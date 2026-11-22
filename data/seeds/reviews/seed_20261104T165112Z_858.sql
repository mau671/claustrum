-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=858
-- TEC-DATA-META years=2021,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.003369+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (858::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2024-02-01T00:00:00+00:00'::TIMESTAMPTZ, '27eff6ef718226c8cc3cbd529513c2e2d059f9de9cf559ee349b91876cb1cfb3'::TEXT, ARRAY[4775, 4765]::BIGINT[]),
    (858::BIGINT, 'Tiene una forma de ser distinta a los demás profes, dado a que uno tiene que saber como llegarle a lo que él quiere. Pero es excelente, da muy buena retroalimentación'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2021-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'c8e989e4f013777df76969ae2d3ff6ae9f6c3008370720bce489f2dec607f79b'::TEXT, ARRAY[4761]::BIGINT[]),
    (858::BIGINT, 'Excelente arquitecto y docente. Tiene un manejo de la disciplina como pocos en la Escuela. Es un poco inaccesible como persona, lo cual se traduce en que algunos estudiantes le tengan miedo. Pero por lo demas es uno de los mejores profesores de arquitectura.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, '10b0e9423fcf752f5ddb24454c8ed0fce938b3d049bc42fbfd0d559522cd1ccd'::TEXT, ARRAY[4828]::BIGINT[])
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
