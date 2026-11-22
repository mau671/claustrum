-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=847
-- TEC-DATA-META years=2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.260748+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (847::BIGINT, 'Facil pero la asistencia si es importante'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '8f8ed86527ffecac0052dba2a966c46920f265453c594ae3c42b7d02aa90161d'::TEXT, ARRAY[587]::BIGINT[]),
    (847::BIGINT, 'Calidad de persona y profesora. El curso se pasa solo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '3f4ac0c3c04af46aa32cdc4a652304631efa8a34df72d27bb2e0b5c42ff030f9'::TEXT, ARRAY[584]::BIGINT[]),
    (847::BIGINT, 'Excelente profe, es un curso bastante bonito en el que tienes que hacer informes todas las semanas y es bastante practico. Lo recomiendo al full y la profesora super pura vida.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2022-06-09T00:00:00+00:00'::TIMESTAMPTZ, '58e7161145e51ee89d20fd053ffd0f2e2dd30355a4848046086324e15954f30b'::TEXT, ARRAY[494]::BIGINT[]),
    (847::BIGINT, 'La profe es muy buena nota y aclara todas las dudas, deja tareas cortas todas las semanas, la asistencia importa pero si quiere empezar a hacer ejercicio como yo, mandese de una jajaja'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2022-02-25T00:00:00+00:00'::TIMESTAMPTZ, 'f5478983d1f54c6b7f0523d983cc11478280e139d2994c7ef8241c1b999e814a'::TEXT, ARRAY[494]::BIGINT[])
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
