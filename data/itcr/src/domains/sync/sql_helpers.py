"""Reusable SQL generation helper functions."""

from datetime import UTC, datetime
from pathlib import Path
from typing import Any

import typer


def utc_timestamp_slug() -> str:
    """Return a UTC timestamp suitable for deterministic file names."""
    return datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")


def resolve_output_path(
    output_path: Path | None,
    mode: str,
    history_dir: Path,
    timestamp_slug: str,
) -> Path:
    """Resolve output path for SQL generation."""
    normalized_mode = mode.strip().lower()
    if normalized_mode not in {"full", "delta"}:
        raise typer.BadParameter("--mode must be either 'full' or 'delta'")

    if output_path is not None:
        return output_path

    if normalized_mode == "delta":
        return history_dir / f"seed_{timestamp_slug}.sql"
    return Path("../seed.sql")


def escape_sql_string(value: str) -> str:
    """Escape a string for SQL INSERT, handling quotes and special chars."""
    escaped = value.replace("'", "''").replace("\\", "\\\\")
    return f"E'{escaped}'"


def format_value(value: Any, target_type: str = "TEXT") -> str:
    """Format a value according to its target PostgreSQL column type."""
    if value is None:
        return "NULL"
    if target_type in ("INTEGER", "BIGINT", "SMALLINT"):
        return str(int(value))
    if target_type == "NUMERIC":
        return str(float(value))
    if target_type == "BOOLEAN":
        return "TRUE" if value else "FALSE"
    if target_type == "DATE":
        return f"'{value}'" if isinstance(value, str) and "-" in value else "NULL"
    if target_type == "TIMESTAMPTZ":
        return f"'{value}'" if isinstance(value, str) else "NOW()"
    if target_type == "TIME":
        return f"'{value}'" if isinstance(value, str) and ":" in value else "NULL"
    if target_type == "UUID":
        return f"'{value}'" if isinstance(value, str) else "NULL"
    return escape_sql_string(str(value))


def build_upsert_clause(columns: list[str], config: dict[str, Any]) -> str:
    """Build an ON CONFLICT clause for a table."""
    conflict_columns = config.get("conflict_columns")
    if conflict_columns is None:
        conflict_columns = ["id"] if "id" in columns else []
    if not conflict_columns:
        return ""

    update_assignments = config.get("update_assignments")
    if update_assignments is None:
        updatable_columns = [col for col in columns if col not in conflict_columns]
        update_assignments = [f"{col} = EXCLUDED.{col}" for col in updatable_columns]
    if not update_assignments:
        return f"ON CONFLICT ({', '.join(conflict_columns)}) DO NOTHING"

    updates = ",\n    ".join(update_assignments)
    return f"ON CONFLICT ({', '.join(conflict_columns)}) DO UPDATE SET\n    {updates}"
