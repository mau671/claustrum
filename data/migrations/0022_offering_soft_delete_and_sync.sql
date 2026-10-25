-- 0022_offering_soft_delete_and_sync.sql
-- Adds active-state lifecycle support for schedule offering data and
-- updates read/validation surfaces to ignore inactive rows.

BEGIN;

ALTER TABLE public.course_offering
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.course_offering_group
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.course_offering_group_professor
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.course_offering_meeting
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course_offering') THEN
    CREATE TRIGGER set_timestamp_course_offering
      BEFORE UPDATE ON public.course_offering
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course_offering_group') THEN
    CREATE TRIGGER set_timestamp_course_offering_group
      BEFORE UPDATE ON public.course_offering_group
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course_offering_group_professor') THEN
    CREATE TRIGGER set_timestamp_course_offering_group_professor
      BEFORE UPDATE ON public.course_offering_group_professor
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course_offering_meeting') THEN
    CREATE TRIGGER set_timestamp_course_offering_meeting
      BEFORE UPDATE ON public.course_offering_meeting
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_course_offering_term_active
  ON public.course_offering(academic_term_id, is_active);

CREATE INDEX IF NOT EXISTS idx_course_offering_group_offering_active
  ON public.course_offering_group(course_offering_id, is_active);

CREATE INDEX IF NOT EXISTS idx_course_offering_group_professor_group_active
  ON public.course_offering_group_professor(course_offering_group_id, is_active);

CREATE INDEX IF NOT EXISTS idx_course_offering_meeting_group_active
  ON public.course_offering_meeting(course_offering_group_id, is_active);

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
          SELECT json_agg(p.full_name ORDER BY p.full_name)
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
