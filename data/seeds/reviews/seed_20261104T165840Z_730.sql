-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=730
-- TEC-DATA-META years=2016,2018,2020,2021,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.892997+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (730::BIGINT, 'No ayuda en nada o casi nada, contesta una pregunta con otra pregunta. Califica suave. No explica mucho pero la clase es tranquila, genera un buen ambiente'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, '5094b41db34403ce1b668a05073818dca586409f5e21f11199b780623bedc2af'::TEXT, ARRAY[3277]::BIGINT[]),
    (730::BIGINT, 'Puede ser algo confuso como explica las cosas, pero en general es un profesor bueno y no califica muy duro'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '3ecb11be66b2a990d7407d7e939e5857ebc8ee2bb06a9812a31b1d3e5e0c98c6'::TEXT, ARRAY[3275]::BIGINT[]),
    (730::BIGINT, 'Es un profesor muy buena gente, no busca molestar a los estudiantes calificando rudo o algo así. A veces cuando explica no se entiende/enreda mucho, pero uno se acostumbra. Casi no ayuda en las prácticas pero es para que uno mismo resuelva los problemas (algo positivo). Lo recomiendo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[], '2022-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'a588a235b47eca2961311e2da58d61e2ab797783666f4968f08f266bc2eeb613'::TEXT, ARRAY[3275]::BIGINT[]),
    (730::BIGINT, 'El profe es buena gente y explica claro. Si uno no entiende, puede preguntarle las veces que quiera y no se enoja. Al principio le responde rápido las consultas pero ya cerca del final de semestre, puede tardar más. Se puede enredar al calificar así que hay que estar pendientes.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2021-12-04T00:00:00+00:00'::TIMESTAMPTZ, '0cd00eae3ac154748479a01ea8a8e4c6f9ccd2c5a2a7ae7747e6659895c2aad7'::TEXT, ARRAY[3275]::BIGINT[]),
    (730::BIGINT, 'Dr. Miguel no aporta mucho a los estudiantes y aun peor a Ing.Biotec. Estilo 70´s. Empeñoso tardò casi 10 años en Alemania para sacar el Dr. y creo fama. Caprichoso para calificar (demostrado con las mujeres vs homres) ...El Tec queda debiendo con este nivel de prof.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-09-08T00:00:00+00:00'::TIMESTAMPTZ, 'b03563d062d15d7ec39a6ae6672d5413921bf2fed726dc84ea9d0ca8160ea272'::TEXT, ARRAY[3277]::BIGINT[]),
    (730::BIGINT, 'Es un profe con muchísima experiencia y sabe bastante sobre lo que explica, aclara cualquier duda y si tiene que explicar 537 veces algo para que entienda, de fijo lo hace. A veces se enreda un poco con sus explicaciones, pero en general es excelente profesor y persona'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, 'd1688858172c97d30733a1fe9443edf93435ee7101f350886a69cf8c5a283028'::TEXT, ARRAY[3277, 3275]::BIGINT[]),
    (730::BIGINT, 'Es un rose excelente e intenta que todos entiendan la materia sin importar cuantas veces la tenga que explicar. Puede ser un poco desordenado con sus ideas pero sí se entiende lo que quiere decir'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, 'def491e10b848b9f8ae6866b4d595bbf1a2782966f7cc38164ac726c08541144'::TEXT, ARRAY[3277]::BIGINT[]),
    (730::BIGINT, 'El profe es uno de los primeros profes de la carrera y tiene mucha experiencia, no obstante a veces le falta claridad a la hora de explicar ciertos conceptos. El si es muy buena gente e intenta motivar a todos a que seamos buenos profesionales. Para los quizzes si hay que estudiar bastante.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores', 'Inspirador']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '9fb5720e97f51a1fc86615ee319976bc674abbac55cd0f468a6cff759f4f36b2'::TEXT, ARRAY[3275, 3277]::BIGINT[]),
    (730::BIGINT, 'No dudo de que sea un buen profesional, pero como profesor queda debiendo mucho. Clases aburridas para una materia de la cual se espera mucho.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-29T00:00:00+00:00'::TIMESTAMPTZ, 'b1890db8bcfb1a9c0c39f09e496fb2ed8f7c0848b8e7c0130542ff5ab245ad02'::TEXT, ARRAY[3275]::BIGINT[]),
    (730::BIGINT, 'Abuuuuurrido'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Brinda apoyo']::TEXT[], '2018-01-03T00:00:00+00:00'::TIMESTAMPTZ, 'f01ae84569a0a045d7c84ee6ce50b3d35831389ea6251b686760527e8d843d6b'::TEXT, ARRAY[3275]::BIGINT[]),
    (730::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, '766fe1eef735e7223bad996943aae11f5162651761ad86bffb04bbba03a91684'::TEXT, ARRAY[3275]::BIGINT[])
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
