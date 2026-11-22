-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=530
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.791707+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (530::BIGINT, 'Es un excelente profesor, muy buena gente, paciente y comprensivo. Uno entiende a la perfección lo que él explica y se preocupa por que todos entiendan bien.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-18T00:00:00+00:00'::TIMESTAMPTZ, '2e87676f0663504522e96f57ef06b14479df4e067af94a2e292ccb724f2bb6db'::TEXT, ARRAY[567]::BIGINT[]),
    (530::BIGINT, 'Muy buen profe, es muy amable y paciente a la hora de atender dudas y explicar procedimientos. Los exámenes cortos son super fáciles y con base a las prácticas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, '78c0b7edc97c89aca5f54b2baa028888d4da8be313120399a4d32c8f5adf9898'::TEXT, ARRAY[567]::BIGINT[]),
    (530::BIGINT, 'Es un gran profe y conforme pasó el semestre se ganó el cariño de toda la clase. Todas sus instrucciones son claras y siempre fue muy organizado. Siempre dispuesto a ayudar a los estudiantes y comprensivo con distintas situaciones. El curso como tal trae una carga de trabajo pero él mas bien ayuda.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-09T00:00:00+00:00'::TIMESTAMPTZ, '9d6060327e10285214ec7db150a443ad45bbace755888550032cd0b4898045bd'::TEXT, ARRAY[567]::BIGINT[]),
    (530::BIGINT, 'Explica muy bien cada laboratorio, los quices son sencillos, siempre está muy dispuesto a ayudar y con buena actitud.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-07-05T00:00:00+00:00'::TIMESTAMPTZ, 'e7d2d528906bf985b2aee8e2d010a29e17de4bcd4e6385f9e0cdcdb4384e3fbd'::TEXT, ARRAY[567]::BIGINT[]),
    (530::BIGINT, 'Exelente profesor, en Laboratorio es muy bueno, explica bien sobre como hacer los informes, ayuda a los estudiantes, y tiene una actitud muy amable, los exámenes cortos no son regalados pero por lo general no son muy complicados, califica un poco duro los informes, pero no demasiado'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'dd1f011867118cbc1ba016c2f4902f560054ca875b98c9838e29e1a19773eec9'::TEXT, ARRAY[567]::BIGINT[]),
    (530::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'a4fe0f487baebfb446e8a1b3a410150178dc3da15f733b8a517e5a3c41c4fdcc'::TEXT, ARRAY[567]::BIGINT[])
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
