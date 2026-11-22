-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=151
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.788675+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (151::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2026-08-31T00:00:00+00:00'::TIMESTAMPTZ, '834e6eba66779bb9308270f5087ab845ac80cc7e6a25f2ccf6e4ccc1ba720ab6'::TEXT, ARRAY[554]::BIGINT[]),
    (151::BIGINT, 'Buena profe y clases divertidas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, '1d4838e9dae34177213abcc7fad8a6076613bcb7ed8adb736725e739cc389245'::TEXT, ARRAY[600]::BIGINT[]),
    (151::BIGINT, 'excelente, la ame, super organizada y no califica duro, aparte explica super bien y es super amable, matricule sin miedo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-17T00:00:00+00:00'::TIMESTAMPTZ, '55d1782f3981eff5977199bdad634f7cf38fe043cd5b625687279e39ca02fae3'::TEXT, ARRAY[554]::BIGINT[]),
    (151::BIGINT, 'Excelente profesora, explica muy bien, además de ser amable, se nota la vocación.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-11-19T00:00:00+00:00'::TIMESTAMPTZ, 'b8291bd7fd5597b549077c675cd5e53e11c1a564243857019d5d093d1bf72d4f'::TEXT, ARRAY[600]::BIGINT[]),
    (151::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '5387daa1b4065d24a7f5b7c54d9f99aaaae8ef029728cb4b39a08bb86410821a'::TEXT, ARRAY[556]::BIGINT[])
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
