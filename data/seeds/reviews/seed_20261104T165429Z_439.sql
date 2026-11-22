-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=439
-- TEC-DATA-META years=2017,2018,2019,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.226775+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (439::BIGINT, 'muy chill, se pasa fácil'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '8bae017d6b294c84e88bbfe2100bbcec1dd09364aaa497e4ed3fb6a0c95b5e97'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Es un ambiente bonito en la clase. La verdad no se hace mucho, si tiene cosas viejas es muy útil. Se trabaja en grupo desde la primera clase, entonces es bueno tener un buen equipo. Siempre llega tarde'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2026-01-11T00:00:00+00:00'::TIMESTAMPTZ, 'f52db40b3edd669ce4357f5656477576179c269e2ce012471600a3933f075e25'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Increible, regala llaves mayas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2025-03-18T00:00:00+00:00'::TIMESTAMPTZ, 'd974e67d88c64bfce1c346f1303f5cfe8729c4766c073bbac57325c21a266a0d'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Muy ligero, si va dejando bretes pero es como cada 4 semanas. En semana 15-17 se entrega todo, entonces si acomodar esas semanas para tener que dedicarle bastante tiempo. A todo le pone 80 o 90, pero se pasa al final entonces promete'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-23T00:00:00+00:00'::TIMESTAMPTZ, '2f2b96311139ae46882463763ef7bc7ed5a3f1bcf6a6d022f702d70244a86010'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Curso aburrido pero la profe es una teja'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-01T00:00:00+00:00'::TIMESTAMPTZ, 'af9b92afcb77ae731ad2d9eb6bcb6a62777111ac83685cbd961a8f7a7433caf3'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'la materia es teórica, pero intenta que la clase sea interactiva. Tareas y exámenes súper fáciles, sí hay que dedicarle tiempo el proyecto pero nada del otro mundo. Casi nunca toma asistencia.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'dee7c9178370990cc3a7d29a596903fca5fa7ad0c5042b74846ca17eae3764a0'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Las tareas y los exámenes son muy fáciles. La profe es buena gente y hace la clase interactiva. El proyecto si pide algo más elaborado, pero nada del otro mundo. En si la materia del curso es teórica por lo que es muy facil'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Clases excelentes']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '5628dfc8acd1c2559d42fe38909f00d9ebbb3c12b59d411646bafa1c22456002'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Es fácil pasar, deja demasiadas tareas que igual son fáciles, califica con lupa los exámenes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-15T00:00:00+00:00'::TIMESTAMPTZ, '071323646020451629bee8e5f5bf222cc61565603093133fb9310820f1e5fe09'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'La materia es demasiado fácil y las tareas igual. Se pasa fácil pero no con 100 porque la profe califica cada detalle. Es muy amable'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2022-06-14T00:00:00+00:00'::TIMESTAMPTZ, '20edb5497fe71f562bace5a88bfa2bbc07888d446335ef1145eb1581e7e28b07'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Es sencillo de pasar con ella, pero en general, y con cualquier profe, no creo que el curso se pueda considerar como complicado.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-11T00:00:00+00:00'::TIMESTAMPTZ, '5d4b01e1ea4ca51780355cb2bdd680bb9958711bdbb2314ee2f0f8a491f27bf9'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'La profe es muy buena gente y lleva a la clase profesionales de la carrera que se especializan en cosas relacionadas a SI y IoT. Deja bastantes trabajos pequeños, y el trabajo final es una progra de algo relacionado a sistemas de información, pero nada difícil.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2021-12-03T00:00:00+00:00'::TIMESTAMPTZ, '120fcb88695e663da5c9d6961bab719d307e8ed96d08b5888e3e6349ff3f2eb9'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, '(virtual) Curso muy teórico, es bastante fácil, la profe es super linda, deja pocas tareas y sencillas. La profe lo pone a uno a participar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Pocos exámenes']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, 'e188a997c5802f157e74565e57de9c61f05377fa6a25f7dd95c6b437272fbcc1'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Es muy teórico, hay veces que no hay que ir porque es virtual. Los exámenes son virtuales (pero da muy poco tiempo para hacerlo). Hay un proyecto final de programar un sistema de información, pero no se ve nada de programar. Es tan fácil que no se ve mucho sentido a que exista el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-21T00:00:00+00:00'::TIMESTAMPTZ, '43d917958eb8048ab8a40069a262e6b10e944906b50f5ab1d74c87d9b19aa21d'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'El curso es muy fácil, se hace un proyecto programado. La profe es amable'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2019-02-06T00:00:00+00:00'::TIMESTAMPTZ, 'c27b761f1ea7fff6881114722d4114801f9a1192992ae4fdd7c0af68ab65d2de'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'La verdad el curso en sí es un chiste entonces mejor llevarlo con ella para que no sea pesado. Ella es muy amable y clases de semana de por medio, para sistemas sí la recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2019-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'c8541948abbcd0edcde8d629666e2cf481597c5e6202bf40c6fcb10c7087e12b'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Este curso no debería existir, es una pérdida de tiempo. No se aprende absolutamente nada. Muchas de las clases son virtuales. La profe es amable pero este curso es demasiado fácil y aburrido. Al final hay que entregar un proyecto programado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Pocos exámenes', 'Aspectos de calificación claros']::TEXT[], '2018-06-18T00:00:00+00:00'::TIMESTAMPTZ, '82a7044286b6c83ec02c89b93b0bd3b0d863c21130bf7c162a7b34240f89599c'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'No sé ni cual es la materia que se ve en el curso... Es como si me lo hubieran regalado. Pasé con 80 !'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-24T00:00:00+00:00'::TIMESTAMPTZ, '19238e2c7612e426e854312d7bddb2a7f32eb897ce8e656969fa435ed8cbdebd'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'Una cochinada, no se aprende nada, la profe diay ahi media rara, clases de por medio, mucha vagancia todo para la casa! muy fácil pero no se aprende nada, si hay otra opción meta con otro profe aunque sea más duro! porque con ella no lo vale...'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-04T00:00:00+00:00'::TIMESTAMPTZ, '4a002e773fd64e0224041627137097bd8255dbfb77460713b3b1854832186be7'::TEXT, ARRAY[1749]::BIGINT[]),
    (439::BIGINT, 'La mayoría de clases son virtuales y es súper fácil el curso. En el proyecto sí califica bastante rudo aunque uno nunca ve nada de programación.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'c453697b020a871ec341f6da91c75d95de0316084c498f34359b55b83bcffea9'::TEXT, ARRAY[1749]::BIGINT[])
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
