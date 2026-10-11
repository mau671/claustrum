BEGIN;

-- 1. Agregar columnas del plugin Admin de Better Auth en el schema better_auth
ALTER TABLE better_auth."user"
  ADD COLUMN IF NOT EXISTS "role" text DEFAULT 'user' NOT NULL,
  ADD COLUMN IF NOT EXISTS "banned" boolean DEFAULT false NOT NULL,
  ADD COLUMN IF NOT EXISTS "banReason" text,
  ADD COLUMN IF NOT EXISTS "banExpires" timestamptz;

ALTER TABLE better_auth."session"
  ADD COLUMN IF NOT EXISTS "impersonatedBy" text;

CREATE INDEX IF NOT EXISTS "idx_better_auth_user_role" ON better_auth."user" ("role");

-- 2. Migrar administradores existentes desde public.user_role hacia better_auth."user"
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'user_role'
  ) THEN
    UPDATE better_auth."user" u
    SET role = 'admin'
    FROM public.user_role ur
    WHERE ur.user_id = u.id AND ur.role::text = 'admin';
  END IF;
END $$;

-- Asegurar que cualquier usuario sin rol explícito quede con rol 'user'
UPDATE better_auth."user"
SET role = 'user'
WHERE role IS NULL OR trim(role) = '';

-- 3. Actualizar función is_admin() para leer directamente de better_auth."user"
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, better_auth
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM better_auth."user" u
    WHERE u.id = (SELECT public.current_user_id())
      AND u.role = 'admin'
      AND u.banned = false
  );
$$;

REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- 4. Crear función can_moderate() para verificar si un usuario es admin o moderador
CREATE OR REPLACE FUNCTION public.can_moderate()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, better_auth
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM better_auth."user" u
    WHERE u.id = (SELECT public.current_user_id())
      AND u.role IN ('admin', 'moderator')
      AND u.banned = false
  );
$$;

REVOKE ALL ON FUNCTION public.can_moderate() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.can_moderate() TO authenticated;

-- 5. Eliminar la tabla legada public.user_role y el enum public.app_role
DROP TABLE IF EXISTS public.user_role CASCADE;
DROP TYPE IF EXISTS public.app_role CASCADE;

COMMIT;
