-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=613
-- TEC-DATA-META years=2016,2018,2019,2020,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.136095+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (613::BIGINT, 'Tiene preferencias, explica mal y califica como si enseñara. Como profesora mala, como persona ahí se la juega, yo no la recomiendo pero no hay de otra.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Da crédito extra']::TEXT[], '2026-07-23T00:00:00+00:00'::TIMESTAMPTZ, '71357a534337d0d9ca358297a64b8d9c9034d83953e8edc60808cd3f6ef2cb6d'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Siempre está abierta a contestar dudas y dar apoyo, además que la retroalimentación que brinda es útil, puntual y respetuosa. Da material de apoyo (videos, páginas...) y está abierta a sugerencias de los propios estudiantes para mejorar. Entregue todo a tiempo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2025-11-10T00:00:00+00:00'::TIMESTAMPTZ, '56e50d7ea305db0e5565f610520339e5f632239c3d696d06fa404470c21226a2'::TEXT, ARRAY[1848]::BIGINT[]),
    (613::BIGINT, 'Un buen curso, temas interesantes, se nota que trata de ir mejorando y ajustando detalles del curso cada semestre, un poco inflexible, con errores cuando a fin de cuentas son estudiantes. Como todo, se puede ir mejorando, pero mucho mejor que muchos profesores de la carrera con aires de superioridad'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-09-06T00:00:00+00:00'::TIMESTAMPTZ, 'fca421dfb4d4ca75c9890e7f9cdff87bf8e216d66b9279922e073a6cc8d7a7b8'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Los aspectos de los trabajos no son claros. Se limita a dejar trabajos y no explica nada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2020-12-09T00:00:00+00:00'::TIMESTAMPTZ, '1e1b7fe8e3703a25749d2cdd105db2c440baeab6565f97d3ffe219204779ed42'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Es una excelente profesora! Hay trabajos cada semana y la retroalimentación es muy buena.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, 'e43b3cf0b3323d1908b7521e040a98e69ec7edd1e311b93f4c4ee6ac0e5e7ad6'::TEXT, ARRAY[1848]::BIGINT[]),
    (613::BIGINT, 'Muy buena persona, se aprende mucho de los proyectos aunque sean bastante pesados, hay que trabajar todas las semanas. La retroalimentación que uno recibe no es muy buena, muchas veces solo recibí un ok.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2020-08-07T00:00:00+00:00'::TIMESTAMPTZ, '79fa456bab039dbcb0ee83f88a7b2ababf4d8d6d2de6009a1f5a08aab61c80ed'::TEXT, ARRAY[1848]::BIGINT[]),
    (613::BIGINT, 'No es una buena profesora. Cero tolerancia con los estudiantes.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos']::TEXT[], '2020-05-04T00:00:00+00:00'::TIMESTAMPTZ, '4129e34192e14cfa7fb03fbaa0043a6b8b5d1582edc3d165a4faace11143c662'::TEXT, ARRAY[1860, 1905]::BIGINT[]),
    (613::BIGINT, 'De las profes que más enseñan de la escuela de diseño, definitivamente la profe se prepara y planifica un cronograma súper bien hecho. La clase es dinámica, hace repasos de las lecturas en clase. Es exigente y da buena retroalimentación. En consulta es súper atenta y se preocupa por usted.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-04-29T00:00:00+00:00'::TIMESTAMPTZ, '953a134f0110d1f26dc59b10026d7993154b745f29dbe8a4e6ac747e677a5f75'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2019-12-02T00:00:00+00:00'::TIMESTAMPTZ, '4087cb87e64fa1812ca328d979c5f7d89ca4d6218df6575b1b0d63f2bb14f87f'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Las clases son aburridas, solo lee diapositivas y no es directa al contestar una pregunta, sin embargo los proyectos son interesantes y se aprende a entregar un proyecto bien hecho. Ayuda muchísimo en consulta y es muy buena persona.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos']::TEXT[], '2018-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'c756e7f76eb2347cc098d8ffc1b9fda000d112c8ef49c8d2de64b16467acdeb5'::TEXT, ARRAY[1848]::BIGINT[]),
    (613::BIGINT, 'da la clase leyendo solo la presentación y es un poco confusa. Deja trabajos muy largos en grupo y si no van a consulta no van a salir bien. es buena persona pero muy poco accesible.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'b750693ae5bf8666bf99a44c0bb3afed21c80b8c6664c4ef7c3aa3b896a98cc3'::TEXT, ARRAY[1848]::BIGINT[]),
    (613::BIGINT, 'Muy buena profesora, recomendada para llevar el curso de Diseño 2 con ella. Es de las pocas profesoras que utilizan el TEC digital a como se debería. Siempre muy clara con todo y todo lo que uno necesita saber acerca de cualquier cosa del curso lo puede encontrar en el TEC digital. Muy organizada!'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2018-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'f390062beee2c6f7620179b56278e0e08337b41423fda99ea52678fddb3f5943'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'María del Carmen aprecia muchísimo a quien se esfuerza por pasar. Nunca te va a recibir de malas y es excelente ayudando, nada más comprenda que ella sí respeta su tiempo y solo asista cuando ella abra el espacio.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Da crédito extra']::TEXT[], '2018-06-16T00:00:00+00:00'::TIMESTAMPTZ, '0ec9bddb44ea2255aa04df0d5dd987072dee8fb30691c7146f90a508d756e690'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'tengan cuidado al llegar a los fiscales, pueden ir bien en el curso pero perderlo por la evaluación final. Vaya SIEMPRE a consulta.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo']::TEXT[], '2018-01-18T00:00:00+00:00'::TIMESTAMPTZ, '234129d2d1a9595a8f894036e9298e28f6fb45fef96d3bb29f3351cd6e1d5a7e'::TEXT, ARRAY[1860]::BIGINT[]),
    (613::BIGINT, 'Es de las mejores profe que tiene la escuela de diseño, te escucha, te ayuda y se aprende con ella simplemente es un amor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'ef99f2475ab09bc1041c91c5c7778a876f2b02966d1438d72df024b8fb54e0c2'::TEXT, ARRAY[1865]::BIGINT[]),
    (613::BIGINT, 'La profesora más amable y dulce de la escuela. Aunque lee un poco, es un amor de persona. Deja trabajos muy acorde al curso, califica de manera adecuada y siempre te explica hasta que entendás. Recomendadísimo ir a consulta con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'f6cf988edf1a176b9605fe495865e8f476ba949bdb3e4f3f32ab4d2e191ebfb9'::TEXT, ARRAY[1859, 4724]::BIGINT[])
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
