-- ============================================================================
-- MIGRATION: Add course equivalents function with pagination
-- ============================================================================
-- This migration adds a function to get course equivalents for a study plan
-- with pagination support for optimization with hundreds of equivalents per course.

DROP FUNCTION IF EXISTS public.get_course_equivalents_for_plan(BIGINT, BIGINT, INTEGER, INTEGER);

-- ============================================================================
-- FUNCTION: get_course_equivalents_for_plan
-- ============================================================================
-- Returns all course equivalents for a specific study plan with pagination.
-- Includes equivalents even if they are not in any level of the study plan.
-- Optimized with indexes for performance with hundreds of equivalents per course.
CREATE OR REPLACE FUNCTION public.get_course_equivalents_for_plan(
  p_study_plan_id BIGINT,
  p_from_course_id BIGINT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (to_course_id BIGINT, to_course_code TEXT, to_course_name TEXT, total_count BIGINT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
DECLARE
  v_total_count BIGINT;
BEGIN
  -- Get total count of equivalents for pagination
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

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.get_course_equivalents_for_plan TO authenticated;
