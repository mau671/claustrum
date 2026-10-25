BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    -- Grant usage on all existing sequences in public schema
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hyperdrive_user;
    
    -- Ensure future sequences will also have these permissions
    ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT USAGE, SELECT ON SEQUENCES TO hyperdrive_user;
  END IF;
END
$$;

COMMIT;
