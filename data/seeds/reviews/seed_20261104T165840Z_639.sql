-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=639
-- TEC-DATA-META years=2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.836585+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (639::BIGINT, 'El profesor sabe mucho de los temas y explica y aclara todas las dudas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'f384021a05ffa1702a24ca41fba0b70e61c708edc9b12d0d4186f17caaff3365'::TEXT, ARRAY[2042]::BIGINT[]),
    (639::BIGINT, 'El profesor sabe mucho sobre el tema y explica muy bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'f211c9b3af18dd520ebb03dae1f7037f90143e7d317f3dc34a5eea4da80a8a6a'::TEXT, ARRAY[2028]::BIGINT[]),
    (639::BIGINT, 'Buen profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Clases excelentes']::TEXT[], '2022-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'daca48680c03e9f4e2cc1b37362f3dccc1f3d94831c6d5c10a4c6f71d381e683'::TEXT, ARRAY[2059]::BIGINT[]),
    (639::BIGINT, 'Es muy buen profe la verdad, es bastante atento con las dudas, explica con el objetivo de que el estudiante aprenda, lo recomiendo para este curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-02-04T00:00:00+00:00'::TIMESTAMPTZ, '0b52f4f55fcec7f98272400e6eb78415b8cc0a97743b22e5f251af246bc9a0b7'::TEXT, ARRAY[637]::BIGINT[]),
    (639::BIGINT, 'Es un buen profe, las clases no son las mejores y pueden ser un poco largas pero el siempre está dispuesto a aclarar las dudas. Las evaluaciones son justas y coherentes con lo que él explica, además es muy flexible con cambiar fechas de entrega y en general es comprensivo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Clases largas']::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, '5a6f221bf6f042ddf9e98c682a306fd1bfb93f7f4de8f5ed6a28112fb723fdf2'::TEXT, ARRAY[637]::BIGINT[])
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
