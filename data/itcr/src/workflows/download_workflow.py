"""Download command."""

import json
import warnings
from pathlib import Path
from typing import Any

import typer

from src.infra.tec_api.endpoints.academic_period import AcademicPeriodClient
from src.infra.tec_api.endpoints.academic_unit import AcademicUnitClient
from src.infra.tec_api.endpoints.campus import CampusClient
from src.infra.tec_api.endpoints.study_plan import StudyPlanClient
from src.shared.scope import normalize_scope

# Suppress SSL warnings
warnings.filterwarnings("ignore", message="Unverified HTTPS request")


def _progress_prefix(label: str) -> str:
    return f"[{label}]"


def _render_download_progress(current: int, total: int, item: str, status: str) -> None:
    total = max(total, 1)
    print(
        f"\r[{current:03d}/{total:03d}] {item:<24} {status}",
        end="",
        flush=True,
    )


def run_study_plan_download_cli(
    output_dir: Path,
    academic_unit_campus_data: list[dict[str, Any]],
    verify_ssl: bool,
    concurrency: int,
) -> None:
    """Run study plan download with plain CLI progress output."""
    total_combos = len(academic_unit_campus_data)
    typer.echo(
        f"{_progress_prefix('study_plan')} Starting download for {total_combos} campus-unit combinations"
    )

    state = {
        "combo_processed": 0,
        "combo_total": total_combos,
        "plans_found": 0,
        "unique_plans": 0,
        "plans_total": 0,
        "fetched": 0,
        "failed": 0,
    }

    def progress_callback(payload: dict[str, Any]) -> None:
        event = payload.get("event")
        if event == "combination":
            state["combo_processed"] = int(
                payload.get("processed", state["combo_processed"])
            )
            state["combo_total"] = int(payload.get("total", state["combo_total"]))
            state["plans_found"] = int(payload.get("plans_found", state["plans_found"]))
            state["unique_plans"] = int(
                payload.get("unique_plans", state["unique_plans"])
            )
            processed = state["combo_processed"]
            total = max(state["combo_total"], 1)
            pct = (processed / total) * 100
            typer.echo(
                f"{_progress_prefix('study_plan')} combinations {processed}/{state['combo_total']} ({pct:.1f}%) | plans found={state['plans_found']} unique={state['unique_plans']}"
            )
            return

        if event == "plans_total":
            state["plans_total"] = int(payload.get("total", 0))
            typer.echo(
                f"{_progress_prefix('study_plan')} fetching detailed plans: total={state['plans_total']}"
            )
            return

        if event == "plan_detail":
            state["fetched"] = int(payload.get("fetched", state["fetched"]))
            state["failed"] = int(payload.get("failed", state["failed"]))
            total = int(payload.get("total", state["plans_total"]))
            total = max(total, 1)
            done = state["fetched"] + state["failed"]
            pct = (done / total) * 100
            typer.echo(
                f"{_progress_prefix('study_plan')} plan details {done}/{total} ({pct:.1f}%) | fetched={state['fetched']} failed={state['failed']}"
            )
            return

        if event == "no_plans":
            typer.echo(
                f"{_progress_prefix('study_plan')} careers without plans: {payload.get('count', 0)}"
            )
            return

        if event == "errors":
            typer.echo(
                f"{_progress_prefix('study_plan')} fetch errors: {payload.get('count', 0)}"
            )
            return

        if event == "complete":
            files = payload.get("files", {})
            typer.echo(
                f"{_progress_prefix('study_plan')} completed | found={payload.get('plans_found', state['plans_found'])} fetched={payload.get('plans_fetched', state['fetched'])} failed={payload.get('plans_failed', state['failed'])}"
            )
            for name, path in files.items():
                typer.echo(f"{_progress_prefix('study_plan')} saved {name}: {path}")

    client = StudyPlanClient(verify_ssl=verify_ssl)
    try:
        client.download_raw(
            output_dir,
            academic_unit_campus_data,
            max_concurrency=concurrency,
            progress_callback=progress_callback,
        )
    finally:
        client.close()


def download(
    output_dir: Path = Path("data/raw"),
    scope: str = "all",
    verify_ssl: bool = False,
    concurrency: int = 3,
    years: list[str] | None = None,
    include_catalog_core: bool = True,
    include_catalog_study_plan: bool = True,
) -> bool:
    """Download raw data from TEC APIs by scope."""
    scope = normalize_scope(scope)
    run_catalog = scope in {"catalog", "all"}
    run_offering = scope in {"offering", "all"}

    if run_catalog and include_catalog_core:
        typer.echo(f"{_progress_prefix('download')} fetching campus data...")
        client = CampusClient()
        try:
            files = client.download_raw(output_dir)
            for source, path in files.items():
                print(f"Saved campus {source} data to: {path}")
        finally:
            client.close()

    if run_catalog and include_catalog_core:
        typer.echo(f"{_progress_prefix('download')} fetching academic_unit data...")
        # Load campus data to get campus codes
        campus_path = output_dir / "campus" / "data.json"
        if campus_path.exists():
            campuses = json.loads(campus_path.read_text())
            campus_codes = [c["code"] for c in campuses]
        else:
            campus_codes = ["CA", "SJ", "SC", "AL", "LM"]  # Default

        client = AcademicUnitClient(verify_ssl=verify_ssl)
        try:
            files = client.download_raw(output_dir, campus_codes)
            for source, path in files.items():
                print(f"Saved academic_unit {source} data to: {path}")
        finally:
            client.close()

    if run_catalog and include_catalog_core:
        typer.echo(f"{_progress_prefix('download')} fetching academic_period data...")
        client = AcademicPeriodClient(verify_ssl=verify_ssl)
        try:
            files = client.download_raw(output_dir)
            for source, path in files.items():
                print(f"Saved academic_period {source} data to: {path}")
        finally:
            client.close()

    if run_catalog and include_catalog_study_plan:
        typer.echo(
            f"{_progress_prefix('download')} preparing study_plan dependencies..."
        )
        # Load campus data to get campus codes
        campus_path = output_dir / "campus" / "data.json"
        if campus_path.exists():
            campuses = json.loads(campus_path.read_text())
            campus_codes = [c["code"] for c in campuses]
        else:
            campus_codes = ["CA", "SJ", "SC", "AL", "LM"]  # Default

        client = AcademicUnitClient(verify_ssl=verify_ssl)
        try:
            files = client.download_raw(output_dir, campus_codes)
            for source, path in files.items():
                print(f"Saved academic_unit {source} data to: {path}")
        finally:
            client.close()

    if run_catalog and include_catalog_study_plan:
        typer.echo(f"{_progress_prefix('download')} fetching study_plan data...")
        # Load academic_unit_campus data to get valid combinations
        relation_path = output_dir / "academic_unit_campus" / "data.json"
        if not relation_path.exists():
            print(f"Error: academic_unit_campus data not found at {relation_path}")
            print(
                "Please run 'process' command first to generate academic_unit_campus data."
            )
            return False

        relations = json.loads(relation_path.read_text())

        # Build combinations using campus codes and academic unit codes
        # First load campus data to map campus_id -> code
        campus_path = output_dir / "campus" / "data.json"
        if campus_path.exists():
            campuses = json.loads(campus_path.read_text())
            campus_id_to_code = {c["id"]: c["code"] for c in campuses}
        else:
            print(f"Error: campus data not found at {campus_path}")
            return False

        # Load academic_unit data to map unit id -> code
        unit_path = output_dir / "academic_unit" / "data.json"
        if unit_path.exists():
            units = json.loads(unit_path.read_text())
            unit_id_to_code = {u["id"]: u["code"] for u in units}
        else:
            print(f"Error: academic_unit data not found at {unit_path}")
            return False

        # Build list of (campus_code, academic_unit_code) combinations
        academic_unit_campus_data = []
        for relation in relations:
            campus_id = relation.get("campus_id")
            academic_unit_id = relation.get("academic_unit_id")

            campus_code = campus_id_to_code.get(campus_id)
            academic_unit_code = unit_id_to_code.get(academic_unit_id)

            if campus_code and academic_unit_code:
                academic_unit_campus_data.append(
                    {
                        "campus_code": campus_code,
                        "academic_unit_code": academic_unit_code,
                    }
                )

        run_study_plan_download_cli(
            output_dir=output_dir,
            academic_unit_campus_data=academic_unit_campus_data,
            verify_ssl=verify_ssl,
            concurrency=concurrency,
        )

    years_list = [item.strip() for item in (years or []) if item and item.strip()]
    years_list = sorted(set(years_list))

    if run_offering and not years_list:
        print("Error: --years is required for offering downloads")
        return False

    if run_offering:
        unit_path = output_dir / "academic_unit" / "data.json"
        if not unit_path.exists():
            print(f"Error: academic_unit data not found at {unit_path}")
            print("Please run 'process' command first to generate academic_unit data.")
            return False

        units = json.loads(unit_path.read_text())
        school_codes = [u["code"] for u in units]

        client = AcademicUnitClient(verify_ssl=verify_ssl)
        try:
            course_offer_school_codes_by_year: dict[str, set[str]] = {}
            empty_course_offer_school_codes_by_year: dict[str, set[str]] = {}
            for current_year in years_list:
                typer.echo(
                    f"{_progress_prefix('download')} fetching course_offer for year={current_year}..."
                )
                files, empty_school_codes, error_school_codes = (
                    client.download_oferta_cursos(
                        output_dir,
                        school_codes,
                        current_year,
                        progress_callback=lambda idx,
                        total,
                        code,
                        status: _render_download_progress(
                            idx, total, f"{code}.json", status
                        ),
                    )
                )
                course_offer_school_codes_by_year[current_year] = set(files)
                empty_course_offer_school_codes_by_year[current_year] = (
                    empty_school_codes
                )
                print()
                typer.echo(
                    f"{_progress_prefix('download')} course_offer complete: {len(files)} files, {len(empty_school_codes)} empty, {len(error_school_codes)} errors"
                )

            for current_year in years_list:
                course_offer_school_codes = course_offer_school_codes_by_year.get(
                    current_year, set()
                )
                fallback_school_codes = sorted(
                    empty_course_offer_school_codes_by_year.get(current_year, set())
                )
                typer.echo(
                    f"{_progress_prefix('download')} fetching schedule_guia for year={current_year}..."
                )
                files = client.download_horarios_from_course_offer(
                    output_dir,
                    current_year,
                    fallback_school_codes=fallback_school_codes,
                    course_offer_school_codes=sorted(course_offer_school_codes),
                    progress_callback=lambda idx,
                    total,
                    sede,
                    carrera,
                    periodo,
                    status: _render_download_progress(
                        idx, total, f"{sede}_{carrera}_{periodo}.json", status
                    ),
                )
                print()
                typer.echo(
                    f"{_progress_prefix('download')} schedule_guia complete: {len(files)} files"
                )
        finally:
            client.close()

    return True
