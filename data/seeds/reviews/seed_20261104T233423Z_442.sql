-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=442
-- TEC-DATA-META years=2018,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:34:23.273367+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (442::BIGINT, 'En costos no hay mucho de donde escoger, así que siento que es la mejor profe para esta materia porque ella es la que organiza los proyectos de todos los demás grupos de costos, es un poco desorganizada pero es muy fácil pasar. Consiga buen grupo de trabajo'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-29T00:00:00+00:00'::TIMESTAMPTZ, 'dec18f5373b1b987e1cc03a9bec821b0923bceac8e278cac15962836511bd266'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Honestamente, es muy buena persona pero como profe tiene muchos aspectos por mejorar. Es bastante desorganizada tanto con las evaluaciones como en la materia. Algunos aspectos del proyecto los explicó casi que al final del curso y al revisar casi nunca da retroalimentación'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, '58f0b007679c45e0128e2c0659914c84b13e16264850a7e180e2be3c7a89f731'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'La compa es pura vida, revisa super chill y el curso es más una conexión con EPI que la materia en sí, hay que ser muy vago e inútil cómo para quedarse con ella. Los examenes son easy y sacar 8+ no es díficil con ella. La clases son aburridas eso sí y a veces poco claras.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-09T00:00:00+00:00'::TIMESTAMPTZ, '1019227670044155aa8f64f83f13920515e5d296c16293f6876157cdd13747cc'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Califica suave, es muy amable y ayuda siempre en consulta, trabajos algo pesados, busque un buen grupo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'a8a3a5f9e8c521b8f5c49f1ed6e928903eb5dcf84e77ca948db58a649151a617'::TEXT, ARRAY[1793]::BIGINT[]),
    (442::BIGINT, 'Es muy buena profe, sabe mucho. Sin embargo, las clases se hacen muy largas y se pierde a veces con el cronograma. Los quizes a veces son orales y la evaluación es un poco rara pero en general se aprende si se pone atencion y se estudia.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-11T00:00:00+00:00'::TIMESTAMPTZ, '382fb0c87d5e375f1a9880d86340016f485e3f6b73288bdc8817f57cd109ceb1'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Ella es buena profe, sabe muy bien los conceptos, pero cuando hace quices las preguntas son muy específicas. Con los trabajos, hay que preguntar bastante porque muchas cosas no quedan claras en los documentos. Pero si es buena persona, y es bastante accesible.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2023-12-18T00:00:00+00:00'::TIMESTAMPTZ, 'c20bbb554f5566307b8c37eec24247db53b31f2513f94f6ed70963ceb668448c'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'La profe es muy buena, explica bien, sin embargo, las evaluaciones no son sencillas, algunas son en grupos, otras individuales. Califica un poco extraño, no es muy parcial.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-07T00:00:00+00:00'::TIMESTAMPTZ, '4bbad3bd0669e35c47b181ac901be5d323b2eb07bb771a1dce4f95e28e842f03'::TEXT, ARRAY[1793]::BIGINT[]),
    (442::BIGINT, 'Se complica explicando, y las clases son más largas de lo que deberían. No la recomiendo, bajo punto por cosas que a ella no le parecen, pero no venían en las instrucciones.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'e3046f37c273c868cd2c19dba51702a41c64c5f9855f6447ae9f5223b515c3c3'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Es muy buena, a veces maneja el curso como se le pega la gana pero igual no es difícil, en los exámenes deja sacar material de apoyo. Mientras usted ponga de su parte va a pasar super bien y va a aprender bastante'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Clases largas']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '6abce3c74034df6e371f7d9f540dc8e3bb0f2b0705699837ec74ea261e2e4eeb'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Es cierto que a veces alarga las clases, sin embargo, si usted tiene paciencia va a aprender y pasa súper bien el curso. Suele ser un poco desordenada con los proyectos pero Melissa también. Si quiere aprender y pasar chill, hágale.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '0c470e716f4d73a9c73ec58565ebd7795d8dc4656382b4513de6d8f6301a6f9b'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'En clase se le entiende maso, pero no es muy complicada la materia. No ayuda en consulta, perdida de tiempo. Se pasa facil el curso pero si es un despiche para todo, los temas del proyecto se terminan de ver la semana antes de entregarse, entonces atrasa la entrega'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2022-12-22T00:00:00+00:00'::TIMESTAMPTZ, '5e6a7131ffea54034f382c0cf86f3444f594fa924b4417fc805144c218312c10'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'En general es una buena profe, muy amable y atenta. En ocasiones se alarga más de la cuenta con las clases y a veces son un tanto aburridas'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-01T00:00:00+00:00'::TIMESTAMPTZ, '8d32f21929edc441126c7f7bb25bd65ec6f69d7605cbb06becd4d58b8d8b13d4'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Las clases siempre se extienden entonces no matriculen seguido después de esta clase. La profe es buena gente y es amable. Recomendada.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2022-10-07T00:00:00+00:00'::TIMESTAMPTZ, '9996babb3e5c51f4937eaa9b9d7bdabd79891f7b13597161f3f2a9d9697a9d86'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'La profe es buena gente y sus clase son largas por lo que se torna un poco aburridas. Las evaluaciones algunas son diferentes a como las vistes en clases, da muy poco tiempo y solo pone la calificación no sabes realmente en que te equivocaste. No la recomiendo, pero tampoco es tan mala opción.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-02-01T00:00:00+00:00'::TIMESTAMPTZ, '722f379b666bf11a5f851d54fea780e0ec387b253cb12324a2d1c939463a3ac0'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'La profe explica bien, el proyecto es muy útil pero no da retroalimentación, el curso es muy tranquilo y sí se aprende la profe siempre esta dispuesta a ayudar de forma amigable, eso si la clase es larga y a veces se extiende del tiempo estimado es fácil pasar si se estudia y lleva la materia aldía'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2021-11-05T00:00:00+00:00'::TIMESTAMPTZ, '93e452d3a4bf4f47547cf779c01caec9f50d6fae4353f96257228dc4c53b7015'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'FATAL!! Las instrucciones en las evaluaciones no son nada claras y son muy confusas, es muy mala para estimar los tiempos en una prueba, y pareciera que se nutre con el sufrimiento de los estudiantes, ya que pareciese disfrutarlo con sus terribles evaluaciones que nunca superare, CON ELLA NO 404'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2021-11-04T00:00:00+00:00'::TIMESTAMPTZ, '5bfebdc8d619d78073b6f22aadffa3b714ceef95a176f19b6ccbf911faeadad8'::TEXT, ARRAY[1793]::BIGINT[]),
    (442::BIGINT, 'Se confunde un poco y se hace bolas a veces, pero sabe mucho de la materia y siempre está dispuesta a ayudar. Deja algunas tareas programadas largas y dura casi todo el rato de la clase. Las evaluaciones las devuelve a buen tiempo. Hay que poner atención en clase pero sí se aprende. No es difícil.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-15T00:00:00+00:00'::TIMESTAMPTZ, 'b78ddee83dc22cd161190fc2b43190ccaa3c4c8d4b41ba9ec926ef6aa546ba15'::TEXT, ARRAY[1793]::BIGINT[]),
    (442::BIGINT, 'Es una profesora que tiene especialidad en ergonomía, por lo que sus clases siempre se basaron en eso. En mi percepción, las clases eran aburridas, pero es facil pasar.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'be1b1a599ce623a6afbe91a1f2404eb4548d36e6e998fe0afec015f3c9782c30'::TEXT, ARRAY[1719]::BIGINT[]),
    (442::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'c523447421e426d4db7783d48fda1e35cafa487eb8d3bb9b75f71ae4d34a484b'::TEXT, ARRAY[1757]::BIGINT[])
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
