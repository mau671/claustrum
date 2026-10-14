"""Shared helpers for process command modules."""

import json
from pathlib import Path


def normalize_text(text: str) -> str:
    """Normalize text to uppercase with strip whitespace."""
    return text.upper().strip()


def load_campus_id_map(data_dir: Path) -> dict[str, int]:
    """Load campus id mapping from processed data."""
    campus_path = data_dir / "campus" / "data.json"
    if not campus_path.exists():
        msg = f"Campus data not found at {campus_path}"
        raise FileNotFoundError(msg)
    campuses = json.loads(campus_path.read_text())
    return {c["code"]: c["id"] for c in campuses}


def load_universities(data_dir: Path) -> dict[str, int]:
    """Load universities and return mapping from short_name to id."""
    univ_path = data_dir / "university" / "data.json"
    if not univ_path.exists():
        msg = f"University data not found at {univ_path}"
        raise FileNotFoundError(msg)
    universities = json.loads(univ_path.read_text())
    return {univ["short_name"]: univ["id"] for univ in universities}


def get_itcr_university_id(data_dir: Path) -> int:
    """Get ITCR university ID (default for campus data)."""
    univ_id = load_universities(data_dir).get("ITCR")
    if univ_id is None:
        msg = "ITCR university not found in university data"
        raise ValueError(msg)
    return univ_id
