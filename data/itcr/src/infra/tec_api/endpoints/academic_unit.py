"""API client for academic unit/career data."""

import json
import re
import time
from collections.abc import Callable
from pathlib import Path
from typing import Any

import requests

from src.infra.tec_api.client import APIClient


class AcademicUnitClient(APIClient):
    """Client for academic unit/career endpoints."""

    course_offer_request_delay_seconds = 1.5
    course_offer_retry_delays_seconds = (5.0, 15.0)
    schedule_request_delay_seconds = 0.5

    def __init__(self, verify_ssl: bool = True) -> None:
        super().__init__()
        self._alteonp_cookie: str = ""
        self._altesp_cookie: str = ""
        self._verify_ssl = verify_ssl

    def _get_cookies(self) -> tuple[str, str]:
        """Get AlteonP and AltesP cookies from page."""
        if self._alteonp_cookie:
            return self._alteonp_cookie, self._altesp_cookie

        try:
            self.session.get(
                "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx",
                verify=False,  # SSL issues only on this endpoint
                timeout=30,
            )
            # Extract cookies
            for cookie in self.session.cookies:
                if cookie.name == "AlteonP":
                    self._alteonp_cookie = cookie.value
                elif cookie.name == "AltesP":
                    self._altesp_cookie = cookie.value
        except requests.RequestException:
            pass

        return self._alteonp_cookie, self._altesp_cookie

    def get_carreras_json(self, campus_code: str) -> Any:
        """GET carga_carreras_json - returns JSON data (tecdigital, no SSL issues)."""
        endpoint = "tds-curriculum-exp/ajax/carga_carreras_json"
        params = {"id_sede": campus_code}
        response = self.session.get(
            f"{self.base_url}/{endpoint}", params=params, verify=True
        )
        response.raise_for_status()
        return response.json()

    def get_carreras_html(self, campus_code: str) -> dict[str, str]:
        """POST carga_carreras_tds_lib - returns HTML with career data."""
        endpoint = "tda-expediente-estudiantil/ajax/combos/carga_carreras_tds_lib"
        data = {"id_sede": campus_code, "accion": "cargar"}
        response = self.session.post(
            f"{self.base_url}/{endpoint}", data=data, verify=True
        )
        response.raise_for_status()

        # Parse HTML response: <span value='CODE'>Name</span>
        pattern = r"<span value='([^']+)'>([^<]+)</span>"
        matches = re.findall(pattern, response.text)
        return {code: name.upper().strip() for code, name in matches}

    def get_escuelas_with_cookie(self) -> dict[str, Any] | None:
        """POST cargaEscuelas - requires AlteonP/AltesP cookies."""
        # First ensure we have cookies
        alteonp, altesp = self._get_cookies()

        endpoint = (
            "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx/cargaEscuelas"
        )
        headers = {
            "Accept": "application/json, text/javascript, */*; q=0.01",
            "Accept-Language": "en-US,en;q=0.8",
            "Connection": "keep-alive",
            "Content-Length": "0",
            "Content-Type": "application/json; charset=utf-8",
            "Cookie": f"AlteonP={alteonp}; AltesP={altesp}",
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
            # Post with empty body (Content-Length: 0)
            response = self.session.post(
                endpoint,
                headers=headers,
                verify=False,  # SSL issues only on this endpoint
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            print(f"Error fetching escuelas: {e}")
            return None

    def get_oferta_cursos(self, school_code: str, year: str) -> Any:
        """POST getdatosEscuelaAno - returns course offer data for a school and year."""
        endpoint = "https://tec-appsext.itcr.ac.cr/guiahorarios/escuela.aspx/getdatosEscuelaAno"
        payload = {"escuela": school_code, "ano": year}

        for attempt_idx, delay_seconds in enumerate(
            (*self.course_offer_retry_delays_seconds, 0.0), 1
        ):
            self._get_cookies()
            headers = {
                "Accept": "application/json, text/javascript, */*; q=0.01",
                "Accept-Language": "en-US,en;q=0.8",
                "Connection": "keep-alive",
                "Content-Type": "application/json; charset=utf-8",
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
                    json=payload,
                    verify=False,
                    timeout=30,
                )
                response.raise_for_status()
                return response.json()
            except requests.HTTPError as e:
                status_code = e.response.status_code if e.response is not None else 0
                should_retry = status_code >= 500 and delay_seconds > 0
                if not should_retry:
                    print(
                        f"Error fetching oferta cursos for {school_code} year {year}: {e}",
                        flush=True,
                    )
                    return None
                self._reset_guiahorarios_cookies()
                print(
                    f"Retrying oferta cursos for {school_code} year {year} after HTTP {status_code} "
                    f"(attempt {attempt_idx})",
                    flush=True,
                )
                time.sleep(delay_seconds)
            except requests.RequestException as e:
                if delay_seconds <= 0:
                    print(
                        f"Error fetching oferta cursos for {school_code} year {year}: {e}",
                        flush=True,
                    )
                    return None
                self._reset_guiahorarios_cookies()
                print(
                    f"Retrying oferta cursos for {school_code} year {year} after request error "
                    f"(attempt {attempt_idx})",
                    flush=True,
                )
                time.sleep(delay_seconds)

        return None

    def _reset_guiahorarios_cookies(self) -> None:
        self._alteonp_cookie = ""
        self._altesp_cookie = ""
        self.session.cookies.clear()

    def download_oferta_cursos(
        self,
        output_dir: Path,
        school_codes: list[str],
        year: str,
        progress_callback: Callable[[int, int, str, str], None] | None = None,
    ) -> tuple[dict[str, Path], set[str], set[str]]:
        """Download course offer data for all schools for a given year."""
        output_dir = output_dir / "course_offer" / year
        output_dir.mkdir(parents=True, exist_ok=True)

        files: dict[str, Path] = {}
        empty_school_codes: set[str] = set()
        error_school_codes: set[str] = set()

        total = len(school_codes)
        for idx, code in enumerate(school_codes, 1):
            oferta = self.get_oferta_cursos(code, year)
            status = "empty"
            if oferta is None:
                status = "error"
                error_school_codes.add(code)
            elif oferta and self._has_course_offer_data(oferta):
                data = self._parse_oferta_cursos(oferta)
                if data:
                    file_path = output_dir / f"{code}.json"
                    file_path.write_text(json.dumps(data, indent=2, ensure_ascii=False))
                    files[code] = file_path
                    status = "saved"
                else:
                    empty_school_codes.add(code)
            else:
                empty_school_codes.add(code)
            if progress_callback is not None:
                progress_callback(idx, total, code, status)
            time.sleep(self.course_offer_request_delay_seconds)

        return files, empty_school_codes, error_school_codes

    def _parse_oferta_cursos(self, response: Any) -> Any:
        """Parse the course offer response, extracting and parsing the 'd' field."""
        if not response or not isinstance(response, dict):
            return None
        data_str = response.get("d")
        if not data_str or not isinstance(data_str, str):
            return None
        try:
            return json.loads(data_str)
        except json.JSONDecodeError:
            return None

    def _has_course_offer_data(self, response: Any) -> bool:
        """Check if the response contains actual course offer data."""
        if not response or not isinstance(response, dict):
            return False
        data = response.get("d")
        if data is None or data == "" or data == "NO DATOS":
            return False
        return True

    def get_horario_guia(self, sede: str, carrera: str, periodo: str) -> str:
        """POST tabla_guia_horario - returns HTML schedule data for a specific combination."""
        endpoint = "tda-expediente-estudiantil/ajax/tabla_guia_horario"
        data = {"sede": sede, "carrera": carrera, "periodo": periodo}
        try:
            response = self.session.post(
                f"{self.base_url}/{endpoint}", data=data, verify=True
            )
            response.raise_for_status()
            return response.text
        except requests.RequestException as e:
            print(f"Error fetching horario guia for {sede}/{carrera}/{periodo}: {e}")
            return ""

    def download_horarios_from_course_offer(
        self,
        output_dir: Path,
        year: str,
        fallback_school_codes: list[str] | None = None,
        course_offer_school_codes: list[str] | None = None,
        progress_callback: Callable[[int, int, str, str, str, str], None] | None = None,
    ) -> dict[str, Path]:
        """Download schedule data using already downloaded course offer files."""
        course_offer_dir = output_dir / "course_offer" / year

        output_dir = output_dir / "schedule_guia" / year
        output_dir.mkdir(parents=True, exist_ok=True)

        campus_path = output_dir.parent.parent / "campus" / "data.json"
        if not campus_path.exists():
            print(f"Campus data not found at {campus_path}")
            return {}

        campuses = json.loads(campus_path.read_text())
        dsc_sede_to_code = {c["name"]: c["code"] for c in campuses}

        files: dict[str, Path] = {}

        combinaciones: dict[tuple[str, str, str], str] = {}
        allowed_course_offer_schools = (
            set(course_offer_school_codes)
            if course_offer_school_codes is not None
            else None
        )

        if course_offer_dir.exists():
            for course_file in course_offer_dir.glob("*.json"):
                school_code = course_file.stem
                if (
                    allowed_course_offer_schools is not None
                    and school_code not in allowed_course_offer_schools
                ):
                    continue
                data = json.loads(course_file.read_text())
                if not data:
                    continue

                for row in data:
                    dsc_sede = row.get("DSC_SEDE", "")
                    sede_code = dsc_sede_to_code.get(dsc_sede)
                    if not sede_code:
                        continue

                    num_ano = str(row.get("NUM_ANO", ""))
                    ide_modalidad = row.get("IDE_MODALIDAD", "")
                    ide_per_mod = str(row.get("IDE_PER_MOD", ""))
                    periodo = f"{num_ano}_{ide_modalidad}_{ide_per_mod}"

                    key = (sede_code, school_code, periodo)
                    if key not in combinaciones:
                        combinaciones[key] = dsc_sede

        fallback_combinaciones = self._build_schedule_fallback_combinations(
            output_dir.parent.parent,
            year,
            sorted(set(fallback_school_codes or [])),
        )

        total_combinaciones = len(combinaciones) + sum(
            len(periodos)
            for _sede, _carrera, _modality_code, periodos in fallback_combinaciones
        )
        downloaded = 0
        failed = 0
        skipped = 0
        total_courses = 0
        processed = 0

        def remove_stale_schedule_file(sede: str, carrera: str, periodo: str) -> None:
            file_path = output_dir / f"{sede}_{carrera}_{periodo}.json"
            if file_path.exists():
                file_path.unlink()

        for (sede, carrera, periodo), _dsc_sede in combinaciones.items():
            processed += 1
            status = "empty"
            try:
                time.sleep(self.schedule_request_delay_seconds)
                html = self.get_horario_guia(sede, carrera, periodo)
                if html:
                    parsed_data = self._parse_horario_html(html)
                    if parsed_data:
                        file_name = f"{sede}_{carrera}_{periodo}.json"
                        file_path = output_dir / file_name
                        file_path.write_text(
                            json.dumps(parsed_data, indent=2, ensure_ascii=False)
                        )
                        files[file_name] = file_path
                        downloaded += 1
                        total_courses += len(parsed_data)
                        status = "saved"
                    else:
                        skipped += 1
                        status = "empty"
                        remove_stale_schedule_file(sede, carrera, periodo)
                else:
                    skipped += 1
                    status = "empty"
                    remove_stale_schedule_file(sede, carrera, periodo)
            except requests.RequestException:
                failed += 1
                status = "error"
            if progress_callback is not None:
                progress_callback(
                    processed, total_combinaciones, sede, carrera, periodo, status
                )

        for sede, carrera, _modality_code, periodos in fallback_combinaciones:
            skip_remaining_periods = False
            consecutive_empty_periods = 0
            for period_idx, periodo in enumerate(periodos):
                if skip_remaining_periods:
                    processed += 1
                    skipped += 1
                    remove_stale_schedule_file(sede, carrera, periodo)
                    if progress_callback is not None:
                        progress_callback(
                            processed,
                            total_combinaciones,
                            sede,
                            carrera,
                            periodo,
                            "fallback-skipped",
                        )
                    continue
                processed += 1
                status = "empty"
                try:
                    time.sleep(self.schedule_request_delay_seconds)
                    html = self.get_horario_guia(sede, carrera, periodo)
                    if html:
                        parsed_data = self._parse_horario_html(html)
                        if parsed_data:
                            file_name = f"{sede}_{carrera}_{periodo}.json"
                            file_path = output_dir / file_name
                            file_path.write_text(
                                json.dumps(parsed_data, indent=2, ensure_ascii=False)
                            )
                            files[file_name] = file_path
                            downloaded += 1
                            total_courses += len(parsed_data)
                            status = "saved"
                        else:
                            skipped += 1
                            remove_stale_schedule_file(sede, carrera, periodo)
                    else:
                        skipped += 1
                        remove_stale_schedule_file(sede, carrera, periodo)
                except requests.RequestException:
                    failed += 1
                    status = "error"

                if status == "empty":
                    consecutive_empty_periods += 1
                else:
                    consecutive_empty_periods = 0

                if period_idx == 1 and consecutive_empty_periods == 2:
                    skip_remaining_periods = True

                if progress_callback is not None:
                    progress_callback(
                        processed,
                        total_combinaciones,
                        sede,
                        carrera,
                        periodo,
                        f"fallback-{status}" if status != "error" else "fallback-error",
                    )

        if progress_callback is None:
            print(
                f"Download complete: {downloaded} files, {total_courses} courses, {skipped} skipped, {failed} failed"
            )

        return files

    def _build_schedule_fallback_combinations(
        self,
        data_dir: Path,
        year: str,
        school_codes: list[str],
    ) -> list[tuple[str, str, str, list[str]]]:
        if not school_codes:
            return []

        unit_path = data_dir / "academic_unit" / "data.json"
        relation_path = data_dir / "academic_unit_campus" / "data.json"
        campus_path = data_dir / "campus" / "data.json"
        term_path = data_dir / "academic_term" / "data.json"
        modality_path = data_dir / "academic_modality" / "data.json"
        required_paths = [
            unit_path,
            relation_path,
            campus_path,
            term_path,
            modality_path,
        ]
        if not all(path.exists() for path in required_paths):
            return []

        units = json.loads(unit_path.read_text())
        relations = json.loads(relation_path.read_text())
        campuses = json.loads(campus_path.read_text())
        terms = json.loads(term_path.read_text())
        modalities = json.loads(modality_path.read_text())

        unit_id_by_code = {u["code"]: int(u["id"]) for u in units}
        campus_code_by_id = {int(c["id"]): c["code"] for c in campuses}
        modality_code_by_id = {int(m["id"]): m["code"] for m in modalities}
        campuses_by_unit_id: dict[int, set[str]] = {}
        for relation in relations:
            unit_id = int(relation.get("academic_unit_id") or 0)
            campus_code = campus_code_by_id.get(int(relation.get("campus_id") or 0))
            if not campus_code:
                continue
            campuses_by_unit_id.setdefault(unit_id, set()).add(campus_code)

        periods_by_modality: dict[str, list[str]] = {}
        for term in terms:
            if str(term.get("year")) != str(year):
                continue
            modality_code = modality_code_by_id.get(
                int(term.get("academic_modality_id") or 0)
            )
            external_key = str(term.get("external_key") or "")
            if not modality_code or not external_key:
                continue
            periods_by_modality.setdefault(modality_code, []).append(external_key)

        for periodos in periods_by_modality.values():
            periodos.sort(key=lambda value: int(value.rsplit("_", 1)[-1]))

        # Load historical modalities from seed-history DB
        historical_path = data_dir / "academic_unit" / "historical_modalities.json"
        historical_modalities: dict[str, list[str]] = {}
        if historical_path.exists():
            try:
                historical_modalities = json.loads(historical_path.read_text())
            except Exception as e:
                print(f"Warning: Failed to parse historical_modalities.json: {e}")

        # Load study plans modalities
        study_plan_path = data_dir / "study_plan" / "data.json"
        active_modalities_by_unit: dict[int, set[str]] = {}
        if study_plan_path.exists():
            try:
                study_plans = json.loads(study_plan_path.read_text())
                for plan in study_plans:
                    unit_id = int(plan.get("academic_unit_id") or 0)
                    mod_id = int(plan.get("academic_modality_id") or 0)
                    mod_code = modality_code_by_id.get(mod_id)
                    if unit_id and mod_code:
                        active_modalities_by_unit.setdefault(unit_id, set()).add(mod_code)
            except Exception as e:
                print(f"Warning: Failed to parse study_plan/data.json: {e}")

        fallback_combinations: list[tuple[str, str, str, list[str]]] = []
        for school_code in school_codes:
            unit_id = unit_id_by_code.get(school_code)
            if unit_id is None:
                continue

            # Merge modalities from study plans and history
            allowed_modalities = set(active_modalities_by_unit.get(unit_id, set()))
            allowed_modalities.update(historical_modalities.get(school_code, []))

            for campus_code in sorted(campuses_by_unit_id.get(unit_id, set())):
                for modality_code, periodos in sorted(periods_by_modality.items()):
                    # If allowed_modalities is empty (e.g. clean run or new school),
                    # we do not filter (safe fallback). Otherwise we filter, but always allow Verano ('V').
                    if allowed_modalities and modality_code not in allowed_modalities and modality_code != "V":
                        continue
                    if periodos:
                        fallback_combinations.append(
                            (campus_code, school_code, modality_code, periodos)
                        )

        return fallback_combinations

    def download_raw(
        self, output_dir: Path, campus_codes: list[str]
    ) -> dict[str, Path]:
        """Download raw academic unit data for the provided campus codes."""
        output_dir = output_dir / "academic_unit"
        output_dir.mkdir(parents=True, exist_ok=True)

        combined: dict[str, Any] = {}
        for campus_code in campus_codes:
            try:
                data = self.get_carreras_json(campus_code)
            except requests.RequestException as e:
                print(f"Error downloading academic units for campus {campus_code}: {e}")
                continue

            if isinstance(data, dict):
                combined[campus_code] = data

        output_path = output_dir / "carga_carreras_json.json"
        output_path.write_text(json.dumps(combined, indent=2, ensure_ascii=False))

        return {"json": output_path}

    def _parse_horario_html(self, html: str) -> list[dict[str, Any]]:
        """Parse HTML table into structured JSON format."""
        from bs4 import BeautifulSoup

        if not html:
            return []

        try:
            soup = BeautifulSoup(html, "html.parser")
            table = soup.find("table", {"id": "tguiaHorario"})
            if not table:
                return []

            all_rows = table.find_all("tr")

            data_rows = []
            for row in all_rows:
                cells = row.find_all("td")
                if len(cells) >= 11:
                    data_rows.append(row)

            if not data_rows:
                return []

            result: list[dict[str, Any]] = []

            for row in data_rows:
                cells = row.find_all(["td"])
                if len(cells) < 11:
                    continue

                codigo = cells[0].get_text(strip=True)
                materia = cells[1].get_text(strip=True)
                grupo = cells[2].get_text(strip=True)
                creditos = cells[3].get_text(strip=True)
                raw_horario = cells[4].get_text(strip=True)
                aula = cells[5].get_text(strip=True)
                profesor = cells[6].get_text(strip=True)
                capacidad = cells[7].get_text(strip=True)
                tipo_materia = cells[8].get_text(strip=True).upper()
                tipo_grupo = cells[9].get_text(strip=True).upper()

                entries = self._parse_horario_entry(
                    codigo=codigo,
                    materia=materia,
                    grupo=grupo,
                    creditos=creditos,
                    raw_horario=raw_horario,
                    aula=aula,
                    profesor=profesor,
                    capacidad=capacidad,
                    tipo_materia=tipo_materia,
                    tipo_grupo=tipo_grupo,
                )

                result.extend(entries)

            return result
        except Exception as e:
            raise ValueError(f"Error parsing horario HTML: {e}") from e

    @staticmethod
    def _parse_required_int(value: str, field_name: str, context: str) -> int:
        """Parse a required numeric field from schedule HTML."""
        text = value.strip()
        if not text or not text.isdigit():
            msg = (
                f"Invalid numeric value for {field_name}: {value!r} "
                f"(context: {context})"
            )
            raise ValueError(msg)
        return int(text)

    def _parse_horario_entry(
        self,
        codigo: str,
        materia: str,
        grupo: str,
        creditos: str,
        raw_horario: str,
        aula: str,
        profesor: str,
        capacidad: str,
        tipo_materia: str,
        tipo_grupo: str,
    ) -> list[dict[str, Any]]:
        """Parse a single horario entry, splitting multi-day entries."""
        pattern = r"([A-Za-zÁÉÍÓÚáéíóúñ]+)\s*-\s*(\d{1,2}:\d{1,2}:\d{1,2}:\d{1,2})"
        matches = re.findall(pattern, raw_horario)

        if not matches:
            return []

        context = f"course={codigo}, group={grupo}, schedule={raw_horario}"
        credits_value = self._parse_required_int(creditos, "CAN_CREDITOS", context)
        capacity_value = self._parse_required_int(capacidad, "CAPACIDAD", context)

        entries = []
        for dia, time_range in matches:
            parts = time_range.split(":")
            if len(parts) != 4:
                continue
            h_inicio = f"{int(parts[0]):02d}:{int(parts[1]):02d}"
            h_fin = f"{int(parts[2]):02d}:{int(parts[3]):02d}"
            entries.append(
                {
                    "IDE_MATERIA": codigo,
                    "DSC_MATERIA": materia,
                    "IDE_GRUPO": grupo,
                    "CAN_CREDITOS": credits_value,
                    "CAPACIDAD": capacity_value,
                    "NOM_DIA": dia.upper(),
                    "HINICIO": h_inicio,
                    "HFIN": h_fin,
                    "AULA": aula,
                    "NOM_PROFESOR": profesor,
                    "TIPO_MATERIA": tipo_materia,
                    "TIPO_GRUPO": tipo_grupo,
                }
            )

        return entries
