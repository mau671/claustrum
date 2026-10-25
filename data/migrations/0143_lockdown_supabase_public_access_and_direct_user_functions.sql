-- 0143_lockdown_supabase_public_access_and_direct_user_functions.sql
-- 1. Revoke public/anon/authenticated access to eliminate Supabase PostgREST public exposure
-- 2. Refactor functions to take p_user_id explicitly, removing dependencies on request.jwt.claims and auth.uid()

BEGIN;

-- ============================================================================
-- 1. REVOKE PUBLIC ACCESS FROM ANON AND AUTHENTICATED
-- ============================================================================

DO $$
BEGIN
  -- Revoke schema usage from Supabase HTTP roles
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;
    REVOKE ALL ON ALL ROUTINES IN SCHEMA public FROM anon;
    REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM anon;
    REVOKE USAGE ON SCHEMA public FROM anon;

    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
      REVOKE ALL ON ALL TABLES IN SCHEMA better_auth FROM anon;
      REVOKE ALL ON ALL ROUTINES IN SCHEMA better_auth FROM anon;
      REVOKE ALL ON ALL SEQUENCES IN SCHEMA better_auth FROM anon;
      REVOKE USAGE ON SCHEMA better_auth FROM anon;
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    REVOKE ALL ON ALL TABLES IN SCHEMA public FROM authenticated;
    REVOKE ALL ON ALL ROUTINES IN SCHEMA public FROM authenticated;
    REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM authenticated;
    REVOKE USAGE ON SCHEMA public FROM authenticated;

    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
      REVOKE ALL ON ALL TABLES IN SCHEMA better_auth FROM authenticated;
      REVOKE ALL ON ALL ROUTINES IN SCHEMA better_auth FROM authenticated;
      REVOKE ALL ON ALL SEQUENCES IN SCHEMA better_auth FROM authenticated;
      REVOKE USAGE ON SCHEMA better_auth FROM authenticated;
    END IF;
  END IF;
END $$;

-- Prevent future tables from being exposed to anon/authenticated
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON ROUTINES FROM anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM anon, authenticated;

-- Ensure hyperdrive_user retains full execution permissions
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT USAGE ON SCHEMA public TO hyperdrive_user;
    GRANT ALL ON ALL TABLES IN SCHEMA public TO hyperdrive_user;
    GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hyperdrive_user;
    GRANT ALL ON ALL ROUTINES IN SCHEMA public TO hyperdrive_user;

    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'better_auth') THEN
      GRANT USAGE ON SCHEMA better_auth TO hyperdrive_user;
      GRANT ALL ON ALL TABLES IN SCHEMA better_auth TO hyperdrive_user;
      GRANT ALL ON ALL SEQUENCES IN SCHEMA better_auth TO hyperdrive_user;
      GRANT ALL ON ALL ROUTINES IN SCHEMA better_auth TO hyperdrive_user;
    END IF;
  END IF;
END $$;

-- ============================================================================
-- 2. REFACTOR get_professor_reviews_public TO ACCEPT p_user_id DIRECTLY
-- ============================================================================

DROP FUNCTION IF EXISTS public.get_professor_reviews_public(TEXT, INTEGER, INTEGER);
DROP FUNCTION IF EXISTS public.get_professor_reviews_public(TEXT, INTEGER, INTEGER, UUID);

CREATE OR REPLACE FUNCTION public.get_professor_reviews_public(
  p_professor_id TEXT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0,
  p_user_id UUID DEFAULT NULL
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id TEXT,
  courses JSONB,
  comment TEXT,
  ease_score NUMERIC,
  quality_score NUMERIC,
  clarity_score NUMERIC,
  fairness_score NUMERIC,
  attendance_required BOOLEAN,
  grade_received TEXT,
  engagement_level SMALLINT,
  tags TEXT[],
  status public.professor_review_status,
  created_at TIMESTAMPTZ,
  like_count BIGINT,
  dislike_count BIGINT,
  my_reaction TEXT,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH rows AS (
    SELECT
      pr.id AS review_id,
      pr.professor_id::text AS professor_id,
      COALESCE(course_list.courses, '[]'::jsonb) AS courses,
      pr.comment,
      pr.ease_score,
      pr.quality_score,
      pr.clarity_score,
      pr.fairness_score,
      pr.attendance_required,
      pr.grade_received,
      pr.engagement_level,
      pr.tags,
      pr.status,
      pr.created_at
    FROM public.professor_review pr
    LEFT JOIN LATERAL (
      SELECT jsonb_agg(
        jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
        ORDER BY c.code, c.name, c.id
      ) AS courses
      FROM public.professor_review_course prc
      JOIN public.course c ON c.id = prc.course_id
      WHERE prc.review_id = pr.id
    ) course_list ON true
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  reaction_counts AS (
    SELECT
      prr.review_id,
      COUNT(*) FILTER (WHERE prr.reaction = 'like')::BIGINT AS like_count,
      COUNT(*) FILTER (WHERE prr.reaction = 'dislike')::BIGINT AS dislike_count
    FROM public.professor_review_reaction prr
    JOIN rows r ON r.review_id = prr.review_id
    GROUP BY prr.review_id
  ),
  counted AS (
    SELECT COUNT(*)::BIGINT AS total_count FROM rows
  )
  SELECT
    r.review_id,
    r.professor_id,
    r.courses,
    r.comment,
    r.ease_score,
    r.quality_score,
    r.clarity_score,
    r.fairness_score,
    r.attendance_required,
    r.grade_received,
    r.engagement_level,
    r.tags,
    r.status,
    r.created_at,
    COALESCE(rc.like_count, 0)::BIGINT AS like_count,
    COALESCE(rc.dislike_count, 0)::BIGINT AS dislike_count,
    mr.reaction AS my_reaction,
    c.total_count
  FROM rows r
  CROSS JOIN counted c
  LEFT JOIN reaction_counts rc ON rc.review_id = r.review_id
  LEFT JOIN public.professor_review_reaction mr
    ON mr.review_id = r.review_id
   AND p_user_id IS NOT NULL
   AND mr.user_id = p_user_id
  ORDER BY r.created_at DESC, r.review_id DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

-- ============================================================================
-- 3. REFACTOR save_user_schedule TO ACCEPT p_user_id DIRECTLY
-- ============================================================================

DROP FUNCTION IF EXISTS public.save_user_schedule(TEXT, BIGINT, JSONB);
DROP FUNCTION IF EXISTS public.save_user_schedule(UUID, TEXT, BIGINT, JSONB);

CREATE OR REPLACE FUNCTION public.save_user_schedule(
  p_user_id UUID,
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
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_schedule_id BIGINT;
BEGIN
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required' USING ERRCODE = '28000';
  END IF;

  IF p_name IS NULL OR trim(p_name) = '' THEN
    RAISE EXCEPTION 'El nombre del horario es requerido' USING ERRCODE = '22023';
  END IF;

  IF p_group_lookups IS NULL OR jsonb_typeof(p_group_lookups) <> 'array' THEN
    RAISE EXCEPTION 'Los grupos seleccionados son invalidos' USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.saved_schedule (user_id, name, academic_term_id)
  VALUES (p_user_id, trim(p_name), p_academic_term_id)
  RETURNING saved_schedule.id INTO v_schedule_id;

  WITH requested_groups AS (
    SELECT DISTINCT
      (item->>'offeringId')::BIGINT AS offering_id,
      item->>'groupCode' AS group_code
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'offeringId'
      AND item ? 'groupCode'
      AND item->>'offeringId' ~ '^\d+$'
      AND trim(item->>'groupCode') <> ''
  )
  INSERT INTO public.saved_schedule_item (
    saved_schedule_id,
    course_offering_group_id
  )
  SELECT DISTINCT
    v_schedule_id,
    cog.id
  FROM requested_groups rg
  JOIN public.course_offering_group cog
    ON cog.course_offering_id = rg.offering_id
   AND cog.group_code = rg.group_code
   AND (cog.is_active IS NULL OR cog.is_active = true)
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.saved_schedule_item ssi
    WHERE ssi.saved_schedule_id = v_schedule_id
      AND ssi.course_offering_group_id = cog.id
  );

  RETURN QUERY
  SELECT
    s.id,
    s.name,
    s.academic_term_id,
    s.created_at,
    s.updated_at
  FROM public.saved_schedule s
  WHERE s.id = v_schedule_id;
END;
$$;

-- ============================================================================
-- 4. REFACTOR insert_student_course_attempt TO TRUST p_user_id
-- ============================================================================

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_equivalent_course_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_normalized_status public.student_course_status;
  v_next_attempt_number INTEGER;
  v_inserted_id BIGINT;
BEGIN
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required';
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

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required for all attempts';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id,
    study_plan_id,
    course_id,
    attempt_number,
    status,
    grade,
    academic_term_id,
    equivalent_course_id,
    approved
  ) VALUES (
    p_user_id,
    p_study_plan_id,
    p_course_id,
    v_next_attempt_number,
    v_normalized_status,
    p_grade,
    p_academic_term_id,
    p_equivalent_course_id,
    (v_normalized_status = 'APPROVED')
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

-- ============================================================================
-- 5. REFACTOR update_student_course_attempt TO VALIDATE USER OWNERSHIP DIRECTLY
-- ============================================================================

DROP FUNCTION IF EXISTS public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2), TEXT, BIGINT);
DROP FUNCTION IF EXISTS public.update_student_course_attempt(UUID, BIGINT, BIGINT, NUMERIC(5,2), TEXT, BIGINT);

CREATE OR REPLACE FUNCTION public.update_student_course_attempt(
  p_user_id UUID,
  p_attempt_id BIGINT,
  p_academic_term_id BIGINT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_status TEXT DEFAULT NULL,
  p_equivalent_course_id BIGINT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_current_status public.student_course_status;
  v_new_status public.student_course_status;
BEGIN
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required';
  END IF;

  SELECT scr.status
  INTO v_current_status
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id
    AND scr.user_id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Attempt not found or not owned by user';
  END IF;

  IF p_status IS NOT NULL THEN
    v_new_status := UPPER(p_status)::public.student_course_status;
  ELSE
    v_new_status := v_current_status;
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_new_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  UPDATE public.student_course_record
  SET
    academic_term_id = p_academic_term_id,
    grade = p_grade,
    status = v_new_status,
    equivalent_course_id = p_equivalent_course_id,
    approved = (v_new_status = 'APPROVED')
  WHERE id = p_attempt_id
    AND user_id = p_user_id;
END;
$$;

-- ============================================================================
-- 6. REFACTOR delete_student_course_attempt TO VALIDATE USER OWNERSHIP DIRECTLY
-- ============================================================================

DROP FUNCTION IF EXISTS public.delete_student_course_attempt(BIGINT);
DROP FUNCTION IF EXISTS public.delete_student_course_attempt(UUID, BIGINT);

CREATE OR REPLACE FUNCTION public.delete_student_course_attempt(
  p_user_id UUID,
  p_attempt_id BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_study_plan_id BIGINT;
  v_course_id BIGINT;
BEGIN
  IF p_user_id IS NULL THEN
    RAISE EXCEPTION 'User ID is required';
  END IF;

  SELECT scr.study_plan_id, scr.course_id
  INTO v_study_plan_id, v_course_id
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id
    AND scr.user_id = p_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Attempt not found or not owned by user';
  END IF;

  DELETE FROM public.student_course_record
  WHERE id = p_attempt_id
    AND user_id = p_user_id;

  -- Recalculate attempt_number for the remaining attempts
  WITH ranked_attempts AS (
    SELECT
      id,
      ROW_NUMBER() OVER (
        PARTITION BY user_id, study_plan_id, course_id
        ORDER BY recorded_at ASC NULLS LAST, id ASC
      ) AS rn
    FROM public.student_course_record
    WHERE user_id = p_user_id
      AND study_plan_id = v_study_plan_id
      AND course_id = v_course_id
  )
  UPDATE public.student_course_record scr
  SET attempt_number = ra.rn
  FROM ranked_attempts ra
  WHERE scr.id = ra.id;
END;
$$;

COMMIT;
