-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=133
-- TEC-DATA-META years=2017,2018,2019,2020,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.325479+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (133::BIGINT, 'Califica muy suave, uno aprende bastante, es muy comprensivo y los trabajos no son dificiles'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa']::TEXT[], '2026-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'cbeac3b7e6ba2291225a61f9c760ac3a0826d45ca96dff7d6da712946110f9ec'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Un excelente profe! Sus clases son divertidas e interesantes, pone bastantes tareas y presentaciones grupales donde siempre saca datos curiosos de la historia de este país. Si quiere aprender más de Costa Rica lleve con el'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2026-02-18T00:00:00+00:00'::TIMESTAMPTZ, '8b01e1cdd7c22f7d7e06ab76f6cc330d7e2d1f83ec3cf8bc3ec4021822a27ea8'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'El mejor profe de ciencias sociales, es comprensivo y las clases son excelentes, el curso se pasa con sólo entregar las evaluaciones'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-11-29T00:00:00+00:00'::TIMESTAMPTZ, '42ea072f47536a31ec4e222a934bd2675bfcac7ea8718ebd4079d78a42655d8b'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Excelente profe, tiene mucho conocimiento, las clases no son aburridas, es super comprensivo y es muy fácil el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2025-01-29T00:00:00+00:00'::TIMESTAMPTZ, '7b767069439e3b0eae32196f72d4480e5e23e6a33b55cca6385ef283742f4897'::TEXT, ARRAY[3834]::BIGINT[]),
    (133::BIGINT, 'Excelente profe, conoce mucho los temas de curso, el curso si se hacen todos los trabajos y entregas a tiempo se pasa con cien no suelen ser muy pesados los trabajos y siempre pasa lista'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2023-12-12T00:00:00+00:00'::TIMESTAMPTZ, 'd080e60f459d9f52281e05aa4e56264b24a303fbaf53098ca20dac46e18131ac'::TEXT, ARRAY[3133]::BIGINT[]),
    (133::BIGINT, 'Excelente profe, sereno traquilo, su objetivo es que lo estudiantes aprendan, no hay que abusarse de la confianza que da. Como profesor de turismo es excelente tiene muho conocimiento y muchos titulos universitarios.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'c22dc393e690cb7e6783dd244a1673d6129fd11a1df6c604bd7aac65f91dbff2'::TEXT, ARRAY[3133]::BIGINT[]),
    (133::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'd08296275d10d4906ded5048811d331643c7f8cc54f7376a49ae57bf9d3e35bc'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Excelente profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ec49dfec031bc593e418c4d8eea9aae4894bb077af7994dcc421dda5efd9df3e'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'el profe es bueno, pero deja bastantes trabajos y exposiciones, que son bastantes fáciles la verdad, pero para que tomen en cuenta si no quieren invertir tanto tiempo a seminario. Si se entrega todo de fijo se pasa con 100.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2023-06-08T00:00:00+00:00'::TIMESTAMPTZ, '81a4488c1622146b25d154c6001be0cf4c1b3d39bc30b3009854472ac6fda027'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'No evalua con examenes, sino con la construccion de proyectos, ensayos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-05-03T00:00:00+00:00'::TIMESTAMPTZ, '366fe91cf0851f0e235baceb129d78d740683859c0ef3518eac5fd56706d3ecc'::TEXT, ARRAY[3136]::BIGINT[]),
    (133::BIGINT, 'El curso es muy aburrido pero con este mae se pasa super facil; al chile es muy dificil que uno no logre pasar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura']::TEXT[], '2020-08-18T00:00:00+00:00'::TIMESTAMPTZ, 'd31e0ea6a9b0150402bf0f914c38473bf090560a22510f6c8dac896b7c09f855'::TEXT, ARRAY[559]::BIGINT[]),
    (133::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2020-08-08T00:00:00+00:00'::TIMESTAMPTZ, '45b0f9de59d6a4b0250fa53012eea0b84190e32880729ecba8761d9a55910502'::TEXT, ARRAY[559]::BIGINT[]),
    (133::BIGINT, 'Tuve mis dudas de matricular debido a las pocas calificaciones, sin embargo ha sido el mejor curso de ciencias sociales que llevé, se aprende bastante sobre el país, las clases son dinámicas, las tareas son cortas y se hace una gira a talamanca al final del semestre que es genial para liberar estrés'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-12-31T00:00:00+00:00'::TIMESTAMPTZ, 'c54a00df3cc3ec01664b3075f4c0e172b026ffa86c8c7d4d7ecd764d1f0eae07'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Deja varias tareas pero son cortas, hace una gira muy bonita y hace que la clase no sea tan aburrida.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2018-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'b9fe9cd2c98e486031dc5608e1da1df32d5a20a644c993d60e75bdb21fdd7173'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Buen profe, siempre hace una gira a talamanca opcional, las tareas son súper cortas y sencillas y el trabajo final es muy fácil, todo mundo pasa con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'ff2c06e9401a8bbd57b74fc1273653e9a9f027470557bd8f9a0eb1cef9231e48'::TEXT, ARRAY[1004]::BIGINT[]),
    (133::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-18T00:00:00+00:00'::TIMESTAMPTZ, 'dad203445d9c5c4bc566cc03a4bb9f3e9a2dd4aa220fa4718c136db8b0470fb2'::TEXT, ARRAY[1004]::BIGINT[])
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
