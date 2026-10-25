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
  academic_unit TEXT,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH approved_reviews AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.status = 'approved'
      AND (
        p_course_code IS NULL
        OR EXISTS (
          SELECT 1
          FROM public.professor_review_course prc
          JOIN public.course c ON c.id = prc.course_id
          WHERE prc.review_id = pr.id
            AND c.code ILIKE p_course_code
        )
      )
  ),
  review_scores AS (
    SELECT
      ar.*,
      (
        SELECT AVG(score_value)
        FROM (
          VALUES
            (ar.ease_score),
            (ar.quality_score),
            (ar.clarity_score),
            (ar.fairness_score)
        ) AS scores(score_value)
        WHERE score_value IS NOT NULL
      ) AS overall_score
    FROM approved_reviews ar
  ),
  aggregated AS (
    SELECT
      rs.professor_id,
      COUNT(rs.id)::BIGINT AS approved_review_count,
      ROUND(AVG(rs.overall_score)::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(rs.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(rs.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(rs.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      (
        SELECT COUNT(DISTINCT prc.course_id)
        FROM public.professor_review_course prc
        JOIN review_scores rs2 ON rs2.id = prc.review_id
        WHERE rs2.professor_id = rs.professor_id
      )::BIGINT AS courses_reviewed_count,
      MAX(rs.created_at) AS last_approved_review_at
    FROM review_scores rs
    GROUP BY rs.professor_id
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
        WHEN NOT EXISTS (
          SELECT 1 
          FROM unnest(regexp_split_to_array(trim(p_query), '\s+')) AS word
          WHERE extensions.unaccent(p.full_name) NOT ILIKE extensions.unaccent('%' || word || '%')
        ) THEN 1::REAL
        ELSE 0::REAL
      END AS search_rank,
      (
        SELECT au.name
        FROM public.course_offering_group_professor cogp
        JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
        JOIN public.course_offering co ON co.id = cog.course_offering_id
        JOIN public.academic_unit au ON au.id = co.academic_unit_id
        WHERE cogp.professor_id = p.id
        GROUP BY au.name
        ORDER BY COUNT(*) DESC
        LIMIT 1
      ) AS academic_unit
    FROM public.professor p
    LEFT JOIN aggregated a ON a.professor_id = p.id
    WHERE public.is_real_professor_name(p.full_name)
      AND (
        COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL
        OR NOT EXISTS (
          SELECT 1 
          FROM unnest(regexp_split_to_array(trim(p_query), '\s+')) AS word
          WHERE extensions.unaccent(p.full_name) NOT ILIKE extensions.unaccent('%' || word || '%')
        )
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
    f.academic_unit,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM filtered f
  ORDER BY
    f.search_rank DESC,
    f.approved_review_count DESC,
    f.professor_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER) TO anon;
GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER) TO authenticated;

COMMIT;
