-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=811
-- TEC-DATA-META years=2018,2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.722537+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (811::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-18T00:00:00+00:00'::TIMESTAMPTZ, '9a4df6aa36c92e99817f086255ec8a6b0573010afa0fce485c637112ae65deef'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Como persona es muy agradable, pero como profesora no la recomiendo.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, 'b278c843db77282f3a5882c3800005a315c541efa67421fc474a0a71d3507e1d'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Es ruda para evaluar en algunos temas, pero en general es muy clara, brinda mucho apoyo, es notable que tiene vocación para la enseñanza y es muy cercana con los estudiantes. Aprovechen las horas de consulta, la recomiendo.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Brinda apoyo']::TEXT[], '2023-04-15T00:00:00+00:00'::TIMESTAMPTZ, 'f039cdc327bc6a0cadf673fdb1a9fc9d9eb641e2d0796ac613fe84bb1fbe7829'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'La profe es buena, aveces las clases son algo pesadas y los recesos un poco cortos, pero se la pasa preguntando si uno entiende o no, entonces se preocupa mucho si uno va comprendiendo la materia, deja trabajos un poco largos, pero por lo general son en grupos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2022-01-10T00:00:00+00:00'::TIMESTAMPTZ, '618be348c6455ba84ac2f56b8824481a7a719656e8e8142caf62a4f4cf429d51'::TEXT, ARRAY[605]::BIGINT[]),
    (811::BIGINT, 'Es una excelente profesora y comprensiva. Explica muy bien y siempre busca que los estudiantes participen. Hace quices durillos pero si uno hace las prácticas que manda, todo bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'f4f3b0bc51e9349bf9b5ec47fa64af491be23ff6b70137fb3a77ae5f5d8ca58e'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Se preocupa por que el estudiante entienda. Sin duda tiene la vocación para ser profesora'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-19T00:00:00+00:00'::TIMESTAMPTZ, '718f9d44663a0b4f89ddf95e25aa1f962705f5127db70f0f171ead62fc7a5ced'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Es mucho mejor dando Cálculo que Discreta, explica de forma ordenada, se entiende bastante bien etc. Deja tareas muy largas pero de forma grupal que son de mucha utilidad para el examen. En discreta es un poco deficiente pero en cálculo es muy buena. Es muy amable y se preocupa por el aprendizaje.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'b84b2b7f645914d43fc1af010dcc98aca0d67082715c34267e4a5914d233c55b'::TEXT, ARRAY[605]::BIGINT[]),
    (811::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '83cb44147cf5bd0c1f7c903d20cec154d6897b36814b6ca2ef1c19ef144c245a'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'El curso fue compartido, ella explica regular y da ayuda cuando la solicitas, es bastante justa para calificar, los quices no son muy fáciles pero tampoco son muy difíciles. Deja Tareas con ejercicios de muy buen nivel para los exámenes.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-30T00:00:00+00:00'::TIMESTAMPTZ, '00c156863e46eb20cef76c51316bbd2859a8b495eab40201263144e3c6e8987a'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Explica super bien, 100% recomendada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-10-05T00:00:00+00:00'::TIMESTAMPTZ, '980c27590162b530503853c778641ed2a560f25bab934be25d6cab324c235c01'::TEXT, ARRAY[923]::BIGINT[]),
    (811::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2018-03-13T00:00:00+00:00'::TIMESTAMPTZ, 'ab9c7e80645df3dc6e2164158f34a0b4a8068abc25e14f3e42fc5e613118c564'::TEXT, ARRAY[563]::BIGINT[]),
    (811::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Deja trabajos largos']::TEXT[], '2018-01-10T00:00:00+00:00'::TIMESTAMPTZ, 'aa8ce80d964ede8d76d60a7075560e4bde213c987587283946501d4556efd56f'::TEXT, ARRAY[923]::BIGINT[])
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
