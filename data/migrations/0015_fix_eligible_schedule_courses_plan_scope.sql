-- Fix eligibility filters to scope by active study plan
CREATE OR REPLACE FUNCTION public.get_eligible_schedule_courses(
  p_user_id UUID,
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_include_other_campuses BOOLEAN DEFAULT false,
  p_show_all_courses BOOLEAN DEFAULT true
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
  WITH user_plan AS (
    SELECT usp.study_plan_id
    FROM public.user_study_plan usp
    WHERE usp.user_id = p_user_id AND usp.is_active = true
    ORDER BY usp.id DESC
    LIMIT 1
  ),
  plan_courses AS (
    SELECT
      splc.course_id,
      spl.level_number,
      spl.level_label,
      splc.sort_order
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    JOIN user_plan up ON spl.study_plan_id = up.study_plan_id
  ),
  course_status AS (
    SELECT scr.course_id, scr.status
    FROM public.student_course_record scr
    JOIN user_plan up ON scr.study_plan_id = up.study_plan_id
    WHERE scr.user_id = p_user_id
  ),
  candidate_courses AS (
    SELECT
      pc.course_id,
      pc.level_number,
      pc.level_label,
      pc.sort_order,
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
    JOIN user_plan up ON cr.study_plan_id = up.study_plan_id
    JOIN plan_courses pc ON pc.course_id = cr.from_course_id
    JOIN public.course prereq ON cr.to_course_id = prereq.id
    LEFT JOIN course_status cs ON cs.course_id = cr.to_course_id
    WHERE cr.relation_type = 'PREREQUISITE'
  ),
  prereq_eligible AS (
    SELECT
      c.course_id,
      c.level_number,
      c.level_label,
      c.sort_order,
      c.status
    FROM candidate_courses c
    LEFT JOIN prereq_status p ON p.course_id = c.course_id
    GROUP BY c.course_id, c.level_number, c.level_label, c.sort_order, c.status
    HAVING COUNT(p.prereq_code) FILTER (WHERE p.prereq_code IS NOT NULL)
         = COUNT(p.prereq_code) FILTER (WHERE p.prereq_status = 'APPROVED')
  ),
  coreq_check AS (
    SELECT
      cr.from_course_id AS course_id,
      cr.to_course_id AS coreq_course_id
    FROM public.course_relation cr
    JOIN user_plan up ON cr.study_plan_id = up.study_plan_id
    JOIN plan_courses pc ON pc.course_id = cr.from_course_id
    WHERE cr.relation_type = 'COREQUISITE'
  ),
  eligible_courses AS (
    SELECT DISTINCT ON (e.course_id)
      e.course_id,
      e.level_number,
      e.level_label,
      e.sort_order
    FROM prereq_eligible e
    WHERE NOT EXISTS (
      SELECT 1
      FROM coreq_check cc
      WHERE cc.course_id = e.course_id
        AND cc.coreq_course_id NOT IN (SELECT pe.course_id FROM prereq_eligible pe)
        AND cc.coreq_course_id NOT IN (
          SELECT cs.course_id FROM course_status cs WHERE cs.status = 'APPROVED'
        )
    )
  ),
  final_courses AS (
    SELECT pc.course_id, pc.level_number, pc.level_label, pc.sort_order
    FROM plan_courses pc
    WHERE p_show_all_courses = true
    UNION
    SELECT ec.course_id, ec.level_number, ec.level_label, ec.sort_order
    FROM eligible_courses ec
  ),
  ordered_courses AS (
    SELECT fc.course_id, fc.level_number, fc.level_label, fc.sort_order
    FROM final_courses fc
    ORDER BY fc.level_number, fc.sort_order
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
      COALESCE(oc.level_number, 999) AS level_number,
      oc.level_label,
      COALESCE(oc.sort_order, 999) AS sort_order
    FROM public.v_schedule_courses v
    JOIN ordered_courses oc ON oc.course_id = v.course_id
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
