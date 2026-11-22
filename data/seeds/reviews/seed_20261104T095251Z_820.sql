-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=820
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.476473+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (820::BIGINT, 'Es un buen profe, si ud le cae bien le ayuda un montón en exámenes y quizes, es muy gracioso y le va a ayudar en todo. Si es mujer, cuidese un poco, el suele ser un poco sugerente, a veces hace comentarios un poco fuera de lugar y hace que una se sienta incómoda. Se vuelve pesado estar cerca de él'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Brinda apoyo']::TEXT[], '2026-10-16T00:00:00+00:00'::TIMESTAMPTZ, '5e6e6e2f7494f364ec98a1bf99192781b6302e61c1d5f2f79c83a0e2b1c53370'::TEXT, ARRAY[614, 568]::BIGINT[]),
    (820::BIGINT, 'Es un profe muy buena nota, siempre se esfuerza para que los estudiantes entiendan y es muy flexible a la hora de entregar trabajos. Lo único malo que tiene es que su forma de explicar es algo compleja si eres de primer ingreso pero por lo demás es excelente profesor. Lo recomiendo demasiado 10/1'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-09-13T00:00:00+00:00'::TIMESTAMPTZ, '34faa3c3a59681e534ed153de88ffbe58318a1d606ebe54fdfca52449e522830'::TEXT, ARRAY[568]::BIGINT[]),
    (820::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-04-23T00:00:00+00:00'::TIMESTAMPTZ, '4ab915b6848e9aa5e4609478a20d227eb17577afdcf48be9ae4cfb64fed40389'::TEXT, ARRAY[614, 568]::BIGINT[]),
    (820::BIGINT, 'Es pura vida, hay gente que dice que no le entienden, pero sólo es dar de nuestra parte como en cualquier curso y se pasa sencillo, es tranquilo y ayuda, hace quices que los basa en el material que sube y los exámenes es parecido, la química es de estudiar, no sean vagos echándole culpas al profe.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, '69db814751e33d331b4e387fa177e0f24c438a0e151f993c442be834f278e45a'::TEXT, ARRAY[4526]::BIGINT[]),
    (820::BIGINT, 'Muy buen profesor, se esfuerza para que uno entienda. Siempre esta dispuesto a explicar las veces que sean necesarias y ayudarlo a uno. Si puede llevar un curso con él, háganlo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-09-25T00:00:00+00:00'::TIMESTAMPTZ, '14c9b1cd9af6df01c8108ada6197d1f6505f2d275278b25e6d9270c5b8e6937b'::TEXT, ARRAY[614, 573]::BIGINT[])
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
    attendance_required, grade_received, engagement_level, tags, status, reviewed_at, created_at, updated_at, import_key
  )
  SELECT 
    professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
    attendance_required, grade_received, engagement_level, tags, 'approved'::public.professor_review_status, now(), created_at, created_at, import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1 FROM public.professor_review pr WHERE pr.import_key = ri.import_key
  )
  RETURNING id, import_key
), target_review AS (
  SELECT id, import_key FROM inserted_review
  UNION ALL
  SELECT pr.id, pr.import_key
  FROM public.professor_review pr
  JOIN review_input ri ON ri.import_key = pr.import_key
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
JOIN review_input ri ON ri.import_key = tr.import_key
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT DO NOTHING;

COMMIT;
