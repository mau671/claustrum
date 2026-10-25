-- 0071_fix_in_progress_status_override.sql
-- Fixes an issue where older IN_PROGRESS attempts would incorrectly take
-- precedence over newer FAILED/WITHDRAWN attempts due to COALESCE logic.

BEGIN;

DROP FUNCTION IF EXISTS public.get_user_course_effective_statuses(UUID, BIGINT);
DROP FUNCTION IF EXISTS public.get_user_course_effective_status_details(UUID, BIGINT);

CREATE OR REPLACE FUNCTION public.get_user_course_effective_status_details(
  p_user_id UUID,
  p_study_plan_id BIGINT
)
RETURNS TABLE (
  course_id BIGINT,
  status public.student_course_status,
  grade NUMERIC(5,2),
  recorded_at TIMESTAMPTZ,
  origin_course_id BIGINT,
  origin_course_code TEXT,
  origin_course_name TEXT,
  origin_study_plan_id BIGINT,
  origin_attempt_id BIGINT,
  origin_attempt_number INTEGER,
  origin_academic_term_id BIGINT,
  origin_academic_term_name TEXT,
  origin_type TEXT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH RECURSIVE plan_courses AS (
  SELECT splc.course_id
  FROM public.study_plan_level_course splc
  JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
  JOIN public.course c ON c.id = splc.course_id
  WHERE spl.study_plan_id = p_study_plan_id
    AND splc.is_active = true
    AND spl.is_active = true
    AND c.is_active = true
),
equivalence_edges AS (
  SELECT cr.from_course_id, cr.to_course_id
  FROM public.course_relation cr
  JOIN public.course from_course ON from_course.id = cr.from_course_id
  JOIN public.course to_course ON to_course.id = cr.to_course_id
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.is_active = true
    AND from_course.is_active = true
    AND to_course.is_active = true
),
equivalence_closure(seed_course_id, equivalent_course_id, path) AS (
  SELECT pc.course_id, pc.course_id, ARRAY[pc.course_id]
  FROM plan_courses pc
  UNION ALL
  SELECT ec.seed_course_id, ee.to_course_id, ec.path || ee.to_course_id
  FROM equivalence_closure ec
  JOIN equivalence_edges ee ON ee.from_course_id = ec.equivalent_course_id
  WHERE NOT ee.to_course_id = ANY(ec.path)
),
propagated_attempts AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.id AS attempt_id,
    scr.course_id,
    scr.study_plan_id,
    scr.academic_term_id,
    term.display_name AS academic_term_name,
    scr.status,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    c.code AS course_code,
    c.name AS course_name
  FROM public.student_course_record scr
  JOIN public.course c ON c.id = scr.course_id
  LEFT JOIN public.academic_term term ON term.id = scr.academic_term_id
  WHERE scr.user_id = p_user_id
    AND scr.status IN ('APPROVED', 'IN_PROGRESS')
    AND c.is_active = true
  ORDER BY
    scr.course_id,
    CASE scr.status WHEN 'APPROVED' THEN 0 ELSE 1 END,
    scr.recorded_at DESC NULLS LAST,
    scr.attempt_number DESC,
    scr.id DESC
),
direct_plan_latest AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.id AS attempt_id,
    scr.course_id,
    scr.study_plan_id,
    scr.academic_term_id,
    term.display_name AS academic_term_name,
    scr.status,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    c.code AS course_code,
    c.name AS course_name
  FROM public.student_course_record scr
  JOIN public.course c ON c.id = scr.course_id
  LEFT JOIN public.academic_term term ON term.id = scr.academic_term_id
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND c.is_active = true
  ORDER BY scr.course_id, scr.recorded_at DESC NULLS LAST, scr.attempt_number DESC, scr.id DESC
)
SELECT
  pc.course_id,
  best_attempt.status,
  best_attempt.grade,
  best_attempt.recorded_at,
  best_attempt.course_id AS origin_course_id,
  best_attempt.course_code AS origin_course_code,
  best_attempt.course_name AS origin_course_name,
  best_attempt.study_plan_id AS origin_study_plan_id,
  best_attempt.attempt_id AS origin_attempt_id,
  best_attempt.attempt_number AS origin_attempt_number,
  best_attempt.academic_term_id AS origin_academic_term_id,
  best_attempt.academic_term_name AS origin_academic_term_name,
  best_attempt.origin_type
FROM plan_courses pc
LEFT JOIN LATERAL (
  SELECT * FROM (
    SELECT
      pa.attempt_id,
      pa.course_id,
      pa.study_plan_id,
      pa.academic_term_id,
      pa.academic_term_name,
      pa.status,
      pa.grade,
      pa.recorded_at,
      pa.attempt_number,
      pa.course_code,
      pa.course_name,
      CASE
        WHEN pa.course_id = pc.course_id AND pa.study_plan_id = p_study_plan_id THEN 'direct'
        WHEN pa.course_id = pc.course_id THEN 'same_course_global'
        ELSE 'equivalent'
      END AS origin_type
    FROM equivalence_closure ec
    JOIN propagated_attempts pa ON pa.course_id = ec.equivalent_course_id
    WHERE ec.seed_course_id = pc.course_id
      AND (
        pa.course_id = pc.course_id
        OR NOT EXISTS (
          SELECT 1
          FROM plan_courses same_plan_course
          WHERE same_plan_course.course_id = pa.course_id
        )
      )
    UNION ALL
    SELECT
      dl.attempt_id,
      dl.course_id,
      dl.study_plan_id,
      dl.academic_term_id,
      dl.academic_term_name,
      dl.status,
      dl.grade,
      dl.recorded_at,
      dl.attempt_number,
      dl.course_code,
      dl.course_name,
      'direct_plan_status' AS origin_type
    FROM direct_plan_latest dl
    WHERE dl.course_id = pc.course_id
  ) candidates
  ORDER BY
    CASE candidates.status WHEN 'APPROVED' THEN 0 ELSE 1 END,
    candidates.recorded_at DESC NULLS LAST,
    CASE candidates.origin_type
      WHEN 'direct' THEN 0
      WHEN 'direct_plan_status' THEN 0
      WHEN 'same_course_global' THEN 1
      ELSE 2
    END,
    candidates.attempt_number DESC,
    candidates.attempt_id DESC
  LIMIT 1
) best_attempt ON true
WHERE best_attempt.attempt_id IS NOT NULL;
$$;

COMMENT ON FUNCTION public.get_user_course_effective_status_details(UUID, BIGINT)
IS 'Returns effective per-course status for a user/plan, propagating APPROVED and IN_PROGRESS by same course globally or plan-scoped directional equivalents that are not active courses in the same viewed plan, with origin metadata. Correctly prioritizes newer attempts over older IN_PROGRESS ones.';

REVOKE ALL ON FUNCTION public.get_user_course_effective_status_details(UUID, BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_course_effective_status_details(UUID, BIGINT) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_user_course_effective_statuses(
  p_user_id UUID,
  p_study_plan_id BIGINT
)
RETURNS TABLE (
  course_id BIGINT,
  status public.student_course_status,
  grade NUMERIC(5,2),
  recorded_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    details.course_id,
    details.status,
    details.grade,
    details.recorded_at
  FROM public.get_user_course_effective_status_details(p_user_id, p_study_plan_id) details;
$$;

COMMENT ON FUNCTION public.get_user_course_effective_statuses(UUID, BIGINT)
IS 'Returns one effective status per course, preserving APPROVED and IN_PROGRESS globally by same course or plan-scoped directional equivalents that are not active courses in the same viewed plan. Correctly prioritizes newer attempts over older IN_PROGRESS ones.';

REVOKE ALL ON FUNCTION public.get_user_course_effective_statuses(UUID, BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_course_effective_statuses(UUID, BIGINT) TO authenticated;

COMMIT;
