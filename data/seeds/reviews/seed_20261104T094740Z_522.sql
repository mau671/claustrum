-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=522
-- TEC-DATA-META years=2016,2017,2018,2019,2020,2021,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:47:40.797557+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (522::BIGINT, 'Simplemente es lo peor que existe, ya entendí porque lo mandan a dar clases Alajuela, no matricule con el, es terrible profesor y terrible persona, si se quiere un poco y no quiere odiar el curso, CORRA de este tipo'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'ff2da457345e09aa9a0085dd7c66aa43e46197badf7f0226fa185106e88179bc'::TEXT, ARRAY[605]::BIGINT[]),
    (522::BIGINT, 'Solo lleve con el si ya sabe el curso y planea pasar solo sacando 100 en los examenes de catedra, porque es imposible en verano con los examenes que hace y las nulas explicaciones que da en clase.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, '819a812d756869f6fb734706e730ba56c716c113bd0cf014213c974257e56594'::TEXT, ARRAY[634]::BIGINT[]),
    (522::BIGINT, 'Los quizes qué hace, ayudan bastante para los exámenes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Pocos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-20T00:00:00+00:00'::TIMESTAMPTZ, '0adda4ed71346dae6392e9c7c5818ef9d38187a92873d33e5ace1e89a7f01660'::TEXT, ARRAY[1018, 563]::BIGINT[]),
    (522::BIGINT, 'No matricule con el, todo lo que dicen es cierto y peor'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2025-02-07T00:00:00+00:00'::TIMESTAMPTZ, '1431f19a6043a08eedc537591d41b3af0c6b2b625c03e41bc1e275434a73761b'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Es lo peor que hay en el TEC evítelo a toda costa, es más difícil ganar un quiz de este profesor que el mismo examen.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-01-27T00:00:00+00:00'::TIMESTAMPTZ, '2acf4b6889f9f0898f4d1f1fc68c817db446e6c8822abefe19343f035cf4278b'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Para los de primer ingreso: NO MATRICULEN CON ÉL, es la peor cosa que podrían hacer.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2024-12-27T00:00:00+00:00'::TIMESTAMPTZ, '2e47a2bc3bef9630173cc43e91df159bf3e44f482fe7bbfd7332d7d0264d9afe'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Si es de primer ingreso no matricule con este personaje, el juega que sabe mucho, pero una vez que llevas el curso con un profesor de verdad, te das cuenta que simplemente es un chiste, se burla de los estudiantes, no explica y hace quiz estúpidamente difíciles, lo peor del TEC, un asco.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-08-28T00:00:00+00:00'::TIMESTAMPTZ, '385e0a8f7992375b1c395c9be2254eb010aa3da5d2d2c9d3e410eb0ee42bdb50'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Se burla de los estudiantes, si uno le vuelve a preguntar sobre un tema, no explica nuevamente, los quiz son ridículamente difíciles, y siempre llega a las clases con ejercicios con un nivel de complejidad exagerados, nunca se le entienden las clases.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-08T00:00:00+00:00'::TIMESTAMPTZ, '8465a7c71bbac4ce684eefe8e84c9877829c1f13458c1a38633f31d54dc829bd'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-02-07T00:00:00+00:00'::TIMESTAMPTZ, 'f8f74b9b34363b98eb1a172bb87e1fd7780ec303b7acbf9e7724c5d8a6385781'::TEXT, ARRAY[605]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('35','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Clases largas']::TEXT[], '2023-01-29T00:00:00+00:00'::TIMESTAMPTZ, '0ed1dad54119fab62a09e100e4a6969f58f6af24e4bbb76ba0681b6cec363185'::TEXT, ARRAY[605]::BIGINT[]),
    (522::BIGINT, 'No entiendo porque tiene una nota tan baja, en probabilidades creo que el mejor profesor que hay, preocupa por el estudiante, explica bastante bien, y ayuda en todo lo que puede, inclusive hace clases especiales bastante interesantes, recomendado'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-11T00:00:00+00:00'::TIMESTAMPTZ, '0619facc850e1cf352f4a0b9346d1128001a02c534e0c059736adf813cc23a78'::TEXT, ARRAY[1049, 4836]::BIGINT[]),
    (522::BIGINT, 'El curso es dificil por si solo, en cuanto al profesor explica entendible algunos temas, pero los quices y examenes son dificiles porque son de Catedra. Debe de mejorar con su explicacion y con mas ejemplos resolviendolos en las lecciones.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-15T00:00:00+00:00'::TIMESTAMPTZ, '38755c6f6d6e9f2f34a939d42861a49aac4767de36370859b2049db5dd02ce49'::TEXT, ARRAY[605]::BIGINT[]),
    (522::BIGINT, 'Es muy buen profesor, explica bastante bien y siempre está dispuesto a resolver dudas, ya sea de manera sincrónica o por mensajes. Además es amable y las clases son llevaderas. El curso es difícil sin importar el profesor porque los exámenes y quices son de la cátedra.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'f0b27003258c4e2a29ba2003e100ad0d49fb10143950bd2e89695653fa6d02d8'::TEXT, ARRAY[1049]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-12-17T00:00:00+00:00'::TIMESTAMPTZ, '7482f22af31e2c0b638dceffc0c121a092978cfbd38d64ab64b817be2fdff0a3'::TEXT, ARRAY[1057]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2020-08-10T00:00:00+00:00'::TIMESTAMPTZ, '29c6a0e961e08dc36945c043480e765410e3d22494581611740934b30a87dd60'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Quizá en el pasado fue un profe gruñón, por lo que vi en comentarios. Sin embargo, me parece que es un buen profe, quiere que los estudiantes entiendan superbien de donde sale todo lo que enseña. Solo que si participás y te equivocaste o estás mal, puede ser un poco irónico.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2020-07-22T00:00:00+00:00'::TIMESTAMPTZ, '97801d12b6fdcd167877da3255e130269d0ae70f9fa655f4f5f0e05ca7cb177f'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'a diferencia de otros estudiantes yo pienso que es un gran profesor no se como calificaría anteriormente pero sus clases actualmente me parece bastante provechosas y se preocupa por que uno entienda yo lo recomiendo y ara mi es un excelente profesor'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-07-02T00:00:00+00:00'::TIMESTAMPTZ, '88f7099c5c69b830552903221ed6731b564746a115823f7c09ab158a7f112134'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'a24efcd55faba43e2a423269305b13966b98202fbb65ce8e34fc4669d6244822'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'el peor profe que he tenido hasta el momento, explicaciones pesimas para aquellos estudiantes primerizos en el curso (mi caso), ademas tiene un complejo de superioridad que crea un mal ambiente para la evacuacion de dudas, le gusta humillar.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2019-10-11T00:00:00+00:00'::TIMESTAMPTZ, '5461d909b9835eaee723c5724b9db43f47e30423c04b71d9f3b947750aab35ee'::TEXT, ARRAY[634]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-02-04T00:00:00+00:00'::TIMESTAMPTZ, '1e99191074a34f6afc343d0b7b723d8f68770d9bed476638688af6107d5b81f7'::TEXT, ARRAY[2439]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-09-25T00:00:00+00:00'::TIMESTAMPTZ, 'e5ae4a82d442c9da4b2631637da29e95c2677fe63694d04eadd4f16146cb867c'::TEXT, ARRAY[1049, 4836]::BIGINT[]),
    (522::BIGINT, 'No explica lo necesario o se brinca aspectos relevantes. Si usted esta repitiendo el curso bien, de lo contrario se va a quedar perdido. Intimida a los estudiantes si no entiende algo. La impuntualidad es algo común ya que es de Alajuela. No lo recomiendo si hay posibilidad con otro mejor.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2018-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'd6bb4e95826c08965b371c12a45006d7f03d6badf2896fc5f9157a7718bbc9b5'::TEXT, ARRAY[2920]::BIGINT[]),
    (522::BIGINT, 'NUNCA metan con el, si queda solo campo con el mejor esperen al otro semestre! Es pésimo, el peor profe que he tenido, si a ud le explicaron en el cole de una manera diferente y le pregunta el le dice que no por que a el no le parece, si solo quedara campo con el preferiría tomarme año sabático'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-08T00:00:00+00:00'::TIMESTAMPTZ, '643675319394cae75ebf74f50e90c1e82a0817526202743fef81949f9c77b7a6'::TEXT, ARRAY[2439]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-11-13T00:00:00+00:00'::TIMESTAMPTZ, '683e24953b2836e50d658f197741fd8715a5e5d2f6084338a0c8f9defc3d5ce6'::TEXT, ARRAY[563]::BIGINT[]),
    (522::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-27T00:00:00+00:00'::TIMESTAMPTZ, '401a08963ab0b7c22f1ceea50f9db5e00a71a6a800c77c485da4b124c6667cf4'::TEXT, ARRAY[935]::BIGINT[])
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
