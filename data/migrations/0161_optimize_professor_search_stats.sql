-- 0161_optimize_professor_search_stats.sql
-- Optimizes professor search and statistics by introducing a pre-aggregated professor_stats table,
-- incremental triggers on reviews and course relationships, and an immutable unaccent GIN trigram index.

BEGIN;

-- 1. Immutable wrapper for unaccent (enables functional indexes and faster text comparison)
CREATE OR REPLACE FUNCTION public.immutable_unaccent(text)
RETURNS text
LANGUAGE sql IMMUTABLE PARALLEL SAFE STRICT
SET search_path = public, extensions
AS $$
  SELECT extensions.unaccent('extensions.unaccent', $1);
$$;

-- 2. GIN Trigram index on professor unaccented full name
CREATE INDEX IF NOT EXISTS idx_professor_unaccent_full_name_trgm
  ON public.professor USING gin (public.immutable_unaccent(full_name) extensions.gin_trgm_ops);

-- 3. Pre-aggregated professor statistics table
CREATE TABLE IF NOT EXISTS public.professor_stats (
  professor_id BIGINT PRIMARY KEY REFERENCES public.professor(id) ON DELETE CASCADE,
  unaccent_full_name TEXT NOT NULL,
  approved_review_count BIGINT NOT NULL DEFAULT 0,
  average_overall_score NUMERIC(4,2),
  average_ease_score NUMERIC(4,2),
  average_quality_score NUMERIC(4,2),
  average_clarity_score NUMERIC(4,2),
  courses_reviewed_count BIGINT NOT NULL DEFAULT 0,
  last_approved_review_at TIMESTAMPTZ,
  academic_unit_id BIGINT REFERENCES public.academic_unit(id) ON DELETE SET NULL,
  academic_unit TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_professor_stats_unaccent_name
  ON public.professor_stats USING gin (unaccent_full_name extensions.gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_professor_stats_reviews_count
  ON public.professor_stats (approved_review_count DESC);

CREATE INDEX IF NOT EXISTS idx_professor_stats_overall_score
  ON public.professor_stats (average_overall_score DESC NULLS LAST);

CREATE INDEX IF NOT EXISTS idx_professor_stats_academic_unit_id
  ON public.professor_stats (academic_unit_id);

-- Enable RLS
ALTER TABLE public.professor_stats ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read professor stats" ON public.professor_stats;
CREATE POLICY "Public can read professor stats" ON public.professor_stats
  FOR SELECT TO anon, authenticated USING (true);

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.professor_stats TO hyperdrive_user;
    DROP POLICY IF EXISTS "Hyperdrive full access" ON public.professor_stats;
    CREATE POLICY "Hyperdrive full access" ON public.professor_stats
      FOR ALL TO hyperdrive_user USING (true) WITH CHECK (true);
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'service_role') THEN
    GRANT SELECT, INSERT, UPDATE, DELETE ON public.professor_stats TO service_role;
    DROP POLICY IF EXISTS "Service role full access" ON public.professor_stats;
    CREATE POLICY "Service role full access" ON public.professor_stats
      FOR ALL TO service_role USING (true) WITH CHECK (true);
  END IF;
END $$;

-- 4. Function to recalculate stats for a single professor
CREATE OR REPLACE FUNCTION public.refresh_professor_stats_for_professor(p_professor_id BIGINT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_prof RECORD;
BEGIN
  SELECT id, full_name, public.immutable_unaccent(full_name) AS unaccent_name
  INTO v_prof
  FROM public.professor
  WHERE id = p_professor_id;

  IF NOT FOUND OR NOT public.is_real_professor_name(v_prof.full_name) THEN
    DELETE FROM public.professor_stats WHERE professor_id = p_professor_id;
    RETURN;
  END IF;

  INSERT INTO public.professor_stats (
    professor_id,
    unaccent_full_name,
    approved_review_count,
    average_overall_score,
    average_ease_score,
    average_quality_score,
    average_clarity_score,
    courses_reviewed_count,
    last_approved_review_at,
    academic_unit_id,
    academic_unit,
    updated_at
  )
  WITH rev_stats AS (
    SELECT
      COUNT(pr.id)::BIGINT AS approved_review_count,
      ROUND(AVG(
        (COALESCE(pr.ease_score, 0) + COALESCE(pr.quality_score, 0) + COALESCE(pr.clarity_score, 0) + COALESCE(pr.fairness_score, 0))
        / NULLIF(
          (CASE WHEN pr.ease_score IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN pr.quality_score IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN pr.clarity_score IS NOT NULL THEN 1 ELSE 0 END +
           CASE WHEN pr.fairness_score IS NOT NULL THEN 1 ELSE 0 END), 0
        )
      )::NUMERIC, 2) AS average_overall_score,
      ROUND(AVG(pr.ease_score)::NUMERIC, 2) AS average_ease_score,
      ROUND(AVG(pr.quality_score)::NUMERIC, 2) AS average_quality_score,
      ROUND(AVG(pr.clarity_score)::NUMERIC, 2) AS average_clarity_score,
      MAX(pr.created_at) AS last_approved_review_at
    FROM public.professor_review pr
    WHERE pr.professor_id = p_professor_id
      AND pr.status = 'approved'
  ),
  course_stats AS (
    SELECT COUNT(DISTINCT prc.course_id)::BIGINT AS courses_reviewed_count
    FROM public.professor_review pr
    JOIN public.professor_review_course prc ON prc.review_id = pr.id
    WHERE pr.professor_id = p_professor_id
      AND pr.status = 'approved'
  ),
  unit_stats AS (
    SELECT au.id AS academic_unit_id, au.name AS academic_unit
    FROM public.course_offering_group_professor cogp
    JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
    JOIN public.course_offering co ON co.id = cog.course_offering_id
    JOIN public.academic_unit au ON au.id = co.academic_unit_id
    WHERE cogp.professor_id = p_professor_id
    GROUP BY au.id, au.name
    ORDER BY COUNT(*) DESC
    LIMIT 1
  )
  SELECT
    p_professor_id,
    v_prof.unaccent_name,
    COALESCE(rs.approved_review_count, 0),
    rs.average_overall_score,
    rs.average_ease_score,
    rs.average_quality_score,
    rs.average_clarity_score,
    COALESCE(cs.courses_reviewed_count, 0),
    rs.last_approved_review_at,
    us.academic_unit_id,
    us.academic_unit,
    NOW()
  FROM rev_stats rs
  LEFT JOIN course_stats cs ON true
  LEFT JOIN unit_stats us ON true
  ON CONFLICT (professor_id) DO UPDATE SET
    unaccent_full_name = EXCLUDED.unaccent_full_name,
    approved_review_count = EXCLUDED.approved_review_count,
    average_overall_score = EXCLUDED.average_overall_score,
    average_ease_score = EXCLUDED.average_ease_score,
    average_quality_score = EXCLUDED.average_quality_score,
    average_clarity_score = EXCLUDED.average_clarity_score,
    courses_reviewed_count = EXCLUDED.courses_reviewed_count,
    last_approved_review_at = EXCLUDED.last_approved_review_at,
    academic_unit_id = EXCLUDED.academic_unit_id,
    academic_unit = EXCLUDED.academic_unit,
    updated_at = NOW();
END;
$$;

-- 5. Incremental triggers on professor_review, professor_review_course, and professor
CREATE OR REPLACE FUNCTION public.trg_professor_review_refresh_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM public.refresh_professor_stats_for_professor(OLD.professor_id);
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    IF OLD.professor_id <> NEW.professor_id THEN
      PERFORM public.refresh_professor_stats_for_professor(OLD.professor_id);
    END IF;
    PERFORM public.refresh_professor_stats_for_professor(NEW.professor_id);
    RETURN NEW;
  ELSE
    PERFORM public.refresh_professor_stats_for_professor(NEW.professor_id);
    RETURN NEW;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_professor_review_stats_update ON public.professor_review;
CREATE TRIGGER trg_professor_review_stats_update
AFTER INSERT OR UPDATE OF status, ease_score, quality_score, clarity_score, fairness_score, professor_id OR DELETE
ON public.professor_review
FOR EACH ROW EXECUTE FUNCTION public.trg_professor_review_refresh_stats();

CREATE OR REPLACE FUNCTION public.trg_professor_review_course_refresh_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_prof_id BIGINT;
BEGIN
  IF TG_OP = 'DELETE' THEN
    SELECT professor_id INTO v_prof_id FROM public.professor_review WHERE id = OLD.review_id;
  ELSE
    SELECT professor_id INTO v_prof_id FROM public.professor_review WHERE id = NEW.review_id;
  END IF;

  IF v_prof_id IS NOT NULL THEN
    PERFORM public.refresh_professor_stats_for_professor(v_prof_id);
  END IF;

  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_professor_review_course_stats_update ON public.professor_review_course;
CREATE TRIGGER trg_professor_review_course_stats_update
AFTER INSERT OR UPDATE OR DELETE
ON public.professor_review_course
FOR EACH ROW EXECUTE FUNCTION public.trg_professor_review_course_refresh_stats();

CREATE OR REPLACE FUNCTION public.trg_professor_insert_init_stats()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF public.is_real_professor_name(NEW.full_name) THEN
    INSERT INTO public.professor_stats (professor_id, unaccent_full_name)
    VALUES (NEW.id, public.immutable_unaccent(NEW.full_name))
    ON CONFLICT (professor_id) DO UPDATE SET
      unaccent_full_name = EXCLUDED.unaccent_full_name;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_professor_insert_init_stats ON public.professor;
CREATE TRIGGER trg_professor_insert_init_stats
AFTER INSERT OR UPDATE OF full_name ON public.professor
FOR EACH ROW EXECUTE FUNCTION public.trg_professor_insert_init_stats();

-- 6. Initial population of professor_stats
INSERT INTO public.professor_stats (
  professor_id,
  unaccent_full_name,
  approved_review_count,
  average_overall_score,
  average_ease_score,
  average_quality_score,
  average_clarity_score,
  courses_reviewed_count,
  last_approved_review_at,
  academic_unit_id,
  academic_unit
)
WITH prof_stats AS (
  SELECT
    pr.professor_id,
    COUNT(pr.id)::BIGINT AS approved_review_count,
    ROUND(AVG(
      (COALESCE(pr.ease_score, 0) + COALESCE(pr.quality_score, 0) + COALESCE(pr.clarity_score, 0) + COALESCE(pr.fairness_score, 0))
      / NULLIF(
        (CASE WHEN pr.ease_score IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN pr.quality_score IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN pr.clarity_score IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN pr.fairness_score IS NOT NULL THEN 1 ELSE 0 END), 0
      )
    )::NUMERIC, 2) AS average_overall_score,
    ROUND(AVG(pr.ease_score)::NUMERIC, 2) AS average_ease_score,
    ROUND(AVG(pr.quality_score)::NUMERIC, 2) AS average_quality_score,
    ROUND(AVG(pr.clarity_score)::NUMERIC, 2) AS average_clarity_score,
    MAX(pr.created_at) AS last_approved_review_at
  FROM public.professor_review pr
  WHERE pr.status = 'approved'
  GROUP BY pr.professor_id
),
prof_course_stats AS (
  SELECT
    pr.professor_id,
    COUNT(DISTINCT prc.course_id)::BIGINT AS courses_reviewed_count
  FROM public.professor_review pr
  JOIN public.professor_review_course prc ON prc.review_id = pr.id
  WHERE pr.status = 'approved'
  GROUP BY pr.professor_id
),
prof_primary_unit AS (
  SELECT DISTINCT ON (cogp.professor_id)
    cogp.professor_id,
    au.id AS academic_unit_id,
    au.name AS academic_unit
  FROM public.course_offering_group_professor cogp
  JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
  JOIN public.course_offering co ON co.id = cog.course_offering_id
  JOIN public.academic_unit au ON au.id = co.academic_unit_id
  GROUP BY cogp.professor_id, au.id, au.name
  ORDER BY cogp.professor_id, COUNT(*) DESC
)
SELECT
  p.id,
  public.immutable_unaccent(p.full_name),
  COALESCE(ps.approved_review_count, 0),
  ps.average_overall_score,
  ps.average_ease_score,
  ps.average_quality_score,
  ps.average_clarity_score,
  COALESCE(pcs.courses_reviewed_count, 0),
  ps.last_approved_review_at,
  pu.academic_unit_id,
  pu.academic_unit
FROM public.professor p
LEFT JOIN prof_stats ps ON ps.professor_id = p.id
LEFT JOIN prof_course_stats pcs ON pcs.professor_id = p.id
LEFT JOIN prof_primary_unit pu ON pu.professor_id = p.id
WHERE public.is_real_professor_name(p.full_name)
ON CONFLICT (professor_id) DO UPDATE SET
  unaccent_full_name = EXCLUDED.unaccent_full_name,
  approved_review_count = EXCLUDED.approved_review_count,
  average_overall_score = EXCLUDED.average_overall_score,
  average_ease_score = EXCLUDED.average_ease_score,
  average_quality_score = EXCLUDED.average_quality_score,
  average_clarity_score = EXCLUDED.average_clarity_score,
  courses_reviewed_count = EXCLUDED.courses_reviewed_count,
  last_approved_review_at = EXCLUDED.last_approved_review_at,
  academic_unit_id = EXCLUDED.academic_unit_id,
  academic_unit = EXCLUDED.academic_unit,
  updated_at = NOW();

-- 7. High-performance search_professor_review_stats function
CREATE OR REPLACE FUNCTION public.search_professor_review_stats(
  p_query TEXT DEFAULT NULL,
  p_min_avg_score NUMERIC DEFAULT NULL,
  p_min_review_count INTEGER DEFAULT 0,
  p_academic_unit_id INTEGER DEFAULT NULL,
  p_only_with_approved_reviews BOOLEAN DEFAULT false,
  p_sort_by TEXT DEFAULT 'reviews',
  p_sort_desc BOOLEAN DEFAULT true,
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
  academic_unit TEXT,
  total_count BIGINT
)
LANGUAGE SQL
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  WITH query_words AS (
    SELECT public.immutable_unaccent(w) AS word
    FROM unnest(regexp_split_to_array(trim(COALESCE(p_query, '')), '\s+')) AS w
    WHERE trim(w) <> ''
  ),
  filtered AS (
    SELECT
      p.id::TEXT AS professor_id,
      p.full_name AS professor_name,
      ps.approved_review_count,
      ps.average_overall_score,
      ps.average_ease_score,
      ps.average_quality_score,
      ps.average_clarity_score,
      ps.courses_reviewed_count,
      ps.last_approved_review_at,
      CASE
        WHEN NOT EXISTS (SELECT 1 FROM query_words) THEN 0::REAL
        ELSE 1::REAL
      END AS search_rank,
      ps.academic_unit
    FROM public.professor_stats ps
    JOIN public.professor p ON p.id = ps.professor_id
    WHERE (
        NOT EXISTS (SELECT 1 FROM query_words)
        OR NOT EXISTS (
          SELECT 1 
          FROM query_words qw
          WHERE ps.unaccent_full_name NOT ILIKE '%' || qw.word || '%'
        )
      )
      AND (
        p_only_with_approved_reviews = false
        OR ps.approved_review_count > 0
      )
      AND ps.approved_review_count >= GREATEST(COALESCE(p_min_review_count, 0), 0)
      AND (
        p_min_avg_score IS NULL
        OR ps.average_overall_score >= p_min_avg_score
      )
      AND (
        p_academic_unit_id IS NULL
        OR ps.academic_unit_id = p_academic_unit_id
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
    f.academic_unit,
    COUNT(*) OVER ()::BIGINT AS total_count
  FROM filtered f
  ORDER BY
    f.search_rank DESC,
    CASE WHEN p_sort_by = 'reviews' AND p_sort_desc THEN f.approved_review_count END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'reviews' AND NOT p_sort_desc THEN f.approved_review_count END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'score' AND p_sort_desc THEN f.average_overall_score END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'score' AND NOT p_sort_desc THEN f.average_overall_score END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'ease' AND p_sort_desc THEN f.average_ease_score END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'ease' AND NOT p_sort_desc THEN f.average_ease_score END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'quality' AND p_sort_desc THEN f.average_quality_score END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'quality' AND NOT p_sort_desc THEN f.average_quality_score END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'clarity' AND p_sort_desc THEN f.average_clarity_score END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'clarity' AND NOT p_sort_desc THEN f.average_clarity_score END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'name' AND p_sort_desc THEN f.professor_name END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'name' AND NOT p_sort_desc THEN f.professor_name END ASC NULLS LAST,
    CASE WHEN p_sort_by = 'date' AND p_sort_desc THEN f.last_approved_review_at END DESC NULLS LAST,
    CASE WHEN p_sort_by = 'date' AND NOT p_sort_desc THEN f.last_approved_review_at END ASC NULLS LAST,
    f.approved_review_count DESC,
    f.professor_name ASC
  LIMIT LEAST(GREATEST(p_limit, 1), 200)
  OFFSET GREATEST(p_offset, 0);
$$;

GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, INTEGER, BOOLEAN, TEXT, BOOLEAN, INTEGER, INTEGER) TO anon, authenticated;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hyperdrive_user') THEN
    GRANT EXECUTE ON FUNCTION public.search_professor_review_stats(TEXT, NUMERIC, INTEGER, INTEGER, BOOLEAN, TEXT, BOOLEAN, INTEGER, INTEGER) TO hyperdrive_user;
  END IF;
END $$;

COMMIT;
