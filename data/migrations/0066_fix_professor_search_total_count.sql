-- 0066_fix_professor_search_total_count.sql
-- Restores total_count in professor search after text-id migration.

BEGIN;

DROP FUNCTION IF EXISTS public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.search_professor_review_stats(
  p_query TEXT DEFAULT NULL,
  p_min_avg_score NUMERIC DEFAULT NULL,
  p_min_review_count INTEGER DEFAULT 0,
  p_course_code TEXT DEFAULT NULL,
  p_only_with_approved_reviews BOOLEAN DEFAULT false,
  p_limit INTEGER DEFAULT 25,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  professor_id TEXT,
  professor_name TEXT,
  approved_review_count BIGINT,
  average_overall_score NUMERIC,
  average_ease_score NUMERIC,
  average_quality_score NUMERIC,
  average_clarity_score NUMERIC,
  courses_reviewed_count BIGINT,
  last_approved_review_at TIMESTAMPTZ,
  search_rank REAL,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH approved_reviews AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.status = 'approved'
      AND (
        p_course_code IS NULL
        OR pr.course_code_snapshot ILIKE p_course_code
      )
  ),
  aggregated AS (
    SELECT
      ar.professor_id,
      COUNT(*)::BIGINT AS approved_review_count,
      ROUND(AVG((ar.ease_score + ar.quality_score + ar.clarity_score + ar.fairness_score) / 4.0)::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(ar.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(ar.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(ar.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      COUNT(DISTINCT ar.course_id)::BIGINT AS courses_reviewed_count,
      MAX(ar.created_at) AS last_approved_review_at
    FROM approved_reviews ar
    GROUP BY ar.professor_id
  ),
  filtered AS (
    SELECT
      p.id::TEXT AS professor_id,
      p.full_name AS professor_name,
      COALESCE(a.approved_review_count, 0) AS approved_review_count,
      a.average_overall_score,
      a.average_ease_score,
      a.average_quality_score,
      a.average_clarity_score,
      COALESCE(a.courses_reviewed_count, 0) AS courses_reviewed_count,
      a.last_approved_review_at,
      CASE
        WHEN COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL THEN 0::REAL
        WHEN p.full_name ILIKE '%' || trim(p_query) || '%' THEN 1::REAL
        ELSE 0::REAL
      END AS search_rank
    FROM public.professor p
    LEFT JOIN aggregated a ON a.professor_id = p.id
    WHERE public.is_real_professor_name(p.full_name)
      AND (
        COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL
        OR p.full_name ILIKE '%' || trim(p_query) || '%'
      )
      AND (
        p_only_with_approved_reviews = false
        OR COALESCE(a.approved_review_count, 0) > 0
      )
      AND COALESCE(a.approved_review_count, 0) >= GREATEST(COALESCE(p_min_review_count, 0), 0)
      AND (
        p_min_avg_score IS NULL
        OR COALESCE(a.average_overall_score, 0) >= p_min_avg_score
      )
  )
  SELECT
    f.professor_id,
    f.professor_name,
    f.approved_review_count,
    f.average_overall_score,
    f.average_ease_score,
    f.average_quality_score,
    f.average_clarity_score,
    f.courses_reviewed_count,
    f.last_approved_review_at,
    f.search_rank,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM filtered f
  ORDER BY
    f.search_rank DESC,
    f.approved_review_count DESC,
    f.professor_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER)
  TO anon, authenticated;

COMMIT;
