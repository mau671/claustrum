BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT USAGE ON SCHEMA better_auth TO hyperdrive_user;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA better_auth TO hyperdrive_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA better_auth
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_user;

    GRANT USAGE ON SCHEMA public TO hyperdrive_user;
    GRANT SELECT, INSERT ON public."user" TO hyperdrive_user;

    DROP POLICY IF EXISTS "Hyperdrive can insert app user profiles" ON public."user";
    CREATE POLICY "Hyperdrive can insert app user profiles"
    ON public."user"
    FOR INSERT
    TO hyperdrive_user
    WITH CHECK (true);
  END IF;
END $$;

COMMIT;
