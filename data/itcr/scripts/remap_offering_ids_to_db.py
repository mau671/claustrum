#!/usr/bin/env python3

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


def deterministic_id(namespace: str, *parts: object) -> int:
    raw = f"{namespace}|" + "|".join(str(part).strip().upper() for part in parts)
    digest = hashlib.blake2b(raw.encode("utf-8"), digest_size=8).digest()
    identifier = int.from_bytes(digest, "big") & ((1 << 63) - 1)
    return identifier or 1


def query_rows(db_url: str, sql: str) -> list[str]:
    output = subprocess.check_output(
        ["psql", db_url, "-At", "-F", "\t", "-c", sql],
        text=True,
    )
    return [line for line in output.splitlines() if line.strip()]


def load_json(path: Path):
    return json.loads(path.read_text())


def build_id_map(rows: list[dict], id_key: str, natural_key: str) -> dict[int, str]:
    return {int(row[id_key]): str(row[natural_key]) for row in rows}


def require_mapping(mapping: dict[str, int], key: str, entity: str) -> int:
    if key not in mapping:
        raise ValueError(f"Missing {entity} in target DB for natural key: {key}")
    return mapping[key]


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Remap offering data IDs against target DB catalog IDs and recompute deterministic IDs."
    )
    parser.add_argument(
        "--db-url", required=True, help="Target Postgres connection URL"
    )
    parser.add_argument(
        "--data-root",
        default="data/raw",
        help="Path to tec-data raw directory (default: data/raw)",
    )
    args = parser.parse_args()

    data_root = Path(args.data_root)
    paths = {
        "course": data_root / "course" / "data.json",
        "campus": data_root / "campus" / "data.json",
        "unit": data_root / "academic_unit" / "data.json",
        "term": data_root / "academic_term" / "data.json",
        "prof": data_root / "professor" / "data.json",
        "off": data_root / "course_offering" / "data.json",
        "grp": data_root / "course_offering_group" / "data.json",
        "gp": data_root / "course_offering_group_professor" / "data.json",
        "meet": data_root / "course_offering_meeting" / "data.json",
    }

    for name, path in paths.items():
        if not path.exists():
            raise FileNotFoundError(f"Missing required file for {name}: {path}")

    local_course = load_json(paths["course"])
    local_campus = load_json(paths["campus"])
    local_unit = load_json(paths["unit"])
    local_term = load_json(paths["term"])
    prof = load_json(paths["prof"])
    off = load_json(paths["off"])
    grp = load_json(paths["grp"])
    gp = load_json(paths["gp"])
    meet = load_json(paths["meet"])

    local_course_code = build_id_map(local_course, "id", "code")
    local_campus_code = build_id_map(local_campus, "id", "code")
    local_unit_code = build_id_map(local_unit, "id", "code")
    local_term_key = build_id_map(local_term, "id", "external_key")

    db_url = args.db_url
    prod_course_id_by_code = {
        code: int(pid)
        for pid, code in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.course")
        )
    }
    prod_campus_id_by_code = {
        code: int(pid)
        for pid, code in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.campus")
        )
    }
    prod_unit_id_by_code = {
        code: int(pid)
        for pid, code in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, code FROM public.academic_unit")
        )
    }
    prod_term_id_by_key = {
        key: int(pid)
        for pid, key in (
            line.split("\t", 1)
            for line in query_rows(
                db_url, "SELECT id, external_key FROM public.academic_term"
            )
        )
    }
    prod_professor_id_by_name = {
        name: int(pid)
        for pid, name in (
            line.split("\t", 1)
            for line in query_rows(db_url, "SELECT id, full_name FROM public.professor")
        )
    }

    professor_old_to_new: dict[int, int] = {}
    for row in prof:
        old_id = int(row["id"])
        full_name = str(row["full_name"])
        new_id = prod_professor_id_by_name.get(full_name)
        if new_id is None:
            new_id = deterministic_id("professor", full_name)
        row["id"] = new_id
        professor_old_to_new[old_id] = new_id

    offering_old_to_new: dict[int, int] = {}
    for row in off:
        old_id = int(row["id"])

        local_course_id = int(row["course_id"])
        local_campus_id = int(row["campus_id"])
        local_unit_id = int(row["academic_unit_id"])
        local_term_id = int(row["academic_term_id"])

        course_code = local_course_code[local_course_id]
        campus_code = local_campus_code[local_campus_id]
        unit_code = local_unit_code[local_unit_id]
        term_key = local_term_key[local_term_id]

        row["course_id"] = require_mapping(
            prod_course_id_by_code, course_code, "course"
        )
        row["campus_id"] = require_mapping(
            prod_campus_id_by_code, campus_code, "campus"
        )
        row["academic_unit_id"] = require_mapping(
            prod_unit_id_by_code, unit_code, "academic_unit"
        )
        row["academic_term_id"] = require_mapping(
            prod_term_id_by_key, term_key, "academic_term"
        )

        new_id = deterministic_id(
            "course_offering",
            row["course_id"],
            row["campus_id"],
            row["academic_unit_id"],
            row["academic_term_id"],
        )
        row["id"] = new_id
        offering_old_to_new[old_id] = new_id

    group_old_to_new: dict[int, int] = {}
    for row in grp:
        old_id = int(row["id"])
        new_offering_id = offering_old_to_new[int(row["course_offering_id"])]
        row["course_offering_id"] = new_offering_id

        new_id = deterministic_id(
            "course_offering_group", new_offering_id, row["group_code"]
        )
        row["id"] = new_id
        group_old_to_new[old_id] = new_id

    for row in gp:
        group_id = group_old_to_new[int(row["course_offering_group_id"])]
        professor_id = professor_old_to_new.get(
            int(row["professor_id"]), int(row["professor_id"])
        )
        row["course_offering_group_id"] = group_id
        row["professor_id"] = professor_id
        row["id"] = deterministic_id(
            "course_offering_group_professor", group_id, professor_id
        )

    for row in meet:
        group_id = group_old_to_new[int(row["course_offering_group_id"])]
        weekday = int(row["weekday"])
        starts_at = row["starts_at"]
        ends_at = row["ends_at"]
        row["course_offering_group_id"] = group_id
        row["id"] = deterministic_id(
            "course_offering_meeting", group_id, weekday, starts_at, ends_at
        )

    paths["prof"].write_text(json.dumps(prof, indent=2, ensure_ascii=False))
    paths["off"].write_text(json.dumps(off, indent=2, ensure_ascii=False))
    paths["grp"].write_text(json.dumps(grp, indent=2, ensure_ascii=False))
    paths["gp"].write_text(json.dumps(gp, indent=2, ensure_ascii=False))
    paths["meet"].write_text(json.dumps(meet, indent=2, ensure_ascii=False))

    print(
        "Remap complete:",
        f"professors={len(prof)}",
        f"offerings={len(off)}",
        f"groups={len(grp)}",
        f"group_prof={len(gp)}",
        f"meetings={len(meet)}",
    )


if __name__ == "__main__":
    main()
