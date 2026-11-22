-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=265
-- TEC-DATA-META years=2020,2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.024037+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (265::BIGINT, 'Es una profe súper buena; brinda todo el material visto durante la clase, es muy atenta a responder dudas y deja trabajos que no son pesados. Súper recomendada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-02-09T00:00:00+00:00'::TIMESTAMPTZ, '7b6d77c22634a3014a98127d94b2d0dfc3d0a276fe0e28fc513130facfa35e69'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'Un amor de profe, el curso fue solo 1examen, 1 proyecto, 1 kahoot y 1 trabajito peque por semana, baja un poquito de puntos aveces pero se pasa muy bien'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Clases excelentes']::TEXT[], '2026-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'a362c7db99c7ba6f1703951c9a9a4b0f6c98b967b716d7d8a0fc516c5602f108'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'La clase es aburrida, mucha presentación de PowerPoint, las tareas no son difíciles pero los proyecto son larguillos. Con solo hacer las tareas y hacer bien uno de los proyectos se puede pasar.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'ee3756cdf9f677aeaa1d6517e715c84e28d218ffe1d974fcc705c30e7ab1a3a2'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'Explica muy bien y es super pura vida, el único problema es que usa muchas presentaciones y a veces la clase se vuelve aburrida, no hay mucha practica durante el curso.Deja muy pocas tareas y los proyectos no son difíciles si usted puso atención en las clases. Nada más hagan bien las tareas y pasan.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-09T00:00:00+00:00'::TIMESTAMPTZ, '51a4a236efb733582f92991fab179ddbf14ba4f8b7030dec5782b3f61f988ec5'::TEXT, ARRAY[1029]::BIGINT[]),
    (265::BIGINT, 'La profesora es excelente, explica muy claro y es muy ordenada, para semana 16 usted ya salió del curso y sabe todo. Muuuy buena profe. Mega recomendada.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '2b9693dd8adc84d89e3b8d19a94c465e72b35e7e59806dbc6c500908ae490a47'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'Muy buena profesora, la programación en los proyectos grupales puede llegar a ser difícil para algunos pero lo que más vale es el análisis. Siempre está disponible para atender dudas. Las clases son bastante útiles y muy claras.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-22T00:00:00+00:00'::TIMESTAMPTZ, '2591a8d84929e73cc0d0265bace1848f9ab43477b724886ad6f9fdf413182e4f'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'Es muy excelente profesional, siempre quiere ayudar a los estudiantes y está dispuesta a resolver dudas. Los proyectos pueden ser un poco largos pero da el tiempo suficiente para hacerlos. Las clases son claras.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2022-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'e74ec6ed8e8eb4f42fbd1ef320d32299cd10a459180e83edc19a89b1a70b24f8'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'Buenísima profe, siempre quiere que los estudiantes entiendan, además súper atenta a resolver dudas. MATRICULE CON ELLA'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-17T00:00:00+00:00'::TIMESTAMPTZ, '42015b7560d47a6c070f8720d3f9a340be73ecd4ff53e889299df1842cfe3863'::TEXT, ARRAY[1035]::BIGINT[]),
    (265::BIGINT, 'La profesora brinda mucha ayuda, deja pocas tareas pero con esas se pasa el curso, se aprende bastante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'df1341ed98574f38ea94f32e72174cdc1b5ba6c2f57713cba9736c6dc93b6781'::TEXT, ARRAY[1029]::BIGINT[]),
    (265::BIGINT, 'Super buena profesora, si tiene una duda pregúntele siempre le va ayudar. Los proyectos pueden llegar a ser largos pero con que haga todas las tareas pasa el curso, nunca se le olvide entregar una tarea.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, '3c13cc3dfc95891d61dd76ec131d2a2839c4e2a4c1c4cd1309a5f2394b62f7ee'::TEXT, ARRAY[1029]::BIGINT[]),
    (265::BIGINT, 'Es por mucho la mejor profesora, sus clases son ordenadas, estructuradas. Está dispuesta aclarar dudas. Tiene pasión por la docencia y las ganas de enseñar. Sus proyectos son largos y pueden resultar difíciles pero vale la pena. Se aprende bastante con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'fed8c2114b861139e29fb9e711279e05198b9a2f440f0d417358832689c4767f'::TEXT, ARRAY[1029, 1035]::BIGINT[]),
    (265::BIGINT, 'Es por mucho la mejor profe con la que me he topado de momento, las clases son muy claras, explica con mucha claridad las evaluaciones asignadas, las tareas son bastante fáciles y no deja muchas. Al menos en mi caso el primer proyecto fue la verdad muy pesado, el segundo no tanto. Muy recomendada.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, '63b0634f97de682d2dcf2484535a5c0ff00e6a51eef257fa618863963025ed43'::TEXT, ARRAY[1029]::BIGINT[]),
    (265::BIGINT, 'Es buena profe, solamente realizar consultas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2021-06-16T00:00:00+00:00'::TIMESTAMPTZ, '708d05e9bebe4edac6fe7152315732e777247c43535e3483c06ae72f4a06edca'::TEXT, ARRAY[1030]::BIGINT[]),
    (265::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'ab73d7e5c435e2728cc8f04bf02b99ab8660045d022f869d20ab98604a5dbee7'::TEXT, ARRAY[1029]::BIGINT[]),
    (265::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-02-04T00:00:00+00:00'::TIMESTAMPTZ, '7b41054b232845526e70173397d7bb3f2e5a45a4afc18956a4caec20001b6199'::TEXT, ARRAY[1029]::BIGINT[])
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
