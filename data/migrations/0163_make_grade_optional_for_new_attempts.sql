-- 0163_make_grade_optional_for_new_attempts.sql
-- Aligns insert_student_course_attempt with the UI and update_student_course_attempt:
-- APPROVED and FAILED attempts can be stored without a numeric grade.

BEGIN;

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_equivalent_course_id BIGINT DEFAULT NULL
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
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required for all attempts';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id,
    study_plan_id,
    course_id,
    attempt_number,
    status,
    grade,
    academic_term_id,
    equivalent_course_id,
    approved
  ) VALUES (
    p_user_id,
    p_study_plan_id,
    p_course_id,
    v_next_attempt_number,
    v_normalized_status,
    p_grade,
    p_academic_term_id,
    p_equivalent_course_id,
    (v_normalized_status = 'APPROVED')
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

COMMIT;
