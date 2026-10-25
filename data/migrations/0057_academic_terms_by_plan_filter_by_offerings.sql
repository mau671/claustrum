-- 0057_academic_terms_by_plan_filter_by_offerings.sql
-- Filters academic terms to only show those that have actual course offerings
-- for the plan's courses. Removes the fallback to all terms.

BEGIN;

CREATE OR REPLACE FUNCTION public.get_academic_terms_by_plan(
  p_study_plan_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL
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
WITH plan_courses AS (
  SELECT DISTINCT splc.course_id
  FROM public.study_plan_level spl
  JOIN public.study_plan_level_course splc ON splc.study_plan_level_id = spl.id
  WHERE spl.study_plan_id = p_study_plan_id
),
plan_related_courses AS (
  SELECT course_id FROM plan_courses
  UNION
  SELECT cr.to_course_id
  FROM public.course_relation cr
  JOIN public.course c ON c.id = cr.to_course_id
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.from_course_id IN (SELECT course_id FROM plan_courses)
    AND c.name <> c.code
  UNION
  SELECT cr.from_course_id
  FROM public.course_relation cr
  JOIN public.course c ON c.id = cr.from_course_id
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.to_course_id IN (SELECT course_id FROM plan_courses)
    AND c.name <> c.code
),
plan_modalities AS (
  SELECT DISTINCT at.academic_modality_id
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id IN (SELECT course_id FROM plan_related_courses)
    AND co.is_active = TRUE
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
)
SELECT DISTINCT
  at.id,
  at.academic_modality_id,
  at.year,
  at.period_number,
  at.external_key,
  at.display_name,
  at.starts_on,
  at.ends_on
FROM public.academic_term at
WHERE EXISTS (
    SELECT 1 FROM plan_modalities pm
    WHERE pm.academic_modality_id = at.academic_modality_id
  )
  AND EXISTS (
    SELECT 1 FROM public.course_offering co
    WHERE co.academic_term_id = at.id
      AND co.is_active = TRUE
      AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
      AND co.course_id IN (SELECT course_id FROM plan_related_courses)
  )
ORDER BY at.year DESC, at.period_number DESC;
$$;

COMMENT ON FUNCTION public.get_academic_terms_by_plan IS 'Returns academic terms for modalities that match the courses in a study plan, filtered to only terms with actual course offerings.';

GRANT EXECUTE ON FUNCTION public.get_academic_terms_by_plan TO anon;
GRANT EXECUTE ON FUNCTION public.get_academic_terms_by_plan TO authenticated;

COMMIT;
