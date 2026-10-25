ALTER TABLE public."user"
  ADD COLUMN IF NOT EXISTS onboarding_dismissed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS onboarding_completed_at TIMESTAMPTZ;

COMMENT ON COLUMN public."user".onboarding_dismissed_at IS 'Timestamp when user explicitly skipped onboarding.';
COMMENT ON COLUMN public."user".onboarding_completed_at IS 'Timestamp when user completed onboarding.';
