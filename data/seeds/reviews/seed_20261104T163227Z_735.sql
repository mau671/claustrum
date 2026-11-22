-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=735
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.092613+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (735::BIGINT, 'Este año él eligió los grupos (y todo se trabajó en grupos) entonces fue un poco de suerte a quienes les iba mejor en el curso o para quienes no era tan pesado. Igual el profe super tuanis, relax y los examenes los hace para la casa (son casos, a veces si se pone creativo pero se logra)'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2026-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'b2f5fe3663b03ccf32f4bb11f3b150be96d97a68df5771fb72dba61920437ea1'::TEXT, ARRAY[3287]::BIGINT[]),
    (735::BIGINT, 'Excelente profe, la materia es pesada, pero el sabe mucho y la clase esta bien.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-07-08T00:00:00+00:00'::TIMESTAMPTZ, '19c7033b2236d91c6c9e1129039a4a7e0138e409b90d5c7fc738521c28499fc3'::TEXT, ARRAY[3287]::BIGINT[]),
    (735::BIGINT, 'El curso lo dan dos profes. Este profe es muy buena gente, muy gracioso, muy tranquilo pero tiene favoritos muy evidentes. En las clases tal vez por ser tan buena nota cuesta que controle la clase pero usted le pone atención y aprende a la primera. Examenes largoooos, pero dan tiempo extra.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, '0698c8f93aa79bc872c550661789a48c060e979d9ab26d4807eb5494a09e3f68'::TEXT, ARRAY[3269]::BIGINT[]),
    (735::BIGINT, 'El profe es super atento a cualquier consulta en clase, cuesta un poco más fuera de horario, pero nada fuera de lo normal. Explica muy bien y demasiado pura vida. Tiene mucha paciencia. Sin embargo los exámenes son super super super super largos y bastante difíciles.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2023-12-25T00:00:00+00:00'::TIMESTAMPTZ, '3c5331bbf544072a66f6b319da687d333b57f6a28e92030861a73edb7bba959d'::TEXT, ARRAY[3304]::BIGINT[]),
    (735::BIGINT, 'Es muy tranquilo pero un poco desordenado. Es flexible con las fechas de entrega. La asistencia no es obligatoria pero si no va puede perderse bastante porque los labs son muy rápidos. Si se quiere se aprende, si no no. Tarda bastante en calificar y dar retroalimentación'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2023-12-03T00:00:00+00:00'::TIMESTAMPTZ, '11fc76dabab2d62001faa7be5da5a4416a5fcab51ea4753533cecebca622eba3'::TEXT, ARRAY[3269]::BIGINT[]),
    (735::BIGINT, 'Es buen profe y le interesa mucho que el estudiante aprenda más que cualquier cosa. muy flexible con las entregas de trabajos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-14T00:00:00+00:00'::TIMESTAMPTZ, '18244b1b9c2849dc1cd37c60f8f0eea7f75e09f6ab32bf4696490184fe70308e'::TEXT, ARRAY[3269, 3304]::BIGINT[]),
    (735::BIGINT, 'Le importa más que uno aprende, que cualquier nota. El curso se disfruta'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, '96c49b3722c3d248a9b8ec7dc4444612f813de3ab7319dc42d69de50b46e53bd'::TEXT, ARRAY[3304]::BIGINT[])
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
