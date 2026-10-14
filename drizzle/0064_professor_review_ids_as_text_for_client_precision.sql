-- 0064_professor_review_ids_as_text_for_client_precision.sql
-- Prevent bigint precision loss in web clients by exposing professor ids as text.

BEGIN;

DROP FUNCTION IF EXISTS public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER);
DROP FUNCTION IF EXISTS public.get_professor_reviews_public(BIGINT, INTEGER, INTEGER);
DROP FUNCTION IF EXISTS public.get_professor_review_summary(BIGINT);

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
  search_rank REAL
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
  )
  SELECT
    p.id::text AS professor_id,
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
  WHERE (
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
  ORDER BY
    search_rank DESC,
    COALESCE(a.approved_review_count, 0) DESC,
    p.full_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

CREATE OR REPLACE FUNCTION public.get_professor_reviews_public(
  p_professor_id TEXT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id TEXT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  comment TEXT,
  ease_score NUMERIC,
  quality_score NUMERIC,
  clarity_score NUMERIC,
  fairness_score NUMERIC,
  attendance_required BOOLEAN,
  grade_received TEXT,
  engagement_level SMALLINT,
  tags TEXT[],
  status public.professor_review_status,
  created_at TIMESTAMPTZ,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH rows AS (
    SELECT
      pr.id AS review_id,
      pr.professor_id::text AS professor_id,
      pr.course_id,
      pr.course_code_snapshot AS course_code,
      pr.course_name_snapshot AS course_name,
      pr.comment,
      pr.ease_score,
      pr.quality_score,
      pr.clarity_score,
      pr.fairness_score,
      pr.attendance_required,
      pr.grade_received,
      pr.engagement_level,
      pr.tags,
      pr.status,
      pr.created_at
    FROM public.professor_review pr
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  counted AS (
    SELECT COUNT(*)::BIGINT AS total_count FROM rows
  )
  SELECT
    r.review_id,
    r.professor_id,
    r.course_id,
    r.course_code,
    r.course_name,
    r.comment,
    r.ease_score,
    r.quality_score,
    r.clarity_score,
    r.fairness_score,
    r.attendance_required,
    r.grade_received,
    r.engagement_level,
    r.tags,
    r.status,
    r.created_at,
    c.total_count
  FROM rows r
  CROSS JOIN counted c
  ORDER BY r.created_at DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

CREATE OR REPLACE FUNCTION public.get_professor_review_summary(
  p_professor_id TEXT
)
RETURNS TABLE (
  professor_id TEXT,
  approved_review_count BIGINT,
  average_overall_score NUMERIC,
  average_ease_score NUMERIC,
  average_quality_score NUMERIC,
  average_clarity_score NUMERIC,
  average_fairness_score NUMERIC,
  would_take_again_percentage NUMERIC,
  tag_counts JSONB
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH approved AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  tag_agg AS (
    SELECT
      tag,
      COUNT(*)::BIGINT AS count
    FROM approved a,
    LATERAL unnest(a.tags) AS tag
    GROUP BY tag
  )
  SELECT
    p_professor_id AS professor_id,
    COUNT(*)::BIGINT AS approved_review_count,
    ROUND(AVG((a.ease_score + a.quality_score + a.clarity_score + a.fairness_score) / 4.0)::NUMERIC, 2) AS average_overall_score,
    ROUND(AVG(a.ease_score)::NUMERIC, 2) AS average_ease_score,
    ROUND(AVG(a.quality_score)::NUMERIC, 2) AS average_quality_score,
    ROUND(AVG(a.clarity_score)::NUMERIC, 2) AS average_clarity_score,
    ROUND(AVG(a.fairness_score)::NUMERIC, 2) AS average_fairness_score,
    ROUND(AVG(CASE WHEN 'Tomaria su clase nuevamente' = ANY(a.tags) THEN 1 ELSE 0 END)::NUMERIC * 100, 2) AS would_take_again_percentage,
    COALESCE(
      (
        SELECT jsonb_agg(jsonb_build_object('tag', t.tag, 'count', t.count) ORDER BY t.count DESC, t.tag ASC)
        FROM tag_agg t
      ),
      '[]'::jsonb
    ) AS tag_counts
  FROM approved a;
$$;

GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER) TO anon;
GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_public(TEXT, INTEGER, INTEGER) TO anon;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_public(TEXT, INTEGER, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_professor_review_summary(TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.get_professor_review_summary(TEXT) TO authenticated;

COMMIT;
