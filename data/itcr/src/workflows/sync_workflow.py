"""Unified sync command for full catalog + offering synchronization."""

from __future__ import annotations

import json
import os
import shutil
import socket
import subprocess
import tempfile
import time
import uuid
from collections.abc import Iterable
from datetime import UTC, datetime
from pathlib import Path
from typing import Any
from urllib.parse import urlparse

import typer

from src.domains.sync.helpers import (
    OFFERING_TABLES,
    SYNC_TABLES,
    collect_seed_history,
    collect_term_external_keys,
    compute_sync_fingerprint,
    infer_environment_id,
    load_json,
    next_sequential_id,
    parse_seed_metadata,
    quote_literal,
    resolve_db_url,
    seed_sha256,
    sql_int_array,
    sql_text_array,
    tables_for_scope,
    write_json,
)
from src.domains.sync.sql_seed import format_value
from src.shared.scope import normalize_scope
from src.workflows.sync_pipeline import run_sync_pipeline

LOCAL_DB_URL = "postgresql://postgres:postgres@127.0.0.1:54322/postgres"
SEED_HISTORY_SERVICE_DB_URL = "postgresql://postgres:postgres@127.0.0.1:5432/postgres"


TABLE_CONFLICT_COLUMNS: dict[str, list[str]] = {
    "country": ["iso2_code"],
    "university": ["id"],
    "campus": ["code"],
    "academic_unit": ["code"],
    "academic_modality": ["code"],
    "academic_term": ["external_key"],
    "academic_unit_campus": ["academic_unit_id", "campus_id"],
    "study_plan": ["academic_unit_id", "external_plan_id"],
    "study_plan_campus": ["study_plan_id", "campus_id"],
    "study_plan_level": ["study_plan_id", "level_number"],
    "course": ["code"],
    "study_plan_level_course": ["study_plan_level_id", "course_id"],
    "course_relation": [
        "study_plan_id",
        "from_course_id",
        "to_course_id",
        "relation_type",
    ],
    "professor": ["full_name"],
    "course_offering": [
        "course_id",
        "campus_id",
        "academic_unit_id",
        "academic_term_id",
    ],
    "course_offering_group": ["course_offering_id", "group_code"],
    "course_offering_group_professor": ["course_offering_group_id", "professor_id"],
    "course_offering_meeting": [
        "course_offering_group_id",
        "weekday",
        "starts_at",
        "ends_at",
    ],
}


def query_rows(db_url: str, sql: str) -> list[str]:
    output = subprocess.check_output(
        ["psql", db_url, "-At", "-F", "\t", "-c", sql],
        text=True,
    )
    return [line for line in output.splitlines() if line.strip()]


def _find_free_host_port() -> int:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind(("127.0.0.1", 0))
        return int(sock.getsockname()[1])


def _start_seed_history_postgres_container() -> tuple[str, str]:
    container_name = f"tec-seed-history-{uuid.uuid4().hex[:8]}"
    host_port = _find_free_host_port()
    db_url = f"postgresql://postgres:postgres@127.0.0.1:{host_port}/postgres"

    subprocess.run(
        [
            "docker",
            "run",
            "-d",
            "--rm",
            "--name",
            container_name,
            "-e",
            "POSTGRES_PASSWORD=postgres",
            "-e",
            "POSTGRES_USER=postgres",
            "-e",
            "POSTGRES_DB=postgres",
            "-p",
            f"{host_port}:5432",
            "postgres:17",
        ],
        check=True,
        text=True,
        capture_output=True,
    )

    for _ in range(60):
        probe = subprocess.run(
            ["psql", db_url, "-v", "ON_ERROR_STOP=1", "-c", "SELECT 1;"],
            text=True,
            capture_output=True,
        )
        if probe.returncode == 0:
            return container_name, db_url
        time.sleep(1)

    raise RuntimeError("Postgres container did not become ready in time")


def _stop_seed_history_postgres_container(container_name: str) -> None:
    subprocess.run(
        ["docker", "stop", container_name],
        check=False,
        text=True,
        capture_output=True,
    )


def _apply_migrations(db_url: str, migrations_dir: Path) -> None:
    bootstrap_sql = """
    CREATE SCHEMA IF NOT EXISTS auth;
    CREATE SCHEMA IF NOT EXISTS better_auth;
    CREATE SCHEMA IF NOT EXISTS extensions;

    DO $$
    BEGIN
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon NOLOGIN;
      END IF;
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated NOLOGIN;
      END IF;
      IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role NOLOGIN;
      END IF;

      -- Create supabase_realtime publication to support realtime migrations
      IF NOT EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
        CREATE PUBLICATION supabase_realtime;
      END IF;
    END
    $$;

    CREATE TABLE IF NOT EXISTS auth.users (
      id UUID PRIMARY KEY,
      email TEXT,
      encrypted_password TEXT,
      email_confirmed_at TIMESTAMPTZ,
      invited_at TIMESTAMPTZ,
      last_sign_in_at TIMESTAMPTZ,
      raw_user_meta_data JSONB,
      raw_app_meta_data JSONB,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ,
      deleted_at TIMESTAMPTZ
    );

    CREATE TABLE IF NOT EXISTS auth.identities (
      id UUID PRIMARY KEY,
      user_id UUID REFERENCES auth.users(id),
      provider TEXT,
      provider_id TEXT,
      identity_data JSONB,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ
    );

    CREATE OR REPLACE FUNCTION auth.uid()
    RETURNS UUID
    LANGUAGE SQL
    STABLE
    AS $$
      SELECT NULLIF(current_setting('request.jwt.claim.sub', true), '')::uuid;
    $$;
    """
    subprocess.run(
        ["psql", db_url, "-v", "ON_ERROR_STOP=1", "-c", bootstrap_sql],
        check=True,
        text=True,
        capture_output=True,
    )

    migration_files = sorted(p for p in migrations_dir.glob("*.sql") if p.is_file())
    if not migration_files:
        raise RuntimeError(f"No migrations found in {migrations_dir}")
    for migration in migration_files:
        subprocess.run(
            ["psql", db_url, "-v", "ON_ERROR_STOP=1", "-f", str(migration)],
            check=True,
            text=True,
            capture_output=True,
        )


def create_temp_seed_history_db(
    seed_paths: list[Path], db_url: str, migrations_dir: Path, skip_migrations: bool = False
) -> tuple[str | None, str]:
    admin_db_url = db_url
    temp_db_url = db_url

    try:
        if not skip_migrations:
            _apply_migrations(admin_db_url, migrations_dir)
        subprocess.run(
            [
                "psql",
                temp_db_url,
                "-v",
                "ON_ERROR_STOP=1",
                "-c",
                "DO $$ DECLARE tbls TEXT; BEGIN "
                "SELECT string_agg(format('%I.%I', schemaname, tablename), ', ') INTO tbls "
                "FROM pg_tables WHERE schemaname = 'public'; "
                "IF tbls IS NOT NULL THEN EXECUTE 'TRUNCATE TABLE ' || tbls || ' RESTART IDENTITY CASCADE'; END IF; "
                "END $$;",
            ],
            check=True,
            text=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as exc:
        error_output = (exc.stderr or exc.stdout or "").strip()
        raise RuntimeError(
            f"Failed preparing seed-history temporary DB:\n{error_output}"
        ) from exc

    for seed_path in seed_paths:
        try:
            subprocess.run(
                ["psql", temp_db_url, "-v", "ON_ERROR_STOP=1", "-f", str(seed_path)],
                check=True,
                text=True,
                capture_output=True,
            )
        except subprocess.CalledProcessError as exc:
            error_output = (exc.stderr or exc.stdout or "").strip()
            raise RuntimeError(
                f"Failed applying seed history file {seed_path.name}:\n{error_output}"
            ) from exc

    return None, temp_db_url


def drop_temp_seed_history_db(db_name: str) -> None:
    parsed = urlparse(LOCAL_DB_URL)
    admin_db_url = parsed._replace(path="/postgres").geturl()
    subprocess.run(
        [
            "psql",
            admin_db_url,
            "-v",
            "ON_ERROR_STOP=1",
            "-c",
            f"DROP DATABASE IF EXISTS {db_name};",
        ],
        check=True,
        text=True,
        capture_output=True,
    )


def normalize_for_compare(value: Any, value_type: str) -> Any:
    if value is None:
        return None
    if value_type in {"INTEGER", "BIGINT", "SMALLINT"}:
        return int(value)
    if value_type == "BOOLEAN":
        if isinstance(value, bool):
            return value
        if isinstance(value, str):
            return value.lower() in {"t", "true", "1"}
    if value_type == "TIME":
        text = str(value).strip()
        if not text:
            return text
        parts = text.split(":")
        if len(parts) == 2:
            return f"{parts[0].zfill(2)}:{parts[1].zfill(2)}:00"
        if len(parts) >= 3:
            return f"{parts[0].zfill(2)}:{parts[1].zfill(2)}:{parts[2].zfill(2)}"
        return text
    return str(value)


def load_existing_rows_by_id(
    db_url: str,
    table: str,
    columns: list[str],
    column_types: dict[str, str],
    where_clause: str | None = None,
) -> dict[int, dict[str, Any]]:
    query_columns = ", ".join(columns)
    sql = f"SELECT {query_columns} FROM public.{table}"
    if where_clause:
        sql += f" {where_clause}"

    output = subprocess.check_output(
        [
            "psql",
            db_url,
            "-At",
            "-F",
            "\t",
            "-P",
            "null=\\N",
            "-c",
            sql,
        ],
        text=True,
    )
    rows: dict[int, dict[str, Any]] = {}
    for line in output.splitlines():
        if not line.strip():
            continue
        values = line.split("\t")
        row: dict[str, Any] = {}
        for index, col in enumerate(columns):
            raw = values[index] if index < len(values) else "\\N"
            value = None if raw == "\\N" else raw
            row[col] = normalize_for_compare(value, column_types.get(col, "TEXT"))
        rows[int(row["id"])] = row
    return rows


def pg_type_to_generic(data_type: str, udt_name: str) -> str:
    dt = (data_type or "").lower()
    udt = (udt_name or "").lower()
    if dt in {"bigint", "integer", "smallint"}:
        return dt.upper()
    if dt in {"numeric", "real", "double precision", "decimal"}:
        return "NUMERIC"
    if dt == "boolean":
        return "BOOLEAN"
    if dt == "date":
        return "DATE"
    if dt == "time without time zone":
        return "TIME"
    if dt in {"timestamp with time zone", "timestamp without time zone"}:
        return "TIMESTAMPTZ"
    if dt == "uuid":
        return "UUID"
    if dt == "user-defined" and udt:
        return udt
    return "TEXT"


def get_table_schema(
    db_url: str, table: str
) -> tuple[list[str], dict[str, str], set[str]]:
    sql = f"""
    SELECT column_name, data_type, udt_name
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = '{quote_literal(table)}'
    ORDER BY ordinal_position;
    """
    rows = query_rows(db_url, sql)
    if not rows:
        raise RuntimeError(f"Table public.{table} not found while introspecting schema")
    columns: list[str] = []
    column_types: dict[str, str] = {}
    column_set: set[str] = set()
    for row in rows:
        col_name, data_type, udt_name = row.split("\t")
        columns.append(col_name)
        column_set.add(col_name)
        column_types[col_name] = pg_type_to_generic(data_type, udt_name)
    return columns, column_types, column_set


def build_insert_statement(
    table: str,
    rows: list[dict[str, Any]],
    columns: list[str],
    column_types: dict[str, str],
    available_columns: set[str],
) -> list[str]:
    if not rows:
        return []
    lines = [f"INSERT INTO public.{table}", f"  ({', '.join(columns)})", "VALUES"]
    values_lines: list[str] = []
    for row in rows:
        formatted = [
            format_value(row.get(col), column_types.get(col, "TEXT")) for col in columns
        ]
        values_lines.append(f"  ({', '.join(formatted)})")
    conflict_columns = TABLE_CONFLICT_COLUMNS.get(table, ["id"])
    updatable = [
        col for col in columns if col not in set(conflict_columns) and col != "id"
    ]
    lines.append(",\n".join(values_lines))
    if updatable:
        update_sql = ", ".join(f"{col} = EXCLUDED.{col}" for col in updatable)
        lifecycle = []
        if "is_active" in available_columns and "is_active" not in columns:
            lifecycle.append("is_active = TRUE")
        if "deactivated_at" in available_columns and "deactivated_at" not in columns:
            lifecycle.append("deactivated_at = NULL")
        if "updated_at" in available_columns and "updated_at" not in columns:
            lifecycle.append("updated_at = NOW()")
        if lifecycle:
            update_sql = ", ".join([update_sql, *lifecycle])
        lines.append(
            f"ON CONFLICT ({', '.join(conflict_columns)}) DO UPDATE SET {update_sql};"
        )
    else:
        lines.append(f"ON CONFLICT ({', '.join(conflict_columns)}) DO NOTHING;")
    return lines


def write_noop_seed(
    output_path: Path,
    environment_id: str,
    years: list[int],
    term_external_keys: list[str],
    fingerprint: str,
    scope: str,
) -> tuple[Path, dict[str, dict[str, int]]]:
    lines = [
        "-- ============================================================================",
        "-- TEC-DATA DELTA SEED (NOOP)",
        "-- ============================================================================",
        f"-- TEC-DATA-META environment_id={environment_id}",
        f"-- TEC-DATA-META scope={scope}",
        f"-- TEC-DATA-META years={','.join(str(y) for y in sorted(set(years)))}",
        f"-- TEC-DATA-META term_external_keys={','.join(sorted(set(term_external_keys)))}",
        f"-- TEC-DATA-META data_fingerprint={fingerprint}",
        f"-- TEC-DATA-META generated_at_utc={datetime.now(UTC).isoformat()}",
        "",
        "BEGIN;",
        "-- NOOP: no row-level changes detected for selected scope",
        "COMMIT;",
        "",
    ]
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines), encoding="utf-8")
    stats = {
        table: {"inserted": 0, "updated": 0, "soft_deleted": 0} for table in SYNC_TABLES
    }
    return output_path, stats


def build_batch_update_statements(
    table: str,
    rows: list[dict[str, Any]],
    changed_columns: tuple[str, ...],
    column_types: dict[str, str],
    available_columns: set[str],
) -> list[str]:
    if not rows or not changed_columns:
        return []
        
    statements = []
    batch_size = 1000
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i + batch_size]
        
        values_lines = []
        for row in batch:
            row_values = [str(int(row["id"]))]
            for col in changed_columns:
                row_values.append(format_value(row.get(col), column_types.get(col, "TEXT")))
            values_lines.append(f"  ({', '.join(row_values)})")
            
        values_str = ",\n".join(values_lines)
        alias_list = ["id"] + list(changed_columns)
        
        assignments = []
        for col in changed_columns:
            assignments.append(f"{col} = nv.{col}::{column_types.get(col, 'TEXT')}")
            
        lifecycle = []
        if "is_active" in available_columns and "is_active" not in changed_columns:
            lifecycle.append("is_active = TRUE")
        if "deactivated_at" in available_columns and "deactivated_at" not in changed_columns:
            lifecycle.append("deactivated_at = NULL")
        if "updated_at" in available_columns and "updated_at" not in changed_columns:
            lifecycle.append("updated_at = NOW()")
            
        all_assignments = ",\n  ".join(assignments + lifecycle)
        
        sql = f"""UPDATE public.{table} AS t
SET
  {all_assignments}
FROM (VALUES
{values_str}
) AS nv ({', '.join(alias_list)})
WHERE t.id = nv.id::BIGINT;"""
        statements.append(sql)
        
    return statements


def payload_row_normalized(
    row: dict[str, Any],
    columns: list[str],
    column_types: dict[str, str],
) -> dict[str, Any]:
    return {
        col: normalize_for_compare(row.get(col), column_types.get(col, "TEXT"))
        for col in columns
    }


def load_offering_campus_subject_by_term(
    data_dir: Path,
    term_ids: set[int],
) -> dict[int, dict[int, set[int]]]:
    """
    Load which (campus, academic_unit/subject) combinations have course offerings
    for each term. This provides 3-dimensional granularity for soft-delete decisions.

    Returns:
        {
            term_id: {
                campus_id: {academic_unit_id, academic_unit_id, ...},
                campus_id: {...},
            },
            ...
        }

    Example:
        {
            2026_S_1_id: {
                cartago_id: {matematica_id},  # Cartago has Matemática offerings in 2026_S_1
            },
            2026_S_2_id: {
                cartago_id: {matematica_id},  # Cartago has Matemática offerings in 2026_S_2
            },
        }
    """
    campus_subject_by_term: dict[int, dict[int, set[int]]] = {}
    course_offering_path = data_dir / "course_offering" / "data.json"
    if not course_offering_path.exists():
        return campus_subject_by_term

    offerings = load_json(course_offering_path)
    for offering in offerings:
        term_id = int(offering.get("academic_term_id", 0))
        if term_id not in term_ids:
            continue
        campus_id = int(offering.get("campus_id", 0))
        subject_id = int(offering.get("academic_unit_id", 0))

        # Skip if any dimension is missing
        if not all([term_id, campus_id, subject_id]):
            continue

        # Initialize nested dicts if needed
        if term_id not in campus_subject_by_term:
            campus_subject_by_term[term_id] = {}
        if campus_id not in campus_subject_by_term[term_id]:
            campus_subject_by_term[term_id][campus_id] = set()

        # Add subject to the set
        campus_subject_by_term[term_id][campus_id].add(subject_id)

    return campus_subject_by_term


def generate_minimal_delta_seed(
    db_url: str,
    data_dir: Path,
    output_path: Path,
    years: list[int],
    term_external_keys: list[str],
    environment_id: str,
    fingerprint: str,
    scope: str = "all",
) -> tuple[Path, dict[str, dict[str, int]], bool]:
    target_tables = tables_for_scope(scope)
    if scope == "offering":
        if term_external_keys:
            terms_sql = ", ".join(
                f"'{quote_literal(term_key)}'"
                for term_key in sorted(set(term_external_keys))
            )
            term_ids = {
                int(value)
                for value in query_rows(
                    db_url,
                    "SELECT id FROM public.academic_term "
                    f"WHERE external_key = ANY(ARRAY[{terms_sql}]::TEXT[])",
                )
            }
        else:
            term_ids = set()
    else:
        term_ids = {
            int(row["id"])
            for row in load_json(data_dir / "academic_term" / "data.json")
            if int(row.get("year", 0)) in set(years)
        }
    lines: list[str] = [
        "-- ============================================================================",
        "-- TEC-DATA DELTA SEED",
        "-- ============================================================================",
        f"-- TEC-DATA-META environment_id={environment_id}",
        f"-- TEC-DATA-META scope={scope}",
        f"-- TEC-DATA-META years={','.join(str(y) for y in sorted(set(years)))}",
        f"-- TEC-DATA-META term_external_keys={','.join(sorted(set(term_external_keys)))}",
        f"-- TEC-DATA-META data_fingerprint={fingerprint}",
        f"-- TEC-DATA-META generated_at_utc={datetime.now(UTC).isoformat()}",
        "",
        "BEGIN;",
        "SET LOCAL TIME ZONE 'UTC';",
    ]

    table_stats: dict[str, dict[str, int]] = {}

    # Load which (campus, subject) combinations have offerings for each term.
    # This provides 3-dimensional granularity: only soft-delete offerings when
    # a campus-subject combination has data in the sync for that term.
    campus_subject_by_term = load_offering_campus_subject_by_term(data_dir, term_ids)

    # Tracks which course_offering IDs are stale but intentionally preserved because
    # their (campus, subject, term) combination has no sync data. Used by child tables
    # (group, professor, meeting) to avoid orphaning records of protected offerings.
    preserved_offering_ids: set[int] = set()
    # Groups of preserved offerings — propagated to group_professor and meeting
    # so they can filter directly by group_id without a multi-table JOIN.
    preserved_group_ids: set[int] = set()

    for table in target_tables:
        db_columns, db_column_types, db_column_set = get_table_schema(db_url, table)
        payload_path = data_dir / table / "data.json"
        payload_rows = load_json(payload_path) if payload_path.exists() else []
        payload_columns = sorted({key for row in payload_rows for key in row.keys()})
        columns = [col for col in db_columns if col in payload_columns]
        if "id" not in columns and "id" in db_column_set:
            columns = ["id", *columns]
        if not columns:
            table_stats[table] = {"inserted": 0, "updated": 0, "soft_deleted": 0}
            continue

        column_types = {col: db_column_types.get(col, "TEXT") for col in columns}
        normalized_payload = {
            int(row["id"]): payload_row_normalized(row, columns, column_types)
            for row in payload_rows
            if row.get("id") is not None
        }
        if scope == "offering" and table in OFFERING_TABLES:
            if not term_ids:
                existing_rows = {}
            else:
                term_ids_sql = ", ".join(str(value) for value in sorted(term_ids))
                where_clause = ""
                if table == "course_offering":
                    where_clause = f"WHERE academic_term_id = ANY(ARRAY[{term_ids_sql}]::BIGINT[]) AND is_active = TRUE"
                elif table == "course_offering_group":
                    where_clause = f"WHERE course_offering_id IN (SELECT id FROM public.course_offering WHERE academic_term_id = ANY(ARRAY[{term_ids_sql}]::BIGINT[])) AND is_active = TRUE"
                elif table == "course_offering_group_professor":
                    where_clause = f"WHERE course_offering_group_id IN (SELECT g.id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE co.academic_term_id = ANY(ARRAY[{term_ids_sql}]::BIGINT[])) AND is_active = TRUE"
                elif table == "course_offering_meeting":
                    where_clause = f"WHERE course_offering_group_id IN (SELECT g.id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE co.academic_term_id = ANY(ARRAY[{term_ids_sql}]::BIGINT[])) AND is_active = TRUE"
                
                existing_rows = load_existing_rows_by_id(db_url, table, columns, column_types, where_clause)
        else:
            existing_rows = load_existing_rows_by_id(db_url, table, columns, column_types)

        insert_rows: list[dict[str, Any]] = []
        update_rows: list[str] = []
        update_groups: dict[tuple[str, ...], list[dict[str, Any]]] = {}

        for row_id, normalized_row in normalized_payload.items():
            current = existing_rows.get(row_id)
            if current is None:
                insert_rows.append(normalized_row)
                continue
            changed_columns = [
                col
                for col in columns
                if col not in ("id", "created_at", "updated_at")
                and normalize_for_compare(
                    current.get(col), column_types.get(col, "TEXT")
                )
                != normalize_for_compare(
                    normalized_row.get(col), column_types.get(col, "TEXT")
                )
            ]
            if table == "course" and "name" in changed_columns:
                payload_name = str(normalized_row.get("name") or "").strip().upper()
                payload_code = str(normalized_row.get("code") or "").strip().upper()
                current_name = str(current.get("name") or "").strip()
                if payload_name == payload_code and current_name:
                    changed_columns = [c for c in changed_columns if c != "name"]
            if (
                scope == "offering"
                and table == "course_offering"
                and changed_columns == ["weekly_hours_snapshot"]
                and normalized_row.get("weekly_hours_snapshot") is None
            ):
                continue
            if changed_columns:
                key = tuple(changed_columns)
                update_groups.setdefault(key, []).append(normalized_row)

        for changed_cols, rows_for_cols in update_groups.items():
            update_rows.extend(
                build_batch_update_statements(
                    table,
                    rows_for_cols,
                    changed_cols,
                    column_types,
                    db_column_set,
                )
            )

        stale_ids_set = set(existing_rows.keys()) - set(normalized_payload.keys())
        stale_ids = sorted(stale_ids_set)
        soft_delete_statements: list[str] = []
        filtered_stale_ids: list[int] = []

        if stale_ids:
            stale_ids_literal = ", ".join(str(value) for value in stale_ids)
            if table in OFFERING_TABLES:
                if table == "course_offering":
                    # 3-dimensional filter: only soft-delete offerings when the
                    # (term, campus, academic_unit) combination has data in this sync.
                    # If the combination is absent (temporarily empty), preserve the
                    # offering and protect its child records via preserved_offering_ids.
                    # Example: Cartago + Matemática + 2026_S_1 empty → preserve
                    #          Cartago + Matemática + 2026_S_2 has data → soft-delete stale
                    for offering_id, offering_row in existing_rows.items():
                        if offering_id not in stale_ids_set:
                            continue

                        term_id = int(offering_row.get("academic_term_id", 0))
                        campus_id = int(offering_row.get("campus_id", 0))
                        # academic_unit_id is a direct field on course_offering
                        subject_id = int(offering_row.get("academic_unit_id", 0))

                        # Only soft-delete if this (term, campus, subject) combination
                        # has data in the sync. This prevents soft-deleting when a
                        # campus-subject is temporarily empty.
                        if (
                            term_id in campus_subject_by_term
                            and campus_id in campus_subject_by_term[term_id]
                            and subject_id in campus_subject_by_term[term_id][campus_id]
                        ):
                            filtered_stale_ids.append(offering_id)

                    # Offerings that are stale but not soft-deleted: their child records
                    # (groups, professors, meetings) must also be preserved.
                    preserved_offering_ids = stale_ids_set - set(filtered_stale_ids)

                    if filtered_stale_ids:
                        filtered_stale_ids_literal = ", ".join(
                            str(id) for id in filtered_stale_ids
                        )
                        soft_delete_statements.append(
                            "UPDATE public.course_offering "
                            "SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() "
                            f"WHERE id = ANY(ARRAY[{filtered_stale_ids_literal}]::BIGINT[]) "
                            f"AND academic_term_id = ANY(ARRAY[{', '.join(str(t) for t in sorted(term_ids))}]::BIGINT[]);"
                        )
                elif table == "course_offering_group":
                    # Identify which stale groups belong to preserved offerings
                    # and exclude them from soft-delete. Only the net stale groups
                    # go into the SQL array — no WHERE exclusion clause needed.
                    preserved_group_ids = {
                        gid
                        for gid in stale_ids_set
                        if int(
                            existing_rows.get(gid, {}).get("course_offering_id") or 0
                        )
                        in preserved_offering_ids
                    }
                    actual_ids = sorted(stale_ids_set - preserved_group_ids)
                    if actual_ids:
                        actual_ids_literal = ", ".join(str(id) for id in actual_ids)
                        soft_delete_statements.append(
                            "UPDATE public.course_offering_group g "
                            "SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() "
                            f"WHERE g.id = ANY(ARRAY[{actual_ids_literal}]::BIGINT[]) "
                            "AND EXISTS (SELECT 1 FROM public.course_offering co "
                            "WHERE co.id = g.course_offering_id "
                            f"AND co.academic_term_id = ANY(ARRAY[{', '.join(str(t) for t in sorted(term_ids))}]::BIGINT[]));"
                        )
                elif table == "course_offering_group_professor":
                    # Exclude rows whose parent group is preserved — only net
                    # stale IDs go into the SQL array.
                    actual_ids = sorted(
                        gp_id
                        for gp_id in stale_ids_set
                        if int(
                            existing_rows.get(gp_id, {}).get("course_offering_group_id")
                            or 0
                        )
                        not in preserved_group_ids
                    )
                    if actual_ids:
                        actual_ids_literal = ", ".join(str(id) for id in actual_ids)
                        soft_delete_statements.append(
                            "UPDATE public.course_offering_group_professor gp "
                            "SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() "
                            f"WHERE gp.id = ANY(ARRAY[{actual_ids_literal}]::BIGINT[]) "
                            "AND EXISTS (SELECT 1 FROM public.course_offering_group g "
                            "JOIN public.course_offering co ON co.id = g.course_offering_id "
                            "WHERE g.id = gp.course_offering_group_id "
                            f"AND co.academic_term_id = ANY(ARRAY[{', '.join(str(t) for t in sorted(term_ids))}]::BIGINT[]));"
                        )
                elif table == "course_offering_meeting":
                    # Exclude rows whose parent group is preserved — only net
                    # stale IDs go into the SQL array.
                    actual_ids = sorted(
                        m_id
                        for m_id in stale_ids_set
                        if int(
                            existing_rows.get(m_id, {}).get("course_offering_group_id")
                            or 0
                        )
                        not in preserved_group_ids
                    )
                    if actual_ids:
                        actual_ids_literal = ", ".join(str(id) for id in actual_ids)
                        soft_delete_statements.append(
                            "UPDATE public.course_offering_meeting m "
                            "SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() "
                            f"WHERE m.id = ANY(ARRAY[{actual_ids_literal}]::BIGINT[]) "
                            "AND EXISTS (SELECT 1 FROM public.course_offering_group g "
                            "JOIN public.course_offering co ON co.id = g.course_offering_id "
                            "WHERE g.id = m.course_offering_group_id "
                            f"AND co.academic_term_id = ANY(ARRAY[{', '.join(str(t) for t in sorted(term_ids))}]::BIGINT[]));"
                        )
            elif scope != "offering":
                soft_delete_statements.append(
                    f"UPDATE public.{table} "
                    "SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() "
                    f"WHERE id = ANY(ARRAY[{stale_ids_literal}]::BIGINT[]);"
                )

        # Report accurate soft_deleted counts, excluding records that are stale
        # but intentionally preserved because their (campus, subject, term) or
        # parent group has no sync data.
        if table == "course_offering":
            actual_soft_deleted = len(filtered_stale_ids)
        elif table == "course_offering_group" and soft_delete_statements:
            actual_soft_deleted = len(stale_ids) - len(preserved_group_ids)
        elif (
            table in {"course_offering_group_professor", "course_offering_meeting"}
            and soft_delete_statements
        ):
            group_id_field = "course_offering_group_id"
            preserved_child_count = sum(
                1
                for row_id in stale_ids_set
                if int(existing_rows.get(row_id, {}).get(group_id_field) or 0)
                in preserved_group_ids
            )
            actual_soft_deleted = len(stale_ids) - preserved_child_count
        else:
            actual_soft_deleted = len(stale_ids) if soft_delete_statements else 0

        total_updated_rows = sum(len(rows) for rows in update_groups.values())
        table_stats[table] = {
            "inserted": len(insert_rows),
            "updated": total_updated_rows,
            "soft_deleted": actual_soft_deleted,
        }

        if insert_rows or update_rows or soft_delete_statements:
            lines.append("")
            lines.append(f"-- table: {table}")
            if insert_rows:
                lines.extend(
                    build_insert_statement(
                        table,
                        insert_rows,
                        columns,
                        column_types,
                        db_column_set,
                    )
                )
            lines.extend(update_rows)
            lines.extend(soft_delete_statements)

    has_changes = any(
        stats["inserted"] > 0 or stats["updated"] > 0 or stats["soft_deleted"] > 0
        for stats in table_stats.values()
    )
    if not has_changes:
        lines.append("")
        lines.append("-- NOOP: no row-level changes detected for selected scope")

    lines.extend(["", "COMMIT;", ""])
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines), encoding="utf-8")
    return output_path, table_stats, not has_changes


def backup_data_files(data_dir: Path, tables: list[str]) -> Path:
    backup_dir = Path(tempfile.mkdtemp(prefix="tec-data-sync-"))
    for table in tables:
        src = data_dir / table / "data.json"
        if not src.exists():
            continue
        dst = backup_dir / table / "data.json"
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    return backup_dir


def restore_data_files(data_dir: Path, backup_dir: Path) -> None:
    for table_dir in backup_dir.iterdir():
        src = table_dir / "data.json"
        if not src.exists():
            continue
        dst = data_dir / table_dir.name / "data.json"
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)


def remap_all_ids_to_db(
    db_url: str, 
    data_dir: Path, 
    tables_to_write: list[str] | None = None,
    term_external_keys: list[str] | None = None,
) -> None:
    tables = {}
    for table in SYNC_TABLES:
        table_file = data_dir / table / "data.json"
        tables[table] = load_json(table_file) if table_file.exists() else []

    countries = tables["country"]
    universities = tables["university"]
    campuses = tables["campus"]
    units = tables["academic_unit"]
    modalities = tables["academic_modality"]
    terms = tables["academic_term"]
    unit_campus = tables["academic_unit_campus"]
    study_plans = tables["study_plan"]
    study_plan_campus = tables["study_plan_campus"]
    study_plan_levels = tables["study_plan_level"]
    courses = tables["course"]
    level_courses = tables["study_plan_level_course"]
    course_relations = tables["course_relation"]
    professors = tables["professor"]
    offerings = tables["course_offering"]
    groups = tables["course_offering_group"]
    group_professors = tables["course_offering_group_professor"]
    meetings = tables["course_offering_meeting"]

    local_campus_by_id = {int(r["id"]): r for r in campuses}
    local_unit_by_id = {int(r["id"]): r for r in units}
    local_term_by_id = {int(r["id"]): r for r in terms}
    local_course_by_id = {int(r["id"]): r for r in courses}
    local_professor_by_id = {int(r["id"]): r for r in professors}
    local_study_plan_level_by_id = {int(r["id"]): r for r in study_plan_levels}

    country_by_iso = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, iso2_code FROM public.country")
        )
    }
    university_by_short_name = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(
                db_url, "SELECT id, short_name FROM public.university"
            )
        )
    }
    campus_by_code = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.campus")
        )
    }
    unit_by_code = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.academic_unit")
        )
    }
    modality_by_code = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(
                db_url, "SELECT id, code FROM public.academic_modality"
            )
        )
    }
    term_by_external_key = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(
                db_url, "SELECT id, external_key FROM public.academic_term"
            )
        )
    }
    course_by_code = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.course")
        )
    }
    professor_by_name = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, full_name FROM public.professor")
        )
    }

    study_plan_by_key: dict[tuple[str, int], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT sp.id, au.code, sp.external_plan_id
        FROM public.study_plan sp
        JOIN public.academic_unit au ON au.id = sp.academic_unit_id
        """,
    ):
        pid, unit_code, external_plan_id = line.split("\t")
        study_plan_by_key[(unit_code, int(external_plan_id))] = int(pid)

    study_plan_level_by_key: dict[tuple[str, int, int], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT spl.id, au.code, sp.external_plan_id, spl.level_number
        FROM public.study_plan_level spl
        JOIN public.study_plan sp ON sp.id = spl.study_plan_id
        JOIN public.academic_unit au ON au.id = sp.academic_unit_id
        """,
    ):
        pid, unit_code, external_plan_id, level_number = line.split("\t")
        study_plan_level_by_key[
            (unit_code, int(external_plan_id), int(level_number))
        ] = int(pid)

    where_clause = ""
    if term_external_keys:
        terms_sql = ", ".join(f"'{quote_literal(k)}'" for k in set(term_external_keys))
        where_clause = f"WHERE at.external_key = ANY(ARRAY[{terms_sql}]::TEXT[])"

    offering_by_key: dict[tuple[str, str, str, str], int] = {}
    for line in query_rows(
        db_url,
        f"""
        SELECT co.id, c.code, cp.code, au.code, at.external_key
        FROM public.course_offering co
        JOIN public.course c ON c.id = co.course_id
        JOIN public.campus cp ON cp.id = co.campus_id
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        JOIN public.academic_term at ON at.id = co.academic_term_id
        {where_clause}
        """,
    ):
        pid, course_code, campus_code, unit_code, external_key = line.split("\t")
        offering_by_key[(course_code, campus_code, unit_code, external_key)] = int(pid)


    group_by_key: dict[tuple[str, str, str, str, str], int] = {}
    for line in query_rows(
        db_url,
        f"""
        SELECT g.id, c.code, cp.code, au.code, at.external_key, g.group_code
        FROM public.course_offering_group g
        JOIN public.course_offering co ON co.id = g.course_offering_id
        JOIN public.course c ON c.id = co.course_id
        JOIN public.campus cp ON cp.id = co.campus_id
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        JOIN public.academic_term at ON at.id = co.academic_term_id
        {where_clause}
        """,
    ):
        pid, course_code, campus_code, unit_code, external_key, group_code = line.split(
            "\t"
        )
        group_by_key[
            (course_code, campus_code, unit_code, external_key, group_code)
        ] = int(pid)

    next_ids: dict[str, int] = {
        "country": max(country_by_iso.values(), default=0),
        "university": max(university_by_short_name.values(), default=0),
        "campus": max(campus_by_code.values(), default=0),
        "academic_unit": max(unit_by_code.values(), default=0),
        "academic_modality": max(modality_by_code.values(), default=0),
        "academic_term": max(term_by_external_key.values(), default=0),
        "course": max(course_by_code.values(), default=0),
        "professor": max(professor_by_name.values(), default=0),
        "study_plan": max(study_plan_by_key.values(), default=0),
        "study_plan_level": max(study_plan_level_by_key.values(), default=0),
        "course_offering": max(offering_by_key.values(), default=0),
        "course_offering_group": max(group_by_key.values(), default=0),
    }

    unit_campus_by_key: dict[tuple[str, str], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT auc.id, au.code, cp.code
        FROM public.academic_unit_campus auc
        JOIN public.academic_unit au ON au.id = auc.academic_unit_id
        JOIN public.campus cp ON cp.id = auc.campus_id
        """,
    ):
        pid, unit_code, campus_code = line.split("\t")
        unit_campus_by_key[(unit_code, campus_code)] = int(pid)
    next_ids["academic_unit_campus"] = max(unit_campus_by_key.values(), default=0)

    study_plan_campus_by_key: dict[tuple[str, int, str], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT spc.id, au.code, sp.external_plan_id, cp.code
        FROM public.study_plan_campus spc
        JOIN public.study_plan sp ON sp.id = spc.study_plan_id
        JOIN public.academic_unit au ON au.id = sp.academic_unit_id
        JOIN public.campus cp ON cp.id = spc.campus_id
        """,
    ):
        pid, unit_code, external_plan_id, campus_code = line.split("\t")
        study_plan_campus_by_key[(unit_code, int(external_plan_id), campus_code)] = int(
            pid
        )
    next_ids["study_plan_campus"] = max(study_plan_campus_by_key.values(), default=0)

    level_course_by_key: dict[tuple[str, int, int, str], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT splc.id, au.code, sp.external_plan_id, spl.level_number, c.code
        FROM public.study_plan_level_course splc
        JOIN public.study_plan_level spl ON spl.id = splc.study_plan_level_id
        JOIN public.study_plan sp ON sp.id = spl.study_plan_id
        JOIN public.academic_unit au ON au.id = sp.academic_unit_id
        JOIN public.course c ON c.id = splc.course_id
        """,
    ):
        pid, unit_code, external_plan_id, level_number, course_code = line.split("\t")
        level_course_by_key[
            (unit_code, int(external_plan_id), int(level_number), course_code)
        ] = int(pid)
    next_ids["study_plan_level_course"] = max(level_course_by_key.values(), default=0)

    relation_by_key: dict[tuple[str, int, str, str, str], int] = {}
    for line in query_rows(
        db_url,
        """
        SELECT cr.id, au.code, sp.external_plan_id, c_from.code, c_to.code, cr.relation_type::text
        FROM public.course_relation cr
        JOIN public.study_plan sp ON sp.id = cr.study_plan_id
        JOIN public.academic_unit au ON au.id = sp.academic_unit_id
        JOIN public.course c_from ON c_from.id = cr.from_course_id
        JOIN public.course c_to ON c_to.id = cr.to_course_id
        """,
    ):
        pid, unit_code, external_plan_id, from_code, to_code, relation_type = (
            line.split("\t")
        )
        relation_by_key[
            (unit_code, int(external_plan_id), from_code, to_code, relation_type)
        ] = int(pid)
    next_ids["course_relation"] = max(relation_by_key.values(), default=0)

    group_professor_by_key: dict[tuple[str, str, str, str, str, str], int] = {}
    for line in query_rows(
        db_url,
        f"""
        SELECT gp.id, c.code, cp.code, au.code, at.external_key, g.group_code, p.full_name
        FROM public.course_offering_group_professor gp
        JOIN public.course_offering_group g ON g.id = gp.course_offering_group_id
        JOIN public.professor p ON p.id = gp.professor_id
        JOIN public.course_offering co ON co.id = g.course_offering_id
        JOIN public.course c ON c.id = co.course_id
        JOIN public.campus cp ON cp.id = co.campus_id
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        JOIN public.academic_term at ON at.id = co.academic_term_id
        {where_clause}
        """,
    ):
        (
            pid,
            course_code,
            campus_code,
            unit_code,
            external_key,
            group_code,
            professor_name,
        ) = line.split("\t")
        group_professor_by_key[
            (
                course_code,
                campus_code,
                unit_code,
                external_key,
                group_code,
                professor_name,
            )
        ] = int(pid)
    next_ids["course_offering_group_professor"] = max(
        group_professor_by_key.values(), default=0
    )

    meeting_by_key: dict[tuple[str, str, str, str, str, int, str, str], int] = {}
    for line in query_rows(
        db_url,
        f"""
        SELECT m.id, c.code, cp.code, au.code, at.external_key, g.group_code, m.weekday, m.starts_at::text, m.ends_at::text
        FROM public.course_offering_meeting m
        JOIN public.course_offering_group g ON g.id = m.course_offering_group_id
        JOIN public.course_offering co ON co.id = g.course_offering_id
        JOIN public.course c ON c.id = co.course_id
        JOIN public.campus cp ON cp.id = co.campus_id
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        JOIN public.academic_term at ON at.id = co.academic_term_id
        {where_clause}
        """,
    ):
        (
            pid,
            course_code,
            campus_code,
            unit_code,
            external_key,
            group_code,
            weekday,
            starts_at,
            ends_at,
        ) = line.split("\t")
        meeting_by_key[
            (
                course_code,
                campus_code,
                unit_code,
                external_key,
                group_code,
                int(weekday),
                str(normalize_for_compare(starts_at, "TIME")),
                str(normalize_for_compare(ends_at, "TIME")),
            )
        ] = int(pid)
    next_ids["course_offering_meeting"] = max(meeting_by_key.values(), default=0)

    country_old_to_new: dict[int, int] = {}
    university_old_to_new: dict[int, int] = {}
    campus_old_to_new: dict[int, int] = {}
    unit_old_to_new: dict[int, int] = {}
    modality_old_to_new: dict[int, int] = {}
    term_old_to_new: dict[int, int] = {}
    course_old_to_new: dict[int, int] = {}
    professor_old_to_new: dict[int, int] = {}
    study_plan_old_to_new: dict[int, int] = {}
    study_plan_level_old_to_new: dict[int, int] = {}
    offering_old_to_new: dict[int, int] = {}
    group_old_to_new: dict[int, int] = {}

    study_plan_old_to_key: dict[int, tuple[str, int]] = {}
    for row in study_plans:
        old_unit_id = int(row["academic_unit_id"])
        unit_code = str(local_unit_by_id[old_unit_id]["code"])
        external_plan_id = int(row["external_plan_id"])
        study_plan_old_to_key[int(row["id"])] = (unit_code, external_plan_id)

    offering_old_to_key: dict[int, tuple[str, str, str, str]] = {}
    for row in offerings:
        course_code = str(local_course_by_id[int(row["course_id"])]["code"])
        campus_code = str(local_campus_by_id[int(row["campus_id"])]["code"])
        unit_code = str(local_unit_by_id[int(row["academic_unit_id"])]["code"])
        external_key = str(
            local_term_by_id[int(row["academic_term_id"])]["external_key"]
        )
        offering_old_to_key[int(row["id"])] = (
            course_code,
            campus_code,
            unit_code,
            external_key,
        )

    group_old_to_key: dict[int, tuple[str, str, str, str, str]] = {}
    for row in groups:
        old_offering_id = int(row["course_offering_id"])
        course_code, campus_code, unit_code, external_key = offering_old_to_key[
            old_offering_id
        ]
        group_old_to_key[int(row["id"])] = (
            course_code,
            campus_code,
            unit_code,
            external_key,
            str(row["group_code"]),
        )

    for row in countries:
        old_id = int(row["id"])
        key = str(row["iso2_code"])
        new_id = country_by_iso.get(key) or next_sequential_id(next_ids, "country")
        country_by_iso[key] = new_id
        row["id"] = new_id
        country_old_to_new[old_id] = new_id

    for row in universities:
        old_id = int(row["id"])
        key = str(row["short_name"])
        row["country_id"] = country_old_to_new[int(row["country_id"])]
        new_id = university_by_short_name.get(key) or next_sequential_id(
            next_ids, "university"
        )
        university_by_short_name[key] = new_id
        row["id"] = new_id
        university_old_to_new[old_id] = new_id

    for row in campuses:
        old_id = int(row["id"])
        key = str(row["code"])
        row["university_id"] = university_old_to_new[int(row["university_id"])]
        new_id = campus_by_code.get(key) or next_sequential_id(next_ids, "campus")
        campus_by_code[key] = new_id
        row["id"] = new_id
        campus_old_to_new[old_id] = new_id

    for row in units:
        old_id = int(row["id"])
        key = str(row["code"])
        row["university_id"] = university_old_to_new[int(row["university_id"])]
        new_id = unit_by_code.get(key) or next_sequential_id(next_ids, "academic_unit")
        unit_by_code[key] = new_id
        row["id"] = new_id
        unit_old_to_new[old_id] = new_id

    for row in modalities:
        old_id = int(row["id"])
        key = str(row["code"])
        new_id = modality_by_code.get(key) or next_sequential_id(
            next_ids, "academic_modality"
        )
        modality_by_code[key] = new_id
        row["id"] = new_id
        modality_old_to_new[old_id] = new_id

    for row in terms:
        old_id = int(row["id"])
        key = str(row["external_key"])
        row["academic_modality_id"] = modality_old_to_new[
            int(row["academic_modality_id"])
        ]
        new_id = term_by_external_key.get(key) or next_sequential_id(
            next_ids, "academic_term"
        )
        term_by_external_key[key] = new_id
        row["id"] = new_id
        term_old_to_new[old_id] = new_id

    for row in courses:
        old_id = int(row["id"])
        key = str(row["code"])
        new_id = course_by_code.get(key) or next_sequential_id(next_ids, "course")
        course_by_code[key] = new_id
        row["id"] = new_id
        course_old_to_new[old_id] = new_id

    for row in professors:
        old_id = int(row["id"])
        key = str(row["full_name"])
        new_id = professor_by_name.get(key) or next_sequential_id(next_ids, "professor")
        professor_by_name[key] = new_id
        row["id"] = new_id
        professor_old_to_new[old_id] = new_id

    for row in unit_campus:
        old_unit_id = int(row["academic_unit_id"])
        old_campus_id = int(row["campus_id"])
        row["academic_unit_id"] = unit_old_to_new[int(row["academic_unit_id"])]
        row["campus_id"] = campus_old_to_new[int(row["campus_id"])]
        key = (
            str(local_unit_by_id[old_unit_id]["code"]),
            str(local_campus_by_id[old_campus_id]["code"]),
        )
        new_id = unit_campus_by_key.get(key) or next_sequential_id(
            next_ids, "academic_unit_campus"
        )
        unit_campus_by_key[key] = new_id
        row["id"] = new_id

    for row in study_plans:
        old_id = int(row["id"])
        unit_code, external_plan_id = study_plan_old_to_key[old_id]
        row["academic_unit_id"] = unit_old_to_new[int(row["academic_unit_id"])]
        row["academic_modality_id"] = modality_old_to_new[
            int(row["academic_modality_id"])
        ]
        new_id = study_plan_by_key.get(
            (unit_code, external_plan_id)
        ) or next_sequential_id(next_ids, "study_plan")
        study_plan_by_key[(unit_code, external_plan_id)] = new_id
        row["id"] = new_id
        study_plan_old_to_new[old_id] = new_id

    for row in study_plan_campus:
        old_plan_id = int(row["study_plan_id"])
        old_campus_id = int(row["campus_id"])
        row["study_plan_id"] = study_plan_old_to_new[int(row["study_plan_id"])]
        row["campus_id"] = campus_old_to_new[int(row["campus_id"])]
        plan_key = study_plan_old_to_key[old_plan_id]
        campus_code = str(local_campus_by_id[old_campus_id]["code"])
        spc_key = (plan_key[0], plan_key[1], campus_code)
        new_spc_id = study_plan_campus_by_key.get(spc_key) or next_sequential_id(
            next_ids, "study_plan_campus"
        )
        study_plan_campus_by_key[spc_key] = new_spc_id
        row["id"] = new_spc_id

    for row in study_plan_levels:
        old_id = int(row["id"])
        old_plan_id = int(row["study_plan_id"])
        unit_code, external_plan_id = study_plan_old_to_key[old_plan_id]
        level_number = int(row["level_number"])
        row["_original_study_plan_id"] = old_plan_id
        row["study_plan_id"] = study_plan_old_to_new[old_plan_id]
        new_id = study_plan_level_by_key.get(
            (unit_code, external_plan_id, level_number)
        ) or next_sequential_id(next_ids, "study_plan_level")
        study_plan_level_by_key[(unit_code, external_plan_id, level_number)] = new_id
        row["id"] = new_id
        study_plan_level_old_to_new[old_id] = new_id

    for row in level_courses:
        old_level_id = int(row["study_plan_level_id"])
        old_course_id = int(row["course_id"])
        row["study_plan_level_id"] = study_plan_level_old_to_new[
            int(row["study_plan_level_id"])
        ]
        row["course_id"] = course_old_to_new[int(row["course_id"])]
        old_plan_id_for_level = int(
            local_study_plan_level_by_id[old_level_id]["_original_study_plan_id"]
        )
        unit_code, external_plan_id = study_plan_old_to_key[old_plan_id_for_level]
        level_number = int(local_study_plan_level_by_id[old_level_id]["level_number"])
        course_code = str(local_course_by_id[old_course_id]["code"])
        level_course_key = (unit_code, external_plan_id, level_number, course_code)
        level_course_id = level_course_by_key.get(
            level_course_key
        ) or next_sequential_id(next_ids, "study_plan_level_course")
        level_course_by_key[level_course_key] = level_course_id
        row["id"] = level_course_id

    for row in course_relations:
        old_plan_id = int(row["study_plan_id"])
        old_from_course_id = int(row["from_course_id"])
        old_to_course_id = int(row["to_course_id"])
        row["study_plan_id"] = study_plan_old_to_new[int(row["study_plan_id"])]
        row["from_course_id"] = course_old_to_new[int(row["from_course_id"])]
        row["to_course_id"] = course_old_to_new[int(row["to_course_id"])]
        plan_key = study_plan_old_to_key[old_plan_id]
        from_code = str(local_course_by_id[old_from_course_id]["code"])
        to_code = str(local_course_by_id[old_to_course_id]["code"])
        relation_key = (
            plan_key[0],
            plan_key[1],
            from_code,
            to_code,
            str(row["relation_type"]),
        )
        relation_id = relation_by_key.get(relation_key) or next_sequential_id(
            next_ids, "course_relation"
        )
        relation_by_key[relation_key] = relation_id
        row["id"] = relation_id

    for row in offerings:
        old_id = int(row["id"])
        course_code, campus_code, unit_code, external_key = offering_old_to_key[old_id]
        row["course_id"] = course_old_to_new[int(row["course_id"])]
        row["campus_id"] = campus_old_to_new[int(row["campus_id"])]
        row["academic_unit_id"] = unit_old_to_new[int(row["academic_unit_id"])]
        row["academic_term_id"] = term_old_to_new[int(row["academic_term_id"])]
        offering_key = (course_code, campus_code, unit_code, external_key)
        new_id = offering_by_key.get(offering_key) or next_sequential_id(
            next_ids, "course_offering"
        )
        offering_by_key[offering_key] = new_id
        row["id"] = new_id
        offering_old_to_new[old_id] = new_id

    for row in groups:
        old_id = int(row["id"])
        key = group_old_to_key[old_id]
        row["course_offering_id"] = offering_old_to_new[int(row["course_offering_id"])]
        new_id = group_by_key.get(key) or next_sequential_id(
            next_ids, "course_offering_group"
        )
        group_by_key[key] = new_id
        row["id"] = new_id
        group_old_to_new[old_id] = new_id

    for row in group_professors:
        old_group_id = int(row["course_offering_group_id"])
        old_professor_id = int(row["professor_id"])
        row["course_offering_group_id"] = group_old_to_new[
            int(row["course_offering_group_id"])
        ]
        row["professor_id"] = professor_old_to_new.get(
            int(row["professor_id"]), int(row["professor_id"])
        )
        group_key = group_old_to_key[old_group_id]
        professor_name = str(local_professor_by_id[old_professor_id]["full_name"])
        gp_key = (
            group_key[0],
            group_key[1],
            group_key[2],
            group_key[3],
            group_key[4],
            professor_name,
        )
        gp_id = group_professor_by_key.get(gp_key) or next_sequential_id(
            next_ids, "course_offering_group_professor"
        )
        group_professor_by_key[gp_key] = gp_id
        row["id"] = gp_id

    for row in meetings:
        old_group_id = int(row["course_offering_group_id"])
        row["course_offering_group_id"] = group_old_to_new[
            int(row["course_offering_group_id"])
        ]
        group_key = group_old_to_key[old_group_id]
        starts_at_norm = str(normalize_for_compare(row.get("starts_at"), "TIME"))
        ends_at_norm = str(normalize_for_compare(row.get("ends_at"), "TIME"))
        row["starts_at"] = starts_at_norm
        row["ends_at"] = ends_at_norm
        meeting_key = (
            group_key[0],
            group_key[1],
            group_key[2],
            group_key[3],
            group_key[4],
            int(row["weekday"]),
            starts_at_norm,
            ends_at_norm,
        )
        meeting_id = meeting_by_key.get(meeting_key) or next_sequential_id(
            next_ids, "course_offering_meeting"
        )
        meeting_by_key[meeting_key] = meeting_id
        row["id"] = meeting_id

    selected_tables = set(tables_to_write or SYNC_TABLES)
    for table, payload in tables.items():
        if table not in selected_tables:
            continue
        write_json(data_dir / table / "data.json", payload)


def run_command(command: list[str], cwd: Path) -> None:
    subprocess.run(command, cwd=cwd, check=True)


def run_sql_command(db_url: str, sql: str, cwd: Path) -> None:
    subprocess.run(
        ["psql", db_url, "-q", "-v", "ON_ERROR_STOP=1", "-c", sql],
        cwd=cwd,
        text=True,
        capture_output=True,
        check=True,
    )


def ledger_seed_exists(db_url: str, sha256: str) -> bool:
    rows = query_rows(
        db_url,
        "SELECT 1 FROM public.sync_seed_run "
        f"WHERE seed_sha256 = '{quote_literal(sha256)}' LIMIT 1",
    )
    return bool(rows)


def ledger_fingerprint_applied(
    db_url: str,
    scope: str,
    years: list[int],
    term_external_keys: list[str],
    fingerprint: str,
) -> bool:
    years_literal = "{" + ",".join(str(v) for v in years) + "}"
    terms_literal = "{" + ",".join(term_external_keys) + "}"
    sql = f"""
    SELECT 1
    FROM public.sync_seed_run
    WHERE status = 'applied'
      AND scope = '{quote_literal(scope)}'
      AND years = '{quote_literal(years_literal)}'::INTEGER[]
      AND term_external_keys = '{quote_literal(terms_literal)}'::TEXT[]
      AND metadata ->> 'sync_fingerprint' = '{quote_literal(fingerprint)}'
    LIMIT 1;
    """
    return bool(query_rows(db_url, sql))


def record_seed_generated(
    db_url: str,
    cwd: Path,
    file_name: str,
    sha256: str,
    scope: str,
    years: list[int],
    term_external_keys: list[str],
    generated_at_utc: datetime,
    metadata: dict[str, Any],
) -> None:
    metadata_json = json.dumps(metadata, ensure_ascii=False)
    sql = f"""
    INSERT INTO public.sync_seed_run (
      seed_file_name,
      seed_sha256,
      scope,
      years,
      term_external_keys,
      generated_at_utc,
      status,
      metadata
    )
    VALUES (
      '{quote_literal(file_name)}',
      '{quote_literal(sha256)}',
      '{quote_literal(scope)}',
      {sql_int_array(years)},
      {sql_text_array(term_external_keys)},
      '{generated_at_utc.isoformat()}',
      'generated',
      '{quote_literal(metadata_json)}'::jsonb
    )
    ON CONFLICT (seed_sha256) DO UPDATE
    SET
      seed_file_name = EXCLUDED.seed_file_name,
      scope = EXCLUDED.scope,
      years = EXCLUDED.years,
      term_external_keys = EXCLUDED.term_external_keys,
      status = 'generated',
      error_message = NULL,
      metadata = EXCLUDED.metadata,
      updated_at = NOW();
    """
    run_sql_command(db_url, sql, cwd)


def mark_seed_status(
    db_url: str,
    cwd: Path,
    sha256: str,
    status: str,
    error_message: str | None = None,
    applied_at_utc: datetime | None = None,
) -> None:
    applied_sql = "NULL"
    if applied_at_utc is not None:
        applied_sql = f"'{applied_at_utc.isoformat()}'"

    error_sql = "NULL"
    if error_message:
        error_sql = f"'{quote_literal(error_message[:4000])}'"

    sql = f"""
    UPDATE public.sync_seed_run
    SET
      status = '{quote_literal(status)}',
      error_message = {error_sql},
      applied_at_utc = {applied_sql},
      updated_at = NOW()
    WHERE seed_sha256 = '{quote_literal(sha256)}';
    """
    run_sql_command(db_url, sql, cwd)


def run_verification(db_url: str) -> None:
    subprocess.run(
        [
            "psql",
            db_url,
            "-P",
            "pager=off",
            "-c",
            """
            SELECT 'course' AS table_name, count(*) FILTER (WHERE is_active = true) AS active_rows FROM public.course
            UNION ALL SELECT 'study_plan', count(*) FILTER (WHERE is_active = true) FROM public.study_plan
            UNION ALL SELECT 'professor', count(*) FILTER (WHERE is_active = true) FROM public.professor
            UNION ALL SELECT 'course_offering', count(*) FILTER (WHERE is_active = true) FROM public.course_offering
            UNION ALL SELECT 'course_offering_group', count(*) FILTER (WHERE is_active = true) FROM public.course_offering_group;
            """,
        ],
        check=True,
    )


def collect_upsert_estimate(
    db_url: str,
    data_dir: Path,
    tables: list[str],
) -> dict[str, dict[str, int]]:
    estimates: dict[str, dict[str, int]] = {}
    for table in tables:
        data_path = data_dir / table / "data.json"
        if not data_path.exists():
            continue

        rows = load_json(data_path)
        payload_ids = {int(row["id"]) for row in rows if row.get("id") is not None}
        payload_count = len(rows)
        if payload_count == 0:
            estimates[table] = {
                "payload": 0,
                "insert_estimate": 0,
                "update_estimate": 0,
            }
            continue

        existing_rows = query_rows(db_url, f"SELECT id FROM public.{table}")
        existing_ids = {int(value) for value in existing_rows}
        insert_estimate = sum(1 for row_id in payload_ids if row_id not in existing_ids)
        update_estimate = max(payload_count - insert_estimate, 0)
        estimates[table] = {
            "payload": payload_count,
            "insert_estimate": insert_estimate,
            "update_estimate": update_estimate,
        }

    return estimates


def print_upsert_estimate(estimates: dict[str, dict[str, int]]) -> None:
    if not estimates:
        return

    typer.echo("Rough ID-based upsert estimate by table (before apply):")
    total_payload = 0
    total_inserts = 0
    total_updates = 0
    for table in SYNC_TABLES:
        table_stats = estimates.get(table)
        if not table_stats:
            continue
        payload = table_stats["payload"]
        insert_estimate = table_stats["insert_estimate"]
        update_estimate = table_stats["update_estimate"]
        total_payload += payload
        total_inserts += insert_estimate
        total_updates += update_estimate
        typer.echo(
            f"  - {table}: payload={payload}, id-new~{insert_estimate}, id-existing~{update_estimate}"
        )

    typer.echo(
        f"Rough totals: payload={total_payload}, id-new~{total_inserts}, id-existing~{total_updates}"
    )


def export_catalog_from_db(db_url: str, data_dir: Path) -> None:
    """Export catalog tables from DB to data/raw/ as JSON for offering processors."""
    typer.echo("Exporting catalog prerequisites from seed-history DB to JSON...")
    catalog_tables = tables_for_scope("catalog")
    if "professor" not in catalog_tables:
        catalog_tables.append("professor")

    for table in catalog_tables:
        sql = f"SELECT row_to_json(t) FROM public.{table} t;"
        try:
            output = subprocess.check_output(
                ["psql", db_url, "-At", "-c", sql],
                text=True,
            )
            rows = [json.loads(line) for line in output.splitlines() if line.strip()]
            out_path = data_dir / table / "data.json"
            write_json(out_path, rows)
        except Exception as exc:
            typer.echo(f"Warning: Failed to export {table} from DB: {exc}")

    # Export historical modalities by school
    sql = """
    SELECT json_build_object('school_code', au.code, 'modality_code', am.code)
    FROM (
        SELECT DISTINCT au.code, am.code
        FROM public.course_offering co
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        JOIN public.academic_term at ON at.id = co.academic_term_id
        JOIN public.academic_modality am ON am.id = at.academic_modality_id
        WHERE co.is_active = true
    ) t;
    """
    try:
        output = subprocess.check_output(
            ["psql", db_url, "-At", "-c", sql],
            text=True,
        )
        historical: dict[str, list[str]] = {}
        for line in output.splitlines():
            if not line.strip():
                continue
            data = json.loads(line)
            school_code = data.get("school_code")
            mod_code = data.get("modality_code")
            if school_code and mod_code:
                historical.setdefault(school_code, []).append(mod_code)

        out_path = data_dir / "academic_unit" / "historical_modalities.json"
        write_json(out_path, historical)
        typer.echo("Exported historical modalities mapping successfully.")
    except Exception as exc:
        typer.echo(f"Warning: Failed to export historical modalities from DB: {exc}")


def run_sync(
    data_dir: Path,
    target: str,
    db_url: str | None,
    env_file: Path,
    years: list[int],
    skip_pipeline: bool,
    skip_download: bool,
    apply_seed: bool,
    verify: bool,
    output: Path | None,
    keep_sql: bool,
    scope: str,
    seed_dir: Path,
    baseline_seed: str | None,
    seed_history_db_url: str,
    skip_migrations: bool = False,
) -> None:
    scope = normalize_scope(scope)
    scoped_tables = tables_for_scope(scope)
    resolved_db_url = resolve_db_url(target, db_url, env_file)
    year_list = sorted(set(years))
    tec_data_root = Path(__file__).resolve().parents[2]
    output_path: Path | None = None
    temp_db_name: str | None = None
    seed_history_container: str | None = None
    if output is not None:
        output_path = (
            output if output.is_absolute() else (tec_data_root / output).resolve()
        )

    root_dir = Path(__file__).resolve().parents[3]

    try:
        if target == "seed-history":
            seed_dir_resolved = (
                seed_dir
                if seed_dir.is_absolute()
                else (tec_data_root / seed_dir).resolve()
            )
            seed_paths = collect_seed_history(
                seed_dir_resolved, baseline_seed=baseline_seed
            )
            typer.echo(f"Building local state from {len(seed_paths)} seed files...")
            migrations_dir = root_dir / "migrations"
            resolved_db_url = seed_history_db_url
            if not os.environ.get("GITHUB_ACTIONS"):
                typer.echo(
                    "Starting ephemeral Postgres Docker container for seed-history..."
                )
                seed_history_container, resolved_db_url = (
                    _start_seed_history_postgres_container()
                )
            temp_db_name, resolved_db_url = create_temp_seed_history_db(
                seed_paths,
                db_url=resolved_db_url,
                migrations_dir=migrations_dir,
                skip_migrations=skip_migrations,
            )

            if scope == "offering":
                export_catalog_from_db(resolved_db_url, data_dir)

        if not skip_pipeline:
            pipeline_mode = "process-only" if skip_download else "download+process"
            typer.echo(
                f"Running full tec-data pipeline ({pipeline_mode}) for years={year_list}..."
            )
            run_sync_pipeline(data_dir, year_list, scope=scope, skip_download=skip_download)

        backup_dir = backup_data_files(data_dir, scoped_tables)
        # Seed history setup moved above

        term_external_keys = collect_term_external_keys(data_dir, year_list)
        typer.echo("Remapping IDs against destination DB...")
        remap_all_ids_to_db(
            resolved_db_url, 
            data_dir, 
            tables_to_write=scoped_tables,
            term_external_keys=term_external_keys
        )
        environment_id = infer_environment_id(resolved_db_url)
        sync_fingerprint = compute_sync_fingerprint(data_dir, scoped_tables)
        fingerprint_already_applied = ledger_fingerprint_applied(
            resolved_db_url,
            scope=scope,
            years=year_list,
            term_external_keys=term_external_keys,
            fingerprint=sync_fingerprint,
        )
        if fingerprint_already_applied:
            typer.echo(
                "No data changes detected versus latest applied fingerprint. Generating NOOP audit seed."
            )

        typer.echo("Generating minimal delta seed SQL...")
        generated_at_utc = datetime.now(UTC)
        output_path = output_path or (
            Path("../seeds/itcr")
            / f"seed_{datetime.now(UTC).strftime('%Y%m%dT%H%M%SZ')}.sql"
        )
        if fingerprint_already_applied:
            output_path, table_stats = write_noop_seed(
                output_path=output_path,
                environment_id=environment_id,
                years=year_list,
                term_external_keys=term_external_keys,
                fingerprint=sync_fingerprint,
                scope=scope,
            )
            is_noop = True
        else:
            output_path, table_stats, is_noop = generate_minimal_delta_seed(
                db_url=resolved_db_url,
                data_dir=data_dir,
                output_path=output_path,
                years=year_list,
                term_external_keys=term_external_keys,
                environment_id=environment_id,
                fingerprint=sync_fingerprint,
                scope=scope,
            )
        if not output_path.is_absolute():
            output_path = (tec_data_root / output_path).resolve()

        manifest_path = output_path.with_suffix(".json")
        manifest_payload = {
            "seed_file": output_path.name,
            "generated_at_utc": generated_at_utc.isoformat(),
            "scope": scope,
            "years": year_list,
            "term_external_keys": term_external_keys,
            "environment_id": environment_id,
            "data_fingerprint": sync_fingerprint,
            "table_stats": table_stats,
            "noop": is_noop,
        }
        manifest_path.write_text(
            json.dumps(manifest_payload, indent=2, ensure_ascii=False), encoding="utf-8"
        )
        typer.echo(f"Generated manifest: {manifest_path}")
        typer.echo(f"Generated {output_path}")

        sha256 = seed_sha256(output_path)
        metadata = {
            "generator": "tec-data sync",
            "target": target,
            "data_dir": str(data_dir),
            "years": year_list,
            "sync_fingerprint": sync_fingerprint,
            "environment_id": environment_id,
            "table_stats": table_stats,
            "noop": is_noop,
        }
        typer.echo("Delta stats by table:")
        for table in scoped_tables:
            stats = table_stats.get(table)
            if not stats:
                continue
            typer.echo(
                f"  - {table}: inserted={stats['inserted']}, updated={stats['updated']}, soft_deleted={stats['soft_deleted']}"
            )

        if target == "seed-history":
            typer.echo("Skipping sync_seed_run ledger writes for seed-history target.")
        else:
            if ledger_seed_exists(resolved_db_url, sha256):
                typer.echo(
                    "Seed already tracked by ledger (same SHA256), marking as skipped."
                )
                record_seed_generated(
                    db_url=resolved_db_url,
                    cwd=root_dir,
                    file_name=output_path.name,
                    sha256=sha256,
                    scope=scope,
                    years=year_list,
                    term_external_keys=term_external_keys,
                    generated_at_utc=generated_at_utc,
                    metadata=metadata,
                )
                mark_seed_status(
                    db_url=resolved_db_url,
                    cwd=root_dir,
                    sha256=sha256,
                    status="skipped_duplicate",
                )
                apply_seed = False
            else:
                record_seed_generated(
                    db_url=resolved_db_url,
                    cwd=root_dir,
                    file_name=output_path.name,
                    sha256=sha256,
                    scope=scope,
                    years=year_list,
                    term_external_keys=term_external_keys,
                    generated_at_utc=generated_at_utc,
                    metadata=metadata,
                )

        if is_noop and target != "seed-history":
            mark_seed_status(
                db_url=resolved_db_url,
                cwd=root_dir,
                sha256=sha256,
                status="skipped_duplicate",
            )

        if is_noop:
            apply_seed = False

        if apply_seed:
            meta = parse_seed_metadata(output_path)
            file_environment_id = meta.get("environment_id")
            if not file_environment_id:
                raise RuntimeError(
                    "Generated seed is missing strict environment metadata"
                )
            if file_environment_id != environment_id:
                raise RuntimeError(
                    "Seed environment mismatch: "
                    f"file={file_environment_id} destination={environment_id}"
                )
            typer.echo("Applying seed to destination DB...")
            try:
                subprocess.run(
                    [
                        "psql",
                        resolved_db_url,
                        "-q",
                        "-v",
                        "ON_ERROR_STOP=1",
                        "-f",
                        str(output_path),
                    ],
                    cwd=root_dir,
                    text=True,
                    capture_output=True,
                    check=True,
                )
                if target != "seed-history":
                    mark_seed_status(
                        db_url=resolved_db_url,
                        cwd=root_dir,
                        sha256=sha256,
                        status="applied",
                        applied_at_utc=datetime.now(UTC),
                    )
                typer.echo("Seed apply completed successfully.")
            except subprocess.CalledProcessError as exc:
                if target != "seed-history":
                    mark_seed_status(
                        db_url=resolved_db_url,
                        cwd=root_dir,
                        sha256=sha256,
                        status="failed",
                        error_message=(exc.stderr or str(exc)),
                    )
                if exc.stderr:
                    typer.echo(exc.stderr.strip())
                raise

        if verify and apply_seed:
            typer.echo("Running post-sync verification queries...")
            run_verification(resolved_db_url)
    finally:
        restore_data_files(data_dir, backup_dir)
        shutil.rmtree(backup_dir, ignore_errors=True)
        if temp_db_name is not None:
            drop_temp_seed_history_db(temp_db_name)
        if seed_history_container is not None:
            _stop_seed_history_postgres_container(seed_history_container)
        if not keep_sql and output_path is not None and output_path.exists():
            output_path.unlink()


app = typer.Typer(pretty_exceptions_show_locals=False)


@app.command("sync")
def sync_cmd(
    data_dir: Path = typer.Option(
        Path("data/raw"), "--data-dir", "-d", help="Data directory for processed files"
    ),
    target: str = typer.Option(
        "local",
        "--target",
        help="Destination target: local, remote, db-url, seed-history",
    ),
    db_url: str | None = typer.Option(
        None, "--db-url", help="Destination Postgres URL (required for target=db-url)"
    ),
    env_file: Path = typer.Option(
        Path("../../.env.prod"),
        "--env-file",
        help="Env file used when target=remote (default: ../../.env.prod)",
    ),
    years: str = typer.Option(
        "2026", "--years", "-y", help="Comma-separated years for offering sync"
    ),
    skip_pipeline: bool = typer.Option(
        False,
        "--skip-pipeline",
        help="Skip download/process pipeline and reuse current data/raw",
    ),
    skip_download: bool = typer.Option(
        False,
        "--skip-download",
        help="Run process steps only, reusing previously downloaded raw files",
    ),
    apply_seed: bool = typer.Option(
        True,
        "--apply/--no-apply",
        help="Apply generated SQL seed",
    ),
    verify: bool = typer.Option(
        True,
        "--verify/--no-verify",
        help="Run verification queries after apply",
    ),
    output: Path | None = typer.Option(
        None,
        "--output",
        "-o",
        help="Output SQL path (defaults to timestamped seed in ../seeds/itcr)",
    ),
    keep_sql: bool = typer.Option(
        True,
        "--keep-sql",
        help="Keep generated SQL file after command finishes",
    ),
    scope: str = typer.Option(
        "all",
        "--scope",
        help="Data scope: catalog, offering, all",
    ),
    seed_dir: Path = typer.Option(
        Path("../seeds/itcr"),
        "--seed-dir",
        help="Directory with seed_*.sql history for target=seed-history",
    ),
    baseline_seed: str | None = typer.Option(
        None,
        "--baseline-seed",
        help="Baseline seed filename in --seed-dir to start replay from",
    ),
    seed_history_db_url: str = typer.Option(
        SEED_HISTORY_SERVICE_DB_URL,
        "--seed-history-db-url",
        help="Postgres URL used by target=seed-history (typically a GitHub service container)",
    ),
    skip_migrations: bool = typer.Option(
        False,
        "--skip-migrations",
        help="Skip applying migrations and bootstrap SQL to the seed history database",
    ),
) -> None:
    """Run a full idempotent synchronization against local or remote DB."""
    year_list = [int(value.strip()) for value in years.split(",") if value.strip()]
    if not year_list:
        raise typer.BadParameter("--years must include at least one year")

    run_sync(
        data_dir=data_dir,
        target=target,
        db_url=db_url,
        env_file=env_file,
        years=year_list,
        skip_pipeline=skip_pipeline,
        skip_download=skip_download,
        apply_seed=apply_seed,
        verify=verify,
        output=output,
        keep_sql=keep_sql,
        scope=scope,
        seed_dir=seed_dir,
        baseline_seed=baseline_seed,
        seed_history_db_url=seed_history_db_url,
        skip_migrations=skip_migrations,
    )
