-- ============================================================================
-- MIGRATION: Filter academic units and plans by campus
-- ============================================================================
-- This migration updates functions to filter academic units and study plans
-- by campus availability, ensuring only valid options are shown in the UI.

DROP FUNCTION IF EXISTS public.get_academic_units_for_campus(BIGINT);

DROP FUNCTION IF EXISTS public.get_study_plans_for_campus_and_academic_unit(BIGINT, BIGINT);

-- ============================================================================
-- FUNCTION: get_academic_units_for_campus (updated)
-- ============================================================================
-- Returns academic units with study plans available at a specific campus.
CREATE OR REPLACE FUNCTION public.get_academic_units_for_campus(p_campus_id BIGINT)
RETURNS TABLE (id BIGINT, code TEXT, name TEXT)
LANGUAGE plpgsql
SET search_path = public
SECURITY INVOKER
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT au.id, au.code, au.name
  FROM public.v_academic_units_with_plans au
  WHERE au.id IN (
    SELECT academic_unit_id
    FROM public.academic_unit_campus
    WHERE campus_id = p_campus_id
  )
  ORDER BY au.name;
END;
$$;

COMMENT ON FUNCTION public.get_academic_units_for_campus IS 'Returns academic units with study plans available at a specific campus.';

-- ============================================================================
-- FUNCTION: get_study_plans_for_campus_and_academic_unit (new)
-- ============================================================================
-- Returns study plans for a specific academic unit and campus.
-- Only returns plans that are valid for the selected campus or have no campus restriction.
-- This filters out old plans that were created before certain campuses existed.
CREATE OR REPLACE FUNCTION public.get_study_plans_for_campus_and_academic_unit(
  p_academic_unit_id BIGINT,
  p_campus_id BIGINT
)
RETURNS TABLE (id BIGINT, academic_unit_id BIGINT, external_plan_id INTEGER, name TEXT, academic_degree TEXT)
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
    sp.academic_degree
  FROM public.study_plan sp
  WHERE sp.academic_unit_id = p_academic_unit_id
    AND (
      sp.id IN (
        SELECT study_plan_id
        FROM public.study_plan_campus
        WHERE campus_id = p_campus_id
      )
      OR NOT EXISTS (
        SELECT 1
        FROM public.study_plan_campus
        WHERE study_plan_id = sp.id
      )
    )
  ORDER BY sp.external_plan_id DESC;
END;
$$;

COMMENT ON FUNCTION public.get_study_plans_for_campus_and_academic_unit IS 'Returns study plans for a specific academic unit and campus, filtering by campus availability.';
