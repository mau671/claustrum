-- FUNCTION: get_suggested_academic_term (invoker)
-- Suggests an academic term based on the study plan modality.
-- For semester modality, suggests Semestre 1 of current year.
-- For other modalities, suggests the first available period of current year.
DROP FUNCTION IF EXISTS public.get_suggested_academic_term(BIGINT);

CREATE OR REPLACE FUNCTION public.get_suggested_academic_term(
  p_study_plan_id BIGINT DEFAULT NULL
)
RETURNS BIGINT
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
DECLARE
  v_modality_id BIGINT;
  v_periods_per_year INTEGER;
  v_current_year INTEGER := EXTRACT(YEAR FROM CURRENT_DATE);
  v_suggested_term_id BIGINT;
BEGIN
  SELECT sp.academic_modality_id, am.periods_per_year
  INTO v_modality_id, v_periods_per_year
  FROM public.study_plan sp
  JOIN public.academic_modality am ON sp.academic_modality_id = am.id
  WHERE sp.id = COALESCE(p_study_plan_id, (
    SELECT usp.study_plan_id
    FROM public.user_study_plan usp
    WHERE usp.user_id = auth.uid() AND usp.is_active = true
    LIMIT 1
  ));

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  IF v_periods_per_year = 2 THEN
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year = v_current_year
      AND period_number = 1
    ORDER BY starts_on ASC
    LIMIT 1;

    IF v_suggested_term_id IS NULL THEN
      SELECT id INTO v_suggested_term_id
      FROM public.academic_term
      WHERE academic_modality_id = v_modality_id
        AND year = v_current_year
        AND period_number = 2
      ORDER BY starts_on ASC
      LIMIT 1;
    END IF;
  ELSE
    SELECT id INTO v_suggested_term_id
    FROM public.academic_term
    WHERE academic_modality_id = v_modality_id
      AND year = v_current_year
    ORDER BY period_number ASC
    LIMIT 1;
  END IF;

  RETURN v_suggested_term_id;
END;
$$;

COMMENT ON FUNCTION public.get_suggested_academic_term IS 'Suggests an academic term based on study plan modality.';
