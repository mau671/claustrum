-- 0039_add_credits_hours_to_course_equivalents_rpc.sql

DROP FUNCTION IF EXISTS public.get_course_equivalents_for_plan(BIGINT, BIGINT, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.get_course_equivalents_for_plan(
  p_study_plan_id BIGINT,
  p_from_course_id BIGINT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  to_course_id BIGINT,
  to_course_code TEXT,
  to_course_name TEXT,
  to_course_credits INTEGER,
  to_course_weekly_hours INTEGER,
  total_count BIGINT
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
DECLARE
  v_total_count BIGINT;
BEGIN
  SELECT COUNT(DISTINCT cr.to_course_id) INTO v_total_count
  FROM public.course_relation cr
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_from_course_id
    AND cr.relation_type = 'EQUIVALENT';

  RETURN QUERY
  SELECT
    cr.to_course_id,
    c.code AS to_course_code,
    c.name AS to_course_name,
    c.default_credits AS to_course_credits,
    c.default_weekly_hours AS to_course_weekly_hours,
    v_total_count AS total_count
  FROM public.course_relation cr
  LEFT JOIN public.course c ON c.id = cr.to_course_id
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_from_course_id
    AND cr.relation_type = 'EQUIVALENT'
  ORDER BY c.code
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_course_equivalents_for_plan TO authenticated;
