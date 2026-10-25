-- 0003_indexes.sql
-- Performance indexes for common lookups and joins.
--
-- Notes:
-- - Keep indexes narrowly focused on the access patterns described in DETALLES.md and DB_DESIGN.md:
--   - common joins via FK columns
--   - lookups by external codes/keys (campus.code, academic_unit.code, course.code, academic_term.external_key)
--   - filtering by "active" or temporal attributes where applicable
-- - Unique constraints already create indexes implicitly; we do NOT duplicate those here.
-- - These are safe to run multiple times thanks to IF NOT EXISTS.

BEGIN;

-- ============================================================================
-- COUNTRY
-- ============================================================================
-- iso2_code is UNIQUE (implicit index). Name lookups are common in UI/admin.
CREATE INDEX IF NOT EXISTS idx_country_name ON public.country(name);

-- ============================================================================
-- UNIVERSITY
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_university_country_id ON public.university(country_id);
CREATE INDEX IF NOT EXISTS idx_university_name ON public.university(name);
CREATE INDEX IF NOT EXISTS idx_university_short_name ON public.university(short_name);

-- ============================================================================
-- CAMPUS
-- ============================================================================
-- code is UNIQUE (implicit index). Joins to university.
CREATE INDEX IF NOT EXISTS idx_campus_university_id ON public.campus(university_id);

-- ============================================================================
-- ACADEMIC UNIT
-- ============================================================================
-- code is UNIQUE (implicit index). Typical filters: join to university.
CREATE INDEX IF NOT EXISTS idx_academic_unit_university_id ON public.academic_unit(university_id);
CREATE INDEX IF NOT EXISTS idx_academic_unit_name ON public.academic_unit(name);

-- ============================================================================
-- ACADEMIC MODALITY
-- ============================================================================
-- code is UNIQUE (implicit index). Add name lookup for admin/search.
CREATE INDEX IF NOT EXISTS idx_academic_modality_name ON public.academic_modality(name);

-- ============================================================================
-- ACADEMIC TERM
-- ============================================================================
-- external_key is UNIQUE (implicit index).
-- Common query pattern: list terms for modality/year, and retrieve one by (year, period_number).
CREATE INDEX IF NOT EXISTS idx_academic_term_modality_id ON public.academic_term(academic_modality_id);
CREATE INDEX IF NOT EXISTS idx_academic_term_year_period ON public.academic_term(year, period_number);

-- ============================================================================
-- ACADEMIC UNIT CAMPUS JOIN TABLE
-- ============================================================================
-- academic_unit_campus has UNIQUE(academic_unit_id, campus_id) (implicit composite index).
-- Add reverse index for queries by campus -> units.
CREATE INDEX IF NOT EXISTS idx_academic_unit_campus_campus_id ON public.academic_unit_campus(campus_id);

-- ============================================================================
-- STUDY PLAN / JOIN TABLES
-- ============================================================================
-- study_plan has UNIQUE(academic_unit_id, external_plan_id) (implicit composite index).
-- Upstream often queries by external_plan_id; add a non-unique index for that lookup.
CREATE INDEX IF NOT EXISTS idx_study_plan_academic_unit_id ON public.study_plan(academic_unit_id);
CREATE INDEX IF NOT EXISTS idx_study_plan_academic_modality_id ON public.study_plan(academic_modality_id);
CREATE INDEX IF NOT EXISTS idx_study_plan_external_plan_id ON public.study_plan(external_plan_id);

-- study_plan_campus has UNIQUE(study_plan_id, campus_id) (implicit composite index).
-- Add reverse index for campus -> plans.
CREATE INDEX IF NOT EXISTS idx_study_plan_campus_campus_id ON public.study_plan_campus(campus_id);

-- ============================================================================
-- COURSE + CURRICULUM STRUCTURE
-- ============================================================================
-- course.code is UNIQUE (implicit index). No owning_academic_unit_id anymore.
CREATE INDEX IF NOT EXISTS idx_course_name ON public.course(name);

-- study_plan_level has UNIQUE(study_plan_id, level_number) (implicit composite index).
CREATE INDEX IF NOT EXISTS idx_study_plan_level_study_plan_id ON public.study_plan_level(study_plan_id);

-- study_plan_level_course has UNIQUE(study_plan_level_id, course_id) (implicit composite index).
-- Add reverse index for course -> level membership queries.
CREATE INDEX IF NOT EXISTS idx_study_plan_level_course_course_id ON public.study_plan_level_course(course_id);

-- course_relation has UNIQUE(study_plan_id, from_course_id, to_course_id, relation_type) (implicit composite index).
-- Add narrower indexes for common graph traversals.
CREATE INDEX IF NOT EXISTS idx_course_relation_study_plan_id ON public.course_relation(study_plan_id);
CREATE INDEX IF NOT EXISTS idx_course_relation_from_course_id ON public.course_relation(from_course_id);
CREATE INDEX IF NOT EXISTS idx_course_relation_to_course_id ON public.course_relation(to_course_id);
CREATE INDEX IF NOT EXISTS idx_course_relation_relation_type ON public.course_relation(relation_type);

-- ============================================================================
-- PROFESSOR
-- ============================================================================
-- full_name is UNIQUE (implicit index). No additional indexes required.

-- ============================================================================
-- COURSE OFFERINGS (SCHEDULE GUIDE)
-- ============================================================================
-- These are hot paths for browsing: filter by term + campus and join down to groups/meetings/professors.
CREATE INDEX IF NOT EXISTS idx_course_offering_course_id ON public.course_offering(course_id);
CREATE INDEX IF NOT EXISTS idx_course_offering_campus_id ON public.course_offering(campus_id);
CREATE INDEX IF NOT EXISTS idx_course_offering_academic_unit_id ON public.course_offering(academic_unit_id);
CREATE INDEX IF NOT EXISTS idx_course_offering_academic_term_id ON public.course_offering(academic_term_id);

-- Composite index for "browse offerings by campus+term" (very common for UI).
CREATE INDEX IF NOT EXISTS idx_course_offering_campus_term ON public.course_offering(campus_id, academic_term_id);

-- Groups under offerings
-- UNIQUE(course_offering_id, group_code) exists (implicit composite index).
-- Add group_type index for filtering (Regular/Virtual/etc.).
CREATE INDEX IF NOT EXISTS idx_course_offering_group_course_offering_id ON public.course_offering_group(course_offering_id);
CREATE INDEX IF NOT EXISTS idx_course_offering_group_group_type ON public.course_offering_group(group_type);

-- Group-professor join
-- UNIQUE(course_offering_group_id, professor_id) exists (implicit composite index).
CREATE INDEX IF NOT EXISTS idx_course_offering_group_professor_professor_id
  ON public.course_offering_group_professor(professor_id);

-- Meetings
CREATE INDEX IF NOT EXISTS idx_course_offering_meeting_group_id ON public.course_offering_meeting(course_offering_group_id);
CREATE INDEX IF NOT EXISTS idx_course_offering_meeting_weekday ON public.course_offering_meeting(weekday);
CREATE INDEX IF NOT EXISTS idx_course_offering_meeting_classroom ON public.course_offering_meeting(classroom);

-- ============================================================================
-- USER-OWNED TABLES
-- ============================================================================
-- public.user: carnet is UNIQUE (implicit index).
-- Add an index on id is redundant (PK).

-- user_study_plan
-- UNIQUE(user_id, study_plan_id, campus_id) exists (implicit composite index).
-- Add common filters: user_id, is_active.
CREATE INDEX IF NOT EXISTS idx_user_study_plan_user_id ON public.user_study_plan(user_id);
CREATE INDEX IF NOT EXISTS idx_user_study_plan_study_plan_id ON public.user_study_plan(study_plan_id);
CREATE INDEX IF NOT EXISTS idx_user_study_plan_campus_id ON public.user_study_plan(campus_id);
CREATE INDEX IF NOT EXISTS idx_user_study_plan_is_active ON public.user_study_plan(is_active);

-- student_course_record (per-user, per-course, per-term queries)
CREATE INDEX IF NOT EXISTS idx_student_course_record_user_id ON public.student_course_record(user_id);
CREATE INDEX IF NOT EXISTS idx_student_course_record_study_plan_id ON public.student_course_record(study_plan_id);
CREATE INDEX IF NOT EXISTS idx_student_course_record_course_id ON public.student_course_record(course_id);
CREATE INDEX IF NOT EXISTS idx_student_course_record_academic_term_id ON public.student_course_record(academic_term_id);
CREATE INDEX IF NOT EXISTS idx_student_course_record_status ON public.student_course_record(status);

-- saved_schedule
CREATE INDEX IF NOT EXISTS idx_saved_schedule_user_id ON public.saved_schedule(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_schedule_academic_term_id ON public.saved_schedule(academic_term_id);

-- saved_schedule_item
-- UNIQUE(saved_schedule_id, course_offering_group_id) exists (implicit composite index).
CREATE INDEX IF NOT EXISTS idx_saved_schedule_item_saved_schedule_id ON public.saved_schedule_item(saved_schedule_id);
CREATE INDEX IF NOT EXISTS idx_saved_schedule_item_course_offering_group_id ON public.saved_schedule_item(course_offering_group_id);

COMMIT;
