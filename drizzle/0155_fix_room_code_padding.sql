-- 0155_fix_room_code_padding.sql
-- Fixes the generated `room.code` column, which truncated numbers above 99 and
-- padded to the wrong width.
--
-- 0148 defined the column as:
--
--   building || '-' || lpad(number::text, 2, '0')
--
-- Two problems:
--   1. `lpad` does not only pad, it TRUNCATES when the input is longer than the
--      requested width. lpad('603', 2, '0') returns '60', so a room with number
--      603 produced 'UTN-60'.
--   2. The ITCR always publishes a 3-digit room number: 'UTN-603', 'A-002',
--      'UTN-000'. Padding to 2 dropped a leading zero and made the generated
--      code disagree with the source.
--
-- Verified against 18,667 rooms across all five campuses: every single value is
-- exactly three digits after the hyphen.
--
-- No production row was corrupted because every room inserted so far had a
-- 1-2 digit number, but the column must be correct before any 3-digit room is
-- written.

BEGIN;

ALTER TABLE public.room DROP COLUMN IF EXISTS code;

ALTER TABLE public.room
  ADD COLUMN code TEXT
  GENERATED ALWAYS AS (
    building || '-' || CASE
      WHEN number < 10  THEN '00' || number::text
      WHEN number < 100 THEN '0'  || number::text
      ELSE number::text
    END
  ) STORED;

COMMENT ON COLUMN public.room.code IS
  'Canonical BUILDING-NNN form, e.g. "UTN-603", "A-002", "UTN-000". '
  'Left-pads to three digits and never truncates.';

COMMIT;
