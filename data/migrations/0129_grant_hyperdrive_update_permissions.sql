DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT UPDATE ON public."user" TO hyperdrive_user;
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_study_plan TO hyperdrive_user;
  END IF;
END
$$;
