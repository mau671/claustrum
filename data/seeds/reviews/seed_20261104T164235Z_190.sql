-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=190
-- TEC-DATA-META years=2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.839108+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (190::BIGINT, 'Es un profesor que lo inspira a uno a seguir adelante, sus clases se basan en ver aspectos basicos del futbol y aplicarlos en un colectivo o en una actividad. Es bastante comico y se lleva muy bien con los estudiantes. Es un grande.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'b99d3489b2bdc77c391b387f6ed70525742d694314eab63711367a0d36b53c52'::TEXT, ARRAY[585]::BIGINT[]),
    (190::BIGINT, 'Apesar de que el curso fue en verano el profesor siempre fue atento a lo que hacíamos en clase, y brindaba apoyo. Es una clase que se disfruta bastante y se aprende mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'be72f5e038e9d5d537dd27b4c817d02107fad390c12c99bce2d045e5b31c9539'::TEXT, ARRAY[495]::BIGINT[]),
    (190::BIGINT, 'La verdad es un excelente profesor que hace una clase divertida. He de confesar que no soy un fan del baloncesto pero hace la clase muy divertida e integra a todos. Lo súper recomiendo y gran aspecto de hacer un partido al final de la clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2025-01-23T00:00:00+00:00'::TIMESTAMPTZ, '02f476939b91ca52cc0d8b261ac9a6702021d3aa6f0d356879362e65357f6b6e'::TEXT, ARRAY[495]::BIGINT[]),
    (190::BIGINT, 'De los mejores profes del TEC. En Futbol, las clases son sobre algún aspecto futbolístico y al final de las clases dejaba espacio para el colectivo (Mejenga). Un profe muy inspiracional, que hace que uno saque lo mejor de si, no falta alguna que otra regañada jajaja. Matrícule con él sin miedo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-01T00:00:00+00:00'::TIMESTAMPTZ, '7ae6c4993cc95ca8e7c31c6406187e5a9f5e17d10be80f4bc2c665b62cbab906'::TEXT, ARRAY[585]::BIGINT[]),
    (190::BIGINT, 'Él es el entrenador de basket, así que no te extrañes si te habla algo fuerte para ciertas indicaciones. Pero quitando eso, es muy buena gente y te sientes en confianza con la clase, inclusive si no sabes de basket no te juzga. Se siente como una familia cuando llevas con él esta materia.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2024-11-07T00:00:00+00:00'::TIMESTAMPTZ, '47cc3501552b2fa67736b87fc7d67318f9626662e9bc598520e0db8a878eb2eb'::TEXT, ARRAY[495]::BIGINT[]),
    (190::BIGINT, 'Muy buen profesor,si va a meter una deportivia,metala con el. En el caso de futbol I, al final de todas las clases dejaba espacio para jugar.Un profe muy inspiracional,que hace que uno saque lo mejor de si. Matricule con el,dele sin miedo'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2024-10-31T00:00:00+00:00'::TIMESTAMPTZ, '3225bf4eb760cfe22a1ad06a61e495cc94e25b0e5bdad77148fa89a0afac1c3b'::TEXT, ARRAY[585]::BIGINT[]),
    (190::BIGINT, 'El profesor es muy buena nota, lleva la clase con mucha adrenalina y se nota que le apasiona lo que hace. Recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2024-06-13T00:00:00+00:00'::TIMESTAMPTZ, '49d6ffe2d706a9060aff6bf5cdf0ebcbc544124a75af483a473021efb4c99c95'::TEXT, ARRAY[494]::BIGINT[]),
    (190::BIGINT, 'El profesor es muy bueno pero a veces se enoja con la clase. Aparte de eso las rutinas pueden ser bastante pesadas para alguien que no hace ejercicio regularmente, igual es muy satisfactorio terminarlas entonces lo recomiendo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2024-02-05T00:00:00+00:00'::TIMESTAMPTZ, '6a3744b0722d4079fa932009011642baa71eba27a9da434d20fae531c1b584d1'::TEXT, ARRAY[494]::BIGINT[]),
    (190::BIGINT, 'La mayor parte del tiempo es buena nota pero es demasiado intenso y siempre está buscando como bajar puntos. No diría que no matricule con él, pero sepa que el profe es muy pesado muchas veces.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2023-05-26T00:00:00+00:00'::TIMESTAMPTZ, 'fbb6ed20c318ff6db6e5f3112552170c2ebba9241d5bd28e2b716160d2a970b0'::TEXT, ARRAY[493]::BIGINT[]),
    (190::BIGINT, 'Excelente curso, si puede llevarlo no lo dude. Las clases son muy grupales y se ven diferentes deportes a las diferente semanas y se disfruta mucho. No necesita tener súper condición física, pero sí es importante participar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2022-12-15T00:00:00+00:00'::TIMESTAMPTZ, '492a9d1a715807392a0abf68e7aa6baf6ad7285693e887e765405288205e0658'::TEXT, ARRAY[493]::BIGINT[]),
    (190::BIGINT, 'Es muy tuanis, integra a todos los estudiantes y las clases se disfrutan bastante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Brinda apoyo']::TEXT[], '2022-12-12T00:00:00+00:00'::TIMESTAMPTZ, '16f2faca4c1068a32b72f5fe17e6950e69c4e9927015432e791becbd34e4c1d2'::TEXT, ARRAY[493]::BIGINT[]),
    (190::BIGINT, 'Un gran profesor, súper recomendado, siempre busca que los estudiantes se interesen por el deporte y es muy divertido. No dude en matricular con él'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2022-08-15T00:00:00+00:00'::TIMESTAMPTZ, 'a6d4f19f783b19b49186f9a725e35f9d6bc08193ead344fe53dbb2636f5f9897'::TEXT, ARRAY[494]::BIGINT[])
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
