"""API client for academic modality and term data."""

import json
from pathlib import Path
from typing import Any

import requests

from src.infra.tec_api.client import APIClient


class AcademicPeriodClient(APIClient):
    """Client for academic modality and term endpoints."""

    def __init__(self, verify_ssl: bool = False) -> None:
        super().__init__()
        self._alteonp_cookie: str = ""
        self._verify_ssl = verify_ssl

    def _get_cookies(self) -> tuple[str, str]:
        """Get AlteonP cookie from page."""
        if self._alteonp_cookie:
            return self._alteonp_cookie, ""

        try:
            self.session.get(
                "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx",
                verify=False,  # SSL issues only on this endpoint
            )
            for cookie in self.session.cookies:
                if cookie.name == "AlteonP":
                    self._alteonp_cookie = cookie.value or ""
                    break
        except requests.RequestException:
            pass

        return self._alteonp_cookie, ""

    def get_modalidad_periodos(self) -> dict[str, Any] | None:
        """POST cargaModalidadPeriodos - returns academic modalities and periods."""
        alteonp, altesp = self._get_cookies()

        endpoint = "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx/cargaModalidadPeriodos"
        headers = {
            "Accept": "application/json, text/javascript, */*; q=0.01",
            "Accept-Language": "en-US,en;q=0.8",
            "Connection": "keep-alive",
            "Content-Length": "0",
            "Content-Type": "application/json; charset=utf-8",
            "Cookie": f"AlteonP={alteonp}",
            "Origin": "https://tec-appsext.itcr.ac.cr",
            "Referer": "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
            "Sec-GPC": "1",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36",
            "X-Requested-With": "XMLHttpRequest",
        }

        try:
            response = self.session.post(
                endpoint,
                headers=headers,
                verify=False,  # SSL issues only on this endpoint
            )
            response.raise_for_status()

            # Response has nested JSON in "d" field: {"d": "[{...}]"}
            raw_response = response.json()
            inner_json = raw_response.get("d")

            if isinstance(inner_json, str):
                # Parse the nested JSON string
                return json.loads(inner_json)

            return raw_response
        except requests.RequestException as e:
            print(f"Error fetching modalidad/periodos: {e}")
            return None

    def download_raw(self, output_dir: Path) -> dict[str, Path]:
        """Download raw academic modality and period data."""
        output_dir = output_dir / "academic_period"
        output_dir.mkdir(parents=True, exist_ok=True)

        data = self.get_modalidad_periodos()

        output_path = output_dir / "carga_modalidad_periodos.json"
        if data:
            output_path.write_text(json.dumps(data, indent=2, ensure_ascii=False))
        else:
            output_path.write_text(json.dumps({}, indent=2, ensure_ascii=False))

        return {"json": output_path}
