-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=84
-- TEC-DATA-META years=2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.827271+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (84::BIGINT, 'Si usted no está muy seguro de haber entrado a materiales, lleve intro con él, de fijo va a hacer que le encante la carrera. Las giras, los proyectos y los talleres son demasiado chivas. La clase es larga pero bastante dinámica. En ocasiones está un toque perdido con la organización y las fechas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2026-07-13T00:00:00+00:00'::TIMESTAMPTZ, '2b050681755f0d811ca467608c09cf8b7e7e8c6885f7a6a144dc65a54f700400'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Es un increible profe, al principio del curso le dice que su objetivo es enamorarlo de la carrera y de verdad que lo logra. Las clases son muy dinamicas, se ve una pincelada de toda la carrera y pone proyectos muy chivas, pero tiene que ponerle a hacerlos bien pq si califica duro algunas cosas.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Muchas tareas']::TEXT[], '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ, '54fe2bd6c9d244069b6c2bf0b3e16e9b15e3e877db3015e3f29210a548bb3126'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'El profesor se le nota la pasión por la carrera a través de sus clases, da muchos tips para lo que sigue de la carrera. Es muy amable, bastante accesible a cualquier tipo de dudas sea en hora de consulta o por mensaje. Incluso siendo semana 16 estando cansado da lo mejor de sí para explicar.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2026-06-11T00:00:00+00:00'::TIMESTAMPTZ, '5ebb2548287dc2d22b864b15d05f1e8e0a50ce9ae9b4cef75cbd61302d78221a'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Buen profesor. Disfruta dar clases y que los estudiantes aprendan. Los trabajos son largos pero interesantes. Califica justo. Abierto a negociar fechas de entregas si es necesario.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2026-01-10T00:00:00+00:00'::TIMESTAMPTZ, 'f360765e8e2bbd23f32d50b5970cfc5082e9a4d6d785490569a775b9032b1bd7'::TEXT, ARRAY[2739]::BIGINT[]),
    (84::BIGINT, 'Buena nota David. Sus clases son muy largas y por ende los cursos se pueden volver pesados. Se esfuerza porque el estudiante aprenda. Lo malo es que califica con IA las evaluaciones asincrónicas, lo que puede llegar a perjudicar la nota. Cuando revisa él, califica medio duro-normal. Es muy teórico'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, '43922ab076c74e9333ac478b2c20bbcd0ae9229b7652d2222e0b7fcdf4ce7531'::TEXT, ARRAY[2739]::BIGINT[]),
    (84::BIGINT, 'El profe ama la carrera y se le nota, sabe muchsimo. Los trabajos y las clases no tienen nada que ver, en la clase basicamente se dedica a mencionar cosas chivas de la carrera y ya. Deje de ir a la clase desde inicio de semestre, no importan las clases. Buena nota. Hay que rogarle por instrucciones.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'd7cc6e3abe996f39087a247c2034485b8582496c7c33e6d2e138519f1fe79d79'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Super buena nota el profe, se nota que ama la carrera, siempre responde dudas y es muy flexible con la entrega de trabajos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, '3569fd70c3fb11f13f0f2a55ae84ebaf475442b0175b6753125fa55bb7d20caf'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Es una teja de profe, si puede matricular con él no lo dude, brinda muy buenos ejemplos, no califica duro y hace que la materia no sea tan aburrida'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '2c59866bc019f850dbf90811566797310438fa56810b2096e3e33b299365f806'::TEXT, ARRAY[2748]::BIGINT[]),
    (84::BIGINT, 'El profe es demasiado bueno, se nota que tiene un montón de conocimiento y da un muchos de ejemplos aplicados como en el día a día como ingeniero que para el curso y su ubicación en el plan está super bien, la evaluaciones son sencillas y califica muy normal.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '3389a82c21791cfbafb431ab599ecd61b79c09e41f9a0b9c1820fb8ce014a82c'::TEXT, ARRAY[2748]::BIGINT[]),
    (84::BIGINT, 'Es un excelente profesor, siempre procura llevarse bien con todos los estudiantes. Aunque los cursos pueden ser algo aburridos por la cantidad de material, él siempre intenta hacerlos más entretenidos. Los trabajos suelen ser fáciles y ayuda mucho a los estudiantes.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, '8c1dd7506ab46b2a25b072ecd8a65d69851be610f603550deb4ef8fb9b43e488'::TEXT, ARRAY[2748, 2739]::BIGINT[]),
    (84::BIGINT, 'La verdad es una teja de profesor, además de ser súper comprensivo se encarga de hacer lo posible para que a uno le guste la carrera. Sinceramente no exige mucho al curso y es comprensible respecto a las entregas (daba más tiempo si sabía que teníamos examen de otro curso, para ayudarnos)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'a8d7295b328ef82bcf2327f31083d92ba6467b09aff3fc69df54489d050f3f53'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Cae muy bien, siempre me respondía cuando le escribía y se le nota el amor a la carrera'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '551f495a6cc23c28b6d049c698f03976f67430a4f5b838d1c6fbe7d3bb1a223c'::TEXT, ARRAY[2733]::BIGINT[]),
    (84::BIGINT, 'Super buena nota de profe, se lleva bien con todos los alumnos, trata de meterle emocion a la materia que da por mas aburrida que sea, hace chistes dentro de la clase. Los examenes y quices son faciles'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2025-05-29T00:00:00+00:00'::TIMESTAMPTZ, '586058ba4406be2faa2d42af644d0de5f32c5d83071c5e48bd1bd6cd71eebdcf'::TEXT, ARRAY[2748]::BIGINT[]),
    (84::BIGINT, 'Es un excelente profesor, se nota la cantidad de conocimiento que posee. El curso es sumamente sencillo pero sí laborioso. Brinda retroalimentación pero a mi parecer la forma de calificar no queda del todo clara. De todas formas, lo hace sumamente suave. Totalmente recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'd975dbcdc74f0747a3832266e235ee00e542a428dffc6123daa54c9443450800'::TEXT, ARRAY[938]::BIGINT[]),
    (84::BIGINT, 'Un chuzo como profesor y como persona. Es un profesor primerizo asi que a veces comete errores, pero es demasiado bueno explicando y todo lo demás. se apunta a negociar con la clase cualquier cosa. lo quiero mucho profe!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'ef6bef2ac5ab4194deb2d7e72bb5d75b968e30a69cb3bf42c34cdf84a68e538e'::TEXT, ARRAY[2739]::BIGINT[]),
    (84::BIGINT, 'El curso se pasa fácil con el, los examenes son sencillos y hace quiz todas las semanas'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores', 'Clases largas']::TEXT[], '2023-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'fb69836c4309b18439627975ead25438d6c8b25b44120e2f86ca2b578e014a70'::TEXT, ARRAY[2739]::BIGINT[])
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
