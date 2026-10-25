BEGIN;

CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE OR REPLACE FUNCTION public.search_professor_review_courses(
  p_query TEXT,
  p_limit INTEGER DEFAULT 8
)
RETURNS TABLE (
  id BIGINT,
  code TEXT,
  name TEXT
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH normalized AS (
    SELECT
      NULLIF(trim(p_query), '') AS query,
      GREATEST(1, LEAST(COALESCE(p_limit, 8), 20)) AS result_limit
  )
  SELECT
    c.id,
    c.code,
    c.name
  FROM public.course c
  CROSS JOIN normalized n
  WHERE n.query IS NOT NULL
    AND (
      c.code ILIKE '%' || n.query || '%'
      OR unaccent(c.name) ILIKE '%' || unaccent(n.query) || '%'
    )
  ORDER BY
    CASE WHEN c.code ILIKE n.query || '%' THEN 0 ELSE 1 END,
    CASE WHEN unaccent(c.name) ILIKE unaccent(n.query) || '%' THEN 0 ELSE 1 END,
    c.code ASC
  LIMIT (SELECT result_limit FROM normalized);
$$;

COMMIT;
