-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=286
-- TEC-DATA-META years=2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.041424+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (286::BIGINT, 'Es una buena opción si quiere adelantar la materia de verano, pero aun así va a ser muy matado, ya que el profe aunque en la revisión no califica duro y perdona muchos puntos, no mide bien el tiempo, pidiendo mucho en poco tiempo. Lo mismo con el examen que era larguísimo.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2025-02-12T00:00:00+00:00'::TIMESTAMPTZ, 'baf095d74f307310b84db9b25072736fca11cf5987de0fe0de44f851f6236b19'::TEXT, ARRAY[1054]::BIGINT[]),
    (286::BIGINT, 'El proyecto no es difícil, siempre y cuando no se dejen las fases para última hora. Las revisiones son largas (40 min ~ 1 h 30 min), pero es porque se toma el tiempo de comprobar todo. No califica duro y da buena retroalimentación.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2024-01-30T00:00:00+00:00'::TIMESTAMPTZ, '2011b3c23c2f36f155f55fb76fcd864e5d056923dce7a7c66b1e0bcc8e3f036e'::TEXT, ARRAY[1054]::BIGINT[]),
    (286::BIGINT, 'El curso es duro, hay muchas asignaciones, no dejes los proyectos para lo ultimo y no subestimes el valor de las tareas (hazlas). Sino entiendes algo el profe siempre esta dispuesto a ayudarte y valora mucho el interés y esfuerzo. Los proyectos son largos pero se aprende mucho de estos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Da crédito extra']::TEXT[], '2023-02-02T00:00:00+00:00'::TIMESTAMPTZ, '531c2348feca125813a6eda3edd0e59acde04994ad161634ba6a15e8aef1c01b'::TEXT, ARRAY[1045]::BIGINT[]),
    (286::BIGINT, 'Como el 90% de profesores de Limón, no lleve con él. El curso lo da con presentaciones que no son ni de él. Solo habla de teoria y de vez en cuando se encarga de medio explicar codigo que a veces ni le compila. Segun el se hace el bueno haciendo lo proyectos "Faciles" pero son esclavizantes.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2022-09-30T00:00:00+00:00'::TIMESTAMPTZ, 'a8fc24f4e4bd81b493bb1920803aaf2fda4e66434057ce37e534f27feb9dee28'::TEXT, ARRAY[1045]::BIGINT[]),
    (286::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, '42f9b7571c700c0ff797740cb5c901d944bf787c8efc3173555702f390a8b463'::TEXT, ARRAY[1037]::BIGINT[]),
    (286::BIGINT, 'Un curso de 4 créditos que parece de 12. Se puede llevar solo este curso en todo el semestre y aún así les va a costar. El profesor hace que el curso sea sumamente esclavizante por todos los trabajos que deja todas las semanas. Hay que sacrificar otros cursos para aprobar este. No lo lleven con él.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-11-29T00:00:00+00:00'::TIMESTAMPTZ, '948f5781cc316418fd2407ba1125118f11a5952c1fa340d33a19cf6f3851f04c'::TEXT, ARRAY[1037]::BIGINT[]),
    (286::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-09-14T00:00:00+00:00'::TIMESTAMPTZ, '6eef44828dd5682c53dbb2c05cc78c2a25bce90a02cca8032b50052454efcd5c'::TEXT, ARRAY[1037]::BIGINT[]),
    (286::BIGINT, 'Se apega al cronograma del curso y a las evaluaciones. Las calificaciones siempre están actualizadas. Diría que la carga es razonable. El profesor es bastante amable y siempre está dispuesto a despejar dudas.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-07-23T00:00:00+00:00'::TIMESTAMPTZ, '010dce393cfaa47da1bbae69534e7ac7f9587bf1c225e5fcb5201a2f800cdf4c'::TEXT, ARRAY[1054]::BIGINT[]),
    (286::BIGINT, 'Buen profesor, los trabajos suelen ser muy largos y muchos quices pero si se le pone bonito con los proyectos y demás si se pasa. No dejarlos para último. Da crédito extra con las entregas y eso ayuda mucho.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da crédito extra', 'Deja trabajos largos']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, '32368694e09e744193b31ba3cdbe15297849adaac43a2d5227dfd24087222287'::TEXT, ARRAY[1054]::BIGINT[]),
    (286::BIGINT, 'Trabajos excesivamente largos que valen poco porcentaje de la nota. Se aprende bastante y es facil pasar por la manera en la que estructura el curso, pero hay que estar listo para llevar un curso de 18 creditos.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-03T00:00:00+00:00'::TIMESTAMPTZ, '06b1fd91054d3964e725838a827ecb69f59a3b43d50972754b41da494d85995c'::TEXT, ARRAY[1045]::BIGINT[]),
    (286::BIGINT, 'Las deficiencias que tiene el profesor no caben aquí sinceramente, en resúmen los proyectos y asignaciones que asigna no se ve que le toma importancia al tiempo que se toma en desarrollarlo, algo que tristemente veo muy seguido en el TEC y además los enunciados son un copy paste de hace 7 años.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2021-01-30T00:00:00+00:00'::TIMESTAMPTZ, '9d8beb09e855ab803bdb373f9073b74d1f20ef9c57bc3c80e47f920eae077f5a'::TEXT, ARRAY[1045]::BIGINT[]),
    (286::BIGINT, 'Quiz fijo en cada clase, pero aclara muchas dudas, si usted realmente le demuestra interés por el curso el es felíz en aclararle y darle consejos de como mejorar en ciertas cosas los algoritmos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2021-01-22T00:00:00+00:00'::TIMESTAMPTZ, '1cdc75935f4ebc5cd61d5dd87af3084f70f713c9bcb0d2464ab2d954569ff816'::TEXT, ARRAY[2677, 1249, 3555, 1250, 1721]::BIGINT[]),
    (286::BIGINT, 'Cada clase hay quiz, deja proyectos muy largos y con enunciados ambiguos que dificilmente si le preguntas, te responda. Lo inunda de tares "cortas", casos y proyectos. Si lleva el curso, asuma que es de 8 creditos (muy difícil).'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2020-12-26T00:00:00+00:00'::TIMESTAMPTZ, '708c7fc528594f893d7d0aba47b1ea5d59bd4999141d5063ab12f78932552c83'::TEXT, ARRAY[1037]::BIGINT[])
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
