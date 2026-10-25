-- 0068_course_detail_terms_placeholder_equivalents.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_offering_terms(BIGINT, BIGINT, BIGINT);
DROP FUNCTION IF EXISTS public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.get_course_offering_terms(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_study_plan_id BIGINT DEFAULT NULL
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
WITH placeholder_course AS (
  SELECT c.id AS course_id
  FROM public.course c
  JOIN public.schedule_equivalence_placeholder_course sep
    ON sep.course_code = c.code
   AND sep.is_active = TRUE
  WHERE c.id = p_course_id
  LIMIT 1
),
related_courses AS (
  SELECT p_course_id AS course_id
  UNION
  SELECT cr.to_course_id
  FROM public.course_relation cr
  WHERE p_study_plan_id IS NOT NULL
    AND EXISTS (SELECT 1 FROM placeholder_course)
    AND cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.from_course_id = p_course_id
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
FROM public.course_offering co
JOIN public.academic_term at ON at.id = co.academic_term_id
WHERE co.course_id IN (SELECT course_id FROM related_courses)
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
  AND EXISTS (
    SELECT 1
    FROM public.course_offering_group cog
    WHERE cog.course_offering_id = co.id
  )
ORDER BY at.year DESC, at.period_number DESC, at.id DESC;
$$;

COMMENT ON FUNCTION public.get_course_offering_terms IS 'Returns academic terms where a course has active offerings with at least one group. For placeholder courses, includes equivalents within the selected study plan.';
GRANT EXECUTE ON FUNCTION public.get_course_offering_terms TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_offering_terms TO authenticated;

CREATE OR REPLACE FUNCTION public.get_course_latest_term_groups(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  academic_term_id BIGINT,
  term_display_name TEXT,
  term_year INTEGER,
  term_period_number INTEGER,
  group_id BIGINT,
  group_code TEXT,
  group_type TEXT,
  capacity INTEGER,
  campus_id BIGINT,
  campus_name TEXT,
  professors JSONB,
  meetings JSONB
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH placeholder_course AS (
  SELECT c.id AS course_id
  FROM public.course c
  JOIN public.schedule_equivalence_placeholder_course sep
    ON sep.course_code = c.code
   AND sep.is_active = TRUE
  WHERE c.id = p_course_id
  LIMIT 1
),
related_courses AS (
  SELECT p_course_id AS course_id
  UNION
  SELECT cr.to_course_id
  FROM public.course_relation cr
  WHERE p_study_plan_id IS NOT NULL
    AND EXISTS (SELECT 1 FROM placeholder_course)
    AND cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.from_course_id = p_course_id
),
selected_term AS (
  SELECT
    at.id,
    at.display_name,
    at.year,
    at.period_number
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id IN (SELECT course_id FROM related_courses)
    AND co.is_active = TRUE
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
    AND EXISTS (
      SELECT 1
      FROM public.course_offering_group g
      WHERE g.course_offering_id = co.id
    )
    AND (p_academic_term_id IS NULL OR at.id = p_academic_term_id)
  ORDER BY at.year DESC, at.period_number DESC, at.id DESC
  LIMIT 1
)
SELECT
  st.id AS academic_term_id,
  st.display_name AS term_display_name,
  st.year AS term_year,
  st.period_number AS term_period_number,
  g.id AS group_id,
  g.group_code,
  g.group_type::TEXT AS group_type,
  g.capacity,
  co.campus_id,
  cp.name AS campus_name,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'id', p.id,
        'name', p.full_name
      )
      ORDER BY p.full_name
    )
    FROM public.course_offering_group_professor cogp
    JOIN public.professor p ON p.id = cogp.professor_id
    WHERE cogp.course_offering_group_id = g.id
  ), '[]'::jsonb) AS professors,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'weekday', com.weekday,
        'starts_at', com.starts_at::TEXT,
        'ends_at', com.ends_at::TEXT,
        'classroom', com.classroom
      )
      ORDER BY com.weekday, com.starts_at
    )
    FROM public.course_offering_meeting com
    WHERE com.course_offering_group_id = g.id
  ), '[]'::jsonb) AS meetings
FROM selected_term st
JOIN public.course_offering co ON co.academic_term_id = st.id
JOIN public.course_offering_group g ON g.course_offering_id = co.id
LEFT JOIN public.campus cp ON cp.id = co.campus_id
WHERE co.course_id IN (SELECT course_id FROM related_courses)
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
ORDER BY
  CASE WHEN g.group_code ~ '^[0-9]+$' THEN (g.group_code)::INT ELSE 99999 END,
  g.group_code,
  g.id;
$$;

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns groups for a course in the selected academic term, or latest term with offerings when no term is provided. For placeholder courses, includes equivalents within the selected study plan.';
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO authenticated;

COMMIT;
