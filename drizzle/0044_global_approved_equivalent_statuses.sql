-- 0044_global_approved_equivalent_statuses.sql
-- Propagate only APPROVED statuses across the same course globally and across
-- transitive bidirectional equivalents within the currently viewed study plan.

BEGIN;

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
  UNION
  SELECT cr.to_course_id AS from_course_id, cr.from_course_id AS to_course_id
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
approved_attempts AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.id AS attempt_id,
    scr.course_id,
    scr.study_plan_id,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    c.code AS course_code,
    c.name AS course_name
  FROM public.student_course_record scr
  JOIN public.course c ON c.id = scr.course_id
  WHERE scr.user_id = p_user_id
    AND scr.status = 'APPROVED'
    AND c.is_active = true
  ORDER BY scr.course_id, scr.recorded_at DESC NULLS LAST, scr.attempt_number DESC, scr.id DESC
),
direct_plan_latest AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.id AS attempt_id,
    scr.course_id,
    scr.study_plan_id,
    scr.status,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    c.code AS course_code,
    c.name AS course_name
  FROM public.student_course_record scr
  JOIN public.course c ON c.id = scr.course_id
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND c.is_active = true
  ORDER BY scr.course_id, scr.recorded_at DESC NULLS LAST, scr.attempt_number DESC, scr.id DESC
)
SELECT
  pc.course_id,
  CASE
    WHEN approved_origin.attempt_id IS NOT NULL THEN 'APPROVED'::public.student_course_status
    ELSE direct_latest.status
  END AS status,
  COALESCE(approved_origin.grade, direct_latest.grade) AS grade,
  COALESCE(approved_origin.recorded_at, direct_latest.recorded_at) AS recorded_at,
  COALESCE(approved_origin.course_id, direct_latest.course_id) AS origin_course_id,
  COALESCE(approved_origin.course_code, direct_latest.course_code) AS origin_course_code,
  COALESCE(approved_origin.course_name, direct_latest.course_name) AS origin_course_name,
  COALESCE(approved_origin.study_plan_id, direct_latest.study_plan_id) AS origin_study_plan_id,
  COALESCE(approved_origin.attempt_id, direct_latest.attempt_id) AS origin_attempt_id,
  CASE
    WHEN approved_origin.attempt_id IS NOT NULL THEN approved_origin.origin_type
    WHEN direct_latest.attempt_id IS NOT NULL THEN 'direct_plan_status'
    ELSE NULL
  END AS origin_type
FROM plan_courses pc
LEFT JOIN LATERAL (
  SELECT
    aa.attempt_id,
    aa.course_id,
    aa.study_plan_id,
    aa.grade,
    aa.recorded_at,
    aa.attempt_number,
    aa.course_code,
    aa.course_name,
    CASE
      WHEN aa.course_id = pc.course_id AND aa.study_plan_id = p_study_plan_id THEN 'direct'
      WHEN aa.course_id = pc.course_id THEN 'same_course_global'
      ELSE 'equivalent'
    END AS origin_type
  FROM equivalence_closure ec
  JOIN approved_attempts aa ON aa.course_id = ec.equivalent_course_id
  WHERE ec.seed_course_id = pc.course_id
  ORDER BY
    CASE
      WHEN aa.course_id = pc.course_id AND aa.study_plan_id = p_study_plan_id THEN 0
      WHEN aa.course_id = pc.course_id THEN 1
      ELSE 2
    END,
    aa.recorded_at DESC NULLS LAST,
    aa.attempt_number DESC,
    aa.attempt_id DESC
  LIMIT 1
) approved_origin ON true
LEFT JOIN direct_plan_latest direct_latest ON direct_latest.course_id = pc.course_id
WHERE approved_origin.attempt_id IS NOT NULL
   OR direct_latest.attempt_id IS NOT NULL;
$$;

COMMENT ON FUNCTION public.get_user_course_effective_status_details(UUID, BIGINT)
IS 'Returns effective per-course status for a user/plan, propagating only APPROVED by same course globally or plan-scoped transitive equivalents, with origin metadata.';

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
IS 'Returns one effective status per course, preserving APPROVED globally by same course or plan-scoped equivalents.';

REVOKE ALL ON FUNCTION public.get_user_course_effective_statuses(UUID, BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_course_effective_statuses(UUID, BIGINT) TO authenticated;

COMMIT;
