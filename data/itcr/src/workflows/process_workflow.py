"""Process command for transforming raw data."""

import json
from pathlib import Path

import typer

from src.domains.catalog.processors import ensure_reference_data
from src.domains.catalog.processors import process_academic_period
from src.domains.catalog.processors import process_academic_unit
from src.domains.catalog.processors import process_campus
from src.domains.offering.processors import run_process_course_offering
from src.domains.study_plan.processors import process_study_plan_complete
from src.shared.scope import normalize_scope

app = typer.Typer(pretty_exceptions_show_locals=False)


def run_process(
    data_dir: Path,
    scope: str = "all",
    university_id: int | None = None,
    years: list[int] | None = None,
    include_catalog_study_plan: bool = True,
) -> None:
    """Run processing for specified scope."""
    scope = normalize_scope(scope)
    run_catalog = scope in {"catalog", "all"}
    run_offering = scope in {"offering", "all"}

    try:
        ensure_reference_data(data_dir)

        if run_catalog:
            campuses = process_campus(data_dir, university_id)
            campus_path = data_dir / "campus" / "data.json"
            campus_path.write_text(json.dumps(campuses, indent=2, ensure_ascii=False))
            typer.echo(f"Processed {len(campuses)} campuses to {campus_path}")

            academic_units, unit_campus_relations = process_academic_unit(
                data_dir, university_id
            )
            unit_path = data_dir / "academic_unit" / "data.json"
            unit_path.write_text(
                json.dumps(academic_units, indent=2, ensure_ascii=False)
            )
            typer.echo(f"Processed {len(academic_units)} academic_units to {unit_path}")

            rel_path = data_dir / "academic_unit_campus" / "data.json"
            rel_path.parent.mkdir(parents=True, exist_ok=True)
            rel_path.write_text(
                json.dumps(unit_campus_relations, indent=2, ensure_ascii=False)
            )
            typer.echo(
                f"Processed {len(unit_campus_relations)} academic_unit_campus relations"
            )

            modalities, terms = process_academic_period(data_dir, years)
            modality_path = data_dir / "academic_modality" / "data.json"
            modality_path.parent.mkdir(parents=True, exist_ok=True)
            modality_path.write_text(
                json.dumps(modalities, indent=2, ensure_ascii=False)
            )
            typer.echo(
                f"Processed {len(modalities)} academic_modality to {modality_path}"
            )

            term_path = data_dir / "academic_term" / "data.json"
            term_path.parent.mkdir(parents=True, exist_ok=True)
            term_path.write_text(json.dumps(terms, indent=2, ensure_ascii=False))
            typer.echo(f"Processed {len(terms)} academic_term to {term_path}")

            if include_catalog_study_plan:
                (
                    study_plans,
                    plan_campus_relations,
                    study_plan_levels,
                    courses,
                    course_relations,
                    level_courses,
                ) = process_study_plan_complete(data_dir)

                plan_path = data_dir / "study_plan" / "data.json"
                plan_path.parent.mkdir(parents=True, exist_ok=True)
                plan_path.write_text(
                    json.dumps(study_plans, indent=2, ensure_ascii=False)
                )
                typer.echo(f"Processed {len(study_plans)} study_plans to {plan_path}")

                plan_campus_path = data_dir / "study_plan_campus" / "data.json"
                plan_campus_path.parent.mkdir(parents=True, exist_ok=True)
                plan_campus_path.write_text(
                    json.dumps(plan_campus_relations, indent=2, ensure_ascii=False)
                )
                typer.echo(
                    f"Processed {len(plan_campus_relations)} study_plan_campus relations"
                )

                plan_level_path = data_dir / "study_plan_level" / "data.json"
                plan_level_path.parent.mkdir(parents=True, exist_ok=True)
                plan_level_path.write_text(
                    json.dumps(study_plan_levels, indent=2, ensure_ascii=False)
                )
                typer.echo(
                    f"Processed {len(study_plan_levels)} study_plan_levels to {plan_level_path}"
                )

                level_course_path = data_dir / "study_plan_level_course" / "data.json"
                level_course_path.parent.mkdir(parents=True, exist_ok=True)
                level_course_path.write_text(
                    json.dumps(level_courses, indent=2, ensure_ascii=False)
                )
                typer.echo(
                    f"Processed {len(level_courses)} study_plan_level_courses to {level_course_path}"
                )

                course_path = data_dir / "course" / "data.json"
                course_path.parent.mkdir(parents=True, exist_ok=True)
                course_path.write_text(
                    json.dumps(courses, indent=2, ensure_ascii=False)
                )
                typer.echo(f"Processed {len(courses)} courses to {course_path}")

                course_rel_path = data_dir / "course_relation" / "data.json"
                course_rel_path.parent.mkdir(parents=True, exist_ok=True)
                course_rel_path.write_text(
                    json.dumps(course_relations, indent=2, ensure_ascii=False)
                )
                typer.echo(
                    f"Processed {len(course_relations)} course_relations to {course_rel_path}"
                )

    except FileNotFoundError as exc:
        typer.echo(f"Error: {exc}")
        raise typer.Exit(1) from exc
    except ValueError as exc:
        typer.echo(f"Error: {exc}")
        raise typer.Exit(1) from exc

    if run_offering:
        if not years:
            typer.echo("Error: --years is required for offering processing")
            raise typer.Exit(1)
        for year in sorted(set(years)):
            run_process_course_offering(data_dir, str(year))


@app.command()
def process_cmd(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory with raw files"
    ),
    scope: str = typer.Option(
        "all", "--scope", "-s", help="Scope to process: catalog, offering, all"
    ),
    university_id: int | None = typer.Option(
        None, "--university-id", "-u", help="University ID for entities"
    ),
    years: str | None = typer.Option(
        None,
        "--years",
        "-y",
        help="Comma-separated years for academic_term (e.g., 2024,2025,2026)",
    ),
) -> None:
    """Process raw data files into normalized data.json format."""
    years_list: list[int] | None = None
    if years:
        years_list = [int(y.strip()) for y in years.split(",")]
    run_process(
        data_dir=data_dir, scope=scope, university_id=university_id, years=years_list
    )


if __name__ == "__main__":
    app()
