BEGIN;

DROP FUNCTION IF EXISTS public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.get_professor_reviews_for_moderation(
  p_status public.professor_review_status DEFAULT NULL,
  p_limit INTEGER DEFAULT 50,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id BIGINT,
  professor_name TEXT,
  courses JSONB,
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
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Access denied';
  END IF;

  RETURN QUERY
  WITH review_courses AS (
    SELECT
      prc.review_id,
      jsonb_agg(
        jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
        ORDER BY c.code, c.name, c.id
      ) AS courses
    FROM public.professor_review_course prc
    JOIN public.course c ON c.id = prc.course_id
    GROUP BY prc.review_id
  )
  SELECT
    pr.id AS review_id,
    pr.professor_id,
    p.full_name AS professor_name,
    COALESCE(rc.courses, '[]'::jsonb) AS courses,
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
  LEFT JOIN review_courses rc ON rc.review_id = pr.id
  WHERE (p_status IS NULL OR pr.status = p_status)
  ORDER BY
    CASE WHEN p_status = 'pending' THEN pr.created_at END ASC,
    CASE WHEN p_status IS NULL OR p_status != 'pending' THEN pr.created_at END DESC,
    pr.id ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) TO authenticated;

COMMIT;
