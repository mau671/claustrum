-- 0154_optimize_academic_units_and_harden_search_path.sql
-- 1. Optimizes get_academic_units_with_professors using EXISTS instead of 4-table DISTINCT join.
-- 2. Hardens search_path on mutable functions flagged by security advisor.

CREATE OR REPLACE FUNCTION public.get_academic_units_with_professors()
RETURNS TABLE(id integer, code text, name text)
LANGUAGE sql
STABLE
SET search_path TO 'public'
AS $function$
  SELECT au.id, au.code, au.name
  FROM public.academic_unit au
  WHERE EXISTS (
    SELECT 1
    FROM public.course_offering co
    JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
    JOIN public.course_offering_group_professor cogp
      ON cogp.course_offering_group_id = cog.id
    WHERE co.academic_unit_id = au.id
  )
  ORDER BY au.name;
$function$;

ALTER FUNCTION public.current_user_id() SET search_path = public;
ALTER FUNCTION public.current_jwt_claims() SET search_path = public;
ALTER FUNCTION public.reply_to_feedback(bigint, text, text) SET search_path = public;
