-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=422
-- TEC-DATA-META years=2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.947203+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (422::BIGINT, 'Es muy claro y no pierde tiempo en cosas que no se necesitan en los parciales.'::TEXT, 2.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Exámenes retadores']::TEXT[], '2021-12-01T00:00:00+00:00'::TIMESTAMPTZ, '9e7d75a3701786c794b18bd163bbb9305fb6ac5854b20ca8b695cbabba5f5028'::TEXT, ARRAY[1296]::BIGINT[]),
    (422::BIGINT, 'Dedica la mayoría de la clase a hacer ejercicios, por tanto el lado conceptual se ve algo descuidado. Explica muy rápido la mayoría del tiempo así que luego hay que ver la grabación para realizar apuntes o para entender el tema en general. No incluye en el examen algo que no se haya hecho en clase.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, 'b0f973b13fdc1d3fd628474c79cc237ca9ebef96e77af5cc68c87902751de057'::TEXT, ARRAY[1272]::BIGINT[]),
    (422::BIGINT, 'Muy buen profe la verdad, las clases son claras y nunca mete cosas en el examen que no se hayan visto en clase.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-11T00:00:00+00:00'::TIMESTAMPTZ, 'c181f189dd050aac2ddad12f1bb0135646d309db5e9320bab7b85e713676517e'::TEXT, ARRAY[1272]::BIGINT[]),
    (422::BIGINT, 'Explica bien el curso. Se sabe que el curso es tedioso y difícil, pero hace mucha práctica y se preocupa por el aprendizaje del estudiante. Eso sí, lleve la materia al día porque el curso lo amerita por la dificultad.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '716ff2b8d6f2e307ba8cdfbc56c17ca16745e9491b9fc9c90271dcc22bee8615'::TEXT, ARRAY[1296]::BIGINT[])
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
