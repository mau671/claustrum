"""Pure helper utilities for sync command internals."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Any

from src.shared.scope import normalize_scope

LOCAL_DB_URL = "postgresql://postgres:postgres@127.0.0.1:54322/postgres"

SYNC_TABLES = [
    "country",
    "university",
    "campus",
    "academic_unit",
    "academic_modality",
    "academic_term",
    "academic_unit_campus",
    "study_plan",
    "study_plan_campus",
    "study_plan_level",
    "course",
    "study_plan_level_course",
    "course_relation",
    "professor",
    "course_offering",
    "course_offering_group",
    "course_offering_group_professor",
    "course_offering_meeting",
]

OFFERING_TABLES = {
    "course_offering",
    "course_offering_group",
    "course_offering_group_professor",
    "course_offering_meeting",
}


def tables_for_scope(scope: str) -> list[str]:
    normalized = normalize_scope(scope)
    if normalized == "all":
        return list(SYNC_TABLES)
    if normalized == "catalog":
        return [
            table
            for table in SYNC_TABLES
            if table not in {"professor", *OFFERING_TABLES}
        ]
    # Include "course" so that names updated by the offering processor
    # (when a course has name == code) are propagated to the DB.
    # Soft-deletes for course are blocked by the scope != "offering" guard
    # in generate_minimal_delta_seed, so only INSERTs/UPDATEs apply.
    offering_with_dependencies = {"professor", "course", *OFFERING_TABLES}
    return [table for table in SYNC_TABLES if table in offering_with_dependencies]


def next_sequential_id(state: dict[str, int], table: str) -> int:
    """Return next positive sequential BIGINT id for a table."""
    state[table] = state.get(table, 0) + 1
    return state[table]


def quote_literal(value: str) -> str:
    return value.replace("'", "''")


def sql_int_array(values: list[int]) -> str:
    if not values:
        return "ARRAY[]::INTEGER[]"
    return "ARRAY[" + ", ".join(str(v) for v in values) + "]::INTEGER[]"


def sql_text_array(values: list[str]) -> str:
    if not values:
        return "ARRAY[]::TEXT[]"
    escaped = ", ".join(f"'{quote_literal(v)}'" for v in values)
    return f"ARRAY[{escaped}]::TEXT[]"


def seed_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def load_json(path: Path) -> list[dict[str, Any]]:
    return json.loads(path.read_text())


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False))


def compute_sync_fingerprint(data_dir: Path, tables: list[str]) -> str:
    hasher = hashlib.sha256()
    for table in tables:
        data_path = data_dir / table / "data.json"
        if not data_path.exists():
            continue
        payload = load_json(data_path)
        canonical_rows = sorted(canonical_json(row) for row in payload)
        hasher.update(table.encode("utf-8"))
        hasher.update(b"\n")
        for row in canonical_rows:
            hasher.update(row.encode("utf-8"))
            hasher.update(b"\n")
    return hasher.hexdigest()


def collect_term_external_keys(data_dir: Path, years: list[int]) -> list[str]:
    term_path = data_dir / "academic_term" / "data.json"
    if not term_path.exists():
        return []
    terms = load_json(term_path)
    year_set = set(years)
    return sorted(
        {
            str(term["external_key"])
            for term in terms
            if int(term.get("year", 0)) in year_set and term.get("external_key")
        }
    )


def build_db_url_from_env(env_file: Path) -> str:
    env_content = env_file.read_text()
    match_url = re.search(r"^VITE_SUPABASE_URL=(.+)$", env_content, flags=re.M)
    match_password = re.search(r"^SUPABASE_PASSWORD=(.+)$", env_content, flags=re.M)
    if not match_url or not match_password:
        raise ValueError(
            f"Missing VITE_SUPABASE_URL or SUPABASE_PASSWORD in {env_file}"
        )

    supabase_url = match_url.group(1).strip()
    password = match_password.group(1).strip()
    project_ref = re.sub(r"^https://([^.]+)\.supabase\.co$", r"\1", supabase_url)
    return (
        f"postgresql://postgres:{password}@db.{project_ref}.supabase.co:5432/"
        "postgres?sslmode=require"
    )


def resolve_db_url(target: str, db_url: str | None, env_file: Path) -> str:
    if target == "local":
        return LOCAL_DB_URL
    if target == "remote":
        return build_db_url_from_env(env_file)
    if target == "seed-history":
        return LOCAL_DB_URL
    if not db_url:
        raise ValueError("--db-url is required when --target=db-url")
    return db_url


def parse_seed_timestamp(path: Path) -> str:
    match = re.match(r"^seed_(\d{8}T\d{6}Z)(?:_.*)?\.sql$", path.name)
    if not match:
        raise ValueError(f"Invalid seed filename format: {path.name}")
    return match.group(1)


def collect_seed_history(
    seed_dir: Path, baseline_seed: str | None = None
) -> list[Path]:
    candidates = [p for p in seed_dir.glob("seed_*.sql") if p.is_file()]
    if not candidates:
        raise ValueError(f"No seed_*.sql files found in {seed_dir}")

    ordered = sorted(candidates, key=parse_seed_timestamp)
    if baseline_seed is None:
        return ordered

    baseline_path = seed_dir / baseline_seed
    if baseline_path not in ordered:
        raise ValueError(f"Baseline seed not found in {seed_dir}: {baseline_seed}")
    baseline_idx = ordered.index(baseline_path)
    return ordered[baseline_idx:]


def infer_environment_id(db_url: str) -> str:
    from urllib.parse import urlparse

    parsed = urlparse(db_url)
    host = parsed.hostname or "unknown-host"
    db_name = (parsed.path or "/postgres").lstrip("/") or "postgres"
    project_ref = ""
    match = re.match(r"^db\.([^.]+)\.supabase\.co$", host)
    if match:
        project_ref = match.group(1)
    if project_ref:
        return f"{project_ref}|{host}|{db_name}"
    return f"{host}|{db_name}"


def parse_seed_metadata(seed_path: Path) -> dict[str, str]:
    metadata: dict[str, str] = {}
    with seed_path.open(encoding="utf-8") as handle:
        for _ in range(80):
            line = handle.readline()
            if not line:
                break
            if not line.startswith("-- TEC-DATA-META "):
                continue
            payload = line.removeprefix("-- TEC-DATA-META ").strip()
            if "=" not in payload:
                continue
            key, value = payload.split("=", 1)
            metadata[key.strip()] = value.strip()
    return metadata
