-- 0028_drop_attempt_notes_add_required_term_input.sql
-- Removes free-text notes from attempts and keeps period selection as structured data.

BEGIN;

DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.get_student_course_attempts(UUID, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_normalized_status public.student_course_status;
  v_next_attempt_number INTEGER;
  v_inserted_id BIGINT;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF v_normalized_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  SELECT COALESCE(MAX(scr.attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id,
    study_plan_id,
    course_id,
    academic_term_id,
    attempt_number,
    status,
    grade,
    approved,
    recorded_at
  )
  VALUES (
    p_user_id,
    p_study_plan_id,
    p_course_id,
    p_academic_term_id,
    v_next_attempt_number,
    v_normalized_status,
    p_grade,
    (v_normalized_status = 'APPROVED'),
    NOW()
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

COMMENT ON FUNCTION public.insert_student_course_attempt IS 'Registers a new attempt for a course, requiring an academic term and preserving retry history.';
GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt TO authenticated;

CREATE OR REPLACE FUNCTION public.get_student_course_attempts(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT
)
RETURNS TABLE (
  id BIGINT,
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
  scr.attempt_number,
  LOWER(scr.status::TEXT) AS status,
  scr.grade,
  scr.academic_term_id,
  scr.recorded_at
FROM public.student_course_record scr
WHERE scr.user_id = p_user_id
  AND scr.study_plan_id = p_study_plan_id
  AND scr.course_id = p_course_id
ORDER BY scr.attempt_number DESC, scr.recorded_at DESC NULLS LAST, scr.id DESC;
$$;

COMMENT ON FUNCTION public.get_student_course_attempts IS 'Returns full attempt history for a course and user.';
GRANT EXECUTE ON FUNCTION public.get_student_course_attempts TO authenticated;

ALTER TABLE public.student_course_record
DROP COLUMN IF EXISTS notes;

COMMIT;
