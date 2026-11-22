-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=834
-- TEC-DATA-META years=2020,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.477558+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (834::BIGINT, 'Pésimo profesor, tienes que adivinar que se supone que se debe hacer durante el curso, deja un cronograma donde se basa para hacer todos los trabajos, lo único que cumple de este es sobre si las clases por semana son presenciales o virtuales. Las rúbricas son de otros años, indicaciones confusas.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-10-21T00:00:00+00:00'::TIMESTAMPTZ, 'ecc5c9aad3ec05d57dfdbecbdaa9acc7eb4fffadf107c533e8bc716a929dd37f'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'En general muy buen profe, muy llevadero y no califica muy rudo... Cabe destacar que normalmente para obtener buenas notas debes pedirle retroalimentación o pedir de su ayuda en los horarios de atención y con eso de fijo sacan buenas notas. Pd: Le gusta que participen en clase o por lo menos hablen'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2026-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'a5385489494e9dceba422fc5007fb6aa8e824d8f733f549c8ecd44296b091ac5'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'No lo duden, es buen profe, demasiado fácil pasar el curso, no califica nada duro. Aveces se le mete un poquito el agua pero es muy buena persona y ayuda bastante. Se pasa con ir al día, eso si, 90% de la nota son trabajos en grupo, así que elijan bien su grupo y todo será un 100 asegurado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2026-02-02T00:00:00+00:00'::TIMESTAMPTZ, '1d41f1836a13964aa8f6136829d894a769feffec2cc1473737d7ab1a8851c7cf'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'Muy buen profe, hace las clases muy entretenidas y logra que sus estudiantes se interesen por los temas de la clase, por lo que las clases no son cansadas. Los trabajos no son complicados, le gusta que lo busquen en hora de consulta y ayuda para sacar 100 en los trabajos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '17fc0820051770ed220b9741cd7f97f09ea6f3b38a9e1d538a58604d7582b732'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'El curso con Benja no es complicado, en absoluto, con tal de seguir las rubricas que deja y solicitar la hora consulta, ese curso se pasa con más de 90. Pero, este semestre que pasó, dejó 60% de evaluación para las últimas 4 semanas, pero, tampoco eran trabajos complicados.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-26T00:00:00+00:00'::TIMESTAMPTZ, '2a59ee7e5a3c787feec6103e1f41f0f6bb41b05e364967eacd3ffd151f074e27'::TEXT, ARRAY[981]::BIGINT[]),
    (834::BIGINT, 'Muy buen profe, hace que la clase no sea aburrida, da muchos puntos extra, si sigue las rúbricas y le envía los trabajos antes de cada entrega le va ir excelente, da bastante retroalimentación.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2024-06-06T00:00:00+00:00'::TIMESTAMPTZ, '0b1e136a362e7d3a3e0694622e6e1e8467deb2d5a39f0752b0607e4c29602248'::TEXT, ARRAY[981]::BIGINT[]),
    (834::BIGINT, 'Si no puede llevar muchos cursos, puede matricularlo con él, pero si el semestre está pesado o estas llevando algún otro curso en verano, no lo matricule por que requiere tiempo hacer sus trabajos y pide mucho para ser de 2 créditos el curso, el lo hace como si valiera 4 créditos'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2024-03-19T00:00:00+00:00'::TIMESTAMPTZ, 'a9a6d09d26de1f27dd95f630d62ccbc0f51d4ae7b0a579496371064b6917ff62'::TEXT, ARRAY[981]::BIGINT[]),
    (834::BIGINT, 'Buen profe, es muy flexible con las entregas, califica duro pero da mucha retroalimentación, la clase la hace muy dinámica e interesante. El único problema es que no explica mucho las evaluaciones, solo deja rúbricas. Si tienen un buen grupo de trabajo y van a las consultas van a pasar de fijo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'd57fb3d4faacbf429872b6eda9d7f58abca3fc27c8e867c9df7beabdb7ce5dca'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'Es pasivo-agresivo, aveces llega a ser odioso y estricto, pero siempre trata de ayudar a los estudiantes. Las clases las hace entretenidas y explica bien. El curso es fácil con un buen grupo de trabajo se pasa.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-01-20T00:00:00+00:00'::TIMESTAMPTZ, '57988d9388dd5cfa15d90353ca958c2cb5a4d38e8e925d1b364e8adb8cd9ac26'::TEXT, ARRAY[981]::BIGINT[]),
    (834::BIGINT, 'Muy buen profe y muy amable, super facil pasar el CFH y además muy interesante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-07T00:00:00+00:00'::TIMESTAMPTZ, '9dada3f020c480c0db31f7c345ce01b75056d35ca6d874ef36df212fc491fd5a'::TEXT, ARRAY[833]::BIGINT[]),
    (834::BIGINT, 'El curso es sencillo, solo tiene que poner atención o leer el pdf para contestar el foro y listo, trate de hacer'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-09-03T00:00:00+00:00'::TIMESTAMPTZ, '4b350f2d3cc2487657ef1b0cd644fc1dc6b8a6822cb2ab2b8059fa570e2320b7'::TEXT, ARRAY[687]::BIGINT[]),
    (834::BIGINT, 'Llevé dos CFH con él y me hizo interesarme totalmente en la clase. Lo recomiendo como a ninguno, el profe Benjamín es lo mejor. No dude en matricular con él, es demasiado pura vida y no se va a aburrir ni a arrepentir.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-24T00:00:00+00:00'::TIMESTAMPTZ, 'a9bfe13c942e8f4cfdb0a7fa16337c010b6af988d7fa5df923fa3c0cfc6ebd47'::TEXT, ARRAY[648]::BIGINT[]),
    (834::BIGINT, 'Es un muy buen profesor su clases son interesantes y capta la atención de los estudiantes'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Respetado por los estudiantes']::TEXT[], '2021-07-23T00:00:00+00:00'::TIMESTAMPTZ, '8e6ea60f8088ca6c17f3fa78eb8cc8a97fc1c483c8864a459433b76d2a22c8fe'::TEXT, ARRAY[628]::BIGINT[]),
    (834::BIGINT, 'Excelente profesor, hizo de este centro una clase super interesante, siempre me dejó con ganas de saber más acerca del tema, las evaluaciones super sencillas también.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-05-28T00:00:00+00:00'::TIMESTAMPTZ, 'a189f2eac9044956879aba7b104f5d906153a417176d75a0eb96c5f9d288b4ab'::TEXT, ARRAY[872]::BIGINT[]),
    (834::BIGINT, 'Algunos temas que se tratan en las clases son interesantes. El profe deja trabajos muuuy largos y califica muy duro. Si toman alguna clase con él, les recomiendo hacer los trabajos que deja en grupo y enviárselos antes de la fecha de entrega para que les dé recomendaciones.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'd37ddc03b0524a330731b3fb80f99f591d5ccea4fdb6cd9700f392cc7546c405'::TEXT, ARRAY[2460]::BIGINT[]),
    (834::BIGINT, 'El curso lo da en conjunto con el profe Rodolfo González. Es pesado para ser de 2 créditos, sin embargo, los profes son súper amables y ayudan un montón. Te dan un montón de ejemplos de los trabajos y si te apegás a los ejemplos de fijo te ponen 100.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-12-09T00:00:00+00:00'::TIMESTAMPTZ, '31b65b664bceb04097ffc52efdcd0682c67e8464cf162f935f78090fe50500e5'::TEXT, ARRAY[980]::BIGINT[]),
    (834::BIGINT, 'Excelente Profesor, lo recomiendo demasiado, el que pierda el curso es solo por vago, vayan a consulta!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ, '0297db0acf4476c1abf19f9c99410bd47ce7d9bfa8f9f0b6519b183bb86489ae'::TEXT, ARRAY[980]::BIGINT[]),
    (834::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, '954baeddf4c6743914f1b324ae2ca305c428ad6ef888207ada06cbcbd6deb9a9'::TEXT, ARRAY[769]::BIGINT[]),
    (834::BIGINT, 'Muy buen profe, recomendado.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2020-05-20T00:00:00+00:00'::TIMESTAMPTZ, 'd6299caefa9c251fe68ab9fcac555d15c1c228ad00476a6e9754a0cc9a1ae516'::TEXT, ARRAY[559]::BIGINT[])
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
