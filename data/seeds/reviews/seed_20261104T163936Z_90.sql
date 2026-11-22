-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=90
-- TEC-DATA-META years=2014,2015,2016,2017,2021,2022,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.308464+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (90::BIGINT, 'jueputa yo no entiendo como este mae tiene 8.0 de calificación en esta página JAJAJAJAJ. Honestamente pésimo mae, malísimo, el mae es en sí estúpidamente aburrido, tiene un ego altísimo, que es esa picha de poner las presentaciones en inglés? no explica ni mierda, diría más pero la página no me deja'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas']::TEXT[], '2026-09-22T00:00:00+00:00'::TIMESTAMPTZ, '9397fc1199117ef8c03cf68937bb3affa354c5bf866170821ab9d97921103f2c'::TEXT, ARRAY[968]::BIGINT[]),
    (90::BIGINT, 'Lleve los cursos de termo con él. Da el programa del curso que se tiene que dar porque así lo requiere lo procesos de acreditación. Los quices los avisa y cubren la materia tal y como lo dice el reglamento. Los que se quejan son los que salen mal y quieren que les regalen el curso.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2022-10-15T00:00:00+00:00'::TIMESTAMPTZ, '3a3076c61e668d8115dde334232837a48e0f2681a59e844b54e96f5e599e9066'::TEXT, ARRAY[949]::BIGINT[]),
    (90::BIGINT, 'Complicado como profesor y como persona, tiene mucho conocimiento pero no sabe transmitirlo a los estudiantes y esta desactualizado, además se comporta como un niño en las clases.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Aspectos de calificación claros', 'Exámenes retadores']::TEXT[], '2022-08-11T00:00:00+00:00'::TIMESTAMPTZ, 'e9f057b5db109ab2104805622c473010c034856eb8b62558426ca66b7f7f3fe9'::TEXT, ARRAY[949]::BIGINT[]),
    (90::BIGINT, 'Complicado entenderle, suele hacer malas caras a los estudiantes en algunas dudas y no tenia buena relación con el grupo en general.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2021-06-28T00:00:00+00:00'::TIMESTAMPTZ, '2be7377e84b5652605a4d6f36cef1ea9053030b6b219ff3e67047f863dccac40'::TEXT, ARRAY[949]::BIGINT[]),
    (90::BIGINT, 'Excelente profesor, he llevado 5 cursos de mi vida con el, desde Termodinámica, termodinámica de los materiales, materiales 3, métodos numéricos y fenómenos de transporte 1, si pudiera llevar mas cursos con el lo haría, explica muy bien ya que esta muy interesado a que el estudiante aprenda.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-11T00:00:00+00:00'::TIMESTAMPTZ, 'cf0e1fceb5bdec078d9e48522a00dc433f554432c4a1bc2498cd1a61263c24eb'::TEXT, ARRAY[949, 2740]::BIGINT[]),
    (90::BIGINT, 'Este es el único profesor que me ayudo con mi tesis después a conseguir trabajo sin ser mi director de proyecto de graduación.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2016-03-05T00:00:00+00:00'::TIMESTAMPTZ, '5e07dacd2fab079b142ef0f5d0e68780fbb42b1b37c51dffcdaac58d24c41083'::TEXT, ARRAY[2799]::BIGINT[]),
    (90::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-09-12T00:00:00+00:00'::TIMESTAMPTZ, '86306278854f47ed26b3b590f464220c3f45268f30dc6a1fc8151951264ecc5d'::TEXT, ARRAY[2131]::BIGINT[]),
    (90::BIGINT, 'Este profesor siempre esta preparado para sus clases. Los examenes son del material visto en clases, quices, y tareas. Hay que trabajar y no regala el curso, pero si se estudia se sale muy bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2015-07-13T00:00:00+00:00'::TIMESTAMPTZ, '33998a716df2d935364bbb0a5bd0ef216284a6dd75aef46a5da514f4e568f708'::TEXT, ARRAY[968]::BIGINT[]),
    (90::BIGINT, 'El material del curso es en inglés, tiene una forma muy particular de enseñar. Fuera de lo convencional.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'ebd51db043e8c703ba3c5b6df3017978579b66b5fabba7a08b96ddfc1c2302d2'::TEXT, ARRAY[2805]::BIGINT[]),
    (90::BIGINT, 'Yo si fui a todas las clases de este profesor y siempre iba preparado y con los temas del dia. Atendia preguntas que a veces le tomaban las 2 horas o mas de clases. Atendia consultas hasta sabados por la noche. Hay que ser un verdadero vago para salir mal con el.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-23T00:00:00+00:00'::TIMESTAMPTZ, '32e31857a7d6c38ea8144b33c2235ec8ecf423312eb6783ee3b00005279c4faf'::TEXT, ARRAY[2764, 2751]::BIGINT[]),
    (90::BIGINT, 'Las clases son super aburridas, habla bajísimo y sólo copia la materia. Da las clases porque no le queda de otra. No le interesa que unx entienda o aprenda'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-19T00:00:00+00:00'::TIMESTAMPTZ, '9cbde67a04e6470ed0daa8c430e5f6fe69226a49c4d6ca00b2a8159ed0d76373'::TEXT, ARRAY[968]::BIGINT[]),
    (90::BIGINT, 'Excelente profesor, en los exámenes entra lo que vimos en clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'db193c5d1f068e936cd3a9cb3a93ce9ac62ddfe7ac46ffd7017da2bfef204ef0'::TEXT, ARRAY[968]::BIGINT[]),
    (90::BIGINT, 'Es Bipolar'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'ddd23cf3b0301ba3b401fa195e20674bb423df85d2f462b7219ee7099139ed44'::TEXT, ARRAY[949]::BIGINT[])
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
