BEGIN;

CREATE OR REPLACE FUNCTION public.moderate_evaluation(
  p_evaluation_id BIGINT,
  p_new_status public.evaluation_status,
  p_moderation_note TEXT DEFAULT NULL
)
RETURNS public.course_evaluations
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  updated_row public.course_evaluations;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Not authorized';
  END IF;

  IF p_new_status NOT IN ('approved', 'rejected') THEN
    RAISE EXCEPTION 'Invalid moderation status: %', p_new_status;
  END IF;

  UPDATE public.course_evaluations ce
  SET
    status = p_new_status,
    moderation_note = p_moderation_note,
    moderated_by = public.current_user_id(),
    moderated_at = NOW(),
    updated_at = NOW()
  WHERE ce.id = p_evaluation_id
  RETURNING ce.* INTO updated_row;

  IF updated_row.id IS NULL THEN
    RAISE EXCEPTION 'Evaluation not found: %', p_evaluation_id;
  END IF;

  RETURN updated_row;
END;
$$;

REVOKE ALL ON FUNCTION public.moderate_evaluation(BIGINT, public.evaluation_status, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.moderate_evaluation(BIGINT, public.evaluation_status, TEXT) TO authenticated;

COMMIT;
