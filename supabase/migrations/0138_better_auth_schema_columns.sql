BEGIN;

ALTER TABLE better_auth."twoFactor"
  ADD COLUMN IF NOT EXISTS "failedVerificationCount" integer DEFAULT 0 NOT NULL,
  ADD COLUMN IF NOT EXISTS "lockedUntil" timestamptz;

ALTER TABLE better_auth."jwks"
  ADD COLUMN IF NOT EXISTS "alg" text,
  ADD COLUMN IF NOT EXISTS "crv" text;

COMMIT;
