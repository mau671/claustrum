BEGIN;

DROP FUNCTION IF EXISTS public.get_user_profile_with_context(uuid);

CREATE OR REPLACE FUNCTION public.get_user_profile_with_context(p_user_id uuid)
 RETURNS TABLE(
   user_id uuid,
   carnet text,
   university_id bigint,
   university_name text,
   campus_id bigint,
   campus_name text,
   academic_unit_id bigint,
   academic_unit_name text,
   study_plan_id bigint,
   study_plan_name text,
   user_study_plan_id bigint,
   entry_year integer,
   term_id bigint
 )
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  -- 🔒 SEGURIDAD: Verificar que quien ejecuta es el propio usuario o el Worker de Cloudflare
  IF current_user != 'hyperdrive_user' AND public.current_user_id() != p_user_id THEN
    RAISE EXCEPTION 'Not authorized to view this user profile';
  END IF;

  RETURN QUERY
  SELECT
    u.id AS user_id,
    u.carnet,
    ctx.university_id,
    univ.name AS university_name,
    ctx.campus_id,
    c.name AS campus_name,
    ctx.academic_unit_id,
    au.name AS academic_unit_name,
    ctx.study_plan_id,
    sp.name AS study_plan_name,
    usp.id AS user_study_plan_id,
    usp.entry_year,
    public.get_suggested_academic_term(usp.study_plan_id) AS term_id
  FROM public."user" u
  LEFT JOIN public.user_study_plan usp ON u.id = usp.user_id AND usp.is_active = true
  LEFT JOIN LATERAL public.derive_user_context_from_study_plan(
    usp.study_plan_id,
    usp.campus_id
  ) ctx ON true
  LEFT JOIN public.university univ ON ctx.university_id = univ.id
  LEFT JOIN public.campus c ON ctx.campus_id = c.id
  LEFT JOIN public.academic_unit au ON ctx.academic_unit_id = au.id
  LEFT JOIN public.study_plan sp ON ctx.study_plan_id = sp.id
  WHERE u.id = p_user_id;
END;
$function$;

COMMIT;
