-- 0073_related_courses_include_offering_availability.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_detail_related_courses(BIGINT, BIGINT, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.get_course_detail_related_courses(
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_limit INTEGER DEFAULT 100,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  course_credits INTEGER,
  course_weekly_hours INTEGER,
  relation_kind TEXT,
  is_placeholder BOOLEAN,
  has_offerings BOOLEAN,
  total_equivalents BIGINT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH placeholder_state AS (
  SELECT public.is_schedule_placeholder_course(p_course_id, p_study_plan_id) AS is_placeholder
),
equivalents AS (
  SELECT DISTINCT
    c.id,
    c.code,
    c.name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.course_relation cr
  JOIN public.course c ON c.id = cr.to_course_id
  WHERE p_study_plan_id IS NOT NULL
    AND cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_course_id
    AND cr.relation_type = 'EQUIVALENT'
    AND c.name IS DISTINCT FROM c.code
),
equivalent_count AS (
  SELECT COUNT(*)::BIGINT AS total_count FROM equivalents
),
base_course AS (
  SELECT
    c.id,
    c.code,
    c.name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.course c
  WHERE c.id = p_course_id
),
paged_equivalents AS (
  SELECT *
  FROM equivalents
  ORDER BY code, id
  LIMIT p_limit
  OFFSET p_offset
)
SELECT
  bc.id AS course_id,
  bc.code AS course_code,
  bc.name AS course_name,
  bc.default_credits AS course_credits,
  bc.default_weekly_hours AS course_weekly_hours,
  'base'::TEXT AS relation_kind,
  ps.is_placeholder,
  EXISTS (
    SELECT 1
    FROM public.course_offering co
    WHERE co.course_id = bc.id
      AND co.is_active = TRUE
      AND EXISTS (
        SELECT 1
        FROM public.course_offering_group cog
        WHERE cog.course_offering_id = co.id
      )
  ) AS has_offerings,
  ec.total_count AS total_equivalents
FROM base_course bc
CROSS JOIN placeholder_state ps
CROSS JOIN equivalent_count ec
UNION ALL
SELECT
  eq.id AS course_id,
  eq.code AS course_code,
  eq.name AS course_name,
  eq.default_credits AS course_credits,
  eq.default_weekly_hours AS course_weekly_hours,
  'equivalent'::TEXT AS relation_kind,
  ps.is_placeholder,
  EXISTS (
    SELECT 1
    FROM public.course_offering co
    WHERE co.course_id = eq.id
      AND co.is_active = TRUE
      AND EXISTS (
        SELECT 1
        FROM public.course_offering_group cog
        WHERE cog.course_offering_id = co.id
      )
  ) AS has_offerings,
  ec.total_count AS total_equivalents
FROM paged_equivalents eq
CROSS JOIN placeholder_state ps
CROSS JOIN equivalent_count ec
ORDER BY relation_kind, course_code, course_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_course_detail_related_courses TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_detail_related_courses TO authenticated;

COMMIT;
