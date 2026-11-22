-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=282
-- TEC-DATA-META years=2020,2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.927720+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (282::BIGINT, 'se nota que sabe demasiado de lo que habla y quizá de las personas más inteligentes que he conocido pero como proferor espero que este sea el peor que hay porque si hay peores que cosa más triste, explica cosas que solo el entiende, se pierde en lo que habla, clases súper aburridas, se pasa súper fá'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ, '4a036b6e3170ac239dd45f6959f94564753d1c4f64f3ca648b5c71b1a0d5fe88'::TEXT, ARRAY[1032, 1029]::BIGINT[]),
    (282::BIGINT, 'Es una materia muy complicada de pasar , nisiquiera da las bases necesarias para realizar los trabajos , quiere que uno investigue todo.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2023-12-12T00:00:00+00:00'::TIMESTAMPTZ, '793bd6ab7d3020a46d1d1281b61d09e16fe8130e17451dbb42b89fb9c7778e7a'::TEXT, ARRAY[2918]::BIGINT[]),
    (282::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2023-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'c99c85491169472151f73a0f1fc0f85d35ac8fad963e3add4a1a34168cd2cbd8'::TEXT, ARRAY[1017]::BIGINT[]),
    (282::BIGINT, 'No lo recomiendo'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2023-05-31T00:00:00+00:00'::TIMESTAMPTZ, '2e3f8c7cbaea16f02ecfeda52d1d82c69547da6a3e37f5c673982504c6af999e'::TEXT, ARRAY[2918]::BIGINT[]),
    (282::BIGINT, '- Los temas que se ven en clase no tienen nada que ver con el proyecto - Una clase la daban los estudiantes, la otra era para trabajar en proyecto y el dia que le tocaba a él dar la clase ponia la clase de otra U - Califica rudísimo, plataforma horrible, hace observaciones absurdas SIEMPRE'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2022-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'f7c22f5dc2a2c8ca48088844d54eaf70d8ffed61f42383f42b4c534e51933469'::TEXT, ARRAY[1128]::BIGINT[]),
    (282::BIGINT, 'Dudo que haya un profesor más malo en la escuela de computación, llevar un curso con él es perder 6 meses de estudio'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-01-30T00:00:00+00:00'::TIMESTAMPTZ, '1b9eb5348da4123bd59c8d36da0b87a0f93f46999f2d276a237710db09fe560a'::TEXT, ARRAY[1029]::BIGINT[]),
    (282::BIGINT, 'El profe muchas veces se enreda y no se le entiende. Se empezó el curso con 15 personas y al mes solo quedaron 3 personas. al final el profe tuvo que aflojar la entregas de tareas y proyectos para que esas 3 personas pasaran.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2021-02-13T00:00:00+00:00'::TIMESTAMPTZ, 'ed79f1eda3e97c486e254a5e11586ec24ea2cfa3fb3bfd075e1dc514962b0c8d'::TEXT, ARRAY[1035]::BIGINT[]),
    (282::BIGINT, 'Super pésimo, tiene mucho conocimiento pero no sabe cómo compartirlo. No escucha comentarios ni recomendaciones de los estudiantes. La mayoría de los estudiantes de sus cursos reprueban y él los tacha de irresponsables. Y por último, su plataforma es pésima aparte de que dura en responder :('::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, 'c95721e457ac856ce41cd88c51c85b7b82f5c00e7eb6471a81f71b59c582d784'::TEXT, ARRAY[1032]::BIGINT[]),
    (282::BIGINT, 'El profesor tiene su propia página que es súper tiesa, además, no explica nada, sabe mucho pero no sabe pasar esos conocimientos a los estudiantes. Deja proyectos largos, no explica los proyectos ni los trabajos. No lo recomiendo para nada. Yo llevé bases con él y también fue una basura.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-01-27T00:00:00+00:00'::TIMESTAMPTZ, '61ce13a4dcefe044666f25b21f8a56ff9ec54fcb04e2301de6ddcd21f89702d7'::TEXT, ARRAY[1035]::BIGINT[]),
    (282::BIGINT, 'Lo que pasa realmente es que el profesor puede saber mucho pero no sabe enseñar Además de ello los proyectos que deja son muy complicados si los comparamos con los proyectos de otras sedes, el profesor es algo orgulloso y le encanta que lo alaben y se nota que tiene preferencia por los que lo alaban'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2020-12-12T00:00:00+00:00'::TIMESTAMPTZ, 'd4988dde6084232ca44de47edbbc38d7e03803b61a7e8d34e32c418d326640ed'::TEXT, ARRAY[1035]::BIGINT[]),
    (282::BIGINT, 'Llevé con él 1 semestre 2020. Las clases presenciales con él si son algo complicadas, pero no difíciles. Cuando se empezó con la modalidad virtual, fue un desastre. No explicaba los trabajos ni proyectos. Sin embargo, es un excelente profesor, sabe mucho y tomaría sus clases de nuevo pero presencial'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2020-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'd7ab3aed53d9e717b5a2f2a3c5746918b29f8cc45c9794a04cbbf24251ca500b'::TEXT, ARRAY[1032]::BIGINT[])
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
