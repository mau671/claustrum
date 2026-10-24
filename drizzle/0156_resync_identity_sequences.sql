-- 0156_resync_identity_sequences.sql
-- Re-synchronises every identity/serial sequence with the maximum id of its table.
--
-- The sequences were left behind by the seed history: rows were inserted with
-- explicit ids (which is what the delta seeds do, since ids are part of the
-- natural-key remapping), and PostgreSQL does not advance a sequence when an id
-- is supplied explicitly. The result is that `course_offering_group_id_seq` sat
-- at 11805 while the table already contained id 17912, so the next INSERT died
-- with "duplicate key value violates unique constraint".
--
-- This migration makes `nextval()` safe again for every table that uses one.
-- Idempotent: running it twice yields the same state.

BEGIN;

DO $$
DECLARE
  r record;
  seq text;
  max_id bigint;
BEGIN
  FOR r IN
    SELECT c.oid::regclass::text AS table_name,
           a.attname AS column_name,
           pg_get_serial_sequence(c.oid::regclass::text, a.attname) AS sequence_name
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum > 0 AND NOT a.attisdropped
    WHERE n.nspname = 'public'
      AND c.relkind = 'r'
      AND pg_get_serial_sequence(c.oid::regclass::text, a.attname) IS NOT NULL
  LOOP
    seq := r.sequence_name;
    EXECUTE format('SELECT COALESCE(MAX(%I), 0) FROM %s', r.column_name, r.table_name)
      INTO max_id;

    IF max_id > 0 THEN
      PERFORM setval(seq, max_id, true);
    ELSE
      PERFORM setval(seq, 1, false);
    END IF;
  END LOOP;
END $$;

COMMIT;
