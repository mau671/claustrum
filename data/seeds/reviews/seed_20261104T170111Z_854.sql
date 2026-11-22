-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=854
-- TEC-DATA-META years=2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.029024+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (854::BIGINT, 'Le grita a los estudiantes, pasa en un puro regaño, no es nada clara y espera que le lean la mente, hay que rogarle una explicación, colérica, nada le parece.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2026-07-16T00:00:00+00:00'::TIMESTAMPTZ, '7651c6d4e77b664a817205c4653aa398cd043a27657f69d81f1965a8ff5f8e25'::TEXT, ARRAY[4748]::BIGINT[]),
    (854::BIGINT, 'Parece seria pero es una exelente persona. da una retroalimentacion increible y se da a entnder muy facil con ejemplos cotidianos o metaforas sencillas. recomendada al 100'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Aspectos de calificación claros']::TEXT[], '2023-02-01T00:00:00+00:00'::TIMESTAMPTZ, '3a5ff807c7bfd5dceb520cf0a0f6585d8474bf44cff69d99623610d99637f760'::TEXT, ARRAY[4751, 4758, 4748, 4757]::BIGINT[]),
    (854::BIGINT, 'Al principio parece que es un poco seria, pero ayuda mucho y explica bien.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2022-02-12T00:00:00+00:00'::TIMESTAMPTZ, '5120f6ddece71872665ec4abb3ea485ff375cddc02ca4938e8eda0b705c2c05e'::TEXT, ARRAY[4758]::BIGINT[])
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
