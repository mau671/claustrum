-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=498
-- TEC-DATA-META years=2014,2015,2016,2017,2019,2020,2021,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.109789+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (498::BIGINT, 'No es fácil pasar, requiere de que vayan a clases, pongan atención y si tienen dudas vayan a consulta. Jorge Monge es realmente un profesor con mucha experiencia y sabe enseñar, es estricto para calificar, pregunte como se deben resolver los ejercicios formalmente y les califica bien.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'cc6d8ff385ee47eaeacf894c80e5ffe8e4b8b4ab415f5400909f24ead6a43777'::TEXT, ARRAY[605]::BIGINT[]),
    (498::BIGINT, 'La materia puede ser o no complicada, y lo digo como si no lo supiera porque me da la impresión que el profesor complicó exageradamente la materia, explica, enseña y hace todo demasiado a la carrera porque se atrasa montones y encima no se despega de la tablet, es un dolor'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas']::TEXT[], '2026-04-04T00:00:00+00:00'::TIMESTAMPTZ, '036080fa7e53fddf6e335ebd16111ed44973bc23a3187922c04e911b1bad1b8b'::TEXT, ARRAY[605]::BIGINT[]),
    (498::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'c889de6b88fb9ebcdfc71b032bda13749dd54addbc8f64bd09c8d3423f63c634'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'No le haga caso a estas reseñas, son super viejas, mejor vea el otro perfil que sale y esas sí son recientes, para ahorrarle la buscada mejor vea otros profes, no he visto peor profe que este'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, '704a1b9192ed95f58a162a6a791675e17e7623531be49687b98c2f903789c28e'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'No es un buen profe, no resuelve suficientes ejercicios en clase, es arrogante y a veces no califica bien las asignaciones. No lo recomiendo.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-29T00:00:00+00:00'::TIMESTAMPTZ, '12aab93a87b9f3d0ca60519993aff05f86aba5437a46bff7231adbc1e44d1b60'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Me han dicho que es buen profe para cursos superiores, pero para Mate General no es bueno, las explicaciones son confusas y hacen que el estudiante se pierda muy facil. Solo se para frente a la clase con un iPad y en 2 horas de clases resuelve a lo mucho 2 o 3 ejercicios, no lo recomiendo nada.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2023-05-30T00:00:00+00:00'::TIMESTAMPTZ, '4d4ee8251a745d55b7a5b455262f9a88b410ce5c85314d527eac9fca36d26e08'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'Las clases pueden resultar aburridas o largas pero valen la pena, el profe explica muy bien y trata de dejar todo claro, resuelve todas las dudas, es ordenado, la cantidad de tareas es moderada y califica muy justo. A veces hace uno que otro chiste. Recomendadísimo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'a5b49b16e8570b9faa39ab986d36e751b23a2c66d4ba3c9ef21c4b6ba140be76'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'Las clases son medio aburridas, pero en el resto está súper bien. Los temas quedan bastante claros.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, '5fe36a81d2fdcfa5de23798b3738cdc7d4dbb7afb67bbf6d86324a1d543ef6b1'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'Lo da semivirtual, deja bastantes tareas pero nada del otro mundo, hay varios trabajos grupales que se hacen durante la clase. El profe explica bien y resuelve dudas. El curso es fácil.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-30T00:00:00+00:00'::TIMESTAMPTZ, '44623f5ef8b85e111b1507268472435163e38cbec84dae1358807e46c5fb2d6d'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Si es semivirtual, los trabajos y tareas se hacen en grupos, incluso algun quiz y un examen fue en parejas. El explica muy bien y no califica nada que no se vea o al menos mencione en la clase, el examen no es duro, es muy apegado a la materia que se vio. Atiende dudas.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-21T00:00:00+00:00'::TIMESTAMPTZ, '0ae8a110ba4328fe61826b4ff9ebd8db0a8298c087bbb17e9b9090db9642faa8'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Excelente. Deja tareas un poco largas y no tan fáciles antes de los exámenes, pero ayudan muchísimo. Además se preocupa porque se entienda y siempre está en consulta. Súper recomendado'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '68351d2d893ff7d27f0bb54c793ac52c4c37c7bec024dcd7a52f4fd4d81e535d'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-20T00:00:00+00:00'::TIMESTAMPTZ, '9116ed703e9396094ec82440c9ebc349cc0ee9f6573106caf028d1c0bd11a172'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2017-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'c43418fa9d4b8025f871718695f75a67f25a0944da49ce9a438cbc15dea631e1'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'La verdad a mi criterio es bastante malo, pierde mas tiempo usando la pizarra inteligente que explicando, los ejercicios que hace son demasiado fáciles y nada parecidos a los del examen, hay mucho mejores profes!'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a732fcb4e4202d116f5b3a9dc5d9e9044f69fc3a13905fd59a5a796abf6f94c1'::TEXT, ARRAY[563]::BIGINT[]),
    (498::BIGINT, 'Excelente profe. Aprueba de medriocres. Usa la tecnologia a su favor y al favor nuestro. Se preocupa para que se entienda todo bien claro. Es un profe que inspira superción!! Recomendado al 100%. Cuando termine el curso se darán cuenta de lo mucho que se aprende.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'dd83102a60d88b50eca798347c3c3bb9784dfeb3af499d0953036d3522b210cf'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Es buen profesor y todo, da buen material didactico, pero utiliza una cochina pizarra inteligente y gasta mas tiempo calibrandola que dando la clase, ademas dura demasido con esa cochina pizarra y casi no hace ejemplos. Deberia de gastar un poquito mas de marcador!!!!!!! No lo recomiendo'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'd43d6f2770f0916131b960baf11c795bdc71e5099a73c829344eda456850df62'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Explica excelente, califica normal y como persona es súper buena gente.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'a7a6e7f7da50a1a03f19ea1f9f0cba4b731aca93b80bcbb6b07fb4df2a7f9964'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'pienso que hay mejores profesores en la escuela'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-04T00:00:00+00:00'::TIMESTAMPTZ, '84d19d32f0fc1113365930af1ae32466bd77a5dd49d957d4465dc33bd84b9dfd'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'Es sencillamente un profesor del siglo XXI, utiliza un proyector inteligente, sube las clases al TEC-digital, deja tareas bastante buenas, bastante material extra y explica demasiado bien.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'a9ea691460b947499738729418acb8755c4dc90d7122d2b1fd863f2e512cbf70'::TEXT, ARRAY[923]::BIGINT[]),
    (498::BIGINT, 'EL mejor profesor'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, '1e5fc90c57254066a9a9c590fb0342b1b2548bca26068d5902e305ef6ca0e267'::TEXT, ARRAY[1864]::BIGINT[])
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
