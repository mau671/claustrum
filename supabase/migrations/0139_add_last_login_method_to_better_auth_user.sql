BEGIN;

ALTER TABLE better_auth."user"
  ADD COLUMN IF NOT EXISTS "lastLoginMethod" text;

COMMIT;
