"""Study plan processing for process command."""

import json
from pathlib import Path
from typing import Any

from src.shared.text_and_ids import load_campus_id_map
from src.shared.text_and_ids import normalize_text


def process_study_plan_complete(
    data_dir: Path = Path("data/raw"),
) -> tuple[
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
    list[dict[str, Any]],
]:
    """Process study plan raw data with full course and relation extraction."""
    plan_dir = data_dir / "study_plan"
    complete_path = plan_dir / "json_draw_angular.json"

    if not complete_path.exists():
        msg = f"Complete study plan data not found at {complete_path}"
        raise FileNotFoundError(msg)

    modality_path = data_dir / "academic_modality" / "data.json"
    modality_code_to_id: dict[str, int] = {}
    modality_name_to_id: dict[str, int] = {}
    if modality_path.exists():
        modalities = json.loads(modality_path.read_text())
        modality_code_to_id = {m["code"]: m["id"] for m in modalities}
        modality_name_to_id = {
            normalize_text(m["name"]): m["id"] for m in modalities if m.get("name")
        }

    campus_id_map = load_campus_id_map(data_dir)

    unit_path = data_dir / "academic_unit" / "data.json"
    unit_code_to_id: dict[str, int] = {}
    if unit_path.exists():
        units = json.loads(unit_path.read_text())
        unit_code_to_id = {u["code"]: u["id"] for u in units}

    complete_data = json.loads(complete_path.read_text())

    study_plan_map: dict[tuple[int, int], dict[str, Any]] = {}
    study_plan_id_counter = 1
    existing_plan_path = data_dir / "study_plan" / "data.json"
    if existing_plan_path.exists():
        existing_plans = json.loads(existing_plan_path.read_text())
        for plan in existing_plans:
            academic_unit_id = plan.get("academic_unit_id")
            external_plan_id = plan.get("external_plan_id")
            if academic_unit_id and external_plan_id:
                study_plan_map[(academic_unit_id, external_plan_id)] = plan
                study_plan_id_counter = max(
                    study_plan_id_counter, plan.get("id", 0) + 1
                )

    plan_campus_relations: list[dict[str, Any]] = []
    plan_campus_keys: set[tuple[int, int]] = set()
    relation_id_counter = 1
    existing_plan_campus_path = data_dir / "study_plan_campus" / "data.json"
    if existing_plan_campus_path.exists():
        existing_relations = json.loads(existing_plan_campus_path.read_text())
        for relation in existing_relations:
            plan_campus_relations.append(relation)
            key = (relation.get("study_plan_id"), relation.get("campus_id"))
            if key[0] and key[1]:
                plan_campus_keys.add(key)
                relation_id_counter = max(
                    relation_id_counter, relation.get("id", 0) + 1
                )

    study_plan_levels: list[dict[str, Any]] = []
    level_key_map: dict[tuple[int, str], int] = {}
    level_id_counter = 1
    existing_level_path = data_dir / "study_plan_level" / "data.json"
    if existing_level_path.exists():
        existing_levels = json.loads(existing_level_path.read_text())
        for level in existing_levels:
            study_plan_levels.append(level)
            level_key = (
                level.get("study_plan_id"),
                normalize_text(level.get("level_label", "")),
            )
            if level_key[0] and level_key[1]:
                level_key_map[level_key] = level.get("id")
                level_id_counter = max(level_id_counter, level.get("id", 0) + 1)

    course_map: dict[str, dict[str, Any]] = {}
    course_id_counter = 1
    existing_course_path = data_dir / "course" / "data.json"
    if existing_course_path.exists():
        existing_courses = json.loads(existing_course_path.read_text())
        for course in existing_courses:
            course_code = normalize_text(course.get("code", ""))
            if not course_code:
                continue
            course_map[course_code] = course
            course_id_counter = max(course_id_counter, course.get("id", 0) + 1)

    level_courses: list[dict[str, Any]] = []
    level_course_keys: set[tuple[int, int]] = set()
    level_course_id_counter = 1
    existing_level_course_path = data_dir / "study_plan_level_course" / "data.json"
    if existing_level_course_path.exists():
        existing_level_courses = json.loads(existing_level_course_path.read_text())
        for level_course in existing_level_courses:
            level_courses.append(level_course)
            key = (
                level_course.get("study_plan_level_id"),
                level_course.get("course_id"),
            )
            if key[0] and key[1]:
                level_course_keys.add(key)
                level_course_id_counter = max(
                    level_course_id_counter, level_course.get("id", 0) + 1
                )

    course_relations: list[dict[str, Any]] = []
    course_relation_keys: set[tuple[int, int, int, str]] = set()
    relation_id_course_counter = 1
    existing_relation_path = data_dir / "course_relation" / "data.json"
    if existing_relation_path.exists():
        existing_relations = json.loads(existing_relation_path.read_text())
        for relation in existing_relations:
            course_relations.append(relation)
            key = (
                relation.get("study_plan_id"),
                relation.get("from_course_id"),
                relation.get("to_course_id"),
                relation.get("relation_type"),
            )
            if all(key):
                course_relation_keys.add(key)
                relation_id_course_counter = max(
                    relation_id_course_counter, relation.get("id", 0) + 1
                )

    processed_plan_ids: set[int] = set()

    def ensure_course(
        course_code: Any,
        course_name: str | None = None,
        credits: int | None = None,
        hours: int | None = None,
    ) -> int:
        if course_code is None:
            return 0
        code_str = str(course_code).strip()
        if not code_str or code_str.isdigit():
            return 0
        normalized_code = normalize_text(code_str)
        if not normalized_code:
            return 0
        if normalized_code in course_map:
            course = course_map[normalized_code]
            if course_name and course_name != normalized_code:
                course["name"] = normalize_text(course_name)
            if credits is not None and course.get("default_credits", 0) == 0:
                course["default_credits"] = credits
            if hours is not None and course.get("default_weekly_hours", 0) == 0:
                course["default_weekly_hours"] = hours
            return int(course["id"])

        nonlocal course_id_counter
        new_course = {
            "id": course_id_counter,
            "code": normalized_code,
            "name": normalize_text(course_name) if course_name else normalized_code,
            "default_credits": credits or 0,
            "default_weekly_hours": hours or 0,
        }
        course_map[normalized_code] = new_course
        course_id_counter += 1
        return int(new_course["id"])

    def add_relation(
        study_plan_id: int, from_code: Any, to_code: Any, relation_type: str
    ) -> None:
        from_id = ensure_course(from_code)
        to_id = ensure_course(to_code)
        if not from_id or not to_id:
            return
        key = (study_plan_id, from_id, to_id, relation_type)
        if key in course_relation_keys:
            return
        nonlocal relation_id_course_counter
        course_relations.append(
            {
                "id": relation_id_course_counter,
                "study_plan_id": study_plan_id,
                "from_course_id": from_id,
                "to_course_id": to_id,
                "relation_type": relation_type,
            }
        )
        course_relation_keys.add(key)
        relation_id_course_counter += 1

    for _, complete_unit_data in complete_data.items():
        campus_code = complete_unit_data.get("campus_code")
        academic_unit_code = complete_unit_data.get("academic_unit_code")
        plans = complete_unit_data.get("plans", [])
        if not campus_code or not academic_unit_code:
            continue

        unit_id = unit_code_to_id.get(academic_unit_code)
        if not unit_id:
            continue
        campus_id = campus_id_map.get(campus_code)

        for plan in plans:
            external_plan_id = plan.get("external_plan_id")
            if not external_plan_id:
                continue
            complete_plan_data = plan.get("complete_data", {})
            if not complete_plan_data:
                continue

            plan_name = normalize_text(plan.get("name", ""))
            first_level = plan.get("first_level_number", 0)
            academic_degree = normalize_text(plan.get("academic_degree", ""))
            modality_raw = plan.get("modalidad", "")
            modality_norm = normalize_text(str(modality_raw)) if modality_raw else ""
            modality_id = modality_code_to_id.get(
                modality_norm
            ) or modality_name_to_id.get(modality_norm)

            plan_key = (unit_id, external_plan_id)
            if plan_key not in study_plan_map:
                study_plan_map[plan_key] = {
                    "id": study_plan_id_counter,
                    "academic_unit_id": unit_id,
                    "academic_modality_id": modality_id,
                    "external_plan_id": external_plan_id,
                    "name": plan_name,
                    "academic_degree": academic_degree or None,
                    "first_level_number": first_level,
                }
                study_plan_id_counter += 1
            else:
                existing = study_plan_map[plan_key]
                if plan_name:
                    existing["name"] = plan_name
                if academic_degree:
                    existing["academic_degree"] = academic_degree
                if modality_id:
                    existing["academic_modality_id"] = modality_id
                if first_level is not None:
                    existing["first_level_number"] = first_level

            plan_id = study_plan_map[plan_key]["id"]
            if campus_id:
                campus_key = (plan_id, campus_id)
                if campus_key not in plan_campus_keys:
                    plan_campus_relations.append(
                        {
                            "id": relation_id_counter,
                            "study_plan_id": plan_id,
                            "campus_id": campus_id,
                            "valid_from": None,
                            "valid_to": None,
                        }
                    )
                    plan_campus_keys.add(campus_key)
                    relation_id_counter += 1

            if plan_id in processed_plan_ids:
                continue
            processed_plan_ids.add(plan_id)

            levels = (
                complete_plan_data.get("levels")
                or complete_plan_data.get("niveles")
                or []
            )
            for idx, level_info in enumerate(levels, start=1):
                level_label_raw = level_info.get("id") or f"NIVEL {idx}"
                level_label = normalize_text(level_label_raw)
                try:
                    level_number = int(level_label_raw.split()[-1])
                except (ValueError, IndexError):
                    level_number = idx

                level_key = (plan_id, level_label)
                if level_key in level_key_map:
                    level_id = level_key_map[level_key]
                else:
                    level_id = level_id_counter
                    study_plan_levels.append(
                        {
                            "id": level_id,
                            "study_plan_id": plan_id,
                            "level_number": level_number,
                            "level_label": level_label,
                        }
                    )
                    level_key_map[level_key] = level_id
                    level_id_counter += 1

                courses_in_level = level_info.get("courses", [])
                sort_order = 0
                for course_data in courses_in_level:
                    course_code = course_data.get("id_course")
                    if not course_code:
                        continue
                    course_name = course_data.get("name", "")
                    try:
                        credits_raw = course_data.get("credits", 0)
                        credits = (
                            int(credits_raw)
                            if credits_raw and str(credits_raw).lstrip("-").isdigit()
                            else 0
                        )
                    except (ValueError, TypeError):
                        credits = 0
                    try:
                        hours_raw = course_data.get("hours", 0)
                        hours = (
                            int(hours_raw)
                            if hours_raw and str(hours_raw).lstrip("-").isdigit()
                            else 0
                        )
                    except (ValueError, TypeError):
                        hours = 0

                    course_id = ensure_course(course_code, course_name, credits, hours)
                    if not course_id:
                        continue

                    level_course_key = (level_id, course_id)
                    if level_course_key not in level_course_keys:
                        level_courses.append(
                            {
                                "id": level_course_id_counter,
                                "study_plan_level_id": level_id,
                                "course_id": course_id,
                                "credits": credits,
                                "weekly_hours": hours,
                                "sort_order": sort_order,
                            }
                        )
                        level_course_keys.add(level_course_key)
                        level_course_id_counter += 1
                    sort_order += 10

                    for req in course_data.get("requirements", []):
                        req_code = req.get("id", "")
                        if req_code:
                            add_relation(plan_id, course_code, req_code, "PREREQUISITE")

                    for req in course_data.get("co_requirements", []):
                        req_code = req.get("id", "")
                        if req_code:
                            add_relation(plan_id, course_code, req_code, "COREQUISITE")

                    for eq in course_data.get("equivalent", []):
                        eq_code = eq.get("id", "")
                        if eq_code and not str(eq_code).lower().startswith("no hay"):
                            add_relation(plan_id, course_code, eq_code, "EQUIVALENT")

    return (
        list(study_plan_map.values()),
        plan_campus_relations,
        study_plan_levels,
        list(course_map.values()),
        course_relations,
        level_courses,
    )
