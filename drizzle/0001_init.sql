-- 0001_init.sql
-- Initial schema: extensions, enums, tables, constraints (PK/UK/FK), and triggers/functions.
--
-- Notes / conventions:
-- - This migration intentionally DOES NOT create RLS policies or enable RLS. That is handled in `0002_rls.sql`.
-- - Most non-unique indexes are also deferred to `0003_indexes.sql` to keep concerns separated.
-- - All tables live in `public` unless otherwise noted.
-- - Enums are used for stable categorical data for optimal storage and performance.
-- - Column comments are added at the end of the file for Supabase documentation.

BEGIN;

-- ============================================================================
-- EXTENSIONS
-- ============================================================================

-- For legacy uuid generation if needed. Supabase often uses gen_random_uuid() via pgcrypto,
-- but this project schema was originally generated with uuid-ossp.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- ENUMS (stable categorical values for optimal performance)
-- ============================================================================

DO $$
BEGIN
  -- Course relation type: prerequisite/corequisite/equivalent
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'course_relation_type') THEN
    CREATE TYPE course_relation_type AS ENUM (
      'PREREQUISITE',
      'COREQUISITE',
      'EQUIVALENT'
    );
  END IF;

  -- Student course status: in-progress/withdrawn/approved/failed
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'student_course_status') THEN
    CREATE TYPE student_course_status AS ENUM (
      'IN_PROGRESS',
      'WITHDRAWN',
      'APPROVED',
      'FAILED'
    );
  END IF;

  -- Group delivery mode type
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'group_type') THEN
    CREATE TYPE group_type AS ENUM (
      'REGULAR',
      'SEMIPRESENCIAL',
      'VIRTUAL',
      'ASISTIDA',
      'TUTORIA',
      'LABORATORIO'
    );
  END IF;
END $$;

-- ============================================================================
-- CATALOG / REFERENCE DATA TABLES
-- ============================================================================

-- Countries (ISO-3166 alpha-2)
CREATE TABLE IF NOT EXISTS public.country (
  id         BIGSERIAL PRIMARY KEY,
  name       TEXT NOT NULL,
  iso2_code  CHAR(2) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Universities / institutions
CREATE TABLE IF NOT EXISTS public.university (
  id         BIGSERIAL PRIMARY KEY,
  country_id BIGINT NOT NULL,
  name       TEXT NOT NULL,
  short_name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT university_country_id_fkey
    FOREIGN KEY (country_id)
    REFERENCES public.country(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Campuses / sedes
CREATE TABLE IF NOT EXISTS public.campus (
  id            BIGSERIAL PRIMARY KEY,
  university_id BIGINT NOT NULL,
  code          TEXT NOT NULL UNIQUE,
  name          TEXT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT campus_university_id_fkey
    FOREIGN KEY (university_id)
    REFERENCES public.university(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Academic Units (schools/departments)
CREATE TABLE IF NOT EXISTS public.academic_unit (
  id             BIGSERIAL PRIMARY KEY,
  university_id  BIGINT NOT NULL,
  code           TEXT NOT NULL UNIQUE,
  name           TEXT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT academic_unit_university_id_fkey
    FOREIGN KEY (university_id)
    REFERENCES public.university(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Academic Modalities
CREATE TABLE IF NOT EXISTS public.academic_modality (
  id               BIGSERIAL PRIMARY KEY,
  code             TEXT NOT NULL UNIQUE,
  name             TEXT NOT NULL,
  periods_per_year INTEGER NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Academic Terms
CREATE TABLE IF NOT EXISTS public.academic_term (
  id                  BIGSERIAL PRIMARY KEY,
  academic_modality_id BIGINT NOT NULL,
  year                INTEGER NOT NULL,
  period_number       INTEGER NOT NULL,
  external_key        TEXT NOT NULL UNIQUE,
  display_name        TEXT NOT NULL,
  starts_on           DATE,
  ends_on             DATE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT academic_term_academic_modality_id_fkey
    FOREIGN KEY (academic_modality_id)
    REFERENCES public.academic_modality(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- ============================================================================
-- PROGRAM / CURRICULUM TABLES
-- ============================================================================

-- Academic Unit offered at Campus
CREATE TABLE IF NOT EXISTS public.academic_unit_campus (
  id               BIGSERIAL PRIMARY KEY,
  academic_unit_id BIGINT NOT NULL,
  campus_id        BIGINT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT academic_unit_campus_academic_unit_id_fkey
    FOREIGN KEY (academic_unit_id)
    REFERENCES public.academic_unit(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT academic_unit_campus_campus_id_fkey
    FOREIGN KEY (campus_id)
    REFERENCES public.campus(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT academic_unit_campus_unique_unit_campus
    UNIQUE (academic_unit_id, campus_id)
);

-- Study Plans / Curricula
CREATE TABLE IF NOT EXISTS public.study_plan (
  id                   BIGSERIAL PRIMARY KEY,
  academic_unit_id     BIGINT NOT NULL,
  academic_modality_id BIGINT NOT NULL,
  external_plan_id     INTEGER NOT NULL, -- Example: 412
  name                 TEXT NOT NULL, -- Example: INGENIERIA EN COMPUTACION-2022
  academic_degree      TEXT, -- Example: BACHILLERATO UNIVERSITARIO
  first_level_number   INTEGER NOT NULL DEFAULT 0,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT study_plan_academic_unit_id_fkey
    FOREIGN KEY (academic_unit_id)
    REFERENCES public.academic_unit(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_academic_modality_id_fkey
    FOREIGN KEY (academic_modality_id)
    REFERENCES public.academic_modality(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_unique_unit_external
    UNIQUE (academic_unit_id, external_plan_id)
);

-- Study Plan valid at Campus
CREATE TABLE IF NOT EXISTS public.study_plan_campus (
  id           BIGSERIAL PRIMARY KEY,
  study_plan_id BIGINT NOT NULL,
  campus_id    BIGINT NOT NULL,
  valid_from   DATE,
  valid_to     DATE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT study_plan_campus_study_plan_id_fkey
    FOREIGN KEY (study_plan_id)
    REFERENCES public.study_plan(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_campus_campus_id_fkey
    FOREIGN KEY (campus_id)
    REFERENCES public.campus(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_campus_unique_plan_campus
    UNIQUE (study_plan_id, campus_id)
);

-- Study Plan Levels
CREATE TABLE IF NOT EXISTS public.study_plan_level (
  id           BIGSERIAL PRIMARY KEY,
  study_plan_id BIGINT NOT NULL,
  level_number INTEGER NOT NULL,
  level_label  TEXT NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT study_plan_level_study_plan_id_fkey
    FOREIGN KEY (study_plan_id)
    REFERENCES public.study_plan(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_level_unique_plan_level
    UNIQUE (study_plan_id, level_number)
);

-- ============================================================================
-- COURSE TABLES
-- ============================================================================

-- Canonical Course Catalog
CREATE TABLE IF NOT EXISTS public.course (
  id                   BIGSERIAL PRIMARY KEY,
  code                 TEXT NOT NULL UNIQUE,
  name                 TEXT NOT NULL,
  default_credits      INTEGER NOT NULL DEFAULT 0,
  default_weekly_hours INTEGER NOT NULL DEFAULT 0,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Courses in Study Plan Level
CREATE TABLE IF NOT EXISTS public.study_plan_level_course (
  id                 BIGSERIAL PRIMARY KEY,
  study_plan_level_id BIGINT NOT NULL,
  course_id          BIGINT NOT NULL,
  credits            INTEGER NOT NULL,
  weekly_hours       INTEGER NOT NULL,
  sort_order         INTEGER NOT NULL DEFAULT 0,

  CONSTRAINT study_plan_level_course_level_id_fkey
    FOREIGN KEY (study_plan_level_id)
    REFERENCES public.study_plan_level(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_level_course_course_id_fkey
    FOREIGN KEY (course_id)
    REFERENCES public.course(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT study_plan_level_course_unique_level_course
    UNIQUE (study_plan_level_id, course_id)
);

-- Course Relations in a Plan
CREATE TABLE IF NOT EXISTS public.course_relation (
  id            BIGSERIAL PRIMARY KEY,
  study_plan_id BIGINT NOT NULL,
  from_course_id BIGINT NOT NULL,
  to_course_id  BIGINT NOT NULL,
  relation_type course_relation_type NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT course_relation_study_plan_id_fkey
    FOREIGN KEY (study_plan_id)
    REFERENCES public.study_plan(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT course_relation_from_course_id_fkey
    FOREIGN KEY (from_course_id)
    REFERENCES public.course(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_relation_to_course_id_fkey
    FOREIGN KEY (to_course_id)
    REFERENCES public.course(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_relation_unique
    UNIQUE (study_plan_id, from_course_id, to_course_id, relation_type)
);

-- ============================================================================
-- COURSE OFFERING TABLES (SCHEDULE)
-- ============================================================================

-- Professors / Instructors
CREATE TABLE IF NOT EXISTS public.professor (
  id        BIGSERIAL PRIMARY KEY,
  full_name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Course Offering (header-level)
CREATE TABLE IF NOT EXISTS public.course_offering (
  id                  BIGSERIAL PRIMARY KEY,
  course_id           BIGINT NOT NULL,
  campus_id           BIGINT NOT NULL,
  academic_unit_id    BIGINT NOT NULL,
  academic_term_id    BIGINT NOT NULL,
  credits_snapshot    INTEGER NOT NULL,
  weekly_hours_snapshot INTEGER NOT NULL,
  course_type         TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT course_offering_course_id_fkey
    FOREIGN KEY (course_id)
    REFERENCES public.course(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_campus_id_fkey
    FOREIGN KEY (campus_id)
    REFERENCES public.campus(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_academic_unit_id_fkey
    FOREIGN KEY (academic_unit_id)
    REFERENCES public.academic_unit(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_academic_term_id_fkey
    FOREIGN KEY (academic_term_id)
    REFERENCES public.academic_term(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_unique_course_campus_unit_term
    UNIQUE (course_id, campus_id, academic_unit_id, academic_term_id)
);

-- Groups / Sections for an Offering
CREATE TABLE IF NOT EXISTS public.course_offering_group (
  id                BIGSERIAL PRIMARY KEY,
  course_offering_id BIGINT NOT NULL,
  group_code        TEXT NOT NULL,
  group_type        group_type NOT NULL,
  capacity          INTEGER NOT NULL DEFAULT 0,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT course_offering_group_course_offering_id_fkey
    FOREIGN KEY (course_offering_id)
      REFERENCES public.course_offering(id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,

  CONSTRAINT course_offering_group_unique
    UNIQUE (course_offering_id, group_code)
);

-- Group-Professor Join (many-to-many)
CREATE TABLE IF NOT EXISTS public.course_offering_group_professor (
  id                     BIGSERIAL PRIMARY KEY,
  course_offering_group_id BIGINT NOT NULL,
  professor_id           BIGINT NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT course_offering_group_professor_group_id_fkey
    FOREIGN KEY (course_offering_group_id)
    REFERENCES public.course_offering_group(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_group_professor_professor_id_fkey
    FOREIGN KEY (professor_id)
    REFERENCES public.professor(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_group_professor_unique
    UNIQUE (course_offering_group_id, professor_id)
);

-- Meeting Times for a Group
CREATE TABLE IF NOT EXISTS public.course_offering_meeting (
  id                     BIGSERIAL PRIMARY KEY,
  course_offering_group_id BIGINT NOT NULL,
  weekday                INTEGER NOT NULL,
  starts_at              TIME NOT NULL,
  ends_at                TIME NOT NULL,
  classroom              TEXT,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT course_offering_meeting_course_offering_group_id_fkey
    FOREIGN KEY (course_offering_group_id)
    REFERENCES public.course_offering_group(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT course_offering_meeting_weekday_check
    CHECK (weekday BETWEEN 1 AND 7),

  CONSTRAINT course_offering_meeting_unique
    UNIQUE (course_offering_group_id, weekday, starts_at, ends_at)
);

-- ============================================================================
-- USER / STUDENT DATA TABLES
-- ============================================================================

-- User Profile
CREATE TABLE IF NOT EXISTS public."user" (
  id         UUID PRIMARY KEY,
  carnet     TEXT UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT user_id_fkey
    FOREIGN KEY (id)
    REFERENCES auth.users(id)
    ON DELETE CASCADE
);

-- User Study Plan Context
CREATE TABLE IF NOT EXISTS public.user_study_plan (
  id           BIGSERIAL PRIMARY KEY,
  user_id      UUID NOT NULL,
  study_plan_id BIGINT NOT NULL,
  campus_id    BIGINT NOT NULL,
  entry_year   INTEGER NOT NULL,
  started_on   DATE,
  ended_on     DATE,
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT user_study_plan_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public."user"(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT user_study_plan_study_plan_id_fkey
    FOREIGN KEY (study_plan_id)
    REFERENCES public.study_plan(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT user_study_plan_campus_id_fkey
    FOREIGN KEY (campus_id)
    REFERENCES public.campus(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT user_study_plan_unique
    UNIQUE (user_id, study_plan_id, campus_id)
);

-- Student Course Records
CREATE TABLE IF NOT EXISTS public.student_course_record (
  id              BIGSERIAL PRIMARY KEY,
  user_id         UUID NOT NULL,
  study_plan_id   BIGINT NOT NULL,
  course_id       BIGINT NOT NULL,
  academic_term_id BIGINT NOT NULL,
  status          student_course_status NOT NULL,
  grade           NUMERIC(5,2),
  approved        BOOLEAN NOT NULL DEFAULT FALSE,
  recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT student_course_record_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public."user"(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT student_course_record_study_plan_id_fkey
    FOREIGN KEY (study_plan_id)
    REFERENCES public.study_plan(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT student_course_record_course_id_fkey
    FOREIGN KEY (course_id)
    REFERENCES public.course(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT student_course_record_academic_term_id_fkey
    FOREIGN KEY (academic_term_id)
    REFERENCES public.academic_term(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Add unique constraint for upsert functionality (migration 0006)
ALTER TABLE public.student_course_record
DROP CONSTRAINT IF EXISTS student_course_record_user_course_plan_unique;

ALTER TABLE public.student_course_record
ADD CONSTRAINT student_course_record_user_course_plan_unique
UNIQUE (user_id, study_plan_id, course_id);

-- Make academic_term_id nullable (migration 0007)
ALTER TABLE public.student_course_record
ALTER COLUMN academic_term_id DROP NOT NULL;

-- Saved Schedules
CREATE TABLE IF NOT EXISTS public.saved_schedule (
  id              BIGSERIAL PRIMARY KEY,
  user_id         UUID NOT NULL,
  name            TEXT NOT NULL,
  academic_term_id BIGINT NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT saved_schedule_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public."user"(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT saved_schedule_academic_term_id_fkey
    FOREIGN KEY (academic_term_id)
    REFERENCES public.academic_term(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Saved Schedule Items
CREATE TABLE IF NOT EXISTS public.saved_schedule_item (
  id                     BIGSERIAL PRIMARY KEY,
  saved_schedule_id      BIGINT NOT NULL,
  course_offering_group_id BIGINT NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT saved_schedule_item_saved_schedule_id_fkey
    FOREIGN KEY (saved_schedule_id)
    REFERENCES public.saved_schedule(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

  CONSTRAINT saved_schedule_item_course_offering_group_id_fkey
    FOREIGN KEY (course_offering_group_id)
    REFERENCES public.course_offering_group(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  CONSTRAINT saved_schedule_item_unique
    UNIQUE (saved_schedule_id, course_offering_group_id)
);

-- ============================================================================
-- HELPER FUNCTIONS + TRIGGERS
-- ============================================================================

CREATE OR REPLACE FUNCTION public.trigger_set_timestamp()
RETURNS TRIGGER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_user') THEN
    CREATE TRIGGER set_timestamp_user
      BEFORE UPDATE ON public."user"
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_university') THEN
    CREATE TRIGGER set_timestamp_university
      BEFORE UPDATE ON public.university
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_campus') THEN
    CREATE TRIGGER set_timestamp_campus
      BEFORE UPDATE ON public.campus
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_academic_unit') THEN
    CREATE TRIGGER set_timestamp_academic_unit
      BEFORE UPDATE ON public.academic_unit
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_academic_modality') THEN
    CREATE TRIGGER set_timestamp_academic_modality
      BEFORE UPDATE ON public.academic_modality
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_academic_term') THEN
    CREATE TRIGGER set_timestamp_academic_term
      BEFORE UPDATE ON public.academic_term
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_study_plan') THEN
    CREATE TRIGGER set_timestamp_study_plan
      BEFORE UPDATE ON public.study_plan
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course') THEN
    CREATE TRIGGER set_timestamp_course
      BEFORE UPDATE ON public.course
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_saved_schedule') THEN
    CREATE TRIGGER set_timestamp_saved_schedule
      BEFORE UPDATE ON public.saved_schedule
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public."user" (id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created') THEN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW
      EXECUTE FUNCTION public.handle_new_user();
  END IF;
END $$;

-- ============================================================================
-- TABLE COMMENTS (for Supabase documentation)
-- ============================================================================

COMMENT ON TABLE public.country IS 'Reference table for countries (ISO-3166 alpha-2).';
COMMENT ON COLUMN public.country.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.country.name IS 'Country name in English or local language.';
COMMENT ON COLUMN public.country.iso2_code IS 'ISO-3166 alpha-2 two-letter country code (unique).';
COMMENT ON COLUMN public.country.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.country.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.university IS 'Universities and institutions; currently used for ITCR and future expansion.';
COMMENT ON COLUMN public.university.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.university.country_id IS 'Foreign key to the country this university belongs to.';
COMMENT ON COLUMN public.university.name IS 'Full official name of the university.';
COMMENT ON COLUMN public.university.short_name IS 'Short display name (e.g., ITCR, UCR) used in UI.';
COMMENT ON COLUMN public.university.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.university.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.campus IS 'Campus and physical locations where courses are offered. Code is the canonical cross-API identifier.';
COMMENT ON COLUMN public.campus.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.campus.university_id IS 'Foreign key to the university that owns this campus.';
COMMENT ON COLUMN public.campus.code IS 'Canonical code used across multiple external APIs (e.g., CA, SJ, AL).';
COMMENT ON COLUMN public.campus.name IS 'Full descriptive name of the campus.';
COMMENT ON COLUMN public.campus.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.campus.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.academic_unit IS 'Academic units (schools/departments) that may offer degree programs or courses.';
COMMENT ON COLUMN public.academic_unit.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.academic_unit.university_id IS 'Foreign key to the university this unit belongs to.';
COMMENT ON COLUMN public.academic_unit.code IS 'Unique code identifier for the academic unit.';
COMMENT ON COLUMN public.academic_unit.name IS 'Full name of the school/department.';
COMMENT ON COLUMN public.academic_unit.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.academic_unit.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.academic_modality IS 'Catalog of academic period types (Semestre, Verano, Bimestre, etc.).';
COMMENT ON COLUMN public.academic_modality.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.academic_modality.code IS 'Short code identifier for the modality (e.g., S=Semestre, V=Verano, B=Bimestre).';
COMMENT ON COLUMN public.academic_modality.name IS 'Full descriptive name of the modality.';
COMMENT ON COLUMN public.academic_modality.periods_per_year IS 'Number of periods per academic year for this modality.';
COMMENT ON COLUMN public.academic_modality.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.academic_modality.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.academic_term IS 'Academic period instance: year + modality + period number with optional validity dates.';
COMMENT ON COLUMN public.academic_term.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.academic_term.academic_modality_id IS 'Foreign key to the academic modality this term belongs to.';
COMMENT ON COLUMN public.academic_term.year IS 'Calendar year of the academic term (e.g., 2026).';
COMMENT ON COLUMN public.academic_term.period_number IS 'Period number within the modality (e.g., 1, 2 for Semestre).';
COMMENT ON COLUMN public.academic_term.external_key IS 'External key from upstream system matching the format {YEAR}_{MODALITY}_{PERIOD}.';
COMMENT ON COLUMN public.academic_term.display_name IS 'Human-readable display name (e.g., "2026 - Semestre 1").';
COMMENT ON COLUMN public.academic_term.starts_on IS 'Start date of the term (optional, for scheduling).';
COMMENT ON COLUMN public.academic_term.ends_on IS 'End date of the term (optional, for scheduling).';
COMMENT ON COLUMN public.academic_term.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.academic_term.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.academic_unit_campus IS 'Join table: which academic units (schools/careers) are available at which campuses.';
COMMENT ON COLUMN public.academic_unit_campus.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.academic_unit_campus.academic_unit_id IS 'Foreign key to the academic unit.';
COMMENT ON COLUMN public.academic_unit_campus.campus_id IS 'Foreign key to the campus.';
COMMENT ON COLUMN public.academic_unit_campus.created_at IS 'Timestamp when the relationship was created.';

COMMENT ON TABLE public.study_plan IS 'Curriculum and study plan versions (Bachillerato, Licenciatura, Maestria) for an academic unit.';
COMMENT ON COLUMN public.study_plan.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.study_plan.academic_unit_id IS 'Foreign key to the academic unit offering this plan.';
COMMENT ON COLUMN public.study_plan.academic_modality_id IS 'Foreign key to the academic modality (Semestre, Bimestre, etc.).';
COMMENT ON COLUMN public.study_plan.external_plan_id IS 'External plan ID from upstream curriculum system.';
COMMENT ON COLUMN public.study_plan.name IS 'Full name of the study plan degree.';
COMMENT ON COLUMN public.study_plan.academic_degree IS 'Academic degree type (e.g., "Licenciatura", "Maestria", "Doctorado").';
COMMENT ON COLUMN public.study_plan.first_level_number IS 'First level number for ordering (usually 0 or 1).';
COMMENT ON COLUMN public.study_plan.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.study_plan.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.study_plan_campus IS 'Join table: where and when a study plan is valid at a specific campus.';
COMMENT ON COLUMN public.study_plan_campus.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.study_plan_campus.study_plan_id IS 'Foreign key to the study plan.';
COMMENT ON COLUMN public.study_plan_campus.campus_id IS 'Foreign key to the campus where the plan is available.';
COMMENT ON COLUMN public.study_plan_campus.valid_from IS 'Date from which the plan is valid at this campus (null = always).';
COMMENT ON COLUMN public.study_plan_campus.valid_to IS 'Date until which the plan is valid at this campus (null = always).';
COMMENT ON COLUMN public.study_plan_campus.created_at IS 'Timestamp when the relationship was created.';

COMMENT ON TABLE public.study_plan_level IS 'Organizational levels within a study plan (e.g., Semestre 0, Semestre 1, Semestre 2).';
COMMENT ON COLUMN public.study_plan_level.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.study_plan_level.study_plan_id IS 'Foreign key to the parent study plan.';
COMMENT ON COLUMN public.study_plan_level.level_number IS 'Sequential number for ordering levels (0, 1, 2, ...).';
COMMENT ON COLUMN public.study_plan_level.level_label IS 'Human-readable label for display (e.g., "Semestre 1", "Bimestre 3").';
COMMENT ON COLUMN public.study_plan_level.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.course IS 'Canonical course catalog. Courses are shared across multiple study plans and academic units.';
COMMENT ON COLUMN public.course.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course.code IS 'Official course code (e.g., "IC1802", "MA1001") - unique identifier.';
COMMENT ON COLUMN public.course.name IS 'Full name of the course.';
COMMENT ON COLUMN public.course.default_credits IS 'Default number of credits for this course.';
COMMENT ON COLUMN public.course.default_weekly_hours IS 'Default weekly lecture hours for this course.';
COMMENT ON COLUMN public.course.created_at IS 'Timestamp when the record was created.';
COMMENT ON COLUMN public.course.updated_at IS 'Timestamp when the record was last updated.';

COMMENT ON TABLE public.study_plan_level_course IS 'Join table: courses included in a specific study plan level with plan-specific credits and hours.';
COMMENT ON COLUMN public.study_plan_level_course.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.study_plan_level_course.study_plan_level_id IS 'Foreign key to the study plan level.';
COMMENT ON COLUMN public.study_plan_level_course.course_id IS 'Foreign key to the course.';
COMMENT ON COLUMN public.study_plan_level_course.credits IS 'Number of credits for this course in this specific plan level.';
COMMENT ON COLUMN public.study_plan_level_course.weekly_hours IS 'Number of weekly hours for this course in this specific plan level.';
COMMENT ON COLUMN public.study_plan_level_course.sort_order IS 'Sort order for display purposes within the level.';

COMMENT ON TABLE public.course_relation IS 'Prerequisite, corequisite, and equivalent relationships between courses within a study plan.';
COMMENT ON COLUMN public.course_relation.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course_relation.study_plan_id IS 'Foreign key to the study plan this relation belongs to.';
COMMENT ON COLUMN public.course_relation.from_course_id IS 'The course that has the relation (e.g., the course requiring a prerequisite).';
COMMENT ON COLUMN public.course_relation.to_course_id IS 'The related course (e.g., the prerequisite or equivalent).';
COMMENT ON COLUMN public.course_relation.relation_type IS 'Type of relation: PREREQUISITE, COREQUISITE, or EQUIVALENT.';
COMMENT ON COLUMN public.course_relation.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.professor IS 'Professor and instructor catalog, deduplicated by full name.';
COMMENT ON COLUMN public.professor.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.professor.full_name IS 'Full name of the professor (unique, deduplication key).';
COMMENT ON COLUMN public.professor.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.course_offering IS 'A course being offered at a specific campus during a specific academic term (header-level).';
COMMENT ON COLUMN public.course_offering.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course_offering.course_id IS 'Foreign key to the canonical course.';
COMMENT ON COLUMN public.course_offering.campus_id IS 'Foreign key to the campus where this offering takes place.';
COMMENT ON COLUMN public.course_offering.academic_unit_id IS 'Foreign key to the academic unit publishing this offering.';
COMMENT ON COLUMN public.course_offering.academic_term_id IS 'Foreign key to the academic term for this offering.';
COMMENT ON COLUMN public.course_offering.credits_snapshot IS 'Snapshot of credits at the time of offering creation.';
COMMENT ON COLUMN public.course_offering.weekly_hours_snapshot IS 'Snapshot of weekly hours at the time of offering creation.';
COMMENT ON COLUMN public.course_offering.course_type IS 'Course type classification (null allowed - values may vary).';
COMMENT ON COLUMN public.course_offering.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.course_offering_group IS 'Specific group and section instances of a course offering (e.g., "Grupo 01", "Grupo 02").';
COMMENT ON COLUMN public.course_offering_group.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course_offering_group.course_offering_id IS 'Foreign key to the parent course offering.';
COMMENT ON COLUMN public.course_offering_group.group_code IS 'Group code identifier within the offering (e.g., "01", "A").';
COMMENT ON COLUMN public.course_offering_group.group_type IS 'Delivery mode type: REGULAR, SEMIPRESENCIAL, VIRTUAL, ASISTIDA, or TUTORIA.';
COMMENT ON COLUMN public.course_offering_group.capacity IS 'Maximum number of students allowed in this group.';
COMMENT ON COLUMN public.course_offering_group.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.course_offering_group_professor IS 'Join table: professors assigned to a specific offering group.';
COMMENT ON COLUMN public.course_offering_group_professor.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course_offering_group_professor.course_offering_group_id IS 'Foreign key to the offering group.';
COMMENT ON COLUMN public.course_offering_group_professor.professor_id IS 'Foreign key to the professor.';
COMMENT ON COLUMN public.course_offering_group_professor.created_at IS 'Timestamp when the assignment was created.';

COMMENT ON TABLE public.course_offering_meeting IS 'Individual meeting sessions (weekday, time, classroom) for a specific group.';
COMMENT ON COLUMN public.course_offering_meeting.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.course_offering_meeting.course_offering_group_id IS 'Foreign key to the offering group this meeting belongs to.';
COMMENT ON COLUMN public.course_offering_meeting.weekday IS 'Day of the week (1=Monday through 7=Sunday).';
COMMENT ON COLUMN public.course_offering_meeting.starts_at IS 'Meeting start time.';
COMMENT ON COLUMN public.course_offering_meeting.ends_at IS 'Meeting end time.';
COMMENT ON COLUMN public.course_offering_meeting.classroom IS 'Classroom or location identifier (e.g., "A-101", "Lab 1").';
COMMENT ON COLUMN public.course_offering_meeting.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public."user" IS 'App user profile linking to Supabase auth.users and storing app-specific user data.';
COMMENT ON COLUMN public."user".id IS 'Primary key and foreign key to auth.users.id.';
COMMENT ON COLUMN public."user".carnet IS 'Student ID or carnet (unique per user).';
COMMENT ON COLUMN public."user".created_at IS 'Timestamp when the profile was created.';
COMMENT ON COLUMN public."user".updated_at IS 'Timestamp when the profile was last updated.';

COMMENT ON TABLE public.user_study_plan IS 'User study plan context associating users with their declared plan and campus.';
COMMENT ON COLUMN public.user_study_plan.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.user_study_plan.user_id IS 'Foreign key to the user profile.';
COMMENT ON COLUMN public.user_study_plan.study_plan_id IS 'Foreign key to the study plan the user is following.';
COMMENT ON COLUMN public.user_study_plan.campus_id IS 'Foreign key to the campus where the user is enrolled.';
COMMENT ON COLUMN public.user_study_plan.entry_year IS 'Academic year the user started this plan.';
COMMENT ON COLUMN public.user_study_plan.started_on IS 'Date when the user started this plan context.';
COMMENT ON COLUMN public.user_study_plan.ended_on IS 'Date when the user ended this plan context (null if still active).';
COMMENT ON COLUMN public.user_study_plan.is_active IS 'Flag indicating if this is the users active plan context.';
COMMENT ON COLUMN public.user_study_plan.created_at IS 'Timestamp when the record was created.';

COMMENT ON TABLE public.student_course_record IS 'User course history with status, grades, and completion information.';
COMMENT ON COLUMN public.student_course_record.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.student_course_record.user_id IS 'Foreign key to the user profile.';
COMMENT ON COLUMN public.student_course_record.study_plan_id IS 'Foreign key to the study plan this record belongs to.';
COMMENT ON COLUMN public.student_course_record.course_id IS 'Foreign key to the course.';
COMMENT ON COLUMN public.student_course_record.academic_term_id IS 'Foreign key to the academic term when the course was taken.';
COMMENT ON COLUMN public.student_course_record.status IS 'Enrollment status: IN_PROGRESS, WITHDRAWN, APPROVED, or FAILED.';
COMMENT ON COLUMN public.student_course_record.grade IS 'Numeric grade received (if applicable).';
COMMENT ON COLUMN public.student_course_record.approved IS 'Flag indicating if the course was approved/passed.';
COMMENT ON COLUMN public.student_course_record.recorded_at IS 'Timestamp when this record was created/recorded.';

COMMENT ON TABLE public.saved_schedule IS 'User-defined schedule collections for planning purposes (not enrollment).';
COMMENT ON COLUMN public.saved_schedule.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.saved_schedule.user_id IS 'Foreign key to the user who owns this schedule.';
COMMENT ON COLUMN public.saved_schedule.name IS 'User-defined name for the schedule.';
COMMENT ON COLUMN public.saved_schedule.academic_term_id IS 'Foreign key to the academic term this schedule is for.';
COMMENT ON COLUMN public.saved_schedule.created_at IS 'Timestamp when the schedule was created.';
COMMENT ON COLUMN public.saved_schedule.updated_at IS 'Timestamp when the schedule was last updated.';

COMMENT ON TABLE public.saved_schedule_item IS 'Individual offering groups selected within a saved schedule.';
COMMENT ON COLUMN public.saved_schedule_item.id IS 'Primary key identifier.';
COMMENT ON COLUMN public.saved_schedule_item.saved_schedule_id IS 'Foreign key to the parent saved schedule.';
COMMENT ON COLUMN public.saved_schedule_item.course_offering_group_id IS 'Foreign key to the offering group selected in the schedule.';
COMMENT ON COLUMN public.saved_schedule_item.created_at IS 'Timestamp when the item was added.';

-- ============================================================================
-- ENUM COMMENTS
-- ============================================================================

COMMENT ON TYPE course_relation_type IS 'Course relation types: PREREQUISITE, COREQUISITE, or EQUIVALENT.';
COMMENT ON TYPE student_course_status IS 'Student course statuses: IN_PROGRESS, WITHDRAWN, APPROVED, or FAILED.';
COMMENT ON TYPE group_type IS 'Group delivery modes: REGULAR, SEMIPRESENCIAL, VIRTUAL, ASISTIDA, or TUTORIA.';

COMMIT;
