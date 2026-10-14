-- 0024_schedule_data_quality_constraints.sql
-- Data quality hardening for schedule/offering values.

BEGIN;

-- Normalize placeholder classroom values to NULL.
UPDATE public.course_offering_meeting
SET classroom = NULL
WHERE classroom IS NOT NULL
  AND upper(trim(classroom)) = 'NO DISPONIBLE';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'course_offering_credits_snapshot_nonnegative'
      AND conrelid = 'public.course_offering'::regclass
  ) THEN
    ALTER TABLE public.course_offering
      ADD CONSTRAINT course_offering_credits_snapshot_nonnegative
      CHECK (credits_snapshot >= 0);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'course_offering_weekly_hours_snapshot_nonnegative'
      AND conrelid = 'public.course_offering'::regclass
  ) THEN
    ALTER TABLE public.course_offering
      ADD CONSTRAINT course_offering_weekly_hours_snapshot_nonnegative
      CHECK (weekly_hours_snapshot >= 0);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'course_offering_group_capacity_nonnegative'
      AND conrelid = 'public.course_offering_group'::regclass
  ) THEN
    ALTER TABLE public.course_offering_group
      ADD CONSTRAINT course_offering_group_capacity_nonnegative
      CHECK (capacity >= 0);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'course_offering_meeting_time_range_check'
      AND conrelid = 'public.course_offering_meeting'::regclass
  ) THEN
    ALTER TABLE public.course_offering_meeting
      ADD CONSTRAINT course_offering_meeting_time_range_check
      CHECK (starts_at < ends_at);
  END IF;
END $$;

COMMIT;
