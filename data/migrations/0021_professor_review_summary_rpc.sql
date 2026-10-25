-- 0021_professor_review_summary_rpc.sql
-- Summary metrics and tag distribution for professor review detail page.

BEGIN;

CREATE OR REPLACE FUNCTION public.get_professor_review_summary(
  p_professor_id BIGINT
)
RETURNS TABLE (
  professor_id BIGINT,
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
    WHERE pr.professor_id = p_professor_id
      AND pr.status = 'approved'
  ),
  tag_distribution AS (
    SELECT
      COALESCE(
        jsonb_agg(
          jsonb_build_object('tag', tag_name, 'count', tag_count)
          ORDER BY tag_count DESC, tag_name ASC
        ),
        '[]'::jsonb
      ) AS tag_counts
    FROM (
      SELECT t.tag_name, COUNT(*)::BIGINT AS tag_count
      FROM approved a
      CROSS JOIN LATERAL unnest(a.tags) AS t(tag_name)
      GROUP BY t.tag_name
    ) ranked
  )
  SELECT
    p_professor_id AS professor_id,
    COUNT(*)::BIGINT AS approved_review_count,
    ROUND(AVG((a.ease_score + a.quality_score + a.clarity_score + a.fairness_score) / 4.0)::NUMERIC, 2) AS average_overall_score,
    ROUND(AVG(a.ease_score)::NUMERIC, 2) AS average_ease_score,
    ROUND(AVG(a.quality_score)::NUMERIC, 2) AS average_quality_score,
    ROUND(AVG(a.clarity_score)::NUMERIC, 2) AS average_clarity_score,
    ROUND(AVG(a.fairness_score)::NUMERIC, 2) AS average_fairness_score,
    ROUND(
      AVG(
        CASE
          WHEN 'Tomaria su clase nuevamente' = ANY(a.tags) THEN 100
          ELSE 0
        END
      )::NUMERIC,
      1
    ) AS would_take_again_percentage,
    (SELECT td.tag_counts FROM tag_distribution td) AS tag_counts
  FROM approved a;
$$;

GRANT EXECUTE ON FUNCTION public.get_professor_review_summary(BIGINT)
  TO anon, authenticated;

COMMIT;
