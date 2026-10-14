BEGIN;

CREATE TABLE IF NOT EXISTS public.professor_review_reaction (
  id BIGSERIAL PRIMARY KEY,
  review_id BIGINT NOT NULL REFERENCES public.professor_review(id) ON DELETE CASCADE ON UPDATE CASCADE,
  user_id UUID NOT NULL REFERENCES public."user"(id) ON DELETE CASCADE ON UPDATE CASCADE,
  reaction TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT professor_review_reaction_value_check
    CHECK (reaction IN ('like', 'dislike')),
  UNIQUE (review_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_professor_review_reaction_review_id
  ON public.professor_review_reaction (review_id);

CREATE INDEX IF NOT EXISTS idx_professor_review_reaction_user_id
  ON public.professor_review_reaction (user_id);

DROP TRIGGER IF EXISTS set_timestamp_professor_review_reaction ON public.professor_review_reaction;
CREATE TRIGGER set_timestamp_professor_review_reaction
  BEFORE UPDATE ON public.professor_review_reaction
  FOR EACH ROW
  EXECUTE FUNCTION public.trigger_set_timestamp();

ALTER TABLE public.professor_review_reaction ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can manage own review reactions" ON public.professor_review_reaction;
CREATE POLICY "Users can manage own review reactions"
ON public.professor_review_reaction
FOR ALL
TO authenticated
USING ((SELECT auth.uid()) = professor_review_reaction.user_id)
WITH CHECK ((SELECT auth.uid()) = professor_review_reaction.user_id);

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

COMMIT;
