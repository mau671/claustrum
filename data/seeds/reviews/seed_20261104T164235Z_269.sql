-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=269
-- TEC-DATA-META years=2018,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.866942+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (269::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'df9877f41206190c74d9e92892330b8f9b190e6a9b4feda7c38bc311b6041f57'::TEXT, ARRAY[1022, 1020]::BIGINT[]),
    (269::BIGINT, 'El curso con este profe, me pareció bastante bueno. El profesor me agradó bastante e hizo del curso un curso llevadero. Lo recomiendo bastante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-06T00:00:00+00:00'::TIMESTAMPTZ, 'c88f895d75ee393698351748335b7459f0dcd925cd7491bc9ee4b83d3c5d571d'::TEXT, ARRAY[1156]::BIGINT[]),
    (269::BIGINT, 'En términos generales me pareció muy buen profesor, yo preguntaba mucho y el siempre me respondía mis dudas, eso si, sus proyectos pueden llegar a ser un toque larguillos, pero nada del otro mundo, personalmente si lo recomiendo, pero solo si usted no le da pena preguntar.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2022-11-16T00:00:00+00:00'::TIMESTAMPTZ, '5462f173a40eedebf3191e495b432e4d4e415904c3eb6f3329f6b4ad761c6f02'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (269::BIGINT, 'No lo recomiendo para este curso, si matricula con este profe no va a aprender.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-21T00:00:00+00:00'::TIMESTAMPTZ, '2202e828282cc787b5cbc618fa1a83cc774a36671298ba77b2e57e00c0e38029'::TEXT, ARRAY[1253]::BIGINT[])
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
