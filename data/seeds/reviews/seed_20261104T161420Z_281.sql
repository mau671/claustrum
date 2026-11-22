-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=281
-- TEC-DATA-META years=2014,2015,2016,2017,2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.032850+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (281::BIGINT, 'Es muy buen profe, con mucho conocimiento. Lo único es que es muy exigente.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-09-11T00:00:00+00:00'::TIMESTAMPTZ, 'd70bcadfed47ab2a505261ac4b9d5458bd2ab1890802b741c0e4f68278231c6c'::TEXT, ARRAY[1030]::BIGINT[]),
    (281::BIGINT, 'Prepotente, clase invertida al 100% todas las clase la dan los estudiantes con presentaciones en caliente da 20 min para hacerlas y presentar de una... y el poco tiempo que sobra solo lee conceptos básicos, de lo peor la verdad. Super cerrado y es lo que el dice y ya. cuiden la salud mental'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Deja trabajos largos']::TEXT[], '2024-01-29T00:00:00+00:00'::TIMESTAMPTZ, '51c8b5236c45f98255a78d5ce189b74333a06a50044cdfee34af26d0ca5e795e'::TEXT, ARRAY[1154]::BIGINT[]),
    (281::BIGINT, 'Siempre trata de ayudar, explica bien, siempre trata de evacuar duda y es importante la participación en clase'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-06-15T00:00:00+00:00'::TIMESTAMPTZ, '63d6ee51994837190cf9041661c08ce0cb8baee7c88f45f19c655e175d0c2c72'::TEXT, ARRAY[1020]::BIGINT[]),
    (281::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2023-06-01T00:00:00+00:00'::TIMESTAMPTZ, '2c4ecef39b3ce25511008de9c683c49042c3ef34ff70f3bf4f90d252cc659115'::TEXT, ARRAY[1020]::BIGINT[]),
    (281::BIGINT, 'Es buen profesor, aunque algunas veces va muy rápido y no se logra comprender al completo la materia'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Da crédito extra', 'Pocos exámenes']::TEXT[], '2023-05-31T00:00:00+00:00'::TIMESTAMPTZ, '9a90933dcc1aaa530063bd015d71cbba95e7457928cb006a97537d0710d2afcd'::TEXT, ARRAY[1022]::BIGINT[]),
    (281::BIGINT, 'No da la clase, la clase la dan los estudiantes y cuando "da" la clase, es 30min de leer una presentación y ya. Es un profesor prepotente y que cree que nunca se equivoca, revisa los trabajos cuando le da la gana, deja trabajos muy duros y además los enunciados no lo entiende ni él.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos proyectos grupales']::TEXT[], '2023-05-19T00:00:00+00:00'::TIMESTAMPTZ, 'f1130f10146c3fdf30ef5620cc80c05f97605362e18034973e937ad8946ffcf4'::TEXT, ARRAY[1154]::BIGINT[]),
    (281::BIGINT, 'El mae no da clases solo llega a leer diapositivas y para todo manda a hacer presentaciones grupales porque no quiere dar clases. Todo el grupo está harto del mae y solo la mitad se sigue conectando. Deja proyectos largos y confusos. Evalúa durísimo mínimo error -10 puntos.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-05-19T00:00:00+00:00'::TIMESTAMPTZ, '16f2bd9773ec189101b0ce0bc034715639ccb6ed87776fd120c2312c8d4b0654'::TEXT, ARRAY[1154]::BIGINT[]),
    (281::BIGINT, 'Hace bastante presentaciones grupales, algunas veces se tarda en revisar los trabajos. A veces cuesta entenderle. 2 proyectos basados pura documentación y el 3ero en una app Web(esto no se enseña en clases).Lo considero un buen profe, lo usual en donde tienes que poner de tu parte y pasas el curso.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2022-12-03T00:00:00+00:00'::TIMESTAMPTZ, '3c338028984a2607c44feb32fc2ffeb926f69dc35b5b74f19d5bc8cd69e688ac'::TEXT, ARRAY[1047]::BIGINT[]),
    (281::BIGINT, 'Aunque sus explicaciones son algo confusas al igual que ciertos ejercicios o proyectos, es muy buena gente y accesible a conversar'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Brinda apoyo']::TEXT[], '2022-02-01T00:00:00+00:00'::TIMESTAMPTZ, '32bedeb5f6b75c354efe5b008309eec651a6ca62556ed240c1d308f2906b6999'::TEXT, ARRAY[1022]::BIGINT[]),
    (281::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('20','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'c9c896f2132c444990370c246b5a39e100b014ad8428674b0f2e19fd3daae25e'::TEXT, ARRAY[1020]::BIGINT[]),
    (281::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2021-01-22T00:00:00+00:00'::TIMESTAMPTZ, 'bd4c31b4e93f81ef8131af9c75e84c2635c3e1cf6bb94fb4a7eded4ded217e59'::TEXT, ARRAY[1020]::BIGINT[]),
    (281::BIGINT, 'Está obsesionado con la ortografía, así que prepárese para tener un profesor de documentación escrita que de computación, dura hasta un mes para calificar los trabajos. No le gusta que el estudiante le cuestione nada y tiene preferencias con ciertos grupos. En fin no se embarque con este profesor'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ, 'dcc67329b2a98174f55fc8c7e9ce498e8536ce7aa39780f0a8ced5cfce87e681'::TEXT, ARRAY[1043]::BIGINT[]),
    (281::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '5c708eeeb90414facab7ed4cb9010d586c6a765aa822a3b1590e21a03bdcb987'::TEXT, ARRAY[2534]::BIGINT[]),
    (281::BIGINT, 'el sabe mucho, pero de manera práctica; a la hora de enseñar se basa en las presentaciones, y llega a leer a las clases (como todos han dicho), si se le hace una pregunta, puede que sepa contestar muy bien, o todo lo contrario, y te deje más confundido, es muy buena persona, y muy accesible.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ, '0e8518b4fd045c763ea0bfad9ba40f42484298701834c8b5eb4b6909a0156704'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'Bueno no es experto en el tema así que todo lo iba a leer, por tanto la materia nunca quedaba clara. Examenes dificiles y muchos quices. Ayuda un poco. Grupos de trabajo muy grandes para proyectos y proyectos dificiles.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-22T00:00:00+00:00'::TIMESTAMPTZ, '9e0e5524d65b3cecd8b662b51ca7b5f409656534ea80fd4d2b68f947d2b4245a'::TEXT, ARRAY[2534]::BIGINT[]),
    (281::BIGINT, 'No sabe de lo que esta hablando, nunca se sabe explicar para las dudas! Siempre esta enredado, lee todas todas las presentaciones y la clase se vuelve rutinaria y aburrida. Es una persona buena pero se complica demasiado. Sus examenes son demasiado largos y el cree que son faciles y cortos -.-'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'd509ad3e44c4cc5c8deb6e0a578d7f7ba9e8a41e7d0d36c8bb418a34f68fd5a4'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'Lee todas las presentaciones y muchas veces no sabe lo que dice. No planifica bien las lecciones y para calificar no es tan suave. A veces es irresponsable para devolver trabajos entregados. Sus clases se vuelven aburridas. Recomiendo a Sonia Mora más que a el.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-27T00:00:00+00:00'::TIMESTAMPTZ, '43083892a8bf0d9a6cfcee0cd9266b4b8eddf8c3e9a7f5dc90506cb581b4cc63'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'Como persona es muy bueno. Como profesor es bueno pero a veces no deja bien claro sobre que es lo que espera en los trabajos y es muy exigente al calificar. Es flexible excepto en lo que se trata de calificaciones. Sí va a aprender en el curso, para ap es preferible respecto a otros profes.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-20T00:00:00+00:00'::TIMESTAMPTZ, 'b1f5464011d879aeeddd275cd2985df6243cbbb9e7551c7e529d45bc7a24aca4'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'El sabe mucho solo que si se basa mucho en el PMBok, por lo que es de basarse mucho en el libro'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-18T00:00:00+00:00'::TIMESTAMPTZ, '547b6f7aedd2ff5487229a2f4f2e8047507bd1698cfb6c87c79d3f7c3f4dbbdc'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '7fd662b76ed3a3c3295d419ac772792a33314a6034d36e5ff19f5df6e7a1b172'::TEXT, ARRAY[1052]::BIGINT[]),
    (281::BIGINT, 'Es una buena persona pero como profesor pide todo como esta en el libro y si no esta igual le quita la mitad de la pregunta, a veces pide cosas como meter una imagen muy grande dentro del documento de word y a la hora de calificar dice que esta ilegible!!'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'f08fad10370ab73e74b170969d3a373d284ccb634c670be839bca369e314c5da'::TEXT, ARRAY[1052]::BIGINT[])
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
