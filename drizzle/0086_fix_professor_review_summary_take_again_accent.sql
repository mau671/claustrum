BEGIN;

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
SECURITY INVOKER
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
    ROUND(
      AVG(
        CASE
          WHEN 'Tomaría su clase nuevamente' = ANY(a.tags)
            OR 'Tomaria su clase nuevamente' = ANY(a.tags)
            THEN 1
          ELSE 0
        END
      )::NUMERIC * 100,
      2
    ) AS would_take_again_percentage,
    COALESCE(
      (
        SELECT jsonb_agg(jsonb_build_object('tag', t.tag, 'count', t.count) ORDER BY t.count DESC, t.tag ASC)
        FROM tag_agg t
      ),
      '[]'::jsonb
    ) AS tag_counts
  FROM approved a;
$$;

COMMIT;
