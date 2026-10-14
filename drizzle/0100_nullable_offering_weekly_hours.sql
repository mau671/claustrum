-- 0100_nullable_offering_weekly_hours.sql
-- Allow offerings sourced only from tabla_guia_horario to omit weekly hours.

BEGIN;

ALTER TABLE public.course_offering
  ALTER COLUMN weekly_hours_snapshot DROP NOT NULL;

COMMIT;
