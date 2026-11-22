-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=646
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.841747+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (646::BIGINT, 'Es buena persona y le puede llegar a apoyar a uno pero considero que califica muy duro, no da la debida retroalimentación de acuerdo a los trabajos y tiende a dar instrucciones confusas. Por fuera de ello es un profesional excelentemente calificado dentro de su campo pero no buen profe'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Clases largas']::TEXT[], '2026-07-07T00:00:00+00:00'::TIMESTAMPTZ, 'd694066c92f5182de235e81f047651fb062c6c6b991f070fe79c71dfcf3292e6'::TEXT, ARRAY[2146]::BIGINT[]),
    (646::BIGINT, 'Siempre brinda apoyo, tiene dominio total de los temas y es muy responsable con las clases, si uno tiene dudas le ayuda y no evalua tan duro, gran persona y lo recomiendo al 100%'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'd88f561915a34c3ad2842b77d7154d7888665fa6de1791855f836ec1e18941dd'::TEXT, ARRAY[2146]::BIGINT[]),
    (646::BIGINT, 'Increible profe, buena gente y explica muy bien la materia y sus clases quedan muy claras, 100% recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-09T00:00:00+00:00'::TIMESTAMPTZ, '83824dfb9acb316b8fbf49250afc755a1801e1060646c8d4746150b25dd57976'::TEXT, ARRAY[4479, 4475, 1058, 1057, 4847, 4608, 4916, 1811]::BIGINT[])
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
