BEGIN;

CREATE OR REPLACE VIEW public.v_schedule_courses
WITH (security_invoker = true)
AS
SELECT
  co.id AS offering_id,
  co.course_id,
  c.code AS course_code,
  c.name AS course_name,
  co.credits_snapshot,
  co.weekly_hours_snapshot,
  co.course_type,
  co.academic_unit_id,
  au.name AS academic_unit_name,
  co.campus_id,
  co.academic_term_id,
  at.display_name AS term_display_name,
  COALESCE(
    (SELECT json_agg(
      jsonb_build_object(
        'group_id', g.id,
        'group_code', g.group_code,
        'group_type', g.group_type,
        'capacity', g.capacity,
        'professors', (
          SELECT json_agg(
            jsonb_build_object('id', p.id, 'name', p.full_name)
            ORDER BY p.full_name
          )
          FROM public.professor p
          JOIN public.course_offering_group_professor cogp ON cogp.professor_id = p.id
          WHERE cogp.course_offering_group_id = g.id
            AND cogp.is_active = true
        ),
        'meetings', (
          SELECT json_agg(
            jsonb_build_object(
              'weekday', com.weekday,
              'starts_at', com.starts_at::text,
              'ends_at', com.ends_at::text,
              'classroom', com.classroom
            ) ORDER BY com.weekday, com.starts_at
          )
          FROM public.course_offering_meeting com
          WHERE com.course_offering_group_id = g.id
            AND com.is_active = true
        )
      ) ORDER BY (g.group_code)::INT
    )
    FROM public.course_offering_group g
    WHERE g.course_offering_id = co.id
      AND g.is_active = true),
    '[]'::json
  ) AS groups
FROM public.course_offering co
JOIN public.course c ON co.course_id = c.id
JOIN public.academic_unit au ON co.academic_unit_id = au.id
JOIN public.academic_term at ON co.academic_term_id = at.id
WHERE co.is_active = true;

COMMIT;
