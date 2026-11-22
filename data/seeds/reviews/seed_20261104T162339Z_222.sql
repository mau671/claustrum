-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=222
-- TEC-DATA-META years=2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.901443+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (222::BIGINT, 'Muy buen profe de física, es claro con la materia, las clases son entretenidas y califica muy bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'd733508eda0b0ecb150cc89164b93d2654f78bb83a6f40120f47e982d99a7273'::TEXT, ARRAY[922]::BIGINT[]),
    (222::BIGINT, 'El mejor profesor de Física'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-06-06T00:00:00+00:00'::TIMESTAMPTZ, '12d52445145a02d0957df936752c3238da5cbd895577973598086bff34629986'::TEXT, ARRAY[922]::BIGINT[]),
    (222::BIGINT, 'Es un buen profesor, se apoya en programas para entender de forma gráfica e interactiva los temas. Es claro, explica muy bien e interactúa con los estudiantes.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-28T00:00:00+00:00'::TIMESTAMPTZ, '57b9d3fd56c6a1ecac65cca5323021e63ce0005b55d6d8e9a3db13df973a7d86'::TEXT, ARRAY[922]::BIGINT[]),
    (222::BIGINT, 'Siempre intenta que uno entienda, ayuda mucho a los estudiantes, es flexible con fechas de entregas, pero la explicación es un poco desordenada'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2022-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'b1fe2acf282fe82df9a35967d6490668d760d764f8a3e4711e8bc0fd7337b954'::TEXT, ARRAY[604, 630, 607, 631, 922]::BIGINT[]),
    (222::BIGINT, 'El profesor tiene cierta dificultad a la hora de explicar. Realiza los procedimientos de inicio a fin.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2022-01-30T00:00:00+00:00'::TIMESTAMPTZ, '7a16be29ec27aebe830891878bf892c13fddc9cee1e9d40989eb06b31d5de45d'::TEXT, ARRAY[630, 3021]::BIGINT[])
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
