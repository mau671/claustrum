-- 0109_delete_and_update_student_course_attempts.sql
-- Adds delete_student_course_attempt and modifies update_student_course_attempt to support status and equivalents

BEGIN;

DROP FUNCTION IF EXISTS public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2));

CREATE OR REPLACE FUNCTION public.update_student_course_attempt(
  p_attempt_id BIGINT,
  p_academic_term_id BIGINT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_status TEXT DEFAULT NULL,
  p_equivalent_course_id BIGINT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID;
  v_current_status public.student_course_status;
  v_new_status public.student_course_status;
BEGIN
  SELECT scr.user_id, scr.status
  INTO v_user_id, v_current_status
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Attempt not found';
  END IF;

  IF public.current_user_id() IS NULL OR public.current_user_id() <> v_user_id THEN
    RAISE EXCEPTION 'Not authorized to update this attempt';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  IF p_status IS NOT NULL THEN
    v_new_status := UPPER(p_status)::public.student_course_status;
  ELSE
    v_new_status := v_current_status;
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_new_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF v_new_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  UPDATE public.student_course_record
  SET
    academic_term_id = p_academic_term_id,
    grade = p_grade,
    status = v_new_status,
    equivalent_course_id = p_equivalent_course_id,
    approved = (v_new_status = 'APPROVED')
  WHERE id = p_attempt_id;
END;
$$;


CREATE OR REPLACE FUNCTION public.delete_student_course_attempt(
  p_attempt_id BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID;
  v_study_plan_id BIGINT;
  v_course_id BIGINT;
BEGIN
  SELECT scr.user_id, scr.study_plan_id, scr.course_id
  INTO v_user_id, v_study_plan_id, v_course_id
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Attempt not found';
  END IF;

  IF public.current_user_id() IS NULL OR public.current_user_id() <> v_user_id THEN
    RAISE EXCEPTION 'Not authorized to delete this attempt';
  END IF;

  DELETE FROM public.student_course_record
  WHERE id = p_attempt_id;

  -- Recalculate attempt_number for the remaining attempts
  WITH ranked_attempts AS (
    SELECT
      id,
      ROW_NUMBER() OVER (
        PARTITION BY user_id, study_plan_id, course_id
        ORDER BY recorded_at ASC NULLS LAST, id ASC
      ) AS rn
    FROM public.student_course_record
    WHERE user_id = v_user_id 
      AND study_plan_id = v_study_plan_id 
      AND course_id = v_course_id
  )
  UPDATE public.student_course_record scr
  SET attempt_number = ra.rn
  FROM ranked_attempts ra
  WHERE scr.id = ra.id
    AND scr.attempt_number <> ra.rn;

END;
$$;

GRANT EXECUTE ON FUNCTION public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2), TEXT, BIGINT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2), TEXT, BIGINT) TO service_role;

GRANT EXECUTE ON FUNCTION public.delete_student_course_attempt(BIGINT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.delete_student_course_attempt(BIGINT) TO service_role;

COMMIT;
