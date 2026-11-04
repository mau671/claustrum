-- 0160_rename_professor_review_summary.sql
-- Renames professor_review_ai_summary to professor_review_summary

BEGIN;

ALTER TABLE IF EXISTS public.professor_review_ai_summary
  RENAME TO professor_review_summary;

-- Trigger rename
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_professor_review_ai_summary'
  ) THEN
    ALTER TRIGGER set_timestamp_professor_review_ai_summary
      ON public.professor_review_summary
      RENAME TO set_timestamp_professor_review_summary;
  END IF;
END $$;

-- Policy recreation for consistency
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    DROP POLICY IF EXISTS "Hyperdrive full access" ON public.professor_review_summary;
    CREATE POLICY "Hyperdrive full access" ON public.professor_review_summary
      FOR ALL TO hyperdrive_user USING (true) WITH CHECK (true);
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
    DROP POLICY IF EXISTS "Service role full access" ON public.professor_review_summary;
    CREATE POLICY "Service role full access" ON public.professor_review_summary
      FOR ALL TO service_role USING (true) WITH CHECK (true);
  END IF;
END $$;

COMMIT;
