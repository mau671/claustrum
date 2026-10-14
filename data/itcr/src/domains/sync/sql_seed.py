"""Generate SQL seed data from processed JSON files."""

import json
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

import typer

from src.domains.sync.sql_helpers import build_upsert_clause
from src.domains.sync.sql_helpers import format_value
from src.domains.sync.sql_helpers import resolve_output_path
from src.domains.sync.sql_helpers import utc_timestamp_slug
from src.shared.scope import normalize_scope


def generate_seed(
    data_dir: Path = Path("data/raw"),
    output_path: Path | None = None,
    tables: list[str] | None = None,
    mode: str = "full",
    scope: str = "all",
    years: list[int] | None = None,
    term_external_keys: list[str] | None = None,
    history_dir: Path = Path("../seeds/itcr"),
    write_manifest: bool = False,
) -> Path:
    """Generate seed.sql from processed JSON data files.

    Args:
        data_dir: Directory containing processed data.json files
        output_path: Output path for seed.sql
        tables: Optional list of tables to include (None = all)

    Returns:
        Path to the generated SQL file.
    """
    scope = normalize_scope(scope)
    timestamp_slug = utc_timestamp_slug()
    output_path = resolve_output_path(output_path, mode, history_dir, timestamp_slug)
    run_generated_at = datetime.now(UTC).isoformat()

    # Table definitions with column info
    table_configs: dict[str, dict[str, Any]] = {
        "country": {
            "columns": ["id", "name", "iso2_code"],
            "types": {"id": "BIGINT"},
            "order": 1,
            "conflict_columns": ["iso2_code"],
            "update_assignments": [
                "name = EXCLUDED.name",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "university": {
            "columns": ["id", "country_id", "name", "short_name"],
            "types": {"id": "BIGINT", "country_id": "BIGINT"},
            "order": 2,
            "conflict_columns": ["id"],
            "update_assignments": [
                "country_id = EXCLUDED.country_id",
                "name = EXCLUDED.name",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "campus": {
            "columns": ["id", "university_id", "code", "name"],
            "types": {"id": "BIGINT", "university_id": "BIGINT"},
            "order": 3,
            "conflict_columns": ["code"],
            "update_assignments": [
                "university_id = EXCLUDED.university_id",
                "name = EXCLUDED.name",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "academic_unit": {
            "columns": ["id", "university_id", "code", "name"],
            "types": {"id": "BIGINT", "university_id": "BIGINT"},
            "order": 4,
            "conflict_columns": ["code"],
            "update_assignments": [
                "university_id = EXCLUDED.university_id",
                "name = EXCLUDED.name",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "academic_modality": {
            "columns": ["id", "code", "name", "periods_per_year"],
            "types": {"id": "BIGINT", "periods_per_year": "INTEGER"},
            "order": 5,
            "conflict_columns": ["code"],
            "update_assignments": [
                "name = EXCLUDED.name",
                "periods_per_year = EXCLUDED.periods_per_year",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "academic_term": {
            "columns": [
                "id",
                "academic_modality_id",
                "year",
                "period_number",
                "external_key",
                "display_name",
                "starts_on",
                "ends_on",
            ],
            "types": {
                "id": "BIGINT",
                "academic_modality_id": "BIGINT",
                "year": "INTEGER",
                "period_number": "INTEGER",
                "starts_on": "DATE",
                "ends_on": "DATE",
            },
            "order": 6,
            "conflict_columns": ["external_key"],
            "update_assignments": [
                "academic_modality_id = EXCLUDED.academic_modality_id",
                "year = EXCLUDED.year",
                "period_number = EXCLUDED.period_number",
                "display_name = EXCLUDED.display_name",
                "starts_on = EXCLUDED.starts_on",
                "ends_on = EXCLUDED.ends_on",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": False,
        },
        "academic_unit_campus": {
            "columns": ["id", "academic_unit_id", "campus_id"],
            "types": {
                "id": "BIGINT",
                "academic_unit_id": "BIGINT",
                "campus_id": "BIGINT",
            },
            "order": 7,
            "conflict_columns": ["academic_unit_id", "campus_id"],
            "update_assignments": [
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "study_plan": {
            "columns": [
                "id",
                "academic_unit_id",
                "academic_modality_id",
                "external_plan_id",
                "name",
                "academic_degree",
                "first_level_number",
            ],
            "types": {
                "id": "BIGINT",
                "academic_unit_id": "BIGINT",
                "academic_modality_id": "BIGINT",
                "external_plan_id": "INTEGER",
                "first_level_number": "INTEGER",
                "academic_degree": "TEXT",
            },
            "order": 8,
            "conflict_columns": ["academic_unit_id", "external_plan_id"],
            "update_assignments": [
                "academic_modality_id = EXCLUDED.academic_modality_id",
                "name = EXCLUDED.name",
                "academic_degree = EXCLUDED.academic_degree",
                "first_level_number = EXCLUDED.first_level_number",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "study_plan_campus": {
            "columns": ["id", "study_plan_id", "campus_id", "valid_from", "valid_to"],
            "types": {
                "id": "BIGINT",
                "study_plan_id": "BIGINT",
                "campus_id": "BIGINT",
                "valid_from": "DATE",
                "valid_to": "DATE",
            },
            "order": 9,
            "conflict_columns": ["study_plan_id", "campus_id"],
            "update_assignments": [
                "valid_from = EXCLUDED.valid_from",
                "valid_to = EXCLUDED.valid_to",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "study_plan_level": {
            "columns": ["id", "study_plan_id", "level_number", "level_label"],
            "types": {
                "id": "BIGINT",
                "study_plan_id": "BIGINT",
                "level_number": "INTEGER",
            },
            "order": 10,
            "conflict_columns": ["study_plan_id", "level_number"],
            "update_assignments": [
                "level_label = EXCLUDED.level_label",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course": {
            "columns": [
                "id",
                "code",
                "name",
                "default_credits",
                "default_weekly_hours",
            ],
            "types": {
                "id": "BIGINT",
                "default_credits": "INTEGER",
                "default_weekly_hours": "INTEGER",
            },
            "order": 11,
            "conflict_columns": ["code"],
            "update_assignments": [
                "name = COALESCE(NULLIF(EXCLUDED.name, EXCLUDED.code), NULLIF(course.name, ''), EXCLUDED.name)",
                "default_credits = EXCLUDED.default_credits",
                "default_weekly_hours = EXCLUDED.default_weekly_hours",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "study_plan_level_course": {
            "columns": [
                "id",
                "study_plan_level_id",
                "course_id",
                "credits",
                "weekly_hours",
                "sort_order",
            ],
            "types": {
                "id": "BIGINT",
                "study_plan_level_id": "BIGINT",
                "course_id": "BIGINT",
                "credits": "INTEGER",
                "weekly_hours": "INTEGER",
                "sort_order": "INTEGER",
            },
            "order": 12,
            "conflict_columns": ["study_plan_level_id", "course_id"],
            "update_assignments": [
                "credits = EXCLUDED.credits",
                "weekly_hours = EXCLUDED.weekly_hours",
                "sort_order = EXCLUDED.sort_order",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course_relation": {
            "columns": [
                "id",
                "study_plan_id",
                "from_course_id",
                "to_course_id",
                "relation_type",
            ],
            "types": {
                "id": "BIGINT",
                "study_plan_id": "BIGINT",
                "from_course_id": "BIGINT",
                "to_course_id": "BIGINT",
            },
            "order": 13,
            "conflict_columns": [
                "study_plan_id",
                "from_course_id",
                "to_course_id",
                "relation_type",
            ],
            "update_assignments": [
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "professor": {
            "columns": ["id", "full_name"],
            "types": {"id": "BIGINT"},
            "order": 14,
            "conflict_columns": ["full_name"],
            "update_assignments": [
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course_offering": {
            "columns": [
                "id",
                "course_id",
                "campus_id",
                "academic_unit_id",
                "academic_term_id",
                "credits_snapshot",
                "weekly_hours_snapshot",
                "course_type",
            ],
            "types": {
                "id": "BIGINT",
                "course_id": "BIGINT",
                "campus_id": "BIGINT",
                "academic_unit_id": "BIGINT",
                "academic_term_id": "BIGINT",
                "credits_snapshot": "INTEGER",
                "weekly_hours_snapshot": "INTEGER",
            },
            "order": 15,
            "conflict_columns": [
                "course_id",
                "campus_id",
                "academic_unit_id",
                "academic_term_id",
            ],
            "update_assignments": [
                "course_id = EXCLUDED.course_id",
                "campus_id = EXCLUDED.campus_id",
                "academic_unit_id = EXCLUDED.academic_unit_id",
                "academic_term_id = EXCLUDED.academic_term_id",
                "credits_snapshot = EXCLUDED.credits_snapshot",
                "weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot",
                "course_type = EXCLUDED.course_type",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course_offering_group": {
            "columns": [
                "id",
                "course_offering_id",
                "group_code",
                "group_type",
                "capacity",
            ],
            "types": {
                "id": "BIGINT",
                "course_offering_id": "BIGINT",
                "capacity": "INTEGER",
            },
            "order": 16,
            "conflict_columns": ["course_offering_id", "group_code"],
            "update_assignments": [
                "course_offering_id = EXCLUDED.course_offering_id",
                "group_code = EXCLUDED.group_code",
                "group_type = EXCLUDED.group_type",
                "capacity = EXCLUDED.capacity",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course_offering_group_professor": {
            "columns": ["id", "course_offering_group_id", "professor_id"],
            "types": {
                "id": "BIGINT",
                "course_offering_group_id": "BIGINT",
                "professor_id": "BIGINT",
            },
            "order": 17,
            "conflict_columns": ["course_offering_group_id", "professor_id"],
            "update_assignments": [
                "course_offering_group_id = EXCLUDED.course_offering_group_id",
                "professor_id = EXCLUDED.professor_id",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
        "course_offering_meeting": {
            "columns": [
                "id",
                "course_offering_group_id",
                "weekday",
                "starts_at",
                "ends_at",
                "classroom",
            ],
            "types": {
                "id": "BIGINT",
                "course_offering_group_id": "BIGINT",
                "weekday": "INTEGER",
                "starts_at": "TIME",
                "ends_at": "TIME",
            },
            "order": 18,
            "conflict_columns": [
                "course_offering_group_id",
                "weekday",
                "starts_at",
                "ends_at",
            ],
            "update_assignments": [
                "course_offering_group_id = EXCLUDED.course_offering_group_id",
                "weekday = EXCLUDED.weekday",
                "starts_at = EXCLUDED.starts_at",
                "ends_at = EXCLUDED.ends_at",
                "classroom = EXCLUDED.classroom",
                "is_active = TRUE",
                "deactivated_at = NULL",
                "updated_at = NOW()",
            ],
            "supports_soft_delete": True,
        },
    }

    # Filter tables if specified
    if tables:
        table_configs = {k: v for k, v in table_configs.items() if k in tables}
        if not table_configs:
            typer.echo(
                f"Error: No valid tables found. Available: {list(table_configs.keys())}"
            )
            raise typer.Exit(1)

    # Sort by order
    sorted_tables = sorted(table_configs.items(), key=lambda x: x[1]["order"])

    # Generate SQL
    output_lines: list[str] = []
    output_lines.append(
        "-- ============================================================================"
    )
    output_lines.append("-- SEED DATA")
    output_lines.append("-- Generated by: tec-data sql")
    output_lines.append(f"-- Generated from: {Path(__file__).parent}")
    output_lines.append(f"-- Generated at (UTC): {run_generated_at}")
    output_lines.append(f"-- Mode: {mode}")
    output_lines.append(f"-- Scope: {scope}")
    if years:
        output_lines.append(
            f"-- Years: {', '.join(str(year) for year in sorted(set(years)))}"
        )
    if term_external_keys:
        output_lines.append(
            "-- Term external keys: " + ", ".join(sorted(set(term_external_keys)))
        )
    output_lines.append(
        "-- ============================================================================"
    )
    output_lines.append("")
    output_lines.append("BEGIN;")
    output_lines.append("SET LOCAL TIME ZONE 'UTC';")

    total_rows = 0
    synced_term_ids: set[int] = set()
    seeded_tables: list[str] = []

    for table_name, config in sorted_tables:
        data_path = data_dir / table_name / "data.json"
        if not data_path.exists():
            typer.echo(f"Warning: {data_path} not found, skipping {table_name}")
            continue

        try:
            with open(data_path, encoding="utf-8") as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            typer.echo(f"Error: Invalid JSON in {data_path}: {e}")
            continue

        if not data:
            typer.echo(f"Warning: Empty data in {data_path}, skipping {table_name}")
            continue

        output_lines.append("")
        output_lines.append(f"-- {table_name} ({len(data)} rows)")
        seeded_tables.append(table_name)

        if table_name == "course_offering":
            for row in data:
                term_id = row.get("academic_term_id")
                if term_id is None:
                    continue
                synced_term_ids.add(int(term_id))

        columns = config["columns"]
        types = config.get("types", {})
        output_lines.append(f"INSERT INTO public.{table_name}")
        output_lines.append(f"  ({', '.join(columns)})")
        output_lines.append("VALUES")

        values_lines: list[str] = []
        for row in data:
            formatted_values: list[str] = []
            for col in columns:
                value = row.get(col)
                col_type = types.get(col, "TEXT")
                formatted_values.append(format_value(value, col_type))
            values_lines.append(f"  ({', '.join(formatted_values)})")

        output_lines.append(",\n".join(values_lines))
        upsert_clause = build_upsert_clause(columns, config)
        if upsert_clause:
            output_lines.append(upsert_clause + ";")
        else:
            output_lines[-1] = output_lines[-1] + ";"
        total_rows += len(data)

    if synced_term_ids:
        term_ids_literal = ", ".join(
            str(term_id) for term_id in sorted(synced_term_ids)
        )

        output_lines.append("")
        output_lines.append("-- Soft delete for stale schedule rows in synced terms")

        output_lines.append("UPDATE public.course_offering_meeting com")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE com.is_active = true")
        output_lines.append("  AND com.updated_at < NOW()")
        output_lines.append("  AND EXISTS (")
        output_lines.append("    SELECT 1")
        output_lines.append("    FROM public.course_offering_group g")
        output_lines.append(
            "    JOIN public.course_offering co ON co.id = g.course_offering_id"
        )
        output_lines.append("    WHERE g.id = com.course_offering_group_id")
        output_lines.append(
            f"      AND co.academic_term_id = ANY(ARRAY[{term_ids_literal}]::BIGINT[])"
        )
        output_lines.append("  );")

        output_lines.append("UPDATE public.course_offering_group_professor cogp")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE cogp.is_active = true")
        output_lines.append("  AND cogp.updated_at < NOW()")
        output_lines.append("  AND EXISTS (")
        output_lines.append("    SELECT 1")
        output_lines.append("    FROM public.course_offering_group g")
        output_lines.append(
            "    JOIN public.course_offering co ON co.id = g.course_offering_id"
        )
        output_lines.append("    WHERE g.id = cogp.course_offering_group_id")
        output_lines.append(
            f"      AND co.academic_term_id = ANY(ARRAY[{term_ids_literal}]::BIGINT[])"
        )
        output_lines.append("  );")

        output_lines.append("UPDATE public.course_offering_group g")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE g.is_active = true")
        output_lines.append("  AND g.updated_at < NOW()")
        output_lines.append("  AND EXISTS (")
        output_lines.append("    SELECT 1")
        output_lines.append("    FROM public.course_offering co")
        output_lines.append("    WHERE co.id = g.course_offering_id")
        output_lines.append(
            f"      AND co.academic_term_id = ANY(ARRAY[{term_ids_literal}]::BIGINT[])"
        )
        output_lines.append("  );")

        output_lines.append("UPDATE public.course_offering co")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE co.is_active = true")
        output_lines.append("  AND co.updated_at < NOW()")
        output_lines.append(
            f"  AND co.academic_term_id = ANY(ARRAY[{term_ids_literal}]::BIGINT[]);"
        )

    if years and "academic_term" in seeded_tables:
        years_literal = ", ".join(str(y) for y in sorted(years))
        output_lines.append("")
        output_lines.append("-- Soft delete for stale academic_term rows in synced years")
        output_lines.append("UPDATE public.academic_term")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE is_active = true")
        output_lines.append("  AND updated_at < NOW()")
        output_lines.append(f"  AND year = ANY(ARRAY[{years_literal}]::INTEGER[]);")

    soft_delete_tables = [
        table_name
        for table_name, config in sorted_tables
        if config.get("supports_soft_delete") and table_name in seeded_tables
    ]
    for table_name in soft_delete_tables:
        if table_name.startswith("course_offering"):
            continue
        if scope == "offering":
            continue
        output_lines.append("")
        output_lines.append(f"-- Soft delete stale rows in {table_name}")
        output_lines.append(f"UPDATE public.{table_name}")
        output_lines.append(
            "SET is_active = false, deactivated_at = NOW(), updated_at = NOW()"
        )
        output_lines.append("WHERE is_active = true")
        output_lines.append("  AND updated_at < NOW();")

    if seeded_tables:
        output_lines.append("")
        output_lines.append("-- Align BIGSERIAL sequences after explicit id inserts")
        for table_name in seeded_tables:
            output_lines.append(
                "SELECT setval("
                f"pg_get_serial_sequence('public.{table_name}', 'id'), "
                f"COALESCE(MAX(id), 1), true) FROM public.{table_name};"
            )

    output_lines.append("")
    output_lines.append("COMMIT;")
    output_lines.append("")

    # Write output
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(output_lines), encoding="utf-8")

    if write_manifest:
        manifest_path = output_path.with_suffix(".json")
        manifest_payload = {
            "seed_file": output_path.name,
            "generated_at_utc": run_generated_at,
            "mode": mode,
            "scope": scope,
            "years": sorted(set(years or [])),
            "term_external_keys": sorted(set(term_external_keys or [])),
            "tables": seeded_tables,
            "total_rows": total_rows,
        }
        manifest_path.write_text(
            json.dumps(manifest_payload, indent=2, ensure_ascii=False), encoding="utf-8"
        )
        typer.echo(f"Generated manifest: {manifest_path}")

    typer.echo(f"Generated {output_path} with {total_rows:,} total rows")
    return output_path


def run_sql(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for processed files"
    ),
    output: Path | None = typer.Option(
        None,
        "--output",
        "-o",
        help="Output SQL file path (defaults to timestamped path when mode=delta)",
    ),
    tables: str | None = typer.Option(
        None, "--tables", "-t", help="Comma-separated list of tables to include"
    ),
    mode: str = typer.Option(
        "delta", "--mode", help="Generation mode: delta (versioned) or full"
    ),
    scope: str = typer.Option(
        "all",
        "--scope",
        help="Data scope: catalog, offering, all",
    ),
    years: str | None = typer.Option(
        None,
        "--years",
        "-y",
        help="Comma-separated years metadata for the run",
    ),
    term_external_keys: str | None = typer.Option(
        None,
        "--terms",
        help="Comma-separated academic_term external keys metadata for the run",
    ),
    history_dir: Path = typer.Option(
        Path("../seeds/itcr"),
        "--history-dir",
        help="Directory for timestamped seed files when mode=delta",
    ),
    manifest: bool = typer.Option(
        False,
        "--manifest/--no-manifest",
        help="Generate a JSON manifest next to the SQL file",
    ),
) -> None:
    """Generate SQL seed data from processed JSON files."""
    table_list = None
    if tables:
        table_list = [t.strip() for t in tables.split(",")]

    years_list = None
    if years:
        years_list = [int(y.strip()) for y in years.split(",") if y.strip()]

    term_list = None
    if term_external_keys:
        term_list = [
            term.strip() for term in term_external_keys.split(",") if term.strip()
        ]

    generate_seed(
        data_dir=data_dir,
        output_path=output,
        tables=table_list,
        mode=mode,
        scope=scope,
        years=years_list,
        term_external_keys=term_list,
        history_dir=history_dir,
        write_manifest=manifest,
    )
