-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=611
-- TEC-DATA-META years=2019,2020,2021,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.453281+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (611::BIGINT, 'No sabe ni de que está hablando, es el profesor más obsoleto de la escuela, no sabe ni donde está parado, mansplainea a más no poder, las cosas las califica cada mil años, debería pensionarse pero dice que no quiere'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-11-10T00:00:00+00:00'::TIMESTAMPTZ, 'e4f9f3abfdbaad60b855e46da4896277ca1148ec34926a888074c5dc12968de2'::TEXT, ARRAY[1845]::BIGINT[]),
    (611::BIGINT, 'No se aprende nada, trae 5 diapositivas y las lee (y se equivoca leyendo), el resto de la clase habla pura paja. No se sabe qué quiere, califica injusto y cuando uno le pregunta algo termina más enredado. No daba esa clase hace 6 años y se nota. Interrumpe y es machista. 0% recomendado, pensiónese.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2025-11-10T00:00:00+00:00'::TIMESTAMPTZ, 'a64b69350ef2516d906c81ca3ee7e98365c8858c98a77071184bac3cb60be86b'::TEXT, ARRAY[1845]::BIGINT[]),
    (611::BIGINT, 'Es un excelente profesor, la materia es super aburrida sin embargo es la naturaleza del curso, el profe puede ser un poco terco pero es gracioso, sabe muy bien sobre como funciona los procesos en la industria realmente, aunque si debería de hacer las clases mas practicas que teóricas'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'La participación importa']::TEXT[], '2025-10-22T00:00:00+00:00'::TIMESTAMPTZ, '975d3eba1c44cb03c9ffd08171cb8362d990cc31b0c3c61c587a1c451245f2a4'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'El profesor más deficiente de Diseño, un "Diseñador Industrial" que su experiencia es creer que sabe de lo que habla y no aplicarlo en el mundo laboral, solo lee diapositivas y le pide a los compañeros del taller que den su curso porque cada semestre se le olvida como usar las máquinas.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-09-06T00:00:00+00:00'::TIMESTAMPTZ, '4b14b66d7217458464c6a2a8749169174f27a9bc2a38f7e181a6e211590603e6'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'Sus clases son verlo leer las diaposutivas y da instrucciones para trabajos las cuales despues dice que no tienen que seguir, califica muy duro para explicar tan mal y hace que la participacion en clase sea una tortura. Parece que quiere quedar a todos'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura']::TEXT[], '2025-07-12T00:00:00+00:00'::TIMESTAMPTZ, 'dd20ca04307f3d5927a8bcf90e63f34a0ad221cd03622e58602b8648b1c369f8'::TEXT, ARRAY[1845]::BIGINT[]),
    (611::BIGINT, 'El curso en sí es muy aburrido, por ratos es un poco cómico, pero hay que tener cuidado con él. Depende mucho de si está de buen humor o no'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'aa487e6fb39e7a737bc560205974e1e828d55fa638ee128b0eed2bafc083d283'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'No lo recomiendo para nada, sus clases son super aburridas, no se aprende nada y solo lee las presentaciones sin que se le entienda nada. Con las evaluaciones es un desorden y ni siquiera él sabe cuando es la entrega. Y si se le pregunta algo nunca responde y solo recalca que el estudiante está mal'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-30T00:00:00+00:00'::TIMESTAMPTZ, 'd354f88b71f7b16c2d9db206fde5d92c153b14efe4bf45366dce7062bf670195'::TEXT, ARRAY[1845]::BIGINT[]),
    (611::BIGINT, 'Este compa se pone a hablar paja cada vez que explica, dura como 30 minutos por diapositiva, no explia nada solo lee las presentaciones, dura mil años para contestar mensajes, y me recontra caga cuando se pone a chupar esa botella para tomar agua (eso ultimo no es relevante pero lo queria poner)'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-13T00:00:00+00:00'::TIMESTAMPTZ, 'd050ddf6f1a8059db577090b354c244d097cc499388b5a75a23d2a38ab99eee9'::TEXT, ARRAY[1845]::BIGINT[]),
    (611::BIGINT, 'Las respuestas a las dudas son muy ambiguas. Nunca responde directamente. La clases son sumamente aburridas y los trabajos largos, con instrucciones confusas.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'eedc5a95ca17c62713d1e1db06aed646888a1f03f78090edf0c288a0a441495b'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'Clases aburridas y largas. Deja demasiados trabajos extensos'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2021-08-24T00:00:00+00:00'::TIMESTAMPTZ, '6ff0d75922be252bf276c8c20ea6e9a0aa2e1fa23323c9958834f41b155fe20c'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'Las clases son súper largas y utiliza lenguaje súper estandarizado, los trabajos son brutalmente largos, pero da súper buena consulta y es abierto a cambios. La materia en sí es pesada.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2021-01-26T00:00:00+00:00'::TIMESTAMPTZ, '04dced78d39210cb4319595ee1ff320d541e10e8013d92084cf22bef8d6638fc'::TEXT, ARRAY[1869]::BIGINT[]),
    (611::BIGINT, 'Las clases son muy largas y aburridas. Interrumpe a los estudiantes cuando están hablando. No permite que las mujeres utilicen las herramientas en el taller.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2020-12-19T00:00:00+00:00'::TIMESTAMPTZ, '7edb8c4fa0c1c8c2b8e766f5759d73b35b9a0fbc41be028974e8efd97e2b2984'::TEXT, ARRAY[1869, 1868]::BIGINT[]),
    (611::BIGINT, 'Prepárese para unas clases teóricas algo aburridas pero en donde va a aprender mucho sobre como usar los materiales y herramientas. Con Mario se aprende fuera de la clase normal, es una persona dispuesta a ayudarlo en lo que necesite, eso sí, ayude mucho en el taller.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2019-01-17T00:00:00+00:00'::TIMESTAMPTZ, 'ca335ab8db9c3be0bd829513885a430263cba5e44a6596e14734633aba341d2b'::TEXT, ARRAY[1869]::BIGINT[])
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
