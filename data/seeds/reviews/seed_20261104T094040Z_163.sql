-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=163
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.734437+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (163::BIGINT, 'Aburrido y persona prepotente, me mandó a cambiarme la camisa...'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-10-06T00:00:00+00:00'::TIMESTAMPTZ, 'f0b51c6c7ed98467a9227dbad8c7086d01f4c5e226fb5ddf75ede46ab8af1934'::TEXT, ARRAY[2379, 625, 545, 2433]::BIGINT[]),
    (163::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '7ad150a2c8222b33fb46fbc3f3e137cf276b9405bd4bcaa06a5681ff24537a61'::TEXT, ARRAY[2379, 625, 545, 2433]::BIGINT[]),
    (163::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2026-07-06T00:00:00+00:00'::TIMESTAMPTZ, '334cc55c54d367e85244fadec60a579d31e66bdca8f942fa58e85894e7e40047'::TEXT, ARRAY[2379, 625, 545, 2433]::BIGINT[]),
    (163::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-02-10T00:00:00+00:00'::TIMESTAMPTZ, '9e2fd20bd3cd14cfc01f7e1f26c7a6a0b0cda7a1d334fffe414655309d8cf563'::TEXT, ARRAY[539]::BIGINT[]),
    (163::BIGINT, 'Ante todo es una gran persona, cae super bien, es buena nota con los estudiantes, sus clases son muy interactiva y si o si te obliga a socializar, todo es bastante claro y cualquier cosa que necesites te ayuda, de los mejores profes de inglés que he tenido.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-05-19T00:00:00+00:00'::TIMESTAMPTZ, '9e773487ccc7758f78e9ae672a372de15968a82b9c83a7db931cd8389afc23ff'::TEXT, ARRAY[539, 545, 625, 2379, 2433, 552]::BIGINT[])
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
