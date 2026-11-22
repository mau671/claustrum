-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=584
-- TEC-DATA-META years=2017,2018,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.812802+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (584::BIGINT, 'Buen profesor, es bastante flexible con los estudiantes. Si entregas todas las asignaciones que él te deja, probablemente te vaya muy bien el el curso.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-10T00:00:00+00:00'::TIMESTAMPTZ, 'f62b8182a18a1d36c391b4a9872dbb57498a85d26132c5305f7089a54f786e76'::TEXT, ARRAY[1162]::BIGINT[]),
    (584::BIGINT, 'Excelente profesor. Califica suave, da mucho tiempo para los proyectos, da puntos extra y sobre todo se aprende un montón. No dude en matricular con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-08T00:00:00+00:00'::TIMESTAMPTZ, '8967cbd9d533b45af1b951339b41265c16e93890a9e34ff9bddca5646dfbd724'::TEXT, ARRAY[1035]::BIGINT[]),
    (584::BIGINT, 'El curso fue bastante llevadero y el profe explicó los temas muy bien, para estar repitiendo el curso puedo decir que comprendí mejor de la manera en la que lo explica y los trabajos cada semana no son matados y ayudan a repasar la materia, un 10 el curso con este profe.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'bb5efd78350d151928af4038ae97027187dffd67b76219012df057b5c93bb353'::TEXT, ARRAY[1035]::BIGINT[]),
    (584::BIGINT, 'Es de esos profes que dan paz, no te estresan con su mala actitud. Es extremadamente buena gente, siempre estuvo de buen humor y dispuesto a ayudar. Al final del curso que la materia se complica un poco cuesta entenderle, pero es un curso demasiado pasable. Da una semana para hacer los examenes amen'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2022-11-30T00:00:00+00:00'::TIMESTAMPTZ, '3f707fc7b8945534c996129ef988b07addc4d7d504d7fc440b1502751049dd71'::TEXT, ARRAY[1035]::BIGINT[]),
    (584::BIGINT, 'El profe es buena gente. Si tiene alguna duda, lo ayuda. Sus proyectos son entretenidos y la materia la hace entendible.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'c0c5c501d4ab8bd92545f26606b3123fa2a44fb36b031825a48068c79b10bbe5'::TEXT, ARRAY[3792]::BIGINT[]),
    (584::BIGINT, 'En Bases de Datos I, el profesor conoce bastante sobre la materia, se le logra entender, casi siempre deja tareas. Como persona, es agradable, trata de ayudar al estudiante y explica las veces necesarias.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2021-02-05T00:00:00+00:00'::TIMESTAMPTZ, 'e489e24bc490be63595d82d46b7dbbdbc928f9aa20021cefd71e8f31ad794669'::TEXT, ARRAY[1037]::BIGINT[]),
    (584::BIGINT, 'Es muy tuanis como persona la mayor parte del tiempo. Diría que su principal problema es que es bastante vago, tanto para planear las clases (parece evidente que nunca lo hace) como para entregar notas (la mayoría casi que en entrega de actas). Pone 100 por cualquier trabajucho y no sabe explicar.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2018-02-05T00:00:00+00:00'::TIMESTAMPTZ, '72eba5b6822b94107e38f786366f31e93dc043d00bd44b1c2f8ad3170279ac90'::TEXT, ARRAY[2570]::BIGINT[]),
    (584::BIGINT, 'Entregas con proyecto que ni compila y te pone 70 :), Le echa el cuento a las estudiantes.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-26T00:00:00+00:00'::TIMESTAMPTZ, '789e92886940c0e4b1523adbab57e95f52dbf2a92632b689d1f88281569ce326'::TEXT, ARRAY[3792]::BIGINT[]),
    (584::BIGINT, 'Se pasa fácil, pero no se aprende nada'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-12T00:00:00+00:00'::TIMESTAMPTZ, '6190bb207ed355b24ca425f1400bc5fd88c581e4745015d07f216a4efdcdd040'::TEXT, ARRAY[1253]::BIGINT[]),
    (584::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '8d133fab70c92edb099ae1ed47691e408f0dabe345acd2ca6749df18b2159958'::TEXT, ARRAY[1249]::BIGINT[])
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
