-- 0158_group_code_unpadded_public_contract.sql
-- Stops padding group_code with artificial leading zeros and fixes saved-schedule
-- resolution after the TEXT -> SMALLINT conversion in 0146.
--
-- Two problems this migration solves:
--
-- 1. The public contract still returned zero-padded codes ('01', '02') through
--    v_schedule_courses and get_course_latest_term_groups even though the
--    column is SMALLINT. Padding is now produced nowhere: the single source of
--    truth is the numeric value cast to text ('1', '2', '20'). This also
--    removes the mismatch that broke loading saved schedules, because
--    GET /schedules/:id/items already returned the unpadded value.
--
-- 2. save_user_schedule regressed in 0143/0146 to a JSON contract requiring
--    `offeringId` while every caller (apps/api, apps/web) sends `courseCode`
--    plus `groupCode`. The lookup matched zero rows, so saving created an
--    empty schedule header. Resolution is now by (course code, group code,
--    academic term), which is unique across campuses for ITCR offerings, and
--    an empty result rolls the header back instead of persisting it.

BEGIN;

-- ============================================================================
-- 1. v_schedule_courses: expose the raw SMALLINT as text
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
        'group_code', g.group_code::TEXT,
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

COMMENT ON VIEW public.v_schedule_courses IS 'Flat course offerings for the schedule builder. group_code is the raw SMALLINT rendered as text, without leading zeros.';

-- ============================================================================
-- 2. get_course_latest_term_groups: same contract, no padding
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
  g.group_code::TEXT AS group_code,
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

COMMENT ON FUNCTION public.get_course_latest_term_groups IS 'Returns groups for a course in the selected academic term, or latest term with offerings when no term is provided. For placeholder courses, includes equivalents within the selected study plan and indicates source course for each group. Only returns active groups, meetings, and professor assignments. group_code is the raw SMALLINT rendered as text, without leading zeros.';

-- ============================================================================
-- 3. save_user_schedule: resolve groups by (course code, group code, term)
--    No offeringId required. campusId stays accepted but is only a tiebreaker,
--    because a course never repeats a group number across campuses in a term.
--    An unmatched payload rolls back the schedule header instead of leaving an
--    orphan empty schedule.
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
  v_inserted_count INTEGER;
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
      upper(trim(item->>'courseCode')) AS course_code,
      (trim(item->>'groupCode'))::SMALLINT AS group_code,
      CASE
        WHEN item ? 'campusId' AND item->>'campusId' ~ '^\d+$'
          THEN (item->>'campusId')::BIGINT
        ELSE NULL
      END AS campus_id
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'courseCode'
      AND item ? 'groupCode'
      AND trim(item->>'courseCode') <> ''
      AND trim(item->>'groupCode') ~ '^\d+$'
      AND trim(item->>'groupCode')::BIGINT BETWEEN 0 AND 32767
  ),
  resolved_groups AS (
    SELECT DISTINCT ON (rg.course_code, rg.group_code)
      cog.id AS course_offering_group_id
    FROM requested_groups rg
    JOIN public.course c
      ON c.code = rg.course_code
    JOIN public.course_offering co
      ON co.course_id = c.id
     AND co.academic_term_id = p_academic_term_id
     AND co.is_active = true
    JOIN public.course_offering_group cog
      ON cog.course_offering_id = co.id
     AND cog.group_code = rg.group_code
     AND (cog.is_active IS NULL OR cog.is_active = true)
    ORDER BY
      rg.course_code,
      rg.group_code,
      (rg.campus_id IS NOT NULL AND co.campus_id = rg.campus_id) DESC,
      co.id
  ),
  inserted_items AS (
    INSERT INTO public.saved_schedule_item (
      saved_schedule_id,
      course_offering_group_id
    )
    SELECT DISTINCT
      v_schedule_id,
      rg.course_offering_group_id
    FROM resolved_groups rg
    ON CONFLICT (saved_schedule_id, course_offering_group_id) DO NOTHING
    RETURNING 1
  )
  SELECT count(*) INTO v_inserted_count
  FROM inserted_items;

  IF v_inserted_count = 0 THEN
    DELETE FROM public.saved_schedule WHERE saved_schedule.id = v_schedule_id;
    RAISE EXCEPTION 'No se encontraron grupos validos para guardar' USING ERRCODE = '22023';
  END IF;

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

COMMENT ON FUNCTION public.save_user_schedule(uuid, text, bigint, jsonb) IS 'Creates a saved schedule for p_user_id. Groups are resolved by (course code, group code, academic term); group code may arrive padded or not. Fails and rolls back when no group matches.';

-- ============================================================================
-- 4. Re-affirm grants (CREATE OR REPLACE preserves them, but keep it explicit)
-- ============================================================================

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_role') THEN
    GRANT EXECUTE ON FUNCTION public.save_user_schedule(UUID, TEXT, BIGINT, JSONB) TO hyperdrive_role;
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO hyperdrive_role;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT EXECUTE ON FUNCTION public.save_user_schedule(UUID, TEXT, BIGINT, JSONB) TO hyperdrive_user;
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO hyperdrive_user;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO anon;
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT EXECUTE ON FUNCTION public.get_course_latest_term_groups(BIGINT, BIGINT, BIGINT, BIGINT, BIGINT) TO authenticated;
  END IF;
END $$;

COMMIT;
