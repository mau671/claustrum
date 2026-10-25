-- 0147_user_carnet_format.sql
-- Normalises `user.carnet` to the official ITCR format and enforces it.
--
-- A carnet is `<year:4><sequence:6>`, always 10 digits starting with a year
-- (2015, 2020, ...). Production had three rows that did not match: '67',
-- '12345678' and '202513' — test data, not real carnets. They become NULL.
--
-- carnet stays TEXT on purpose. It is an identifier, not a quantity: it is
-- never summed, compared numerically or ordered by magnitude, and encoding it
-- as an integer would break the moment the institution changes the prefix
-- format. A CHECK constraint gives the same integrity guarantee without that
-- coupling.

BEGIN;

-- ============================================================================
-- 1. REPORT what is about to change (visible in the migration log)
-- ============================================================================

DO $$
DECLARE
  invalid_count BIGINT;
  invalid_examples TEXT;
BEGIN
  SELECT count(*), string_agg(DISTINCT carnet, ', ')
  INTO invalid_count, invalid_examples
  FROM public."user"
  WHERE carnet IS NOT NULL
    AND carnet !~ '^20[0-9]{2}[0-9]{6}$';

  IF invalid_count > 0 THEN
    RAISE NOTICE
      'Nulling % carnet value(s) that do not match ^20[0-9]{2}[0-9]{6}$: %',
      invalid_count, invalid_examples;
  END IF;
END $$;

-- ============================================================================
-- 2. BACKFILL: invalid values become NULL instead of a broken identifier
-- ============================================================================

UPDATE public."user"
SET carnet = NULL
WHERE carnet IS NOT NULL
  AND carnet !~ '^20[0-9]{2}[0-9]{6}$';

-- ============================================================================
-- 3. ENFORCE the format from now on
-- ============================================================================

ALTER TABLE public."user"
  DROP CONSTRAINT IF EXISTS user_carnet_format_check;

ALTER TABLE public."user"
  ADD CONSTRAINT user_carnet_format_check
  CHECK (carnet IS NULL OR carnet ~ '^20[0-9]{2}[0-9]{6}$');

COMMENT ON COLUMN public."user".carnet IS
  'ITCR student id: 10 digits, <year:4><sequence:6> (e.g. 2020042209). '
  'NULL when the user has not provided a valid carnet.';

COMMIT;
