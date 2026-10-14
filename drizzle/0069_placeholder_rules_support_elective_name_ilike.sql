-- 0069_placeholder_rules_support_elective_name_ilike.sql

BEGIN;

ALTER TABLE public.schedule_equivalence_placeholder_course
  ADD COLUMN IF NOT EXISTS study_plan_id BIGINT REFERENCES public.study_plan(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS course_name_ilike_pattern TEXT;

ALTER TABLE public.schedule_equivalence_placeholder_course
  ALTER COLUMN course_code DROP NOT NULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'schedule_equivalence_placeholder_course_match_check'
  ) THEN
    ALTER TABLE public.schedule_equivalence_placeholder_course
      ADD CONSTRAINT schedule_equivalence_placeholder_course_match_check
      CHECK (
        course_code IS NOT NULL
        OR course_name_ilike_pattern IS NOT NULL
      );
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_schedule_equivalence_placeholder_course_active_plan
  ON public.schedule_equivalence_placeholder_course(is_active, study_plan_id);

INSERT INTO public.schedule_equivalence_placeholder_course (
  course_code,
  course_name_ilike_pattern,
  study_plan_id,
  is_active
)
SELECT
  NULL,
  '%electiva%',
  NULL,
  TRUE
WHERE NOT EXISTS (
  SELECT 1
  FROM public.schedule_equivalence_placeholder_course sep
  WHERE sep.course_code IS NULL
    AND sep.study_plan_id IS NULL
    AND sep.course_name_ilike_pattern = '%electiva%'
);

CREATE OR REPLACE FUNCTION public.get_schedule_courses(
  p_user_id UUID,
  p_academic_term_id BIGINT,
  p_campus_id BIGINT,
  p_study_plan_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_include_other_campuses BOOLEAN DEFAULT false,
  p_show_all_courses BOOLEAN DEFAULT true
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
  level_number INTEGER,
  level_label TEXT,
  sort_order INTEGER
)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  IF p_user_id IS NULL THEN
    IF p_study_plan_id IS NOT NULL THEN
      RETURN QUERY
      SELECT *
      FROM public.get_schedule_courses_by_study_plan(
        p_academic_term_id,
        p_campus_id,
        p_study_plan_id,
        p_include_other_campuses
      );
      RETURN;
    END IF;

    IF p_academic_unit_id IS NOT NULL THEN
      RETURN QUERY
      SELECT *
      FROM public.get_schedule_courses_by_academic_unit(
        p_academic_term_id,
        p_campus_id,
        p_academic_unit_id,
        p_include_other_campuses
      );
      RETURN;
    END IF;

    RETURN;
  END IF;

  IF p_study_plan_id IS NOT NULL THEN
    RETURN QUERY
    WITH plan_courses AS (
      SELECT
        splc.course_id,
        spl.level_number,
        spl.level_label,
        splc.sort_order
      FROM public.study_plan_level_course splc
      JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
      WHERE spl.study_plan_id = p_study_plan_id
    ),
    placeholder_courses AS (
      SELECT pc.course_id, pc.level_number, pc.level_label, pc.sort_order
      FROM plan_courses pc
      JOIN public.course c ON c.id = pc.course_id
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
    ),
    equivalent_courses AS (
      SELECT DISTINCT
        cr.to_course_id AS course_id,
        pc.level_number,
        pc.level_label,
        pc.sort_order
      FROM public.course_relation cr
      JOIN placeholder_courses pc ON pc.course_id = cr.from_course_id
      WHERE cr.study_plan_id = p_study_plan_id
        AND cr.relation_type = 'EQUIVALENT'
    ),
    course_status AS (
      SELECT es.course_id, es.status
      FROM public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) es
    ),
    candidate_courses AS (
      SELECT
        pc.course_id,
        pc.level_number,
        pc.level_label,
        pc.sort_order,
        cs.status
      FROM plan_courses pc
      LEFT JOIN course_status cs ON cs.course_id = pc.course_id
      WHERE cs.status IS NULL OR cs.status IN ('FAILED', 'WITHDRAWN')
    ),
    prereq_status AS (
      SELECT
        cr.from_course_id AS course_id,
        prereq.code AS prereq_code,
        cs.status AS prereq_status
      FROM public.course_relation cr
      JOIN plan_courses pc ON pc.course_id = cr.from_course_id
      JOIN public.course prereq ON cr.to_course_id = prereq.id
      LEFT JOIN course_status cs ON cs.course_id = cr.to_course_id
      WHERE cr.study_plan_id = p_study_plan_id
        AND cr.relation_type = 'PREREQUISITE'
    ),
    prereq_eligible AS (
      SELECT
        c.course_id,
        c.level_number,
        c.level_label,
        c.sort_order,
        c.status
      FROM candidate_courses c
      LEFT JOIN prereq_status p ON p.course_id = c.course_id
      GROUP BY c.course_id, c.level_number, c.level_label, c.sort_order, c.status
      HAVING COUNT(p.prereq_code) FILTER (WHERE p.prereq_code IS NOT NULL)
           = COUNT(p.prereq_code) FILTER (WHERE p.prereq_status = 'APPROVED')
    ),
    coreq_check AS (
      SELECT
        cr.from_course_id AS course_id,
        cr.to_course_id AS coreq_course_id
      FROM public.course_relation cr
      JOIN plan_courses pc ON pc.course_id = cr.from_course_id
      WHERE cr.study_plan_id = p_study_plan_id
        AND cr.relation_type = 'COREQUISITE'
    ),
    eligible_courses AS (
      SELECT DISTINCT ON (e.course_id)
        e.course_id,
        e.level_number,
        e.level_label,
        e.sort_order
      FROM prereq_eligible e
      WHERE NOT EXISTS (
        SELECT 1
        FROM coreq_check cc
        WHERE cc.course_id = e.course_id
          AND cc.coreq_course_id NOT IN (SELECT pe.course_id FROM prereq_eligible pe)
          AND cc.coreq_course_id NOT IN (
            SELECT cs.course_id FROM course_status cs WHERE cs.status = 'APPROVED'
          )
      )
    ),
    eligible_equivalents AS (
      SELECT DISTINCT
        cr.to_course_id AS course_id,
        pc.level_number,
        pc.level_label,
        pc.sort_order
      FROM eligible_courses e
      JOIN placeholder_courses pc ON pc.course_id = e.course_id
      JOIN public.course_relation cr ON cr.study_plan_id = p_study_plan_id
        AND cr.from_course_id = pc.course_id
        AND cr.relation_type = 'EQUIVALENT'
    ),
    final_courses AS (
      SELECT pc.course_id, pc.level_number, pc.level_label, pc.sort_order
      FROM plan_courses pc
      WHERE p_show_all_courses = true
      UNION
      SELECT ec.course_id, ec.level_number, ec.level_label, ec.sort_order
      FROM eligible_courses ec
      UNION
      SELECT eq.course_id, eq.level_number, eq.level_label, eq.sort_order
      FROM equivalent_courses eq
      WHERE p_show_all_courses = true
      UNION
      SELECT ee.course_id, ee.level_number, ee.level_label, ee.sort_order
      FROM eligible_equivalents ee
    ),
    ordered_courses AS (
      SELECT DISTINCT ON (fc.course_id)
        fc.course_id,
        fc.level_number,
        fc.level_label,
        fc.sort_order
      FROM final_courses fc
      ORDER BY fc.course_id, fc.level_number, fc.sort_order
    ),
    schedule_courses AS (
      SELECT v.offering_id,
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
        COALESCE(oc.level_number, 999) AS level_number,
        oc.level_label,
        COALESCE(oc.sort_order, 999) AS sort_order
      FROM public.v_schedule_courses v
      JOIN ordered_courses oc ON oc.course_id = v.course_id
      WHERE v.academic_term_id = p_academic_term_id
        AND (p_include_other_campuses OR v.campus_id = p_campus_id)
        AND (v.groups::jsonb <> '[]'::jsonb)
    ),
    base_courses AS (
      SELECT DISTINCT ON (sc.course_code)
        sc.offering_id,
        sc.course_id,
        sc.course_code,
        sc.course_name,
        sc.credits,
        sc.weekly_hours,
        sc.course_type,
        sc.academic_unit_id,
        sc.academic_unit_name,
        sc.campus_id,
        sc.academic_term_id,
        sc.term_display_name,
        sc.level_number,
        sc.level_label,
        sc.sort_order
      FROM schedule_courses sc
      ORDER BY sc.course_code, (sc.campus_id = p_campus_id) DESC, sc.offering_id
    ),
    unique_group_rows AS (
      SELECT DISTINCT ON (sc.course_code, (g.value->>'group_id'), sc.campus_id)
        sc.course_code,
        (g.value || jsonb_build_object('campus_id', sc.campus_id)) AS group_obj
      FROM schedule_courses sc
      JOIN LATERAL jsonb_array_elements(sc.groups::jsonb) AS g(value) ON true
      ORDER BY sc.course_code, (g.value->>'group_id'), sc.campus_id
    ),
    grouped AS (
      SELECT ugr.course_code,
        json_agg(
          ugr.group_obj
          ORDER BY (ugr.group_obj->>'group_code')::int, (ugr.group_obj->>'campus_id')::int
        ) AS groups
      FROM unique_group_rows ugr
      GROUP BY ugr.course_code
    )
    SELECT bc.offering_id,
      bc.course_id,
      bc.course_code,
      bc.course_name,
      bc.credits,
      bc.weekly_hours,
      bc.course_type,
      bc.academic_unit_id,
      bc.academic_unit_name,
      bc.campus_id,
      bc.academic_term_id,
      bc.term_display_name,
      grouped.groups,
      bc.level_number,
      bc.level_label,
      bc.sort_order
    FROM base_courses bc
    JOIN grouped ON grouped.course_code = bc.course_code
    ORDER BY bc.level_number, bc.sort_order, bc.course_code;
    RETURN;
  END IF;

  IF p_academic_unit_id IS NOT NULL THEN
    RETURN QUERY
    SELECT *
    FROM public.get_schedule_courses_by_academic_unit(
      p_academic_term_id,
      p_campus_id,
      p_academic_unit_id,
      p_include_other_campuses
    );
    RETURN;
  END IF;

  RETURN;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_course_offering_terms(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_study_plan_id BIGINT DEFAULT NULL
)
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
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
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
)
SELECT DISTINCT
  at.id,
  at.academic_modality_id,
  at.year,
  at.period_number,
  at.external_key,
  at.display_name,
  at.starts_on,
  at.ends_on
FROM public.course_offering co
JOIN public.academic_term at ON at.id = co.academic_term_id
WHERE co.course_id IN (SELECT course_id FROM related_courses)
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
  AND EXISTS (
    SELECT 1
    FROM public.course_offering_group cog
    WHERE cog.course_offering_id = co.id
  )
ORDER BY at.year DESC, at.period_number DESC, at.id DESC;
$$;

CREATE OR REPLACE FUNCTION public.get_course_latest_term_groups(
  p_course_id BIGINT,
  p_campus_id BIGINT DEFAULT NULL,
  p_academic_unit_id BIGINT DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS TABLE (
  academic_term_id BIGINT,
  term_display_name TEXT,
  term_year INTEGER,
  term_period_number INTEGER,
  group_id BIGINT,
  group_code TEXT,
  group_type TEXT,
  capacity INTEGER,
  campus_id BIGINT,
  campus_name TEXT,
  professors JSONB,
  meetings JSONB
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
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
  g.id AS group_id,
  g.group_code,
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
  ), '[]'::jsonb) AS meetings
FROM selected_term st
JOIN public.course_offering co ON co.academic_term_id = st.id
JOIN public.course_offering_group g ON g.course_offering_id = co.id
LEFT JOIN public.campus cp ON cp.id = co.campus_id
WHERE co.course_id IN (SELECT course_id FROM related_courses)
  AND co.is_active = TRUE
  AND (p_campus_id IS NULL OR co.campus_id = p_campus_id)
  AND (p_academic_unit_id IS NULL OR co.academic_unit_id = p_academic_unit_id)
ORDER BY
  CASE WHEN g.group_code ~ '^[0-9]+$' THEN (g.group_code)::INT ELSE 99999 END,
  g.group_code,
  g.id;
$$;

COMMENT ON TABLE public.schedule_equivalence_placeholder_course
IS 'Configurable placeholder matching rules for equivalent schedule expansion. Supports direct code matches and name ILIKE patterns, optionally scoped by study plan.';

COMMIT;
