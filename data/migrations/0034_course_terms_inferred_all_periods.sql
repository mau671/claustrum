-- 0034_course_terms_inferred_all_periods.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_active_academic_terms(BIGINT, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.get_course_active_academic_terms(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  id BIGINT,
  academic_modality_id BIGINT,
  year INTEGER,
  period_number INTEGER,
  external_key TEXT,
  display_name TEXT,
  starts_on DATE,
  ends_on DATE
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH inferred_modalities AS (
  SELECT DISTINCT at.academic_modality_id
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id = p_course_id
    AND co.is_active = TRUE
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
)
SELECT
  at.id,
  at.academic_modality_id,
  at.year,
  at.period_number,
  at.external_key,
  at.display_name,
  at.starts_on,
  at.ends_on
FROM public.academic_term at
WHERE (
  EXISTS (
    SELECT 1
    FROM inferred_modalities im
    WHERE im.academic_modality_id = at.academic_modality_id
  )
  OR NOT EXISTS (SELECT 1 FROM inferred_modalities)
)
ORDER BY at.year DESC, at.period_number DESC;
$$;

COMMENT ON FUNCTION public.get_course_active_academic_terms IS 'Returns all academic terms for modalities inferred from course offerings (not limited to active terms). Falls back to all terms when there is no course history.';

GRANT EXECUTE ON FUNCTION public.get_course_active_academic_terms TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_active_academic_terms TO authenticated;

COMMIT;
