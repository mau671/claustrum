BEGIN;

-- 1. Fix insert_student_course_attempt to use public.current_user_id() instead of auth.uid()
CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_equivalent_course_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_normalized_status public.student_course_status;
  v_next_attempt_number INTEGER;
  v_inserted_id BIGINT;
BEGIN
  IF public.current_user_id() IS NULL OR public.current_user_id() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF v_normalized_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required for all attempts';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id,
    study_plan_id,
    course_id,
    academic_term_id,
    attempt_number,
    status,
    grade,
    approved,
    recorded_at,
    equivalent_course_id
  )
  VALUES (
    p_user_id,
    p_study_plan_id,
    p_course_id,
    p_academic_term_id,
    v_next_attempt_number,
    v_normalized_status,
    p_grade,
    (v_normalized_status = 'APPROVED'),
    NOW(),
    p_equivalent_course_id
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

-- 2. Fix get_professor_reviews_public to use public.current_user_id() instead of auth.uid()
CREATE OR REPLACE FUNCTION public.get_professor_reviews_public(
  p_professor_id TEXT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id TEXT,
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
    AND mr.user_id = (SELECT public.current_user_id())
  ORDER BY r.created_at DESC, r.review_id DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

-- 3. Fix RLS policy on professor_review_reaction to use public.current_user_id()
DROP POLICY IF EXISTS "Users can manage own review reactions" ON public.professor_review_reaction;

CREATE POLICY "Users can manage own review reactions"
ON public.professor_review_reaction
FOR ALL
TO authenticated
USING ((SELECT public.current_user_id()) = user_id)
WITH CHECK ((SELECT public.current_user_id()) = user_id);

COMMIT;
