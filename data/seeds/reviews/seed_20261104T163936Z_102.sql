-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=102
-- TEC-DATA-META years=2015,2016,2017,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.315881+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (102::BIGINT, 'Tal vez es un poco duro, pero va directo al grano, no utiliza presentaciones, pero sus clases no son aburridas. LLeve todo al día y el curso se pasa solo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2025-08-11T00:00:00+00:00'::TIMESTAMPTZ, 'ebc63eac9598a407758d72dbe98e140e910f9fb888e7685e26618a744aac4caa'::TEXT, ARRAY[2784]::BIGINT[]),
    (102::BIGINT, 'Es una muy buen profe, explica de manera que uno entienda sin mucho relleno, conforme vaya avanzando el curso y si muestran interés, él se vuelve permisivo con las fechas de entrega y la relación profesor-estudiante se hace muy ameno. Lleve el curso con él.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-23T00:00:00+00:00'::TIMESTAMPTZ, '9afec3ca1598c66f50ac5dee73bdee41b7889bea6c6ce781689497b8f9859f4a'::TEXT, ARRAY[938]::BIGINT[]),
    (102::BIGINT, 'Muy buen profe. Explica bastante bien la materia y hace el curso bien interesante. En mi caso la clase era justo después de almuerzo entonces nos tenia bastante paciencia. Hay bastantes trabajos escritos pero entre compañeros se pueden ayudar'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2023-07-06T00:00:00+00:00'::TIMESTAMPTZ, '2bdf4c5f9ee38b05371c267c73e12a08bdb03c907186520600e09a6819455cf2'::TEXT, ARRAY[938]::BIGINT[]),
    (102::BIGINT, 'El mae es un crack, sabe demasiado, si califica durillo pero se aprende un montón'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2017-09-21T00:00:00+00:00'::TIMESTAMPTZ, 'fd5dfce3d445a5c71154da33a478feae9ec3361c196bd32885950f8cdadc6b7f'::TEXT, ARRAY[938]::BIGINT[]),
    (102::BIGINT, 'Es un excelente profesor, Se aprende mucho y es muy bueno explicando, en mi caso aprendí mucho más con el que en la teoría, las evaluaciones no son fáciles ya que le gustan las explicaciones muy detalladas pero en general lo recomiendo 100%'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-23T00:00:00+00:00'::TIMESTAMPTZ, '51d597fa23f7c88478ae6203671ad5ad434cc52902b0ef8c42a4dfed4946dbe3'::TEXT, ARRAY[938]::BIGINT[]),
    (102::BIGINT, 'Él tiene mucha experiencia como profe y como ingeniero. Se aprende mucho, le gusta que uno vaya a consulta'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-20T00:00:00+00:00'::TIMESTAMPTZ, '4cba18128992b39e498cd3d5b509081f99ac1f857f0caf34602b4861079b489f'::TEXT, ARRAY[2820]::BIGINT[]),
    (102::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-17T00:00:00+00:00'::TIMESTAMPTZ, '1bf86764bbd56f37eea808e234e3b7366c97f07f61e486e54af1d25c94c557cd'::TEXT, ARRAY[2820]::BIGINT[]),
    (102::BIGINT, 'Un profesor pura vida, quices normales, califica no muy duro sin embargo esto es solo por ser el curso de introducción.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ, '251de69c87f37cee8b23d0cbacd3e51132ad7b8716daaeb25294c0e3cc40ac8e'::TEXT, ARRAY[2733]::BIGINT[]),
    (102::BIGINT, 'Facil, explica bien, es estricto con lo que se hace y se queda el que hace lo que quiere sin seguir instrucciones, facil a comparacion de otros profes y se aprende.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-21T00:00:00+00:00'::TIMESTAMPTZ, '612083912ea599acc61b4ee751c0e142ef03829babfb7deb84d55c9aed2962f8'::TEXT, ARRAY[610]::BIGINT[]),
    (102::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, '3e3f8955e81bad6fc2e8433a21206c1a259b798f6d78db8f642d8ae5c47f5c9c'::TEXT, ARRAY[610]::BIGINT[])
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
