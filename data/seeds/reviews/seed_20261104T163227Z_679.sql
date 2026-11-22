-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=679
-- TEC-DATA-META years=2018,2019,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.078028+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (679::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'c2c9f908fb366967ab953b436e69a357c83e035d22633480228693b75bbd93dc'::TEXT, ARRAY[2613]::BIGINT[]),
    (679::BIGINT, 'Las primeras semanas del curso son muy intensas, deja tareas muy extensas y que tienen muy poco valor, la participación en clase se califica con palitos, ni intente discutir con él. PD. Estudie más los exámenes de años anteriores que la materia que da en clase.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, '41b006125c2a57a28994a8cc5898477a5fb96c1437d7d4ba8bd6aa520f4c9699'::TEXT, ARRAY[2620]::BIGINT[]),
    (679::BIGINT, 'A poner atención, nada más! es un poco duro, eso sí, se aprende mucho'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, '3e1690b59ed17581e9260fd82f63547ed93b26578e00e63151fbd39aa536fa55'::TEXT, ARRAY[4295, 4297, 4298]::BIGINT[]),
    (679::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '1fd16ebd44e61f8ccc037a41d17ffed3ef7435731ffe3c07862458290d7903b6'::TEXT, ARRAY[4295, 4297, 4298]::BIGINT[]),
    (679::BIGINT, 'El profesor es sumamente prepotente, el NUNCA se equivoca, ni intenten discutir con el algo, que siempre es dueño de la razón, aveces no sabe de lo que está hablando y pide a los estudiantes búscar en Google la respuesta a las preguntas que le hacen.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '600cefdbc47ce5a961eac18b4e81b463523c38db896a14c6bb81f7a15e981018'::TEXT, ARRAY[2613]::BIGINT[]),
    (679::BIGINT, 'Las clases son muy pesadas, como profesor le falta mucho, también es muy arrogante, no se interesa que el estudiante logre aprender, facilidad de ayuda es de 0.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'a86341ac125742d545c889fef7445ac5e77f6a23a7aca6b2286c158617906df7'::TEXT, ARRAY[2633]::BIGINT[]),
    (679::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa']::TEXT[], '2019-01-27T00:00:00+00:00'::TIMESTAMPTZ, '8b0bc4c6758c139232c7affff2687f16d699ddaaea33ef64e7893aa8317b7cf7'::TEXT, ARRAY[2620]::BIGINT[]),
    (679::BIGINT, 'Deja tareas muy largas que son de poco valor Nuca pierde Si se equivoca en la calificación de trabajos, exámenes, quiz o tareas hace las correcciones solamente a los estudiantes que se dan cuanta y no a todo el grupo Los rubros de evaluación nunca son claros'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2018-06-11T00:00:00+00:00'::TIMESTAMPTZ, '6164dbdca1da4055f156c5fc652e8e0759acedecd5d88ca9e7a010f46837a124'::TEXT, ARRAY[2633]::BIGINT[])
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
