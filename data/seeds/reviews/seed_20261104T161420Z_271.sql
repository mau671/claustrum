-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=271
-- TEC-DATA-META years=2014,2017,2019,2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.025509+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (271::BIGINT, 'El curso está muy mal distribuido. Dejó un último trabajo de 5% más largo que un proyecto de 20% y con menos tiempo. Cuando uno le pide ayuda siempre tiene que burlarse primero de uno. No se le puede hacer ni una broma porque se enoja, pero él si le puede hacer a uno aparentemente.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos']::TEXT[], '2023-11-08T00:00:00+00:00'::TIMESTAMPTZ, 'aa20126c8a9aa74c54c82baa9f0addb68154b116e6ffa4d70cca6465b2b5b2dd'::TEXT, ARRAY[1045]::BIGINT[]),
    (271::BIGINT, 'Profesor incomprendido, la verdad no es el mejor profe, pero tampoco es tan malo como lo pintan, se esfuerza bastante en enseñar las bases porque él sabe lo que sufren los estudiantes en cursos posteriores.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-05T00:00:00+00:00'::TIMESTAMPTZ, 'bda37e7d4a6d642ab7ecaf6049a9bb504771875c1b7107b259f86e532c0d2890'::TEXT, ARRAY[1030]::BIGINT[]),
    (271::BIGINT, 'Los enunciados de los proyectos y tareas son confusos, clases aburridas, en virtualidad en más de una ocasión interrumpió la clase para contestar llamadas o atender al hijo. Llega sin la clase preparada lo cuál se nota cuando escribe código y no le sirve, utiliza métodos de programación obsoletos.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, '0f9c53c1e99438c744d4174638b43cdae59d70b79458d3ecc41ebc9641d1afdd'::TEXT, ARRAY[1030]::BIGINT[]),
    (271::BIGINT, 'No apoya a los estudiantes, humilla a los mismos. Las clases las da con tecnologías obsoletas y no sabe explicar para nada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2020-08-31T00:00:00+00:00'::TIMESTAMPTZ, '72ce695d7e2c50fd82c5f63ce6ec734b9dbac751dda7becd2a76d4829c56f549'::TEXT, ARRAY[1045]::BIGINT[]),
    (271::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2020-08-05T00:00:00+00:00'::TIMESTAMPTZ, '0082d1b3f115e20d3bf4644cab4e74c1c4a1a7a46cafee10e2a88bdeda7c9f14'::TEXT, ARRAY[1045]::BIGINT[]),
    (271::BIGINT, 'No responde dudas , evaluaciones confusas, humilla a los estudiantes, evaluaciones sin sentido fuera de los contenidos del curso, no conoce las tecnologías en que deja las evaluaciones'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2020-08-05T00:00:00+00:00'::TIMESTAMPTZ, 'e0ca1be375ccff4ecb8ec48dc457a71ef3a1a369b0a50e534f8d2cab749be04f'::TEXT, ARRAY[1045]::BIGINT[]),
    (271::BIGINT, 'Muy paciente y no duda en scar tiempo adicional para ayudar o explicar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2019-04-25T00:00:00+00:00'::TIMESTAMPTZ, '20d17b1ab4e3ce7cc46bbee15cf4c8071ba37ce7f87772e4dbf993e2610ef593'::TEXT, ARRAY[1167]::BIGINT[]),
    (271::BIGINT, 'No sabe de lo que está hablando, se enrreda solo.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Exámenes retadores', 'Deja trabajos largos']::TEXT[], '2017-11-20T00:00:00+00:00'::TIMESTAMPTZ, '91e7f17b18eea13f276d53542fbdd97923ecc24aa2b0c443c80c25a61f227e32'::TEXT, ARRAY[1029]::BIGINT[]),
    (271::BIGINT, 'Este profe, repite semestralmente todas las clases, no investiga cosas nuevas a pesar de que el curso es de alto interés y sobre todo de alta importancia. Siempre ponen al mismo profe sin abrir espacio a nuevos profesionales y a gente que no siga en sistemas obsoletos'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '7860987e55fb08e774c4f346ed53e54f33b5b00a8320844bf1061cff3a5c1b25'::TEXT, ARRAY[1045, 1054]::BIGINT[]),
    (271::BIGINT, 'Buen profe, pero aún le falta en clases'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-18T00:00:00+00:00'::TIMESTAMPTZ, '7f960780276d6cac72ef8bf7e62609cf4e78c0f48b5d7b5fb284318faddbb700'::TEXT, ARRAY[1054]::BIGINT[])
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
