-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=67
-- TEC-DATA-META years=2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.751651+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (67::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, '2fe2e8057dd06b9898802fa0ee5ab9b303d5ee6c45c3ad546abc0f85ae649203'::TEXT, ARRAY[1782]::BIGINT[]),
    (67::BIGINT, 'Muy buena profe, es muy simpática, y si vas a sus clases ella no tiene problema con ayudarte'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-11-05T00:00:00+00:00'::TIMESTAMPTZ, '3c39e19806c03b301d74e13e43e816efdb4f995a9a5268f052facde42f684fe8'::TEXT, ARRAY[1782]::BIGINT[]),
    (67::BIGINT, 'De las mejores profesoras del TEC, brinda clases cortas y concisas, explica muy bien, le interesa que los estudiantes aprenda, muy importante ir a las clases y hacer las tareas y prácticas en casa para que los exámenes resulten fáciles y te de el tiempo y tener buena nota.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'c16627c778dfd04d6f1bd1927b0dd8f356f8b542256bf2f8611f4544ce712ead'::TEXT, ARRAY[1782, 2403, 290]::BIGINT[]),
    (67::BIGINT, 'Super buena gente, ayuda al estudiante a como puede. Basta experiencia y sabiduría, da retroalimentación útil. Sus Excels están poquito dañadillos, pero nada del otro mundo, ella lo corrige en medio de la clase. Puedes hacerle consultas pero debes volver a escribirle si no te responde. Vaya a clases'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-20T00:00:00+00:00'::TIMESTAMPTZ, '08cfc8dc601796beb956884012baa3b43941993f17ead91137b3f0509e8b664e'::TEXT, ARRAY[2403]::BIGINT[]),
    (67::BIGINT, 'La profe es super buena gente, siempre trata de ayudar a sus estudiantes. Obviamente si ve que la gente no le pone es más ruda pero en general fue muy tranquilo llevar una clase de finanzas con ella'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, '74c67b36044cf4b88e319f88550222dd51f6a91036f2987e35ef28b5d3baf18f'::TEXT, ARRAY[1782]::BIGINT[]),
    (67::BIGINT, 'Muy buena profesora, sin embargo las indicaciones en ocasiones no son claras, en especial, en los exámenes. Además, brinda machotes de excel lo cual es muy bueno pero a veces las mismas fórmulas que ella da en el excel están malas.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2024-06-11T00:00:00+00:00'::TIMESTAMPTZ, '5464d48192b964e849616dcbe0eb7bef03aedadf30fcf85b1931dc350b8d128c'::TEXT, ARRAY[290]::BIGINT[])
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
