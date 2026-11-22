-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=413
-- TEC-DATA-META years=2016,2019,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.940384+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (413::BIGINT, 'Excelente profesor, uno debe de aprovechar para preguntarle sobre la carrera y la industria en general, Sabe mucho. El curso es muy fácil, el profesor ayuda si uno se queda pegado. Lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2023-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'dd3d9e983b9822da7fe2e3cb73c142b8a0d139ff05a38835ae5275823590a472'::TEXT, ARRAY[1255]::BIGINT[]),
    (413::BIGINT, 'Buen profesor. Le gusta que los estudiantes sepan justificar y explicar bien el por qué de las cosas durante las exposiciones de los proyectos. Los labs presenciales se les saca MUCHO más provecho con este profe. Además, propicia un buen ambiente de clase.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '0807696b1fdce6293f54efafdf81dd216290e159b85f578ef5c84d822039be19'::TEXT, ARRAY[1326]::BIGINT[]),
    (413::BIGINT, 'El profe es SÚPER lindo, súper buena persona es de lo MEJOR, explica todo con detalle sepa usted o no, nunca le falta el respeto. Siempre se encarga de generar un buen ambiente, las clases son demasiados entretenidas, él es el mejor. Demasiado inspirador, siempre dispuesto a ayudar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-13T00:00:00+00:00'::TIMESTAMPTZ, '6f20a5716fc1bf28e367cc8596162e54fbc3a5a04ab53903e9712210d40be961'::TEXT, ARRAY[1255]::BIGINT[]),
    (413::BIGINT, 'Es un profesional muy preparado, uno tiene que aprovechar para aprender de él. En intro, la clase es fácil, pero uno siempre tiene que presentar el trabajo de la semana, pero se pasa muy fácil. Se nota el compromiso por parte del profesor. Excelente profesor.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '8fb5d4fc6236c9fc4fd8d049d4e32e87d0358439d7d34b881fb298ec1318ef27'::TEXT, ARRAY[1252]::BIGINT[]),
    (413::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e8f80039a428167798b2cf9a7d3cfe9203ad283e261891f5aa89377b54f0eb18'::TEXT, ARRAY[1288, 1289]::BIGINT[]),
    (413::BIGINT, 'El profe explica muy bien, siempre da ejemplos de reales que se puede encontrar en un ambiente laboral. Los exámenes son un poco complicados pero muy parecido a lo que se hace en clase. Ayuda bastante.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Exámenes retadores']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '1ac1cbc31e50f5f9da4e2b77205c7eeb6a4b5c627175989aa347a14602e9faff'::TEXT, ARRAY[1288]::BIGINT[]),
    (413::BIGINT, 'El profe es excelente, ayuda en todo lo que se le pida aunque no sea de su curso y se aprende mucho, da un enfoque de su materia con respecto a lo que se puede topar en la calle. Los exámenes son complicados.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2023-06-20T00:00:00+00:00'::TIMESTAMPTZ, '5a894face8878de71a398101f658289420848eff8f4cc49d337562999f140f4e'::TEXT, ARRAY[1288]::BIGINT[]),
    (413::BIGINT, 'Hace el curso mucho mas interesante que los demas profes, aprendi bastante y se enfoca mucho en los usos practicos de lo que se ve en clase. El profe es buena gente y ayuda, aunque en ocasiones se le mete el agua jaja. Tenga cuidado con los examenes, no son faciles y lo ponen a pensar bastante'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Inspirador']::TEXT[], '2023-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'ad6d853899208e61a701bab0b632e3807ab48496e72d5b2f174774c3bcbff534'::TEXT, ARRAY[1288]::BIGINT[]),
    (413::BIGINT, 'Muy buen profe, clases son interesantes y es fácil pasar. Un poco desordenado, entonces no se extrañe si no sube notas sino hasta el final de semestre. Muy provechosos los laboratorios'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo']::TEXT[], '2019-06-16T00:00:00+00:00'::TIMESTAMPTZ, '690fb99f541710cc62dc9b00c813462542fb020eac979e967329630c49b099b6'::TEXT, ARRAY[3069]::BIGINT[]),
    (413::BIGINT, 'Explica bien en clase y ayuda si se lo pides. Prácticamente no devuelve los informes calificados lo que impide que uno corrija los errores que este cometiendo. Es díficil de localizar porque no responde correo del TecDigital y no tiene oficina. Los quices a veces son faciles y otras dificiles.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2016-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'f28c747f4f7edba60ce16e8d42633f9ddc2ee2d5c2502d308fbfb2a03e3da44c'::TEXT, ARRAY[927]::BIGINT[]),
    (413::BIGINT, 'El profe explica bastante claro y si uno ocupa ayuda con la práctica sin problema le explica a uno, como persona es un sol. Todas las semanas aplica quiz, pero es un poco desordenado con eso porque puede que no los entregue, además puede que se atrase con las notas y evaluaciones.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-12-04T00:00:00+00:00'::TIMESTAMPTZ, '067da4bcae4fcf423aabf700f358f83ae8bec1cb7dbbe6dcc04f1b5bdb9d0c27'::TEXT, ARRAY[927]::BIGINT[]),
    (413::BIGINT, 'La intención de él es que aprendamos, eso es claro. Pero a veces se vuela con los quices y los hace sorpresa. Si uno ocupa ayuda, él va sin problema. Califica normal, pero debe ir siempre preparado para que no llegue sin saber nada al laboratorio.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2016-11-25T00:00:00+00:00'::TIMESTAMPTZ, '2147e946dc24eee8efdb724855107846b3644f7391c74570bdf14aa83db12a20'::TEXT, ARRAY[927]::BIGINT[])
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
