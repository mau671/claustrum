-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=727
-- TEC-DATA-META years=2019,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.882406+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (727::BIGINT, 'En general es buen profe, pero sus quices (gran parte de la nota) son demasiado especificos y no siempre tienen que ver con aspectos de la materia estudiada. Fuera de eso es ameno y comprensivo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'afde0df5979fa1345ec9b2d94c06453d61187aafaddb516fa64313af570678ed'::TEXT, ARRAY[3259]::BIGINT[]),
    (727::BIGINT, 'El profe explica demasiado bien y siempre atiende dudas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '5f3f3f21f2c34cdc8ab4c4c0cd754604f296f9fb039bb62d15882f8652449342'::TEXT, ARRAY[3259]::BIGINT[]),
    (727::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas']::TEXT[], '2019-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'a68daf0b0144d746fb70d6d38f7c0044224dc8dc02b65bcf0b2d01b1eb240596'::TEXT, ARRAY[3259]::BIGINT[]),
    (727::BIGINT, 'No tiene otra opción'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2019-05-30T00:00:00+00:00'::TIMESTAMPTZ, '456fde3ec6f8f82be596cdece9cdbededa9582976b86b5cb68c462c72cb57ec6'::TEXT, ARRAY[3259]::BIGINT[])
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
