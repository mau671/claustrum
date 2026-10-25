-- 0029_course_detail_professors_and_latest_groups.sql

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
    at.period_number
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
counts AS (
  SELECT
    r.professor_id,
    COUNT(DISTINCT r.term_id) AS terms_taught_count
  FROM relevant r
  GROUP BY r.professor_id
)
SELECT
  rk.professor_id,
  rk.professor_name,
  rk.term_id AS last_taught_term_id,
  rk.term_name AS last_taught_term_name,
  rk.year AS last_taught_year,
  rk.period_number AS last_taught_period_number,
  c.terms_taught_count
FROM ranked rk
JOIN counts c ON c.professor_id = rk.professor_id
WHERE rk.row_num = 1
ORDER BY rk.year DESC, rk.period_number DESC, rk.professor_name;
$$;

COMMENT ON FUNCTION public.get_course_recent_professors IS 'Returns professors that taught a course in the recent year window (default 2 years).';
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO authenticated;

DROP FUNCTION IF EXISTS public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.get_course_latest_term_groups(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  academic_term_id BIGINT,
  term_display_name TEXT,
  term_year INTEGER,
  term_period_number INTEGER,
  group_id BIGINT,
  group_code TEXT,
  group_type TEXT,
  capacity INTEGER,
  campus_id BIGINT,
  campus_name TEXT,
  professors JSONB,
  meetings JSONB
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH latest_term AS (
  SELECT
    at.id,
    at.display_name,
    at.year,
    at.period_number
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id = p_course_id
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
    AND EXISTS (
      SELECT 1
      FROM public.course_offering_group g
      WHERE g.course_offering_id = co.id
    )
  ORDER BY at.year DESC, at.period_number DESC, at.id DESC
  LIMIT 1
)
SELECT
  lt.id AS academic_term_id,
  lt.display_name AS term_display_name,
  lt.year AS term_year,
  lt.period_number AS term_period_number,
  g.id AS group_id,
  g.group_code,
  g.group_type::TEXT AS group_type,
  g.capacity,
  co.campus_id,
  cp.name AS campus_name,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'id', p.id,
        'name', p.full_name
      )
      ORDER BY p.full_name
    )
    FROM public.course_offering_group_professor cogp
    JOIN public.professor p ON p.id = cogp.professor_id
    WHERE cogp.course_offering_group_id = g.id
  ), '[]'::jsonb) AS professors,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'weekday', com.weekday,
        'starts_at', com.starts_at::TEXT,
        'ends_at', com.ends_at::TEXT,
        'classroom', com.classroom
      )
      ORDER BY com.weekday, com.starts_at
    )
    FROM public.course_offering_meeting com
    WHERE com.course_offering_group_id = g.id
  ), '[]'::jsonb) AS meetings
FROM latest_term lt
JOIN public.course_offering co ON co.academic_term_id = lt.id
JOIN public.course_offering_group g ON g.course_offering_id = co.id
LEFT JOIN public.campus cp ON cp.id = co.campus_id
WHERE co.course_id = p_course_id
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
ORDER BY
  CASE WHEN g.group_code ~ '^[0-9]+$' THEN (g.group_code)::INT ELSE 99999 END,
  g.group_code,
  g.id;
$$;

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns all groups for a course in the latest academic term where it was offered.';
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO authenticated;

COMMIT;
