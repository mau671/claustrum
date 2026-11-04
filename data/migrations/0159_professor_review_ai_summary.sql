-- 0159_professor_review_ai_summary.sql
-- Stores AI-generated qualitative summaries for professors with high review volume.

BEGIN;

CREATE TABLE IF NOT EXISTS public.professor_review_ai_summary (
  professor_id BIGINT PRIMARY KEY REFERENCES public.professor(id) ON DELETE CASCADE,
  summary TEXT NOT NULL,
  reviews_analyzed_count INTEGER NOT NULL CHECK (reviews_analyzed_count > 0),
  last_review_id_analyzed BIGINT NOT NULL,
  model_used TEXT NOT NULL DEFAULT 'cliproxy/gemini-3.8-flash#medium',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Trigger for updated_at
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_professor_review_ai_summary'
  ) THEN
    CREATE TRIGGER set_timestamp_professor_review_ai_summary
      BEFORE UPDATE ON public.professor_review_ai_summary
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;
END $$;

-- Enable RLS
ALTER TABLE public.professor_review_ai_summary ENABLE ROW LEVEL SECURITY;

-- Allow 'review_summaries' scope in sync_seed_run
ALTER TABLE public.sync_seed_run DROP CONSTRAINT IF EXISTS sync_seed_run_scope_check;
ALTER TABLE public.sync_seed_run ADD CONSTRAINT sync_seed_run_scope_check CHECK (scope = ANY (ARRAY['catalog'::text, 'offering'::text, 'reviews'::text, 'review_summaries'::text, 'all'::text]));

-- Grant permissions and define policies
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.professor_review_ai_summary TO hyperdrive_user;
    DROP POLICY IF EXISTS "Hyperdrive full access" ON public.professor_review_ai_summary;
    CREATE POLICY "Hyperdrive full access" ON public.professor_review_ai_summary
      FOR ALL TO hyperdrive_user USING (true) WITH CHECK (true);
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.professor_review_ai_summary TO service_role;
    DROP POLICY IF EXISTS "Service role full access" ON public.professor_review_ai_summary;
    CREATE POLICY "Service role full access" ON public.professor_review_ai_summary
      FOR ALL TO service_role USING (true) WITH CHECK (true);
  END IF;
END $$;

COMMIT;
