BEGIN;

ALTER TABLE public.sync_seed_run
  DROP CONSTRAINT IF EXISTS sync_seed_run_scope_check;

UPDATE public.sync_seed_run
SET scope = 'all'
WHERE scope = 'mixed';

ALTER TABLE public.sync_seed_run
  ADD CONSTRAINT sync_seed_run_scope_check
  CHECK (scope = ANY (ARRAY['catalog'::text, 'offering'::text, 'all'::text]));

COMMIT;
