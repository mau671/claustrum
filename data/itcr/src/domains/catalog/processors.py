"""Catalog processing steps for process command."""

import json
import re
from pathlib import Path
from typing import Any

from src.shared.text_and_ids import get_itcr_university_id
from src.shared.text_and_ids import load_campus_id_map
from src.shared.text_and_ids import normalize_text


def ensure_reference_data(data_dir: Path) -> None:
    """Ensure country and university reference data exists."""
    country_path = data_dir / "country" / "data.json"
    country_path.parent.mkdir(parents=True, exist_ok=True)
    if not country_path.exists():
        countries = [{"id": 1, "name": "COSTA RICA", "iso2_code": "CR"}]
        country_path.write_text(json.dumps(countries, indent=2, ensure_ascii=False))
        print(f"Created {country_path}")

    university_path = data_dir / "university" / "data.json"
    university_path.parent.mkdir(parents=True, exist_ok=True)
    if not university_path.exists():
        universities = [
            {
                "id": 1,
                "country_id": 1,
                "name": "INSTITUTO TECNOLÓGICO DE COSTA RICA",
                "short_name": "ITCR",
            }
        ]
        university_path.write_text(
            json.dumps(universities, indent=2, ensure_ascii=False)
        )
        print(f"Created {university_path}")


def load_campus_codes(data_dir: Path) -> list[str]:
    """Load campus codes from processed data."""
    campus_path = data_dir / "campus" / "data.json"
    if not campus_path.exists():
        msg = f"Campus data not found at {campus_path}"
        raise FileNotFoundError(msg)
    campuses = json.loads(campus_path.read_text())
    return [c["code"] for c in campuses]


def process_campus(
    data_dir: Path = Path("data/raw"),
    university_id: int | None = None,
) -> list[dict[str, Any]]:
    """Process campus raw data and generate normalized output."""
    campus_dir = data_dir / "campus"
    if university_id is None:
        university_id = get_itcr_university_id(data_dir)

    json_data = json.loads((campus_dir / "carga_sedes_json.json").read_text())
    json_sedes = {
        item["key"]: normalize_text(item["data"]) for item in json_data.get("sedes", [])
    }

    html_content = (campus_dir / "carga_sedes_tds_lib.html").read_text()
    html_matches = re.findall(r"<span value='([^']+)'>([^<]+)</span>", html_content)
    html_sedes = {code: normalize_text(name) for code, name in html_matches}

    merged: dict[str, str] = html_sedes.copy()
    for code, name in json_sedes.items():
        if code not in merged:
            merged[code] = name
        elif len(name) > len(merged[code]):
            merged[code] = name

    campuses: list[dict[str, Any]] = []
    for idx, (code, name) in enumerate(sorted(merged.items()), start=1):
        campuses.append(
            {"id": idx, "university_id": university_id, "code": code, "name": name}
        )
    return campuses


def process_academic_unit(
    data_dir: Path = Path("data/raw"),
    university_id: int | None = None,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Process academic unit raw data and generate normalized output."""
    unit_dir = data_dir / "academic_unit"
    if university_id is None:
        university_id = get_itcr_university_id(data_dir)

    campus_id_map = load_campus_id_map(data_dir)
    raw_data = json.loads((unit_dir / "carga_carreras_json.json").read_text())

    all_units: dict[str, dict[str, Any]] = {}
    unit_campus_relations: list[dict[str, Any]] = []
    existing_relations: set[tuple[int, int]] = set()
    relation_id_counter = 1

    existing_units_path = unit_dir / "data.json"
    if existing_units_path.exists():
        existing_data = json.loads(existing_units_path.read_text())
        all_units.update({u["code"]: u for u in existing_data})
        unit_id_counter = (
            (max(u["id"] for u in existing_data) + 1) if existing_data else 1
        )
        relations_path = data_dir / "academic_unit_campus" / "data.json"
        if relations_path.exists():
            existing_relations_data = json.loads(relations_path.read_text())
            unit_campus_relations.extend(existing_relations_data)
            for rel in existing_relations_data:
                existing_relations.add(
                    (rel.get("academic_unit_id"), rel.get("campus_id"))
                )
            if existing_relations_data:
                relation_id_counter = max(r["id"] for r in existing_relations_data) + 1
    else:
        unit_id_counter = 1

    for campus_code, campus_id in campus_id_map.items():
        if campus_code not in raw_data:
            continue
        carreras = raw_data[campus_code].get("carreras", [])
        if not isinstance(carreras, list):
            continue
        for carrera in carreras:
            code = carrera.get("key")
            name = carrera.get("data")
            if not code or not name:
                continue
            code = normalize_text(str(code))
            name = normalize_text(str(name))
            if code not in all_units:
                all_units[code] = {
                    "id": unit_id_counter,
                    "university_id": university_id,
                    "code": code,
                    "name": name,
                }
                unit_id_counter += 1
            unit_id = all_units[code]["id"]
            relation_key = (unit_id, campus_id)
            if relation_key not in existing_relations:
                unit_campus_relations.append(
                    {
                        "id": relation_id_counter,
                        "academic_unit_id": unit_id,
                        "campus_id": campus_id,
                    }
                )
                existing_relations.add(relation_key)
                relation_id_counter += 1

    return list(all_units.values()), unit_campus_relations


def process_academic_period(
    data_dir: Path = Path("data/raw"),
    years: list[int] | None = None,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Process academic modality and term raw data."""
    if years is None:
        years = [2024, 2025, 2026]

    raw_data = json.loads(
        (data_dir / "academic_period" / "carga_modalidad_periodos.json").read_text()
    )
    modalidades_raw = (
        raw_data if isinstance(raw_data, list) else raw_data.get("modalidad", [])
    )

    all_modalities: dict[str, dict[str, Any]] = {}
    modality_id_counter = 1
    for mod in modalidades_raw:
        code = mod.get("IDE_MODALIDAD")
        name = mod.get("NOMBRE")
        periods_per_year = mod.get("CANT_PERIODOS", 0)
        if not code or not name:
            continue
        code = normalize_text(str(code))
        name = normalize_text(str(name))
        all_modalities[code] = {
            "id": modality_id_counter,
            "code": code,
            "name": name,
            "periods_per_year": int(periods_per_year) if periods_per_year else 0,
        }
        modality_id_counter += 1

    all_terms: list[dict[str, Any]] = []
    term_id_counter = 1
    for mod_code, mod_data in all_modalities.items():
        for year in years:
            for period_num in range(1, mod_data["periods_per_year"] + 1):
                all_terms.append(
                    {
                        "id": term_id_counter,
                        "academic_modality_id": mod_data["id"],
                        "year": year,
                        "period_number": period_num,
                        "external_key": f"{year}_{mod_code}_{period_num}",
                        "display_name": f"{year} - {mod_data['name']} {period_num}",
                    }
                )
                term_id_counter += 1

    return list(all_modalities.values()), all_terms
