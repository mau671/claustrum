from __future__ import annotations

import argparse
import json
import re
import sys
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import requests
import urllib3

from reviews.console import (
    console,
    info,
    step,
    success,
    title,
    warning,
)
from reviews.db import load_professor_courses, save_json
from reviews.models import DbProfessor, MatchEntry, SiteProfessor
from reviews.paths import (
    PROFESSORS_OUTPUT,
    RAW_CANDIDATES_ROOT,
    RAW_PROFESSORS_ROOT,
    SCHOOL_SNAPSHOT_PATH,
    SEED_REVIEWS_ROOT,
    UNMATCHED_OUTPUT,
)
from reviews.processing.pipeline import main as process_main
from reviews.professors.discovery import (
    SCHOOL_URL,
    fix_url_fragment,
    parse_cell_name,
    source_id_from_url,
)
from reviews.professors.matching import (
    load_db_professors,
    load_manual_matches,
    match_site_professor,
)
from reviews.reconcile import reconcile_matching_state
from reviews.reviews.downloader import (
    download_profile,
    load_download_index,
    load_json_list,
    load_match_files,
    save_download_index,
)
from reviews.reviews.parser import extract_reviews
from reviews.text import normalize_name


def load_school_snapshot() -> dict[str, Any] | None:
    if not SCHOOL_SNAPSHOT_PATH.exists():
        return None
    try:
        return json.loads(SCHOOL_SNAPSHOT_PATH.read_text(encoding="utf-8"))
    except Exception:
        return None


def save_school_snapshot(snapshot: dict[str, Any]) -> None:
    SCHOOL_SNAPSHOT_PATH.parent.mkdir(parents=True, exist_ok=True)
    SCHOOL_SNAPSHOT_PATH.write_text(
        json.dumps(snapshot, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def fetch_school_dataset() -> list[dict[str, Any]]:
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    session = requests.Session()
    session.verify = False
    response = session.get(SCHOOL_URL, timeout=30)
    response.raise_for_status()

    match = re.search(r"var\s+dataSet\s*=\s*(\[.*?\]);", response.text, re.DOTALL)
    if not match:
        raise ValueError(f"Could not extract dataSet from {SCHOOL_URL}")
    return json.loads(match.group(1))


def build_current_snapshot(school_rows: list[dict[str, Any]]) -> dict[str, Any]:
    professors_map: dict[str, dict[str, Any]] = {}
    total_reviews = 0

    for row in school_rows:
        source_id = str(row.get("i", "")).strip()
        if not source_id:
            continue
        surname = str(row.get("a", "")).strip()
        given_name = str(row.get("n", "")).strip()
        display_name = parse_cell_name(f"{surname}, {given_name}")
        review_count = int(row.get("m") or 0)
        score = str(row.get("c") or "")
        department = str(row.get("d", "")).strip()

        total_reviews += review_count
        professors_map[source_id] = {
            "review_count": review_count,
            "score": score,
            "display_name": display_name,
            "department": department,
        }

    return {
        "version": 1,
        "last_synced_at": datetime.now(timezone.utc).isoformat(),
        "school_url": SCHOOL_URL,
        "total_professors": len(professors_map),
        "total_reviews": total_reviews,
        "professors": professors_map,
    }


def detect_deltas(
    school_rows: list[dict[str, Any]],
    matches: list[MatchEntry],
    download_index: dict[str, Any],
    previous_snapshot: dict[str, Any] | None,
    quiet: bool = False,
) -> dict[str, Any]:
    matches_by_source: dict[str, MatchEntry] = {
        m.source_professor_id: m for m in matches
    }
    school_by_source: dict[str, dict[str, Any]] = {
        str(r.get("i", "")): r for r in school_rows if r.get("i")
    }

    matched_deltas: list[dict[str, Any]] = []
    unmatched_deltas: list[dict[str, Any]] = []
    new_profiles: list[dict[str, Any]] = []

    if previous_snapshot is not None:
        prev_professors = previous_snapshot.get("professors", {})
        for source_id, row in school_by_source.items():
            current_count = int(row.get("m") or 0)
            prev_data = prev_professors.get(source_id)

            if prev_data is None:
                # Brand new profile on MisProfesores
                surname = str(row.get("a", "")).strip()
                given_name = str(row.get("n", "")).strip()
                new_profiles.append({
                    "source_professor_id": source_id,
                    "display_name": parse_cell_name(f"{surname}, {given_name}"),
                    "review_count": current_count,
                    "department": str(row.get("d", "")).strip(),
                })
                continue

            prev_count = int(prev_data.get("review_count") or 0)
            delta = current_count - prev_count
            if delta > 0:
                match = matches_by_source.get(source_id)
                if match is not None:
                    matched_deltas.append({
                        "match": match,
                        "source_professor_id": source_id,
                        "professor_id": match.professor_id,
                        "prev_count": prev_count,
                        "current_count": current_count,
                        "delta": delta,
                        "site_name": match.site_name or match.db_full_name,
                    })
                else:
                    surname = str(row.get("a", "")).strip()
                    given_name = str(row.get("n", "")).strip()
                    unmatched_deltas.append({
                        "source_professor_id": source_id,
                        "display_name": parse_cell_name(f"{surname}, {given_name}"),
                        "department": str(row.get("d", "")).strip(),
                        "prev_count": prev_count,
                        "current_count": current_count,
                        "delta": delta,
                    })
    else:
        # Bootstrap pass: check profiles already in download_index with site_count > known_count
        profiles_index = download_index.get("profiles", {})
        candidates: list[tuple[str, MatchEntry, int, set[str]]] = []

        for sid, pdata in profiles_index.items():
            site_row = school_by_source.get(sid)
            if not site_row:
                continue
            site_count = int(site_row.get("m") or 0)
            known_ids = set(pdata.get("known_review_ids") or [])
            if site_count > len(known_ids) and sid in matches_by_source:
                candidates.append((sid, matches_by_source[sid], site_count, known_ids))

        if not quiet:
            info(f"Bootstrap snapshot: comprobando {len(candidates)} perfiles con posibles reseñas nuevas...")

        def check_candidate(item: tuple[str, MatchEntry, int, set[str]]) -> dict[str, Any] | None:
            sid, match, site_count, known_ids = item
            urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
            session = requests.Session()
            session.verify = False
            try:
                resp = session.get(match.source_url, timeout=20)
                page_reviews = extract_reviews(resp.text)
                page_new_ids = [
                    r["source_review_id"]
                    for r in page_reviews
                    if r.get("source_review_id") and r["source_review_id"] not in known_ids
                ]
                if page_new_ids:
                    return {
                        "match": match,
                        "source_professor_id": sid,
                        "professor_id": match.professor_id,
                        "prev_count": len(known_ids),
                        "current_count": site_count,
                        "delta": len(page_new_ids),
                        "site_name": match.site_name or match.db_full_name,
                        "sample_new_id": page_new_ids[0],
                    }
            except Exception as err:
                warning(f"Could not check page 1 for {sid}: {err}")
            return None

        with ThreadPoolExecutor(max_workers=8) as executor:
            for item_result in executor.map(check_candidate, candidates):
                if item_result is not None:
                    matched_deltas.append(item_result)

    return {
        "matched_deltas": matched_deltas,
        "unmatched_deltas": unmatched_deltas,
        "new_profiles": new_profiles,
    }


def attempt_unmatched_auto_match(
    item: dict[str, Any],
    download_index: dict[str, Any],
    db_professors: list[DbProfessor],
    db_by_id: dict[int, DbProfessor],
    courses_by_professor: dict[int, list[dict[str, Any]]],
    manual_matches: dict[str, dict[str, Any]],
    fetched_at: str,
    dry_run: bool = False,
) -> tuple[MatchEntry, dict[str, Any]] | None:
    source_id = str(item["source_professor_id"])
    display_name = str(item.get("display_name") or "")
    url = str(item.get("misprofesores_url") or "")
    if not url:
        parts = display_name.split()
        first_part = parts[0] if parts else "profesor"
        last_part = parts[1] if len(parts) > 1 else ""
        url = f"https://costarica.misprofesores.com/profesores/{fix_url_fragment(first_part)}-{fix_url_fragment(last_part)}_{source_id}"

    candidate_reviews: list[dict[str, Any]] = []

    if dry_run:
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        session = requests.Session()
        session.verify = False
        try:
            resp = session.get(url, timeout=20)
            candidate_reviews = extract_reviews(resp.text)
        except Exception:
            candidate_reviews = []
    else:
        candidate_entry = MatchEntry(
            professor_id=0,
            source_professor_id=source_id,
            source_url=url,
            site_name=display_name,
            db_full_name="",
            is_manual=False,
            reason="candidate_evidence",
        )
        download_profile(
            candidate_entry,
            output_root=RAW_CANDIDATES_ROOT,
            index=download_index,
            fetched_at=fetched_at,
            max_pages=2,
            show_progress=False,
        )
        candidate_dir = RAW_CANDIDATES_ROOT / source_id / "pages"
        if candidate_dir.exists():
            for page_file in sorted(candidate_dir.glob("page-*.json")):
                try:
                    page_data = json.loads(page_file.read_text(encoding="utf-8"))
                    for rev in page_data.get("reviews") or []:
                        if isinstance(rev, dict):
                            candidate_reviews.append(rev)
                except Exception:
                    continue

    if not candidate_reviews:
        return None

    site_prof = SiteProfessor(
        display_name=display_name,
        normalized_name=normalize_name(display_name),
        url=url,
        department=str(item.get("department") or ""),
        source_professor_id=source_id,
    )

    matched, _details = match_site_professor(
        site_prof,
        db_professors=db_professors,
        db_by_id=db_by_id,
        courses_by_professor=courses_by_professor,
        reviews_by_source={source_id: candidate_reviews},
        manual_matches=manual_matches,
    )

    valid_reasons = (
        "strong_course_evidence",
        "course_evidence_override",
        "strong_name",
        "probable_name",
    )

    if matched is not None and matched.get("match_reason") in valid_reasons:
        matched_professor_id = int(matched["professor_id"])
        new_match_entry = MatchEntry(
            professor_id=matched_professor_id,
            source_professor_id=source_id,
            source_url=url,
            site_name=display_name,
            db_full_name=str(matched["db_full_name"]),
            is_manual=False,
            reason=str(matched["match_reason"]),
        )
        return new_match_entry, matched

    return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Daily incremental synchronization of new MisProfesores reviews."
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Detect new reviews and print preview without downloading or writing files.",
    )
    parser.add_argument(
        "--write-sql",
        action="store_true",
        default=True,
        help="Generate SQL seed files for newly detected reviews (default: True).",
    )
    parser.add_argument(
        "--no-sql",
        dest="write_sql",
        action="store_false",
        help="Do not write SQL seed files.",
    )
    parser.add_argument(
        "--no-openrouter",
        action="store_true",
        help="Disable OpenRouter LLM and use only deterministic course matching.",
    )
    parser.add_argument(
        "--min-course-confidence",
        choices=["high", "medium", "low"],
        default="high",
        help="Minimum confidence threshold for course matching (default: high).",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output final result as JSON to stdout for programmatic callers.",
    )
    return parser.parse_args()


def run_daily_sync(args: argparse.Namespace) -> dict[str, Any]:
    start_time = datetime.now(timezone.utc)
    fetched_at = datetime.now(timezone.utc).isoformat()

    if not args.json:
        title("MisProfesores Daily Review Sync")
        step(1, 4, "Consultando directorio de ITCR en MisProfesores")

    school_rows = fetch_school_dataset()
    if not args.json:
        success(f"Directorio cargado exitosamente: {len(school_rows):,} profesores registrados.")

    matches = load_match_files()
    download_index = load_download_index()
    previous_snapshot = load_school_snapshot()

    if not args.json:
        step(2, 4, "Calculando deltas y evaluando perfiles sin match")

    deltas = detect_deltas(
        school_rows=school_rows,
        matches=matches,
        download_index=download_index,
        previous_snapshot=previous_snapshot,
        quiet=args.json,
    )

    matched_deltas = deltas["matched_deltas"]
    unmatched_deltas = deltas["unmatched_deltas"]
    new_profiles = deltas["new_profiles"]
    auto_matched_professors: list[dict[str, Any]] = []

    # Auto-rematch pass: if any unmatched profile has new review activity, attempt matching
    if unmatched_deltas:
        if not args.json:
            info(f"Evaluando {len(unmatched_deltas)} perfil(es) sin match con nueva actividad...")
        db_professors = load_db_professors()
        db_by_id = {p.id: p for p in db_professors}
        courses_by_prof = load_professor_courses()
        manual_matches = load_manual_matches()

        for u_item in unmatched_deltas:
            res_match = attempt_unmatched_auto_match(
                item=u_item,
                download_index=download_index,
                db_professors=db_professors,
                db_by_id=db_by_id,
                courses_by_professor=courses_by_prof,
                manual_matches=manual_matches,
                fetched_at=fetched_at,
                dry_run=args.dry_run,
            )
            if res_match:
                new_match_entry, matched_dict = res_match
                source_id = new_match_entry.source_professor_id
                auto_matched_professors.append({
                    "professor_id": new_match_entry.professor_id,
                    "source_id": source_id,
                    "site_name": new_match_entry.site_name,
                    "db_full_name": new_match_entry.db_full_name,
                    "reason": new_match_entry.reason,
                    "delta": u_item["delta"],
                })

                if not args.dry_run:
                    # 1. Update professors.json
                    recognized_data = load_json_list(PROFESSORS_OUTPUT)
                    recognized_data.append(matched_dict)
                    save_json(PROFESSORS_OUTPUT, recognized_data)

                    # 2. Update unmatched.json
                    unmatched_data = [
                        u
                        for u in load_json_list(UNMATCHED_OUTPUT)
                        if source_id_from_url(str(u.get("misprofesores_url") or "")) != source_id
                    ]
                    save_json(UNMATCHED_OUTPUT, unmatched_data)

                    # 3. Reconcile raw dirs
                    reconcile_matching_state()

                    # 4. Update download_index
                    candidate_profiles = download_index.get("candidate_profiles", {})
                    if source_id in candidate_profiles:
                        pdata = candidate_profiles.pop(source_id)
                        pdata["professor_id"] = new_match_entry.professor_id
                        download_index.setdefault("profiles", {})[source_id] = pdata

                matched_deltas.append({
                    "match": new_match_entry,
                    "source_professor_id": source_id,
                    "professor_id": new_match_entry.professor_id,
                    "prev_count": 0,
                    "current_count": u_item["current_count"],
                    "delta": u_item["delta"],
                    "site_name": new_match_entry.site_name,
                })

                if not args.json:
                    success(
                        f"¡Auto-match confirmado! {new_match_entry.site_name} -> "
                        f"[bold green]{new_match_entry.db_full_name}[/bold green] "
                        f"(Razón: {new_match_entry.reason})"
                    )

    if new_profiles and not args.json:
        info(f"Nuevos perfiles descubiertos en MisProfesores: {len(new_profiles)}")
        for np in new_profiles[:5]:
            info(f"   • {np['display_name']} (Depto: {np['department']}, Reviews: {np['review_count']})")

    if not matched_deltas:
        if not args.json:
            success("¡Al día! No se detectaron reseñas nuevas para profesores vinculados.")
        if not args.dry_run:
            new_snapshot = build_current_snapshot(school_rows)
            save_school_snapshot(new_snapshot)
        return {
            "status": "up_to_date",
            "new_reviews_count": 0,
            "affected_professors_count": 0,
            "affected_professors": [],
            "auto_matched_professors": auto_matched_professors,
            "seed_files": [],
            "new_profiles": new_profiles,
            "unmatched_deltas": [
                u for u in unmatched_deltas
                if u["source_professor_id"] not in {m["source_id"] for m in auto_matched_professors}
            ],
        }

    if not args.json:
        info(f"Se encontraron [bold cyan]{len(matched_deltas)}[/bold cyan] perfiles vinculados con reseñas nuevas:")
        for item in matched_deltas:
            info(
                f"   • Prof {item['professor_id']}: [bold]{item['site_name']}[/bold] "
                f"(+{item['delta']} reseña(s), total en sitio: {item['current_count']})"
            )

    if args.dry_run:
        if not args.json:
            console.print()
            warning("[bold yellow]Modo Dry-Run activo.[/bold yellow] No se descargarán ni escribirán archivos.")
        return {
            "status": "dry_run_complete",
            "new_reviews_count": sum(d["delta"] for d in matched_deltas),
            "affected_professors_count": len(matched_deltas),
            "affected_professors": [
                {
                    "professor_id": d["professor_id"],
                    "name": d["site_name"],
                    "source_id": d["source_professor_id"],
                    "delta": d["delta"],
                }
                for d in matched_deltas
            ],
            "auto_matched_professors": auto_matched_professors,
            "seed_files": [],
            "new_profiles": new_profiles,
            "unmatched_deltas": [
                u for u in unmatched_deltas
                if u["source_professor_id"] not in {m["source_id"] for m in auto_matched_professors}
            ],
        }

    # Step 3: Targeted download
    if not args.json:
        step(3, 4, f"Descargando reseñas para {len(matched_deltas)} perfil(es)")

    download_results: list[dict[str, Any]] = []
    unique_professor_ids: set[int] = set()

    for item in matched_deltas:
        match = item["match"]
        res = download_profile(
            match=match,
            output_root=RAW_PROFESSORS_ROOT,
            index=download_index,
            fetched_at=fetched_at,
            show_progress=False,
        )
        download_results.append(res)
        unique_professor_ids.add(match.professor_id)
        if not args.json:
            success(
                f"Descargado perfil {match.source_professor_id} (Prof {match.professor_id}): "
                f"{res['new_reviews']} nuevas reseñas crudas."
            )

    save_download_index(download_index)

    # Step 4: Process and generate SQL
    if not args.json:
        step(4, 4, "Procesando normalización, materias y generando SQL")

    existing_seed_files_before = (
        set(SEED_REVIEWS_ROOT.glob("seed_*.sql")) if SEED_REVIEWS_ROOT.exists() else set()
    )

    process_argv = [
        sys.argv[0],
        "--min-course-confidence",
        args.min_course_confidence,
        "--only-changed",
    ]
    if args.write_sql:
        process_argv.append("--write-sql")
    if args.no_openrouter:
        process_argv.append("--no-openrouter")

    for pid in sorted(unique_professor_ids):
        process_argv.extend(["--professor-id", str(pid)])

    old_argv = sys.argv
    sys.argv = process_argv
    try:
        process_main()
    finally:
        sys.argv = old_argv

    existing_seed_files_after = (
        set(SEED_REVIEWS_ROOT.glob("seed_*.sql")) if SEED_REVIEWS_ROOT.exists() else set()
    )
    new_seed_files = sorted(
        [str(p) for p in (existing_seed_files_after - existing_seed_files_before)]
    )

    # Save updated snapshot
    new_snapshot = build_current_snapshot(school_rows)
    save_school_snapshot(new_snapshot)

    elapsed = (datetime.now(timezone.utc) - start_time).total_seconds()

    if not args.json:
        console.print()
        if new_seed_files:
            success(f"[bold green]Sincronización completada en {elapsed:.1f}s.[/bold green]")
            info(f"Nuevos archivos SQL generados ({len(new_seed_files)}):")
            for sf in new_seed_files:
                info(f"   • {Path(sf).name}")
        else:
            success(f"Sincronización completada en {elapsed:.1f}s. (No hubo reseñas listas para emitir SQL).")

    return {
        "status": "success",
        "new_reviews_count": sum(r["new_reviews"] for r in download_results),
        "affected_professors_count": len(unique_professor_ids),
        "affected_professors": [
            {
                "professor_id": d["professor_id"],
                "name": d["site_name"],
                "source_id": d["source_professor_id"],
                "delta": d["delta"],
            }
            for d in matched_deltas
        ],
        "auto_matched_professors": auto_matched_professors,
        "seed_files": new_seed_files,
        "new_profiles": new_profiles,
        "unmatched_deltas": [
            u for u in unmatched_deltas
            if u["source_professor_id"] not in {m["source_id"] for m in auto_matched_professors}
        ],
    }


def main() -> None:
    args = parse_args()
    try:
        result = run_daily_sync(args)
        if args.json:
            print(json.dumps(result, indent=2, ensure_ascii=False))
    except Exception as err:
        if args.json:
            print(json.dumps({"status": "error", "message": str(err)}))
        else:
            console.print_exception()
        sys.exit(1)


if __name__ == "__main__":
    main()
