BEGIN;

-- 1. Create Notifications Table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES better_auth."user"(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  link TEXT,
  is_read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON public.notifications (user_id);
CREATE INDEX idx_notifications_created_at ON public.notifications (created_at DESC);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Usuarios pueden leer sus propias notificaciones
CREATE POLICY "Usuarios pueden leer sus propias notificaciones"
  ON public.notifications FOR SELECT TO authenticated
  USING (user_id = (auth.uid())::uuid); 

-- Usuarios pueden actualizar sus propias notificaciones (ej. marcar como leída)
CREATE POLICY "Usuarios pueden actualizar sus propias notificaciones"
  ON public.notifications FOR UPDATE TO authenticated
  USING (user_id = (auth.uid())::uuid)
  WITH CHECK (user_id = (auth.uid())::uuid);

-- Administradores pueden insertar y leer todo
CREATE POLICY "Administradores pueden gestionar notificaciones"
  ON public.notifications FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- 2. Alterar tabla de retroalimentación
ALTER TABLE public.user_feedback
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES better_auth."user"(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS admin_notes TEXT;

-- 3. Crear RPC para respuesta del administrador
CREATE OR REPLACE FUNCTION public.reply_to_feedback(
  p_feedback_id BIGINT,
  p_admin_notes TEXT,
  p_reply_message TEXT
) RETURNS void AS $$
DECLARE
  v_user_id UUID;
BEGIN
  -- Verificar administrador
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Acceso denegado';
  END IF;

  -- Actualizar retroalimentación y obtener el ID del usuario
  UPDATE public.user_feedback
  SET 
    admin_notes = COALESCE(p_admin_notes, admin_notes),
    is_reviewed = true,
    updated_at = NOW()
  WHERE id = p_feedback_id
  RETURNING user_id INTO v_user_id;

  -- Insertar notificación si hay un mensaje y un usuario vinculado
  IF p_reply_message IS NOT NULL AND p_reply_message != '' AND v_user_id IS NOT NULL THEN
    INSERT INTO public.notifications (user_id, title, message, link)
    VALUES (
      v_user_id,
      'Respuesta a tu retroalimentación',
      p_reply_message,
      NULL -- Opcional: enlace a una vista de retroalimentación para usuarios
    );
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;
