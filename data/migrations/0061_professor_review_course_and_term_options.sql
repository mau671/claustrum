-- 0061_professor_review_course_and_term_options.sql

BEGIN;

ALTER TABLE public.professor_review
ADD COLUMN IF NOT EXISTS academic_term_id BIGINT REFERENCES public.academic_term(id) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE INDEX IF NOT EXISTS idx_professor_review_academic_term_id
  ON public.professor_review (academic_term_id);

CREATE OR REPLACE FUNCTION public.get_professor_review_courses(
  p_professor_id BIGINT,
  p_limit INTEGER DEFAULT 200
)
RETURNS TABLE (
  id BIGINT,
  code TEXT,
  name TEXT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    c.id,
    c.code,
    c.name
  FROM public.course c
  WHERE EXISTS (
    SELECT 1
    FROM public.course_offering_group_professor cogp
    JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
    JOIN public.course_offering co ON co.id = cog.course_offering_id
    WHERE cogp.professor_id = p_professor_id
      AND co.course_id = c.id
      AND co.is_active = TRUE
  )
  ORDER BY c.code ASC
  LIMIT GREATEST(1, LEAST(COALESCE(p_limit, 200), 500));
$$;

CREATE OR REPLACE FUNCTION public.get_professor_offering_terms(
  p_professor_id BIGINT,
  p_limit INTEGER DEFAULT 200
)
RETURNS TABLE (
  id BIGINT,
  academic_modality_id BIGINT,
  year INTEGER,
  period_number INTEGER,
  external_key TEXT,
  display_name TEXT,
  starts_on DATE,
  ends_on DATE
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT DISTINCT
    at.id,
    at.academic_modality_id,
    at.year,
    at.period_number,
    at.external_key,
    at.display_name,
    at.starts_on,
    at.ends_on
  FROM public.academic_term at
  JOIN public.course_offering co ON co.academic_term_id = at.id
  JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
  JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
  WHERE cogp.professor_id = p_professor_id
    AND co.is_active = TRUE
  ORDER BY at.year DESC, at.period_number DESC, at.id DESC
  LIMIT GREATEST(1, LEAST(COALESCE(p_limit, 200), 500));
$$;

GRANT EXECUTE ON FUNCTION public.get_professor_review_courses TO anon;
GRANT EXECUTE ON FUNCTION public.get_professor_review_courses TO authenticated;

GRANT EXECUTE ON FUNCTION public.get_professor_offering_terms TO anon;
GRANT EXECUTE ON FUNCTION public.get_professor_offering_terms TO authenticated;

COMMIT;
