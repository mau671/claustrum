-- ============================================================================
-- FUNCTION: get_study_plan_courses_details (update to include level_label)
-- ============================================================================
-- This migration updates get_study_plan_courses_details function to return
-- level_label along with level_number, allowing the frontend to display
-- correct period labels (Semestre, Trimestre, Bimestre, etc.) instead of
-- always showing "Semestre X".

DROP FUNCTION IF EXISTS public.get_study_plan_courses_details(BIGINT);

CREATE OR REPLACE FUNCTION public.get_study_plan_courses_details(p_study_plan_id BIGINT)
RETURNS TABLE (
  course_id BIGINT,
  level_number INTEGER,
  level_label TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  sort_order INTEGER,
  course_code TEXT,
  course_name TEXT,
  default_credits INTEGER,
  default_weekly_hours INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    splc.course_id,
    spl.level_number,
    spl.level_label,
    splc.credits,
    splc.weekly_hours,
    splc.sort_order,
    c.code AS course_code,
    c.name AS course_name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.study_plan_level_course splc
  JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
  JOIN public.course c ON splc.course_id = c.id
  WHERE spl.study_plan_id = p_study_plan_id
  ORDER BY spl.level_number, splc.sort_order;
END;
$$;
