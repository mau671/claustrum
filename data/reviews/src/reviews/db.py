from __future__ import annotations

import json
import os
import re
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from .paths import (
    COURSE_DECISIONS_PATH,
    COURSE_FAMILY_DECISIONS_PATH,
    COURSE_VARIATIONS_PATH,
    WORKSPACE_ROOT,
)

LOCAL_DB_URL = "postgresql://postgres:postgres@127.0.0.1:54322/postgres"

ENV_FILE_CANDIDATES = (
    WORKSPACE_ROOT / ".env.dev",
    WORKSPACE_ROOT / ".env",
    WORKSPACE_ROOT / ".env.prod",
)


def load_env_file(path: Path) -> None:
    if not path.exists():
        return
    for line in path.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or "=" not in stripped:
            continue
        key, value = stripped.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def resolve_database_url() -> str:
    """Resolve the Postgres URL used to read the catalog.

    `DATABASE_URL` wins so CI and explicit overrides work; otherwise the
    workspace env files are loaded in order of preference and the local
    compose Postgres is used as a last resort.
    """
    explicit = os.environ.get("DATABASE_URL") or os.environ.get("LOCAL_DB_URL")
    if explicit:
        return explicit

    for candidate in ENV_FILE_CANDIDATES:
        load_env_file(candidate)
        resolved = os.environ.get("DATABASE_URL") or os.environ.get("LOCAL_DB_URL")
        if resolved:
            return resolved

    return LOCAL_DB_URL


def query_database(query: str) -> list[dict[str, Any]]:
    """Run a read-only query and return the rows as dictionaries.

    Uses `psql` directly against `DATABASE_URL`; there is no Supabase CLI or
    local Supabase stack involved anymore. The query is wrapped in
    `json_agg(row_to_json(...))` so psql only has to return a single JSON array
    and column typing/escaping stays in Postgres.
    """
    db_url = resolve_database_url()
    wrapped = (
        "SELECT COALESCE(json_agg(row_to_json(q)), '[]'::json)::text "
        f"FROM ({query.rstrip().rstrip(';')}) AS q;"
    )
    conn_args, conn_env = psql_connection_args(db_url)
    try:
        result = subprocess.run(
            [*conn_args, "-A", "-t", "-v", "ON_ERROR_STOP=1", "-c", wrapped],
            check=True,
            capture_output=True,
            text=True,
            env=conn_env,
        )
    except FileNotFoundError as error:
        raise RuntimeError(
            "`psql` was not found in PATH. Install the PostgreSQL client "
            "(for example `psql` from postgresql-client) and try again."
        ) from error
    except subprocess.CalledProcessError as error:
        detail = redact_db_url(
            (error.stderr or error.stdout or "").strip() or str(error)
        )
        raise RuntimeError(
            "Could not query the catalog database.\n"
            f"URL: {mask_database_url(db_url)}\n"
            "Start the local database with `pnpm run db:start` from the project root "
            "and make sure `DATABASE_URL` points to it.\n\n"
            f"psql output:\n{detail}"
        ) from error

    payload = result.stdout.strip()
    if not payload:
        return []
    parsed = json.loads(payload)
    if isinstance(parsed, list):
        return [row for row in parsed if isinstance(row, dict)]
    return []


def resolve_psql_binary() -> str:
    """Prefer `psql` from PATH, falling back to the compose container."""
    configured = os.environ.get("PSQL_BINARY")
    if configured:
        return configured
    return "psql"


def psql_connection_args(db_url: str) -> tuple[list[str], dict[str, str]]:
    """Build psql connection flags without putting credentials in `argv`.

    Arguments are visible through `ps` and, worse, end up inside
    `str(CalledProcessError)`. Shipping the password through `PGPASSWORD`
    keeps it out of both.
    """
    from urllib.parse import unquote, urlparse

    parsed = urlparse(db_url)
    args = [resolve_psql_binary(), "-X"]
    env = dict(os.environ)
    env.pop("PGPASSWORD", None)

    if parsed.hostname:
        args += ["-h", parsed.hostname]
    if parsed.port:
        args += ["-p", str(parsed.port)]
    if parsed.username:
        args += ["-U", unquote(parsed.username)]
    args += ["-d", (parsed.path or "/postgres").lstrip("/") or "postgres"]

    if parsed.password:
        env["PGPASSWORD"] = unquote(parsed.password)
    for pair in parsed.query.split("&"):
        key, _, value = pair.partition("=")
        if key.lower() == "sslmode":
            env["PGSSLMODE"] = value
    return args, env


def redact_db_url(text: str) -> str:
    """Strip credentials from anything that may be logged or persisted."""
    return re.sub(
        r"(postgres(?:ql)?://[^:/@\s]+:)[^@\s]+(@)",
        r"\1***\2",
        text,
    )


def mask_database_url(db_url: str) -> str:
    from urllib.parse import urlparse

    parsed = urlparse(db_url)
    if not parsed.password:
        return db_url
    netloc = f"{parsed.username}:***@{parsed.hostname}"
    if parsed.port:
        netloc = f"{netloc}:{parsed.port}"
    return parsed._replace(netloc=netloc).geturl()


def load_professor_courses() -> dict[int, list[dict[str, Any]]]:
    rows = query_rows(
        """
        SELECT cogp.professor_id, c.id AS course_id, c.code, c.name
        FROM public.course c
        JOIN public.course_offering co ON co.course_id = c.id
        JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
        JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
        WHERE co.is_active AND cog.is_active AND cogp.is_active
        GROUP BY cogp.professor_id, c.id, c.code, c.name
        ORDER BY cogp.professor_id, c.code, c.name
        """
    )
    courses_by_professor: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for row in rows:
        courses_by_professor[int(row["professor_id"])].append(row)
    return courses_by_professor


def load_professors(*, only_active: bool = True) -> list[dict[str, Any]]:
    where = "WHERE is_active = true" if only_active else ""
    rows = query_rows(f"SELECT id, full_name FROM public.professor {where} ORDER BY id")
    return [{"id": int(row["id"]), "full_name": str(row["full_name"])} for row in rows]


def load_all_courses() -> list[dict[str, Any]]:
    rows = query_rows(
        "SELECT id AS course_id, code, name, EXISTS("
        "SELECT 1 FROM public.course_offering co WHERE co.course_id = c.id AND co.is_active"
        ") AS has_offerings FROM public.course c ORDER BY code, name"
    )
    return [
        {
            "course_id": int(row["course_id"]),
            "code": str(row["code"]),
            "name": str(row["name"]),
            "has_offerings": bool(row.get("has_offerings")),
        }
        for row in rows
    ]


def load_course_prefix_affinity(
    courses_by_professor: dict[int, list[dict[str, Any]]],
) -> dict[int, Counter[str]]:
    professor_prefixes: dict[int, set[str]] = {}
    affinity: dict[int, Counter[str]] = defaultdict(Counter)
    for professor_id, courses in courses_by_professor.items():
        prefixes = {
            match.group(0)
            for course in courses
            if (match := re.match(r"[A-Z]+", str(course.get("code") or ""))) is not None
        }
        professor_prefixes[professor_id] = {prefix for prefix in prefixes if prefix}
    for professor_id, courses in courses_by_professor.items():
        for course in courses:
            course_id = int(course["course_id"])
            affinity[course_id].update(professor_prefixes[professor_id])
    return affinity


def get_existing_import_keys(professor_id: int) -> set[str]:
    """Collect import keys already emitted for a professor.

    Reads the SQL seed history and, when a database is reachable, the live
    `professor_review.import_key` values. The DB lookup keeps idempotency
    working when the local SQL history has been pruned or moved.
    """
    from .paths import PROCESSED_ROOT, SEED_REVIEWS_ROOT

    keys: set[str] = set()

    for sql_dir in (SEED_REVIEWS_ROOT, PROCESSED_ROOT / "sql"):
        if not sql_dir.exists():
            continue
        for sql_file in sql_dir.glob(f"*_{professor_id}.sql"):
            content = sql_file.read_text(encoding="utf-8")
            keys.update(re.findall(r"'([a-f0-9]{64})'::TEXT", content))

    try:
        rows = query_rows(
            "SELECT import_key FROM public.professor_review "
            f"WHERE professor_id = {int(professor_id)} AND import_key IS NOT NULL"
        )
    except RuntimeError:
        return keys

    keys.update(str(row["import_key"]) for row in rows)
    return keys


def query_rows(query: str) -> list[dict[str, Any]]:
    return query_database(query)


def load_json_dict(path: Path) -> dict[str, dict[str, Any]]:
    if not path.exists():
        return {}
    data = json.loads(path.read_text())
    if not isinstance(data, dict):
        return {}
    return {str(key): value for key, value in data.items() if isinstance(value, dict)}


def load_course_decisions() -> dict[str, dict[str, Any]]:
    return load_json_dict(COURSE_DECISIONS_PATH)


def load_course_variations() -> dict[str, dict[str, Any]]:
    return load_json_dict(COURSE_VARIATIONS_PATH)


def load_course_family_decisions() -> dict[str, dict[str, Any]]:
    return load_json_dict(COURSE_FAMILY_DECISIONS_PATH)


def save_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=True, indent=2) + "\n")
