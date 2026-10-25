BEGIN;

CREATE OR REPLACE FUNCTION public.get_suggested_academic_term(p_study_plan_id bigint DEFAULT NULL::bigint)
 RETURNS bigint
 LANGUAGE plpgsql
 SET search_path TO 'public'
AS $function$
DECLARE
  v_modality_id BIGINT;
  v_suggested_term_id BIGINT;
  v_current_year INTEGER;
BEGIN
  -- Obtain the modality for the given plan, or fallback to the user's active plan
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

  v_current_year := EXTRACT(YEAR FROM CURRENT_DATE);

  -- 1. Try to find the most recent term in the current year that has active offerings
  SELECT at.id INTO v_suggested_term_id
  FROM public.academic_term at
  WHERE at.academic_modality_id = v_modality_id
    AND at.year <= v_current_year
    AND EXISTS (
      SELECT 1
      FROM public.course_offering co
      WHERE co.academic_term_id = at.id
        AND co.is_active = true
    )
  ORDER BY at.year DESC, at.period_number DESC
  LIMIT 1;

  -- 2. If none with active offerings, just get the most recent term up to the current year
  IF v_suggested_term_id IS NULL THEN
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year <= v_current_year
    ORDER BY year DESC, period_number DESC
    LIMIT 1;
  END IF;

  RETURN v_suggested_term_id;
END;
$function$;

COMMIT;
