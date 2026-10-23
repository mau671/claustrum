from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import replace
from datetime import datetime, timezone
from pathlib import Path
from threading import local
from typing import Any

import requests

from reviews.console import progress_bar
from reviews.db import save_json
from reviews.models import MatchEntry
from reviews.paths import DOWNLOAD_INDEX_PATH, MANUAL_MATCHES_ROOT, PROFESSORS_OUTPUT, RAW_CANDIDATES_ROOT, RAW_PROFESSORS_ROOT, UNMATCHED_OUTPUT
from reviews.professors.discovery import source_id_from_url
from reviews.reviews.parser import extract_reviews, parse_total_pages

THREAD_STATE = local()


def load_json_list(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text())
    if not isinstance(data, list):
        raise ValueError(f"Expected list in {path}")
    return [item for item in data if isinstance(item, dict)]


def load_match_files(*, include_manual: bool = True) -> list[MatchEntry]:
    matches: list[MatchEntry] = []
    seen_sources: set[str] = set()
    paths = [PROFESSORS_OUTPUT]
    if include_manual:
        paths.extend(sorted(MANUAL_MATCHES_ROOT.glob("*.json")))

    for path in paths:
        if not path.exists():
            continue
        is_manual = path.parent == MANUAL_MATCHES_ROOT
        for item in load_json_list(path):
            url = str(item.get("misprofesores_url", "")).strip()
            professor_id = item.get("professor_id")
            source_professor_id = source_id_from_url(url)
            if not url or professor_id is None or source_professor_id is None:
                continue
            if source_professor_id in seen_sources:
                continue
            seen_sources.add(source_professor_id)
            matches.append(
                MatchEntry(
                    professor_id=int(professor_id),
                    source_professor_id=source_professor_id,
                    source_url=url,
                    site_name=str(item.get("site_name") or ""),
                    db_full_name=str(item.get("db_full_name") or ""),
                    is_manual=is_manual,
                    reason=str(item.get("manual_reason") or item.get("match_reason") or "") or None,
                )
            )
    return matches


def candidate_entry_from_unmatched(item: dict[str, Any]) -> MatchEntry | None:
    url = str(item.get("misprofesores_url", "")).strip()
    source_professor_id = source_id_from_url(url)
    if not url or source_professor_id is None:
        return None
    return MatchEntry(
        professor_id=0,
        source_professor_id=source_professor_id,
        source_url=url,
        site_name=str(item.get("site_name") or ""),
        db_full_name="",
        is_manual=False,
        reason="candidate_evidence",
    )


def load_candidate_entries(limit: int | None = None) -> list[MatchEntry]:
    if not UNMATCHED_OUTPUT.exists():
        return []
    entries: list[MatchEntry] = []
    for item in load_json_list(UNMATCHED_OUTPUT):
        entry = candidate_entry_from_unmatched(item)
        if entry is not None:
            entries.append(entry)
        if limit is not None and len(entries) >= limit:
            break
    return entries


def build_profile_url(source_url: str, page: int) -> str:
    return source_url if page == 1 else f"{source_url}?pag={page}"


def fetch_html(url: str) -> str:
    session = getattr(THREAD_STATE, "session", None)
    if session is None:
        session = requests.Session()
        session.verify = False
        import urllib3
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        THREAD_STATE.session = session
    response = session.get(url, timeout=30)
    response.raise_for_status()
    return response.text


def load_download_index(path: Path = DOWNLOAD_INDEX_PATH) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "profiles": {}, "candidate_profiles": {}}
    data = json.loads(path.read_text())
    if not isinstance(data, dict):
        return {"version": 1, "profiles": {}, "candidate_profiles": {}}
    data.setdefault("version", 1)
    data.setdefault("profiles", {})
    data.setdefault("candidate_profiles", {})
    return data


def save_download_index(index: dict[str, Any], path: Path = DOWNLOAD_INDEX_PATH) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(index, ensure_ascii=True, indent=2, sort_keys=True) + "\n")


def profile_base_dir(*, output_root: Path, match: MatchEntry) -> Path:
    if match.professor_id:
        return output_root / str(match.professor_id) / f"source-{match.source_professor_id}"
    return output_root / match.source_professor_id


def raw_page_paths(base_dir: Path) -> list[Path]:
    return sorted((base_dir / "pages").glob("page-*.json"))


def known_review_ids_from_files(base_dir: Path) -> set[str]:
    known: set[str] = set()
    for path in raw_page_paths(base_dir):
        data = json.loads(path.read_text())
        for review in data.get("reviews") or []:
            if isinstance(review, dict):
                source_review_id = str(review.get("source_review_id") or "")
                if source_review_id:
                    known.add(source_review_id)
    return known


def page_number_from_path(path: Path) -> int:
    match = re.search(r"page-(\d+)\.json$", path.name)
    return int(match.group(1)) if match else 0


def write_page(
    *,
    match: MatchEntry,
    page: int,
    total_pages: int,
    page_html: str,
    output_root: Path,
    fetched_at: str,
) -> tuple[Path, list[str]]:
    page_url = build_profile_url(match.source_url, page)
    page_reviews = extract_reviews(page_html)
    base_dir = profile_base_dir(output_root=output_root, match=match)
    pages_dir = base_dir / "pages"
    pages_dir.mkdir(parents=True, exist_ok=True)
    output_path = pages_dir / f"page-{page:03d}.json"
    if page > 1 and not page_reviews:
        output_path.unlink(missing_ok=True)
        return output_path, []

    review_ids = [
        str(review["source_review_id"])
        for review in page_reviews
        if review.get("source_review_id")
    ]
    reviews_hash = hashlib.sha256(
        json.dumps(page_reviews, sort_keys=True, ensure_ascii=True).encode("utf-8")
    ).hexdigest()

    # Skip the write when the page content did not change. This keeps mtimes
    # stable so the processing step can detect unmodified pages and skip them.
    if output_path.exists():
        try:
            existing = json.loads(output_path.read_text())
        except (json.JSONDecodeError, OSError):
            existing = None
        if (
            isinstance(existing, dict)
            and existing.get("reviews_hash") == reviews_hash
            and existing.get("total_pages") == total_pages
        ):
            return output_path, review_ids

    output_path.write_text(
        json.dumps(
            {
                "source_url": page_url,
                "source_professor_id": match.source_professor_id,
                "professor_id": match.professor_id or None,
                "page": page,
                "total_pages": total_pages,
                "fetched_at": fetched_at,
                "reviews_hash": reviews_hash,
                "reviews": page_reviews,
            },
            ensure_ascii=True,
            indent=2,
        )
        + "\n"
    )
    return output_path, review_ids


def save_profile_index(base_dir: Path, profile_index: dict[str, Any]) -> None:
    save_json(base_dir / "index.json", profile_index)


def download_profile(
    match: MatchEntry,
    *,
    output_root: Path,
    index: dict[str, Any],
    fetched_at: str,
    max_pages: int | None = None,
    refresh_all: bool = False,
    complete_history: bool = False,
    show_progress: bool = False,
) -> dict[str, Any]:
    base_dir = profile_base_dir(output_root=output_root, match=match)
    base_dir.mkdir(parents=True, exist_ok=True)
    source_key = match.source_professor_id
    profiles_key = "candidate_profiles" if match.professor_id == 0 else "profiles"
    profile_index = index[profiles_key].setdefault(source_key, {})
    known_ids = set(profile_index.get("known_review_ids") or []) | known_review_ids_from_files(base_dir)
    existing_pages = {page_number_from_path(path) for path in raw_page_paths(base_dir)}

    downloaded_pages = 0
    new_review_ids: list[str] = []
    total_pages = 1
    page = 1
    stop_reason = "completed"
    while True:
        if max_pages is not None and page > max_pages:
            stop_reason = "max_pages"
            break
        html = fetch_html(build_profile_url(match.source_url, page))
        if page == 1:
            total_pages = parse_total_pages(html)
            if show_progress:
                label = f"Downloading Profile {match.source_professor_id}"
                print(progress_bar(0, total_pages, label=label), end="", flush=True)
        _, page_review_ids = write_page(match=match, page=page, total_pages=total_pages, page_html=html, output_root=output_root, fetched_at=fetched_at)
        downloaded_pages += 1
        if show_progress:
            label = f"Downloading Profile {match.source_professor_id}"
            print("\r" + progress_bar(page, total_pages, label=label), end="", flush=True)

        page_ids = set(page_review_ids)
        if page > 1 and not page_ids:
            stop_reason = "empty_page"
            break
        page_new_ids = sorted(page_ids - known_ids)
        new_review_ids.extend(page_new_ids)
        known_ids.update(page_ids)

        should_complete_history = complete_history and len(existing_pages) < total_pages
        if not refresh_all and not should_complete_history and page > 1 and page_ids and not page_new_ids:
            stop_reason = "known_page_overlap"
            break
        if not refresh_all and not should_complete_history and page == 1 and page_ids and not page_new_ids:
            stop_reason = "page_1_unchanged"
            break
        if page >= total_pages:
            break
        page += 1

    if show_progress:
        print()

    profile_index.update(
        {
            "source_url": match.source_url,
            "professor_id": match.professor_id or None,
            "known_review_ids": sorted(known_ids),
            "latest_review_id": max(known_ids) if known_ids else None,
            "last_total_pages": total_pages,
            "last_fetched_at": fetched_at,
            "last_stop_reason": stop_reason,
        }
    )
    save_profile_index(base_dir, profile_index)
    return {
        "source_professor_id": match.source_professor_id,
        "professor_id": match.professor_id or None,
        "downloaded_pages": downloaded_pages,
        "new_reviews": len(set(new_review_ids)),
        "stop_reason": stop_reason,
        "total_pages": total_pages,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Download MisProfesores reviews idempotently.")
    parser.add_argument("--max-workers", type=int, default=None, help="Maximum concurrent profiles.")
    parser.add_argument("--refresh-all", action="store_true", help="Re-download every page regardless of local review IDs.")
    parser.add_argument("--include-unmatched", action="store_true", help="Download candidate evidence for data/state/matching/unmatched.json.")
    parser.add_argument("--candidate-limit", type=int, default=None, help="Limit unmatched candidate profiles downloaded.")
    parser.add_argument("--candidate-pages", type=int, default=2, help="Maximum pages per unmatched candidate profile.")
    parser.add_argument("--source-id", action="append", default=None, help="Download only a specific MisProfesores source id. Can be repeated.")
    parser.add_argument("--professor-id", action="append", type=int, default=None, help="Download only matches for a specific local professor id. Can be repeated.")
    parser.add_argument("--complete-history", action="store_true", help="If local pages are incomplete, continue past known overlap until all historical pages are saved.")
    parser.add_argument("--quiet", action="store_true", help="Hide per-profile download progress.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    fetched_at = datetime.now(timezone.utc).isoformat()
    matches = load_match_files()
    if args.source_id:
        requested = set(args.source_id)
        matches = [match for match in matches if match.source_professor_id in requested]
    if args.professor_id:
        requested_professors = set(args.professor_id)
        matches = [match for match in matches if match.professor_id in requested_professors]

    index = load_download_index()
    max_workers = args.max_workers or max(4, min(32, (os.cpu_count() or 4) * 4))
    results: list[dict[str, Any]] = []
    show_progress = not args.quiet
    if show_progress:
        print(f"Downloading confirmed profiles: {len(matches):,}")
        for profile_index, match in enumerate(matches, start=1):
            print(f"\nProfile {profile_index:,}/{len(matches):,}: professor {match.professor_id} · source {match.source_professor_id}")
            results.append(
                download_profile(
                    match,
                    output_root=RAW_PROFESSORS_ROOT,
                    index=index,
                    fetched_at=fetched_at,
                    refresh_all=args.refresh_all,
                    complete_history=args.complete_history,
                    show_progress=True,
                )
            )
    else:
        with ThreadPoolExecutor(max_workers=min(max_workers, max(1, len(matches)))) as executor:
            futures = [
                executor.submit(
                    download_profile,
                    match,
                    output_root=RAW_PROFESSORS_ROOT,
                    index=index,
                    fetched_at=fetched_at,
                    refresh_all=args.refresh_all,
                    complete_history=args.complete_history,
                )
                for match in matches
            ]
            for future in as_completed(futures):
                results.append(future.result())

    candidate_results: list[dict[str, Any]] = []
    if args.include_unmatched:
        candidates = load_candidate_entries(args.candidate_limit)
        if args.source_id:
            requested = set(args.source_id)
            candidates = [candidate for candidate in candidates if candidate.source_professor_id in requested]
        if show_progress:
            print(f"\nDownloading candidate profiles: {len(candidates):,}")
            for profile_index, candidate in enumerate(candidates, start=1):
                print(f"\nCandidate {profile_index:,}/{len(candidates):,}: source {candidate.source_professor_id}")
                candidate_results.append(
                    download_profile(
                        replace(candidate, professor_id=0),
                        output_root=RAW_CANDIDATES_ROOT,
                        index={"version": 1, "profiles": {}, "candidate_profiles": index.setdefault("candidate_profiles", {})},
                        fetched_at=fetched_at,
                        max_pages=args.candidate_pages,
                        refresh_all=args.refresh_all,
                        complete_history=args.complete_history,
                        show_progress=True,
                    )
                )
        else:
            with ThreadPoolExecutor(max_workers=min(max_workers, max(1, len(candidates)))) as executor:
                futures = [
                    executor.submit(
                        download_profile,
                        replace(candidate, professor_id=0),
                        output_root=RAW_CANDIDATES_ROOT,
                        index={"version": 1, "profiles": {}, "candidate_profiles": index.setdefault("candidate_profiles", {})},
                        fetched_at=fetched_at,
                        max_pages=args.candidate_pages,
                        refresh_all=args.refresh_all,
                        complete_history=args.complete_history,
                    )
                    for candidate in candidates
                ]
                for future in as_completed(futures):
                    candidate_results.append(future.result())

    save_download_index(index)
    downloaded_pages = sum(int(result["downloaded_pages"]) for result in results)
    candidate_pages = sum(int(result["downloaded_pages"]) for result in candidate_results)
    print()
    print("Download summary")
    print("-" * 80)
    for result in sorted(results, key=lambda item: str(item["source_professor_id"])):
        print(
            f"source {result['source_professor_id']} · professor {result['professor_id']} · "
            f"pages {result['downloaded_pages']}/{result.get('total_pages', '?')} · "
            f"new reviews {result['new_reviews']} · stop {result['stop_reason']}"
        )
    print(f"Downloaded profiles: {len(results)}")
    print(f"Downloaded pages: {downloaded_pages}")
    print(f"New reviews: {sum(int(result['new_reviews']) for result in results)}")
    if args.include_unmatched:
        print(f"Downloaded candidate profiles: {len(candidate_results)}")
        print(f"Downloaded candidate pages: {candidate_pages}")
    print(f"Saved under: {RAW_PROFESSORS_ROOT}")
    print(f"Saved candidates under: {RAW_CANDIDATES_ROOT}")
    print(f"Index: {DOWNLOAD_INDEX_PATH}")


if __name__ == "__main__":
    main()
