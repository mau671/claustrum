-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=308
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:26:57.355312+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (308::BIGINT, 'El profesor realmente no sabe la materia que imparte, lo cual se nota con sus exámenes y proyectos hechos en ChatGPT. La cantidad de trabajo que deja es exagerada por un curso donde todos los demás profesores hacen que parezca un curso de un crédito. Evitar a toda costa si va a llevar cursos pesados'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-11-21T00:00:00+00:00'::TIMESTAMPTZ, '2160d7cc86a394ea8fc79641c2675cf3303f38389ccdb305abc0fe1a4ef77eb6'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'Excelente profesor. Alto nivel. Ayuda mucho hacer trabajos pequeños en forma constante. Mezcla clases invertidas con normales(reiteración) y eso ayuda mucho para enfrentar los retos. Realmente si uno se esfuerza en cumplir con lo solicitado el curso se hace facil para aprender y pasar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-08-13T00:00:00+00:00'::TIMESTAMPTZ, 'a7f65a417bd818d3ae032ee1ebd57c3ecbf7c43aaae7ab46183c50ffa4700383'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'El curso es pesado deja minimo 2 trabajos por semana. Algo bueno es que atrasa las fecha de entrega, lo malo es que le va a dejar todos los proyectos en el último mes. Cabe decir que el NO DA EL CURSO CON POO.'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores']::TEXT[], '2026-07-09T00:00:00+00:00'::TIMESTAMPTZ, '244d2afad26c2d032b78355e6ed3efebe80b233b81002f743e0a2b7be02580a7'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'El curso es muy pesado, deja un resumen de un video largo y un laboratorio en tríos cada semana, no es algo largo pero si es cansado, si tiene un buen grupo pasa fácil. Solo deja un proyecto pesado y los otros son fáciles, los exámenes son un asco y muy largos, da mucho tiempo para las varas'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2026-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'e4f04beda3d52544d4f03411226d12c86638e4f754fa5cf4a58207fe565cfb60'::TEXT, ARRAY[1029]::BIGINT[]),
    (308::BIGINT, 'Te hace perder el tiempo a más no poder, da por sentado todo y se enreda solo. El trabaja como si no hubiera más materias, es un desordenado con cómo manda las cosas, es muy necio con que le pongan atención por más que hable pura papaya. Es una carga más que una ayuda, solo complica el semestre.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2026-03-29T00:00:00+00:00'::TIMESTAMPTZ, '8639ebabeed24be2f0c926a3e50bf109126fd25ad8f8f68e68fbc88f4aed7df7'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'Usa el formato de aula invertida (ver videos antes y luego en la clase pasa a explicar) en general da mucho tiempo extra lo cual se agradece y califica suave pero justo los exámenes son difíciles pero si pone atención en clase los pasa fácil si tiene un buen grupo de trabajo todo pasa bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-02-09T00:00:00+00:00'::TIMESTAMPTZ, '2f2845044ea278dfaf4eab7612cdd0dcd0fb8571e346e3cf86fc436d576daac1'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'Si usted le pone desde el inicio con este profesor pasas si o si, explica bien la materia, y las clases son pura aula invertida, la unica parte que no me gusta de este profesor es que usa el correo electronico como "portal del curso" cuando tiene a disposición el Tec digital.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2026-02-04T00:00:00+00:00'::TIMESTAMPTZ, '50acdc665121dd32fb83e2127eca080c109500f959040885091dc9310260774e'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'El formato es aula invertida. Muy buen profe, explica súper bien todos los temas y premia a la gente que le pone más. Las evaluaciones son bastante logrables. Por mucho la mejor opción para el curso.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Da crédito extra']::TEXT[], '2026-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'a1a4dbd02a866c0e687389814c42401009e93a11256a9a0e538a6ab9208ca595'::TEXT, ARRAY[1253]::BIGINT[]),
    (308::BIGINT, 'Víctor es un profe muy necio, pasa hablando pura papaya, a veces hasta cae mal, pero se aprende bastante en realidad a lo largo del curso y es demasiado fácil pasar su materia, las tareas y los exámenes son un queque. Probalemente volvería a matricular con él'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2026-01-31T00:00:00+00:00'::TIMESTAMPTZ, '8f737a530a326b524523dec19e6ac6a3a970ca56990788119a1377f9f10e2803'::TEXT, ARRAY[1029]::BIGINT[]),
    (308::BIGINT, 'El formato de la clase es aula invertida entonces se pueden repetir los videos las veces que uno quiera, deja laboratorios y resumenes semanales que valen gran porcentaje de la nota, los examenes que hace son faciles y alguno de los proyectos son largos pero da mucho tiempo, ademas se aprende mucho'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2026-01-20T00:00:00+00:00'::TIMESTAMPTZ, '8d1c5ecd9a4eb21ad3c92d4c4d93d8d61420070a237fd720b3908ba26c3004a4'::TEXT, ARRAY[1029]::BIGINT[])
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
