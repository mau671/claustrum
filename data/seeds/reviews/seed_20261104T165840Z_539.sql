-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=539
-- TEC-DATA-META years=2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.805345+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (539::BIGINT, 'La mejor'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2025-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'bc80bb50e292f2738ed3bf539eea81aab4fb7dd37d64215c812af3b6558a0ea6'::TEXT, ARRAY[567]::BIGINT[]),
    (539::BIGINT, 'La amo profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'd87d7c8887c547170f65209992fe99aacad58703b37f80d321c3149cda32f1e9'::TEXT, ARRAY[567]::BIGINT[]),
    (539::BIGINT, 'Muy amable, explica muy bien y responde dudas de una manera respetuosa y atenta, realmente hace que el ambiente de clase sea agradable, es flexible con algunas cosas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'd41d13b2e6463e7940fd6dd903efcd0031f73d82ba918cc8f56971cebbef3429'::TEXT, ARRAY[567]::BIGINT[]),
    (539::BIGINT, 'La profe es demasiado buena persona rajado, es super amable y siempre te va a ayudar. Los quices son faciles y no califica muy duro. Lo único tal vez es que comparado con otros profes no explica los informes. Lleve con ella de fijo'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-17T00:00:00+00:00'::TIMESTAMPTZ, '244d487234d03fc878240a2015d499e83dab89fe98e2574343909ed470cb36c1'::TEXT, ARRAY[567]::BIGINT[]),
    (539::BIGINT, 'La mejor profesora de laboratorio, siempre que alguien tiene preguntas ella ayuda con mucho amabilidad. Antes de cada experimento explica lo que va a pasar y como hacer los cálculos correspondientes. Da material extra si algo no queda claro, busca ayudar a los estudiantes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-07T00:00:00+00:00'::TIMESTAMPTZ, 'fcac8b2a8b8bceb05e90bdd542885e22cc94ca56da4783ba31604dfa05991689'::TEXT, ARRAY[567]::BIGINT[])
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
