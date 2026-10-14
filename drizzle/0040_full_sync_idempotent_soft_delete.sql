-- 0040_full_sync_idempotent_soft_delete.sql
-- Adds soft-delete lifecycle columns for sync-managed catalog tables and
-- updates key read views/functions to ignore inactive rows.

BEGIN;

-- Catalog tables managed by tec-data sync
ALTER TABLE public.country
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.university
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.campus
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.academic_unit
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.academic_modality
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.academic_term
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.academic_unit_campus
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.study_plan
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.study_plan_campus
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.study_plan_level
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.study_plan_level_course
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course_relation
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.professor
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course_offering
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course_offering_group
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course_offering_group_professor
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

ALTER TABLE public.course_offering_meeting
  ADD COLUMN IF NOT EXISTS deactivated_at TIMESTAMPTZ;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_country') THEN
    CREATE TRIGGER set_timestamp_country
      BEFORE UPDATE ON public.country
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

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_academic_unit_campus') THEN
    CREATE TRIGGER set_timestamp_academic_unit_campus
      BEFORE UPDATE ON public.academic_unit_campus
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_study_plan') THEN
    CREATE TRIGGER set_timestamp_study_plan
      BEFORE UPDATE ON public.study_plan
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_study_plan_campus') THEN
    CREATE TRIGGER set_timestamp_study_plan_campus
      BEFORE UPDATE ON public.study_plan_campus
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_study_plan_level') THEN
    CREATE TRIGGER set_timestamp_study_plan_level
      BEFORE UPDATE ON public.study_plan_level
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course') THEN
    CREATE TRIGGER set_timestamp_course
      BEFORE UPDATE ON public.course
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_study_plan_level_course') THEN
    CREATE TRIGGER set_timestamp_study_plan_level_course
      BEFORE UPDATE ON public.study_plan_level_course
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_course_relation') THEN
    CREATE TRIGGER set_timestamp_course_relation
      BEFORE UPDATE ON public.course_relation
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_professor') THEN
    CREATE TRIGGER set_timestamp_professor
      BEFORE UPDATE ON public.professor
      FOR EACH ROW
      EXECUTE FUNCTION public.trigger_set_timestamp();
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_country_active ON public.country(is_active);
CREATE INDEX IF NOT EXISTS idx_university_active ON public.university(is_active);
CREATE INDEX IF NOT EXISTS idx_campus_active ON public.campus(is_active);
CREATE INDEX IF NOT EXISTS idx_academic_unit_active ON public.academic_unit(is_active);
CREATE INDEX IF NOT EXISTS idx_academic_modality_active ON public.academic_modality(is_active);
CREATE INDEX IF NOT EXISTS idx_academic_term_active ON public.academic_term(is_active);
CREATE INDEX IF NOT EXISTS idx_academic_unit_campus_active ON public.academic_unit_campus(is_active);
CREATE INDEX IF NOT EXISTS idx_study_plan_active ON public.study_plan(is_active);
CREATE INDEX IF NOT EXISTS idx_study_plan_campus_active ON public.study_plan_campus(is_active);
CREATE INDEX IF NOT EXISTS idx_study_plan_level_active ON public.study_plan_level(is_active);
CREATE INDEX IF NOT EXISTS idx_course_active ON public.course(is_active);
CREATE INDEX IF NOT EXISTS idx_study_plan_level_course_active ON public.study_plan_level_course(is_active);
CREATE INDEX IF NOT EXISTS idx_course_relation_active ON public.course_relation(is_active);
CREATE INDEX IF NOT EXISTS idx_professor_active ON public.professor(is_active);

CREATE OR REPLACE VIEW public.v_universities
WITH (security_invoker = true)
AS
SELECT DISTINCT u.id, u.name, u.short_name
FROM public.university u
WHERE u.is_active = true
  AND EXISTS (
    SELECT 1
    FROM public.campus c
    WHERE c.university_id = u.id
      AND c.is_active = true
  )
ORDER BY u.name;

CREATE OR REPLACE VIEW public.v_campuses_by_university
WITH (security_invoker = true)
AS
SELECT c.id, c.university_id, c.code, c.name
FROM public.campus c
WHERE c.is_active = true
ORDER BY c.name;

CREATE OR REPLACE VIEW public.v_academic_units_with_plans
WITH (security_invoker = true)
AS
SELECT DISTINCT au.id, au.university_id, au.code, au.name
FROM public.academic_unit au
WHERE au.is_active = true
  AND EXISTS (
    SELECT 1
    FROM public.study_plan sp
    WHERE sp.academic_unit_id = au.id
      AND sp.is_active = true
  )
ORDER BY au.name;

CREATE OR REPLACE VIEW public.v_study_plans_for_academic_unit
WITH (security_invoker = true)
AS
SELECT
  sp.id,
  sp.academic_unit_id,
  sp.external_plan_id,
  sp.name,
  sp.academic_degree,
  am.name AS modality_name
FROM public.study_plan sp
JOIN public.academic_modality am ON sp.academic_modality_id = am.id
WHERE sp.is_active = true
  AND am.is_active = true
ORDER BY sp.name;

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
    AND c.is_active = true
    AND c.code = ANY(ARRAY['AL', 'CA', 'LM', 'SC', 'SJ']::TEXT[])
  ORDER BY c.name;
END;
$$;

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
      AND is_active = true
  )
  ORDER BY au.name;
END;
$$;

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
    AND sp.is_active = true
    AND (am.id IS NULL OR am.is_active = true)
  ORDER BY sp.external_plan_id DESC;
END;
$$;

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
    AND sp.is_active = true
    AND (
      sp.id IN (
        SELECT study_plan_id
        FROM public.study_plan_campus
        WHERE campus_id = p_campus_id
          AND is_active = true
      )
      OR NOT EXISTS (
        SELECT 1
        FROM public.study_plan_campus
        WHERE study_plan_id = sp.id
          AND is_active = true
      )
    )
  ORDER BY sp.external_plan_id DESC;
END;
$$;

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
    AND splc.is_active = true
    AND spl.is_active = true
    AND c.is_active = true
  ORDER BY spl.level_number, splc.sort_order;
END;
$$;

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
  WHERE at.is_active = true
    AND co.is_active = true
  ORDER BY at.year DESC, at.period_number DESC;
END;
$$;

COMMIT;
