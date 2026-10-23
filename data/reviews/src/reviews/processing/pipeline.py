from __future__ import annotations

import argparse
import json
import os
import shutil
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from .courses import (
    DEFAULT_MODEL,
    add_class_token_variations_for_match,
    add_comment_alias_variations_for_match,
    add_course_variations_for_match,
    deterministic_course_match,
    format_course_output,
    get_course_match,
    is_course_confidence_accepted,
    split_primary_and_related_course_matches,
)
from reviews.console import progress_iter
from reviews.db import get_existing_import_keys, load_all_courses, load_course_decisions, load_course_family_decisions, load_course_prefix_affinity, load_course_variations, load_env_file, load_professor_courses, save_json
from .normalizers import (
    is_pending_review_comment,
    normalize_attendance,
    normalize_comment,
    normalize_grade,
    normalize_score,
    normalize_tags,
    parse_review_date,
)
from reviews.paths import (
    COURSE_DECISIONS_PATH,
    COURSE_FAMILY_DECISIONS_PATH,
    COURSE_VARIATIONS_PATH,
    PROCESSED_PROFESSORS_ROOT,
    PROCESSED_REPORTS_ROOT,
    RAW_PROFESSORS_ROOT,
    ROOT,
    SEED_REVIEWS_ROOT,
)
from .reports import collect_reports
from .sql_export import write_professor_sql


def process_review(*, review: dict[str, Any], course_match: dict[str, Any], min_course_confidence: str, counters: Counter[str]) -> dict[str, Any]:
    notes: list[str] = []
    primary_course_match, course_matches = split_primary_and_related_course_matches(course_match)

    created_at, date_note = parse_review_date(review.get("date"))
    if date_note is not None:
        notes.append(date_note)
        counters[date_note] += 1

    comment, comment_note = normalize_comment(review.get("comment"))
    if comment_note is not None:
        notes.append(comment_note)
        counters[comment_note] += 1

    attendance_required, attendance_note = normalize_attendance(review.get("attendance"))
    if attendance_note is not None:
        notes.append(attendance_note)
        counters[attendance_note] += 1

    grade_received, grade_note = normalize_grade(review.get("received_grade"))
    if grade_note is not None:
        notes.append(grade_note)
        counters[grade_note] += 1

    tags, unmapped_tags = normalize_tags(review.get("tags"))
    if unmapped_tags:
        notes.append("unmapped_tags")
        counters["unmapped_tags"] += len(unmapped_tags)

    ease_score = normalize_score(review.get("ease_score"))
    quality_score = normalize_score(review.get("quality_score"))
    if ease_score is None:
        notes.append("invalid_ease_score")
        counters["invalid_ease_score"] += 1
    if quality_score is None:
        notes.append("invalid_quality_score")
        counters["invalid_quality_score"] += 1

    accepted_course_matches = [match for match in course_matches if is_course_confidence_accepted(match, min_course_confidence)]
    if not course_matches:
        notes.append("course_unmatched")
        counters["course_unmatched_reviews"] += 1
    elif not accepted_course_matches:
        notes.append("course_match_below_confidence_threshold")
        counters["course_match_below_confidence_threshold"] += 1
    elif primary_course_match.get("course_id") is None:
        notes.append("multiple_courses_without_primary")
        counters["reviews_with_multiple_courses_without_primary"] += 1
    if any(match.get("requires_offering_backfill") for match in course_matches):
        notes.append("requires_offering_backfill")
        counters["reviews_requiring_offering_backfill"] += 1
    if len(course_matches) > 1:
        notes.append("multiple_course_matches")
        counters["reviews_with_multiple_course_matches"] += 1

    is_ready = created_at is not None and bool(accepted_course_matches) and ease_score is not None and quality_score is not None
    counters["ready_reviews" if is_ready else "incomplete_reviews"] += 1

    return {
        "created_at": created_at,
        "courses": [format_course_output(match) for match in course_matches],
        "comment": comment,
        "quality_score": quality_score,
        "ease_score": ease_score,
        "clarity_score": None,
        "fairness_score": None,
        "attendance_required": attendance_required,
        "grade_received": grade_received,
        "raw_received_grade": review.get("received_grade"),
        "engagement_level": None,
        "tags": tags,
        "processing_status": "ready" if is_ready else "incomplete",
        "processing_notes": notes,
    }


def process_file(
    *,
    path: Path,
    courses_by_professor: dict[int, list[dict[str, Any]]],
    course_prefix_affinity: dict[int, Counter[str]],
    all_courses: list[dict[str, Any]],
    decisions: dict[str, dict[str, Any]],
    api_key: str | None,
    model: str,
    use_openrouter: bool,
    max_openrouter_calls: int | None,
    variations: dict[str, dict[str, Any]],
    family_decisions: dict[str, dict[str, Any]],
    min_course_confidence: str,
    counters: Counter[str],
) -> dict[str, Any]:
    data = json.loads(path.read_text())
    professor_id = int(data["professor_id"])
    processed_reviews: list[dict[str, Any]] = []
    for review in data.get("reviews") or []:
        if not isinstance(review, dict):
            continue
        if is_pending_review_comment(review.get("comment")):
            counters["ignored_pending_review_comments"] += 1
            continue
        counters["raw_reviews"] += 1
        course_match = get_course_match(
            professor_id=professor_id,
            review=review,
            courses_by_professor=courses_by_professor,
            course_prefix_affinity=course_prefix_affinity,
            all_courses=all_courses,
            decisions=decisions,
            api_key=api_key,
            model=model,
            use_openrouter=use_openrouter,
            max_openrouter_calls=max_openrouter_calls,
            variations=variations,
            family_decisions=family_decisions,
            counters=counters,
        )
        processed_reviews.append(process_review(review=review, course_match=course_match, min_course_confidence=min_course_confidence, counters=counters))

    output = dict(data)
    output["processed_at"] = datetime.now(timezone.utc).isoformat()
    output["reviews"] = processed_reviews
    output["processing_summary"] = {
        "ready_reviews": sum(1 for review in processed_reviews if review["processing_status"] == "ready"),
        "incomplete_reviews": sum(1 for review in processed_reviews if review["processing_status"] != "ready"),
    }
    return output


def select_raw_files(*, professor_ids: list[int] | None, limit_professors: int | None, professor_offset: int, limit_files: int | None, limit_pages_per_professor: int | None, only_changed: bool = False) -> list[Path]:
    all_files = sorted(
        RAW_PROFESSORS_ROOT.glob("*/*/pages/page-*.json"),
        key=lambda path: (int(path.relative_to(RAW_PROFESSORS_ROOT).parts[0]), path.relative_to(RAW_PROFESSORS_ROOT).parts[1], path.name),
    )
    files_by_professor: dict[int, list[Path]] = defaultdict(list)
    for path in all_files:
        files_by_professor[int(path.relative_to(RAW_PROFESSORS_ROOT).parts[0])].append(path)

    selected_professors = sorted(files_by_professor)
    if professor_ids:
        requested = set(professor_ids)
        selected_professors = [professor_id for professor_id in selected_professors if professor_id in requested]
    if professor_offset:
        selected_professors = selected_professors[max(professor_offset, 0) :]
    if limit_professors is not None:
        selected_professors = selected_professors[: max(limit_professors, 0)]

    selected_files: list[Path] = []
    for professor_id in selected_professors:
        professor_files = files_by_professor[professor_id]
        if limit_pages_per_professor is not None:
            professor_files = professor_files[: max(limit_pages_per_professor, 0)]
        selected_files.extend(professor_files)

    if only_changed:
        selected_files = [path for path in selected_files if is_page_stale(path)]

    if limit_files is not None:
        selected_files = selected_files[: max(limit_files, 0)]
    return selected_files


def is_page_stale(raw_path: Path) -> bool:
    """True when the raw page has not been processed or changed since then."""
    relative = raw_path.relative_to(RAW_PROFESSORS_ROOT)
    processed_path = PROCESSED_PROFESSORS_ROOT / relative
    if not processed_path.exists():
        return True
    try:
        return raw_path.stat().st_mtime_ns > processed_path.stat().st_mtime_ns
    except OSError:
        return True


def load_processed_pages_for_professor(professor_id: int) -> list[dict[str, Any]]:
    """Load every processed page for a professor, in a stable order."""
    professor_root = PROCESSED_PROFESSORS_ROOT / str(professor_id)
    if not professor_root.exists():
        return []
    pages: list[dict[str, Any]] = []
    for path in sorted(professor_root.glob("*/pages/page-*.json")):
        try:
            pages.append(json.loads(path.read_text()))
        except (json.JSONDecodeError, OSError):
            continue
    return pages


def remove_professors_from_course_variations(variations: dict[str, dict[str, Any]], professor_ids: set[int]) -> dict[str, dict[str, Any]]:
    filtered: dict[str, dict[str, Any]] = {}
    for course_id, entry in variations.items():
        raw_variations = entry.get("variations")
        if not isinstance(raw_variations, dict):
            filtered[course_id] = entry
            continue
        kept_variations: dict[str, Any] = {}
        for variation_name, variation in raw_variations.items():
            if not isinstance(variation, dict):
                kept_variations[variation_name] = variation
                continue
            remaining_professor_ids = [professor_id for professor_id in variation.get("professor_ids", []) if professor_id not in professor_ids]
            if not remaining_professor_ids:
                continue
            kept_variation = dict(variation)
            kept_variation["professor_ids"] = remaining_professor_ids
            kept_variations[variation_name] = kept_variation
        if kept_variations:
            kept_entry = dict(entry)
            kept_entry["variations"] = kept_variations
            filtered[course_id] = kept_entry
    return filtered


def prime_course_variations(raw_files: list[Path], all_courses: list[dict[str, Any]], variations: dict[str, dict[str, Any]], counters: Counter[str]) -> None:
    for _, raw_path in progress_iter(raw_files, total=len(raw_files), label="Priming pages"):
        data = json.loads(raw_path.read_text())
        professor_id = int(data["professor_id"])
        for review in data.get("reviews") or []:
            if not isinstance(review, dict) or is_pending_review_comment(review.get("comment")):
                continue
            decision = deterministic_course_match(
                review.get("class_name"),
                all_courses,
                match_scope="global_catalog",
                requires_offering_backfill=True,
                allow_ambiguous=False,
            )
            if decision is None or decision.get("course_id") is None or decision.get("confidence") != "high":
                continue
            add_course_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decision)
            add_class_token_variations_for_match(variations, professor_id=professor_id, class_name=review.get("class_name"), decision=decision)
            add_comment_alias_variations_for_match(variations, professor_id=professor_id, review=review, decision=decision)
            counters["primed_course_variations"] += 1


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Process raw MisProfesores reviews into normalized JSON files.")
    parser.add_argument("--model", default=DEFAULT_MODEL, help="OpenRouter model for ambiguous course matching.")
    parser.add_argument("--no-openrouter", action="store_true", help="Disable OpenRouter and only use deterministic matching.")
    parser.add_argument("--limit-files", type=int, default=None, help="Process only the first N raw page files.")
    parser.add_argument("--limit-professors", type=int, default=None, help="Process only the first N professors by raw folder order.")
    parser.add_argument("--professor-offset", type=int, default=0, help="Skip the first N professors by raw folder order.")
    parser.add_argument("--limit-pages-per-professor", type=int, default=None, help="Process only the first N raw page files per selected professor.")
    parser.add_argument("--professor-id", action="append", type=int, default=None, help="Process a specific professor id. Can be passed multiple times.")
    parser.add_argument("--max-openrouter-calls", type=int, default=None, help="Stop calling OpenRouter after N ambiguous course decisions.")
    parser.add_argument("--min-course-confidence", choices=["high", "medium", "low"], default="high", help="Minimum course match confidence required for a review to be marked ready.")
    parser.add_argument("--reset-course-cache", action="store_true", help="Ignore existing data/state/courses/decisions.json.")
    parser.add_argument("--reset-variation-cache", action="store_true", help="Ignore existing data/state/courses/variations.json.")
    parser.add_argument("--clean-output", action="store_true", help="Remove data/processed/professors and data/processed/reports before writing this run.")
    parser.add_argument("--write-sql", action="store_true", help="Write idempotent SQL files under data/seeds/reviews/seed_YYYYMMDDTHHMMSSZ_{professor_id}.sql.")
    parser.add_argument("--only-changed", action="store_true", help="Process only raw pages newer than their processed output (incremental runs).")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    load_env_file(ROOT / ".env")
    api_key = os.getenv("OPENROUTER_API_KEY")
    use_openrouter = not args.no_openrouter
    if use_openrouter and not api_key:
        print("OPENROUTER_API_KEY is missing; ambiguous course matches will be marked unmatched.")

    if args.clean_output:
        shutil.rmtree(PROCESSED_PROFESSORS_ROOT, ignore_errors=True)
        shutil.rmtree(PROCESSED_REPORTS_ROOT, ignore_errors=True)

    courses_by_professor = load_professor_courses()
    course_prefix_affinity = load_course_prefix_affinity(courses_by_professor)
    all_courses = load_all_courses()
    decisions = load_course_decisions()
    if args.reset_course_cache:
        if args.professor_id:
            prefixes = tuple(f"{professor_id}:" for professor_id in args.professor_id)
            decisions = {key: value for key, value in decisions.items() if not key.startswith(prefixes)}
        else:
            decisions = {}
    variations = load_course_variations()
    if args.reset_variation_cache:
        if args.professor_id:
            variations = remove_professors_from_course_variations(variations, set(args.professor_id))
        else:
            variations = {}
    family_decisions = load_course_family_decisions()
    if args.reset_course_cache:
        if args.professor_id:
            prefixes = tuple(f"{professor_id}:" for professor_id in args.professor_id)
            family_decisions = {key: value for key, value in family_decisions.items() if not key.startswith(prefixes)}
        else:
            family_decisions = {}
    counters: Counter[str] = Counter()

    raw_files = select_raw_files(
        professor_ids=args.professor_id,
        limit_professors=args.limit_professors,
        professor_offset=args.professor_offset,
        limit_files=args.limit_files,
        limit_pages_per_professor=args.limit_pages_per_professor,
        only_changed=args.only_changed,
    )
    print(f"Raw files selected: {len(raw_files):,}")
    print("Priming course variations")
    prime_course_variations(raw_files, all_courses, variations, counters)

    processed_files: list[Path] = []
    processed_page_data_by_professor: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for _, raw_path in progress_iter(raw_files, total=len(raw_files), label="Processing pages"):
        counters["raw_files"] += 1
        output = process_file(
            path=raw_path,
            courses_by_professor=courses_by_professor,
            course_prefix_affinity=course_prefix_affinity,
            all_courses=all_courses,
            decisions=decisions,
            api_key=api_key,
            model=args.model,
            use_openrouter=use_openrouter,
            max_openrouter_calls=args.max_openrouter_calls,
            variations=variations,
            family_decisions=family_decisions,
            min_course_confidence=args.min_course_confidence,
            counters=counters,
        )
        relative = raw_path.relative_to(RAW_PROFESSORS_ROOT)
        output_path = PROCESSED_PROFESSORS_ROOT / relative
        save_json(output_path, output)
        processed_files.append(output_path)
        processed_page_data_by_professor[int(output["professor_id"])].append(output)

    sql_review_count = 0
    if args.write_sql:
        professor_items = sorted(processed_page_data_by_professor.items())
        timestamp_str = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        sql_dir = SEED_REVIEWS_ROOT
        sql_dir.mkdir(parents=True, exist_ok=True)
        for _, item in progress_iter(professor_items, total=len(professor_items), label="Writing SQL"):
            professor_id, changed_page_data = item
            # With --only-changed the run may hold a subset of pages. Read every
            # processed page for the professor so the seed stays complete; the
            # import_key filter still prevents duplicate rows.
            page_data = load_processed_pages_for_professor(professor_id) or changed_page_data
            try:
                existing_keys = get_existing_import_keys(professor_id)
            except Exception as e:
                print(f"Warning: Could not fetch existing keys for {professor_id}: {e}")
                existing_keys = set()
            sql_path = sql_dir / f"seed_{timestamp_str}_{professor_id}.sql"
            count = write_professor_sql(professor_id, page_data, sql_path, existing_keys)
            sql_review_count += count
            if count == 0:
                sql_path.unlink(missing_ok=True)
        counters["sql_ready_reviews"] = sql_review_count

    save_json(COURSE_DECISIONS_PATH, decisions)
    save_json(COURSE_VARIATIONS_PATH, variations)
    save_json(COURSE_FAMILY_DECISIONS_PATH, family_decisions)
    reports = collect_reports(processed_files)
    summary = {
        "processed_at": datetime.now(timezone.utc).isoformat(),
        "model": args.model,
        "openrouter_enabled": use_openrouter,
        "counters": dict(counters),
        "processed_files": len(processed_files),
        "course_decisions": len(decisions),
        "course_variations": len(variations),
        "course_family_decisions": len(family_decisions),
        "sql_ready_reviews": sql_review_count if args.write_sql else None,
        "limits": {
            "professor_ids": args.professor_id,
            "limit_professors": args.limit_professors,
            "professor_offset": args.professor_offset,
            "limit_files": args.limit_files,
            "limit_pages_per_professor": args.limit_pages_per_professor,
            "max_openrouter_calls": args.max_openrouter_calls,
            "min_course_confidence": args.min_course_confidence,
            "only_changed": args.only_changed,
        },
    }
    save_json(PROCESSED_REPORTS_ROOT / "summary.json", summary)
    save_json(PROCESSED_REPORTS_ROOT / "course-match-failures.json", reports["course_match_failures"])
    save_json(PROCESSED_REPORTS_ROOT / "ambiguous-course-reviews.json", reports["ambiguous_course_reviews"])
    save_json(PROCESSED_REPORTS_ROOT / "grade-normalization.json", reports["grade_normalization"])
    save_json(PROCESSED_REPORTS_ROOT / "tag-mapping.json", reports["tag_counts"])
    save_json(PROCESSED_REPORTS_ROOT / "incomplete-reviews.json", reports["incomplete_reviews"])
    save_json(PROCESSED_REPORTS_ROOT / "offering-backfill.json", reports["offering_backfill_reviews"])
    save_json(PROCESSED_REPORTS_ROOT / "multiple-course-reviews.json", reports["multiple_course_reviews"])

    from rich.table import Table
    from rich.box import ROUNDED
    from reviews.console import console, success
    
    table = Table(box=ROUNDED)
    table.add_column("Files")
    table.add_column("Raw")
    table.add_column("Ready")
    table.add_column("Incomplete")
    table.add_column("SQL")
    table.add_column("Course Decisions")
    table.add_column("Variation Groups")
    
    table.add_row(
        str(len(processed_files)),
        str(counters["raw_reviews"]),
        str(counters["ready_reviews"]),
        str(counters["incomplete_reviews"]),
        str(sql_review_count) if args.write_sql else "-",
        str(len(decisions)),
        str(len(variations)),
    )
    console.print()
    console.print(table)
    console.print()
    
    home_dir = Path.home()
    try:
        if PROCESSED_PROFESSORS_ROOT.is_relative_to(home_dir):
            saved_path = f"~/{PROCESSED_PROFESSORS_ROOT.relative_to(home_dir)}"
        else:
            saved_path = str(PROCESSED_PROFESSORS_ROOT)
    except ValueError:
        saved_path = str(PROCESSED_PROFESSORS_ROOT)
        
    success(f"Saved under: {saved_path}")


if __name__ == "__main__":
    main()
