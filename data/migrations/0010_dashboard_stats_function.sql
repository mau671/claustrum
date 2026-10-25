-- FUNCTION: get_user_dashboard_stats (invoker)
DROP FUNCTION IF EXISTS public.get_user_dashboard_stats(UUID, BIGINT);

CREATE OR REPLACE FUNCTION public.get_user_dashboard_stats(p_user_id UUID, p_study_plan_id BIGINT)
RETURNS JSON
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_stats JSON;
  v_semesters JSON;
  v_next_courses JSON;
BEGIN
  -- Calculate overall stats based on study plan courses
  WITH plan_courses AS (
    SELECT splc.course_id, splc.credits, spl.level_number, spl.level_label
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  course_status AS (
    SELECT course_id, status
    FROM public.student_course_record
    WHERE user_id = p_user_id AND study_plan_id = p_study_plan_id
  ),
  course_stats AS (
    SELECT
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE cs.status = 'APPROVED') AS completed,
      COUNT(*) FILTER (WHERE cs.status = 'IN_PROGRESS') AS in_progress,
      COUNT(*) FILTER (WHERE cs.status = 'FAILED') AS failed,
      COUNT(*) FILTER (WHERE cs.status = 'WITHDRAWN') AS withdrawn,
      SUM(pc.credits) AS total_credits,
      SUM(pc.credits) FILTER (WHERE cs.status = 'APPROVED') AS completed_credits
    FROM plan_courses pc
    LEFT JOIN course_status cs ON cs.course_id = pc.course_id
  )
  SELECT json_build_object(
    'totalCourses', COALESCE((SELECT total FROM course_stats), 0),
    'completedCourses', COALESCE((SELECT completed FROM course_stats), 0),
    'inProgressCourses', COALESCE((SELECT in_progress FROM course_stats), 0),
    'failedCourses', COALESCE((SELECT failed FROM course_stats), 0),
    'withdrawnCourses', COALESCE((SELECT withdrawn FROM course_stats), 0),
    'notTakenCourses', GREATEST(
      COALESCE((SELECT total FROM course_stats), 0)
      - (COALESCE((SELECT completed FROM course_stats), 0)
        + COALESCE((SELECT in_progress FROM course_stats), 0)
        + COALESCE((SELECT failed FROM course_stats), 0)
        + COALESCE((SELECT withdrawn FROM course_stats), 0)),
      0
    ),
    'totalCredits', COALESCE((SELECT total_credits FROM course_stats), 0),
    'completedCredits', COALESCE((SELECT completed_credits FROM course_stats), 0),
    'currentSemester', COALESCE((
      SELECT MAX(pc.level_number)
      FROM plan_courses pc
      JOIN course_status cs ON cs.course_id = pc.course_id
      WHERE cs.status IN ('APPROVED', 'IN_PROGRESS')
    ), 0),
    'progressPercentage', CASE
      WHEN (SELECT total FROM course_stats) > 0 THEN
        ROUND(((SELECT completed FROM course_stats)::numeric / (SELECT total FROM course_stats)::numeric) * 100)::int
      ELSE 0
    END
  ) INTO v_stats;

  -- Calculate semester progress
  SELECT json_agg(
    json_build_object(
      'levelNumber', sem.level_number,
      'levelLabel', sem.level_label,
      'totalCourses', sem.total,
      'completedCourses', sem.completed,
      'credits', sem.credits,
      'completedCredits', sem.completed_credits,
      'status', CASE
        WHEN sem.completed = sem.total THEN 'completed'
        WHEN sem.completed > 0 OR sem.in_progress > 0 THEN 'in_progress'
        ELSE 'pending'
      END
    ) ORDER BY sem.level_number
  ) INTO v_semesters
  FROM (
    SELECT
      spl.level_number,
      spl.level_label,
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE ucs.status = 'APPROVED') AS completed,
      SUM(splc.credits) AS credits,
      SUM(splc.credits) FILTER (WHERE ucs.status = 'APPROVED') AS completed_credits,
      COUNT(*) FILTER (WHERE ucs.status = 'IN_PROGRESS') AS in_progress
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    LEFT JOIN public.student_course_record ucs ON ucs.course_id = splc.course_id
      AND ucs.user_id = p_user_id
      AND ucs.study_plan_id = p_study_plan_id
    WHERE spl.study_plan_id = p_study_plan_id
    GROUP BY spl.level_number, spl.level_label
  ) sem;

  -- Get next available courses (prerequisites approved and corequisites available)
  WITH plan_courses AS (
    SELECT
      splc.course_id,
      spl.level_number,
      spl.level_label,
      splc.credits,
      c.code,
      c.name
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    JOIN public.course c ON c.id = splc.course_id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  course_status AS (
    SELECT course_id, status
    FROM public.student_course_record
    WHERE user_id = p_user_id AND study_plan_id = p_study_plan_id
  ),
  candidate_courses AS (
    SELECT
      pc.course_id,
      pc.code,
      pc.name,
      pc.credits,
      pc.level_number,
      pc.level_label,
      cs.status
    FROM plan_courses pc
    LEFT JOIN course_status cs ON cs.course_id = pc.course_id
    WHERE cs.status IS NULL OR cs.status IN ('FAILED', 'WITHDRAWN')
  ),
  prereq_status AS (
    SELECT
      cr.from_course_id AS course_id,
      prereq.code AS prereq_code,
      cs.status AS prereq_status
    FROM public.course_relation cr
    JOIN public.course prereq ON cr.to_course_id = prereq.id
    LEFT JOIN course_status cs ON cs.course_id = cr.to_course_id
    WHERE cr.study_plan_id = p_study_plan_id
      AND cr.relation_type = 'PREREQUISITE'
  ),
  prereq_eligible AS (
    SELECT
      c.course_id,
      c.code,
      c.name,
      c.credits,
      c.level_number,
      c.level_label,
      c.status,
      COALESCE((
        SELECT array_agg(p.prereq_code ORDER BY p.prereq_code)
        FROM prereq_status p
        WHERE p.course_id = c.course_id
      ), ARRAY[]::text[]) AS prerequisites
    FROM candidate_courses c
    LEFT JOIN prereq_status p ON p.course_id = c.course_id
    GROUP BY c.course_id, c.code, c.name, c.credits, c.level_number, c.level_label, c.status
    HAVING COUNT(p.prereq_code) FILTER (WHERE p.prereq_code IS NOT NULL) 
         = COUNT(p.prereq_code) FILTER (WHERE p.prereq_status = 'APPROVED')
  ),
  coreq_check AS (
    SELECT
      cr.from_course_id AS course_id,
      cr.to_course_id AS coreq_course_id
    FROM public.course_relation cr
    WHERE cr.study_plan_id = p_study_plan_id
      AND cr.relation_type = 'COREQUISITE'
  ),
  next_courses AS (
    SELECT
      e.course_id::text AS id,
      e.code,
      e.name,
      e.credits,
      e.level_number,
      e.level_label AS levelLabel,
      e.status,
      e.prerequisites
    FROM prereq_eligible e
    WHERE NOT EXISTS (
      SELECT 1
      FROM coreq_check cc
      WHERE cc.course_id = e.course_id
        AND cc.coreq_course_id NOT IN (SELECT course_id FROM prereq_eligible)
        AND cc.coreq_course_id NOT IN (
          SELECT course_id FROM course_status WHERE status = 'APPROVED'
        )
    )
    ORDER BY e.level_number,
      CASE WHEN e.status IS NULL THEN 0 ELSE 1 END,
      e.code
    LIMIT 10
  )
  SELECT json_agg(json_build_object(
    'id', id,
    'code', code,
    'name', name,
    'credits', credits,
    'levelLabel', levelLabel,
    'prerequisites', prerequisites
  )) INTO v_next_courses
  FROM next_courses;

  RETURN json_build_object(
    'stats', v_stats,
    'semesters', COALESCE(v_semesters, '[]'::json),
    'nextCourses', COALESCE(v_next_courses, '[]'::json)
  );
END;
$$;

COMMENT ON FUNCTION public.get_user_dashboard_stats IS 'Returns dashboard statistics for a user study plan';

-- Update update_student_course_status to use BIGINT and TEXT
DROP FUNCTION IF EXISTS public.update_student_course_status(UUID, INTEGER, INTEGER, student_course_status);
DROP FUNCTION IF EXISTS public.update_student_course_status(UUID, INTEGER, INTEGER, TEXT);

CREATE OR REPLACE FUNCTION public.update_student_course_status(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  UPDATE public.student_course_record
  SET status = upper(p_status)::public.student_course_status, recorded_at = NOW()
  WHERE user_id = p_user_id
    AND study_plan_id = p_study_plan_id
    AND course_id = p_course_id;

  IF NOT FOUND THEN
    INSERT INTO public.student_course_record (user_id, study_plan_id, course_id, status, recorded_at)
    VALUES (p_user_id, p_study_plan_id, p_course_id, upper(p_status)::public.student_course_status, NOW());
    RETURN 'inserted';
  END IF;

  RETURN 'updated';
END;
$$;

COMMENT ON FUNCTION public.update_student_course_status IS 'Updates or inserts a course status for a user';
GRANT EXECUTE ON FUNCTION public.update_student_course_status TO authenticated;

-- Update delete_student_course_status to use BIGINT
DROP FUNCTION IF EXISTS public.delete_student_course_status(UUID, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.delete_student_course_status(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  DELETE FROM public.student_course_record
  WHERE user_id = p_user_id
    AND study_plan_id = p_study_plan_id
    AND course_id = p_course_id;

  IF FOUND THEN
    RETURN 'deleted';
  END IF;

  RETURN 'not_found';
END;
$$;

COMMENT ON FUNCTION public.delete_student_course_status IS 'Deletes a course status for a user';
GRANT EXECUTE ON FUNCTION public.delete_student_course_status TO authenticated;
