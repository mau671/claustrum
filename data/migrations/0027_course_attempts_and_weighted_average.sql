-- 0027_course_attempts_and_weighted_average.sql
-- Moves student course tracking to attempt-based records and updates dashboard/KPIs.

BEGIN;

ALTER TABLE public.student_course_record
  ADD COLUMN IF NOT EXISTS attempt_number INTEGER,
  ADD COLUMN IF NOT EXISTS notes TEXT;

WITH ranked_attempts AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, study_plan_id, course_id
      ORDER BY recorded_at, id
    ) AS rn
  FROM public.student_course_record
)
UPDATE public.student_course_record scr
SET attempt_number = ra.rn
FROM ranked_attempts ra
WHERE scr.id = ra.id
  AND (scr.attempt_number IS NULL OR scr.attempt_number <> ra.rn);

ALTER TABLE public.student_course_record
  ALTER COLUMN attempt_number SET DEFAULT 1,
  ALTER COLUMN attempt_number SET NOT NULL;

ALTER TABLE public.student_course_record
DROP CONSTRAINT IF EXISTS student_course_record_user_course_plan_unique;

ALTER TABLE public.student_course_record
DROP CONSTRAINT IF EXISTS student_course_record_user_course_attempt_unique;

ALTER TABLE public.student_course_record
ADD CONSTRAINT student_course_record_user_course_attempt_unique
UNIQUE (user_id, study_plan_id, course_id, attempt_number);

ALTER TABLE public.student_course_record
DROP CONSTRAINT IF EXISTS student_course_record_grade_range_check;

ALTER TABLE public.student_course_record
ADD CONSTRAINT student_course_record_grade_range_check
CHECK (grade IS NULL OR (grade >= 0 AND grade <= 100));

CREATE INDEX IF NOT EXISTS idx_student_course_record_user_plan_course_attempt
ON public.student_course_record(user_id, study_plan_id, course_id, attempt_number DESC);

CREATE INDEX IF NOT EXISTS idx_student_course_record_user_plan_course_recorded
ON public.student_course_record(user_id, study_plan_id, course_id, recorded_at DESC);

DROP FUNCTION IF EXISTS public.update_student_course_status(UUID, BIGINT, BIGINT, TEXT);
DROP FUNCTION IF EXISTS public.update_student_course_status(UUID, INTEGER, INTEGER, TEXT);
DROP FUNCTION IF EXISTS public.update_student_course_status(UUID, INTEGER, INTEGER, student_course_status);
DROP FUNCTION IF EXISTS public.delete_student_course_status(UUID, BIGINT, BIGINT);
DROP FUNCTION IF EXISTS public.delete_student_course_status(UUID, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL,
  p_notes TEXT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_normalized_status public.student_course_status;
  v_next_attempt_number INTEGER;
  v_inserted_id BIGINT;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized to insert attempts for this user';
  END IF;

  v_normalized_status := UPPER(p_status)::public.student_course_status;

  IF v_normalized_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_normalized_status IN ('IN_PROGRESS', 'WITHDRAWN') AND p_grade IS NOT NULL THEN
    RAISE EXCEPTION 'Grade is only allowed for APPROVED and FAILED attempts';
  END IF;

  SELECT COALESCE(MAX(scr.attempt_number), 0) + 1
  INTO v_next_attempt_number
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.course_id = p_course_id;

  INSERT INTO public.student_course_record (
    user_id,
    study_plan_id,
    course_id,
    academic_term_id,
    attempt_number,
    status,
    grade,
    approved,
    notes,
    recorded_at
  )
  VALUES (
    p_user_id,
    p_study_plan_id,
    p_course_id,
    p_academic_term_id,
    v_next_attempt_number,
    v_normalized_status,
    p_grade,
    (v_normalized_status = 'APPROVED'),
    NULLIF(BTRIM(p_notes), ''),
    NOW()
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

COMMENT ON FUNCTION public.insert_student_course_attempt IS 'Registers a new attempt for a course, preserving retry history.';
GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt TO authenticated;

CREATE OR REPLACE FUNCTION public.get_user_course_effective_statuses(
  p_user_id UUID,
  p_study_plan_id BIGINT
)
RETURNS TABLE (
  course_id BIGINT,
  status public.student_course_status,
  grade NUMERIC(5,2),
  recorded_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
WITH latest_attempt AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.course_id,
    scr.status,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    scr.id
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
  ORDER BY scr.course_id, scr.recorded_at DESC NULLS LAST, scr.attempt_number DESC, scr.id DESC
),
latest_approved AS (
  SELECT DISTINCT ON (scr.course_id)
    scr.course_id,
    scr.grade,
    scr.recorded_at,
    scr.attempt_number,
    scr.id
  FROM public.student_course_record scr
  WHERE scr.user_id = p_user_id
    AND scr.study_plan_id = p_study_plan_id
    AND scr.status = 'APPROVED'
  ORDER BY scr.course_id, scr.recorded_at DESC NULLS LAST, scr.attempt_number DESC, scr.id DESC
)
SELECT
  la.course_id,
  CASE WHEN lap.course_id IS NOT NULL THEN 'APPROVED'::public.student_course_status ELSE la.status END AS status,
  COALESCE(lap.grade, la.grade) AS grade,
  COALESCE(lap.recorded_at, la.recorded_at) AS recorded_at
FROM latest_attempt la
LEFT JOIN latest_approved lap ON lap.course_id = la.course_id;
$$;

COMMENT ON FUNCTION public.get_user_course_effective_statuses IS 'Returns one effective status per course, preserving APPROVED if any approved attempt exists.';
GRANT EXECUTE ON FUNCTION public.get_user_course_effective_statuses TO authenticated;

CREATE OR REPLACE FUNCTION public.get_student_course_attempts(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT
)
RETURNS TABLE (
  id BIGINT,
  attempt_number INTEGER,
  status TEXT,
  grade NUMERIC(5,2),
  academic_term_id BIGINT,
  notes TEXT,
  recorded_at TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
SELECT
  scr.id,
  scr.attempt_number,
  LOWER(scr.status::TEXT) AS status,
  scr.grade,
  scr.academic_term_id,
  scr.notes,
  scr.recorded_at
FROM public.student_course_record scr
WHERE scr.user_id = p_user_id
  AND scr.study_plan_id = p_study_plan_id
  AND scr.course_id = p_course_id
ORDER BY scr.attempt_number DESC, scr.recorded_at DESC NULLS LAST, scr.id DESC;
$$;

COMMENT ON FUNCTION public.get_student_course_attempts IS 'Returns full attempt history for a course and user.';
GRANT EXECUTE ON FUNCTION public.get_student_course_attempts TO authenticated;

DROP FUNCTION IF EXISTS public.get_user_dashboard_stats(UUID, BIGINT);

CREATE OR REPLACE FUNCTION public.get_user_dashboard_stats(p_user_id UUID, p_study_plan_id BIGINT)
RETURNS JSON
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_stats JSON;
  v_semesters JSON;
  v_next_courses JSON;
BEGIN
  WITH plan_courses AS (
    SELECT splc.course_id, splc.credits, spl.level_number, spl.level_label
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  course_status AS (
    SELECT es.course_id, es.status, es.grade
    FROM public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) es
  ),
  course_stats AS (
    SELECT
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE cs.status = 'APPROVED') AS completed,
      COUNT(*) FILTER (WHERE cs.status = 'IN_PROGRESS') AS in_progress,
      COUNT(*) FILTER (WHERE cs.status = 'FAILED') AS failed,
      COUNT(*) FILTER (WHERE cs.status = 'WITHDRAWN') AS withdrawn,
      SUM(pc.credits) AS total_credits,
      SUM(pc.credits) FILTER (WHERE cs.status = 'APPROVED') AS completed_credits,
      SUM((COALESCE(cs.grade, 0) * pc.credits)::numeric) AS weighted_grade_sum
    FROM plan_courses pc
    LEFT JOIN course_status cs ON cs.course_id = pc.course_id
  )
  SELECT json_build_object(
    'totalCourses', COALESCE((SELECT total FROM course_stats), 0),
    'completedCourses', COALESCE((SELECT completed FROM course_stats), 0),
    'inProgressCourses', COALESCE((SELECT in_progress FROM course_stats), 0),
    'failedCourses', COALESCE((SELECT failed FROM course_stats), 0),
    'withdrawnCourses', COALESCE((SELECT withdrawn FROM course_stats), 0),
    'notTakenCourses', GREATEST(
      COALESCE((SELECT total FROM course_stats), 0)
      - (COALESCE((SELECT completed FROM course_stats), 0)
        + COALESCE((SELECT in_progress FROM course_stats), 0)
        + COALESCE((SELECT failed FROM course_stats), 0)
        + COALESCE((SELECT withdrawn FROM course_stats), 0)),
      0
    ),
    'totalCredits', COALESCE((SELECT total_credits FROM course_stats), 0),
    'completedCredits', COALESCE((SELECT completed_credits FROM course_stats), 0),
    'currentSemester', COALESCE((
      SELECT MAX(pc.level_number)
      FROM plan_courses pc
      JOIN course_status cs ON cs.course_id = pc.course_id
      WHERE cs.status IN ('APPROVED', 'IN_PROGRESS')
    ), 0),
    'progressPercentage', CASE
      WHEN (SELECT total FROM course_stats) > 0 THEN
        ROUND(((SELECT completed FROM course_stats)::numeric / (SELECT total FROM course_stats)::numeric) * 100)::int
      ELSE 0
    END,
    'weightedAverage', CASE
      WHEN COALESCE((SELECT total_credits FROM course_stats), 0) > 0 THEN
        ROUND(
          COALESCE((SELECT weighted_grade_sum FROM course_stats), 0)::numeric
          / (SELECT total_credits FROM course_stats)::numeric,
          2
        )
      ELSE 0
    END
  ) INTO v_stats;

  SELECT json_agg(
    json_build_object(
      'levelNumber', sem.level_number,
      'levelLabel', sem.level_label,
      'totalCourses', sem.total,
      'completedCourses', sem.completed,
      'credits', sem.credits,
      'completedCredits', sem.completed_credits,
      'status', CASE
        WHEN sem.completed = sem.total THEN 'completed'
        WHEN sem.completed > 0 OR sem.in_progress > 0 THEN 'in_progress'
        ELSE 'pending'
      END
    ) ORDER BY sem.level_number
  ) INTO v_semesters
  FROM (
    SELECT
      spl.level_number,
      spl.level_label,
      COUNT(*) AS total,
      COUNT(*) FILTER (WHERE ucs.status = 'APPROVED') AS completed,
      SUM(splc.credits) AS credits,
      SUM(splc.credits) FILTER (WHERE ucs.status = 'APPROVED') AS completed_credits,
      COUNT(*) FILTER (WHERE ucs.status = 'IN_PROGRESS') AS in_progress
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    LEFT JOIN public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) ucs
      ON ucs.course_id = splc.course_id
    WHERE spl.study_plan_id = p_study_plan_id
    GROUP BY spl.level_number, spl.level_label
  ) sem;

  WITH plan_courses AS (
    SELECT
      splc.course_id,
      spl.level_number,
      spl.level_label,
      splc.credits,
      c.code,
      c.name
    FROM public.study_plan_level_course splc
    JOIN public.study_plan_level spl ON splc.study_plan_level_id = spl.id
    JOIN public.course c ON c.id = splc.course_id
    WHERE spl.study_plan_id = p_study_plan_id
  ),
  course_status AS (
    SELECT es.course_id, es.status
    FROM public.get_user_course_effective_statuses(p_user_id, p_study_plan_id) es
  ),
  candidate_courses AS (
    SELECT
      pc.course_id,
      pc.code,
      pc.name,
      pc.credits,
      pc.level_number,
      pc.level_label,
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
    JOIN public.course prereq ON cr.to_course_id = prereq.id
    LEFT JOIN course_status cs ON cs.course_id = cr.to_course_id
    WHERE cr.study_plan_id = p_study_plan_id
      AND cr.relation_type = 'PREREQUISITE'
  ),
  prereq_eligible AS (
    SELECT
      c.course_id,
      c.code,
      c.name,
      c.credits,
      c.level_number,
      c.level_label,
      c.status,
      COALESCE((
        SELECT array_agg(p.prereq_code ORDER BY p.prereq_code)
        FROM prereq_status p
        WHERE p.course_id = c.course_id
      ), ARRAY[]::text[]) AS prerequisites
    FROM candidate_courses c
    LEFT JOIN prereq_status p ON p.course_id = c.course_id
    GROUP BY c.course_id, c.code, c.name, c.credits, c.level_number, c.level_label, c.status
    HAVING COUNT(p.prereq_code) FILTER (WHERE p.prereq_code IS NOT NULL)
         = COUNT(p.prereq_code) FILTER (WHERE p.prereq_status = 'APPROVED')
  ),
  coreq_check AS (
    SELECT
      cr.from_course_id AS course_id,
      cr.to_course_id AS coreq_course_id
    FROM public.course_relation cr
    WHERE cr.study_plan_id = p_study_plan_id
      AND cr.relation_type = 'COREQUISITE'
  ),
  next_courses AS (
    SELECT
      e.course_id::text AS id,
      e.code,
      e.name,
      e.credits,
      e.level_number,
      e.level_label AS levelLabel,
      e.status,
      e.prerequisites
    FROM prereq_eligible e
    WHERE NOT EXISTS (
      SELECT 1
      FROM coreq_check cc
      WHERE cc.course_id = e.course_id
        AND cc.coreq_course_id NOT IN (SELECT course_id FROM prereq_eligible)
        AND cc.coreq_course_id NOT IN (
          SELECT course_id FROM course_status WHERE status = 'APPROVED'
        )
    )
    ORDER BY e.level_number,
      CASE WHEN e.status IS NULL THEN 0 ELSE 1 END,
      e.code
    LIMIT 10
  )
  SELECT json_agg(json_build_object(
    'id', id,
    'code', code,
    'name', name,
    'credits', credits,
    'levelLabel', levelLabel,
    'prerequisites', prerequisites
  )) INTO v_next_courses
  FROM next_courses;

  RETURN json_build_object(
    'stats', v_stats,
    'semesters', COALESCE(v_semesters, '[]'::json),
    'nextCourses', COALESCE(v_next_courses, '[]'::json)
  );
END;
$$;

COMMENT ON FUNCTION public.get_user_dashboard_stats IS 'Returns dashboard statistics and weighted average for a user study plan based on course attempts.';
GRANT EXECUTE ON FUNCTION public.get_user_dashboard_stats TO authenticated;

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
      WHERE c.code IN ('SE1100', 'SE1200', 'SE1400')
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

COMMIT;
