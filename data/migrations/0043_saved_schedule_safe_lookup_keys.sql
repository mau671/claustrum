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
      upper(trim(item->>'courseCode')) AS course_code,
      trim(item->>'groupCode') AS group_code,
      CASE
        WHEN item ? 'campusId' AND item->>'campusId' ~ '^\d+$'
          THEN (item->>'campusId')::BIGINT
        ELSE NULL
      END AS campus_id
    FROM jsonb_array_elements(p_group_lookups) AS item
    WHERE item ? 'courseCode'
      AND item ? 'groupCode'
      AND trim(item->>'courseCode') <> ''
      AND trim(item->>'groupCode') <> ''
  ), inserted_items AS (
    INSERT INTO public.saved_schedule_item (
      saved_schedule_id,
      course_offering_group_id
    )
    SELECT DISTINCT
      v_schedule_id,
      cog.id
    FROM requested_groups rg
    JOIN public.course c
      ON c.code = rg.course_code
    JOIN public.course_offering co
      ON co.course_id = c.id
     AND co.academic_term_id = p_academic_term_id
     AND co.is_active = true
     AND (rg.campus_id IS NULL OR co.campus_id = rg.campus_id)
    JOIN public.course_offering_group cog
      ON cog.course_offering_id = co.id
     AND cog.group_code = rg.group_code
     AND cog.is_active = true
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

DROP FUNCTION IF EXISTS public.get_user_saved_schedule_group_lookups(BIGINT);

CREATE OR REPLACE FUNCTION public.get_user_saved_schedule_group_lookups(
  p_saved_schedule_id BIGINT
)
RETURNS TABLE (
  course_code TEXT,
  campus_id BIGINT,
  group_code TEXT
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    c.code AS course_code,
    co.campus_id,
    cog.group_code
  FROM public.saved_schedule ss
  JOIN public.saved_schedule_item ssi
    ON ssi.saved_schedule_id = ss.id
  JOIN public.course_offering_group cog
    ON cog.id = ssi.course_offering_group_id
  JOIN public.course_offering co
    ON co.id = cog.course_offering_id
  JOIN public.course c
    ON c.id = co.course_id
  WHERE ss.id = p_saved_schedule_id
    AND ss.user_id = auth.uid()
  ORDER BY c.code, co.campus_id, cog.group_code;
$$;

REVOKE ALL ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_user_schedule(TEXT, BIGINT, JSONB) TO authenticated;

REVOKE ALL ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_user_saved_schedule_group_lookups(BIGINT) TO authenticated;
