-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=65
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.053420+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (65::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'b91e2f509e9d4e7b3c9e13d8f35be1c00f5cafe806ec0c08793510e56a80aae2'::TEXT, ARRAY[963]::BIGINT[]),
    (65::BIGINT, 'La verdad en el curso PI1402 - Logística y administración de la cadena de abastecimiento fue muy dinámico lo dio virtual y además fue claro con la materia y exámenes explica las veces que usted necesita para entender da consulta y brinda prácticas de examen y realmente es muy bueno matriculé'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-02-12T00:00:00+00:00'::TIMESTAMPTZ, '79fef1b9676f4e95f32921d869e84cc0d9b15b634d00b5e9be17dc5c8dcb5dd2'::TEXT, ARRAY[2474]::BIGINT[]),
    (65::BIGINT, 'Le da un enfoque al curso mas profesional, normalmente un curso donde todo mundo detesta, el profe lo planeo y evaluo de manera que se abarcaran todos los contenidos sin perder la salud mental. Dele sin miedo con el Bryan.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, '93b0c8b88d046adfe0cdb5295019b3dd42868f91c078d4aef8ce11fdfda47ff6'::TEXT, ARRAY[963]::BIGINT[])
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
