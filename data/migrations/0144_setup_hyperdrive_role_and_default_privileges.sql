-- 0144_setup_hyperdrive_role_and_default_privileges.sql
-- Database role and permissions architecture overhaul for Cloudflare Hyperdrive and PostgreSQL
-- 1. Create hyperdrive_role (NOLOGIN, BYPASSRLS) implementing the Group Role pattern with least privilege (DML only).
-- 2. Grant schema, table, sequence, and routine privileges across public, better_auth, and extensions.
-- 3. Configure ALTER DEFAULT PRIVILEGES for objects created by role postgres.
-- 4. Assign hyperdrive_role to hyperdrive_user, set search_path, and revoke postgres superuser if previously assigned.

BEGIN;

-- ============================================================================
-- 1. GROUP ROLE PATTERN: hyperdrive_role (NOLOGIN)
-- ============================================================================

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    CREATE ROLE hyperdrive_role NOLOGIN;
  END IF;
END $$;

-- ============================================================================
-- 2. GRANT SCHEMA ACCESS
-- ============================================================================

GRANT USAGE ON SCHEMA public TO hyperdrive_role;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
    GRANT USAGE ON SCHEMA better_auth TO hyperdrive_role;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'extensions') THEN
    GRANT USAGE ON SCHEMA extensions TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 3. GRANT TABLE ACCESS (DML ONLY: SELECT, INSERT, UPDATE, DELETE)
-- ============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO hyperdrive_role;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA better_auth TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 4. GRANT SEQUENCE ACCESS
-- ============================================================================

GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO hyperdrive_role;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
    GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA better_auth TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 5. GRANT ROUTINE ACCESS
-- ============================================================================

GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public TO hyperdrive_role;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
    GRANT EXECUTE ON ALL ROUTINES IN SCHEMA better_auth TO hyperdrive_role;
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'extensions') THEN
    GRANT EXECUTE ON ALL ROUTINES IN SCHEMA extensions TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 6. CONFIGURE ALTER DEFAULT PRIVILEGES FOR OBJECTS CREATED BY ROLE postgres
-- ============================================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'postgres') THEN
    ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_role;
    ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
      GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO hyperdrive_role;
    ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
      GRANT EXECUTE ON ROUTINES TO hyperdrive_role;

    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
      ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA better_auth
        GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_role;
      ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA better_auth
        GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO hyperdrive_role;
      ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA better_auth
        GRANT EXECUTE ON ROUTINES TO hyperdrive_role;
    END IF;
  END IF;

  -- Also set default privileges for the current migration runner role
  ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_role;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO hyperdrive_role;
  ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT EXECUTE ON ROUTINES TO hyperdrive_role;

  IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
    ALTER DEFAULT PRIVILEGES IN SCHEMA better_auth
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_role;
    ALTER DEFAULT PRIVILEGES IN SCHEMA better_auth
      GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO hyperdrive_role;
    ALTER DEFAULT PRIVILEGES IN SCHEMA better_auth
      GRANT EXECUTE ON ROUTINES TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 7. CONFIGURE RLS BYPASS ON THE GROUP ROLE
-- ============================================================================

ALTER ROLE hyperdrive_role BYPASSRLS;

-- ============================================================================
-- 8. HANDLE hyperdrive_user (LOGIN USER USED BY HYPERDRIVE)
-- ============================================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT hyperdrive_role TO hyperdrive_user;
    ALTER ROLE hyperdrive_user IN DATABASE postgres SET search_path TO better_auth, public, extensions;

    -- Revoke direct postgres superuser role if it was previously granted to adhere to least privilege
    IF EXISTS (
      SELECT 1
      FROM pg_auth_members m
      JOIN pg_roles r ON m.roleid = r.oid
      JOIN pg_roles u ON m.member = u.oid
      WHERE r.rolname = 'postgres' AND u.rolname = 'hyperdrive_user'
    ) THEN
      REVOKE postgres FROM hyperdrive_user;
    END IF;
  END IF;
END $$;

COMMIT;
