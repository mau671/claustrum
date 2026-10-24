-- 0152_drop_lookup_sort_order.sql
-- Removes `sort_order` from the lookup tables added in 0151.
--
-- It was never consumed: no query, RPC, API handler or frontend component
-- reads it. The sync wrote a constant 100, and the seeded ordering had no
-- effect anywhere. Ordering is better expressed at the point of use
-- (ORDER BY name, or a presentation order in the client) than as a manually
-- maintained integer that silently drifts.
--
-- Safe to drop: no view, function, index or constraint references the column.

BEGIN;

ALTER TABLE public.group_type     DROP COLUMN IF EXISTS sort_order;
ALTER TABLE public.academic_degree DROP COLUMN IF EXISTS sort_order;
ALTER TABLE public.course_type    DROP COLUMN IF EXISTS sort_order;

COMMENT ON TABLE public.group_type IS
  'Catalogue of group delivery types published by the ITCR (REGULAR, VIRTUAL, ...). '
  'A lookup table instead of an enum so the sync can add new values without DDL.';

COMMENT ON TABLE public.academic_degree IS
  'Academic degrees awarded by the institution. Lookup table so a new degree '
  'can be added without a DDL migration.';

COMMENT ON TABLE public.course_type IS
  'Course type classification as published by the ITCR (CURSO UNICO, ELECTIVA, ...). '
  'Values change over time, so this is a lookup rather than an enum.';

COMMIT;
