-- 0105_add_equivalent_course_id_to_attempts.sql
-- Adds equivalent_course_id to student_course_record to track the actual course taken
-- when fulfilling a placeholder requirement (e.g. tracking that SE1107 was taken for SE1100).

BEGIN;

ALTER TABLE public.student_course_record
ADD COLUMN IF NOT EXISTS equivalent_course_id BIGINT REFERENCES public.course(id);

DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT, BIGINT);
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT, TEXT, BIGINT);

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_notes TEXT DEFAULT NULL,
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
    notes,
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
    NULLIF(BTRIM(p_notes), ''),
    NOW(),
    p_equivalent_course_id
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

COMMENT ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT, BIGINT) IS 'Registers a new attempt for a course, preserving retry history and optional equivalent course tracking.';
GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC, BIGINT, TEXT, BIGINT) TO authenticated;

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
  recorded_at TIMESTAMPTZ,
  equivalent_course_id BIGINT,
  equivalent_course_code TEXT,
  equivalent_course_name TEXT
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
  scr.recorded_at,
  scr.equivalent_course_id,
  ec.code AS equivalent_course_code,
  ec.name AS equivalent_course_name
FROM public.student_course_record scr
JOIN public.course c ON c.id = scr.course_id
LEFT JOIN public.course ec ON ec.id = scr.equivalent_course_id
WHERE scr.user_id = p_user_id
  AND scr.study_plan_id = p_study_plan_id
  AND scr.course_id = p_course_id
ORDER BY scr.recorded_at DESC NULLS LAST, scr.id DESC;
$$;

COMMENT ON FUNCTION public.get_student_course_attempts(UUID, BIGINT, BIGINT) IS 'Returns attempt history strictly for the requested course, including metadata about any explicitly tracked equivalent course taken.';
GRANT EXECUTE ON FUNCTION public.get_student_course_attempts(UUID, BIGINT, BIGINT) TO authenticated;

COMMIT;
