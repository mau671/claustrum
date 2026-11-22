-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=466
-- TEC-DATA-META years=2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:34:23.275231+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (466::BIGINT, 'Tiene un ego que no lo deja entender a sus estudiantes, prioriza su ego antes que el bienestar de sus estudiantes y si agarra a alguno entre ojos le hace la vida imposible, en general la escuela de seguridad laboral es un asco e ineficiente'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas']::TEXT[], '2025-12-22T00:00:00+00:00'::TIMESTAMPTZ, '3487a2190ecd6ad693b06df3f1946df1b5f95d3fb13121e15cc887e587108345'::TEXT, ARRAY[1491]::BIGINT[]),
    (466::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2025-08-21T00:00:00+00:00'::TIMESTAMPTZ, 'd317c8cb9bf5611c59c993afe70e3f2ebbccb4d66a9365ca7e2a3d3608f71a82'::TEXT, ARRAY[3087]::BIGINT[]),
    (466::BIGINT, 'Lo hizo un curso más pesado de lo que es en comparación con los otros profes, no lo volvería a llevar con él.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Clases largas']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, '5d52d2e7d4f6cf70ef11763c4dfcbefb61a30532ef2701364cbe9fcefb83646d'::TEXT, ARRAY[155]::BIGINT[]),
    (466::BIGINT, 'Excelente profesor, si te gusta que expliquem detalladamente los temas este es tu profesor, califica bastantemente suave, sus exámenes no son tan duros a como se creen, también prepárate para leer mucho, los quizes son más duros que los propios exámenes'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2025-06-27T00:00:00+00:00'::TIMESTAMPTZ, '6ea2535d5eed3c04f5ec1b5ee9dc2a60cd6ac6f401c4202ea44a2310aa7156a5'::TEXT, ARRAY[3087]::BIGINT[])
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
