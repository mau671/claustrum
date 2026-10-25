BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    -- SELECT policy for hyperdrive_user on user
    DROP POLICY IF EXISTS "Hyperdrive can view app user profiles" ON public."user";
    CREATE POLICY "Hyperdrive can view app user profiles"
    ON public."user"
    FOR SELECT
    TO hyperdrive_user
    USING (true);

    -- UPDATE policy for hyperdrive_user on user
    DROP POLICY IF EXISTS "Hyperdrive can update app user profiles" ON public."user";
    CREATE POLICY "Hyperdrive can update app user profiles"
    ON public."user"
    FOR UPDATE
    TO hyperdrive_user
    USING (true)
    WITH CHECK (true);

    -- SELECT policy for hyperdrive_user on user_study_plan
    DROP POLICY IF EXISTS "Hyperdrive can view user study plans" ON public.user_study_plan;
    CREATE POLICY "Hyperdrive can view user study plans"
    ON public.user_study_plan
    FOR SELECT
    TO hyperdrive_user
    USING (true);

    -- INSERT policy for hyperdrive_user on user_study_plan
    DROP POLICY IF EXISTS "Hyperdrive can insert user study plans" ON public.user_study_plan;
    CREATE POLICY "Hyperdrive can insert user study plans"
    ON public.user_study_plan
    FOR INSERT
    TO hyperdrive_user
    WITH CHECK (true);

    -- UPDATE policy for hyperdrive_user on user_study_plan
    DROP POLICY IF EXISTS "Hyperdrive can update user study plans" ON public.user_study_plan;
    CREATE POLICY "Hyperdrive can update user study plans"
    ON public.user_study_plan
    FOR UPDATE
    TO hyperdrive_user
    USING (true)
    WITH CHECK (true);

  END IF;
END
$$;

COMMIT;
