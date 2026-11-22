-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=252
-- TEC-DATA-META years=2014,2015,2017,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.855443+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (252::BIGINT, 'Evalúa normalmente duro, explica rápido pero al menos considero que se entiende , también hay que poner de nuestra parte por supuesto, se aprende bastante, tiene su egocentrismo pero también intenta comprender cómo piensa el estudiante, pienso que si te interesa el control el es el que más sabe'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2025-10-23T00:00:00+00:00'::TIMESTAMPTZ, 'fae372984bb232830f347c1767bb240856df76268dbc8558b5f014e153757936'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Va a aprender demasiado pero el profe tiene sus cosas, le molesta que uno pregunte cosas que para él son tontas y a veces tiende a humillar a los estudiantes pero el curso es pasable, nada más estudie mucho las prácticas del mae y vaya frecuentemente a consulta porque le gusta ver el interés'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '24c167196e2e4c7621ea51377167ede482e6abd5337eaa1e1fe045d67f65dfde'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Va a aprender mucho si se pega su buena estudiada, pero sinceramente no es un profe que recomiende. No le ayuda en nada, explica la materia sumamente rápido (es tomar apuntes o prestar atención), se burla de los estudiantes y mal intencionado (no vayan a consulta antes del examen, por experiencia)'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2023-12-04T00:00:00+00:00'::TIMESTAMPTZ, '814db1a5c7cf189260964c0e88e83fc9c71481601d47cf5c333fd290edbe78dc'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Este profesor es malisimo no explica nada y tras de eso es demasiado burlon con todos los estudiantes. No ayuda en nota y no ayuda en nada a pesar de que se esfuerce.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'bedbc5fac783017800064bc7814ebbdbe5b2040803db75bfca441a8974941a44'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'No lleven con el, profesor que literalmente piensa que todos son ingenieros de una vez, nacidos profecionales y que cree que las explicaciones que da el son buenas. La verdad un profesor de poca empatia y muy montado con los estudiantes'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2023-01-30T00:00:00+00:00'::TIMESTAMPTZ, '6491303d569950e96659e4a32128cce02ed35af8735f7872317d9936a3b42feb'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Si quiere pasar fácil no es buena idea matricular con este profesor. Piensa que los estudiantes llegan al curso con mayor nivel del que realmente llevamos, y no vacila en masacrar en las evaluaciones. Sin embargo es bastante pasable si la materia es de su agrado, será un desafío interesante.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-12T00:00:00+00:00'::TIMESTAMPTZ, 'cbf67b31f916a8041081dd2413b15663d9fe9458cf773ea870d3c4daad82928c'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Es un buen profe y sabe un montón, supuestamente estaba apunto de sacar el doctorado. Sin embargo, es muy exigente y se va a volver un curso demandante. Si quiere pasar fácil matricule con Gómez, si quiere aprender y le interesa el tema de automatismo y programación en C++/Arduino/PLC Murillo.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos proyectos grupales']::TEXT[], '2022-08-30T00:00:00+00:00'::TIMESTAMPTZ, '7cee53c757ee9c2c694b59657cb5c68a4222a78d3efd80ab0c281a7871bb38df'::TEXT, ARRAY[992, 994]::BIGINT[]),
    (252::BIGINT, 'El peor profesor de la escuela, un curso de un crédito se vuelve de 4, no enseña nada y quiere todo perfecto, es un pésimo profesor'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2022-08-29T00:00:00+00:00'::TIMESTAMPTZ, '1f27817e120f51d2c140076d425144eb5a517c45a77d1f3898f213640001d5b3'::TEXT, ARRAY[994]::BIGINT[]),
    (252::BIGINT, 'Es el segundo peor profesor de la escuela despues del Vaquerano, no tomen la clase con él, no se le entiende nada. La segunda semana y ya pide que seamos programadores es increible.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Deja trabajos largos']::TEXT[], '2022-08-09T00:00:00+00:00'::TIMESTAMPTZ, 'e7e8fa09a8dc900a15fa4fa9bd1d9e6e6349e4d48d955715861fac7c00f6f662'::TEXT, ARRAY[994]::BIGINT[]),
    (252::BIGINT, 'Enseña bien la materia, se relaciona mucho a lo que entra en los exámenes. Deja 3 proyectos grupales de utilizar software y una exposición. Es egocénctrico y burlón, pero hay que saberlo tratar. Brinda buena consulta.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '4f3050bfdee5115ebeac267688276c434df12970d5ceb9caa7dda1cd6fd8903e'::TEXT, ARRAY[992]::BIGINT[]),
    (252::BIGINT, 'Pesimo, el peor profe de mante, no entiendo como no despiden a personas que no hacen bien su trabajo, se burla de los estudiantes y nadie lo quiere, seguro por eso es asi'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2022-03-17T00:00:00+00:00'::TIMESTAMPTZ, '28e8c931f79ce24676d3af303205ef91a793bce34e8fd0764762d3fa1cef3db2'::TEXT, ARRAY[3653, 994]::BIGINT[]),
    (252::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'c94b72c8f8745023cf739ae948ea11daebccf31b273411d447cc65f4ce8a5da9'::TEXT, ARRAY[3065]::BIGINT[]),
    (252::BIGINT, 'Simplemente no le interesa enseñar. Posiblemente este ahi solo por el salario. Incluso se nota que esta indispuesto antes de cada clase. Arrogante, le encanta rajar y hacer menos a los estudiantes'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-29T00:00:00+00:00'::TIMESTAMPTZ, '1ba8522da24127145192321b3f8a3d1255f8c9e979406f35d679752e72377d8f'::TEXT, ARRAY[926]::BIGINT[]),
    (252::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-05T00:00:00+00:00'::TIMESTAMPTZ, 'f2e8657093b2de9a45bdc845d39411d8c0cee7acc21b8dab079e2d104383c0fd'::TEXT, ARRAY[3065]::BIGINT[]),
    (252::BIGINT, 'Mal profesor, pésimo enseñando!'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('20','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-01T00:00:00+00:00'::TIMESTAMPTZ, '7e257a9aada808ad9b7d9976a7ea97598484fc18cbe5192d7b15db3330e53c4c'::TEXT, ARRAY[962]::BIGINT[]),
    (252::BIGINT, 'No enseña nada, sabe tanto que no sabe explicar.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-02-03T00:00:00+00:00'::TIMESTAMPTZ, '40a2154178d3af4ae0427b930c724f9fc1ec904b9cef2595badf997a0ff62081'::TEXT, ARRAY[926]::BIGINT[]),
    (252::BIGINT, 'Mal profesor, él simplemente no enseña nada. Pero lo recomiendo para los que sean totalmente autodidactas y gusten de aprender de un libro.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, '904cca99b873fd798d8163edcfea203afa620d8e5d4c2d3292d519652dd9bdae'::TEXT, ARRAY[2894]::BIGINT[]),
    (252::BIGINT, 'Muy mal profesor es mas fácil entenderle a cualquier libro que a el'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, '15067baafe76b532db167ab66c850ea19324b32f19a01424e6489a63c9c99b56'::TEXT, ARRAY[962]::BIGINT[]),
    (252::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-23T00:00:00+00:00'::TIMESTAMPTZ, '69346e64366970665bf7b4eabd05103d96b051efe025cdcca59b0f698a5ce4fe'::TEXT, ARRAY[962]::BIGINT[]),
    (252::BIGINT, 'En Electri I da muchas oportunidades para pasar. A veces se enreda solo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '367931ff8a5ad2471dc48fe9fb5bf51c4ceaa8a1915cd9b78fa437377b32a8ee'::TEXT, ARRAY[2894]::BIGINT[]),
    (252::BIGINT, 'En realidad pasamos menos de la mitad, pero los que no pasaron fueron por mamadores. Porque el Profe hizo curva en un examen y puso un ejercicio extra en otro en el que muchos alzamos la nota. Los que le pasamos, llegamos a Electricidad II volando.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'a038a1eecb5d2c97d5f166e04ef8db0d0259c87747254930ffedab45d070f6f4'::TEXT, ARRAY[2894]::BIGINT[])
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
