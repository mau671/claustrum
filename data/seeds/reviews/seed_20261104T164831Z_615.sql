-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=615
-- TEC-DATA-META years=2017,2018,2019,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.813200+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (615::BIGINT, 'Realmente se preocupa por los estudiantes y se ve que le apasiona el diseño. Es bastante rudo para calificar en trabajos extraclase, pero es para que a usted le vaya bien en el examen y en futuros trabajos de diseño. SIEMPRE está dispuesto a ayudar y a mostrarle cómo se hacen las cosas.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2023-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'e669a99af402b8784f31015e0871ae151343bba859ba8da1e49c34e5f4a2da4f'::TEXT, ARRAY[1847]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, '4ec0cb7465c7ad033bb826e5a552ae37a079041ee424f4189fc7cfee2d42846f'::TEXT, ARRAY[1847]::BIGINT[]),
    (615::BIGINT, 'Nunca se tome personal la retroalimentación que le dé porque es de los pocos profes que de verdad se preocupa porque usted mejore. Siempre te reconoce el esfuerzo pero califica duro (nada del otro mundo). Si de verdad quiere aprender, matricule con él.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, '31ed7893967bacb12f71b20623ddfd70e6a0ab9101bd1a1a57962eed90e0d37b'::TEXT, ARRAY[1847]::BIGINT[]),
    (615::BIGINT, 'Excelente profe. Se ve que le apasiona el diseño industrial. Hace de todo para ayudar a los estudiantes. Califica un poco duro, pero nada muy drástico.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-07T00:00:00+00:00'::TIMESTAMPTZ, '5b8f8bba3930cad96b9d221a3887c977b7d86e44cc967e9183c277c864596df1'::TEXT, ARRAY[1847]::BIGINT[]),
    (615::BIGINT, 'Excelente. Se aprende muchísimo según lo que enseña y da retroalimentación muy buena. De los mejores profes de la escuela, si pueden matricular con él, háganlo. Califica pesado pero sí se puede pasar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-05T00:00:00+00:00'::TIMESTAMPTZ, '0900069968b4b0cbeb78f73e5f257d73b659b5e2920758e518add8ac1a7b55d3'::TEXT, ARRAY[1847]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2021-03-02T00:00:00+00:00'::TIMESTAMPTZ, 'f0e07668111057072c2e75eb104950a9ccc3556b76d6546afbeddb9e24047076'::TEXT, ARRAY[1709]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2019-12-02T00:00:00+00:00'::TIMESTAMPTZ, '452b7a47b2a3dff7a3a3829bcccd24f050726b5426f0e3980057b6032252b0e8'::TEXT, ARRAY[1859]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2019-12-02T00:00:00+00:00'::TIMESTAMPTZ, '9c5657b96b22af3c65d8d2129cc730d356ea97bf053202e38b3ea22f43d3e587'::TEXT, ARRAY[1859]::BIGINT[]),
    (615::BIGINT, 'Es muy buen profesor, se ve que es muy apasionado y le interesa hacer la clase divertida y que uno aprenda pero a veces tiende a evaluar un poco rudo pero deja mucha reatroalimentación'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '1736a4bce0f11949553749e6f86983bb7d2a5054fc0c77e0b822c88f13d0f72c'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Es un muy buen profe. Se nota que le apasiona la materia y que quiere que la aprendamos lo mejor posible. Es muy importante estar llendo a consulta, ahí aclara demasiado pero a veces no estaba cuando decía que iba a estar y no respondía correos. Hay que trabajar mucho, pero se aprende mucho'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-24T00:00:00+00:00'::TIMESTAMPTZ, '155086a70c3d18e292c105339df2743164778d56735ba045e0843d0b386fe206'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Es un buen profe, sólo que califica muy duro. Aún así se aprende bien.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'e22c497f1a86b4903ad08c0f8b176bc4b14ea34da249a2df6b8ec8b1ddb65fe2'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Es un super profe, no dude en matricular con él. Eso sí prepárese para trabajar con el mismo grupo todo el semestre. Choose wisely. Califica duro pero si hace bien los trabajos de fijo pasa.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'b8634db7a05e6ff1e2a6bfd1ffe64edb91196b2605b135729932b48f3b5dd065'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'De los mejores, le apasiona lo que hace y lo que le interesa es que uno de verdad aprenda. Ir a consulta es importante tho.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Exámenes retadores']::TEXT[], '2018-11-30T00:00:00+00:00'::TIMESTAMPTZ, '5da67d9120fc431bc4c94798af6cf9b97674f63da1e7e747168a916ab369ad83'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Excelente profesor, brinda buena retroalimentación y se nota el interés que tiene por la carrera, siempre está dispuesto a brindar su ayuda. Volvería a matricular con él sin duda.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'bc84771b4310694d74b00a31d2116d4be1e147e83fd66670573bd81f8220d32f'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2018-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'a8dffee9df2be28ea36ea1bb534c9ce3cf767a58e8b372c4d6925096aadc00f7'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'f68c4070e0fbe7d030b356eb6fa10fc6e66e6b739ce2d1a62d1ec1fd1e06c54f'::TEXT, ARRAY[1709]::BIGINT[]),
    (615::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-10T00:00:00+00:00'::TIMESTAMPTZ, '02656dce3314667408d30fca99b11083e786c60e43fd58898e095595202b8d58'::TEXT, ARRAY[1845]::BIGINT[]),
    (615::BIGINT, 'Las clases que da son interesantes, a veces le gusta salirse de la rutina y enseñar de una manera diferente. Es comprensivo y respetuoso.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2017-06-14T00:00:00+00:00'::TIMESTAMPTZ, '4d75c8e05a991b5e2642122019408be1744d639f2e6a34e82fab0247b34d87d9'::TEXT, ARRAY[1845]::BIGINT[])
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
