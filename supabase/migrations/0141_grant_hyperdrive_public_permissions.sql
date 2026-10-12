BEGIN;

DO $$
DECLARE
  v_table text;
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    -- 1. Otorgar permisos sobre el schema public
    GRANT USAGE ON SCHEMA public TO hyperdrive_user;

    -- 2. Otorgar permisos de lectura/escritura en todas las tablas y vistas de public
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO hyperdrive_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hyperdrive_user;

    -- 3. Otorgar permisos sobre todas las secuencias de public
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hyperdrive_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT USAGE, SELECT ON SEQUENCES TO hyperdrive_user;

    -- 4. Otorgar permisos de ejecución en todas las funciones y rutinas de public
    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO hyperdrive_user;
    GRANT EXECUTE ON ALL ROUTINES IN SCHEMA public TO hyperdrive_user;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT EXECUTE ON FUNCTIONS TO hyperdrive_user;

    -- 5. Intentar otorgar BYPASSRLS si el entorno lo permite
    BEGIN
      ALTER ROLE hyperdrive_user BYPASSRLS;
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;

    -- 6. Crear política permisiva para hyperdrive_user en todas las tablas de public con RLS
    FOR v_table IN
      SELECT tablename
      FROM pg_tables
      WHERE schemaname = 'public'
    LOOP
      EXECUTE format(
        'DROP POLICY IF EXISTS "Hyperdrive full access" ON public.%I',
        v_table
      );
      EXECUTE format(
        'CREATE POLICY "Hyperdrive full access" ON public.%I FOR ALL TO hyperdrive_user USING (true) WITH CHECK (true)',
        v_table
      );
    END LOOP;
  END IF;
END $$;

COMMIT;
