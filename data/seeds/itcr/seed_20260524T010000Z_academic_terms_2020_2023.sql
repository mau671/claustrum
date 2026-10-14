-- ============================================================================
-- TEC-DATA ACADEMIC TERMS 2020-2023
-- ============================================================================

BEGIN;

WITH generated_terms AS (
  SELECT
    117 + ROW_NUMBER() OVER (ORDER BY term_year, modality.id, period_number) AS id,
    modality.id AS academic_modality_id,
    term_year AS year,
    period_number,
    term_year::TEXT || '_' || modality.code || '_' || period_number::TEXT AS external_key,
    term_year::TEXT || ' - ' || modality.name || ' ' || period_number::TEXT AS display_name
  FROM generate_series(2020, 2023) AS years(term_year)
  CROSS JOIN public.academic_modality AS modality
  CROSS JOIN LATERAL generate_series(1, modality.periods_per_year) AS periods(period_number)
)
INSERT INTO public.academic_term (
  id,
  academic_modality_id,
  year,
  period_number,
  external_key,
  display_name,
  starts_on,
  ends_on,
  is_active,
  deactivated_at
)
SELECT
  id,
  academic_modality_id,
  year,
  period_number,
  external_key,
  display_name,
  NULL,
  NULL,
  TRUE,
  NULL
FROM generated_terms
ON CONFLICT (external_key) DO UPDATE SET
  academic_modality_id = EXCLUDED.academic_modality_id,
  year = EXCLUDED.year,
  period_number = EXCLUDED.period_number,
  display_name = EXCLUDED.display_name,
  starts_on = EXCLUDED.starts_on,
  ends_on = EXCLUDED.ends_on,
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW();

SELECT setval(
  'public.academic_term_id_seq',
  (SELECT COALESCE(MAX(id), 1) FROM public.academic_term),
  TRUE
);

COMMIT;
