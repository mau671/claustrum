-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=556
-- TEC-DATA-META years=2019,2020,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.049783+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (556::BIGINT, 'No se por que tiene calificación tan baja, en realidad es un profesor excelente y da oportunidades de mejorar los quices además de ser super comprensivo, lo único que tiene es que sus clases suelen ser mucho mas fáciles que la materia que se evalúa en los exámenes'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-15T00:00:00+00:00'::TIMESTAMPTZ, '55d362e49e89825d67f731f2d93f03575db4cafd743327f7187600b91fa268b5'::TEXT, ARRAY[614, 573]::BIGINT[]),
    (556::BIGINT, 'Los exámenes de cátedra se hacen muy complicados a pesar de que se hace mucha práctica, las preguntas de las autoevaluaciones y quizes se contradicen a demás de que son demasiadas, el profesor ayuda muchísimo, sin embargo, en caso de que no tengan buenas bases les va a costar comprender.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2023-06-28T00:00:00+00:00'::TIMESTAMPTZ, '7b7c4857d0ecf7d2707715c71d31f7a7703bcaee50d7a718f237ac81f399eff8'::TEXT, ARRAY[568]::BIGINT[]),
    (556::BIGINT, 'Buen profe pero es complicado entenderle a veces, las clases son un poco confusas e implica mucho estudiar solo. Recomiendo si tiene buenas bases de química'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2023-05-26T00:00:00+00:00'::TIMESTAMPTZ, '3e327aa2ea26f46acf458cf5d348bf7a236bb011c64c301adc32627542b2d1df'::TEXT, ARRAY[568]::BIGINT[]),
    (556::BIGINT, 'Si la persona tiene buenas bases de química, puede jugarsela, sin embargo, el curso es semivirtual, y no explica muy bien, puede mejorar. Por mi experiencia, tuve que estudiar todo por mi cuenta y buscar ayuda a terceros. Sin embargo, se preocupa por los estudiantes, pero no vale la pena.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-01T00:00:00+00:00'::TIMESTAMPTZ, '32bf802a5ac7ac52697277e4c3a4c7e1c0151febbbfd3ad0b455f4ea1ce03d52'::TEXT, ARRAY[568]::BIGINT[]),
    (556::BIGINT, 'Primer año, primer curso de quimica y semivirtual pero excelente profesor, explica mucho y le apasiona mucho la materia, es matado pero bueno es un buen comienzo de la vida TEC'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2020-05-11T00:00:00+00:00'::TIMESTAMPTZ, 'ed9db5088b733c46b77f8a874c65a192938dbfd761a9be9d1c57300d2837d69f'::TEXT, ARRAY[568]::BIGINT[]),
    (556::BIGINT, 'Muy tuanis y explica muy bien!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-07-08T00:00:00+00:00'::TIMESTAMPTZ, '1a7c5f3595500d972264bea902d833ba35dadbd07c1744ae9c81395b9e471f1c'::TEXT, ARRAY[613, 567]::BIGINT[])
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
