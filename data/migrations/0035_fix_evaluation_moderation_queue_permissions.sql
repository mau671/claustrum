-- 0035_fix_evaluation_moderation_queue_permissions.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT);

CREATE OR REPLACE FUNCTION public.get_evaluation_moderation_queue(
  p_status public.evaluation_status,
  p_limit INT DEFAULT 50,
  p_offset INT DEFAULT 0
)
RETURNS TABLE (
  id BIGINT,
  course_id INT,
  course_code TEXT,
  course_name TEXT,
  academic_term_id INT,
  term_display_name TEXT,
  professor_id BIGINT,
  professor_name TEXT,
  uploaded_by UUID,
  uploader_email TEXT,
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
SECURITY DEFINER
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
    e.uploaded_by,
    au.email AS uploader_email,
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
  LEFT JOIN auth.users au ON au.id = e.uploaded_by
  WHERE e.status = p_status
  ORDER BY e.created_at DESC
  LIMIT GREATEST(COALESCE(p_limit, 50), 1)
  OFFSET GREATEST(COALESCE(p_offset, 0), 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) TO authenticated;

COMMENT ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT)
IS 'Returns moderation queue for course evaluations. Requires admin role and runs as security definer to read uploader email safely.';

COMMIT;
