-- 0153_optimize_professor_review_summary.sql
-- Optimizes get_professor_review_summary to use idx_professor_review_professor_id
-- instead of a full sequential scan over professor_review caused by column cast.

CREATE OR REPLACE FUNCTION public.get_professor_review_summary(p_professor_id text)
 RETURNS TABLE(professor_id text, approved_review_count bigint, average_overall_score numeric, average_ease_score numeric, average_quality_score numeric, average_clarity_score numeric, average_fairness_score numeric, would_take_again_percentage numeric, tag_counts jsonb)
 LANGUAGE sql
 STABLE
 SET search_path TO 'public'
AS $function$
  WITH approved AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.professor_id = CASE WHEN p_professor_id ~ '^[0-9]+$' THEN p_professor_id::BIGINT ELSE NULL END
      AND pr.status = 'approved'
  ),
  review_scores AS (
    SELECT
      a.*,
      (
        SELECT AVG(score_value)
        FROM (
          VALUES
            (a.ease_score),
            (a.quality_score),
            (a.clarity_score),
            (a.fairness_score)
        ) AS scores(score_value)
        WHERE score_value IS NOT NULL
      ) AS overall_score
    FROM approved a
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
    ROUND(AVG(rs.overall_score)::NUMERIC, 2) AS average_overall_score,
    ROUND(AVG(rs.ease_score)::NUMERIC, 2) AS average_ease_score,
    ROUND(AVG(rs.quality_score)::NUMERIC, 2) AS average_quality_score,
    ROUND(AVG(rs.clarity_score)::NUMERIC, 2) AS average_clarity_score,
    ROUND(AVG(rs.fairness_score)::NUMERIC, 2) AS average_fairness_score,
    ROUND(
      AVG(
        CASE
          WHEN 'Tomaría su clase nuevamente' = ANY(rs.tags)
            OR 'Tomaria su clase nuevamente' = ANY(rs.tags)
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
  FROM review_scores rs;
$function$;
