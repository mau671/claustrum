BEGIN;

ALTER TABLE public.professor_review
  ALTER COLUMN clarity_score DROP NOT NULL,
  ALTER COLUMN fairness_score DROP NOT NULL,
  ALTER COLUMN engagement_level DROP NOT NULL;

ALTER TABLE public.professor_review
DROP CONSTRAINT IF EXISTS professor_review_tags_allowed_check;

ALTER TABLE public.professor_review
ADD CONSTRAINT professor_review_tags_allowed_check
  CHECK (
    tags <@ ARRAY[
      'Tomaría su clase nuevamente',
      'Brinda apoyo',
      'Da buena retroalimentación',
      'Explica con claridad',
      'Clases excelentes',
      'Califica con rigor',
      'Muchas tareas',
      'Deja trabajos largos',
      'Exámenes retadores',
      'Muchos exámenes',
      'Pocos exámenes',
      'Asistencia obligatoria',
      'La participación importa',
      'Clases largas',
      'Requiere mucha lectura',
      'Aspectos de calificación claros',
      'Respetado por los estudiantes',
      'Inspirador',
      'Muy cómico',
      'Da crédito extra',
      'Muchos proyectos grupales',
      'Proyecto útil',
      'Clase fácil'
    ]::TEXT[]
  );

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
SECURITY INVOKER
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
      COUNT(*)::BIGINT AS approved_review_count,
      ROUND(AVG(rs.overall_score)::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(rs.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(rs.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(rs.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      COUNT(DISTINCT rs.course_id)::BIGINT AS courses_reviewed_count,
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
    WHERE pr.professor_id::TEXT = p_professor_id
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
$$;

COMMIT;
