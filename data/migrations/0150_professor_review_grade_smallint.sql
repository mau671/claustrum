-- 0150_professor_review_grade_smallint.sql
-- Converts professor_review.grade_received from TEXT to SMALLINT.
--
-- The column holds a grade on the 0-100 scale. Production had 1312 rows with a
-- value: 1302 numeric and 10 empty strings. The empty strings are treated as
-- "not provided" and become NULL, which the column already allowed.
--
-- The API currently exposes it as a string. To avoid changing the public
-- contract in the same step as the storage change, the value is cast back to
-- text by the functions that return it (see section 5). The frontend keeps
-- receiving a string and can parse it as before.

BEGIN;

-- ============================================================================
-- 1. PRECHECK: reject anything that is neither a number nor an empty string
-- ============================================================================

DO $$
DECLARE
  invalid_count BIGINT;
  invalid_examples TEXT;
BEGIN
  SELECT count(*), string_agg(DISTINCT grade_received, ', ')
  INTO invalid_count, invalid_examples
  FROM public.professor_review
  WHERE grade_received IS NOT NULL
    AND btrim(grade_received) <> ''
    AND btrim(grade_received) !~ '^[0-9]+(\.[0-9]+)?$';

  IF invalid_count > 0 THEN
    RAISE EXCEPTION
      'Cannot convert grade_received to SMALLINT: % non-numeric value(s): %',
      invalid_count, invalid_examples;
  END IF;
END $$;

-- ============================================================================
-- 2. NORMALISE: empty strings mean "no grade provided"
-- ============================================================================

UPDATE public.professor_review
SET grade_received = NULL
WHERE grade_received IS NOT NULL
  AND btrim(grade_received) = '';

-- ============================================================================
-- 3. DROP THE LENGTH CHECK, it no longer applies to a number
-- ============================================================================

ALTER TABLE public.professor_review
  DROP CONSTRAINT IF EXISTS professor_review_grade_received_length_check;

-- ============================================================================
-- 4. CONVERT THE COLUMN
-- ============================================================================

ALTER TABLE public.professor_review
  ALTER COLUMN grade_received TYPE SMALLINT
  USING (round(grade_received::NUMERIC)::SMALLINT);

ALTER TABLE public.professor_review
  DROP CONSTRAINT IF EXISTS professor_review_grade_received_range_check;

ALTER TABLE public.professor_review
  ADD CONSTRAINT professor_review_grade_received_range_check
  CHECK (grade_received IS NULL OR (grade_received >= 0 AND grade_received <= 100));

COMMENT ON COLUMN public.professor_review.grade_received IS
  'Grade the reviewer reports having received, 0-100. NULL when not provided.';

COMMIT;
