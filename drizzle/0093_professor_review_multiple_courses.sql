BEGIN;

CREATE TABLE IF NOT EXISTS public.professor_review_course (
  review_id BIGINT NOT NULL REFERENCES public.professor_review(id) ON DELETE CASCADE ON UPDATE CASCADE,
  course_id BIGINT NOT NULL REFERENCES public.course(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (review_id, course_id)
);

DROP INDEX IF EXISTS public.idx_professor_review_course_single_primary;

ALTER TABLE public.professor_review_course
  DROP COLUMN IF EXISTS is_primary;

CREATE INDEX IF NOT EXISTS idx_professor_review_course_course_id
  ON public.professor_review_course (course_id);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'professor_review'
      AND column_name = 'course_id'
  ) THEN
    EXECUTE '
      INSERT INTO public.professor_review_course (review_id, course_id)
      SELECT pr.id, pr.course_id
      FROM public.professor_review pr
      WHERE pr.course_id IS NOT NULL
      ON CONFLICT (review_id, course_id) DO NOTHING
    ';
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS ensure_professor_review_course_relation_matches_professor_trigger
  ON public.professor_review_course;
DROP FUNCTION IF EXISTS public.ensure_professor_review_course_relation_matches_professor();

DROP TRIGGER IF EXISTS sync_professor_review_primary_course_relation_trigger
  ON public.professor_review;
DROP FUNCTION IF EXISTS public.sync_professor_review_primary_course_relation();

DROP TRIGGER IF EXISTS set_professor_review_course_snapshot_trigger
  ON public.professor_review;
DROP TRIGGER IF EXISTS ensure_professor_review_course_matches_professor_trigger
  ON public.professor_review;
DROP FUNCTION IF EXISTS public.set_professor_review_course_snapshot();
DROP FUNCTION IF EXISTS public.ensure_professor_review_course_matches_professor();

DROP INDEX IF EXISTS public.idx_professor_review_course_id;
DROP INDEX IF EXISTS public.idx_professor_review_course_code_snapshot;

ALTER TABLE public.professor_review
  DROP COLUMN IF EXISTS course_id,
  DROP COLUMN IF EXISTS course_code_snapshot,
  DROP COLUMN IF EXISTS course_name_snapshot;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read approved professor review courses"
  ON public.professor_review_course;
CREATE POLICY "Public can read approved professor review courses"
ON public.professor_review_course
FOR SELECT
TO anon, authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.id = professor_review_course.review_id
      AND pr.status = 'approved'
  )
);

DROP POLICY IF EXISTS "Admins can read all professor review courses"
  ON public.professor_review_course;
CREATE POLICY "Admins can read all professor review courses"
ON public.professor_review_course
FOR SELECT
TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "Admins can manage professor review courses"
  ON public.professor_review_course;
CREATE POLICY "Admins can manage professor review courses"
ON public.professor_review_course
FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

GRANT SELECT ON public.professor_review_course TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.professor_review_course TO authenticated;

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
      COUNT(*)::BIGINT AS approved_review_count,
      ROUND(AVG(rs.overall_score)::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(rs.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(rs.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(rs.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      COUNT(DISTINCT prc.course_id)::BIGINT AS courses_reviewed_count,
      MAX(rs.created_at) AS last_approved_review_at
    FROM review_scores rs
    LEFT JOIN public.professor_review_course prc ON prc.review_id = rs.id
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

CREATE OR REPLACE FUNCTION public.get_professor_review_reports_for_moderation(
  p_status public.professor_review_report_status DEFAULT 'pending',
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  report_id BIGINT,
  review_id BIGINT,
  reason TEXT,
  description TEXT,
  status public.professor_review_report_status,
  created_at TIMESTAMPTZ,
  professor_id BIGINT,
  professor_name TEXT,
  course_code TEXT,
  course_name TEXT,
  comment TEXT,
  total_count BIGINT
)
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  RETURN QUERY
  WITH filtered AS (
    SELECT r.*
    FROM public.professor_review_report r
    WHERE r.status = p_status
  ),
  total AS (
    SELECT COUNT(*)::BIGINT AS count
    FROM filtered
  ),
  review_courses AS (
    SELECT
      prc.review_id,
      string_agg(c.code, ', ' ORDER BY c.code, c.name, c.id) AS course_code,
      string_agg(c.name, ', ' ORDER BY c.code, c.name, c.id) AS course_name
    FROM public.professor_review_course prc
    JOIN public.course c ON c.id = prc.course_id
    GROUP BY prc.review_id
  )
  SELECT
    r.id AS report_id,
    pr.id AS review_id,
    r.reason,
    r.description,
    r.status,
    r.created_at,
    p.id AS professor_id,
    p.full_name AS professor_name,
    COALESCE(rc.course_code, '') AS course_code,
    COALESCE(rc.course_name, '') AS course_name,
    pr.comment,
    t.count AS total_count
  FROM filtered r
  JOIN public.professor_review pr ON pr.id = r.review_id
  JOIN public.professor p ON p.id = pr.professor_id
  LEFT JOIN review_courses rc ON rc.review_id = pr.id
  CROSS JOIN total t
  ORDER BY r.created_at ASC, r.id ASC
  LIMIT GREATEST(p_limit, 0)
  OFFSET GREATEST(p_offset, 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_professor_review_reports_for_moderation(public.professor_review_report_status, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_professor_review_reports_for_moderation(public.professor_review_report_status, INTEGER, INTEGER) TO authenticated;

COMMIT;
