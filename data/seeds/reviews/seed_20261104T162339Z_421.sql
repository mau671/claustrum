-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=421
-- TEC-DATA-META years=2017,2018,2019,2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.988015+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (421::BIGINT, 'Considero que hay cursos en los que le falta mucho, y este es uno de ellos, se limita mucho a las presentaciones, y ejercicios muy simples. Creo que sus clases podrían ser más llevaderas si se esforzara más en ello, porque a veces se vuelven aburridas. No le gusta que lo corrijan.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-04-23T00:00:00+00:00'::TIMESTAMPTZ, '5e020589beff644aabd42f927b80ed8dbf519d2d108a26f4f2623336e910161b'::TEXT, ARRAY[1305]::BIGINT[]),
    (421::BIGINT, 'El profe es muy cosi pero no quiere decir que regala el curso, hay que llevar la materia al día y estar viendo los videos de clases anteriores'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2021-08-03T00:00:00+00:00'::TIMESTAMPTZ, 'e4683833b4fa77877dfacc9926d89f75706258bb069f3fa925268327a395b4d2'::TEXT, ARRAY[610]::BIGINT[]),
    (421::BIGINT, 'Es muy bueno para trasmitir el conocimiento y trata siempre de que a todos los estudiantes les quede claro todo.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, 'fe802e749106d9f978fbb1bd0d68fd4abb372d8a6a650deae8e948bd0f26bc0d'::TEXT, ARRAY[1256]::BIGINT[]),
    (421::BIGINT, 'Es muy buen profe, se le entiendo mucho y en las horas consulta es bastante bueno...'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'a5f0ae22cf89e8026359083da91df195c1643d2be73ae8f78599e5ffcaecce88'::TEXT, ARRAY[4769, 1182, 637, 1999, 636, 1726, 640]::BIGINT[]),
    (421::BIGINT, 'Se aprende mucho con el, pero su forma de calificar es muy exigente'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-23T00:00:00+00:00'::TIMESTAMPTZ, '06f58c093001f6fd5e3fe8a077d850612754b50efd376990909d23a0cc8ae497'::TEXT, ARRAY[610]::BIGINT[]),
    (421::BIGINT, 'Un excelente profesor, lo recomiendo al 100%, explica muy bien y las veces que sean necesarias hasta que el estudiante logre captar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2018-01-24T00:00:00+00:00'::TIMESTAMPTZ, '19be4479144014912ce62c818f0550ead786c97da1967209c76dd5a4356f7ef9'::TEXT, ARRAY[4769, 1182, 637, 1999, 636, 1726, 640]::BIGINT[]),
    (421::BIGINT, 'Deberían traer alguien mejr'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-12T00:00:00+00:00'::TIMESTAMPTZ, '43965cbd567a05c6b62f90a6a7767dd36ac41c246ed700baee4d50014be3abb9'::TEXT, ARRAY[922]::BIGINT[]),
    (421::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-25T00:00:00+00:00'::TIMESTAMPTZ, '330551d332e575b72dbe37dd290a7aae82b28382cc387ce998209322a3f39495'::TEXT, ARRAY[4769, 1182, 637, 1999, 636, 1726, 640]::BIGINT[]),
    (421::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '94ef9abbddb4c10f55ff0a88cd16157764f5a77eed98b41ef2854c7b9061b6f9'::TEXT, ARRAY[922]::BIGINT[]),
    (421::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '7d32365a2cff84edcfe2ca9d075c36694069192eed5fdfef1a5d50b11a7fd3d9'::TEXT, ARRAY[922]::BIGINT[])
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
