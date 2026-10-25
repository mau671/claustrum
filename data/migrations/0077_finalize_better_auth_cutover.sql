-- 0070_finalize_better_auth_cutover.sql
-- Run after Better Auth CLI has generated its schema in better_auth and after
-- Supabase Auth users have been migrated into better_auth."user".

BEGIN;

DO $$
BEGIN
  IF to_regclass('better_auth."user"') IS NULL THEN
    RAISE EXCEPTION 'better_auth."user" does not exist. Run the Better Auth CLI schema migration before this Supabase migration.';
  END IF;
END $$;

INSERT INTO better_auth."user" (
  "id",
  "name",
  "email",
  "emailVerified",
  "image",
  "createdAt",
  "updatedAt",
  "userMetadata",
  "appMetadata",
  "invitedAt",
  "lastSignInAt"
)
SELECT
  au.id,
  COALESCE(
    au.raw_user_meta_data ->> 'full_name',
    au.raw_user_meta_data ->> 'name',
    au.raw_user_meta_data ->> 'user_name',
    split_part(au.email, '@', 1),
    'Usuario'
  ),
  au.email,
  au.email_confirmed_at IS NOT NULL,
  COALESCE(au.raw_user_meta_data ->> 'avatar_url', au.raw_user_meta_data ->> 'picture'),
  au.created_at,
  COALESCE(au.updated_at, au.created_at, now()),
  au.raw_user_meta_data,
  au.raw_app_meta_data,
  au.invited_at,
  au.last_sign_in_at
FROM auth.users au
WHERE au.email IS NOT NULL
  AND au.deleted_at IS NULL
ON CONFLICT ("id") DO UPDATE SET
  "name" = EXCLUDED."name",
  "email" = EXCLUDED."email",
  "emailVerified" = EXCLUDED."emailVerified",
  "image" = EXCLUDED."image",
  "updatedAt" = EXCLUDED."updatedAt",
  "userMetadata" = EXCLUDED."userMetadata",
  "appMetadata" = EXCLUDED."appMetadata",
  "invitedAt" = EXCLUDED."invitedAt",
  "lastSignInAt" = EXCLUDED."lastSignInAt";

INSERT INTO better_auth."account" (
  "id",
  "accountId",
  "providerId",
  "userId",
  "password",
  "createdAt",
  "updatedAt"
)
SELECT
  gen_random_uuid(),
  au.id::text,
  'credential',
  au.id,
  au.encrypted_password,
  au.created_at,
  COALESCE(au.updated_at, au.created_at, now())
FROM auth.users au
WHERE au.email IS NOT NULL
  AND au.deleted_at IS NULL
  AND au.encrypted_password IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM better_auth."account" ba
    WHERE ba."userId" = au.id
      AND ba."providerId" = 'credential'
      AND ba."accountId" = au.id::text
  );

INSERT INTO better_auth."account" (
  "id",
  "accountId",
  "providerId",
  "userId",
  "password",
  "createdAt",
  "updatedAt"
)
SELECT
  gen_random_uuid(),
  COALESCE(ai.identity_data ->> 'sub', ai.provider_id, ai.id::text),
  ai.provider,
  ai.user_id,
  NULL,
  COALESCE(ai.created_at, au.created_at, now()),
  COALESCE(ai.updated_at, au.updated_at, ai.created_at, au.created_at, now())
FROM auth.identities ai
JOIN auth.users au ON au.id = ai.user_id
JOIN better_auth."user" bu ON bu.id = ai.user_id
WHERE ai.provider <> 'email'
  AND NOT EXISTS (
    SELECT 1
    FROM better_auth."account" ba
    WHERE ba."userId" = ai.user_id
      AND ba."providerId" = ai.provider
      AND ba."accountId" = COALESCE(ai.identity_data ->> 'sub', ai.provider_id, ai.id::text)
  );

INSERT INTO public."user" (id)
SELECT bu.id
FROM better_auth."user" bu
ON CONFLICT (id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.current_jwt_claims()
RETURNS JSONB
LANGUAGE SQL
STABLE
AS $$
  SELECT COALESCE(NULLIF(current_setting('request.jwt.claims', true), '')::jsonb, '{}'::jsonb);
$$;

CREATE OR REPLACE FUNCTION public.current_user_id()
RETURNS UUID
LANGUAGE SQL
STABLE
AS $$
  SELECT NULLIF(public.current_jwt_claims() ->> 'sub', '')::uuid;
$$;

REVOKE ALL ON FUNCTION public.current_jwt_claims() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.current_user_id() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.current_jwt_claims() TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.current_user_id() TO anon, authenticated;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

ALTER TABLE public."user"
  DROP CONSTRAINT IF EXISTS user_id_fkey;

ALTER TABLE public."user"
  ADD CONSTRAINT user_id_fkey
  FOREIGN KEY (id)
  REFERENCES better_auth."user"(id)
  ON DELETE CASCADE;

ALTER TABLE public.course_evaluations
  DROP CONSTRAINT IF EXISTS course_evaluations_moderated_by_fkey;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'course_evaluations' AND column_name = 'moderated_by'
  ) THEN
    EXECUTE 'ALTER TABLE public.course_evaluations
      ADD CONSTRAINT course_evaluations_moderated_by_fkey
      FOREIGN KEY (moderated_by)
      REFERENCES better_auth."user"(id)
      ON DELETE SET NULL';
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_role ur
    WHERE ur.user_id = (SELECT public.current_user_id())
      AND ur.role = 'admin'::public.app_role
  );
$$;

REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

DROP POLICY IF EXISTS "Users can view own profile" ON public."user";
CREATE POLICY "Users can view own profile"
ON public."user"
FOR SELECT
TO authenticated
USING ((SELECT public.current_user_id()) = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public."user";
CREATE POLICY "Users can update own profile"
ON public."user"
FOR UPDATE
TO authenticated
USING ((SELECT public.current_user_id()) = id)
WITH CHECK ((SELECT public.current_user_id()) = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public."user";
CREATE POLICY "Users can insert own profile"
ON public."user"
FOR INSERT
TO authenticated
WITH CHECK ((SELECT public.current_user_id()) = id);

DROP POLICY IF EXISTS "Users can view own study plans" ON public.user_study_plan;
CREATE POLICY "Users can view own study plans"
ON public.user_study_plan
FOR SELECT
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can insert own study plans" ON public.user_study_plan;
CREATE POLICY "Users can insert own study plans"
ON public.user_study_plan
FOR INSERT
TO authenticated
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can update own study plans" ON public.user_study_plan;
CREATE POLICY "Users can update own study plans"
ON public.user_study_plan
FOR UPDATE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id)
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can delete own study plans" ON public.user_study_plan;
CREATE POLICY "Users can delete own study plans"
ON public.user_study_plan
FOR DELETE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can view own course records" ON public.student_course_record;
CREATE POLICY "Users can view own course records"
ON public.student_course_record
FOR SELECT
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can insert own course records" ON public.student_course_record;
CREATE POLICY "Users can insert own course records"
ON public.student_course_record
FOR INSERT
TO authenticated
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can update own course records" ON public.student_course_record;
CREATE POLICY "Users can update own course records"
ON public.student_course_record
FOR UPDATE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id)
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can delete own course records" ON public.student_course_record;
CREATE POLICY "Users can delete own course records"
ON public.student_course_record
FOR DELETE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can view own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can view own saved schedules"
ON public.saved_schedule
FOR SELECT
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can insert own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can insert own saved schedules"
ON public.saved_schedule
FOR INSERT
TO authenticated
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can update own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can update own saved schedules"
ON public.saved_schedule
FOR UPDATE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id)
WITH CHECK ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can delete own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can delete own saved schedules"
ON public.saved_schedule
FOR DELETE
TO authenticated
USING ((SELECT public.current_user_id()) = user_id);

DROP POLICY IF EXISTS "Users can view own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can view own schedule items"
ON public.saved_schedule_item
FOR SELECT
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id FROM public.saved_schedule ss
    WHERE ss.user_id = (SELECT public.current_user_id())
  )
);

DROP POLICY IF EXISTS "Users can insert own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can insert own schedule items"
ON public.saved_schedule_item
FOR INSERT
TO authenticated
WITH CHECK (
  saved_schedule_id IN (
    SELECT ss.id FROM public.saved_schedule ss
    WHERE ss.user_id = (SELECT public.current_user_id())
  )
);

DROP POLICY IF EXISTS "Users can update own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can update own schedule items"
ON public.saved_schedule_item
FOR UPDATE
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id FROM public.saved_schedule ss
    WHERE ss.user_id = (SELECT public.current_user_id())
  )
)
WITH CHECK (
  saved_schedule_id IN (
    SELECT ss.id FROM public.saved_schedule ss
    WHERE ss.user_id = (SELECT public.current_user_id())
  )
);

DROP POLICY IF EXISTS "Users can delete own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can delete own schedule items"
ON public.saved_schedule_item
FOR DELETE
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id FROM public.saved_schedule ss
    WHERE ss.user_id = (SELECT public.current_user_id())
  )
);

DROP POLICY IF EXISTS "Users can view own role assignments" ON public.user_role;
CREATE POLICY "Users can view own role assignments"
ON public.user_role
FOR SELECT
TO authenticated
USING (user_id = (SELECT public.current_user_id()) OR public.is_admin());

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_normalized_status public.student_course_status;
  v_next_attempt_number INTEGER;
  v_inserted_id BIGINT;
BEGIN
  IF public.current_user_id() IS NULL OR public.current_user_id() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF v_normalized_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  SELECT COALESCE(MAX(scr.attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id, study_plan_id, course_id, academic_term_id,
    attempt_number, status, grade, approved, recorded_at
  )
  VALUES (
    p_user_id, p_study_plan_id, p_course_id, p_academic_term_id,
    v_next_attempt_number, v_normalized_status, p_grade,
    (v_normalized_status = 'APPROVED'), NOW()
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.save_user_schedule(
  p_name TEXT,
  p_academic_term_id BIGINT,
  p_group_lookups JSONB
)
RETURNS TABLE (
  id BIGINT,
  name TEXT,
  academic_term_id BIGINT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := public.current_user_id();
  v_schedule_id BIGINT;
  v_inserted_count INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'No autenticado' USING ERRCODE = '28000';
  END IF;

  IF p_name IS NULL OR trim(p_name) = '' THEN
    RAISE EXCEPTION 'El nombre del horario es requerido' USING ERRCODE = '22023';
  END IF;

  IF p_group_lookups IS NULL OR jsonb_typeof(p_group_lookups) <> 'array' THEN
    RAISE EXCEPTION 'Los grupos seleccionados son invalidos' USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.saved_schedule (user_id, name, academic_term_id)
  VALUES (v_user_id, trim(p_name), p_academic_term_id)
  RETURNING saved_schedule.id INTO v_schedule_id;

  WITH requested_groups AS (
    SELECT DISTINCT
      upper(trim(item->>'courseCode')) AS course_code,
      trim(item->>'groupCode') AS group_code,
      CASE
        WHEN item ? 'campusId' AND item->>'campusId' ~ '^\d+$'
          THEN (item->>'campusId')::BIGINT
        ELSE NULL
      END AS campus_id
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'courseCode'
      AND item ? 'groupCode'
      AND trim(item->>'courseCode') <> ''
      AND trim(item->>'groupCode') <> ''
  ), inserted_items AS (
    INSERT INTO public.saved_schedule_item (saved_schedule_id, course_offering_group_id)
    SELECT DISTINCT v_schedule_id, cog.id
    FROM requested_groups rg
    JOIN public.course c ON c.code = rg.course_code
    JOIN public.course_offering co
      ON co.course_id = c.id
     AND co.academic_term_id = p_academic_term_id
     AND co.is_active = true
     AND (rg.campus_id IS NULL OR co.campus_id = rg.campus_id)
    JOIN public.course_offering_group cog
      ON cog.course_offering_id = co.id
     AND cog.group_code = rg.group_code
     AND cog.is_active = true
    RETURNING 1
  )
  SELECT count(*) INTO v_inserted_count FROM inserted_items;

  IF v_inserted_count = 0 THEN
    DELETE FROM public.saved_schedule WHERE saved_schedule.id = v_schedule_id;
    RAISE EXCEPTION 'No se encontraron grupos validos para guardar' USING ERRCODE = '22023';
  END IF;

  RETURN QUERY
  SELECT ss.id, ss.name, ss.academic_term_id, ss.created_at, ss.updated_at
  FROM public.saved_schedule ss
  WHERE ss.id = v_schedule_id
    AND ss.user_id = v_user_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_student_course_attempt(
  p_attempt_id BIGINT,
  p_academic_term_id BIGINT,
  p_grade NUMERIC(5,2) DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID;
  v_status public.student_course_status;
BEGIN
  SELECT scr.user_id, scr.status
  INTO v_user_id, v_status
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Attempt not found';
  END IF;

  IF public.current_user_id() IS NULL OR public.current_user_id() <> v_user_id THEN
    RAISE EXCEPTION 'Not authorized to update this attempt';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF v_status IN ('IN_PROGRESS', 'WITHDRAWN') THEN
    p_grade := NULL;
  END IF;

  UPDATE public.student_course_record
  SET academic_term_id = p_academic_term_id,
      grade = p_grade,
      approved = (status = 'APPROVED')
  WHERE id = p_attempt_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_user_saved_schedule_group_lookups(
  p_saved_schedule_id BIGINT
)
RETURNS TABLE (course_code TEXT, campus_id BIGINT, group_code TEXT)
LANGUAGE SQL
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT c.code AS course_code, co.campus_id, cog.group_code
  FROM public.saved_schedule ss
  JOIN public.saved_schedule_item ssi ON ssi.saved_schedule_id = ss.id
  JOIN public.course_offering_group cog ON cog.id = ssi.course_offering_group_id
  JOIN public.course_offering co ON co.id = cog.course_offering_id
  JOIN public.course c ON c.id = co.course_id
  WHERE ss.id = p_saved_schedule_id
    AND ss.user_id = public.current_user_id()
  ORDER BY c.code, co.campus_id, cog.group_code;
$$;

CREATE OR REPLACE FUNCTION public.moderate_professor_review(
  p_review_id BIGINT,
  p_new_status public.professor_review_status,
  p_moderation_note TEXT DEFAULT NULL
)
RETURNS public.professor_review
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  updated_row public.professor_review;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF p_new_status NOT IN ('approved', 'rejected') THEN
    RAISE EXCEPTION 'Invalid moderation status: %', p_new_status;
  END IF;

  UPDATE public.professor_review pr
  SET
    status = p_new_status,
    moderation_note = p_moderation_note,
    reviewed_by = (SELECT public.current_user_id()),
    reviewed_at = NOW()
  WHERE pr.id = p_review_id
  RETURNING pr.* INTO updated_row;

  IF updated_row.id IS NULL THEN
    RAISE EXCEPTION 'Review not found: %', p_review_id;
  END IF;

  RETURN updated_row;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_suggested_academic_term(
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
DECLARE
  v_modality_id BIGINT;
  v_periods_per_year INTEGER;
  v_current_year INTEGER := EXTRACT(YEAR FROM CURRENT_DATE);
  v_suggested_term_id BIGINT;
BEGIN
  SELECT sp.academic_modality_id, am.periods_per_year
  INTO v_modality_id, v_periods_per_year
  FROM public.study_plan sp
  JOIN public.academic_modality am ON sp.academic_modality_id = am.id
  WHERE sp.id = COALESCE(p_study_plan_id, (
    SELECT usp.study_plan_id
    FROM public.user_study_plan usp
    WHERE usp.user_id = public.current_user_id() AND usp.is_active = true
    LIMIT 1
  ));

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  IF v_periods_per_year = 2 THEN
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year = v_current_year
      AND period_number = 1
    ORDER BY starts_on ASC
    LIMIT 1;

    IF v_suggested_term_id IS NULL THEN
      SELECT id INTO v_suggested_term_id
      FROM public.academic_term
      WHERE academic_modality_id = v_modality_id
        AND year = v_current_year
        AND period_number = 2
      ORDER BY starts_on ASC
      LIMIT 1;
    END IF;
  ELSE
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year = v_current_year
    ORDER BY period_number ASC
    LIMIT 1;
  END IF;

  RETURN v_suggested_term_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_schedule_user_context()
RETURNS TABLE (
  user_id UUID,
  university_id BIGINT,
  campus_id BIGINT,
  academic_unit_id BIGINT,
  study_plan_id BIGINT,
  university_name TEXT,
  campus_name TEXT,
  academic_unit_name TEXT,
  study_plan_name TEXT
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id AS user_id,
    ctx.university_id,
    usp.campus_id,
    ctx.academic_unit_id,
    ctx.study_plan_id,
    COALESCE(univ.name, ''::TEXT) AS university_name,
    COALESCE(c.name, ''::TEXT) AS campus_name,
    COALESCE(au.name, ''::TEXT) AS academic_unit_name,
    COALESCE(sp.name, ''::TEXT) AS study_plan_name
  FROM public."user" u
  LEFT JOIN public.user_study_plan usp ON u.id = usp.user_id AND usp.is_active = true
  LEFT JOIN LATERAL public.derive_user_context_from_study_plan(usp.study_plan_id, usp.campus_id) ctx ON true
  LEFT JOIN public.university univ ON ctx.university_id = univ.id
  LEFT JOIN public.campus c ON usp.campus_id = c.id
  LEFT JOIN public.academic_unit au ON ctx.academic_unit_id = au.id
  LEFT JOIN public.study_plan sp ON ctx.study_plan_id = sp.id
  WHERE u.id = public.current_user_id();
END;
$$;

COMMENT ON TABLE public."user" IS 'App user profile linked to Better Auth better_auth."user" and storing app-specific user data.';
COMMENT ON COLUMN public."user".id IS 'Primary key and foreign key to Better Auth user id.';

COMMIT;
