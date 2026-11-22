-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=268
-- TEC-DATA-META years=2021,2022,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.922660+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (268::BIGINT, 'Muy buen profe.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2026-07-04T00:00:00+00:00'::TIMESTAMPTZ, '840d76a119d4eab8adc598080c76734b83f4f9b0fff4d7082a81da3aa558317b'::TEXT, ARRAY[1022, 1020]::BIGINT[]),
    (268::BIGINT, 'Buen profesor, califica suave con una carga razonable. Proyectos sencillos. Sin embargo algo negativo es que en la mitad del curso solo ve pura teoría y hasta el puro final acumula lo practico por lo que se desperdicia una oportunidad para aprender más cosas útiles. Se hace un proyecto web sencillo'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '022b44d81ae6fa51cd05a92f34f3180141f643f8db4743170d17366df2a735fe'::TEXT, ARRAY[1037]::BIGINT[]),
    (268::BIGINT, 'Excelente profesor, califica super suave y se aprende. Da buena retroalimentación. Proyectos bastante sencillos, examenes sencillos y tareas faciles. Sin duda alguna matricularia con el de nuevo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Aspectos de calificación claros']::TEXT[], '2021-07-01T00:00:00+00:00'::TIMESTAMPTZ, '3b2a5fdfd32177dfa19595e523b545d8a8eef1e94ad9026cac9b0639531f6199'::TEXT, ARRAY[1037]::BIGINT[]),
    (268::BIGINT, 'Muy buen profesor para llevar BD 1, da las clases un poco rapido, lo que son dudas o consultas el profe esta disponible ayudarle y aclarar esas dudas, se atrasa un poco con la entrega de algunas notas(proyectos), pero es porque el proyecto es muy grande y el valor es muy alto.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-05-21T00:00:00+00:00'::TIMESTAMPTZ, 'f2e42262d3410b715f7a115ee6ccf244b62a85d2524fe8af4eefc64a785057ff'::TEXT, ARRAY[1037]::BIGINT[]),
    (268::BIGINT, 'Buen profesor. Explica las veces que el estudiante necesita y apoya en los trabajos. No es muy flexible con las fechas de entrega.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-04T00:00:00+00:00'::TIMESTAMPTZ, '2cf466ac6e4c0d9c5b0569e99e0effb6ac46c516756c93367398028e36647883'::TEXT, ARRAY[1043]::BIGINT[])
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
