CREATE OR REPLACE FUNCTION public.save_user_schedule(
  p_name TEXT,
  p_academic_term_id BIGINT,
  p_group_lookups JSONB
)
RETURNS TABLE (
  id BIGINT,
  name TEXT,
  academic_term_id BIGINT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_schedule_id BIGINT;
  v_inserted_count INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'No autenticado' USING ERRCODE = '28000';
  END IF;

  IF p_name IS NULL OR trim(p_name) = '' THEN
    RAISE EXCEPTION 'El nombre del horario es requerido' USING ERRCODE = '22023';
  END IF;

  IF p_group_lookups IS NULL OR jsonb_typeof(p_group_lookups) <> 'array' THEN
    RAISE EXCEPTION 'Los grupos seleccionados son invalidos' USING ERRCODE = '22023';
  END IF;

  INSERT INTO public.saved_schedule (user_id, name, academic_term_id)
  VALUES (v_user_id, trim(p_name), p_academic_term_id)
  RETURNING saved_schedule.id INTO v_schedule_id;

  WITH requested_groups AS (
    SELECT DISTINCT
      (item->>'offeringId')::BIGINT AS offering_id,
      item->>'groupCode' AS group_code
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'offeringId'
      AND item ? 'groupCode'
      AND item->>'offeringId' ~ '^\d+$'
      AND trim(item->>'groupCode') <> ''
  ), inserted_items AS (
    INSERT INTO public.saved_schedule_item (
      saved_schedule_id,
      course_offering_group_id
    )
    SELECT
      v_schedule_id,
      cog.id
    FROM requested_groups rg
    JOIN public.course_offering_group cog
      ON cog.course_offering_id = rg.offering_id
     AND cog.group_code = rg.group_code
    RETURNING 1
  )
  SELECT count(*) INTO v_inserted_count
  FROM inserted_items;

  IF v_inserted_count = 0 THEN
    DELETE FROM public.saved_schedule WHERE saved_schedule.id = v_schedule_id;
    RAISE EXCEPTION 'No se encontraron grupos validos para guardar' USING ERRCODE = '22023';
  END IF;

  RETURN QUERY
  SELECT
    ss.id,
    ss.name,
    ss.academic_term_id,
    ss.created_at,
    ss.updated_at
  FROM public.saved_schedule ss
  WHERE ss.id = v_schedule_id
    AND ss.user_id = v_user_id;
END;
$$;

REVOKE ALL ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_user_saved_schedule_group_lookups(
  p_saved_schedule_id BIGINT
)
RETURNS TABLE (
  course_offering_id BIGINT,
  group_code TEXT
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    cog.course_offering_id,
    cog.group_code
  FROM public.saved_schedule ss
  JOIN public.saved_schedule_item ssi
    ON ssi.saved_schedule_id = ss.id
  JOIN public.course_offering_group cog
    ON cog.id = ssi.course_offering_group_id
  WHERE ss.id = p_saved_schedule_id
    AND ss.user_id = auth.uid()
  ORDER BY cog.course_offering_id, cog.group_code;
$$;

REVOKE ALL ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) TO authenticated;
