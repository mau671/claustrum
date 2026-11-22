-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=95
-- TEC-DATA-META years=2016,2018,2021,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.071745+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (95::BIGINT, 'Es buena gente y no busca perjudicar a los estudiantes. Él imparte la segunda parte del curso y es virtual, sin embargo no se aprende tanto como se desearía. Pierde demasiado tiempo en clase. Es la parte más fácil del curso, pero no se aprovecha el curso. Se hace muchas prácticas en clase.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2026-07-09T00:00:00+00:00'::TIMESTAMPTZ, 'e41ee1caffec43e12e4c49f37c66f3bb171edb1a644ed2a61b4417f0419bfa59'::TEXT, ARRAY[2745]::BIGINT[]),
    (95::BIGINT, 'Excelente profe, ayuda a los estudiantes, sin embargo los temas no son tan claros y hay que estudiar por cuenta propia, las evaluaciones son apegadas a lo visto en clase'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Brinda apoyo']::TEXT[], '2023-11-22T00:00:00+00:00'::TIMESTAMPTZ, '176a85cff3773db0048b6cdf822d27f29d007589d74bf0c10772455271069aab'::TEXT, ARRAY[2745]::BIGINT[]),
    (95::BIGINT, 'El profe es muy comprensivo e incluso intentan ayudarlo en las tareas y proyectos, sin embargo no explica tan bien las semanas que les correspondieron. Sus examenes son relativamente sencillos y no es tan duro para calificar.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'df965b995f82ba51c762d12492601169662e426636940daf91e0e4ca3767a4e5'::TEXT, ARRAY[2745]::BIGINT[]),
    (95::BIGINT, 'Es un gran profesional pero no un gran profesor. Lee las diapositivas y las pasa muy rápido, lo bueno es que las sube al tec digital y los exámenes son sencillos. Si se aprende durante el curso pero es un conocimiento muy básico.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'cdbb84db20f89e010130a36591f11dd89f01c86b4d376a203fecf8a602659705'::TEXT, ARRAY[2745]::BIGINT[]),
    (95::BIGINT, 'Muy muy bueno, y sabe mucho, el curso es de dificultad moderada!'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, '83c9b2a82f9589225c55db61bbb12428a4cab929c8a82f1195a51e4bebbba442'::TEXT, ARRAY[2805]::BIGINT[])
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
