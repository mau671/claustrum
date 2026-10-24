-- 0146_group_code_smallint.sql
-- Converts course_offering_group.group_code from TEXT to SMALLINT.
--
-- Why: every value is numeric ('01'..'97'). Storing identifiers as padded text
-- means '01' and '001' are different keys, so a change in the upstream padding
-- silently duplicates every group and soft-deletes the originals. That is
-- exactly what happened in the 2026-10-23 offering seed: 4609 inserts against
-- 4253 soft-deletes with zero overlap. As SMALLINT the unique constraint
-- rejects the duplicate and the sync fails loudly instead.
--
-- SMALLINT instead of INTEGER: the domain is bounded by the number of groups a
-- single offering can have. 32767 is far beyond any real course, and the
-- narrower type keeps the composite unique index smaller on a table that grows
-- every term.
--
-- The public contract is unchanged: every function that exposes group_code
-- keeps returning TEXT, so the frontend, the ICS export and the Effect schemas
-- do not change. The cast back to text happens at the boundary.

BEGIN;

-- ============================================================================
-- 1. PRECHECK: fail fast instead of corrupting data
-- ============================================================================

DO $$
DECLARE
  bad_count BIGINT;
  bad_examples TEXT;
  overflow_count BIGINT;
BEGIN
  SELECT count(*), string_agg(DISTINCT group_code, ', ')
  INTO bad_count, bad_examples
  FROM public.course_offering_group
  WHERE group_code !~ '^[0-9]+$';

  IF bad_count > 0 THEN
    RAISE EXCEPTION
      'Cannot convert group_code to SMALLINT: % non-numeric value(s) found: %',
      bad_count, bad_examples;
  END IF;

  SELECT count(*) INTO overflow_count
  FROM public.course_offering_group
  WHERE group_code::BIGINT > 32767;

  IF overflow_count > 0 THEN
    RAISE EXCEPTION
      'Cannot convert group_code to SMALLINT: % value(s) exceed 32767',
      overflow_count;
  END IF;
END $$;

-- ============================================================================
-- 2. DROP DEPENDENT OBJECTS
--    CREATE OR REPLACE cannot change a return type, so the two functions that
--    return group_code must be dropped and recreated.
-- ============================================================================

DROP FUNCTION IF EXISTS public.get_course_latest_term_groups(
  BIGINT, BIGINT, BIGINT, BIGINT, BIGINT
);
DROP FUNCTION IF EXISTS public.get_user_saved_schedule_group_lookups(BIGINT);

-- The view embeds group_code in a json_agg, which makes it a hard dependency
-- for ALTER COLUMN TYPE. Drop it here and recreate it in section 5.
DROP VIEW IF EXISTS public.v_schedule_courses;

-- ============================================================================
-- 3. CONVERT THE COLUMN
--    The USING cast normalises '01' -> 1, which is the point: values that only
--    differed by padding collapse to the same key.
-- ============================================================================

ALTER TABLE public.course_offering_group
  ALTER COLUMN group_code TYPE SMALLINT
  USING (group_code::SMALLINT);

COMMENT ON COLUMN public.course_offering_group.group_code IS
  'Group identifier within the offering, stored as an integer (0..999). '
  'Render with LPAD(group_code::TEXT, 2, ''0'') when displaying (e.g. "01").';

-- Domain guard: the TEC issues 2 digits today, but allow up to 3 so a course
-- with 100+ groups does not require another migration.
ALTER TABLE public.course_offering_group
  DROP CONSTRAINT IF EXISTS course_offering_group_code_range_check;
ALTER TABLE public.course_offering_group
  ADD CONSTRAINT course_offering_group_code_range_check
  CHECK (group_code BETWEEN 0 AND 999);

-- ============================================================================
-- 4. VERIFY THE UNIQUE CONSTRAINT SURVIVED
--    ALTER COLUMN TYPE rebuilds it, but assert so the duplicate-detection
--    guarantee is not silently lost.
-- ============================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'public.course_offering_group'::regclass
      AND contype = 'u'
      AND pg_get_constraintdef(oid) LIKE '%course_offering_id, group_code%'
  ) THEN
    ALTER TABLE public.course_offering_group
      ADD CONSTRAINT course_offering_group_offering_group_code_key
      UNIQUE (course_offering_id, group_code);
  END IF;
END $$;

-- ============================================================================
-- 5. RECREATE v_schedule_courses
--    Identical to 0119 except group_code is cast back to text inside the JSON
--    payload, preserving the shape the frontend already consumes.
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

COMMENT ON VIEW public.v_schedule_courses IS 'Course offerings with groups, professors, and meetings for schedule display. group_code is exposed as text for API compatibility.';

-- ============================================================================
-- 6. RECREATE get_course_latest_term_groups
--    Body is identical to 0101 except:
--      - g.group_code -> g.group_code::TEXT in the SELECT (return type is TEXT)
--      - the ORDER BY no longer needs the regex/CASE guard, since the column is
--        now a real integer; ordering by it directly is equivalent and cheaper.
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
  g.group_type::TEXT AS group_type,
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

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns groups for a course in the selected academic term, or latest term with offerings when no term is provided. For placeholder courses, includes equivalents within the selected study plan and indicates source course for each group. Only returns active groups, meetings, and professor assignments. group_code is exposed as text for API compatibility.';

GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO anon;
GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO authenticated;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 7. RECREATE get_user_saved_schedule_group_lookups
--    Only change: group_code::TEXT in the SELECT list.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_user_saved_schedule_group_lookups(
  p_saved_schedule_id BIGINT
)
RETURNS TABLE (course_code TEXT, campus_id BIGINT, group_code TEXT)
LANGUAGE SQL
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT c.code AS course_code, co.campus_id, LPAD(cog.group_code::TEXT, 2, '0') AS group_code
  FROM public.saved_schedule ss
  JOIN public.saved_schedule_item ssi ON ssi.saved_schedule_id = ss.id
  JOIN public.course_offering_group cog ON cog.id = ssi.course_offering_group_id
  JOIN public.course_offering co ON co.id = cog.course_offering_id
  JOIN public.course c ON c.id = co.course_id
  WHERE ss.id = p_saved_schedule_id
    AND ss.user_id = public.current_user_id()
  ORDER BY c.code, co.campus_id, cog.group_code;
$$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    GRANT EXECUTE ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) TO hyperdrive_role;
  END IF;
END $$;

-- ============================================================================
-- 8. save_user_schedule
--    It compares cog.group_code = rg.group_code, where group_code came from a
--    JSON text field. Cast the JSON value to SMALLINT. Using a regex guard
--    means a malformed value is skipped instead of raising a cast error, and
--    both '01' and '1' resolve to the same row.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.save_user_schedule(
  p_user_id uuid,
  p_name text,
  p_academic_term_id bigint,
  p_group_lookups jsonb
)
RETURNS TABLE(id bigint, name text, academic_term_id bigint, created_at timestamp with time zone, updated_at timestamp with time zone)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
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
      (item->>'groupCode')::SMALLINT AS group_code
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'offeringId'
      AND item ? 'groupCode'
      AND item->>'offeringId' ~ '^\d+$'
      AND trim(item->>'groupCode') ~ '^\d+$'
      AND trim(item->>'groupCode')::BIGINT <= 32767
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
$function$;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    GRANT EXECUTE ON FUNCTION public.save_user_schedule(UUID, TEXT, BIGINT, JSONB) TO hyperdrive_role;
  END IF;
END $$;

COMMIT;
