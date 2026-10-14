-- 0054_attempts_include_equivalences_and_course_metadata.sql
-- Allows viewing attempts recorded on equivalent courses for a plan.

BEGIN;

DROP FUNCTION IF EXISTS public.get_student_course_attempts(UUID, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.get_student_course_attempts(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT
)
RETURNS TABLE (
  id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  attempt_number INTEGER,
  status TEXT,
  grade NUMERIC(5,2),
  academic_term_id BIGINT,
  recorded_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH related_courses AS (
  SELECT p_course_id AS course_id
  UNION
  SELECT cr.to_course_id
  FROM public.course_relation cr
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.from_course_id = p_course_id
  UNION
  SELECT cr.from_course_id
  FROM public.course_relation cr
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.to_course_id = p_course_id
)
SELECT
  scr.id,
  scr.course_id,
  c.code AS course_code,
  c.name AS course_name,
  scr.attempt_number,
  LOWER(scr.status::TEXT) AS status,
  scr.grade,
  scr.academic_term_id,
  scr.recorded_at
FROM public.student_course_record scr
JOIN public.course c ON c.id = scr.course_id
WHERE scr.user_id = p_user_id
  AND scr.study_plan_id = p_study_plan_id
  AND scr.course_id IN (SELECT rc.course_id FROM related_courses rc)
ORDER BY scr.recorded_at DESC NULLS LAST, scr.id DESC;
$$;

COMMENT ON FUNCTION public.get_student_course_attempts IS 'Returns attempt history for a course including equivalent courses in the same study plan, with source course metadata.';
GRANT EXECUTE ON FUNCTION public.get_student_course_attempts TO authenticated;

COMMIT;
