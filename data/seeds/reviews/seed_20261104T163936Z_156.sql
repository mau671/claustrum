-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=156
-- TEC-DATA-META years=2014,2015,2016,2017,2018,2020,2021,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.327595+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (156::BIGINT, 'A veces cuando usted le pregunta algo le responde con mala cara, siempre hay que exponer y aprenderse las varas en muy poco tiempo, no se aprende muy bien la vdd, si tienen chance de elegir a otro profe sería mejor.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2025-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'd565a5917f1dd9ad87dd94079cd5cece72bfc714081e46c5b1cf2133b7d3bb67'::TEXT, ARRAY[625, 545]::BIGINT[]),
    (156::BIGINT, 'La profesora califica muy duro, realmente duro y nunca senti que fuera comprensiva con estudiantes a los que les resulta dificil el idioma, sus trabajos son complejos y algunos hasta tontos como aprenderse un texto para exponer en 20 minutos, no aprendi nada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2024-11-06T00:00:00+00:00'::TIMESTAMPTZ, '48a56f19f34d37e6d7bf3ee6e48b72277f0cc8cd3b7d69bfbadcf985f139bcb4'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'La profesora es buena persona, explica maso menos, le gusta muchos los trabajos en equipo, pide que graben audios cada 2 semanas aproximadamente. Si les falta puntos NO ayuda, me quede por menos de 1 punto y no le dio la gana ayudarme.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Exámenes retadores']::TEXT[], '2024-06-25T00:00:00+00:00'::TIMESTAMPTZ, '5236c901269099463c7041e893d1c21d1d91984db0f81902bde749fbfa230013'::TEXT, ARRAY[545]::BIGINT[]),
    (156::BIGINT, 'La verdad como persona me parece muy buena, pero como profesora califica muy duro, si no considera tener un nivel de ingles muy bueno no la recomiendo. Además, te pide muchos trabajos grupales y grabaciones fuera y dentro de la clase, deja bastantes tareas y sus examenes son complicados.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2024-06-10T00:00:00+00:00'::TIMESTAMPTZ, '8eecbe62cebf7fa0214bdbe724d896634ae058d01a376628155ea3c56c849e5c'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'Me pareció buena profe, sus clases son muy normales y la participación es importante, con ella hay que cuidar la pronunciación, corrige mucho, si a usted se le dificulta el inglés ella es una buena profe para tomar este curso, es muy comprensiva en ese aspecto.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-11-30T00:00:00+00:00'::TIMESTAMPTZ, '2d87d46a93438751899162361e6ec4c52f469acffb5c266e8c1673883af22969'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'Es buena docente. Contesta a las consultas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'a3297d30f84730a8df28af1f2079f65c5f032b5f3a9e446f5210199a4f2cc1ac'::TEXT, ARRAY[545]::BIGINT[]),
    (156::BIGINT, 'La profe explica bien, no me puedo quejar, sin embargo deja trabajos que conllevan mucho tiempo, casi siempre grabar un audio o video de algún texto escrito por usted.. Si no le molesta ese aspecto puede llevarlo con ella.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2021-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'd9d1c3959bbd94e227cdf91fda92a2054a2a355890d506c4180af0f869c67e5c'::TEXT, ARRAY[545]::BIGINT[]),
    (156::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2021-03-04T00:00:00+00:00'::TIMESTAMPTZ, 'f0a2c9ab9dcbf72c24eae5befe9b0c25a3e8906b3f060c4b2c42196e3b4802f9'::TEXT, ARRAY[545]::BIGINT[]),
    (156::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases largas', 'Brinda apoyo']::TEXT[], '2020-07-28T00:00:00+00:00'::TIMESTAMPTZ, '5f2164f0428faae4db6924c2b1b3bf026d1bf9a4198b0695f2ae0ffbe1568529'::TEXT, ARRAY[625, 545]::BIGINT[]),
    (156::BIGINT, 'Es una persona amable, califica respecto al nivel del estudiante en inglés. Las clases son dinámicas pero monótonas, cuando hay que exponer se debe hacer una actuación y es muy divertido. Los exámenes son sencillos y fáciles si no le cuesta el inglés. Profesora muy buena para inglés 1 :)'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2018-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'bf6de83d928a6b369afcfb9b6051ebfc2155a3e6b80cb10866f4f8a992fd4828'::TEXT, ARRAY[547]::BIGINT[]),
    (156::BIGINT, 'Buena profe, los examenes son fáciles, pero la clase no me gustó mucho en todas las clases se ve materia y hay que hacer conversaciones en grupo y exponerlas y es muy tedioso.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a8d0b70852630fc220bcb98e0781411df7c5deed1193c101260dd2aa3ae8adc3'::TEXT, ARRAY[547]::BIGINT[]),
    (156::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2018-06-04T00:00:00+00:00'::TIMESTAMPTZ, 'e0dd3ecb73b85fb783e172cfa06a2a009343d2089913018ddc500eec51c54c3b'::TEXT, ARRAY[539]::BIGINT[]),
    (156::BIGINT, 'No recomendado para aquellos que les cuesta el inglés calificación a matar.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2017-01-15T00:00:00+00:00'::TIMESTAMPTZ, '8e61c43d5bf1cb5855db43b56806cb6dbdc5398bec7d3943bf3634b37713f705'::TEXT, ARRAY[547]::BIGINT[]),
    (156::BIGINT, 'No, no, no.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, '7dd01abea46c17ff331413820a31848dc7a1131d3e4d2a2631db64dd447dade3'::TEXT, ARRAY[545]::BIGINT[]),
    (156::BIGINT, 'Profesora normal, sin embargo con algunos estudiantes se le mete el agua, y importante, su pronunciación podría mejorar porque es malilla. Los exámenes son fáciles.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2016-01-31T00:00:00+00:00'::TIMESTAMPTZ, '1c488d65fe1f333c7a27dab3a2ea1fe1148d1de6115e36e3166b858aa8e544d5'::TEXT, ARRAY[627]::BIGINT[]),
    (156::BIGINT, 'Si uno sabe inglés es muy fácil pasar, es durilla y deja un montón de pequeñas tareas.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'a91503aa5fccdd7698afd50447d13ab268f995ead5334399dee5df809a839e27'::TEXT, ARRAY[547]::BIGINT[]),
    (156::BIGINT, 'Muy mala profesora, deja demasiadas tareas y con los lab reports se pierde demasiado tiempo! Hace que la clase se pase rápido y no es aburrida, pero no se aprende nada.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-28T00:00:00+00:00'::TIMESTAMPTZ, '412a7f3fda1cdaee9c39781fbfce98d4136af9896e28fb6e81818c36bf60ab70'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'Mala profesora'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-29T00:00:00+00:00'::TIMESTAMPTZ, '0411262ef0fee0199a686eea0db228e05efbc4dce313433a36a2c9e0e5304d37'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'Deja muchas tareas y asignaciones y quizá si a una persona le cuesta el inglés si le va a costar con ella, pero a la hora de calificar es muy considerada, es decir, califica dependiendo de la persona, a quien sabe más, le exige más. Pero si deja mucho que hacer :/'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, '6cf46eaa772de3681c0de1aa4d8a4894b039d6d7fb69e1ed125208b95ebce200'::TEXT, ARRAY[625]::BIGINT[]),
    (156::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('35','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-03T00:00:00+00:00'::TIMESTAMPTZ, '45201a2f44ec64dcc7bf1488c867ddbbd506ee96d5a360781aa76d79c271de2e'::TEXT, ARRAY[625]::BIGINT[])
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
