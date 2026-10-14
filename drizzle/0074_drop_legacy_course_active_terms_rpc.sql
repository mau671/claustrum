-- 0074_drop_legacy_course_active_terms_rpc.sql

BEGIN;

DROP FUNCTION IF EXISTS public.get_course_active_academic_terms(BIGINT, BIGINT, BIGINT, BIGINT);

COMMIT;
