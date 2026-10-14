-- ============================================================================
-- MIGRATION: Add modality_name to study plans query
-- ============================================================================
-- This migration adds modality_name to the get_study_plans_for_academic_unit
-- function to return the academic modality name (SEMESTRE, BIMESTRE, etc.)

DROP FUNCTION IF EXISTS public.get_study_plans_for_academic_unit(BIGINT);

-- FUNCTION: get_study_plans_for_academic_unit (invoker)
-- ============================================================================
-- Returns study plans for a specific academic unit, ordered by newest first.
-- Includes modality_name for displaying the academic term type.
CREATE OR REPLACE FUNCTION public.get_study_plans_for_academic_unit(p_academic_unit_id BIGINT)
RETURNS TABLE (id BIGINT, academic_unit_id BIGINT, external_plan_id INTEGER, name TEXT, academic_degree TEXT, modality_name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    sp.id, 
    sp.academic_unit_id, 
    sp.external_plan_id, 
    sp.external_plan_id::TEXT || ' - ' || sp.name AS name, 
    sp.academic_degree,
    am.name AS modality_name
  FROM public.study_plan sp
  LEFT JOIN public.academic_modality am ON sp.academic_modality_id = am.id
  WHERE sp.academic_unit_id = p_academic_unit_id
  ORDER BY sp.external_plan_id DESC;
END;
$$;

COMMENT ON FUNCTION public.get_study_plans_for_academic_unit IS 'Returns study plans for a specific academic unit with modality name.';
