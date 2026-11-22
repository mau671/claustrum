-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=364
-- TEC-DATA-META years=2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.790482+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (364::BIGINT, 'Es muy buen profesor. Aclara muy bien las dudas. Califica de manera justa, además suele dejar prácticas de bastante utilidad. Es paciente y por momentos hasta divertido. Hay que poner atención y tomar apuntes porque hay cosas que se dicen en clase que las usa después.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'a3772f587ff40b4f962afc5c261895941931a4e7e0045f4eea88f8fc44dcd65a'::TEXT, ARRAY[3164]::BIGINT[]),
    (364::BIGINT, 'Muy buena persona y ayuda bastante (responde muy bien las consultas que uno le haga), pero para Python le falta bastante, mas por ser profesor de Química y no especializarse en ello. Hacer bien las tareas y ponerle en el primer examen para pasar con lo minino. Por aquello regalo una tarea extra(OJO)'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Da crédito extra']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '7b8fc7b83d38a59936e048e0eebd21da87139e36e40be834039e1b7cc8630e13'::TEXT, ARRAY[1184]::BIGINT[]),
    (364::BIGINT, 'Haga las tareas bien y salga ok en examenes y pasa, no es muy wow el curso y es de python, es un curso sencillo'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2024-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'c55f4589125f659eda695e20a288901e996a28a0c54bae478d3a797d57794fec'::TEXT, ARRAY[1184]::BIGINT[])
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
