BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT USAGE ON SCHEMA extensions TO hyperdrive_user;
    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA extensions TO hyperdrive_user;
    GRANT EXECUTE ON ALL ROUTINES IN SCHEMA extensions TO hyperdrive_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA extensions
      GRANT EXECUTE ON FUNCTIONS TO hyperdrive_user;
  END IF;
END $$;

COMMIT;
