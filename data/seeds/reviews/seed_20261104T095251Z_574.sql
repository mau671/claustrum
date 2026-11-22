-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=574
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.441516+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (574::BIGINT, 'Es un excelente profesor y una gran persona, hace todo lo posible para que este proceso final de la carrera sea lo más llevadero que se pueda, sus clases son bastante largas y en cuanto a trabajos son realizables, sabe que uno en este punto está super saturado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'd14b5f54de9601337ed5310f7662234dad4e6ba5485c65d7537967abb5c5a0ec'::TEXT, ARRAY[2998, 2997]::BIGINT[]),
    (574::BIGINT, 'Un excelente profesor, de mis favoritos de Computadores es una lástima que lo veas hasta el final. Hace muy interesante sus clases. Alegra hablar con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-20T00:00:00+00:00'::TIMESTAMPTZ, 'd9dca337a2b58b86f88a815e030e9a32c1061f6d2aea2590796540d100fe6b28'::TEXT, ARRAY[2997]::BIGINT[]),
    (574::BIGINT, 'Un grande el Jennier, de los mejores profesores del Área. 10/10 calificación perfecta'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-01-19T00:00:00+00:00'::TIMESTAMPTZ, 'fd173fb5cbd1a1ae2cfcb00dc816942295834948e489466bd272512231ba7f3e'::TEXT, ARRAY[1329]::BIGINT[]),
    (574::BIGINT, 'Excelente como profesor y como persona'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2022-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'd79670be534255e887f5feee31be972c5f2038fc1518a67ad9a10d756b49a94a'::TEXT, ARRAY[2997, 2998, 3002]::BIGINT[]),
    (574::BIGINT, 'Gran profesor y con gran anuencia a responder preguntas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2021-07-15T00:00:00+00:00'::TIMESTAMPTZ, '96aa99b67e6fd9411cd05db882939b5f1a110418ba9ff275f523fc98503cf747'::TEXT, ARRAY[2998]::BIGINT[]),
    (574::BIGINT, 'Un muy buen profe. La verdad el se aprovechan las clases con él y ayuda mucho para guiarlo a uno con el proceso de los cursos finales de la carrera (computadores). Recomendado.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2021-02-06T00:00:00+00:00'::TIMESTAMPTZ, '3adcd79f0f5b0ac621df61d6eb04ab6464687edb542da9de3e0db461e55f07de'::TEXT, ARRAY[2998]::BIGINT[])
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
