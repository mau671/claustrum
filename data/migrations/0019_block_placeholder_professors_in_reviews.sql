-- 0019_block_placeholder_professors_in_reviews.sql
-- Blocks placeholder/non-real professor names from reviews and listing RPCs.

BEGIN;

CREATE OR REPLACE FUNCTION public.is_real_professor_name(p_full_name TEXT)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT
    COALESCE(NULLIF(trim(p_full_name), ''), '') <> ''
    AND NOT (
      p_full_name ~* 'sin\s+profesor\s+asignado'
      OR p_full_name ~* 'se\s+imparte\s+en\s+idioma\s+ingles'
    );
$$;

CREATE OR REPLACE FUNCTION public.ensure_professor_review_real_professor()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  professor_name TEXT;
BEGIN
  SELECT p.full_name
  INTO professor_name
  FROM public.professor p
  WHERE p.id = NEW.professor_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid professor_id: %', NEW.professor_id;
  END IF;

  IF NOT public.is_real_professor_name(professor_name) THEN
    RAISE EXCEPTION 'Professor is not eligible for reviews: %', professor_name;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS ensure_professor_review_real_professor_trigger ON public.professor_review;
CREATE TRIGGER ensure_professor_review_real_professor_trigger
  BEFORE INSERT OR UPDATE OF professor_id
  ON public.professor_review
  FOR EACH ROW
  EXECUTE FUNCTION public.ensure_professor_review_real_professor();

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
  professor_id BIGINT,
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
    p.id AS professor_id,
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
      ELSE GREATEST(
        similarity(p.full_name, trim(p_query)),
        CASE
          WHEN p.full_name ILIKE '%' || trim(p_query) || '%' THEN 1::REAL
          ELSE 0::REAL
        END
      )
    END AS search_rank
  FROM public.professor p
  LEFT JOIN aggregated a ON a.professor_id = p.id
  WHERE public.is_real_professor_name(p.full_name)
    AND (
      COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL
      OR p.full_name ILIKE '%' || trim(p_query) || '%'
      OR similarity(p.full_name, trim(p_query)) > 0.2
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
  p_professor_id BIGINT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id BIGINT,
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
  SELECT
    pr.id AS review_id,
    pr.professor_id,
    pr.course_id,
    pr.course_code_snapshot AS course_code,
    pr.course_name_snapshot AS course_name,
    CASE
      WHEN pr.status = 'approved' THEN pr.comment
      ELSE 'Comentario en revision'
    END AS comment,
    CASE WHEN pr.status = 'approved' THEN pr.ease_score ELSE NULL END AS ease_score,
    CASE WHEN pr.status = 'approved' THEN pr.quality_score ELSE NULL END AS quality_score,
    CASE WHEN pr.status = 'approved' THEN pr.clarity_score ELSE NULL END AS clarity_score,
    CASE WHEN pr.status = 'approved' THEN pr.fairness_score ELSE NULL END AS fairness_score,
    CASE WHEN pr.status = 'approved' THEN pr.attendance_required ELSE NULL END AS attendance_required,
    CASE WHEN pr.status = 'approved' THEN pr.grade_received ELSE NULL END AS grade_received,
    CASE WHEN pr.status = 'approved' THEN pr.engagement_level ELSE NULL END AS engagement_level,
    CASE WHEN pr.status = 'approved' THEN pr.tags ELSE '{}'::TEXT[] END AS tags,
    pr.status,
    pr.created_at,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM public.professor_review pr
  JOIN public.professor p ON p.id = pr.professor_id
  WHERE pr.professor_id = p_professor_id
    AND pr.status <> 'rejected'
    AND public.is_real_professor_name(p.full_name)
  ORDER BY pr.created_at DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

CREATE OR REPLACE FUNCTION public.get_professor_reviews_for_moderation(
  p_status public.professor_review_status DEFAULT 'pending',
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id BIGINT,
  professor_name TEXT,
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
  reviewed_at TIMESTAMPTZ,
  moderation_note TEXT,
  total_count BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  RETURN QUERY
  SELECT
    pr.id AS review_id,
    pr.professor_id,
    p.full_name AS professor_name,
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
    pr.created_at,
    pr.reviewed_at,
    pr.moderation_note,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM public.professor_review pr
  JOIN public.professor p ON p.id = pr.professor_id
  WHERE pr.status = p_status
    AND public.is_real_professor_name(p.full_name)
  ORDER BY pr.created_at ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
END;
$$;

COMMIT;
