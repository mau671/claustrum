-- 0038_fix_weighted_average_null_grades.sql
-- Fix weighted average calculation to only consider courses with numeric grades.

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
  WITH plan_courses AS (
    SELECT splc.course_id, splc.credits, spl.level_number, spl.level_label
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  course_status AS (
    SELECT es.course_id, es.status, es.grade
    FROM public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) es
  ),
  course_stats AS (
    SELECT
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE cs.status = 'APPROVED') AS completed,
      COUNT(*) FILTER (WHERE cs.status = 'IN_PROGRESS') AS in_progress,
      COUNT(*) FILTER (WHERE cs.status = 'FAILED') AS failed,
      COUNT(*) FILTER (WHERE cs.status = 'WITHDRAWN') AS withdrawn,
      SUM(pc.credits) AS total_credits,
      SUM(pc.credits) FILTER (WHERE cs.status = 'APPROVED') AS completed_credits,
      SUM((cs.grade * pc.credits)::numeric) FILTER (WHERE cs.grade IS NOT NULL) AS weighted_grade_sum,
      SUM(pc.credits) FILTER (WHERE cs.grade IS NOT NULL) AS graded_credits
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
    END,
    'weightedAverage', CASE
      WHEN COALESCE((SELECT graded_credits FROM course_stats), 0) > 0 THEN
        ROUND(
          COALESCE((SELECT weighted_grade_sum FROM course_stats), 0)::numeric
          / (SELECT graded_credits FROM course_stats)::numeric,
          6
        )
      ELSE 0
    END
  ) INTO v_stats;

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
    LEFT JOIN public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) ucs
      ON ucs.course_id = splc.course_id
    WHERE spl.study_plan_id = p_study_plan_id
    GROUP BY spl.level_number, spl.level_label
  ) sem;

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
    SELECT es.course_id, es.status
    FROM public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) es
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

COMMENT ON FUNCTION public.get_user_dashboard_stats IS 'Returns dashboard statistics and weighted average for a user study plan based on course attempts.';
GRANT EXECUTE ON FUNCTION public.get_user_dashboard_stats TO authenticated;
