-- 0149_study_plan_academic_degree_enum.sql
-- Converts study_plan.academic_degree to a PostgreSQL enum and makes it NOT NULL.
--
-- academic_degree is a closed catalogue owned by the institution (7 values),
-- unlike course_offering.course_type which is published by the TEC and can gain
-- variants at any time. A closed catalogue is exactly what an enum is for: the
-- value set is validated by the type and cannot drift through a typo.
--
-- Note on course_type: it deliberately stays TEXT. It already was an enum in an
-- early version of the schema and had to be migrated away because the TEC added
-- values ('TRABAJO FINAL DE GRADUACION', 'CENTROS DE FORMACION', ...). Keeping
-- it as text (or a lookup table) avoids a DDL migration every semester.

BEGIN;

-- ============================================================================
-- 1. CREATE THE TYPE (idempotent)
-- ============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_type
    WHERE typname = 'academic_degree'
      AND typnamespace = 'public'::regnamespace
  ) THEN
    CREATE TYPE public.academic_degree AS ENUM (
      'ASOCIADO',
      'BACHILLERATO UNIVERSITARIO',
      'DIPLOMADO',
      'DOCTORADO ACADÉMICO',
      'LICENCIATURA',
      'MAESTRÍA',
      'NO OTORGA'
    );
  END IF;
END $$;

-- ============================================================================
-- 2. PRECHECK: every existing value must be in the enum
-- ============================================================================

DO $$
DECLARE
  invalid_count BIGINT;
  invalid_examples TEXT;
BEGIN
  SELECT count(*), string_agg(DISTINCT academic_degree, ', ')
  INTO invalid_count, invalid_examples
  FROM public.study_plan
  WHERE academic_degree IS NOT NULL
    AND academic_degree NOT IN (
      'ASOCIADO',
      'BACHILLERATO UNIVERSITARIO',
      'DIPLOMADO',
      'DOCTORADO ACADÉMICO',
      'LICENCIATURA',
      'MAESTRÍA',
      'NO OTORGA'
    );

  IF invalid_count > 0 THEN
    RAISE EXCEPTION
      'Cannot convert academic_degree to enum: % value(s) not in the catalogue: %',
      invalid_count, invalid_examples;
  END IF;
END $$;

-- ============================================================================
-- 3. DROP DEPENDENT VIEWS
--    Both expose academic_degree directly, so ALTER COLUMN TYPE is blocked.
--    They are recreated in section 5 keeping the text contract intact.
-- ============================================================================

DROP VIEW IF EXISTS public.v_study_plans_by_campus;
DROP VIEW IF EXISTS public.v_study_plans_for_academic_unit;

-- ============================================================================
-- 4. CONVERT THE COLUMN
-- ============================================================================

ALTER TABLE public.study_plan
  ALTER COLUMN academic_degree TYPE public.academic_degree
  USING (academic_degree::public.academic_degree);

-- No NULLs exist today; the catalogue has no "unknown" member, so the column
-- is expected to always carry a value when a plan is ingested.
ALTER TABLE public.study_plan
  ALTER COLUMN academic_degree SET NOT NULL;

COMMENT ON COLUMN public.study_plan.academic_degree IS
  'Academic degree awarded by the study plan. Closed institutional catalogue.';

-- ============================================================================
-- 5. RECREATE THE VIEWS
--    academic_degree::TEXT keeps the JSON/row shape the API already consumes.
-- ============================================================================

CREATE VIEW public.v_study_plans_by_campus AS
SELECT DISTINCT
  sp.id,
  sp.academic_unit_id,
  sp.external_plan_id,
  sp.name,
  sp.academic_degree::TEXT AS academic_degree
FROM public.study_plan sp
WHERE sp.academic_unit_id IN (
  SELECT DISTINCT auc.academic_unit_id
  FROM public.academic_unit_campus auc
  WHERE auc.campus_id IN (SELECT c.id FROM public.campus c)
)
ORDER BY sp.name;

CREATE VIEW public.v_study_plans_for_academic_unit AS
SELECT
  sp.id,
  sp.academic_unit_id,
  sp.external_plan_id,
  sp.name,
  sp.academic_degree::TEXT AS academic_degree,
  am.name AS modality_name
FROM public.study_plan sp
JOIN public.academic_modality am ON sp.academic_modality_id = am.id
WHERE sp.is_active = true
  AND am.is_active = true
ORDER BY sp.name;

COMMIT;
