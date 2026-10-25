-- 0157_cleanup_legacy_objects.sql
-- Clean up dead legacy functions, views, scratch tables, and obsolete RLS policies
-- left behind after migrating to the Cloudflare Worker + Better Auth architecture.

BEGIN;

-- ============================================================================
-- STEP 1: DROP DEAD SCRATCH TABLES (No foreign keys or dependencies)
-- ============================================================================
DROP TABLE IF EXISTS public.fn_out;
DROP TABLE IF EXISTS public.rpc_use;
DROP TABLE IF EXISTS public.dep_out;
DROP TABLE IF EXISTS public.scan_results;

-- ============================================================================
-- STEP 2: DROP DEAD VIEWS (No dependencies; grants cleaned up automatically)
-- ============================================================================
DROP VIEW IF EXISTS public.v_study_plans_for_academic_unit;
DROP VIEW IF EXISTS public.v_study_plans_by_campus;
DROP VIEW IF EXISTS public.v_academic_units_for_campus;
DROP VIEW IF EXISTS public.v_campuses_by_university;
DROP VIEW IF EXISTS public.v_universities;

-- ============================================================================
-- STEP 3: DROP STANDALONE DEAD FUNCTIONS AND OBSOLETE OVERLOADS
-- ============================================================================
DROP FUNCTION IF EXISTS public.search_professor_review_courses(text, integer);
DROP FUNCTION IF EXISTS public.get_academic_units_for_university(bigint);
DROP FUNCTION IF EXISTS public.get_user_schedule_courses(uuid, bigint, bigint, boolean);
DROP FUNCTION IF EXISTS public.get_eligible_schedule_courses(uuid, bigint, bigint, boolean, boolean);
DROP FUNCTION IF EXISTS public.get_schedule_user_context();
DROP FUNCTION IF EXISTS public.get_user_saved_schedule_group_lookups(bigint);
DROP FUNCTION IF EXISTS public.get_course_evaluations(integer);
DROP FUNCTION IF EXISTS public.get_course_evaluations(integer, bigint);

-- Drop ONLY the legacy 3-arg overload (preserve active 7-arg overload)
DROP FUNCTION IF EXISTS public.get_schedule_courses(bigint, bigint, bigint);

-- Drop ONLY the legacy 6-arg overload (preserve active 7-arg overload)
DROP FUNCTION IF EXISTS public.insert_student_course_attempt(uuid, bigint, bigint, text, numeric, bigint);

-- Drop orphaned trigger function from old Supabase Auth
DROP FUNCTION IF EXISTS public.handle_new_user();

-- ============================================================================
-- STEP 4: DROP DEAD MODERATION & FEEDBACK FUNCTIONS (Replaced by Worker handlers)
-- ============================================================================
DROP FUNCTION IF EXISTS public.reply_to_feedback(bigint, text, text);
DROP FUNCTION IF EXISTS public.moderate_evaluation(bigint, public.evaluation_status, text);
DROP FUNCTION IF EXISTS public.moderate_professor_review(bigint, public.professor_review_status, text);
DROP FUNCTION IF EXISTS public.moderate_professor_review_report(bigint, public.professor_review_report_status, text);
DROP FUNCTION IF EXISTS public.get_evaluation_moderation_queue(public.evaluation_status, integer, integer);
DROP FUNCTION IF EXISTS public.get_professor_reviews_for_moderation(public.professor_review_status, integer, integer);
DROP FUNCTION IF EXISTS public.get_professor_review_reports_for_moderation(public.professor_review_report_status, integer, integer);
DROP FUNCTION IF EXISTS public.can_moderate();

-- ============================================================================
-- STEP 5: DROP 12 OBSOLETE POLICIES DEPENDING ON is_admin() THEN DROP is_admin()
-- ============================================================================
DROP POLICY IF EXISTS "Admins can read all evaluations" ON public.course_evaluations;
DROP POLICY IF EXISTS "Admins can moderate evaluations" ON public.course_evaluations;
DROP POLICY IF EXISTS "Admins can delete any evaluation" ON public.course_evaluations;
DROP POLICY IF EXISTS "Administradores pueden gestionar notificaciones" ON public.notifications;
DROP POLICY IF EXISTS "Admins can read all professor reviews" ON public.professor_review;
DROP POLICY IF EXISTS "Admins can update professor reviews" ON public.professor_review;
DROP POLICY IF EXISTS "Admins can read all professor review courses" ON public.professor_review_course;
DROP POLICY IF EXISTS "Admins can manage professor review courses" ON public.professor_review_course;
DROP POLICY IF EXISTS "Admins can read professor review reports" ON public.professor_review_report;
DROP POLICY IF EXISTS "Admins can update professor review reports" ON public.professor_review_report;
DROP POLICY IF EXISTS "Admins can read all feedback" ON public.user_feedback;
DROP POLICY IF EXISTS "Admins can update feedback" ON public.user_feedback;

DROP FUNCTION IF EXISTS public.is_admin();

-- ============================================================================
-- STEP 6: REFACTOR 2 ACTIVE FUNCTIONS TO ELIMINATE current_user_id() CALLS
-- ============================================================================

-- get_suggested_academic_term: remove fallback to current_user_id() (always returned NULL)
CREATE OR REPLACE FUNCTION public.get_suggested_academic_term(p_study_plan_id bigint DEFAULT NULL::bigint)
RETURNS bigint
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_modality_id BIGINT;
  v_suggested_term_id BIGINT;
  v_current_year INTEGER;
BEGIN
  IF p_study_plan_id IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT sp.academic_modality_id
  INTO v_modality_id
  FROM public.study_plan sp
  WHERE sp.id = p_study_plan_id;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  v_current_year := EXTRACT(YEAR FROM CURRENT_DATE);

  SELECT at.id INTO v_suggested_term_id
  FROM public.academic_term at
  WHERE at.academic_modality_id = v_modality_id
    AND at.year <= v_current_year
    AND EXISTS (
      SELECT 1
      FROM public.course_offering co
      WHERE co.academic_term_id = at.id
        AND co.is_active = true
    )
  ORDER BY at.year DESC, at.period_number DESC
  LIMIT 1;

  IF v_suggested_term_id IS NULL THEN
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year <= v_current_year
    ORDER BY year DESC, period_number DESC
    LIMIT 1;
  END IF;

  RETURN v_suggested_term_id;
END;
$$;

-- get_user_profile_with_context: remove redundant current_user_id() check
CREATE OR REPLACE FUNCTION public.get_user_profile_with_context(p_user_id uuid)
RETURNS TABLE(
  user_id uuid,
  carnet text,
  university_id bigint,
  university_name text,
  campus_id bigint,
  campus_name text,
  academic_unit_id bigint,
  academic_unit_name text,
  study_plan_id bigint,
  study_plan_name text,
  user_study_plan_id bigint,
  entry_year integer,
  term_id bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
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
    usp.entry_year,
    public.get_suggested_academic_term(usp.study_plan_id) AS term_id
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

-- ============================================================================
-- STEP 7: DROP 20 OBSOLETE POLICIES DEPENDING ON current_user_id() THEN DROP current_user_id()
-- ============================================================================
DROP POLICY IF EXISTS "Users can manage own review reactions" ON public.professor_review_reaction;
DROP POLICY IF EXISTS "Users can view own saved schedules" ON public.saved_schedule;
DROP POLICY IF EXISTS "Users can insert own saved schedules" ON public.saved_schedule;
DROP POLICY IF EXISTS "Users can update own saved schedules" ON public.saved_schedule;
DROP POLICY IF EXISTS "Users can delete own saved schedules" ON public.saved_schedule;
DROP POLICY IF EXISTS "Users can view own schedule items" ON public.saved_schedule_item;
DROP POLICY IF EXISTS "Users can insert own schedule items" ON public.saved_schedule_item;
DROP POLICY IF EXISTS "Users can update own schedule items" ON public.saved_schedule_item;
DROP POLICY IF EXISTS "Users can delete own schedule items" ON public.saved_schedule_item;
DROP POLICY IF EXISTS "Users can view own course records" ON public.student_course_record;
DROP POLICY IF EXISTS "Users can insert own course records" ON public.student_course_record;
DROP POLICY IF EXISTS "Users can update own course records" ON public.student_course_record;
DROP POLICY IF EXISTS "Users can delete own course records" ON public.student_course_record;
DROP POLICY IF EXISTS "Users can view own profile" ON public."user";
DROP POLICY IF EXISTS "Users can insert own profile" ON public."user";
DROP POLICY IF EXISTS "Users can update own profile" ON public."user";
DROP POLICY IF EXISTS "Users can view own study plans" ON public.user_study_plan;
DROP POLICY IF EXISTS "Users can insert own study plans" ON public.user_study_plan;
DROP POLICY IF EXISTS "Users can update own study plans" ON public.user_study_plan;
DROP POLICY IF EXISTS "Users can delete own study plans" ON public.user_study_plan;

DROP FUNCTION IF EXISTS public.current_user_id();

-- ============================================================================
-- STEP 8: DROP current_jwt_claims() (No remaining callers)
-- ============================================================================
DROP FUNCTION IF EXISTS public.current_jwt_claims();

COMMIT;
