-- FUNCTION: get_schedule_courses_by_academic_unit (fixed for other campuses)
-- Fixed to properly include groups from other campuses without losing data
DROP FUNCTION IF EXISTS public.get_schedule_courses_by_academic_unit(BIGINT, BIGINT, BIGINT, BOOLEAN);

CREATE OR REPLACE FUNCTION public.get_schedule_courses_by_academic_unit(
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_academic_unit_id BIGINT,
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
  IF p_include_other_campuses THEN
    RETURN QUERY
    WITH schedule_courses AS (
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
        v.groups
      FROM public.v_schedule_courses v
      WHERE v.academic_term_id = p_academic_term_id
        AND v.academic_unit_id = p_academic_unit_id
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
        sc.term_display_name
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
      999 AS level_number,
      NULL::TEXT AS level_label,
      999 AS sort_order
    FROM base_courses bc
    JOIN grouped ON grouped.course_code = bc.course_code
    ORDER BY bc.course_code;
  ELSE
    RETURN QUERY
    SELECT DISTINCT ON (v.course_code)
      v.offering_id,
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
      999 AS level_number,
      NULL::TEXT AS level_label,
      999 AS sort_order
    FROM public.v_schedule_courses v
    WHERE v.academic_term_id = p_academic_term_id
      AND v.campus_id = p_campus_id
      AND v.academic_unit_id = p_academic_unit_id
      AND (v.groups::jsonb <> '[]'::jsonb)
    ORDER BY v.course_code, v.offering_id;
  END IF;
END;
$$;

COMMENT ON FUNCTION public.get_schedule_courses_by_academic_unit IS 'Returns schedule courses with optional other campuses support.';
