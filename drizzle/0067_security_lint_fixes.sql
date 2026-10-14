-- 0067_security_lint_fixes.sql
-- Fixes Supabase Security Advisor warnings:
-- 1) RLS disabled on sync_seed_run, schedule_equivalence_placeholder_course
-- 2) function_search_path_mutable on get_course_evaluations
-- 3) extension_in_public for unaccent
-- 4) anon/authenticated can execute SECURITY DEFINER functions

BEGIN;

-- ============================================================================
-- 1. Move unaccent extension out of public schema
-- ============================================================================
CREATE SCHEMA IF NOT EXISTS extensions;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_extension e
    JOIN pg_namespace n ON n.oid = e.extnamespace
    WHERE e.extname = 'unaccent'
      AND n.nspname = 'public'
  ) THEN
    ALTER EXTENSION unaccent SET SCHEMA extensions;
  END IF;
END $$;

-- ============================================================================
-- 2. Enable RLS on tables missing it
-- ============================================================================
ALTER TABLE public.sync_seed_run ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedule_equivalence_placeholder_course ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read sync seed runs" ON public.sync_seed_run;
CREATE POLICY "Authenticated users can read sync seed runs"
ON public.sync_seed_run
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Public can read schedule equivalence placeholder courses" ON public.schedule_equivalence_placeholder_course;
CREATE POLICY "Public can read schedule equivalence placeholder courses"
ON public.schedule_equivalence_placeholder_course
FOR SELECT
TO anon, authenticated
USING (true);

-- ============================================================================
-- 3. Fix get_course_evaluations — add SET search_path (no SECURITY DEFINER issue)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_course_evaluations(p_course_id INT)
RETURNS TABLE (
  id BIGINT,
  course_id INT,
  academic_term_id INT,
  professor_id BIGINT,
  evaluation_type TEXT,
  evaluation_number INT,
  custom_name TEXT,
  is_catedra BOOLEAN,
  includes_answers BOOLEAN,
  has_separate_answers BOOLEAN,
  file_key TEXT,
  file_size BIGINT,
  answers_file_key TEXT,
  status TEXT,
  created_at TIMESTAMPTZ,
  term_display_name TEXT,
  professor_name TEXT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    e.id,
    e.course_id,
    e.academic_term_id,
    e.professor_id,
    e.evaluation_type::TEXT,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::TEXT,
    e.created_at,
    at.display_name AS term_display_name,
    p.full_name AS professor_name
  FROM public.course_evaluations e
  LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
  LEFT JOIN public.professor p ON p.id = e.professor_id
  WHERE e.course_id = p_course_id
    AND e.status = 'approved'
  ORDER BY e.created_at DESC;
$$;

REVOKE ALL ON FUNCTION public.get_course_evaluations(INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_course_evaluations(INT) TO anon, authenticated;

-- ============================================================================
-- 4. Fix search_professor_review_courses — SECURITY INVOKER + use extensions.unaccent
-- ============================================================================
CREATE OR REPLACE FUNCTION public.search_professor_review_courses(
  p_query TEXT,
  p_limit INTEGER DEFAULT 8
)
RETURNS TABLE (
  id BIGINT,
  code TEXT,
  name TEXT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH normalized AS (
    SELECT
      NULLIF(trim(p_query), '') AS query,
      GREATEST(1, LEAST(COALESCE(p_limit, 8), 20)) AS result_limit
  )
  SELECT
    c.id,
    c.code,
    c.name
  FROM public.course c
  CROSS JOIN normalized n
  WHERE n.query IS NOT NULL
    AND (
      c.code ILIKE '%' || n.query || '%'
      OR extensions.unaccent(c.name) ILIKE '%' || extensions.unaccent(n.query) || '%'
    )
  ORDER BY
    CASE WHEN c.code ILIKE n.query || '%' THEN 0 ELSE 1 END,
    CASE WHEN extensions.unaccent(c.name) ILIKE extensions.unaccent(n.query) || '%' THEN 0 ELSE 1 END,
    c.code ASC
  LIMIT (SELECT result_limit FROM normalized);
$$;

REVOKE ALL ON FUNCTION public.search_professor_review_courses(TEXT, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.search_professor_review_courses(TEXT, INTEGER) TO anon, authenticated;

-- ============================================================================
-- 5. Fix search_professor_review_stats — SECURITY INVOKER (reads via RLS-friendly tables)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.search_professor_review_stats(
  p_query TEXT DEFAULT NULL,
  p_min_avg_score NUMERIC DEFAULT NULL,
  p_min_review_count INTEGER DEFAULT 0,
  p_course_code TEXT DEFAULT NULL,
  p_only_with_approved_reviews BOOLEAN DEFAULT false,
  p_limit INTEGER DEFAULT 25,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  professor_id TEXT,
  professor_name TEXT,
  approved_review_count BIGINT,
  average_overall_score NUMERIC,
  average_ease_score NUMERIC,
  average_quality_score NUMERIC,
  average_clarity_score NUMERIC,
  courses_reviewed_count BIGINT,
  last_approved_review_at TIMESTAMPTZ,
  search_rank REAL,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH approved_reviews AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.status = 'approved'
      AND (
        p_course_code IS NULL
        OR pr.course_code_snapshot ILIKE p_course_code
      )
  ),
  aggregated AS (
    SELECT
      ar.professor_id,
      COUNT(*)::BIGINT AS approved_review_count,
      ROUND(AVG((ar.ease_score + ar.quality_score + ar.clarity_score + ar.fairness_score) / 4.0)::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(ar.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(ar.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(ar.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      COUNT(DISTINCT ar.course_id)::BIGINT AS courses_reviewed_count,
      MAX(ar.created_at) AS last_approved_review_at
    FROM approved_reviews ar
    GROUP BY ar.professor_id
  ),
  filtered AS (
    SELECT
      p.id::TEXT AS professor_id,
      p.full_name AS professor_name,
      COALESCE(a.approved_review_count, 0) AS approved_review_count,
      a.average_overall_score,
      a.average_ease_score,
      a.average_quality_score,
      a.average_clarity_score,
      COALESCE(a.courses_reviewed_count, 0) AS courses_reviewed_count,
      a.last_approved_review_at,
      CASE
        WHEN COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL THEN 0::REAL
        WHEN p.full_name ILIKE '%' || trim(p_query) || '%' THEN 1::REAL
        ELSE 0::REAL
      END AS search_rank
    FROM public.professor p
    LEFT JOIN aggregated a ON a.professor_id = p.id
    WHERE public.is_real_professor_name(p.full_name)
      AND (
        COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL
        OR p.full_name ILIKE '%' || trim(p_query) || '%'
      )
      AND (
        p_only_with_approved_reviews = false
        OR COALESCE(a.approved_review_count, 0) > 0
      )
      AND COALESCE(a.approved_review_count, 0) >= GREATEST(COALESCE(p_min_review_count, 0), 0)
      AND (
        p_min_avg_score IS NULL
        OR COALESCE(a.average_overall_score, 0) >= p_min_avg_score
      )
  )
  SELECT
    f.professor_id,
    f.professor_name,
    f.approved_review_count,
    f.average_overall_score,
    f.average_ease_score,
    f.average_quality_score,
    f.average_clarity_score,
    f.courses_reviewed_count,
    f.last_approved_review_at,
    f.search_rank,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM filtered f
  ORDER BY
    f.search_rank DESC,
    f.approved_review_count DESC,
    f.professor_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

-- ============================================================================
-- 6. Fix get_professor_reviews_public — SECURITY INVOKER (reads via RLS)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_professor_reviews_public(
  p_professor_id TEXT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id TEXT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  comment TEXT,
  ease_score NUMERIC,
  quality_score NUMERIC,
  clarity_score NUMERIC,
  fairness_score NUMERIC,
  attendance_required BOOLEAN,
  grade_received TEXT,
  engagement_level SMALLINT,
  tags TEXT[],
  status public.professor_review_status,
  created_at TIMESTAMPTZ,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH rows AS (
    SELECT
      pr.id AS review_id,
      pr.professor_id::text AS professor_id,
      pr.course_id,
      pr.course_code_snapshot AS course_code,
      pr.course_name_snapshot AS course_name,
      pr.comment,
      pr.ease_score,
      pr.quality_score,
      pr.clarity_score,
      pr.fairness_score,
      pr.attendance_required,
      pr.grade_received,
      pr.engagement_level,
      pr.tags,
      pr.status,
      pr.created_at
    FROM public.professor_review pr
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  counted AS (
    SELECT COUNT(*)::BIGINT AS total_count FROM rows
  )
  SELECT
    r.review_id,
    r.professor_id,
    r.course_id,
    r.course_code,
    r.course_name,
    r.comment,
    r.ease_score,
    r.quality_score,
    r.clarity_score,
    r.fairness_score,
    r.attendance_required,
    r.grade_received,
    r.engagement_level,
    r.tags,
    r.status,
    r.created_at,
    c.total_count
  FROM rows r
  CROSS JOIN counted c
  ORDER BY r.created_at DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

-- ============================================================================
-- 7. Fix get_professor_review_summary — SECURITY INVOKER (reads via RLS)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_professor_review_summary(
  p_professor_id TEXT
)
RETURNS TABLE (
  professor_id TEXT,
  approved_review_count BIGINT,
  average_overall_score NUMERIC,
  average_ease_score NUMERIC,
  average_quality_score NUMERIC,
  average_clarity_score NUMERIC,
  average_fairness_score NUMERIC,
  would_take_again_percentage NUMERIC,
  tag_counts JSONB
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH approved AS (
    SELECT pr.*
    FROM public.professor_review pr
    WHERE pr.professor_id::text = p_professor_id
      AND pr.status = 'approved'
  ),
  tag_agg AS (
    SELECT
      tag,
      COUNT(*)::BIGINT AS count
    FROM approved a,
    LATERAL unnest(a.tags) AS tag
    GROUP BY tag
  )
  SELECT
    p_professor_id AS professor_id,
    COUNT(*)::BIGINT AS approved_review_count,
    ROUND(AVG((a.ease_score + a.quality_score + a.clarity_score + a.fairness_score) / 4.0)::NUMERIC, 2) AS average_overall_score,
    ROUND(AVG(a.ease_score)::NUMERIC, 2) AS average_ease_score,
    ROUND(AVG(a.quality_score)::NUMERIC, 2) AS average_quality_score,
    ROUND(AVG(a.clarity_score)::NUMERIC, 2) AS average_clarity_score,
    ROUND(AVG(a.fairness_score)::NUMERIC, 2) AS average_fairness_score,
    ROUND(AVG(CASE WHEN 'Tomaria su clase nuevamente' = ANY(a.tags) THEN 1 ELSE 0 END)::NUMERIC * 100, 2) AS would_take_again_percentage,
    COALESCE(
      (
        SELECT jsonb_agg(jsonb_build_object('tag', t.tag, 'count', t.count) ORDER BY t.count DESC, t.tag ASC)
        FROM tag_agg t
      ),
      '[]'::jsonb
    ) AS tag_counts
  FROM approved a;
$$;

-- ============================================================================
-- 8. Fix insert_student_course_attempt — SECURITY INVOKER (auth.uid() + RLS protect)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.insert_student_course_attempt(
  p_user_id UUID,
  p_study_plan_id BIGINT,
  p_course_id BIGINT,
  p_status TEXT,
  p_grade NUMERIC(5,2) DEFAULT NULL,
  p_academic_term_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SECURITY INVOKER
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

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
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
    user_id, study_plan_id, course_id, academic_term_id,
    attempt_number, status, grade, approved, recorded_at
  )
  VALUES (
    p_user_id, p_study_plan_id, p_course_id, p_academic_term_id,
    v_next_attempt_number, v_normalized_status, p_grade,
    (v_normalized_status = 'APPROVED'), NOW()
  )
  RETURNING id INTO v_inserted_id;

  RETURN v_inserted_id;
END;
$$;

REVOKE ALL ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.insert_student_course_attempt(UUID, BIGINT, BIGINT, TEXT, NUMERIC(5,2), BIGINT) TO authenticated;

-- ============================================================================
-- 9. Fix update_student_course_attempt — SECURITY INVOKER (auth.uid() + RLS protect)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.update_student_course_attempt(
  p_attempt_id BIGINT,
  p_academic_term_id BIGINT,
  p_grade NUMERIC(5,2) DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_user_id UUID;
  v_status public.student_course_status;
BEGIN
  SELECT scr.user_id, scr.status
  INTO v_user_id, v_status
  FROM public.student_course_record scr
  WHERE scr.id = p_attempt_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Attempt not found';
  END IF;

  IF auth.uid() IS NULL OR auth.uid() <> v_user_id THEN
    RAISE EXCEPTION 'Not authorized to update this attempt';
  END IF;

  IF p_academic_term_id IS NULL THEN
    RAISE EXCEPTION 'Academic term is required';
  END IF;

  IF p_grade IS NOT NULL AND (p_grade < 0 OR p_grade > 100) THEN
    RAISE EXCEPTION 'Grade must be between 0 and 100';
  END IF;

  IF v_status IN ('APPROVED', 'FAILED') AND p_grade IS NULL THEN
    RAISE EXCEPTION 'Grade is required for APPROVED and FAILED attempts';
  END IF;

  IF v_status IN ('IN_PROGRESS', 'WITHDRAWN') THEN
    p_grade := NULL;
  END IF;

  UPDATE public.student_course_record
  SET
    academic_term_id = p_academic_term_id,
    grade = p_grade,
    approved = (status = 'APPROVED')
  WHERE id = p_attempt_id;
END;
$$;

REVOKE ALL ON FUNCTION public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2)) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.update_student_course_attempt(BIGINT, BIGINT, NUMERIC(5,2)) TO authenticated;

-- ============================================================================
-- 10. Fix save_user_schedule — SECURITY INVOKER (auth.uid() + RLS protect)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.save_user_schedule(
  p_name TEXT,
  p_academic_term_id BIGINT,
  p_group_lookups JSONB
)
RETURNS TABLE (
  id BIGINT,
  name TEXT,
  academic_term_id BIGINT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_schedule_id BIGINT;
  v_inserted_count INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'No autenticado' USING ERRCODE = '28000';
  END IF;

  IF p_name IS NULL OR trim(p_name) = '' THEN
    RAISE EXCEPTION 'El nombre del horario es requerido' USING ERRCODE = '22023';
  END IF;

  IF p_group_lookups IS NULL OR jsonb_typeof(p_group_lookups) <> 'array' THEN
    RAISE EXCEPTION 'Los grupos seleccionados son invalidos' USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.saved_schedule (user_id, name, academic_term_id)
  VALUES (v_user_id, trim(p_name), p_academic_term_id)
  RETURNING saved_schedule.id INTO v_schedule_id;

  WITH requested_groups AS (
    SELECT DISTINCT
      upper(trim(item->>'courseCode')) AS course_code,
      trim(item->>'groupCode') AS group_code,
      CASE
        WHEN item ? 'campusId' AND item->>'campusId' ~ '^\d+$'
          THEN (item->>'campusId')::BIGINT
        ELSE NULL
      END AS campus_id
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'courseCode'
      AND item ? 'groupCode'
      AND trim(item->>'courseCode') <> ''
      AND trim(item->>'groupCode') <> ''
  ), inserted_items AS (
    INSERT INTO public.saved_schedule_item (
      saved_schedule_id,
      course_offering_group_id
    )
    SELECT DISTINCT
      v_schedule_id,
      cog.id
    FROM requested_groups rg
    JOIN public.course c ON c.code = rg.course_code
    JOIN public.course_offering co
      ON co.course_id = c.id
     AND co.academic_term_id = p_academic_term_id
     AND co.is_active = true
     AND (rg.campus_id IS NULL OR co.campus_id = rg.campus_id)
    JOIN public.course_offering_group cog
      ON cog.course_offering_id = co.id
     AND cog.group_code = rg.group_code
     AND cog.is_active = true
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
    ss.id,
    ss.name,
    ss.academic_term_id,
    ss.created_at,
    ss.updated_at
  FROM public.saved_schedule ss
  WHERE ss.id = v_schedule_id
    AND ss.user_id = v_user_id;
END;
$$;

REVOKE ALL ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) TO authenticated;

-- ============================================================================
-- 11. Fix get_user_saved_schedule_group_lookups — SECURITY INVOKER
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_user_saved_schedule_group_lookups(
  p_saved_schedule_id BIGINT
)
RETURNS TABLE (
  course_code TEXT,
  campus_id BIGINT,
  group_code TEXT
)
LANGUAGE sql
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT
    c.code AS course_code,
    co.campus_id,
    cog.group_code
  FROM public.saved_schedule ss
  JOIN public.saved_schedule_item ssi
    ON ssi.saved_schedule_id = ss.id
  JOIN public.course_offering_group cog
    ON cog.id = ssi.course_offering_group_id
  JOIN public.course_offering co
    ON co.id = cog.course_offering_id
  JOIN public.course c
    ON c.id = co.course_id
  WHERE ss.id = p_saved_schedule_id
    AND ss.user_id = auth.uid()
  ORDER BY c.code, co.campus_id, cog.group_code;
$$;

REVOKE ALL ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) TO authenticated;

-- ============================================================================
-- 12. Fix get_evaluation_moderation_queue — SECURITY INVOKER + plpgsql guard
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_evaluation_moderation_queue(
  p_status public.evaluation_status,
  p_limit INT DEFAULT 50,
  p_offset INT DEFAULT 0
)
RETURNS TABLE (
  id BIGINT,
  course_id INT,
  course_code TEXT,
  course_name TEXT,
  academic_term_id INT,
  term_display_name TEXT,
  professor_id BIGINT,
  professor_name TEXT,
  evaluation_type TEXT,
  evaluation_number INT,
  custom_name TEXT,
  is_catedra BOOLEAN,
  includes_answers BOOLEAN,
  has_separate_answers BOOLEAN,
  file_key TEXT,
  file_size BIGINT,
  answers_file_key TEXT,
  status TEXT,
  moderation_note TEXT,
  created_at TIMESTAMPTZ,
  total_count BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'forbidden'
      USING ERRCODE = '42501';
  END IF;

  RETURN QUERY
  SELECT
    e.id,
    e.course_id,
    c.code AS course_code,
    c.name AS course_name,
    e.academic_term_id,
    at.display_name AS term_display_name,
    e.professor_id,
    p.full_name AS professor_name,
    e.evaluation_type::TEXT,
    e.evaluation_number,
    e.custom_name,
    e.is_catedra,
    e.includes_answers,
    e.has_separate_answers,
    e.file_key,
    e.file_size,
    e.answers_file_key,
    e.status::TEXT,
    e.moderation_note,
    e.created_at,
    COUNT(*) OVER () AS total_count
  FROM public.course_evaluations e
  JOIN public.course c ON c.id = e.course_id
  LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
  LEFT JOIN public.professor p ON p.id = e.professor_id
  WHERE e.status = p_status
  ORDER BY e.created_at DESC
  LIMIT GREATEST(COALESCE(p_limit, 50), 1)
  OFFSET GREATEST(COALESCE(p_offset, 0), 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_evaluation_moderation_queue(public.evaluation_status, INT, INT) TO authenticated;

-- ============================================================================
-- 13. Fix get_professor_reviews_for_moderation — SECURITY INVOKER
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_professor_reviews_for_moderation(
  p_status public.professor_review_status DEFAULT 'pending',
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id BIGINT,
  professor_name TEXT,
  course_id BIGINT,
  course_code TEXT,
  course_name TEXT,
  comment TEXT,
  ease_score NUMERIC,
  quality_score NUMERIC,
  clarity_score NUMERIC,
  fairness_score NUMERIC,
  attendance_required BOOLEAN,
  grade_received TEXT,
  engagement_level SMALLINT,
  tags TEXT[],
  status public.professor_review_status,
  created_at TIMESTAMPTZ,
  reviewed_at TIMESTAMPTZ,
  moderation_note TEXT,
  total_count BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  RETURN QUERY
  SELECT
    pr.id AS review_id,
    pr.professor_id,
    p.full_name AS professor_name,
    pr.course_id,
    pr.course_code_snapshot AS course_code,
    pr.course_name_snapshot AS course_name,
    pr.comment,
    pr.ease_score,
    pr.quality_score,
    pr.clarity_score,
    pr.fairness_score,
    pr.attendance_required,
    pr.grade_received,
    pr.engagement_level,
    pr.tags,
    pr.status,
    pr.created_at,
    pr.reviewed_at,
    pr.moderation_note,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM public.professor_review pr
  JOIN public.professor p ON p.id = pr.professor_id
  WHERE pr.status = p_status
  ORDER BY pr.created_at ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
END;
$$;

REVOKE ALL ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER) TO authenticated;

-- ============================================================================
-- 14. Fix moderate_professor_review — SECURITY INVOKER
-- ============================================================================
CREATE OR REPLACE FUNCTION public.moderate_professor_review(
  p_review_id BIGINT,
  p_new_status public.professor_review_status,
  p_moderation_note TEXT DEFAULT NULL
)
RETURNS public.professor_review
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  updated_row public.professor_review;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF p_new_status NOT IN ('approved', 'rejected') THEN
    RAISE EXCEPTION 'Invalid moderation status: %', p_new_status;
  END IF;

  UPDATE public.professor_review pr
  SET
    status = p_new_status,
    moderation_note = p_moderation_note,
    reviewed_by = (SELECT auth.uid()),
    reviewed_at = NOW()
  WHERE pr.id = p_review_id
  RETURNING pr.* INTO updated_row;

  IF updated_row.id IS NULL THEN
    RAISE EXCEPTION 'Review not found: %', p_review_id;
  END IF;

  RETURN updated_row;
END;
$$;

REVOKE ALL ON FUNCTION public.moderate_professor_review(BIGINT, public.professor_review_status, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.moderate_professor_review(BIGINT, public.professor_review_status, TEXT) TO authenticated;

-- ============================================================================
-- 15. Fix is_admin — keep SECURITY DEFINER (needed by RLS), revoke PUBLIC
-- ============================================================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_role ur
    WHERE ur.user_id = (SELECT auth.uid())
      AND ur.role = 'admin'::public.app_role
  );
$$;

REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- ============================================================================
-- 16. Fix handle_new_user — keep SECURITY DEFINER (trigger), revoke PUBLIC
-- ============================================================================
REVOKE ALL ON FUNCTION public.handle_new_user() FROM PUBLIC;

COMMIT;
