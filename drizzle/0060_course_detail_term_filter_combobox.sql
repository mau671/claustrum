-- 0060_course_detail_term_filter_combobox.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_recent_professors(BIGINT, BIGINT, BIGINT, INTEGER);
DROP FUNCTION IF EXISTS public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT);

CREATE OR REPLACE FUNCTION public.get_course_offering_terms(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL
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
LANGUAGE sql
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
FROM public.course_offering co
JOIN public.academic_term at ON at.id = co.academic_term_id
WHERE co.course_id = p_course_id
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
  AND EXISTS (
    SELECT 1
    FROM public.course_offering_group cog
    WHERE cog.course_offering_id = co.id
  )
ORDER BY at.year DESC, at.period_number DESC, at.id DESC;
$$;

COMMENT ON FUNCTION public.get_course_offering_terms IS 'Returns academic terms where a course has active offerings with at least one group.';
GRANT EXECUTE ON FUNCTION public.get_course_offering_terms TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_offering_terms TO authenticated;

CREATE OR REPLACE FUNCTION public.get_course_recent_professors(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_year_window INTEGER DEFAULT 2,
  p_academic_term_id BIGINT DEFAULT NULL
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
    AND (
      (p_academic_term_id IS NOT NULL AND at.id = p_academic_term_id)
      OR (
        p_academic_term_id IS NULL
        AND at.year >= (EXTRACT(YEAR FROM NOW())::INT - (GREATEST(COALESCE(p_year_window, 2), 1) - 1))
      )
    )
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

COMMENT ON FUNCTION public.get_course_recent_professors IS 'Returns professors that taught a course in a selected term or within the recent year window, and counts groups taught in each professor latest term.';
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_recent_professors TO authenticated;

CREATE OR REPLACE FUNCTION public.get_course_latest_term_groups(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL
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
WITH selected_term AS (
  SELECT
    at.id,
    at.display_name,
    at.year,
    at.period_number
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id = p_course_id
    AND co.is_active = TRUE
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
    AND EXISTS (
      SELECT 1
      FROM public.course_offering_group g
      WHERE g.course_offering_id = co.id
    )
    AND (p_academic_term_id IS NULL OR at.id = p_academic_term_id)
  ORDER BY at.year DESC, at.period_number DESC, at.id DESC
  LIMIT 1
)
SELECT
  st.id AS academic_term_id,
  st.display_name AS term_display_name,
  st.year AS term_year,
  st.period_number AS term_period_number,
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
FROM selected_term st
JOIN public.course_offering co ON co.academic_term_id = st.id
JOIN public.course_offering_group g ON g.course_offering_id = co.id
LEFT JOIN public.campus cp ON cp.id = co.campus_id
WHERE co.course_id = p_course_id
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
ORDER BY
  CASE WHEN g.group_code ~ '^[0-9]+$' THEN (g.group_code)::INT ELSE 99999 END,
  g.group_code,
  g.id;
$$;

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns groups for a course in the selected academic term, or latest term with offerings when no term is provided.';
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups TO authenticated;

COMMIT;
