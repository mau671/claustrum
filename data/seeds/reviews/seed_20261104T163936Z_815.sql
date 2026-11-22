-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=815
-- TEC-DATA-META years=2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.244137+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (815::BIGINT, 'Es buena persona y le gusta ayudar a los estudiantes y le interesa que pasen, sin embargo no se le entiende nada, explica muy confuso y a pesar de que los quizes son virtuales, de nada sirven para el examen, la verdad no lo recomendaría para nada'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, '877302382f4cc44802d01fe6d1b00cfca952b1fa9938b2b932bf138471ec5964'::TEXT, ARRAY[563]::BIGINT[]),
    (815::BIGINT, 'El profesor es muy bueno y si tiene que volver a explicar lo hace las veces que uno lo necesite, sin embargo es difícil entenderle, para pasar hay que ser muy autodidacta.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2025-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'f489b28f5defe41937d642ab91de1f5e234b98e11deb8a6244fa8deaeff4ef4c'::TEXT, ARRAY[2439, 563]::BIGINT[]),
    (815::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2024-03-01T00:00:00+00:00'::TIMESTAMPTZ, 'a849af8c7a119bb59490702be97082a4a5c0e4afb44e86eac206798d263e2c44'::TEXT, ARRAY[2439]::BIGINT[])
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
