-- 0071_course_detail_shared_placeholder_options.sql

BEGIN;

CREATE OR REPLACE FUNCTION public.is_schedule_placeholder_course(
  p_course_id BIGINT,
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.course c
    JOIN public.schedule_equivalence_placeholder_course sep
      ON sep.is_active = TRUE
     AND (sep.study_plan_id IS NULL OR sep.study_plan_id = p_study_plan_id)
     AND (
       (sep.course_code IS NOT NULL AND sep.course_code = c.code)
       OR (
         sep.course_name_ilike_pattern IS NOT NULL
         AND c.name ILIKE sep.course_name_ilike_pattern
       )
     )
    WHERE c.id = p_course_id
  );
$$;

GRANT EXECUTE ON FUNCTION public.is_schedule_placeholder_course TO anon;
GRANT EXECUTE ON FUNCTION public.is_schedule_placeholder_course TO authenticated;

CREATE OR REPLACE FUNCTION public.get_course_detail_related_courses(
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_limit INTEGER DEFAULT 100,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  course_credits INTEGER,
  course_weekly_hours INTEGER,
  relation_kind TEXT,
  is_placeholder BOOLEAN,
  total_equivalents BIGINT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH placeholder_state AS (
  SELECT public.is_schedule_placeholder_course(p_course_id, p_study_plan_id) AS is_placeholder
),
equivalents AS (
  SELECT DISTINCT
    c.id,
    c.code,
    c.name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.course_relation cr
  JOIN public.course c ON c.id = cr.to_course_id
  WHERE p_study_plan_id IS NOT NULL
    AND cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_course_id
    AND cr.relation_type = 'EQUIVALENT'
    AND c.name IS DISTINCT FROM c.code
),
equivalent_count AS (
  SELECT COUNT(*)::BIGINT AS total_count FROM equivalents
),
base_course AS (
  SELECT
    c.id,
    c.code,
    c.name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.course c
  WHERE c.id = p_course_id
),
paged_equivalents AS (
  SELECT *
  FROM equivalents
  ORDER BY code, id
  LIMIT p_limit
  OFFSET p_offset
)
SELECT
  bc.id AS course_id,
  bc.code AS course_code,
  bc.name AS course_name,
  bc.default_credits AS course_credits,
  bc.default_weekly_hours AS course_weekly_hours,
  'base'::TEXT AS relation_kind,
  ps.is_placeholder,
  ec.total_count AS total_equivalents
FROM base_course bc
CROSS JOIN placeholder_state ps
CROSS JOIN equivalent_count ec
UNION ALL
SELECT
  eq.id AS course_id,
  eq.code AS course_code,
  eq.name AS course_name,
  eq.default_credits AS course_credits,
  eq.default_weekly_hours AS course_weekly_hours,
  'equivalent'::TEXT AS relation_kind,
  ps.is_placeholder,
  ec.total_count AS total_equivalents
FROM paged_equivalents eq
CROSS JOIN placeholder_state ps
CROSS JOIN equivalent_count ec
ORDER BY relation_kind, course_code, course_id;
$$;

GRANT EXECUTE ON FUNCTION public.get_course_detail_related_courses TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_detail_related_courses TO authenticated;

DROP FUNCTION IF EXISTS public.get_course_evaluations(INT);

CREATE OR REPLACE FUNCTION public.get_course_evaluations(
  p_course_id INT,
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  id BIGINT,
  course_id INT,
  course_code TEXT,
  course_name TEXT,
  academic_term_id INT,
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
  WITH related_courses AS (
    SELECT rel.course_id
    FROM public.get_course_detail_related_courses(
      p_study_plan_id,
      p_course_id,
      10000,
      0
    ) rel
    WHERE rel.relation_kind = 'base'
       OR rel.is_placeholder = TRUE
  )
  SELECT
    e.id,
    e.course_id,
    c.code AS course_code,
    c.name AS course_name,
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
  JOIN public.course c ON c.id = e.course_id
  LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
  LEFT JOIN public.professor p ON p.id = e.professor_id
  WHERE e.course_id IN (SELECT rc.course_id FROM related_courses rc)
    AND e.status = 'approved'
  ORDER BY e.created_at DESC;
$$;

GRANT EXECUTE ON FUNCTION public.get_course_evaluations(INT, BIGINT) TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_evaluations(INT, BIGINT) TO authenticated;

COMMIT;
