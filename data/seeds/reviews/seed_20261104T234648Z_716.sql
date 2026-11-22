-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=716
-- TEC-DATA-META years=2016,2017,2019,2020,2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:46:48.126803+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (716::BIGINT, 'Esta electiva realmente no es muy difícil. 2 exámenes y 2 tareas, 15%c/u y un proyecto de 40% el cual no deben subestimar aunque suene fácil, puede volverse muy largo. Es muy teórica por lo que puede llegar a ser muy aburrida, y considérese que es un curso meramente introductorio.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2026-07-06T00:00:00+00:00'::TIMESTAMPTZ, 'e4d985d9dfd2ce689350f4fea7c5d1e5b1fe97df4cedebe64dcec926505c0af7'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Es el profe complicado de la carrera, traten de ir a consulta para las tareas y el proyecto, porque los examenes pueden ponerse complicados y confusos, entonces lo importante es ponerle bastante a los trabajos'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2025-07-15T00:00:00+00:00'::TIMESTAMPTZ, 'e8778391498952d242e370bfbe83f6573743afb36a364197e73b701762d288a5'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'El profe explica bastante bien, y a lo largo del curso hace tareas formativas con buen feedback para aplicar en el proyecto final. Lo único malo es que para retroalimentación en las tareas evaluadas hay que preguntarle en consulta.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'a82f29716a6da8fa4b2f98fad1699ef657590707f639cf3883202d550db724e9'::TEXT, ARRAY[3078]::BIGINT[]),
    (716::BIGINT, 'Se nota que el profe sabe mucho de la materia, y por lo tanto el curso se puede aprovechar mucho. Las clases son full teóricas, por lo cual las tareas al inicio pueden ser abrumadoras (mezclan teoría con programación). Si le dedica buen tiempo, pasa bien.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2022-11-26T00:00:00+00:00'::TIMESTAMPTZ, '2528994d8249885f234ec5f60aacca899f2978add549752f32e7e860225371e9'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Clases teóricas (aplicables solo al examen), tareas y el proyecto son prácticos (python). No tiene rubrica de calificación, póngale desde el inicio y se pasa.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '12ebb9b300f0d76d92f5f537a250d87f8c3979b074b08258104f932312036bc2'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Clases teóricas, evaluaciones prácticas. No vale la pena ir a clases porque solo habla paja y luego deja tareas que son como miniproyectos super dificiles. Es creido e inaccesible. No da una rúbrica entonces no se sabe de donde sacó la nota'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos']::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '76254ff28db515d659c7487fc11a9c3347f7abc959846714c35ba50a938da5fc'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'De forma virtual el curso estuvo bien organizado, los trabajos son largos pero si va a consulta el profe le da buena retroalimentación y en los siguientes trabajos corregir esos errores. Para los proyectos se debe trabajar con tiempo porque son pesados y valen más de la mitad del curso'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Deja trabajos largos']::TEXT[], '2021-12-05T00:00:00+00:00'::TIMESTAMPTZ, '1c461cdfa9a0c54a8f2df0704515aa57ae75396c979cc48efc4fbf1c150ee7f4'::TEXT, ARRAY[3085]::BIGINT[]),
    (716::BIGINT, 'El profe sabe demasiado de ambos temas y en consulta ayuda muchisimo a entender las tareas y proyectos que deja. Ademas es bueno ir a consulta para que le de retroalimentacion y asi poder mejorar las notas para los trabajos que siguen. Los proyectos son pesados y hay que trabajarlos con tiempo.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2021-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'd5afc562aedac46d7541c9516d8b5430cefb3492e1934ffd9e1ddd795b1f24e9'::TEXT, ARRAY[3075, 3085]::BIGINT[]),
    (716::BIGINT, 'Buen profe a mi parecer, pero si espera que uno le ponga bastante a los cursos suyos, y si quiere buenas notas, debe ir a consulta, para realimentación de trabajos y así, porque usualmente los califica estricto, y no se sabe las rúbricas que usó.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'a638b419de3276e8331c9c52387c07be582b37fe1c85d5a52bebcd9b7cc7d195'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Un mae aca lo puso perfecto. UN CANCER PARA MECATRONICA. Suerte a quien sea que tenga que llevar con este mae. Ojala se devuelva a España aunque probablemente ni lo dejan entrar.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2020-07-30T00:00:00+00:00'::TIMESTAMPTZ, '3ea59ca8df1bd8c81594ca242cd600615efccb1d2fb1e8cca34c9944dd417f7b'::TEXT, ARRAY[3075, 3085]::BIGINT[]),
    (716::BIGINT, 'La teoría la explica relativamente bien, pero es pésimo como persona, no se le puede preguntar nada, los exámenes son extraños y poco tienen que ver con la materia y se abusa con los trabajos que deja.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2019-11-11T00:00:00+00:00'::TIMESTAMPTZ, 'f5e03125fb529a9df9443a47f4b5bac9fe12c1da061addca2ca20f1997a28a7b'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'En mis cuatro años en el TEC ha sido el peor profesor que he tenido, exige a los estudiantes cosas que ni el mismo hace. Preguntarle cosas es inútil ya que pareciera que no conoce la materia. Simplemente no alcanzan las palabras para describir el pésimo profesor y profesional que es.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '9cf37401aa37c1b4956525262586ac9a1e2dc9309f4405ae3cf9f63c20dc6978'::TEXT, ARRAY[3064]::BIGINT[]),
    (716::BIGINT, 'Es el peor profesor que he tenido. Le ha hecho demasiado daño a la carrera de Meca por su egocentrismo y berrinches. Mal profesor, un asco de persona y ni qué decir de profesional. No se vio más de la mitad de la materia del curso, nunca explicó nada, sus exámenes eran totalmente sin sentido. NO NO'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '1680991c77080fc70fe8cdeef67d57e39239f1010ff37dd1fdb72123f3fb2436'::TEXT, ARRAY[3064]::BIGINT[]),
    (716::BIGINT, 'No explica bien. Si alguien tiene dudas lo trata mal. Califica a matar. No sabe organizarse con el tiempo y no se vieron todos los contenidos. No me explico por que lo pusieron a dar un curso tan importante como análisis.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2019-06-11T00:00:00+00:00'::TIMESTAMPTZ, '4c8338121aee5ba9db1403714488385d81e2032f62aaa838e7fa9362edbadd63'::TEXT, ARRAY[3064]::BIGINT[]),
    (716::BIGINT, 'Es un profe que sabe de lo que habla. Domina la materia y hace una clase muy interesante. Lástima que el curso no da para abarcar más temas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2017-12-08T00:00:00+00:00'::TIMESTAMPTZ, '7f4b8d6e5e02a9f9193e1f0c8d117d902dc5bddd588ca04e1ce70b732d6003f2'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2017-09-19T00:00:00+00:00'::TIMESTAMPTZ, 'd8f3d3ee8751338a9c087000dad5b8ca1599245d585a19b52c8d65023cfaee32'::TEXT, ARRAY[3075]::BIGINT[]),
    (716::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Clases excelentes']::TEXT[], '2016-09-18T00:00:00+00:00'::TIMESTAMPTZ, 'e2544d8211c81b26d3b1b9aefbb32cdb4300b792af6200f84d1bbefa4cc4b6f8'::TEXT, ARRAY[3066]::BIGINT[])
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
