-- 0072_drop_legacy_course_equivalents_rpc.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_equivalents_for_plan(BIGINT, BIGINT, INTEGER, INTEGER);

COMMIT;
