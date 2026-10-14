-- Migration 0089 changed course_evaluations.course_id and academic_term_id
-- from INT to BIGINT, but functions get_course_evaluations and
-- get_evaluation_moderation_queue still declare INT in RETURNS TABLE,
-- causing error 42804 at runtime.

DROP FUNCTION IF EXISTS public.get_course_evaluations(INT);

-- Fix get_course_evaluations
CREATE OR REPLACE FUNCTION public.get_course_evaluations(p_course_id INT)
RETURNS TABLE (
  id BIGINT,
  course_id BIGINT,
  academic_term_id BIGINT,
  professor_id BIGINT,
  evaluation_type TEXT,
  evaluation_number INT,
  custom_name TEXT,
  is_catedra BOOLEAN,
  includes_answers BOOLEAN,
  has_separate_answers BOOLEAN,
  file_key TEXT,
  file_size BIGINT,
  answers_file_key TEXT,
  status TEXT,
  created_at TIMESTAMPTZ,
  term_display_name TEXT,
  professor_name TEXT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    e.id,
    e.course_id,
    e.academic_term_id,
    e.professor_id,
    e.evaluation_type::TEXT,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::TEXT,
    e.created_at,
    at.display_name AS term_display_name,
    p.full_name AS professor_name
  FROM public.course_evaluations e
  LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
  LEFT JOIN public.professor p ON p.id = e.professor_id
  WHERE e.course_id = p_course_id
  ORDER BY e.evaluation_type, e.evaluation_number NULLS LAST;
$$;

REVOKE ALL ON FUNCTION public.get_course_evaluations(INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_course_evaluations(INT) TO authenticated;

DROP FUNCTION IF EXISTS public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT);

-- Fix get_evaluation_moderation_queue
CREATE OR REPLACE FUNCTION public.get_evaluation_moderation_queue(
  p_status public.evaluation_status,
  p_limit INT DEFAULT 50,
  p_offset INT DEFAULT 0
)
RETURNS TABLE (
  id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  academic_term_id BIGINT,
  term_display_name TEXT,
  professor_id BIGINT,
  professor_name TEXT,
  evaluation_type TEXT,
  evaluation_number INT,
  custom_name TEXT,
  is_catedra BOOLEAN,
  includes_answers BOOLEAN,
  has_separate_answers BOOLEAN,
  file_key TEXT,
  file_size BIGINT,
  answers_file_key TEXT,
  status TEXT,
  moderation_note TEXT,
  created_at TIMESTAMPTZ,
  total_count BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'forbidden'
      USING ERRCODE = '42501';
  END IF;

  RETURN QUERY
  SELECT
    e.id,
    e.course_id,
    c.code AS course_code,
    c.name AS course_name,
    e.academic_term_id,
    at.display_name AS term_display_name,
    e.professor_id,
    p.full_name AS professor_name,
    e.evaluation_type::TEXT,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::TEXT,
    e.moderation_note,
    e.created_at,
    COUNT(*) OVER () AS total_count
  FROM public.course_evaluations e
  JOIN public.course c ON c.id = e.course_id
  LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
  LEFT JOIN public.professor p ON p.id = e.professor_id
  WHERE e.status = p_status
  ORDER BY e.created_at DESC
  LIMIT GREATEST(COALESCE(p_limit, 50), 1)
  OFFSET GREATEST(COALESCE(p_offset, 0), 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) TO authenticated;
