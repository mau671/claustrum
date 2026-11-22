-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=261
-- TEC-DATA-META years=2021,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.125483+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (261::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '3887e31e22fe1075027876453499bdddaa4979df4e3ceeb4377c802aa01650a3'::TEXT, ARRAY[1249]::BIGINT[]),
    (261::BIGINT, 'le falta mucho para ser profe'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-09-03T00:00:00+00:00'::TIMESTAMPTZ, '678b1b8d857c14a4af088237903b39db2d08878bd185acff0ae11331fcfe8040'::TEXT, ARRAY[1282]::BIGINT[]),
    (261::BIGINT, 'Calidad de persona y profesor. Las clases bien planeadas, se aprende demasiado y se preocupa por que los estudiantes aprendan. Lo recomiendo 10/10'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, '87d39e3a6901397cbbe512516f2d0ab103be3877ab4fa6f2d5ff84d883ab83df'::TEXT, ARRAY[1286, 1282]::BIGINT[])
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
