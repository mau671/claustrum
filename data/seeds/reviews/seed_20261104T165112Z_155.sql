-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=155
-- TEC-DATA-META years=2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.099451+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (155::BIGINT, 'Super buena, comica y cercana a los estudiantes, siempre y cuando le ponga atencion y realice las evaluaciones de fijo pasa. Aisha mi reina'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[], '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ, '9878fd0ef970c95ceda181ec82474a77bf2b94df4a2a577fc1aa4c0d5dc3cd32'::TEXT, ARRAY[539]::BIGINT[]),
    (155::BIGINT, 'Es muy comica y usualmente las clases con ella se sienten muy relajadas, se disfrutan y son excelentes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-27T00:00:00+00:00'::TIMESTAMPTZ, '6cb99b89b5fe098e0103d39cd8b1ab371e20fcdecf063e9754c1dc2480853629'::TEXT, ARRAY[539]::BIGINT[]),
    (155::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-12-06T00:00:00+00:00'::TIMESTAMPTZ, '495fffdfcb18b3b9e5b8a88f1e157172d3d71b86c14df429d27c3732d6e5f885'::TEXT, ARRAY[545]::BIGINT[]),
    (155::BIGINT, 'Muy buena profe para enseñar Inglés, se nota que su nivel de la lengua es avanzado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'c4ebb5887d285ea0ba19c95ca3cbc1803c7530348aefdd135bfae92f9d248fe9'::TEXT, ARRAY[539]::BIGINT[])
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
