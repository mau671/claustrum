-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=334
-- TEC-DATA-META years=2017,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.887771+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (334::BIGINT, 'Es una profesora que tiene un conociminto muy amplio, su evaluacion no es tan dura, los examenes no valen mucho, pero sus tareas/proyectos son inhumanos, una tarea que vale 2 puntos te puede costar 12 horas, los examenes evalua duro y no acepta reclamos, despues de ahi bien, se preocupa por enseñar'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2026-07-24T00:00:00+00:00'::TIMESTAMPTZ, '19d6d032c8a479378661b3da0a3789d0d702e22b15e523e1ef3c4642d4537e2c'::TEXT, ARRAY[1043]::BIGINT[]),
    (334::BIGINT, 'Muy buena profesora, sabe bastante del tema y es muy humana. Deja bastantes trabajos, pero la mayoría son grupales y la evaluación está muy bien distribuida para pasar. En resumen, enseña bien y no es difícil pasar con ella. 10/10'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '0c432c315fab2d205837df8d1c17dc50aed9fcef3f0a13905a81d068ab318848'::TEXT, ARRAY[1037]::BIGINT[]),
    (334::BIGINT, 'Es una profesora excelente, se nota que le gusta la materia. Los trabajos y exámenes son un poco largos y algo complejos, pero en general la materia es sencilla si se le presta atención en la clase.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Deja trabajos largos']::TEXT[], '2025-07-03T00:00:00+00:00'::TIMESTAMPTZ, '21d98aad74bf73ba245d9cc5f33f6150ac3e3d8f7717cd6afb8c8fef71c8813e'::TEXT, ARRAY[1043, 1037]::BIGINT[]),
    (334::BIGINT, 'Buena profesora, se ve que sabe mucho del tema y que le gusta enseñar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-03T00:00:00+00:00'::TIMESTAMPTZ, '1f0815cdad06e0a8ef2d9ce09b067bbd8071541d555a492ec90a52f951291ada'::TEXT, ARRAY[1037]::BIGINT[]),
    (334::BIGINT, 'Las clases son tan monótonas que duermen, es pesadísima a la hora de calificar rebusca hasta la última gota para bajar puntos, las calificaciones nunca están al día y encima los trabajos son pesadísimos'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2024-12-03T00:00:00+00:00'::TIMESTAMPTZ, '697b378b36eee0bdae7a71b0e467aac074d3785cdaedfe082125a69965e9c0d8'::TEXT, ARRAY[1162]::BIGINT[]),
    (334::BIGINT, 'Realmente es muy buena profe, el curso es medianamente sencillo siempre y cuando se le ponga lo suficiente, la mayor crítica son las tareas que a veces pueden ser demasiado largas, sucede lo mismo con los proyectos, los exámenes son normales, apoya mucho al estudiante (pasa fechas), recomendada.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'a62ef842692050612f01149ae20d6aa9d56ef9d9b6cccba930758c2ffc71f7a4'::TEXT, ARRAY[1037]::BIGINT[]),
    (334::BIGINT, 'Deja demasiados trabajos, la matería es demasiado difícil o ella la explica de una forma técnica muy abusada. Lo que explica también es el primer tutorial que encuentra en google, pesima forma de calificar, por más que se le da lo que quiere busca el mínimo error para bajar puntos.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2023-10-05T00:00:00+00:00'::TIMESTAMPTZ, '19903b9dc3c17ce3a97625772d35e17cf4288977b02cd43e8d6babb4559c144c'::TEXT, ARRAY[1162]::BIGINT[]),
    (334::BIGINT, 'Un amor de profe. Es algo estricta pero es porque se preocupa por el estudiante (ponga atención nada más y no use el celular). Se pueden negociar fechas de entrega, porcentaje de exámenes, etc.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-02T00:00:00+00:00'::TIMESTAMPTZ, '8921e4a954f5f634674b58eca01ade48a56e4f19386662a99900c19810b7853c'::TEXT, ARRAY[1043, 1045]::BIGINT[]),
    (334::BIGINT, 'No brinda un espacio de confianza, si pregunta algo y el estudiante no responde castiga de forma irónica y dice que eso es muy facilito, para ella y sus 55 años de experiencia, da cero en investigaciones si en la exposición no dominas 100% el tema, proyectos que no se entienden que quiere.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'd72be87a74e081995f861d3661fd964b0019a8c46a2a7d2a8d73aaa8f38f494e'::TEXT, ARRAY[1162]::BIGINT[]),
    (334::BIGINT, 'Me gustó llevar IA con esta profe, no fue muy complicado y se le entiende relativamente bien, no busca perjudicar a los estudiantes'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2022-06-03T00:00:00+00:00'::TIMESTAMPTZ, '1554c5b1f6054386cc681cc4899146cff412da95db65c69b8aefba534fcb6c2f'::TEXT, ARRAY[1162]::BIGINT[]),
    (334::BIGINT, 'La profe no califica nada, todo le queda al asistente lo que provoca que el chorro de tareas que deja no tengan nota hasta semana 18 y que si ud entrega una tarea mal hecha o un proyecto basura le ponga un 100. Cada clase son 2 horas leyendo presentaciones'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'b919406d68a7c57318e89a7a9c70750a40e0e805242c892b27cd09c629260d4d'::TEXT, ARRAY[1043]::BIGINT[]),
    (334::BIGINT, 'muy buena profesora ! siento que en el curso aprendi mucho con ella. Deja proyectos buenos para entender la materia. los examenes son duros XD'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-02T00:00:00+00:00'::TIMESTAMPTZ, '5ecd5b4f92a7b012415b6c7094fbcc81f2300d10efbd7da7e83de56cf5b8158d'::TEXT, ARRAY[1043]::BIGINT[]),
    (334::BIGINT, 'Solo lee presentaciones y los proyectos son demasiado fáciles. El curso se gana fácilmente pero no se aprende mucho.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-14T00:00:00+00:00'::TIMESTAMPTZ, '262456750adea6ee42d2cc53b976a88ca6994130cd855913cd9e593c809ad77e'::TEXT, ARRAY[1043]::BIGINT[])
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
