-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=869
-- TEC-DATA-META years=2020,2021,2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.727902+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (869::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-11-25T00:00:00+00:00'::TIMESTAMPTZ, '35c771ba0f511bdacf89ac9add81b8032c92176124947bdf89d311e536313fd4'::TEXT, ARRAY[4755]::BIGINT[]),
    (869::BIGINT, 'Es una excelente docente, hace las clases muy interesantes, se nota su interés por el curso y de que los estudiantes aprendan. Hay un ambiente de respeto y comunicación.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-04-04T00:00:00+00:00'::TIMESTAMPTZ, '88a8e6d266e6ddeab9a8ccd95a6b4be20a27cc1fc8077e388e452d8c5c62a5b4'::TEXT, ARRAY[4788, 4770, 4755, 4756]::BIGINT[]),
    (869::BIGINT, 'virtual era muy tedioso por tantas actividades grupales en clase pero fácil, presencial fue más llevadero y bonito, se aprende mucho, ella sabe mucho y califica adecuadamente, los trabajos son sencillos pero hay que hacerlos con dedicacion y no el dia antes'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2022-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'f286f80f6a822261c583248300034783833d7c594535f20c02f736a2c661e492'::TEXT, ARRAY[4756]::BIGINT[]),
    (869::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2021-01-15T00:00:00+00:00'::TIMESTAMPTZ, '771cd0b4ba6bce026c0d3259f09b0f070aa952fc0b2463475e6a25422c196124'::TEXT, ARRAY[4756]::BIGINT[]),
    (869::BIGINT, 'De las mejores profesoras del Tecnológico, se nota la pasión por el curso y por enseñar y ayudar a los estudiantes. Sus exámenes son bastante fáciles siempre que se preste atención a las clases. Se esfuerza por hacer cada lección entretenida, llevaría todos mis cursos de historia con ella sin duda.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2020-07-28T00:00:00+00:00'::TIMESTAMPTZ, '0135d530e295fc448a02a4148cf20d3b232175a12c544c5bd0cf5b54e9b026e8'::TEXT, ARRAY[4756, 4755, 4770, 4781, 4788]::BIGINT[])
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
