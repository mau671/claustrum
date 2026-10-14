BEGIN;

CREATE OR REPLACE FUNCTION public.get_schedule_courses_by_study_plan(
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_study_plan_id BIGINT,
  p_include_other_campuses BOOLEAN DEFAULT false
)
RETURNS TABLE (
  offering_id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  course_type TEXT,
  academic_unit_id BIGINT,
  academic_unit_name TEXT,
  campus_id BIGINT,
  academic_term_id BIGINT,
  term_display_name TEXT,
  groups JSON,
  level_number INTEGER,
  level_label TEXT,
  sort_order INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  WITH plan_courses AS (
    SELECT
      splc.course_id,
      spl.level_number,
      spl.level_label,
      splc.sort_order
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  placeholder_courses AS (
    SELECT pc.course_id, pc.level_number, pc.level_label, pc.sort_order
    FROM plan_courses pc
    JOIN public.course c ON c.id = pc.course_id
    JOIN public.schedule_equivalence_placeholder_course sep
      ON sep.is_active = TRUE
     AND (sep.study_plan_id IS NULL OR sep.study_plan_id = p_study_plan_id)
     AND (
       (sep.course_code IS NOT NULL AND sep.course_code = c.code)
       OR (
         sep.course_name_ilike_pattern IS NOT NULL
         AND c.name ILIKE sep.course_name_ilike_pattern
       )
     )
  ),
  equivalent_courses AS (
    SELECT DISTINCT
      cr.to_course_id AS course_id,
      pc.level_number,
      pc.level_label,
      pc.sort_order
    FROM public.course_relation cr
    JOIN placeholder_courses pc ON pc.course_id = cr.from_course_id
    WHERE cr.study_plan_id = p_study_plan_id
      AND cr.relation_type = 'EQUIVALENT'
  ),
  expanded_plan_courses AS (
    SELECT pc.course_id, pc.level_number, pc.level_label, pc.sort_order
    FROM plan_courses pc
    UNION
    SELECT ec.course_id, ec.level_number, ec.level_label, ec.sort_order
    FROM equivalent_courses ec
  ),
  schedule_courses AS (
    SELECT v.offering_id,
      v.course_id,
      v.course_code,
      v.course_name,
      v.credits_snapshot AS credits,
      v.weekly_hours_snapshot AS weekly_hours,
      v.course_type,
      v.academic_unit_id,
      v.academic_unit_name,
      v.campus_id,
      v.academic_term_id,
      v.term_display_name,
      v.groups,
      COALESCE(pc.level_number, 999) AS level_number,
      pc.level_label,
      COALESCE(pc.sort_order, 999) AS sort_order
    FROM public.v_schedule_courses v
    JOIN expanded_plan_courses pc ON pc.course_id = v.course_id
    WHERE v.academic_term_id = p_academic_term_id
      AND (p_include_other_campuses OR v.campus_id = p_campus_id)
      AND (v.groups::jsonb <> '[]'::jsonb)
  ),
  base_courses AS (
    SELECT DISTINCT ON (sc.course_code)
      sc.offering_id,
      sc.course_id,
      sc.course_code,
      sc.course_name,
      sc.credits,
      sc.weekly_hours,
      sc.course_type,
      sc.academic_unit_id,
      sc.academic_unit_name,
      sc.campus_id,
      sc.academic_term_id,
      sc.term_display_name,
      sc.level_number,
      sc.level_label,
      sc.sort_order
    FROM schedule_courses sc
    ORDER BY sc.course_code, (sc.campus_id = p_campus_id) DESC, sc.offering_id
  ),
  group_rows AS (
    SELECT sc.course_code,
      (g.value || jsonb_build_object('campus_id', sc.campus_id)) AS group_obj
    FROM schedule_courses sc
    JOIN LATERAL jsonb_array_elements(sc.groups::jsonb) AS g(value) ON true
  ),
  grouped AS (
    SELECT gr.course_code,
      json_agg(group_obj ORDER BY (group_obj->>'group_code')::int, (group_obj->>'campus_id')::int) AS groups
    FROM group_rows gr
    GROUP BY gr.course_code
  )
  SELECT bc.offering_id,
    bc.course_id,
    bc.course_code,
    bc.course_name,
    bc.credits,
    bc.weekly_hours,
    bc.course_type,
    bc.academic_unit_id,
    bc.academic_unit_name,
    bc.campus_id,
    bc.academic_term_id,
    bc.term_display_name,
    grouped.groups,
    bc.level_number,
    bc.level_label,
    bc.sort_order
  FROM base_courses bc
  JOIN grouped ON grouped.course_code = bc.course_code
  ORDER BY bc.level_number, bc.sort_order, bc.course_code;
END;
$$;

COMMIT;
