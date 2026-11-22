-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=581
-- TEC-DATA-META years=2020,2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.798673+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (581::BIGINT, 'Demasiado fácil. Demasiado desorden.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-19T00:00:00+00:00'::TIMESTAMPTZ, 'f14fd97cd586608f0edd51b0f142292b3200d5ea0af7400ec7378bbd83a3d097'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'Es el profe que si le pregunta algo lo deja más enredado que antes, pero es lo de menos. Importa mucho la participación, aunque sea con comentarios y preguntas tontas. Si lo hace el profe es muy pura vida calificando. Todos los trabajos son en grupos. Muy dispuesto a dar consulta. Lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2022-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'f37cb864cc3156f980d9e5227a3114ae516dc9ca7640aa9fde840d87dad24bb6'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'deja tareas casi todas las clases pero son cortas y sencillas. Participar es importante. Se pasa fácil, se aprende masomenos. No va a programar nada. Puros diagramas y documentos.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2022-11-25T00:00:00+00:00'::TIMESTAMPTZ, '59a812195789743f90cb78c451ef41aa8f86ecfc22e46506bbd5fc76110f19e3'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'No es mal profesor, pero es demasiado desordenado con las notas y las clases, falta mucho por ser director de la Escuela y porque tiene que asisitir a citas médicas. Explica bien, pero la retroalimentación la da toda al final, lo que complica la realización de las asignaciones a lo largo del semestr'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '811e17ff48ee8d946989861c938ee26d2ccb2d744b4a4afeee66fbec0d7c2e15'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'casi ni brinda ejemplos de lo que hay que hacer pero es buen profe. Se pasa fácil, nada mas hay que hacer todo lo que pide. Deja un proyecto que se hace a lo largo del semestre, una investigación y tres exámenes. Permite eximirse y el curso es de dificultad baja.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2022-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'a855c598d4a97a6e0319f32016f60af888b4caf4c9c9cf4f5c23a3d4db46496a'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'Se ausentó casi por medio semestre por motivos de salud, por eso las clases pasaron a ser asincrónicas pero bien realizadas. Explica bien pero hay que ponerle atención porque es fácil de perderse, el proyecto se realiza durante todo el semestre y realiza exámenes de dificultad media. Recomendado.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Exámenes retadores']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'f3fd723987c076cefb08404194eef25ff372a96c07188baafa12f5a4cbbcd8b7'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'Virtual. Se ausentó mucho, la mayoría de clases fueron grabadas. Dejó todas las revisiones para los últimos días, las tareas y proyectos no son muy complicados y brinda pocos (o nulos) ejemplos para tener como referencia, muy pasable.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2021-07-03T00:00:00+00:00'::TIMESTAMPTZ, 'c867769122d7ce6a8684aaae08e2bcae72643b87cb66a6290b09b2ecef54c130'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'Casi no nos dio clases, solo subió videos donde explicaba lo que se ocupaba para los avances del proyecto, un poco desorganizado, pero creo que en general es buen profe, el proyecto no es muy complicado. El proyecto se va entregando por avances, deja tareas pequeñas y hace exámenes.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'c851c299e5aaecee63956810cde0abbfd8d11184286dc8a63153cf21bbd1a6db'::TEXT, ARRAY[1039]::BIGINT[]),
    (581::BIGINT, 'Excelente persona, pasa muy ocupado sin embargo atiende dudas con todo el gusto, le gusta que se participe en clases y en general sus clases son para aprender. Califica suave.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '1dab370e89c3ce5ddb19343e6a7bfba2ef4b7cbcb80084dde47b8c9545db58f0'::TEXT, ARRAY[1039]::BIGINT[])
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
