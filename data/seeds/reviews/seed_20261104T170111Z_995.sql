-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=995
-- TEC-DATA-META years=2014,2015,2017,2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.066164+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (995::BIGINT, 'Domina muy bien la materia por lo que la explica de manera clara. Como profesora en este curso es bastante buena. Sentí que aprendí bastante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2023-11-01T00:00:00+00:00'::TIMESTAMPTZ, '2f611490c665102d6baf6bba57a2242e7551540064414ef0a90fd8bf499efb44'::TEXT, ARRAY[1056]::BIGINT[]),
    (995::BIGINT, 'Sin duda alguna, una de las peores profesoras que he tenido, su actitud ha sido demasiado negativa, no parece gustarle ser profesora, no ayuda, no se toma bien las críticas constructivas ni las evaluaciones a docente, deja guías que ni sirven en angular, etc... cero recomendable'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-10-18T00:00:00+00:00'::TIMESTAMPTZ, '5f4b38b2da0cf9e972c45697bbcf06036ab666d8a656ed7eefdd54e383025009'::TEXT, ARRAY[1056]::BIGINT[]),
    (995::BIGINT, 'No se siente que le guste enseñar, deja trabajos super largos, pesima actitud, si uno le pregunta algo contesta sin ganas'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-10-18T00:00:00+00:00'::TIMESTAMPTZ, '9590f60133d9df88b6c62b39a3a7c04feb980a8162c1863d6da2792d94c48d92'::TEXT, ARRAY[1056]::BIGINT[]),
    (995::BIGINT, 'Los laboratorios son demasiado largos, todo lo complica mucho, es muy muy estricta, no matriculen con ella'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2021-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'f6a6171d9c4b55823e980d04a65262032b9c1c9f88abd984cd5009f6ec0e95b3'::TEXT, ARRAY[1249]::BIGINT[]),
    (995::BIGINT, 'Si no hay otro, pues suerte.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, 'e92d37c7227d967624853ef01111a965d9af2efe0d7db525eec6a06fc5abd956'::TEXT, ARRAY[2926]::BIGINT[]),
    (995::BIGINT, 'Ni lo intenten, cualquier opción es mejor'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '15b450c4b5685bacdf83b1feafce1a358d301adb1e9607d9d9c7603631f547d3'::TEXT, ARRAY[1037]::BIGINT[]),
    (995::BIGINT, 'Excelente profesora! Ha mejorado mucho a lo largo de los años, materia super clara, dinámica y mucho trabajo en equipo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Aspectos de calificación claros']::TEXT[], '2017-11-16T00:00:00+00:00'::TIMESTAMPTZ, '93a1cc491983966c87a821918080232f85a286fd5e4adc918e406afef9992f4a'::TEXT, ARRAY[1056]::BIGINT[]),
    (995::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, '0dd1d09ab04f1fd90e94d8746a1f8a9a70e46ffd50ea8d060f294051ba9e7810'::TEXT, ARRAY[1037]::BIGINT[]),
    (995::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'b480cfe607525e314bcecec345c5517a10678cce0e01d2cc4769de77ce9819f9'::TEXT, ARRAY[1030]::BIGINT[]),
    (995::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-29T00:00:00+00:00'::TIMESTAMPTZ, '0e07c7bf3aa7bcf0e47e9fd5f7aaea33c5a2b51da6c9fca997c6c58dc5b24bf8'::TEXT, ARRAY[1030]::BIGINT[]),
    (995::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-23T00:00:00+00:00'::TIMESTAMPTZ, '2f3fd1f0ae3c3b5142915026d093d42459133d81fcd9d7a210a01c0dbe9a8193'::TEXT, ARRAY[1030]::BIGINT[])
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
