-- 0018_professor_reviews_module.sql
-- Reviews module: schema, indexes, RLS, and RPCs for public browsing + admin moderation.

BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type
    WHERE typname = 'professor_review_status'
      AND typnamespace = 'public'::regnamespace
  ) THEN
    CREATE TYPE public.professor_review_status AS ENUM ('pending', 'approved', 'rejected');
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_type
    WHERE typname = 'app_role'
      AND typnamespace = 'public'::regnamespace
  ) THEN
    CREATE TYPE public.app_role AS ENUM ('admin');
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS public.user_role (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public."user"(id) ON DELETE CASCADE ON UPDATE CASCADE,
  role public.app_role NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, role)
);

CREATE TABLE IF NOT EXISTS public.professor_review (
  id BIGSERIAL PRIMARY KEY,
  professor_id BIGINT NOT NULL REFERENCES public.professor(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  course_id BIGINT NOT NULL REFERENCES public.course(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  course_code_snapshot TEXT NOT NULL,
  course_name_snapshot TEXT NOT NULL,
  comment TEXT NOT NULL,
  ease_score NUMERIC(3,1) NOT NULL,
  quality_score NUMERIC(3,1) NOT NULL,
  clarity_score NUMERIC(3,1) NOT NULL,
  fairness_score NUMERIC(3,1) NOT NULL,
  attendance_required BOOLEAN NOT NULL,
  grade_received TEXT,
  engagement_level SMALLINT NOT NULL,
  tags TEXT[] NOT NULL DEFAULT '{}'::TEXT[],
  status public.professor_review_status NOT NULL DEFAULT 'pending',
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID REFERENCES public."user"(id) ON DELETE SET NULL ON UPDATE CASCADE,
  moderation_note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT professor_review_comment_length_check
    CHECK (char_length(comment) BETWEEN 5 AND 1000),
  CONSTRAINT professor_review_grade_received_length_check
    CHECK (grade_received IS NULL OR char_length(grade_received) <= 32),
  CONSTRAINT professor_review_ease_score_range_check
    CHECK (ease_score >= 0 AND ease_score <= 10),
  CONSTRAINT professor_review_quality_score_range_check
    CHECK (quality_score >= 0 AND quality_score <= 10),
  CONSTRAINT professor_review_clarity_score_range_check
    CHECK (clarity_score >= 0 AND clarity_score <= 10),
  CONSTRAINT professor_review_fairness_score_range_check
    CHECK (fairness_score >= 0 AND fairness_score <= 10),
  CONSTRAINT professor_review_engagement_level_range_check
    CHECK (engagement_level BETWEEN 1 AND 5),
  CONSTRAINT professor_review_tags_allowed_check
    CHECK (
      tags <@ ARRAY[
        'Da buena retroalimentación',
        'Tomaría su clase nuevamente',
        'Brinda apoyo',
        'Explica con claridad',
        'Exámenes retadores',
        'Proyecto útil'
      ]::TEXT[]
    ),
  CONSTRAINT professor_review_reviewed_status_consistency_check
    CHECK (
      (status = 'pending' AND reviewed_at IS NULL AND reviewed_by IS NULL)
      OR (status IN ('approved', 'rejected') AND reviewed_at IS NOT NULL)
    )
);

CREATE INDEX IF NOT EXISTS idx_user_role_user_id_role
  ON public.user_role (user_id, role);

CREATE INDEX IF NOT EXISTS idx_professor_review_professor_id
  ON public.professor_review (professor_id);

CREATE INDEX IF NOT EXISTS idx_professor_review_course_id
  ON public.professor_review (course_id);

CREATE INDEX IF NOT EXISTS idx_professor_review_reviewed_by
  ON public.professor_review (reviewed_by);

CREATE INDEX IF NOT EXISTS idx_professor_review_approved_professor_created_at
  ON public.professor_review (professor_id, created_at DESC)
  WHERE status = 'approved';

CREATE INDEX IF NOT EXISTS idx_professor_review_pending_created_at
  ON public.professor_review (created_at ASC)
  WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_professor_review_course_code_snapshot
  ON public.professor_review (course_code_snapshot);

CREATE INDEX IF NOT EXISTS idx_professor_full_name_trgm
  ON public.professor USING gin (full_name gin_trgm_ops);

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

CREATE OR REPLACE FUNCTION public.set_professor_review_course_snapshot()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  course_row public.course%ROWTYPE;
BEGIN
  SELECT c.*
  INTO course_row
  FROM public.course c
  WHERE c.id = NEW.course_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid course_id: %', NEW.course_id;
  END IF;

  NEW.course_code_snapshot = course_row.code;
  NEW.course_name_snapshot = course_row.name;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.ensure_professor_review_course_matches_professor()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM public.course_offering_group_professor cogp
    JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
    JOIN public.course_offering co ON co.id = cog.course_offering_id
    WHERE cogp.professor_id = NEW.professor_id
      AND co.course_id = NEW.course_id
  ) THEN
    RAISE EXCEPTION 'The professor % has no offering record for course %', NEW.professor_id, NEW.course_id;
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS set_professor_review_course_snapshot_trigger ON public.professor_review;
CREATE TRIGGER set_professor_review_course_snapshot_trigger
  BEFORE INSERT OR UPDATE OF course_id
  ON public.professor_review
  FOR EACH ROW
  EXECUTE FUNCTION public.set_professor_review_course_snapshot();

DROP TRIGGER IF EXISTS ensure_professor_review_course_matches_professor_trigger ON public.professor_review;
CREATE TRIGGER ensure_professor_review_course_matches_professor_trigger
  BEFORE INSERT OR UPDATE OF professor_id, course_id
  ON public.professor_review
  FOR EACH ROW
  EXECUTE FUNCTION public.ensure_professor_review_course_matches_professor();

DROP TRIGGER IF EXISTS set_timestamp_professor_review ON public.professor_review;
CREATE TRIGGER set_timestamp_professor_review
  BEFORE UPDATE ON public.professor_review
  FOR EACH ROW
  EXECUTE FUNCTION public.trigger_set_timestamp();

ALTER TABLE public.user_role ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own role assignments" ON public.user_role;
CREATE POLICY "Users can view own role assignments"
ON public.user_role
FOR SELECT
TO authenticated
USING (
  user_id = (SELECT auth.uid()) OR public.is_admin()
);

DROP POLICY IF EXISTS "Admins can manage roles" ON public.user_role;
CREATE POLICY "Admins can manage roles"
ON public.user_role
FOR ALL
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Public can read approved professor reviews" ON public.professor_review;
CREATE POLICY "Public can read approved professor reviews"
ON public.professor_review
FOR SELECT
TO anon, authenticated
USING (status = 'approved');

DROP POLICY IF EXISTS "Admins can read all professor reviews" ON public.professor_review;
CREATE POLICY "Admins can read all professor reviews"
ON public.professor_review
FOR SELECT
TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "Admins can update professor reviews" ON public.professor_review;
CREATE POLICY "Admins can update professor reviews"
ON public.professor_review
FOR UPDATE
TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

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
  professor_id BIGINT,
  professor_name TEXT,
  approved_review_count BIGINT,
  average_overall_score NUMERIC,
  average_ease_score NUMERIC,
  average_quality_score NUMERIC,
  average_clarity_score NUMERIC,
  courses_reviewed_count BIGINT,
  last_approved_review_at TIMESTAMPTZ,
  search_rank REAL
)
LANGUAGE SQL
STABLE
SECURITY DEFINER
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
  )
  SELECT
    p.id AS professor_id,
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
      ELSE GREATEST(
        similarity(p.full_name, trim(p_query)),
        CASE
          WHEN p.full_name ILIKE '%' || trim(p_query) || '%' THEN 1::REAL
          ELSE 0::REAL
        END
      )
    END AS search_rank
  FROM public.professor p
  LEFT JOIN aggregated a ON a.professor_id = p.id
  WHERE (
    COALESCE(NULLIF(trim(p_query), ''), NULL) IS NULL
    OR p.full_name ILIKE '%' || trim(p_query) || '%'
    OR similarity(p.full_name, trim(p_query)) > 0.2
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
  ORDER BY
    search_rank DESC,
    COALESCE(a.approved_review_count, 0) DESC,
    p.full_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

CREATE OR REPLACE FUNCTION public.get_professor_reviews_public(
  p_professor_id BIGINT,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  review_id BIGINT,
  professor_id BIGINT,
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
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    pr.id AS review_id,
    pr.professor_id,
    pr.course_id,
    pr.course_code_snapshot AS course_code,
    pr.course_name_snapshot AS course_name,
    CASE
      WHEN pr.status = 'approved' THEN pr.comment
      ELSE 'Comentario en revision'
    END AS comment,
    CASE WHEN pr.status = 'approved' THEN pr.ease_score ELSE NULL END AS ease_score,
    CASE WHEN pr.status = 'approved' THEN pr.quality_score ELSE NULL END AS quality_score,
    CASE WHEN pr.status = 'approved' THEN pr.clarity_score ELSE NULL END AS clarity_score,
    CASE WHEN pr.status = 'approved' THEN pr.fairness_score ELSE NULL END AS fairness_score,
    CASE WHEN pr.status = 'approved' THEN pr.attendance_required ELSE NULL END AS attendance_required,
    CASE WHEN pr.status = 'approved' THEN pr.grade_received ELSE NULL END AS grade_received,
    CASE WHEN pr.status = 'approved' THEN pr.engagement_level ELSE NULL END AS engagement_level,
    CASE WHEN pr.status = 'approved' THEN pr.tags ELSE '{}'::TEXT[] END AS tags,
    pr.status,
    pr.created_at,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM public.professor_review pr
  WHERE pr.professor_id = p_professor_id
    AND pr.status <> 'rejected'
  ORDER BY pr.created_at DESC
  LIMIT LEAST(GREATEST(p_limit, 1), 100)
  OFFSET GREATEST(p_offset, 0);
$$;

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
SECURITY DEFINER
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

CREATE OR REPLACE FUNCTION public.moderate_professor_review(
  p_review_id BIGINT,
  p_new_status public.professor_review_status,
  p_moderation_note TEXT DEFAULT NULL
)
RETURNS public.professor_review
LANGUAGE plpgsql
SECURITY DEFINER
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

GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, TEXT, BOOLEAN, INTEGER, INTEGER)
  TO anon, authenticated;

GRANT EXECUTE ON FUNCTION public.get_professor_reviews_public(BIGINT, INTEGER, INTEGER)
  TO anon, authenticated;

GRANT EXECUTE ON FUNCTION public.get_professor_reviews_for_moderation(public.professor_review_status, INTEGER, INTEGER)
  TO authenticated;

GRANT EXECUTE ON FUNCTION public.moderate_professor_review(BIGINT, public.professor_review_status, TEXT)
  TO authenticated;

COMMIT;
