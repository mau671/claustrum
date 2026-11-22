-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=630
-- TEC-DATA-META years=2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.063153+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (630::BIGINT, 'No actualiza notas, lo cual es molesto. Los quices fueron más dificiles que los examenes. Y el curso en sí es interesante pero es un poco dificil como evalua por ser solamente examenes y quices.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'd267f76c85d4406445aa3cd79e48de9bb9fdd3ad3df50674dd4ce0a92f9f2cc2'::TEXT, ARRAY[1989, 1991]::BIGINT[]),
    (630::BIGINT, 'El profe sabe mucho acerca del tema, sin embargo puede llegar a perjudicar a los estudiantes a la hora de calificar, ademas la repartición porcentual que hace del curso es muy mala, le da mucho % a los quices. Es de tenerlo cuidado en ese aspecto'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-05-30T00:00:00+00:00'::TIMESTAMPTZ, '2a9a0fce3e1e190e00500caa950cf0011c1a88e7d3d01f1f050d7a2eba1a6527'::TEXT, ARRAY[1989, 1991]::BIGINT[])
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
