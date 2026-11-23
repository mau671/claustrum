-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=233
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:26:49.517919+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (233::BIGINT, 'Literalmente el mae pasa exponiendo su maldito libro, tiene un fetiche con ese libro, el mae califica feo y aunque le reclames el mae no hace nada, yo podía pasar si aunque sea me ayudaba a revisar el examen que se me cortó el pdf, pero el mae no hizo nada, una basura, es prepotente y no ayuda.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2026-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'f7f1de5f362b9f15ba05a963ea2e3e8bca0bab2ba2a2691362db5c8a8b8395d8'::TEXT, ARRAY[610]::BIGINT[]),
    (233::BIGINT, 'El curso es horrible de base, el profe no ayuda mucho. Sus clases son bastante aburridas, los ejemplos que pone solo confunden más y para sacar consulta con él parece el EBAIS. No lo recomiendo para nada'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2026-11-18T00:00:00+00:00'::TIMESTAMPTZ, '33f4d06cf71fed430cccec2bac96bfeaa1ff10841ae72a01cf3019d68ede3641'::TEXT, ARRAY[933]::BIGINT[]),
    (233::BIGINT, 'Super desordenado, es super flojo y nunca atiende ni revisa las cosas a tiempo, el es amigable pero no lo recomiendo.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2026-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'd86bfbb125754209978585264e9de1d4aef3095e2bbf6d94d9e71489585d449a'::TEXT, ARRAY[610]::BIGINT[])
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
