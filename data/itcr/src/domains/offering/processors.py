"""Process course offering data from schedule_guia and course_offer."""

import json
import re
import unicodedata
from pathlib import Path
from typing import Any


def remove_accents(text: str) -> str:
    """Remove accents from text for SQL enum compatibility."""
    normalized = unicodedata.normalize("NFD", text)
    return "".join(ch for ch in normalized if unicodedata.category(ch) != "Mn")


def normalize_group_type_key(raw_group_type: str) -> str:
    """Normalize group type to a comparable uppercase key without accents."""
    normalized = remove_accents(raw_group_type.upper().strip())
    normalized = re.sub(r"\s+", " ", normalized)
    return normalized


def normalize_group_type(raw_group_type: str) -> str:
    """Normalize external group type values to DB enum-compatible values."""
    normalized = normalize_group_type_key(raw_group_type)

    aliases = {
        "GRUPO RN": "RN",
        "RN": "RN",
        "PRESENCIAL": "REGULAR",
        "REGULAR": "REGULAR",
        "CORRIENTE": "REGULAR",
        "SEMIPRESENCIAL": "SEMIPRESENCIAL",
        "VIRTUAL": "VIRTUAL",
        "ASISTIDA": "ASISTIDA",
        "TUTORIA": "TUTORIA",
        "LABORATORIO": "LABORATORIO",
        "TALLER": "TALLER",
        "ENSEÑANZA REMOTA": "ENSEÑANZA REMOTA",
        "ENSENANZA REMOTA": "ENSEÑANZA REMOTA",
        "TRABAJO FINAL DE GRADUACION": "TRABAJO FINAL DE GRADUACIÓN",
        "TRABAJO FINAL DE GRADUACION (TFG)": "TRABAJO FINAL DE GRADUACIÓN",
        "TRABAJO FINAL DE GRADUACION TFG": "TRABAJO FINAL DE GRADUACIÓN",
        "TFG": "TRABAJO FINAL DE GRADUACIÓN",
    }

    canonical = aliases.get(normalized)
    if canonical:
        return canonical

    msg = f"Unknown group type: {raw_group_type!r} (normalized={normalized!r})"
    raise ValueError(msg)


def normalize_classroom(raw_classroom: str) -> str | None:
    """Normalize classroom values and convert placeholders to NULL."""
    classroom = raw_classroom.strip()
    if not classroom:
        return None
    if classroom.upper() == "NO DISPONIBLE":
        return None
    return classroom


def is_placeholder_professor_name(raw_name: str) -> bool:
    """Return True when the professor name is a known placeholder value."""
    normalized = remove_accents(raw_name.upper().strip())
    placeholders = {
        "SIN PROFESOR ASIGNADO",
        "(SE IMPARTE EN IDIOMA INGLES)",
        "SE IMPARTE EN IDIOMA INGLES",
    }
    return normalized in placeholders


def render_progress(current: int, total: int) -> None:
    total = max(total, 1)
    print(f"\r[{current:03d}/{total:03d}] Processing ...", end="", flush=True)


def run_process_course_offering(data_dir: Path, year: str) -> None:
    """Process course offering data for a given year.

    Requires schedule_guia data; course_offer is optional metadata for weekly hours.
    """
    year_str = str(year)
    course_offer_dir = data_dir / "course_offer" / year_str
    schedule_guia_dir = data_dir / "schedule_guia" / year_str

    if not schedule_guia_dir.exists():
        print(f"Error: schedule_guia data not found at {schedule_guia_dir}")
        return

    print(f"Processing course offering data for year {year_str}...")

    campus_path = data_dir / "campus" / "data.json"
    academic_unit_path = data_dir / "academic_unit" / "data.json"
    academic_term_path = data_dir / "academic_term" / "data.json"
    course_path = data_dir / "course" / "data.json"
    professor_path = data_dir / "professor" / "data.json"

    if not campus_path.exists():
        print(f"Error: campus data not found at {campus_path}")
        return

    if not academic_unit_path.exists():
        print(f"Error: academic_unit data not found at {academic_unit_path}")
        return

    if not academic_term_path.exists():
        print(f"Error: academic_term data not found at {academic_term_path}")
        return

    if not course_path.exists():
        print(f"Error: course data not found at {course_path}")
        return

    campuses = json.loads(campus_path.read_text())
    campus_code_to_id = {c["code"]: c["id"] for c in campuses}
    campus_code_to_name = {c["code"]: c["name"] for c in campuses}

    academic_units = json.loads(academic_unit_path.read_text())
    academic_unit_code_to_id = {u["code"]: u["id"] for u in academic_units}

    academic_terms = json.loads(academic_term_path.read_text())
    academic_term_external_to_id = {t["external_key"]: t["id"] for t in academic_terms}

    courses = json.loads(course_path.read_text())
    course_code_to_id = {c["code"]: c["id"] for c in courses}
    course_code_to_data = {c["code"]: c for c in courses}

    professors = {}
    existing_professor_count = 0
    max_professor_id = 0
    if professor_path.exists():
        professor_list = json.loads(professor_path.read_text())
        for p in professor_list:
            name = p["full_name"].upper()
            if is_placeholder_professor_name(name):
                continue
            pid = int(p.get("id", 0) or 0)
            if pid > 0:
                max_professor_id = max(max_professor_id, pid)
                professors[name] = pid
        existing_professor_count = len(professors)

    next_professor_id = max_professor_id + 1
    next_offering_id = 1
    next_group_id = 1
    next_group_professor_id = 1
    next_meeting_id = 1

    updated_course_names: list[tuple[str, str]] = []

    day_mapping = {
        "LUNES": 1,
        "MARTES": 2,
        "MIERCOLES": 3,
        "JUEVES": 4,
        "VIERNES": 5,
        "SABADO": 6,
        "DOMINGO": 7,
    }

    course_offerings: dict[tuple[int, int, int, int], dict[str, Any]] = {}
    groups: list[dict[str, Any]] = []
    group_professors: list[dict[str, Any]] = []
    meetings: list[dict[str, Any]] = []

    created_groups: dict[tuple[int, str], int] = {}
    created_gps: set[tuple[int, int]] = set()
    created_meetings: set[tuple[int, int, str, str]] = set()
    unknown_group_types: dict[str, int] = {}
    unknown_group_type_examples: list[str] = []

    course_offer_files = (
        sorted(course_offer_dir.glob("*.json")) if course_offer_dir.exists() else []
    )
    print(f"Loading {len(course_offer_files)} course_offer files for mixing...")

    course_offer_data: dict[str, list[dict[str, Any]]] = {}
    total_course_offer_files = len(course_offer_files)
    for idx, file in enumerate(course_offer_files, 1):
        data = json.loads(file.read_text())
        for entry in data:
            code = entry.get("IDE_MATERIA", "")
            if code:
                if code not in course_offer_data:
                    course_offer_data[code] = []
                course_offer_data[code].append(entry)
        render_progress(idx, total_course_offer_files)
    print()

    schedule_guia_files = sorted(schedule_guia_dir.glob("*.json"))
    total_files = len(schedule_guia_files)

    print(f"Processing {total_files} schedule files...")

    for idx, schedule_file in enumerate(schedule_guia_files, 1):
        file_name = schedule_file.stem
        parts = file_name.split("_")
        if len(parts) != 5:
            render_progress(idx, total_files)
            continue

        sede_code = parts[0]
        carrera_code = parts[1]
        ano = parts[2]
        modalidad = parts[3]
        periodo_num = parts[4]
        periodo = f"{ano}_{modalidad}_{periodo_num}"

        campus_id = campus_code_to_id.get(sede_code)
        if not campus_id:
            render_progress(idx, total_files)
            continue

        dsc_sede = campus_code_to_name.get(sede_code, "")

        academic_unit_id = academic_unit_code_to_id.get(carrera_code)
        if not academic_unit_id:
            render_progress(idx, total_files)
            continue

        academic_term_id = academic_term_external_to_id.get(periodo)
        if not academic_term_id:
            render_progress(idx, total_files)
            continue

        schedule_data = json.loads(schedule_file.read_text())
        if not schedule_data:
            continue

        render_progress(idx, total_files)

        for entry in schedule_data:
            course_code = entry.get("IDE_MATERIA", "")
            group_code = entry.get("IDE_GRUPO", "")

            course_id = course_code_to_id.get(course_code)
            if not course_id:
                continue

            course_data = course_code_to_data.get(course_code, {})

            course_name_from_schedule = entry.get("DSC_MATERIA", "").strip().upper()
            existing_name = course_data.get("name", "").strip().upper()
            needs_name_update = course_name_from_schedule and (
                not existing_name or existing_name == course_code
            )
            if needs_name_update:
                course_data["name"] = course_name_from_schedule
                course_code_to_data[course_code] = course_data
                updated_course_names.append((course_code, course_name_from_schedule))

            course_id = course_code_to_id.get(course_code)
            if not course_id:
                continue

            offering_key = (course_id, campus_id, academic_unit_id, academic_term_id)

            if offering_key not in course_offerings:
                course_data = course_code_to_data.get(course_code, {})
                course_offer_list = course_offer_data.get(course_code, [])

                course_hours = None
                for offer in course_offer_list:
                    if (
                        offer.get("DSC_SEDE") == dsc_sede
                        and offer.get("NUM_ANO") == int(ano)
                        and offer.get("IDE_MODALIDAD") == modalidad
                        and offer.get("IDE_PER_MOD") == int(periodo_num)
                    ):
                        course_hours = offer.get("HORAS", 0)
                        break

                credits = entry.get(
                    "CAN_CREDITOS", course_data.get("default_credits", 0)
                )
                weekly_hours = course_hours
                course_type = entry.get("TIPO_MATERIA", "")

                course_offerings[offering_key] = {
                    "id": next_offering_id,
                    "course_id": course_id,
                    "campus_id": campus_id,
                    "academic_unit_id": academic_unit_id,
                    "academic_term_id": academic_term_id,
                    "credits_snapshot": credits,
                    "weekly_hours_snapshot": weekly_hours,
                    "course_type": course_type,
                }
                next_offering_id += 1

            offering_id = course_offerings[offering_key]["id"]

            group_key = (offering_id, group_code)
            capacity = entry.get("CAPACIDAD", 0)
            raw_group_type = entry.get("TIPO_GRUPO", "REGULAR")
            try:
                group_type = normalize_group_type(raw_group_type)
            except ValueError:
                normalized_raw = normalize_group_type_key(str(raw_group_type))
                unknown_group_types[normalized_raw] = (
                    unknown_group_types.get(normalized_raw, 0) + 1
                )
                if len(unknown_group_type_examples) < 20:
                    unknown_group_type_examples.append(
                        (
                            f"file={schedule_file.name}, course={course_code}, "
                            f"group={group_code}, raw={raw_group_type!r}, "
                            f"normalized={normalized_raw!r}"
                        )
                    )
                continue

            if group_key not in created_groups:
                group_id = next_group_id
                group = {
                    "id": group_id,
                    "course_offering_id": offering_id,
                    "group_code": group_code,
                    "group_type": group_type,
                    "capacity": capacity,
                }
                groups.append(group)
                created_groups[group_key] = group_id
                next_group_id += 1

            group_id = created_groups[group_key]

            professor_name = entry.get("NOM_PROFESOR", "").strip().upper()
            if professor_name and not is_placeholder_professor_name(professor_name):
                if professor_name not in professors:
                    professors[professor_name] = next_professor_id
                    next_professor_id += 1
                professor_id = professors[professor_name]

                gp_key = (group_id, professor_id)
                if gp_key not in created_gps:
                    gp = {
                        "id": next_group_professor_id,
                        "course_offering_group_id": group_id,
                        "professor_id": professor_id,
                    }
                    group_professors.append(gp)
                    created_gps.add(gp_key)
                    next_group_professor_id += 1

            day_name = entry.get("NOM_DIA", "").upper()
            weekday = day_mapping.get(day_name, 0)
            if weekday == 0:
                continue

            starts_at = entry.get("HINICIO", "")
            ends_at = entry.get("HFIN", "")
            classroom = normalize_classroom(entry.get("AULA", ""))

            meeting_key = (group_id, weekday, starts_at, ends_at)
            if meeting_key not in created_meetings:
                meeting = {
                    "id": next_meeting_id,
                    "course_offering_group_id": group_id,
                    "weekday": weekday,
                    "starts_at": starts_at,
                    "ends_at": ends_at,
                    "classroom": classroom,
                }
                meetings.append(meeting)
                created_meetings.add(meeting_key)
                next_meeting_id += 1

    print()

    if unknown_group_types:
        detected = ", ".join(
            f"{name} ({count})"
            for name, count in sorted(
                unknown_group_types.items(), key=lambda item: (-item[1], item[0])
            )
        )
        examples = "\n  - " + "\n  - ".join(unknown_group_type_examples)
        msg = (
            "Unknown TIPO_GRUPO values detected. "
            "Add them to enum/mapping before generating seed.\n"
            f"Detected: {detected}\n"
            f"Examples:{examples}"
        )
        raise ValueError(msg)

    output_dir = data_dir / "course_offering"
    output_dir.mkdir(parents=True, exist_ok=True)

    offering_list = list(course_offerings.values())
    offering_path = output_dir / "data.json"
    offering_path.write_text(json.dumps(offering_list, indent=2, ensure_ascii=False))
    print(f"Saved course_offering: {offering_path} ({len(offering_list)} offerings)")

    group_output_dir = data_dir / "course_offering_group"
    group_output_dir.mkdir(parents=True, exist_ok=True)
    group_path = group_output_dir / "data.json"
    group_path.write_text(json.dumps(groups, indent=2, ensure_ascii=False))
    print(f"Saved course_offering_group: {group_path} ({len(groups)} groups)")

    gp_output_dir = data_dir / "course_offering_group_professor"
    gp_output_dir.mkdir(parents=True, exist_ok=True)
    gp_path = gp_output_dir / "data.json"
    gp_path.write_text(json.dumps(group_professors, indent=2, ensure_ascii=False))
    print(
        f"Saved course_offering_group_professor: {gp_path} ({len(group_professors)} relations)"
    )

    meeting_output_dir = data_dir / "course_offering_meeting"
    meeting_output_dir.mkdir(parents=True, exist_ok=True)
    meeting_path = meeting_output_dir / "data.json"
    meeting_path.write_text(json.dumps(meetings, indent=2, ensure_ascii=False))
    print(f"Saved course_offering_meeting: {meeting_path} ({len(meetings)} meetings)")

    professor_list = [
        {"id": professors[name], "full_name": name} for name in sorted(professors)
    ]
    professor_path = data_dir / "professor" / "data.json"
    professor_path.parent.mkdir(parents=True, exist_ok=True)
    professor_path.write_text(json.dumps(professor_list, indent=2, ensure_ascii=False))
    print(f"Saved professor: {professor_path} ({len(professor_list)} professors)")

    if updated_course_names:
        course_output_path = data_dir / "course" / "data.json"
        course_output_path.parent.mkdir(parents=True, exist_ok=True)
        course_list = list(course_code_to_data.values())
        course_output_path.write_text(
            json.dumps(course_list, indent=2, ensure_ascii=False)
        )
        print(
            f"Updated {len(updated_course_names)} course names in {course_output_path}"
        )

    print(f"\nProcessing complete for year {year_str}")
    print(f"  - Offerings: {len(offering_list)}")
    print(f"  - Groups: {len(groups)}")
    print(f"  - Group-Professor: {len(group_professors)}")
    print(f"  - Meetings: {len(meetings)}")
    print(f"  - Professors in snapshot: {len(professor_list)}")
    print(
        f"  - New professors discovered: {max(len(professor_list) - existing_professor_count, 0)}"
    )
