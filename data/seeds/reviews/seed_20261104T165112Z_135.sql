-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=135
-- TEC-DATA-META years=2016,2018,2019,2021,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.081555+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Respetado por los estudiantes', 'Deja trabajos largos']::TEXT[], '2025-02-04T00:00:00+00:00'::TIMESTAMPTZ, 'b8bec9fc86608fe281a4c0866ccb95d1415826b1f79082ce7911e011be8bda6b'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Si quieren pasar fácil la materia matriculen con él. Los trabajos son algo largos pero se hacen fácil. Con que entregue las cosas bien pasan, califica suave, y explica bien. Recomendado'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-11-20T00:00:00+00:00'::TIMESTAMPTZ, '167bfcea624d07d6a8f76f21920fcf4dfaa093f0878ce95e9dad60b06b915591'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2023-09-28T00:00:00+00:00'::TIMESTAMPTZ, 'f120be1eb38acc825e8b5f49ffef396b17fa7c0959eb81e2ca16f659e8ff9ac0'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'El curso es muy interesante y se aprende bastante, el profesor es bueno explicando y le encanta que los estudiantes participen, entonces para eso hay que leerse los documentos que él asigne, si el estudiante no participa por su cuenta, él pregunta al azar. Le encanta debatir de muy buena manera.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Clases largas']::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, '632a05453185497e72657f71d00abe999219dd82c5a0c0e2856183a94402c52c'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '374bf67d6dd58a1e092e01d2d9745c881c70bf2f528a2e0f840294360c909dbb'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-08-07T00:00:00+00:00'::TIMESTAMPTZ, '550ec68a053f1820d24ccb96848635fa08d588f71f63a95325aa58bcbe36b464'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2022-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'f6340b3e49b91970c9cbb2296d0116439f54e362d75f6cc8a46c4f9f1d0c81f9'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Las clases son un poco aburridas pero el curso es fácil'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'f71dd05564cfa6389ee4c84dbd5ce9712afa304a52173ee532df4b62ca4a5442'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2021-08-06T00:00:00+00:00'::TIMESTAMPTZ, '9a77860ef22bc0243863f17d4dbe2a2f0ffb73fdb4f1c992253a9b7d06910887'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-03-26T00:00:00+00:00'::TIMESTAMPTZ, 'dc0deda1209f196da20a6442b1f3624b476bdd378aa0c9a4e0ea27f454c37312'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Hace las clases muuuuuuuuuy aburridas, la materia en sí es fácil. Al principio se deja muchas tareas pero después se pasa más ligero.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'c52a8619ece0593ae69bd02842741d9c7d22b5561d15f96930dd43c4e43f447b'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Explica muy bien'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2019-10-24T00:00:00+00:00'::TIMESTAMPTZ, '0139530c0ec3e607ccbea5f6b7891e0a18a0797fa8ff93de81402cb1a3c081c3'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-08-27T00:00:00+00:00'::TIMESTAMPTZ, 'ad7c439657bfdefe5f7e0d4280ead685ddea1e3ecf11c986923221552676e33c'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-09-04T00:00:00+00:00'::TIMESTAMPTZ, '7fa5eb06ec55d269b9892ba20ad532724a3f4ba9720920c6746b7758f0c59e47'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'Hace proyectos, hay examenes para la casa muy largos, las clases son muy largas y aburridas, tods las semanas tareas escritas, no hay que exponer'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2016-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'fa2d0c0f06424a08c9fb7be8defe3ed0c560afd214279f27538475e69772e148'::TEXT, ARRAY[981]::BIGINT[]),
    (135::BIGINT, 'No prepara muy bien las clases, generando clases largas y no muy provechosas. No evalúa claro.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, '753211aa958a57f06aa99054ffccd805595dd760740cbd69958f11a0fc3843f9'::TEXT, ARRAY[981]::BIGINT[])
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
