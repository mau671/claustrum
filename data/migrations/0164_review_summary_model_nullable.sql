-- 0164_review_summary_model_nullable.sql
-- Stores the model that produced each summary per run instead of a fixed default.

BEGIN;

ALTER TABLE public.professor_review_summary
  ALTER COLUMN model_used DROP NOT NULL,
  ALTER COLUMN model_used DROP DEFAULT;

COMMIT;
