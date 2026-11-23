-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=332
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:27:00.967782+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (332::BIGINT, 'Entiendo el nivel de esfuerzo que le exige a uno el profe, pero él también se esfuerza mucho, le contesta mensajes a uno con dudas los domingos o bien entrada la noche. Siempre esta atento a aclarar dudas.'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Inspirador', 'Exámenes retadores']::TEXT[], '2026-11-16T00:00:00+00:00'::TIMESTAMPTZ, '85d390106d5f029e815c121048acc0a27fcd4b2af60a4ebef07b991ab37dff4a'::TEXT, ARRAY[1029]::BIGINT[]),
    (332::BIGINT, 'Ignore los comentarios positivos, estoy seguro que es Él mismo que entra para intentar subirse de nota, es un pésimo profesor, demasiado exigente hacia los estudiantes pero no para él, porque asume que usted todo lo sabe. Evitelo o estudie todos los días de manera independiente para aprobar.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('5','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-11-13T00:00:00+00:00'::TIMESTAMPTZ, '016eb1c94c281c20eb8062d0e65fdde1f547032217228732bbe0b507a798aa50'::TEXT, ARRAY[1029]::BIGINT[])
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
