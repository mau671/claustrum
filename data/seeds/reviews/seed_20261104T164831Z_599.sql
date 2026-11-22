-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=599
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.800013+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (599::BIGINT, 'Nunca había tenido un profe que falte tanto el respecto, no lo recomiendo para nada, si usted quiere pasarla mal en las clases vaya con él.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-03-20T00:00:00+00:00'::TIMESTAMPTZ, '8a71458657a44d91c8a2241646d31f1f7cb84f3637d52e868ddcd63261a2f99c'::TEXT, ARRAY[1708]::BIGINT[]),
    (599::BIGINT, 'Exámenes muy largos'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-09-26T00:00:00+00:00'::TIMESTAMPTZ, '6df4df27cc298f5e6abd7f9f1511524281b53219bf3e120bc27c729043d481e0'::TEXT, ARRAY[3429]::BIGINT[]),
    (599::BIGINT, 'Clases aburridas de solo leer diapositivas, no da las resoluciones de los ejercicios paso a paso o da respuestas incorrectas Tiene un aire de grandeza y arrogancia, levanta la voz a estudiantes y las explicaciones hay que rogárselas Se pasa bastante fácil, lo difícil es aguantar las clases con él'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-16T00:00:00+00:00'::TIMESTAMPTZ, '77a7b5f2662adac0809fe3866875f66184243b6a77b1badc0a2d257b03cebade'::TEXT, ARRAY[1708]::BIGINT[]),
    (599::BIGINT, 'Nunca envía la solución de las tareas, quizzes o exámenes, el material que da en clase es pobre, además no vienen muchos ejercicios y por lo general los ejercicios de la presentación tienen los resultados malos, explica muy rápido y pierde el tiempo hablando de otros temas. Es arrogante.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2024-05-28T00:00:00+00:00'::TIMESTAMPTZ, 'cfdf601f2c4696255e444d1cd4e09bcce3372497931d562bc1c7bb583883d430'::TEXT, ARRAY[1708]::BIGINT[]),
    (599::BIGINT, 'El profesor no es claro con lo que pide, deja tareas demasiado largas, quita puntos por todo, y es muy fácil perder puntos por todo, no deja prácticas extra solo tarea y no te explica por qué x ejercicio está mal'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2024-03-16T00:00:00+00:00'::TIMESTAMPTZ, 'c8e91f1d2aa7ab230e9e3e451cc8ed229cf760b4d16ff52ca6bffff482fa562b'::TEXT, ARRAY[1708]::BIGINT[])
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
