"""API client for study plan data."""

import json
from pathlib import Path
from typing import Any, Callable

import requests

from src.infra.tec_api.client import APIClient


class StudyPlanClient(APIClient):
    """Client for study plan endpoints."""

    def __init__(self, verify_ssl: bool = True) -> None:
        super().__init__()
        self._verify_ssl = verify_ssl

    def get_planes_json(
        self, campus_code: str, academic_unit_code: str
    ) -> dict[str, Any]:
        """GET carga_planes_json - returns JSON data for study plans.

        Returns format: {"planes": [{"key": 412, "data": "PLAN NAME"}, ...]}
        """
        endpoint = "tds-curriculum-exp/ajax/carga_planes_json"
        params = {"id_sede": campus_code, "id_depto": academic_unit_code}
        response = self.session.get(
            f"{self.base_url}/{endpoint}", params=params, verify=self._verify_ssl
        )
        response.raise_for_status()
        return response.json()

    def get_draw_angular(self, plan_key: int) -> dict[str, Any]:
        """GET json_draw_angular - returns complete study plan data.

        Returns format with: name, first_level, modalidad, niveles, cursos, etc.
        The plan_key is the external_plan_id from carga_planes_json.
        """
        endpoint = "tds-curriculum-exp/ajax/json_draw_angular"
        params = {"id_plan": plan_key}
        response = self.session.get(
            f"{self.base_url}/{endpoint}", params=params, verify=self._verify_ssl
        )
        response.raise_for_status()
        return response.json()

    def download_raw(
        self,
        output_dir: Path,
        academic_unit_campus_data: list[dict[str, Any]],
        fetch_complete_data: bool = True,
        delay_between_calls: float = 0.1,
        max_concurrency: int = 3,
        progress_callback: Callable[[dict[str, Any]], None] | None = None,
    ) -> dict[str, Path]:
        """Download raw study plan data for all academic unit - campus combinations.

        This method:
        1. Calls carga_planes_json for each campus-unit combination
        2. For each unique plan, calls json_draw_angular to get complete data
        3. Combines both sources, using json_draw_angular name with fallback
        4. Handles multi-campus study plans (same plan in multiple campuses)
        """

        """Download raw study plan data for all academic unit - campus combinations.

        This method:
        1. Calls carga_planes_json for each campus-unit combination
        2. For each plan found, calls json_draw_angular to get complete data
        3. Combines both sources, using json_draw_angular name with fallback
        4. Handles multi-campus study plans (same plan in multiple campuses)

        Args:
            output_dir: Directory to save downloaded data
            academic_unit_campus_data: List of {"campus_code": str, "academic_unit_code": str}
            fetch_complete_data: If True, fetch complete data via json_draw_angular
            delay_between_calls: Delay in seconds between API calls to avoid rate limiting

        Returns:
            Dict with paths to downloaded files
        """
        output_dir = output_dir / "study_plan"
        output_dir.mkdir(parents=True, exist_ok=True)

        from concurrent.futures import ThreadPoolExecutor, as_completed
        import time

        def report(event: str, **payload: Any) -> None:
            if progress_callback:
                progress_callback({"event": event, **payload})

        all_planes: dict[str, dict[str, Any]] = {}
        all_complete_planes: dict[str, dict[str, Any]] = {}
        errors: list[str] = []
        plans_without_study_plans: list[str] = []
        plan_cache: dict[int, dict[str, Any]] = {}
        plan_errors: dict[int, str] = {}
        plan_fallbacks: dict[int, str] = {}
        combo_plans: dict[str, dict[str, Any]] = {}
        unique_plan_ids: set[int] = set()

        total_relations = len(academic_unit_campus_data)
        processed_relations = 0
        total_plans_found = 0
        total_plans_fetched = 0
        total_plans_failed = 0

        for relation in academic_unit_campus_data:
            campus_code = relation.get("campus_code")
            academic_unit_code = relation.get("academic_unit_code")

            if not campus_code or not academic_unit_code:
                continue

            key = f"{campus_code}_{academic_unit_code}"
            processed_relations += 1

            try:
                planes_response = self.get_planes_json(campus_code, academic_unit_code)
                all_planes[key] = {
                    "campus_code": campus_code,
                    "academic_unit_code": academic_unit_code,
                    "data": planes_response,
                }

                planes_list = planes_response.get("planes", [])
                combo_plans[key] = {
                    "campus_code": campus_code,
                    "academic_unit_code": academic_unit_code,
                    "plans": planes_list,
                }
                total_plans_found += len(planes_list)
                for plan_item in planes_list:
                    plan_key = plan_item.get("key")
                    if not plan_key:
                        continue
                    plan_key_int = int(plan_key)
                    unique_plan_ids.add(plan_key_int)
                    plan_fallbacks.setdefault(plan_key_int, plan_item.get("data", ""))

                if not planes_list:
                    plans_without_study_plans.append(key)

            except requests.RequestException as e:
                errors.append(f"{key}: {e}")
                all_planes[key] = {
                    "campus_code": campus_code,
                    "academic_unit_code": academic_unit_code,
                    "data": None,
                    "error": str(e),
                }

            report(
                "combination",
                processed=processed_relations,
                total=total_relations,
                plans_found=total_plans_found,
                unique_plans=len(unique_plan_ids),
                plans_fetched=total_plans_fetched,
                plans_failed=total_plans_failed,
            )

        if fetch_complete_data and unique_plan_ids:
            report(
                "plans_total",
                total=len(unique_plan_ids),
                plans_found=total_plans_found,
            )

            def fetch_plan(
                plan_id: int,
            ) -> tuple[int, dict[str, Any] | None, str | None]:
                try:
                    data = self.get_draw_angular(plan_id)
                    if delay_between_calls:
                        time.sleep(delay_between_calls)
                    return plan_id, data, None
                except requests.RequestException as exc:
                    return plan_id, None, str(exc)

            with ThreadPoolExecutor(max_workers=max_concurrency) as executor:
                future_to_plan = {
                    executor.submit(fetch_plan, plan_id): plan_id
                    for plan_id in unique_plan_ids
                }
                for future in as_completed(future_to_plan):
                    plan_id = future_to_plan[future]
                    plan_id, data, error = future.result()
                    if error or data is None:
                        total_plans_failed += 1
                        plan_errors[plan_id] = error or "Unknown error"
                    else:
                        total_plans_fetched += 1
                        plan_cache[plan_id] = data

                    report(
                        "plan_detail",
                        plan_id=plan_id,
                        fetched=total_plans_fetched,
                        failed=total_plans_failed,
                        total=len(unique_plan_ids),
                        plans_found=total_plans_found,
                    )

        for key, combo in combo_plans.items():
            complete_planes_for_unit: list[dict[str, Any]] = []
            for plan_item in combo.get("plans", []):
                plan_key = plan_item.get("key")
                plan_name_fallback = plan_item.get("data")
                if not plan_key:
                    continue
                plan_key_int = int(plan_key)
                complete_data = plan_cache.get(plan_key_int)

                if complete_data is None and plan_key_int in plan_errors:
                    errors.append(f"{key}/plan_{plan_key}: {plan_errors[plan_key_int]}")
                    complete_planes_for_unit.append(
                        {
                            "external_plan_id": plan_key,
                            "name": plan_name_fallback,
                            "first_level_number": 0,
                            "modalidad": "",
                            "academic_degree": "",
                            "complete_data": None,
                            "error": plan_errors[plan_key_int],
                            "fallback_name_used": True,
                        }
                    )
                    continue

                if complete_data is None:
                    complete_planes_for_unit.append(
                        {
                            "external_plan_id": plan_key,
                            "name": plan_name_fallback,
                            "first_level_number": 0,
                            "modalidad": "",
                            "academic_degree": "",
                            "complete_data": None,
                            "fallback_name_used": True,
                        }
                    )
                    continue

                plan_name = (
                    complete_data.get("dsc_curriculum")
                    or complete_data.get("nombre")
                    or complete_data.get("name")
                    or plan_name_fallback
                )
                first_level = (
                    complete_data.get("first_level")
                    or complete_data.get("primer_nivel")
                    or complete_data.get("primer_nivel_number")
                    or 0
                )
                modalidad_key = (
                    complete_data.get("modality")
                    or complete_data.get("modalidad")
                    or complete_data.get("tipo_modalidad")
                    or ""
                )
                academic_degree = (
                    complete_data.get("academic_degree")
                    or complete_data.get("grado_academico")
                    or ""
                )

                complete_planes_for_unit.append(
                    {
                        "external_plan_id": plan_key,
                        "name": plan_name,
                        "first_level_number": int(first_level) if first_level else 0,
                        "modalidad": modalidad_key,
                        "academic_degree": academic_degree,
                        "complete_data": complete_data,
                        "fallback_name_used": plan_name is None
                        or plan_name == plan_name_fallback,
                    }
                )

            all_complete_planes[key] = {
                "campus_code": combo.get("campus_code"),
                "academic_unit_code": combo.get("academic_unit_code"),
                "plans": complete_planes_for_unit,
            }

        if plans_without_study_plans:
            report(
                "no_plans",
                count=len(plans_without_study_plans),
                combos=plans_without_study_plans,
            )

        if errors:
            report("errors", count=len(errors), errors=errors)

        if plans_without_study_plans:
            print(
                f"Careers without study plans ({len(plans_without_study_plans)} total):"
            )
            for key in plans_without_study_plans[:10]:
                print(f"  - {key}")
            if len(plans_without_study_plans) > 10:
                print(f"  ... and {len(plans_without_study_plans) - 10} more")

        if errors:
            print(f"Errors fetching study plans ({len(errors)} total):")
            for error in errors[:10]:
                print(f"  - {error}")
            if len(errors) > 10:
                print(f"  ... and {len(errors) - 10} more")

        files: dict[str, Path] = {}

        output_path = output_dir / "carga_planes_json.json"
        output_path.write_text(json.dumps(all_planes, indent=2, ensure_ascii=False))
        files["json"] = output_path

        if all_complete_planes:
            complete_path = output_dir / "json_draw_angular.json"
            complete_path.write_text(
                json.dumps(all_complete_planes, indent=2, ensure_ascii=False)
            )
            files["complete"] = complete_path

        report(
            "complete",
            files=files,
            plans_found=total_plans_found,
            plans_fetched=total_plans_fetched,
            plans_failed=total_plans_failed,
        )

        return files
