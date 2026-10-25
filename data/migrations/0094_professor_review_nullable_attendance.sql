BEGIN;

ALTER TABLE public.professor_review
  ALTER COLUMN attendance_required DROP NOT NULL;

COMMIT;
