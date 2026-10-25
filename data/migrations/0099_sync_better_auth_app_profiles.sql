BEGIN;

CREATE OR REPLACE FUNCTION public.handle_better_auth_user_created()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public."user" (id)
  VALUES (NEW.id)
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_better_auth_user_created ON better_auth."user";
CREATE TRIGGER on_better_auth_user_created
AFTER INSERT ON better_auth."user"
FOR EACH ROW
EXECUTE FUNCTION public.handle_better_auth_user_created();

INSERT INTO public."user" (id)
SELECT id
FROM better_auth."user"
ON CONFLICT (id) DO NOTHING;

COMMIT;
