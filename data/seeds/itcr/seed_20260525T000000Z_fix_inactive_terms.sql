-- ============================================================================
-- TEC-DATA-META scope=all
-- TEC-DATA-META years=
-- TEC-DATA-META term_external_keys=
-- ============================================================================
-- FIX: Reactivate academic terms that have active course offerings but were
-- incorrectly marked as is_active = FALSE by the initial seed.
-- Only affects terms from 2024 onward; 2020-2023 terms were already correct.
-- ============================================================================

BEGIN;

UPDATE public.academic_term at
SET
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW()
WHERE at.is_active = FALSE
  AND EXISTS (
    SELECT 1
    FROM public.course_offering co
    WHERE co.academic_term_id = at.id
      AND co.is_active = TRUE
  );

COMMIT;
