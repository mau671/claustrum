-- 0037_update_student_course_attempt.sql

BEGIN;

CREATE OR REPLACE FUNCTION public.update_student_course_attempt(
  p_attempt_id BIGINT,
  p_academic_term_id BIGINT,
  p_grade NUMERIC(5,2) DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID;
  v_status public.student_course_status;
BEGIN
  SELECT scr.user_id, scr.status
  INTO v_user_id, v_status
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Attempt not found';
  END IF;

  IF auth.uid() IS NULL OR auth.uid() <> v_user_id THEN
    RAISE EXCEPTION 'Not authorized to update this attempt';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF v_status IN ('IN_PROGRESS', 'WITHDRAWN') THEN
    p_grade := NULL;
  END IF;

  UPDATE public.student_course_record
  SET
    academic_term_id = p_academic_term_id,
    grade = p_grade,
    approved = (status = 'APPROVED')
  WHERE id = p_attempt_id;
END;
$$;

COMMENT ON FUNCTION public.update_student_course_attempt IS 'Updates period and grade for a student course attempt owned by the authenticated user.';
GRANT EXECUTE ON FUNCTION public.update_student_course_attempt TO authenticated;

COMMIT;
