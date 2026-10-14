BEGIN;

CREATE OR REPLACE FUNCTION public.moderate_professor_review_report(
  p_report_id BIGINT,
  p_new_status public.professor_review_report_status,
  p_resolution_note TEXT DEFAULT NULL
)
RETURNS public.professor_review_report
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  updated_row public.professor_review_report;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF p_new_status NOT IN ('resolved', 'dismissed') THEN
    RAISE EXCEPTION 'Invalid moderation status: %', p_new_status;
  END IF;

  UPDATE public.professor_review_report r
  SET
    status = p_new_status,
    resolution_note = NULLIF(BTRIM(COALESCE(p_resolution_note, '')), ''),
    resolved_by = public.current_user_id(),
    resolved_at = NOW(),
    updated_at = NOW()
  WHERE r.id = p_report_id
  RETURNING r.* INTO updated_row;

  IF updated_row.id IS NULL THEN
    RAISE EXCEPTION 'Report not found: %', p_report_id;
  END IF;

  -- Automatically reject the underlying review if the report is resolved
  IF p_new_status = 'resolved' THEN
    UPDATE public.professor_review
    SET
      status = 'rejected',
      moderation_note = COALESCE(NULLIF(BTRIM(COALESCE(p_resolution_note, '')), ''), 'Rechazado automáticamente al resolver un reporte.'),
      reviewed_by = public.current_user_id(),
      reviewed_at = NOW(),
      updated_at = NOW()
    WHERE id = updated_row.review_id
      AND status != 'rejected';
  END IF;

  RETURN updated_row;
END;
$$;

COMMIT;
