"""Sync download/process pipeline orchestration."""

from pathlib import Path
from typing import Any

import typer

from src.domains.sync.helpers import load_json
from src.domains.sync.helpers import write_json
from src.workflows.download_workflow import download
from src.workflows.process_workflow import run_process


def run_sync_pipeline(
    data_dir: Path,
    years: list[int],
    scope: str,
    skip_download: bool = False,
) -> None:
    year_list = sorted(set(years))
    run_catalog = scope in {"catalog", "all"}
    run_offering = scope in {"offering", "all"}

    def has_offering_prerequisites() -> bool:
        required_paths = [
            data_dir / "campus" / "data.json",
            data_dir / "academic_unit" / "data.json",
            data_dir / "academic_term" / "data.json",
            data_dir / "course" / "data.json",
        ]
        return all(path.exists() for path in required_paths)

    def has_terms_for_years(target_years: list[int]) -> bool:
        term_path = data_dir / "academic_term" / "data.json"
        if not term_path.exists():
            return False
        terms = load_json(term_path)
        available = {int(term.get("year", 0)) for term in terms}
        return set(target_years).issubset(available)

    def download_or_raise(**kwargs: Any) -> None:
        if not download(**kwargs):
            raise RuntimeError("Download phase failed")

    def prepare_catalog_prerequisites() -> None:
        download_or_raise(
            output_dir=data_dir,
            scope="catalog",
            include_catalog_core=True,
            include_catalog_study_plan=False,
        )
        run_process(
            data_dir=data_dir,
            scope="catalog",
            years=year_list,
            include_catalog_study_plan=False,
        )

    def prepare_catalog_full() -> None:
        prepare_catalog_prerequisites()
        download_or_raise(
            output_dir=data_dir,
            scope="catalog",
            include_catalog_core=False,
            include_catalog_study_plan=True,
        )
        run_process(data_dir=data_dir, scope="catalog", years=year_list)

    if run_catalog:
        if skip_download:
            run_process(data_dir=data_dir, scope="catalog", years=year_list)
        else:
            prepare_catalog_full()

    if not run_offering:
        return

    if not has_offering_prerequisites() or not has_terms_for_years(year_list):
        if skip_download:
            raise RuntimeError(
                "Offering scope requires catalog prerequisites (campus, academic_unit, academic_term, course) "
                "for requested years in data/raw; rerun without --skip-download."
            )
        typer.echo("Preparing missing catalog prerequisites for offering scope...")
        prepare_catalog_full()

    merged_offerings: dict[tuple[int, int, int, int], dict[str, Any]] = {}
    merged_groups: dict[tuple[int, str], dict[str, Any]] = {}
    merged_group_professors: dict[tuple[int, int], dict[str, Any]] = {}
    merged_meetings: dict[tuple[int, int, str, str], dict[str, Any]] = {}
    merged_professors: dict[str, dict[str, Any]] = {}

    for year in year_list:
        year_str = str(year)
        if not skip_download:
            download_or_raise(output_dir=data_dir, scope="offering", years=[year_str])
        run_process(data_dir=data_dir, scope="offering", years=[year])

        offerings = load_json(data_dir / "course_offering" / "data.json")
        groups = load_json(data_dir / "course_offering_group" / "data.json")
        group_professors = load_json(
            data_dir / "course_offering_group_professor" / "data.json"
        )
        meetings = load_json(data_dir / "course_offering_meeting" / "data.json")
        professors = load_json(data_dir / "professor" / "data.json")

        merged_offerings.update(
            {
                (
                    int(r["course_id"]),
                    int(r["campus_id"]),
                    int(r["academic_unit_id"]),
                    int(r["academic_term_id"]),
                ): r
                for r in offerings
            }
        )
        merged_groups.update(
            {(int(r["course_offering_id"]), str(r["group_code"])): r for r in groups}
        )
        merged_group_professors.update(
            {
                (int(r["course_offering_group_id"]), int(r["professor_id"])): r
                for r in group_professors
            }
        )
        merged_meetings.update(
            {
                (
                    int(r["course_offering_group_id"]),
                    int(r["weekday"]),
                    str(r["starts_at"]),
                    str(r["ends_at"]),
                ): r
                for r in meetings
            }
        )
        merged_professors.update({str(r["full_name"]): r for r in professors})

    write_json(
        data_dir / "course_offering" / "data.json", list(merged_offerings.values())
    )
    write_json(
        data_dir / "course_offering_group" / "data.json", list(merged_groups.values())
    )
    write_json(
        data_dir / "course_offering_group_professor" / "data.json",
        list(merged_group_professors.values()),
    )
    write_json(
        data_dir / "course_offering_meeting" / "data.json",
        list(merged_meetings.values()),
    )
    write_json(data_dir / "professor" / "data.json", list(merged_professors.values()))
