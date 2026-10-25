-- 0108_fix_insert_student_course_attempt_signature.sql
-- Fixes the function signature and body for insert_student_course_attempt
-- to properly exclude the 'notes' column which was dropped in migration 0028.

BEGIN;

-- Drop versions that might have been created by mistake
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT, BIGINT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, TEXT, BIGINT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, BIGINT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, BIGINT);

-- Create the correct version without p_notes and without notes in the INSERT
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
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
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

GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, BIGINT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, BIGINT) TO service_role;

COMMIT;
