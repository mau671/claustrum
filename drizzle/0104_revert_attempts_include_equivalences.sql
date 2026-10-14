-- 0104_revert_attempts_include_equivalences.sql
-- Reverts migration 0054 to only return attempts for the explicitly requested course.
-- Equivalent course attempts are already displayed via the effective status origin metadata
-- in the UI. Returning them in the history causes confusion when multiple placeholders
-- share the same equivalents and a greedy match assigns the attempt to a different placeholder.

BEGIN;

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
  AND scr.course_id = p_course_id
ORDER BY scr.recorded_at DESC NULLS LAST, scr.id DESC;
$$;

COMMENT ON FUNCTION public.get_student_course_attempts IS 'Returns attempt history strictly for the requested course. Equivalent attempts are excluded from history to avoid overlap across placeholders.';

COMMIT;
