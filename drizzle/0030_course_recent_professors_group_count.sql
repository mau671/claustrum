-- 0030_course_recent_professors_group_count.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_recent_professors(BIGINT, BIGINT, BIGINT, INTEGER);

CREATE OR REPLACE FUNCTION public.get_course_recent_professors(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_year_window INTEGER DEFAULT 2
)
RETURNS TABLE (
  professor_id BIGINT,
  professor_name TEXT,
  last_taught_term_id BIGINT,
  last_taught_term_name TEXT,
  last_taught_year INTEGER,
  last_taught_period_number INTEGER,
  groups_in_last_term_count BIGINT,
  terms_taught_count BIGINT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH relevant AS (
  SELECT
    p.id AS professor_id,
    p.full_name AS professor_name,
    at.id AS term_id,
    at.display_name AS term_name,
    at.year,
    at.period_number,
    cog.id AS group_id
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
  JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
  JOIN public.professor p ON p.id = cogp.professor_id
  WHERE co.course_id = p_course_id
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
    AND at.year >= (EXTRACT(YEAR FROM NOW())::INT - (GREATEST(COALESCE(p_year_window, 2), 1) - 1))
),
ranked AS (
  SELECT
    r.*,
    ROW_NUMBER() OVER (
      PARTITION BY r.professor_id
      ORDER BY r.year DESC, r.period_number DESC, r.term_id DESC
    ) AS row_num
  FROM relevant r
),
latest_term_per_professor AS (
  SELECT
    rk.professor_id,
    rk.professor_name,
    rk.term_id,
    rk.term_name,
    rk.year,
    rk.period_number
  FROM ranked rk
  WHERE rk.row_num = 1
),
groups_in_latest_term AS (
  SELECT
    l.professor_id,
    COUNT(DISTINCT r.group_id) AS groups_in_last_term_count
  FROM latest_term_per_professor l
  JOIN relevant r ON r.professor_id = l.professor_id AND r.term_id = l.term_id
  GROUP BY l.professor_id
),
counts AS (
  SELECT
    r.professor_id,
    COUNT(DISTINCT r.term_id) AS terms_taught_count
  FROM relevant r
  GROUP BY r.professor_id
)
SELECT
  l.professor_id,
  l.professor_name,
  l.term_id AS last_taught_term_id,
  l.term_name AS last_taught_term_name,
  l.year AS last_taught_year,
  l.period_number AS last_taught_period_number,
  COALESCE(g.groups_in_last_term_count, 0) AS groups_in_last_term_count,
  c.terms_taught_count
FROM latest_term_per_professor l
LEFT JOIN groups_in_latest_term g ON g.professor_id = l.professor_id
JOIN counts c ON c.professor_id = l.professor_id
ORDER BY l.year DESC, l.period_number DESC, l.professor_name;
$$;

COMMENT ON FUNCTION public.get_course_recent_professors IS 'Returns professors that taught a course in the recent year window and counts groups taught in each professor latest term.';
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO authenticated;

COMMIT;
