BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
    ALTER ROLE postgres RESET search_path;
    ALTER ROLE postgres IN DATABASE postgres RESET search_path;
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    ALTER ROLE hyperdrive_user IN DATABASE postgres SET search_path TO better_auth, public;
  END IF;
END $$;

COMMIT;
