-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=48
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.042959+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (48::BIGINT, 'Excelente profesor, se interesa mucho por lo estudiantes y siempre mejora a base de lo que uno le dice. 100% recomendado, lástima que la escuela no le da más cursos'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-22T00:00:00+00:00'::TIMESTAMPTZ, '0249d24d7098abbc671431652227700a237edfde08dbf80a43269ce4dd83cfad'::TEXT, ARRAY[2394]::BIGINT[]),
    (48::BIGINT, 'Usa el mismo tono de voz durante toda la clase, lo cual da sueño, pero mientras haga los trabajos en clase y las tareas se pasa fácil. Y si pides ayuda él te la da. En general unas clasecitas de exposición en público no le vendrían mal. La materia también es aburrida.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '9f73495be465eac1e01c5e96f3dd9d0d1ca3560643086596f85c564a9ed52ad2'::TEXT, ARRAY[2394]::BIGINT[]),
    (48::BIGINT, 'Las clases son bastante aburridas, el tono de la voz del profesor es muy suave, pero las prácticas, tareas y exámenes son bastante fáciles. Sólo es cuestión de ir al día'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'e9d6cf6360087c768ddf66a5c3bf3cb39691bc9768dba2d009d9d14bcb4a6945'::TEXT, ARRAY[2394]::BIGINT[]),
    (48::BIGINT, 'Profesor más aburrido que he tenido en toda la carrera, es apenas semana 4 y ya no quiero continuar solo para no escuchar al profesor hablar'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2025-03-14T00:00:00+00:00'::TIMESTAMPTZ, '401fe76972d8aedf9f332baba5e440a829419de8f5bd63d9aab51d78368bef44'::TEXT, ARRAY[2394]::BIGINT[])
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
