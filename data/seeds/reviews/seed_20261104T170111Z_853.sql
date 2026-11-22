-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=853
-- TEC-DATA-META years=2018,2020,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.026841+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (853::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2024-01-09T00:00:00+00:00'::TIMESTAMPTZ, 'c633872f8b43009b9db211acc7126a194e8526d03b4251a3eb0e5f7c23ac5ae6'::TEXT, ARRAY[4751, 4758, 4757]::BIGINT[]),
    (853::BIGINT, 'sumamente clara con las indicaciones de los proyectos, ayuda muchísimo y cae bastante bien, tiene una buena relación de respeto mutuo con los estudiantes'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2022-07-01T00:00:00+00:00'::TIMESTAMPTZ, '4f957493990df201bece613b0df3b4406939effa23b2f30cdd48de899cb6cfcf'::TEXT, ARRAY[4751]::BIGINT[]),
    (853::BIGINT, 'Muy buena profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2020-03-11T00:00:00+00:00'::TIMESTAMPTZ, 'ab91f19406773857618024fc4aab80eb14f5eb32708ab1530699eb93e08c0454'::TEXT, ARRAY[4751, 4748, 4757, 4758]::BIGINT[]),
    (853::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'b9aa02cb763be70f003131f21025084c35c54b1533224c06782b8881af24bcdb'::TEXT, ARRAY[4824]::BIGINT[]),
    (853::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, '53f21c27f1f4aee72d49396b8d3c19c4a8c708fea4b7bc2631df56081a64ffd7'::TEXT, ARRAY[4824]::BIGINT[]),
    (853::BIGINT, 'muy buena profe, siempre anuente a ayudar, en revisiones es muy clara y te ayuda bastante, pero califica duro'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2018-01-16T00:00:00+00:00'::TIMESTAMPTZ, '094ef4f51c64c7e09dea9018a6e0a0d91384be70e8bb0fbc39c62cb1ebcb4457'::TEXT, ARRAY[4765]::BIGINT[])
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
