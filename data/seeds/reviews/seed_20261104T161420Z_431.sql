-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=431
-- TEC-DATA-META years=2019,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.088030+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (431::BIGINT, 'No sabe explicar'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '94bea309e2b853c03b34d7ef49e814325b47d38e85302b9a7a8e2012e6d3081a'::TEXT, ARRAY[1763]::BIGINT[]),
    (431::BIGINT, 'La clase es sencilla y el profe la hace amena, no son muy largas y los trabajos son relativamente fáciles si se puso atencion'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'f27dbc13d7c32ea8625c3fa584565d508f5d2d49c4ef3c4fdf7822c768e60fb5'::TEXT, ARRAY[1793]::BIGINT[]),
    (431::BIGINT, 'Las clases al inicio eran largas, luego eran de un par de horas solamente, el curso en sí es sencillo solamente es de poner atención y leer la guía. Las evaluaciones son sencillas.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Pocos exámenes']::TEXT[], '2021-12-22T00:00:00+00:00'::TIMESTAMPTZ, '09f8199e78f3210ac31623fb55aad99a7b74b043e258e53c704c101261923202'::TEXT, ARRAY[1751, 1312]::BIGINT[]),
    (431::BIGINT, 'Tiene buenas intenciones pero la enseñanza no se le da, lo que hace es seguir algún ejemplo que ya haya hecho. Los quices empezaron siendo fáciles y después dejo unos que eran confusos. No hay exámenes entonces es una parte "buena", el articulo es bastante sencillo. Personalmente, no aprendí nada.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, '85d3a90eda4ac4cc292d9b329c1a09981003851c21301fee1a13ba16fb21030b'::TEXT, ARRAY[1722]::BIGINT[]),
    (431::BIGINT, 'Buen profe pero hasta ahí, no se llegan a tener tantas clases sincrónicas y hace pocas evaluaciones. Califica suave pero en cualquier momento lo sorprende a uno con algún quiz o así.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '635911bf0357515273c30cf3179d3c1ab9492f3b20569034a55976d35ddc1afc'::TEXT, ARRAY[1722]::BIGINT[]),
    (431::BIGINT, 'Pésimo profe, 3 clases sincrónicas en un semestre de 16 semanas. Evaluaciones son confusas, hace evaluación sorpresa de temas que recién explicó en una clase. Las pocas clases que da son desorganizadas, en un tono aburrido, confuso, 0/10. Si tienen buenas bases en costos I llévenlo, califica suave.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2021-06-18T00:00:00+00:00'::TIMESTAMPTZ, '76ec4b543d532238d39dd19e3f7093cd37b26eccdedd63e10cac751db2d4f99d'::TEXT, ARRAY[1722]::BIGINT[]),
    (431::BIGINT, 'Es muy mal profesor, no ayuda, deja trabajos que nada que ver con lo que hemos visto, no da clases, dice que olvidó los materiales en la casa.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2021-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'a9cb38a58b0031f1573e86fb3cb663cb9973b78ee1a4118ee38a5dd94cfeabb4'::TEXT, ARRAY[1722]::BIGINT[]),
    (431::BIGINT, 'Buena persona, profesor para abajo de la media. Muy vago, y no se le logra entender nada de la materia quizás porque ni él mismo la entiende. Suele tener unos ejercicios ya resueltos para hacer en clase, si se le pierden no es nada. No puede explicar un simple ejemplo. Evalúa normal.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2019-01-24T00:00:00+00:00'::TIMESTAMPTZ, '5d37969f199b751ef6923957282afa0649ecaeae9eb12aa7ab1b2c321ddbac4f'::TEXT, ARRAY[1728]::BIGINT[])
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
