-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=836
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.254703+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (836::BIGINT, 'No es dificil pasar, pongale al primer examen y haga los primeros informes escritos bien hechos, lea por lo menos las primeras semanas todo lo que pueda del curso y lo demás practicamente es regalado. No es estricta, es flexible y las clases pueden ser interesantes (depende mucho de si usted)'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Da crédito extra', 'Deja trabajos largos']::TEXT[], '2026-08-03T00:00:00+00:00'::TIMESTAMPTZ, '415148ab0c5970d7af64b33a68e14def8027bfcf77a3e0378fbd5311722b631c'::TEXT, ARRAY[559]::BIGINT[]),
    (836::BIGINT, 'Con está profesora la verdad es que pasar es regalado, no pasa lista, a muchas clases llega tarde o las cancela y las evaluaciones las califica muy ligera, la verdad lo volvería a llevar con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '63b51bc2392352028bbd1523b856f8fb08c4f9639505fe8017996c36dc188b49'::TEXT, ARRAY[559]::BIGINT[])
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
