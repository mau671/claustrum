-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=10
-- TEC-DATA-META years=2017,2019,2021,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.478870+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (10::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, '721720c2a70c1215d5d4cda6435aef2b62690f81cc674750e3d92706b19c72f8'::TEXT, ARRAY[2438]::BIGINT[]),
    (10::BIGINT, 'Pesimo, no tiene vocación de educador. Es una persona burlista y desordenado.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2021-07-30T00:00:00+00:00'::TIMESTAMPTZ, '5eb397d4bad87a9db5a0730e1fde28a9279cb6cc6d3f7f5558154fc5b0169b65'::TEXT, ARRAY[2419]::BIGINT[]),
    (10::BIGINT, 'Molesto, inmaduro, humillador, con un complejo de superioridad y ego más grande que Godzilla, no debería ser profesor, es el peor que existe.'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2019-03-23T00:00:00+00:00'::TIMESTAMPTZ, 'ef63c59fbea2bfe1c5b145e2df345a6010f08438d01300d74519bd41d356fb94'::TEXT, ARRAY[2419]::BIGINT[]),
    (10::BIGINT, 'Se enoja si le ponen un mala retroalimentación.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2017-04-06T00:00:00+00:00'::TIMESTAMPTZ, 'cee0f760b41fe4a69b847b82950a4044a5fa9f93270c782357583b0e0642eb55'::TEXT, ARRAY[2419]::BIGINT[])
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
