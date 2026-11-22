-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=826
-- TEC-DATA-META years=2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.250917+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (826::BIGINT, 'Se pueden pasar los cursos con un poco de estudio, deja trabajos en parejas que a veces cuestan puntos, los exámenes y quinces son normales, ni tan fáciles ni difíciles, es muy estricta con ausencias y tardías, hace clases con kahoots y así, es entretenido y es pura vida.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Muchos proyectos grupales']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'c3f6a3a779f987985d05fb86d18d674d21946e3a9d3cae6760940b631a3d6859'::TEXT, ARRAY[539]::BIGINT[]),
    (826::BIGINT, 'Buena profe, le interesa que sus estudiantes realmente comprendan los temas, explica muy bien y las veces que sean necesarias, hace dinámicas entretenidas. No deja tareas con porcentaje. Los exámenes no son complicados pero sí es bueno dedicarle un rato de estudio.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '2afc606b545d024a28c5dc3db660eeb9a6ce1a7d80607cafcd03f652c281b4c7'::TEXT, ARRAY[625]::BIGINT[]),
    (826::BIGINT, 'Deja varias tareas de grabarse hablando ingles, también deja varias tareas de hacer en pareja, a veces hace preguntas enredadas en los quiz pero ella no tiene problemas en aclarar. Pero es buena profe muy pura vida, siempre la vi de buenas, hace chistes y hace algunas clases dinámicas divertidas'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Pocos exámenes', 'Aspectos de calificación claros']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'ff11cfec6cc4b450b279e0f6cedafb2f74ff6f5bcb2d6e2934c0d41493a1a4b4'::TEXT, ARRAY[539]::BIGINT[]),
    (826::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2024-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'cb31a871916af72b46185425f3ab561b8c59d59d0c47bb6af698c0508b0300b5'::TEXT, ARRAY[625, 2432, 2379, 547, 545, 2433]::BIGINT[]),
    (826::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2023-11-28T00:00:00+00:00'::TIMESTAMPTZ, '38d77469b29b18f5414cea2ef511e843a5616a053eb5c5b1ce0e3d6c7e946bfb'::TEXT, ARRAY[625, 2432, 2379, 547, 545, 2433]::BIGINT[])
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
