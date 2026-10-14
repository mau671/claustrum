-- functions.sql
-- All database functions for user profile, dropdown loading, and schedule.
-- Consolidates migrations 0004, 0005, and 0006.
--
-- IMPORTANT (SECURITY / SUPABASE LINTER):
-- - DO NOT use SECURITY DEFINER views. Supabase DB linter flags SECURITY DEFINER views because they can
--   execute with the view owner's privileges and bypass RLS expectations.
-- - These views are (and must remain) SECURITY INVOKER / default behavior.
-- - Underlying catalog tables are already RLS-enabled and readable (anon+authenticated) via 0002_rls.sql.
--
-- About hardening:
-- - We explicitly set helper functions to SECURITY INVOKER to avoid accidental privilege elevation.
-- - We also attempt to set views as security_invoker (Postgres 15+). If your Postgres version doesn't
--   support this, the views remain normal invoker views by default.

BEGIN;

-- ============================================================================
-- VIEW: universities (NO SECURITY DEFINER)
-- ============================================================================
-- Returns active universities that have at least one active campus.
DROP VIEW IF EXISTS public.v_universities;
CREATE VIEW public.v_universities
WITH (security_invoker = true)
AS
SELECT DISTINCT u.id, u.name, u.short_name
FROM public.university u
WHERE u.id IN (SELECT DISTINCT university_id FROM public.campus)
ORDER BY u.name;

COMMENT ON VIEW public.v_universities IS 'Universities that have campuses.';

-- ============================================================================
-- VIEW: campuses_by_university (NO SECURITY DEFINER)
-- ============================================================================
-- Returns campuses.
DROP VIEW IF EXISTS public.v_campuses_by_university;
CREATE VIEW public.v_campuses_by_university
WITH (security_invoker = true)
AS
SELECT c.id, c.university_id, c.code, c.name
FROM public.campus c
ORDER BY c.name;

COMMENT ON VIEW public.v_campuses_by_university IS 'Campuses, filterable by university_id.';

-- ============================================================================
-- VIEW: academic_units_with_plans (NO SECURITY DEFINER)
-- ============================================================================
-- Returns academic units (schools) that have study plans.
-- Used to populate school dropdown - only shows schools that actually offer plans.
DROP VIEW IF EXISTS public.v_academic_units_with_plans;
CREATE VIEW public.v_academic_units_with_plans
WITH (security_invoker = true)
AS
SELECT DISTINCT au.id, au.university_id, au.code, au.name
FROM public.academic_unit au
WHERE au.id IN (
  SELECT DISTINCT academic_unit_id
  FROM public.study_plan
)
ORDER BY au.name;

COMMENT ON VIEW public.v_academic_units_with_plans IS 'Academic units (schools) that have study plans.';

-- ============================================================================
-- VIEW: academic_units_for_campus
-- ============================================================================
-- Returns academic units (schools) available at campuses.
DROP VIEW IF EXISTS public.v_academic_units_for_campus;
CREATE VIEW public.v_academic_units_for_campus
WITH (security_invoker = true)
AS
SELECT DISTINCT au.id, au.code, au.name
FROM public.academic_unit au
WHERE au.id IN (
  SELECT DISTINCT academic_unit_id
  FROM public.academic_unit_campus
  WHERE campus_id IN (SELECT id FROM public.campus)
)
ORDER BY au.name;

COMMENT ON VIEW public.v_academic_units_for_campus IS 'Academic units available at campuses.';

-- ============================================================================
-- VIEW: study_plans_for_academic_unit (NO SECURITY DEFINER)
-- ============================================================================
-- Returns study plans (Bachillerato, Licenciatura, etc.) for academic units.
DROP VIEW IF EXISTS public.v_study_plans_for_academic_unit;
CREATE VIEW public.v_study_plans_for_academic_unit
WITH (security_invoker = true)
AS
SELECT sp.id, sp.academic_unit_id, sp.external_plan_id, sp.name, sp.academic_degree,
       am.name AS modality_name
FROM public.study_plan sp
JOIN public.academic_modality am ON sp.academic_modality_id = am.id
ORDER BY sp.name;

COMMENT ON VIEW public.v_study_plans_for_academic_unit IS 'Study plans (degree variants) for academic units with modality info.';

-- ============================================================================
-- VIEW: study_plans_by_campus
-- ============================================================================
-- Returns study plans valid at campuses.
DROP VIEW IF EXISTS public.v_study_plans_by_campus;
CREATE VIEW public.v_study_plans_by_campus
WITH (security_invoker = true)
AS
SELECT DISTINCT sp.id, sp.academic_unit_id, sp.external_plan_id, sp.name, sp.academic_degree
FROM public.study_plan sp
WHERE sp.academic_unit_id IN (
  SELECT DISTINCT academic_unit_id
  FROM public.academic_unit_campus
  WHERE campus_id IN (SELECT id FROM public.campus)
)
ORDER BY sp.name;

COMMENT ON VIEW public.v_study_plans_by_campus IS 'Study plans available at campuses.';

-- ============================================================================
-- FUNCTION: get_campuses_for_university (invoker)
-- ============================================================================
-- Returns campuses (AL, CA, LM, SC, SJ) for a specific university.
CREATE OR REPLACE FUNCTION public.get_campuses_for_university(p_university_id BIGINT)
RETURNS TABLE (id BIGINT, university_id BIGINT, code TEXT, name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT c.id, c.university_id, c.code, c.name
  FROM public.campus c
  WHERE c.university_id = p_university_id
    AND c.code = ANY(ARRAY['AL', 'CA', 'LM', 'SC', 'SJ']::TEXT[])
  ORDER BY c.name;
END;
$$;

COMMENT ON FUNCTION public.get_campuses_for_university IS 'Returns campuses (AL, CA, LM, SC, SJ) for a specific university.';

-- ============================================================================
-- FUNCTION: get_academic_units_for_campus (invoker)
-- ============================================================================
-- Returns academic units available at a specific campus.
CREATE OR REPLACE FUNCTION public.get_academic_units_for_campus(p_campus_id BIGINT)
RETURNS TABLE (id BIGINT, code TEXT, name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT au.id, au.code, au.name
  FROM public.v_academic_units_with_plans au
  WHERE au.id IN (
    SELECT academic_unit_id
    FROM public.academic_unit_campus
    WHERE campus_id = p_campus_id
  )
  ORDER BY au.name;
END;
$$;

COMMENT ON FUNCTION public.get_academic_units_for_campus IS 'Returns academic units with study plans available at a specific campus.';

-- ============================================================================
-- FUNCTION: get_academic_units_for_university (invoker)
-- ============================================================================
-- Returns academic units with plans for a specific university.
CREATE OR REPLACE FUNCTION public.get_academic_units_for_university(p_university_id BIGINT)
RETURNS TABLE (id BIGINT, university_id BIGINT, code TEXT, name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT au.id, au.university_id, au.code, au.name
  FROM public.v_academic_units_with_plans au
  WHERE au.university_id = p_university_id
  ORDER BY au.name;
END;
$$;

COMMENT ON FUNCTION public.get_academic_units_for_university IS 'Returns academic units with plans for a specific university.';

-- ============================================================================
-- FUNCTION: get_study_plans_for_academic_unit (invoker)
-- ============================================================================
-- Returns study plans for a specific academic unit, ordered by newest first (higher external_plan_id = newer).
-- Format: "external_plan_id - name"
CREATE OR REPLACE FUNCTION public.get_study_plans_for_academic_unit(p_academic_unit_id BIGINT)
RETURNS TABLE (id BIGINT, academic_unit_id BIGINT, external_plan_id INTEGER, name TEXT, academic_degree TEXT, modality_name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    sp.id, 
    sp.academic_unit_id, 
    sp.external_plan_id, 
    sp.external_plan_id::TEXT || ' - ' || sp.name AS name, 
    sp.academic_degree,
    am.name AS modality_name
  FROM public.study_plan sp
  LEFT JOIN public.academic_modality am ON sp.academic_modality_id = am.id
  WHERE sp.academic_unit_id = p_academic_unit_id
  ORDER BY sp.external_plan_id DESC;
END;
$$;

COMMENT ON FUNCTION public.get_study_plans_for_academic_unit IS 'Returns study plans for a specific academic unit, ordered by newest first.';

-- ============================================================================
-- FUNCTION: get_study_plans_for_campus_and_academic_unit (invoker)
-- ============================================================================
-- Returns study plans for a specific academic unit and campus.
-- Only returns plans that are valid for the selected campus or have no campus restriction.
-- This filters out old plans that were created before certain campuses existed.
CREATE OR REPLACE FUNCTION public.get_study_plans_for_campus_and_academic_unit(
  p_academic_unit_id BIGINT,
  p_campus_id BIGINT
)
RETURNS TABLE (id BIGINT, academic_unit_id BIGINT, external_plan_id INTEGER, name TEXT, academic_degree TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    sp.id,
    sp.academic_unit_id,
    sp.external_plan_id,
    sp.external_plan_id::TEXT || ' - ' || sp.name AS name,
    sp.academic_degree
  FROM public.study_plan sp
  WHERE sp.academic_unit_id = p_academic_unit_id
    AND (
      sp.id IN (
        SELECT study_plan_id
        FROM public.study_plan_campus
        WHERE campus_id = p_campus_id
      )
      OR NOT EXISTS (
        SELECT 1
        FROM public.study_plan_campus
        WHERE study_plan_id = sp.id
      )
    )
  ORDER BY sp.external_plan_id DESC;
END;
$$;

COMMENT ON FUNCTION public.get_study_plans_for_campus_and_academic_unit IS 'Returns study plans for a specific academic unit and campus, filtering by campus availability.';

-- ============================================================================
-- FUNCTION: derive_user_context_from_study_plan (invoker)
-- ============================================================================
-- Inverse derivation: from user_study_plan, derive all related entities.
-- Returns: university_id, campus_id, academic_unit_id, study_plan_id.
CREATE OR REPLACE FUNCTION public.derive_user_context_from_study_plan(p_study_plan_id BIGINT, p_campus_id BIGINT)
RETURNS TABLE (
  university_id BIGINT,
  campus_id BIGINT,
  academic_unit_id BIGINT,
  study_plan_id BIGINT
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    univ.id AS university_id,
    p_campus_id AS campus_id,
    sp.academic_unit_id,
    sp.id AS study_plan_id
  FROM public.study_plan sp
  JOIN public.campus c ON c.id = p_campus_id
  JOIN public.university univ ON c.university_id = univ.id
  WHERE sp.id = p_study_plan_id;
END;
$$;

COMMENT ON FUNCTION public.derive_user_context_from_study_plan IS 'Derives university, academic_unit from study plan for UI population.';

-- ============================================================================
-- FUNCTION: get_user_profile_with_context (invoker)
-- ============================================================================
-- Returns complete user profile with derived context from their study plan.
-- Used when user already has data configured.
CREATE OR REPLACE FUNCTION public.get_user_profile_with_context(p_user_id UUID)
RETURNS TABLE (
  user_id UUID,
  carnet TEXT,
  university_id BIGINT,
  university_name TEXT,
  campus_id BIGINT,
  campus_name TEXT,
  academic_unit_id BIGINT,
  academic_unit_name TEXT,
  study_plan_id BIGINT,
  study_plan_name TEXT,
  user_study_plan_id BIGINT,
  entry_year INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id AS user_id,
    u.carnet,
    ctx.university_id,
    univ.name AS university_name,
    ctx.campus_id,
    c.name AS campus_name,
    ctx.academic_unit_id,
    au.name AS academic_unit_name,
    ctx.study_plan_id,
    sp.name AS study_plan_name,
    usp.id AS user_study_plan_id,
    usp.entry_year
  FROM public."user" u
  LEFT JOIN public.user_study_plan usp ON u.id = usp.user_id AND usp.is_active = true
  LEFT JOIN LATERAL public.derive_user_context_from_study_plan(
    usp.study_plan_id,
    usp.campus_id
  ) ctx ON true
  LEFT JOIN public.university univ ON ctx.university_id = univ.id
  LEFT JOIN public.campus c ON ctx.campus_id = c.id
  LEFT JOIN public.academic_unit au ON ctx.academic_unit_id = au.id
  LEFT JOIN public.study_plan sp ON ctx.study_plan_id = sp.id
  WHERE u.id = p_user_id;
END;
$$;

COMMENT ON FUNCTION public.get_user_profile_with_context IS 'Returns user profile with derived university/campus/academic_unit context.';

-- ============================================================================
-- FUNCTION: get_study_plan_courses_details (invoker)
-- ============================================================================
-- Returns all courses for a study plan with their details and level info.
CREATE OR REPLACE FUNCTION public.get_study_plan_courses_details(p_study_plan_id BIGINT)
RETURNS TABLE (
  course_id BIGINT,
  level_number INTEGER,
  level_label TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  sort_order INTEGER,
  course_code TEXT,
  course_name TEXT,
  default_credits INTEGER,
  default_weekly_hours INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    splc.course_id,
    spl.level_number,
    spl.level_label,
    splc.credits,
    splc.weekly_hours,
    splc.sort_order,
    c.code AS course_code,
    c.name AS course_name,
    c.default_credits,
    c.default_weekly_hours
  FROM public.study_plan_level_course splc
  JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
  JOIN public.course c ON splc.course_id = c.id
  WHERE spl.study_plan_id = p_study_plan_id
  ORDER BY spl.level_number, splc.sort_order;
END;
$$;

COMMENT ON FUNCTION public.get_study_plan_courses_details IS 'Returns all courses for a study plan with details flattened.';

-- ============================================================================
-- VIEW: v_schedule_courses (NO SECURITY DEFINER)
-- ============================================================================
-- Returns all course offerings with groups, professors, and meetings for a given
-- academic term, campus, and academic unit (from study plan).
-- Used by the Schedule page to display courses and groups for selection.
-- Groups are ordered by group_code.
DROP VIEW IF EXISTS public.v_schedule_courses;
CREATE VIEW public.v_schedule_courses
WITH (security_invoker = true)
AS
SELECT
  co.id AS offering_id,
  co.course_id,
  c.code AS course_code,
  c.name AS course_name,
  co.credits_snapshot,
  co.weekly_hours_snapshot,
  co.course_type,
  co.academic_unit_id,
  au.name AS academic_unit_name,
  co.campus_id,
  co.academic_term_id,
  at.display_name AS term_display_name,
  COALESCE(
    (SELECT json_agg(
      jsonb_build_object(
        'group_id', g.id,
        'group_code', g.group_code,
        'group_type', g.group_type,
        'capacity', g.capacity,
        'professors', (
          SELECT json_agg(p.full_name ORDER BY p.full_name)
          FROM public.professor p
          JOIN public.course_offering_group_professor cogp ON cogp.professor_id = p.id
          WHERE cogp.course_offering_group_id = g.id
        ),
        'meetings', (
          SELECT json_agg(
            jsonb_build_object(
              'weekday', com.weekday,
              'starts_at', com.starts_at::text,
              'ends_at', com.ends_at::text,
              'classroom', com.classroom
            ) ORDER BY com.weekday, com.starts_at
          )
          FROM public.course_offering_meeting com
          WHERE com.course_offering_group_id = g.id
        )
      ) ORDER BY (g.group_code)::INT
    )
    FROM public.course_offering_group g
    WHERE g.course_offering_id = co.id),
    '[]'::json
  ) AS groups
FROM public.course_offering co
JOIN public.course c ON co.course_id = c.id
JOIN public.academic_unit au ON co.academic_unit_id = au.id
JOIN public.academic_term at ON co.academic_term_id = at.id;

COMMENT ON VIEW public.v_schedule_courses IS 'Course offerings with groups, professors, and meetings for schedule display.';

-- ============================================================================
-- FUNCTION: get_schedule_courses (invoker)
-- ============================================================================
-- Returns schedule courses filtered by academic term, campus, and academic unit.
-- Filters out empty offerings (no groups) and orders by course code.
CREATE OR REPLACE FUNCTION public.get_schedule_courses(
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_academic_unit_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  offering_id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  course_type TEXT,
  academic_unit_id BIGINT,
  academic_unit_name TEXT,
  campus_id BIGINT,
  academic_term_id BIGINT,
  term_display_name TEXT,
  groups JSON
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    v.offering_id,
    v.course_id,
    v.course_code,
    v.course_name,
    v.credits_snapshot AS credits,
    v.weekly_hours_snapshot AS weekly_hours,
    v.course_type,
    v.academic_unit_id,
    v.academic_unit_name,
    v.campus_id,
    v.academic_term_id,
    v.term_display_name,
    v.groups
  FROM public.v_schedule_courses v
  WHERE v.academic_term_id = p_academic_term_id
    AND v.campus_id = p_campus_id
    AND (p_academic_unit_id IS NULL OR v.academic_unit_id = p_academic_unit_id)
    AND (v.groups::jsonb <> '[]'::jsonb)
  ORDER BY v.course_code;
END;
$$;

COMMENT ON FUNCTION public.get_schedule_courses IS 'Returns schedule courses filtered by term, campus, and optional academic unit.';

-- ============================================================================
-- FUNCTION: get_active_academic_terms (invoker)
-- ============================================================================
-- Returns academic terms that have course offerings.
-- Used to populate the term selector in the Schedule page.
CREATE OR REPLACE FUNCTION public.get_active_academic_terms()
RETURNS TABLE (
  id BIGINT,
  academic_modality_id BIGINT,
  year INTEGER,
  period_number INTEGER,
  external_key TEXT,
  display_name TEXT,
  starts_on DATE,
  ends_on DATE
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT
    at.id,
    at.academic_modality_id,
    at.year,
    at.period_number,
    at.external_key,
    at.display_name,
    at.starts_on,
    at.ends_on
  FROM public.academic_term at
  JOIN public.course_offering co ON co.academic_term_id = at.id
  ORDER BY at.year DESC, at.period_number DESC;
END;
$$;

COMMENT ON FUNCTION public.get_active_academic_terms IS 'Returns academic terms that have course offerings.';

-- ============================================================================
-- FUNCTION: get_user_schedule_courses (invoker)
-- ============================================================================
-- Returns schedule courses filtered by user's study plan courses.
-- Shows ONE course per course_id with all its groups combined.
-- Groups are ordered by group_code.
-- Optionally includes groups from other campuses.
CREATE OR REPLACE FUNCTION public.get_user_schedule_courses(
  p_user_id UUID,
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_include_other_campuses BOOLEAN DEFAULT false
)
RETURNS TABLE (
  offering_id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  course_type TEXT,
  academic_unit_id BIGINT,
  academic_unit_name TEXT,
  campus_id BIGINT,
  academic_term_id BIGINT,
  term_display_name TEXT,
  groups JSON,
  level_number INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (v.course_code)
    v.offering_id,
    v.course_id,
    v.course_code,
    v.course_name,
    v.credits_snapshot AS credits,
    v.weekly_hours_snapshot AS weekly_hours,
    v.course_type,
    v.academic_unit_id,
    v.academic_unit_name,
    v.campus_id,
    v.academic_term_id,
    v.term_display_name,
    v.groups,
    COALESCE(spl.level_number, 999) AS level_number
  FROM public.v_schedule_courses v
  INNER JOIN public.user_study_plan usp ON usp.user_id = p_user_id AND usp.is_active = true
  INNER JOIN public.study_plan_level_course splc ON splc.study_plan_level_id IN (
    SELECT id FROM public.study_plan_level WHERE study_plan_id = usp.study_plan_id
  ) AND splc.course_id = v.course_id
  INNER JOIN public.study_plan_level spl ON spl.id = splc.study_plan_level_id
  WHERE v.academic_term_id = p_academic_term_id
    AND (p_include_other_campuses OR v.campus_id = p_campus_id)
    AND (v.groups::jsonb <> '[]'::jsonb)
  ORDER BY v.course_code, v.offering_id;
END;
$$;

COMMENT ON FUNCTION public.get_user_schedule_courses IS 'Returns schedule courses filtered by user study plan, ordered by level_number.';

-- ============================================================================
-- FUNCTION: get_schedule_user_context (invoker)
-- ============================================================================
-- Returns user's study plan context for scheduling.
-- Uses auth.uid() to get the current user automatically.
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
  LEFT JOIN LATERAL public.derive_user_context_from_study_plan(
    usp.study_plan_id,
    usp.campus_id
  ) ctx ON true
  LEFT JOIN public.university univ ON ctx.university_id = univ.id
  LEFT JOIN public.campus c ON usp.campus_id = c.id
  LEFT JOIN public.academic_unit au ON ctx.academic_unit_id = au.id
  LEFT JOIN public.study_plan sp ON ctx.study_plan_id = sp.id
  WHERE u.id = auth.uid();
END;
$$;

COMMENT ON FUNCTION public.get_schedule_user_context IS 'Returns user study plan context for schedule filtering.';

-- ============================================================================
-- FUNCTION: get_schedule_courses_by_academic_unit (invoker)
-- ============================================================================
-- Returns schedule courses filtered by academic unit (career/school).
-- Fallback when user doesn't have a study plan configured.
-- Shows ONE course per course_id with all its groups combined.
-- Groups are ordered by group_code.
-- Optionally includes groups from other campuses.
CREATE OR REPLACE FUNCTION public.get_schedule_courses_by_academic_unit(
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_academic_unit_id BIGINT,
  p_include_other_campuses BOOLEAN DEFAULT false
)
RETURNS TABLE (
  offering_id BIGINT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  credits INTEGER,
  weekly_hours INTEGER,
  course_type TEXT,
  academic_unit_id BIGINT,
  academic_unit_name TEXT,
  campus_id BIGINT,
  academic_term_id BIGINT,
  term_display_name TEXT,
  groups JSON,
  level_number INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT ON (v.course_code)
    v.offering_id,
    v.course_id,
    v.course_code,
    v.course_name,
    v.credits_snapshot AS credits,
    v.weekly_hours_snapshot AS weekly_hours,
    v.course_type,
    v.academic_unit_id,
    v.academic_unit_name,
    v.campus_id,
    v.academic_term_id,
    v.term_display_name,
    v.groups,
    999 AS level_number
  FROM public.v_schedule_courses v
  WHERE v.academic_term_id = p_academic_term_id
    AND (p_include_other_campuses OR v.campus_id = p_campus_id)
    AND v.academic_unit_id = p_academic_unit_id
    AND (v.groups::jsonb <> '[]'::jsonb)
  ORDER BY v.course_code, v.offering_id;
END;
$$;

COMMENT ON FUNCTION public.get_schedule_courses_by_academic_unit IS 'Returns schedule courses filtered by academic unit, one entry per course.';

-- ============================================================================
-- SECURITY HARDENING (invoker)
-- ============================================================================
-- Ensure helper functions do not run with elevated privileges.
ALTER FUNCTION public.get_campuses_for_university(BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_academic_units_for_campus(BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_academic_units_for_university(BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_study_plans_for_academic_unit(BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.derive_user_context_from_study_plan(BIGINT, BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_user_profile_with_context(UUID) SECURITY INVOKER;
ALTER FUNCTION public.get_study_plan_courses_details(BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_schedule_courses(BIGINT, BIGINT, BIGINT) SECURITY INVOKER;
ALTER FUNCTION public.get_active_academic_terms() SECURITY INVOKER;
ALTER FUNCTION public.get_user_schedule_courses(UUID, BIGINT, BIGINT, BOOLEAN) SECURITY INVOKER;
ALTER FUNCTION public.get_schedule_user_context() SECURITY INVOKER;
ALTER FUNCTION public.get_schedule_courses_by_academic_unit(BIGINT, BIGINT, BIGINT, BOOLEAN) SECURITY INVOKER;

-- ============================================================================
-- FUNCTION: update_student_course_status
-- ============================================================================
-- Updates or inserts a student's course status record.
CREATE OR REPLACE FUNCTION public.update_student_course_status(
  p_user_id UUID,
  p_study_plan_id INTEGER,
  p_course_id INTEGER,
  p_status student_course_status
)
RETURNS void AS $$
BEGIN
  INSERT INTO public.student_course_record (user_id, study_plan_id, course_id, status, recorded_at)
  VALUES (p_user_id, p_study_plan_id, p_course_id, p_status, NOW())
  ON CONFLICT (user_id, study_plan_id, course_id)
  DO UPDATE SET
    status = p_status,
    recorded_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

 -- Grant execute permission to authenticated users
 GRANT EXECUTE ON FUNCTION public.update_student_course_status TO authenticated;

-- ============================================================================
-- FUNCTION: delete_student_course_status
-- ============================================================================
-- Deletes a student's course status record (used to mark as not taken).
CREATE OR REPLACE FUNCTION public.delete_student_course_status(
  p_user_id UUID,
  p_study_plan_id INTEGER,
  p_course_id INTEGER
)
RETURNS void AS $$
BEGIN
  DELETE FROM public.student_course_record
  WHERE user_id = p_user_id
    AND study_plan_id = p_study_plan_id
    AND course_id = p_course_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.delete_student_course_status TO authenticated;

-- ============================================================================
-- FUNCTION: get_course_equivalents_for_plan
-- ============================================================================
-- Returns all course equivalents for a specific study plan with pagination.
-- Includes equivalents even if they are not in any level of the study plan.
-- Optimized with indexes for performance with hundreds of equivalents per course.
CREATE OR REPLACE FUNCTION public.get_course_equivalents_for_plan(
  p_study_plan_id BIGINT,
  p_from_course_id BIGINT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (to_course_id BIGINT, to_course_code TEXT, to_course_name TEXT, total_count BIGINT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
DECLARE
  v_total_count BIGINT;
BEGIN
  -- Get total count of equivalents for pagination
  SELECT COUNT(DISTINCT cr.to_course_id) INTO v_total_count
  FROM public.course_relation cr
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_from_course_id
    AND cr.relation_type = 'EQUIVALENT';

  RETURN QUERY
  SELECT
    cr.to_course_id,
    c.code AS to_course_code,
    c.name AS to_course_name,
    v_total_count AS total_count
  FROM public.course_relation cr
  LEFT JOIN public.course c ON c.id = cr.to_course_id
  WHERE cr.study_plan_id = p_study_plan_id
    AND cr.from_course_id = p_from_course_id
    AND cr.relation_type = 'EQUIVALENT'
  ORDER BY c.code
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.get_course_equivalents_for_plan TO authenticated;

 COMMIT;
