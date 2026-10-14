"""API client for campus/sedes data."""

import json
from pathlib import Path
from typing import Any

from src.infra.tec_api.client import APIClient


class CampusClient(APIClient):
    """Client for campus/sedes endpoints."""

    def get_sedes_json(self) -> Any:
        """GET carga_sedes_json - returns JSON data."""
        endpoint = "tds-curriculum-exp/ajax/carga_sedes_json"
        return self.get(endpoint)

    def get_sedes_html(self) -> Any:
        """POST carga_sedes_tds_lib - returns HTML data."""
        endpoint = "tda-expediente-estudiantil/ajax/combos/carga_sedes_tds_lib"
        return self.post(endpoint, data={"accion": "cargar"})

    def download_raw(self, output_dir: Path, format: str = "json") -> dict[str, Path]:
        """Download raw campus data and save to files."""
        output_dir = output_dir / "campus"
        output_dir.mkdir(parents=True, exist_ok=True)

        files: dict[str, Path] = {}

        # Download JSON endpoint
        json_response = self.get_sedes_json()
        json_data = json_response.json()
        json_path = output_dir / "carga_sedes_json.json"
        json_path.write_text(json.dumps(json_data, indent=2, ensure_ascii=False))
        files["json"] = json_path

        # Download HTML endpoint
        html_response = self.get_sedes_html()
        html_path = output_dir / "carga_sedes_tds_lib.html"
        html_path.write_text(html_response.text)
        files["html"] = html_path

        return files
