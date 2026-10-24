-- 0151_lookup_tables_group_type_academic_degree_course_type.sql
-- Replaces the group_type and academic_degree enums with lookup tables, and
-- moves course_type into a lookup as well.
--
-- Why lookups instead of enums:
--   - group_type already needed four ALTER TYPE migrations (0023, 0051, 0058)
--     to add RN, ENSEÑANZA REMOTA, TRABAJO FINAL DE GRADUACIÓN and TALLER.
--   - Adding a value to an enum requires DDL, which cannot run inside the data
--     sync. With a lookup it is a plain INSERT, so the sync can ingest a new
--     value by itself and report it in the delta.
--   - A typo or a new upstream value used to make normalize_group_type raise,
--     and the processor then dropped the whole group along with its professors
--     and meetings. With a lookup the row is stored and the run continues.
--
-- The columns keep their current textual values, so the API, the views and the
-- frontend receive exactly what they receive today.

BEGIN;

-- ============================================================================
-- 1. DROP DEPENDENT VIEWS
--    v_schedule_courses selects group_type and course_type; the two study plan
--    views select academic_degree. They are recreated in section 6.
-- ============================================================================

DROP VIEW IF EXISTS public.v_schedule_courses;
DROP VIEW IF EXISTS public.v_study_plans_by_campus;
DROP VIEW IF EXISTS public.v_study_plans_for_academic_unit;

-- ============================================================================
-- 2. DROP FUNCTIONS THAT RETURN group_type AS AN ENUM
--    get_course_latest_term_groups returns group_type::TEXT, but the cast comes
--    from the enum; recreate it after the type change.
-- ============================================================================

DROP FUNCTION IF EXISTS public.get_course_latest_term_groups(
  BIGINT, BIGINT, BIGINT, BIGINT, BIGINT
);

-- ============================================================================
-- 3. CONVERT THE COLUMNS TO TEXT
--    Must happen before the enum types are dropped, otherwise they are still
--    referenced by these columns.
-- ============================================================================

ALTER TABLE public.course_offering_group
  ALTER COLUMN group_type TYPE TEXT
  USING (group_type::TEXT);

ALTER TABLE public.study_plan
  ALTER COLUMN academic_degree TYPE TEXT
  USING (academic_degree::TEXT);

-- Now the enums are unreferenced and can go. A table cannot share a name with
-- an existing type, so they must be removed before the lookup tables are
-- created with the same names.
DROP TYPE IF EXISTS public.group_type;
DROP TYPE IF EXISTS public.academic_degree;

-- ============================================================================
-- 4. LOOKUP TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.group_type (
  code       TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 100,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.group_type IS
  'Catalogue of group delivery types published by the ITCR (REGULAR, VIRTUAL, ...). '
  'A lookup table instead of an enum so the sync can add new values without DDL.';
COMMENT ON COLUMN public.group_type.code IS
  'Value as published by the ITCR. Referenced by course_offering_group.group_type.';

CREATE TABLE IF NOT EXISTS public.academic_degree (
  code       TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 100,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.academic_degree IS
  'Academic degrees awarded by the institution. Lookup table so a new degree '
  'can be added without a DDL migration.';

CREATE TABLE IF NOT EXISTS public.course_type (
  code       TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 100,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.course_type IS
  'Course type classification as published by the ITCR (CURSO UNICO, ELECTIVA, ...). '
  'Values change over time, so this is a lookup rather than an enum.';

-- Timestamp triggers, same convention as the rest of the schema.
DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['group_type', 'academic_degree', 'course_type']
  LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_trigger WHERE tgname = 'set_timestamp_' || t
    ) THEN
      EXECUTE format(
        'CREATE TRIGGER set_timestamp_%I BEFORE UPDATE ON public.%I '
        'FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp()',
        t, t
      );
    END IF;
  END LOOP;
END $$;

-- ============================================================================
-- 6. SEED THE CATALOGUES
--    The known values get a sensible display name and order; anything else
--    already present in the data is appended so the FK can be created.
-- ============================================================================

INSERT INTO public.group_type (code, name, sort_order)
VALUES
  ('REGULAR', 'Regular', 1),
  ('SEMIPRESENCIAL', 'Semipresencial', 2),
  ('VIRTUAL', 'Virtual', 3),
  ('ASISTIDA', 'Asistida', 4),
  ('TUTORIA', 'Tutoría', 5),
  ('LABORATORIO', 'Laboratorio', 6),
  ('RN', 'RN', 7),
  ('ENSEÑANZA REMOTA', 'Enseñanza remota', 8),
  ('TRABAJO FINAL DE GRADUACIÓN', 'Trabajo final de graduación', 9),
  ('TALLER', 'Taller', 10)
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.academic_degree (code, name, sort_order)
VALUES
  ('ASOCIADO', 'Asociado', 1),
  ('BACHILLERATO UNIVERSITARIO', 'Bachillerato universitario', 2),
  ('DIPLOMADO', 'Diplomado', 3),
  ('DOCTORADO ACADÉMICO', 'Doctorado académico', 4),
  ('LICENCIATURA', 'Licenciatura', 5),
  ('MAESTRÍA', 'Maestría', 6),
  ('NO OTORGA', 'No otorga', 7)
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.course_type (code, name, sort_order)
VALUES
  ('CURSO UNICO', 'Curso único', 1),
  ('CURSO COMUN', 'Curso común', 2),
  ('ELECTIVA UNICA', 'Electiva única', 3),
  ('ELECTIVA COMUN', 'Electiva común', 4),
  ('LABORATORIO UNICO', 'Laboratorio único', 5),
  ('LABORATORIO COMUN', 'Laboratorio común', 6),
  ('OPTATIVO UNICO', 'Optativo único', 7),
  ('CENTROS DE FORMACION', 'Centros de formación', 8),
  ('TRABAJO FINAL DE GRADUACION', 'Trabajo final de graduación', 9)
ON CONFLICT (code) DO NOTHING;

-- Any value present in the data but absent from the list above is added, so the
-- migration never fails on an unexpected value. The sync reports new values.
INSERT INTO public.group_type (code, name)
SELECT DISTINCT
  g.group_type,
  initcap(lower(g.group_type))
FROM public.course_offering_group g
WHERE g.group_type IS NOT NULL
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.academic_degree (code, name)
SELECT DISTINCT
  sp.academic_degree,
  initcap(lower(sp.academic_degree))
FROM public.study_plan sp
WHERE sp.academic_degree IS NOT NULL
ON CONFLICT (code) DO NOTHING;

INSERT INTO public.course_type (code, name)
SELECT DISTINCT course_type, initcap(lower(course_type))
FROM public.course_offering
WHERE course_type IS NOT NULL
ON CONFLICT (code) DO NOTHING;

-- ============================================================================
-- 7. FOREIGN KEYS
--    ON UPDATE CASCADE so a catalogue rename propagates; ON DELETE RESTRICT so
--    a value in use cannot disappear from the catalogue by accident.
-- ============================================================================

ALTER TABLE public.course_offering_group
  DROP CONSTRAINT IF EXISTS course_offering_group_group_type_fkey;
ALTER TABLE public.course_offering_group
  ADD CONSTRAINT course_offering_group_group_type_fkey
  FOREIGN KEY (group_type) REFERENCES public.group_type(code)
  ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.study_plan
  DROP CONSTRAINT IF EXISTS study_plan_academic_degree_fkey;
ALTER TABLE public.study_plan
  ADD CONSTRAINT study_plan_academic_degree_fkey
  FOREIGN KEY (academic_degree) REFERENCES public.academic_degree(code)
  ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.course_offering
  DROP CONSTRAINT IF EXISTS course_offering_course_type_fkey;
ALTER TABLE public.course_offering
  ADD CONSTRAINT course_offering_course_type_fkey
  FOREIGN KEY (course_type) REFERENCES public.course_type(code)
  ON UPDATE CASCADE ON DELETE RESTRICT;

-- study_plan.academic_degree was made NOT NULL by 0149; keep it that way.
ALTER TABLE public.study_plan
  ALTER COLUMN academic_degree SET NOT NULL;

-- ============================================================================
-- 8. INDEXES FOR THE NEW FOREIGN KEYS
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_course_offering_group_group_type
  ON public.course_offering_group (group_type);
CREATE INDEX IF NOT EXISTS idx_course_offering_course_type
  ON public.course_offering (course_type);
CREATE INDEX IF NOT EXISTS idx_study_plan_academic_degree
  ON public.study_plan (academic_degree);

-- ============================================================================
-- 9. RECREATE v_schedule_courses
--    Same shape as 0146 (group_code padded to text, room-aware meetings).
-- ============================================================================

CREATE OR REPLACE VIEW public.v_schedule_courses
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
        'group_code', LPAD(g.group_code::TEXT, 2, '0'),
        'group_type', g.group_type,
        'capacity', g.capacity,
        'professors', (
          SELECT json_agg(
            jsonb_build_object('id', p.id, 'name', p.full_name)
            ORDER BY p.full_name
          )
          FROM public.professor p
          JOIN public.course_offering_group_professor cogp ON cogp.professor_id = p.id
          WHERE cogp.course_offering_group_id = g.id
            AND cogp.is_active = true
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
            AND com.is_active = true
        )
      ) ORDER BY g.group_code
    )
    FROM public.course_offering_group g
    WHERE g.course_offering_id = co.id
      AND g.is_active = true),
    '[]'::json
  ) AS groups
FROM public.course_offering co
JOIN public.course c ON co.course_id = c.id
JOIN public.academic_unit au ON co.academic_unit_id = au.id
JOIN public.academic_term at ON at.id = co.academic_term_id
WHERE co.is_active = true;

-- ============================================================================
-- 10. RECREATE THE STUDY PLAN VIEWS
--     academic_degree is TEXT now, so no cast is needed.
-- ============================================================================

CREATE VIEW public.v_study_plans_by_campus AS
SELECT DISTINCT
  sp.id,
  sp.academic_unit_id,
  sp.external_plan_id,
  sp.name,
  sp.academic_degree
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
  sp.academic_degree,
  am.name AS modality_name
FROM public.study_plan sp
JOIN public.academic_modality am ON sp.academic_modality_id = am.id
WHERE sp.is_active = true
  AND am.is_active = true
ORDER BY sp.name;

-- ============================================================================
-- 11. RECREATE get_course_latest_term_groups
--     group_type is TEXT now, so the ::TEXT cast is no longer needed.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_course_latest_term_groups(
  p_course_id bigint,
  p_campus_id bigint DEFAULT NULL::bigint,
  p_academic_unit_id bigint DEFAULT NULL::bigint,
  p_academic_term_id bigint DEFAULT NULL::bigint,
  p_study_plan_id bigint DEFAULT NULL::bigint
)
 RETURNS TABLE(
  academic_term_id bigint,
  term_display_name text,
  term_year integer,
  term_period_number integer,
  source_course_id bigint,
  source_course_code text,
  source_course_name text,
  group_id bigint,
  group_code text,
  group_type text,
  capacity integer,
  campus_id bigint,
  campus_name text,
  professors jsonb,
  meetings jsonb
 )
 LANGUAGE sql
 STABLE
 SET search_path TO 'public'
AS $function$
WITH placeholder_course AS (
  SELECT c.id AS course_id
  FROM public.course c
  JOIN public.schedule_equivalence_placeholder_course sep
    ON sep.is_active = TRUE
   AND (sep.study_plan_id IS NULL OR sep.study_plan_id = p_study_plan_id)
   AND (
     (sep.course_code IS NOT NULL AND sep.course_code = c.code)
     OR (
       sep.course_name_ilike_pattern IS NOT NULL
       AND c.name ILIKE sep.course_name_ilike_pattern
     )
   )
  WHERE c.id = p_course_id
  LIMIT 1
),
related_courses AS (
  SELECT p_course_id AS course_id
  UNION
  SELECT cr.to_course_id
  FROM public.course_relation cr
  WHERE p_study_plan_id IS NOT NULL
    AND EXISTS (SELECT 1 FROM placeholder_course)
    AND cr.study_plan_id = p_study_plan_id
    AND cr.relation_type = 'EQUIVALENT'
    AND cr.from_course_id = p_course_id
),
selected_term AS (
  SELECT
    at.id,
    at.display_name,
    at.year,
    at.period_number
  FROM public.course_offering co
  JOIN public.academic_term at ON at.id = co.academic_term_id
  WHERE co.course_id IN (SELECT course_id FROM related_courses)
    AND co.is_active = TRUE
    AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
    AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
    AND EXISTS (
      SELECT 1
      FROM public.course_offering_group g
      WHERE g.course_offering_id = co.id
        AND g.is_active = TRUE
    )
    AND (p_academic_term_id IS NULL OR at.id = p_academic_term_id)
  ORDER BY at.year DESC, at.period_number DESC, at.id DESC
  LIMIT 1
)
SELECT
  st.id AS academic_term_id,
  st.display_name AS term_display_name,
  st.year AS term_year,
  st.period_number AS term_period_number,
  c.id AS source_course_id,
  c.code AS source_course_code,
  c.name AS source_course_name,
  g.id AS group_id,
  LPAD(g.group_code::TEXT, 2, '0') AS group_code,
  g.group_type,
  g.capacity,
  co.campus_id,
  cp.name AS campus_name,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'id', p.id,
        'name', p.full_name
      )
      ORDER BY p.full_name
    )
    FROM public.course_offering_group_professor cogp
    JOIN public.professor p ON p.id = cogp.professor_id
    WHERE cogp.course_offering_group_id = g.id
      AND cogp.is_active = TRUE
  ), '[]'::jsonb) AS professors,
  COALESCE((
    SELECT jsonb_agg(
      jsonb_build_object(
        'weekday', com.weekday,
        'starts_at', com.starts_at::TEXT,
        'ends_at', com.ends_at::TEXT,
        'classroom', com.classroom
      )
      ORDER BY com.weekday, com.starts_at
    )
    FROM public.course_offering_meeting com
    WHERE com.course_offering_group_id = g.id
      AND com.is_active = TRUE
  ), '[]'::jsonb) AS meetings
FROM selected_term st
JOIN public.course_offering co ON co.academic_term_id = st.id
JOIN public.course c ON c.id = co.course_id
JOIN public.course_offering_group g ON g.course_offering_id = co.id
  AND g.is_active = TRUE
LEFT JOIN public.campus cp ON cp.id = co.campus_id
WHERE co.course_id IN (SELECT course_id FROM related_courses)
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
ORDER BY
  g.group_code,
  g.id;
$function$;

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns groups for a course in the selected academic term, or latest term with offerings when no term is provided. For placeholder courses, includes equivalents within the selected study plan and indicates source course for each group. Only returns active groups, meetings, and professor assignments.';

GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO authenticated;

-- ============================================================================
-- 12. GRANTS FOR THE NEW TABLES
-- ============================================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.group_type TO hyperdrive_role;
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.academic_degree TO hyperdrive_role;
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.course_type TO hyperdrive_role;
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO hyperdrive_role;
  END IF;
END $$;

COMMIT;
