-- 0002_rls.sql
-- Enable Row Level Security (RLS) and define policies.
--
-- Goals:
-- - Public/app clients should be able to READ the catalog/schedule data (campus, plans, offerings, etc.).
-- - User-owned data must be isolated per user (profile, plans, records, saved schedules).
-- - Writes to catalog tables are NOT allowed from the client; data is ingested via admin/seed/sync scripts
--   using elevated credentials (secret key / service role) which bypass RLS.
--
-- Notes:
-- - We implement "read-only for everyone (anon+authenticated)" on catalog tables to support public browsing.
--   If you later want to require login for browsing, change the policies to `TO authenticated`.
-- - This project’s key model: publishable keys for frontend/public clients; secret keys for backend/admin.
--   The secret key bypasses RLS; therefore, we keep insert/update/delete policies minimal and safe.

BEGIN;

-- ============================================================================
-- ENABLE RLS
-- ============================================================================
-- User tables (must be protected)
ALTER TABLE public."user"                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_study_plan        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_course_record  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_schedule         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_schedule_item    ENABLE ROW LEVEL SECURITY;

-- Catalog / sync tables (readable, but not writable by normal clients)
ALTER TABLE public.country                        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.university                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campus                         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_unit                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_modality              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_term                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_unit_campus           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plan                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plan_campus              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course                         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plan_level               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plan_level_course        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_relation                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professor                      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_offering                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_offering_group          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_offering_group_professor ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.course_offering_meeting        ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- USER TABLE POLICIES
-- ============================================================================
-- Rationale: aligns with DB_DESIGN.md:
-- - `public.user` is a lightweight profile linked 1:1 to `auth.users`.
-- - Users should only see/change their own row.
-- - Insert is done by trigger `public.handle_new_user()`; still allow authenticated inserts for safety
--   when called in-session, but restrict to own id.

DROP POLICY IF EXISTS "Users can view own profile" ON public."user";
CREATE POLICY "Users can view own profile"
ON public."user"
FOR SELECT
TO authenticated
USING ((select auth.uid()) = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public."user";
CREATE POLICY "Users can update own profile"
ON public."user"
FOR UPDATE
TO authenticated
USING ((select auth.uid()) = id)
WITH CHECK ((select auth.uid()) = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public."user";
CREATE POLICY "Users can insert own profile"
ON public."user"
FOR INSERT
TO authenticated
WITH CHECK ((select auth.uid()) = id);

-- ============================================================================
-- USER STUDY PLAN POLICIES
-- ============================================================================
-- Users manage their own plan context (used in app for filtering/eligibility).

DROP POLICY IF EXISTS "Users can view own study plans" ON public.user_study_plan;
CREATE POLICY "Users can view own study plans"
ON public.user_study_plan
FOR SELECT
TO authenticated
USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert own study plans" ON public.user_study_plan;
CREATE POLICY "Users can insert own study plans"
ON public.user_study_plan
FOR INSERT
TO authenticated
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update own study plans" ON public.user_study_plan;
CREATE POLICY "Users can update own study plans"
ON public.user_study_plan
FOR UPDATE
TO authenticated
USING ((select auth.uid()) = user_id)
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete own study plans" ON public.user_study_plan;
CREATE POLICY "Users can delete own study plans"
ON public.user_study_plan
FOR DELETE
TO authenticated
USING ((select auth.uid()) = user_id);

-- ============================================================================
-- STUDENT COURSE RECORD POLICIES
-- ============================================================================
-- Records are per-user. App can allow users to store their history manually/imported.

DROP POLICY IF EXISTS "Users can view own course records" ON public.student_course_record;
CREATE POLICY "Users can view own course records"
ON public.student_course_record
FOR SELECT
TO authenticated
USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert own course records" ON public.student_course_record;
CREATE POLICY "Users can insert own course records"
ON public.student_course_record
FOR INSERT
TO authenticated
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update own course records" ON public.student_course_record;
CREATE POLICY "Users can update own course records"
ON public.student_course_record
FOR UPDATE
TO authenticated
USING ((select auth.uid()) = user_id)
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete own course records" ON public.student_course_record;
CREATE POLICY "Users can delete own course records"
ON public.student_course_record
FOR DELETE
TO authenticated
USING ((select auth.uid()) = user_id);

-- ============================================================================
-- SAVED SCHEDULE POLICIES
-- ============================================================================
-- Users can manage their own saved schedules.

DROP POLICY IF EXISTS "Users can view own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can view own saved schedules"
ON public.saved_schedule
FOR SELECT
TO authenticated
USING ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can insert own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can insert own saved schedules"
ON public.saved_schedule
FOR INSERT
TO authenticated
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can update own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can update own saved schedules"
ON public.saved_schedule
FOR UPDATE
TO authenticated
USING ((select auth.uid()) = user_id)
WITH CHECK ((select auth.uid()) = user_id);

DROP POLICY IF EXISTS "Users can delete own saved schedules" ON public.saved_schedule;
CREATE POLICY "Users can delete own saved schedules"
ON public.saved_schedule
FOR DELETE
TO authenticated
USING ((select auth.uid()) = user_id);

-- ============================================================================
-- SAVED SCHEDULE ITEM POLICIES
-- ============================================================================
-- Items are writable only if the parent schedule belongs to the user.

DROP POLICY IF EXISTS "Users can view own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can view own schedule items"
ON public.saved_schedule_item
FOR SELECT
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id
    FROM public.saved_schedule ss
    WHERE ss.user_id = (select auth.uid())
  )
);

DROP POLICY IF EXISTS "Users can insert own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can insert own schedule items"
ON public.saved_schedule_item
FOR INSERT
TO authenticated
WITH CHECK (
  saved_schedule_id IN (
    SELECT ss.id
    FROM public.saved_schedule ss
    WHERE ss.user_id = (select auth.uid())
  )
);

DROP POLICY IF EXISTS "Users can update own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can update own schedule items"
ON public.saved_schedule_item
FOR UPDATE
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id
    FROM public.saved_schedule ss
    WHERE ss.user_id = (select auth.uid())
  )
)
WITH CHECK (
  saved_schedule_id IN (
    SELECT ss.id
    FROM public.saved_schedule ss
    WHERE ss.user_id = (select auth.uid())
  )
);

DROP POLICY IF EXISTS "Users can delete own schedule items" ON public.saved_schedule_item;
CREATE POLICY "Users can delete own schedule items"
ON public.saved_schedule_item
FOR DELETE
TO authenticated
USING (
  saved_schedule_id IN (
    SELECT ss.id
    FROM public.saved_schedule ss
    WHERE ss.user_id = (select auth.uid())
  )
);

-- ============================================================================
-- CATALOG READ POLICIES (PUBLIC READ)
-- ============================================================================
-- Rationale:
-- - Endpoints in DETALLES.md are largely public catalog/schedule data.
-- - App UX typically needs browsing without requiring login.
-- - Writes are handled by admin scripts using secret keys (RLS bypass).
--
-- If you want to restrict reads to authenticated users later, change `TO anon, authenticated`
-- to `TO authenticated`.

-- Helper pattern: keep policy names explicit and consistent.

DROP POLICY IF EXISTS "Public can read countries" ON public.country;
CREATE POLICY "Public can read countries" ON public.country
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read universities" ON public.university;
CREATE POLICY "Public can read universities" ON public.university
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read campuses" ON public.campus;
CREATE POLICY "Public can read campuses" ON public.campus
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read academic units" ON public.academic_unit;
CREATE POLICY "Public can read academic units" ON public.academic_unit
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read academic unit campuses" ON public.academic_unit_campus;
CREATE POLICY "Public can read academic unit campuses" ON public.academic_unit_campus
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read modalities" ON public.academic_modality;
CREATE POLICY "Public can read modalities" ON public.academic_modality
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read terms" ON public.academic_term;
CREATE POLICY "Public can read terms" ON public.academic_term
FOR SELECT TO anon, authenticated USING (true);


DROP POLICY IF EXISTS "Public can read study plans" ON public.study_plan;
CREATE POLICY "Public can read study plans" ON public.study_plan
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read study plan campuses" ON public.study_plan_campus;
CREATE POLICY "Public can read study plan campuses" ON public.study_plan_campus
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read courses" ON public.course;
CREATE POLICY "Public can read courses" ON public.course
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read plan levels" ON public.study_plan_level;
CREATE POLICY "Public can read plan levels" ON public.study_plan_level
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read plan level courses" ON public.study_plan_level_course;
CREATE POLICY "Public can read plan level courses" ON public.study_plan_level_course
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read course relations" ON public.course_relation;
CREATE POLICY "Public can read course relations" ON public.course_relation
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read professors" ON public.professor;
CREATE POLICY "Public can read professors" ON public.professor
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read offerings" ON public.course_offering;
CREATE POLICY "Public can read offerings" ON public.course_offering
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read offering groups" ON public.course_offering_group;
CREATE POLICY "Public can read offering groups" ON public.course_offering_group
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read group professors" ON public.course_offering_group_professor;
CREATE POLICY "Public can read group professors" ON public.course_offering_group_professor
FOR SELECT TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "Public can read meetings" ON public.course_offering_meeting;
CREATE POLICY "Public can read meetings" ON public.course_offering_meeting
FOR SELECT TO anon, authenticated USING (true);

-- ============================================================================
-- OPTIONAL: LOCK DOWN WRITES ON CATALOG TABLES
-- ============================================================================
-- By default, with RLS enabled and no INSERT/UPDATE/DELETE policies, writes are blocked for clients.
-- That is desired. Admin scripts using secret/service roles bypass RLS.
-- If you ever introduce additional Postgres roles, keep this invariant: catalog writes are admin-only.

COMMIT;
