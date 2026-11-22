-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=871
-- TEC-DATA-META years=2014,2015,2018,2020,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.031167+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (871::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2024-05-31T00:00:00+00:00'::TIMESTAMPTZ, 'c40314fc19792108612a17e98e75e049b05a462344d724afc883cfd7bd27ddf0'::TEXT, ARRAY[4818, 4830]::BIGINT[]),
    (871::BIGINT, 'lleve con el en 2020 y 2024, ha mejorado demasiado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-03-11T00:00:00+00:00'::TIMESTAMPTZ, 'f66ed13508f53e8736e04596843a2a8b7b662e6847064dc5272efb2399fe1d79'::TEXT, ARRAY[4818, 4830, 4817]::BIGINT[]),
    (871::BIGINT, 'El profesor no tiene buen dominio de los programas a utilizar en el curso, lo que dificulta el dominio de los contenidos al no ser capaz de atender las consultas de los estudiantes.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-02-07T00:00:00+00:00'::TIMESTAMPTZ, '3dcef5ff051519e6cdffc659812e5556e8a0124484abe7f4a6501b252f2ce09c'::TEXT, ARRAY[4776]::BIGINT[]),
    (871::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2018-12-02T00:00:00+00:00'::TIMESTAMPTZ, '42916da89972b68026f0255b9a19bae64ba1bb28a06665b8cb628b29fc9528c2'::TEXT, ARRAY[4818, 4830, 4817]::BIGINT[]),
    (871::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-21T00:00:00+00:00'::TIMESTAMPTZ, '0ff830d1bd18d81e1f5c10bc4b277a03429852a26b9f5c1dbfc1bbea375dcaf3'::TEXT, ARRAY[4818, 4830, 4817]::BIGINT[]),
    (871::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '3b9fb7effa18ae04ca55bdf145c702850d7de7277cbb241875addcd7b6bbd818'::TEXT, ARRAY[4792, 4790, 4849]::BIGINT[])
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
