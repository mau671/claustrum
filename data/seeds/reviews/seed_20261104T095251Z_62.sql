-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=62
-- TEC-DATA-META years=2019,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.480551+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (62::BIGINT, 'Con este profesor un curso que es de 4 créditos se siente como de 1 crédito. Deja bastantes tareas pero bastante cortas y sencillas. A veces da indicaciones un poco confusas para los exámenes y proyecto final, pero las evaluaciones son muy sencillas y se pasa fácil.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-07T00:00:00+00:00'::TIMESTAMPTZ, '96a9dd5842fe6e750ab5b03eba760331b64c00f779221b7a33793275627ebd3d'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'Puso de asistente a alguien que ni había llevado el curso aun y nos calificó los exámenes :( No apeló nada aunque tuviera la prueba. No revisó los avances hasta literal 2 días antes de la entrega del PF y por eso no dio retroalimentación de ninguna. Sabe mucho de los temas, pero no bueno evaluando.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '404fb2e4906a4f34f8f06e41fef6ca5f1af1ec21df252dede6a887fa866bfe52'::TEXT, ARRAY[1883]::BIGINT[]),
    (62::BIGINT, 'Excelente profesor, es muy pura vida. Las clases son largas. Muchos trabajos, pero para nada difíciles'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-04T00:00:00+00:00'::TIMESTAMPTZ, '557150cc500cf30ae91887afa24a092772691e9573abd3c7c66b46fec90c68ac'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'El profe Diego es excelente, sabe demasiado del tema y se ve que disfruta lo que hace porque hace las clases muy amenas, aunque son algo largas. Es un poco desordenado con las fechas, por lo que hay que estar al pendiente de eso. Pese a eso, tomaría la clase con él indudablemente.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '3d97f422b3ba3f70d48c44f2770db56a243edc473780dcf6c6acbc3c98145032'::TEXT, ARRAY[1883]::BIGINT[]),
    (62::BIGINT, 'El profesor es muy respetuoso, amable y pura vida. Tiene mucho conocimiento del mercadeo. Se pasa muy fácil con él, pero las clases son largas y no se le entiende mucho porque se traba al hablar. No explica claramente el proyecto así que sean intensos con eso. Por lo demás, es un buen profesor.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-22T00:00:00+00:00'::TIMESTAMPTZ, '4343d870702b4d6f7b5be58be76323de225f03b749d56cef3daf5408ac7adfc6'::TEXT, ARRAY[3438]::BIGINT[]),
    (62::BIGINT, 'No es claro con las fechas de las evaluaciones y lo que desea en ellas, sin embargo, además de eso el curso se hace bastante sencillo con él, dado que las evaluaciones son sencillas y califica amigablemente.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'a89ad8c65840e7db2ee269b22eae8d096569f927c883f1f680fd066be23c23a3'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'Buena persona, explica bien, le interesa la materia. algunas veces se confunde con fechas y hay que consultarle. En general es bastante accesible.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '9bf37b8ce9d293c711caebb3200949cdf969caac0e5ac43d2e851caa9cbefe54'::TEXT, ARRAY[1883]::BIGINT[]),
    (62::BIGINT, 'No sabe dar instrucciones claras sobre los trabajos, las fechas son confusas ya que en los documentos sale una fecha y él dice otra entonces se le debe preguntar por correo.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2022-03-09T00:00:00+00:00'::TIMESTAMPTZ, 'b283a7be0c4247606c82337cb75c0512a0c508ed2d8503a5ac7de741e710f21a'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'Curso muy fácil. Hubo 3 cosas grandes: 1. un examen que estaba sencillo 2. una actividad de vender algo por el TEC 3. Un "proyecto" donde se imagina un producto innovador y se le aplica el proceso de investigación de mercados (varias semanas). Hay unas cuantas tareas muy fáciles.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[], '2019-07-15T00:00:00+00:00'::TIMESTAMPTZ, '30bfda72700409fcb2f81c0d1ab8ace98f8050fe3931738e428a3403cab018b4'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'El profe es muy buena gente, va a aprender bastante en el curso, eso si hay que hacer muchos trabajos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'La participación importa']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, '3ed41183a0789a78d695558261235b96f9235f8b8f8e006ff18981b3a8180d62'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'Buen profesor, le da una dificultad al curso adecuada.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2019-05-22T00:00:00+00:00'::TIMESTAMPTZ, 'f87faca17da96ff17ca790f4063c7b886c7c9b4bcd3cff85efe4bfafd8a1be86'::TEXT, ARRAY[965]::BIGINT[]),
    (62::BIGINT, 'El profesor que cualquiera espera en verano, enseña la materia como corresponde sin agregarle ningún tipo de complejidad al curso, realiza muchas actividades y las 4h se pasan rápido'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-17T00:00:00+00:00'::TIMESTAMPTZ, '84b48bfc4e3e6b5883855408d8c08f3ce8a196f85581a5296487ddac956cbef5'::TEXT, ARRAY[965]::BIGINT[])
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
