CREATE OR REPLACE FUNCTION public.get_suggested_academic_term(p_study_plan_id bigint DEFAULT NULL::bigint)
 RETURNS bigint
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
DECLARE
  v_modality_id BIGINT;
  v_suggested_term_id BIGINT;
BEGIN
  SELECT sp.academic_modality_id
  INTO v_modality_id
  FROM public.study_plan sp
  WHERE sp.id = COALESCE(p_study_plan_id, (
    SELECT usp.study_plan_id
    FROM public.user_study_plan usp
    WHERE usp.user_id = public.current_user_id() AND usp.is_active = true
    LIMIT 1
  ));

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT at.id INTO v_suggested_term_id
  FROM public.academic_term at
  WHERE at.academic_modality_id = v_modality_id
    AND EXISTS (
      SELECT 1
      FROM public.course_offering co
      WHERE co.academic_term_id = at.id
        AND co.is_active = true
    )
  ORDER BY at.year DESC, at.period_number DESC
  LIMIT 1;

  IF v_suggested_term_id IS NULL THEN
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
    ORDER BY year DESC, period_number DESC
    LIMIT 1;
  END IF;

  RETURN v_suggested_term_id;
END;
$function$;
