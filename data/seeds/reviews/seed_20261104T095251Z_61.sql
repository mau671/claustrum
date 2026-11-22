-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=61
-- TEC-DATA-META years=2014,2015,2017,2019,2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.479887+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (61::BIGINT, 'Creo que es la profesora mas vaga que he conocido en en el TEC, siempre habla de su viaje a USA como si a uno le importara, no lleven sus clases son un completo bostezo y no se aprende nada'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ, '76cb2c97cb2e66715ffe8407bb636193cfd9d24737b2717ec4afebf09780b765'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Una profesora muy vaga, no se le entiende nada, no se como la escuela de administración todavía la tiene como profesora, ya que a todas las evaluaciones les pone 100 y nÍ las lee'::TEXT, 10.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2026-01-07T00:00:00+00:00'::TIMESTAMPTZ, 'cd575a8cdc29e8703ad318dfa916f5aef76ff4e60b2079b3c9ad6c7c200b7367'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'De mi parte no le lograba entender nada si no leía el capítulo del libro, ni siquiera leyendo el resumen que ella sube. Las clases son ella leyendo la diapositivas de una presentación. Tiende a ser grosera con las preguntas, los compañeros terminan por no preguntar nada. Las tareas siempre pone 100'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'b458d32e57b13a3cfb87888837669871229ba7b93ae773e1791c27095094726f'::TEXT, ARRAY[2371]::BIGINT[]),
    (61::BIGINT, 'Una profesora muy ofensiva, el curso se pasa solo pero sus clases son demasiado aburridas'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2025-11-05T00:00:00+00:00'::TIMESTAMPTZ, 'ecbcc08b8565e21f8a10251cf50c7f8267ef36a5a06a74cbb19fd211192a9108'::TEXT, ARRAY[2396]::BIGINT[]),
    (61::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Exámenes retadores']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'c0d5270f4c1b1de7ca80a798bed39ebfbfd43d0ed91bce94bfa2b932898927d9'::TEXT, ARRAY[2396]::BIGINT[]),
    (61::BIGINT, 'Muy pura vida. Conoce mucho sobre el tema y trata super bien a los estudiantes'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-04-06T00:00:00+00:00'::TIMESTAMPTZ, 'b1cdf53a7cd5c294ed2716cebec352b0ff45e88bd1a34d5fdbe74bc5ca576f2e'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Es muy amable pero lamentablemente se aprende muy poco de negocios. Es un poco "bateadora" y se desvía demasiado de los temas con sus anécdotas desactualizados. Califica los trabajos muy muy fácil, pero los exámenes son muy específicos. Estudien del libro.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, '1aef73aba7c9076c18341ece6cf498756ee09b68cdc07f723b74de3d512a9294'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'No se aprende mucho de Negocios. La profe es buena gente. Los exámenes difíciles porque son muy específicos pero son iguales a exámenes pasados.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-06-08T00:00:00+00:00'::TIMESTAMPTZ, '17b48c388cff35c714bd596c4eba4d930fd0efab25e27b3da2bad54c60a024e8'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Los exámenes se pasan leyendo muy bien el libro porque a veces pregunta cosas muy detalladas. Busque exámenes viejos y pasa bien. Cuenta muchas anécdotas personales pero es demasiado buena gente. No deja tantas tareas pero hay que hacer un ensayo de un libro y exponer individualmente.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-04-18T00:00:00+00:00'::TIMESTAMPTZ, 'acc998bcabe2b52071072995974bab74efa2ddebd5d27e68f68cb1b9e6b6ad1a'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Los demás comentarios no mienten, preparate para conocer toda la vida de la profe y cero sobre negocios internacionales. Si la ignorás o trabajás en la computadora en clase, puede molestarse, pero no habla casi nada de las clases. Los exámenes son los mismos de años pasados.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Requiere mucha lectura']::TEXT[], '2019-03-31T00:00:00+00:00'::TIMESTAMPTZ, 'ddcbff0ea7aed483a42e582fab7eb3f315096a4d9591078ec4595096670d284b'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'La profe es buena nota y no califica duro pero no se aprende nada y solo habla de su vida y estudios en Estados. Busque los examenes viejos y pasa.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-03T00:00:00+00:00'::TIMESTAMPTZ, '7dfd1313b67f9252f1549c6b050e22ff440e1d8ba9909ccfeec2e69b94d76096'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Solo lee diapositivas y no de aprende nada, los examenes son medio dificiles, pero pasables, ayuda mucho y es buena nota'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-09T00:00:00+00:00'::TIMESTAMPTZ, '8fe7789e08c2819bd1f9396de46aaab578cb7699bb991239babb0385ea06e2bb'::TEXT, ARRAY[2451]::BIGINT[]),
    (61::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, '77236b866c58a1791a3d8927b7a756d199e747a1ba732b9a34650c9088edcd02'::TEXT, ARRAY[2371]::BIGINT[]),
    (61::BIGINT, 'Media clase se va a dedicar a contar sobre su vida en la universidad que estuvo en Estados Unidos y Europa.Si le gusta perder el tiempo en clases es ideal. Exámenes medianamente complicados, pero se le entiende y ayuda bastante si es requerido.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'c98fea99b3345a4f01aaefb0bda3374251e7e5f04244854e69a651c36c0f65b7'::TEXT, ARRAY[2371]::BIGINT[])
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
