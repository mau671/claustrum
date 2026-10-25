-- 0103_greedy_matching_equivalents.sql
-- Implements greedy 1-to-1 matching of equivalent course attempts to plan courses.
-- Ensures that a single equivalent attempt (e.g., passing Futbol I) only satisfies
-- ONE placeholder course (e.g., Electiva Deportiva 1) and not all of them simultaneously.

BEGIN;

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
  SELECT 
    splc.course_id,
    spl.level_number,
    splc.sort_order
  FROM public.study_plan_level_course splc
  JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
  JOIN public.course c ON c.id = splc.course_id
  WHERE spl.study_plan_id = p_study_plan_id
    AND splc.is_active = true
    AND spl.is_active = true
    AND c.is_active = true
),
ranked_pc AS (
  SELECT 
    course_id,
    ROW_NUMBER() OVER (ORDER BY level_number ASC, sort_order ASC, course_id ASC) as pc_rank
  FROM plan_courses
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
    AND c.is_active = true
    -- include all statuses so we don't let IN_PROGRESS override FAILED implicitly
  ORDER BY
    scr.course_id,
    CASE scr.status
      WHEN 'APPROVED' THEN 1
      WHEN 'FAILED' THEN 2
      WHEN 'IN_PROGRESS' THEN 3
      WHEN 'WITHDRAWN' THEN 4
      ELSE 5
    END ASC,
    scr.recorded_at DESC NULLS LAST,
    scr.attempt_number DESC,
    scr.id DESC
),
ranked_pa AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (
      ORDER BY 
        CASE status 
          WHEN 'APPROVED' THEN 1 
          WHEN 'FAILED' THEN 2 
          WHEN 'IN_PROGRESS' THEN 3 
          WHEN 'WITHDRAWN' THEN 4 
          ELSE 5 
        END ASC,
        recorded_at DESC NULLS LAST,
        attempt_id DESC
    ) as pa_rank
  FROM propagated_attempts
),
possible_pairs AS (
  SELECT 
    rpc.course_id as pc_id, 
    rpc.pc_rank,
    rpa.course_id as pa_id, 
    rpa.pa_rank,
    rpa.attempt_id,
    rpa.study_plan_id,
    rpa.academic_term_id,
    rpa.academic_term_name,
    rpa.status,
    rpa.grade,
    rpa.recorded_at,
    rpa.attempt_number,
    rpa.course_code,
    rpa.course_name
  FROM ranked_pc rpc
  JOIN equivalence_closure ec ON ec.seed_course_id = rpc.course_id
  JOIN ranked_pa rpa ON rpa.course_id = ec.equivalent_course_id
  WHERE (
    rpa.course_id = rpc.course_id
    OR NOT EXISTS (
      SELECT 1
      FROM plan_courses same_plan_course
      WHERE same_plan_course.course_id = rpa.course_id
    )
  )
),
ordered_pairs AS (
  SELECT 
    *, 
    ROW_NUMBER() OVER (
      ORDER BY 
        CASE WHEN pc_id = pa_id THEN 0 ELSE 1 END ASC, -- Direct attempts first
        CASE status WHEN 'APPROVED' THEN 1 WHEN 'FAILED' THEN 2 ELSE 3 END ASC, -- Best statuses first
        pc_rank ASC, -- Earlier courses in plan first
        pa_rank ASC -- Best attempts first
    ) as pair_id
  FROM possible_pairs
),
greedy_match(pair_id, pc_id, pa_id, used_pc, used_pa) AS (
  (
    SELECT pair_id, pc_id, pa_id, ARRAY[pc_id], ARRAY[pa_id]
    FROM ordered_pairs
    ORDER BY pair_id
    LIMIT 1
  )
  UNION ALL
  SELECT op.pair_id, op.pc_id, op.pa_id,
         gm.used_pc || op.pc_id,
         gm.used_pa || op.pa_id
  FROM greedy_match gm
  JOIN LATERAL (
    SELECT * FROM ordered_pairs
    WHERE pair_id > gm.pair_id
      AND NOT pc_id = ANY(gm.used_pc)
      AND NOT pa_id = ANY(gm.used_pa)
    ORDER BY pair_id
    LIMIT 1
  ) op ON true
),
matched_pairs AS (
  SELECT 
    gm.pc_id,
    op.attempt_id,
    op.pa_id as course_id,
    op.study_plan_id,
    op.academic_term_id,
    op.academic_term_name,
    op.status,
    op.grade,
    op.recorded_at,
    op.attempt_number,
    op.course_code,
    op.course_name,
    CASE
      WHEN op.pa_id = gm.pc_id AND op.study_plan_id = p_study_plan_id THEN 'direct'
      WHEN op.pa_id = gm.pc_id THEN 'same_course_global'
      ELSE 'equivalent'
    END AS origin_type
  FROM greedy_match gm
  JOIN ordered_pairs op ON op.pair_id = gm.pair_id
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
  COALESCE(propagated_origin.status, direct_latest.status) AS status,
  COALESCE(propagated_origin.grade, direct_latest.grade) AS grade,
  COALESCE(propagated_origin.recorded_at, direct_latest.recorded_at) AS recorded_at,
  COALESCE(propagated_origin.course_id, direct_latest.course_id) AS origin_course_id,
  COALESCE(propagated_origin.course_code, direct_latest.course_code) AS origin_course_code,
  COALESCE(propagated_origin.course_name, direct_latest.course_name) AS origin_course_name,
  COALESCE(propagated_origin.study_plan_id, direct_latest.study_plan_id) AS origin_study_plan_id,
  COALESCE(propagated_origin.attempt_id, direct_latest.attempt_id) AS origin_attempt_id,
  COALESCE(propagated_origin.attempt_number, direct_latest.attempt_number) AS origin_attempt_number,
  COALESCE(propagated_origin.academic_term_id, direct_latest.academic_term_id) AS origin_academic_term_id,
  COALESCE(propagated_origin.academic_term_name, direct_latest.academic_term_name) AS origin_academic_term_name,
  CASE
    WHEN propagated_origin.attempt_id IS NOT NULL THEN propagated_origin.origin_type
    WHEN direct_latest.attempt_id IS NOT NULL THEN 'direct_plan_status'
    ELSE NULL
  END AS origin_type
FROM plan_courses pc
LEFT JOIN matched_pairs propagated_origin ON propagated_origin.pc_id = pc.course_id
LEFT JOIN direct_plan_latest direct_latest ON direct_latest.course_id = pc.course_id
WHERE propagated_origin.attempt_id IS NOT NULL
   OR direct_latest.attempt_id IS NOT NULL;
$$;

COMMENT ON FUNCTION public.get_user_course_effective_status_details(UUID, BIGINT)
IS 'Returns effective per-course status for a user/plan. Uses a greedy 1-to-1 matching to prevent a single equivalent course attempt from satisfying multiple placeholder courses simultaneously.';

COMMIT;
