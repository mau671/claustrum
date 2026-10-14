BEGIN;

DROP FUNCTION IF EXISTS public.get_professor_reviews_public(TEXT, INTEGER, INTEGER);

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
  like_count BIGINT,
  dislike_count BIGINT,
  my_reaction TEXT,
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
      first_course.course_id,
      first_course.course_code,
      first_course.course_name,
      COALESCE(course_list.courses, '[]'::jsonb) AS courses,
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
    LEFT JOIN LATERAL (
      SELECT c.id AS course_id, c.code AS course_code, c.name AS course_name
      FROM public.professor_review_course prc
      JOIN public.course c ON c.id = prc.course_id
      WHERE prc.review_id = pr.id
      ORDER BY c.code, c.name, c.id
      LIMIT 1
    ) first_course ON true
    LEFT JOIN LATERAL (
      SELECT jsonb_agg(
        jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
        ORDER BY c.code, c.name, c.id
      ) AS courses
      FROM public.professor_review_course prc
      JOIN public.course c ON c.id = prc.course_id
      WHERE prc.review_id = pr.id
    ) course_list ON true
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  reaction_counts AS (
    SELECT
      prr.review_id,
      COUNT(*) FILTER (WHERE prr.reaction = 'like')::BIGINT AS like_count,
      COUNT(*) FILTER (WHERE prr.reaction = 'dislike')::BIGINT AS dislike_count
    FROM public.professor_review_reaction prr
    JOIN rows r ON r.review_id = prr.review_id
    GROUP BY prr.review_id
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
    r.courses,
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
    COALESCE(rc.like_count, 0)::BIGINT AS like_count,
    COALESCE(rc.dislike_count, 0)::BIGINT AS dislike_count,
    mr.reaction AS my_reaction,
    c.total_count
  FROM rows r
  CROSS JOIN counted c
  LEFT JOIN reaction_counts rc ON rc.review_id = r.review_id
  LEFT JOIN public.professor_review_reaction mr
    ON mr.review_id = r.review_id
    AND mr.user_id = (SELECT auth.uid())
  ORDER BY r.created_at DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

GRANT EXECUTE ON FUNCTION public.get_professor_reviews_public(TEXT, INTEGER, INTEGER) TO anon;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_public(TEXT, INTEGER, INTEGER) TO authenticated;

DROP FUNCTION IF EXISTS public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER);

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
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  RETURN QUERY
  WITH review_courses AS (
    SELECT
      prc.review_id,
      (array_agg(c.id ORDER BY c.code, c.name, c.id))[1] AS course_id,
      (array_agg(c.code ORDER BY c.code, c.name, c.id))[1] AS course_code,
      (array_agg(c.name ORDER BY c.code, c.name, c.id))[1] AS course_name,
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
    rc.course_id,
    COALESCE(rc.course_code, '') AS course_code,
    COALESCE(rc.course_name, '') AS course_name,
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
  WHERE pr.status = p_status
  ORDER BY pr.created_at ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) TO authenticated;

COMMIT;
