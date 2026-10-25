BEGIN;

-- 1. Modify insert_student_course_attempt to make grade and academic term optional
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
  IF public.current_user_id() IS NULL OR public.current_user_id() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
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
    academic_term_id,
    attempt_number,
    status,
    grade,
    approved,
    recorded_at,
    equivalent_course_id
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
    NOW(),
    p_equivalent_course_id
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

-- 2. Modify update_student_course_attempt to make grade and academic term optional
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

  IF p_status IS NOT NULL THEN
    v_new_status := UPPER(p_status)::public.student_course_status;
  ELSE
    v_new_status := v_current_status;
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
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

COMMIT;
