-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=683
-- TEC-DATA-META years=2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.831474+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (683::BIGINT, 'No hace exámenes, califica bastante suave y sus clases son cortas, excelente persona y muy buen profesor.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, '6177bbab09e6ced499f6b4b9a5c0e95549db6247400f558f817500b489590e3b'::TEXT, ARRAY[2598]::BIGINT[]),
    (683::BIGINT, 'Amé este profe. Muy calidad'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador']::TEXT[], '2024-04-24T00:00:00+00:00'::TIMESTAMPTZ, '4b1d1aade59f0a08b3f86d66b8e2a1efadd28890f5bba5cc97211ba3d5ac8488'::TEXT, ARRAY[2602]::BIGINT[]),
    (683::BIGINT, 'El profe es una belleza. De verdad que lo tengo en mi corazón porque transmite y enseña muchisimas cosas para la vida mas allá que de materia y diapositivas. Muy buena opción si quiere disfrutar un curso. Ayuda muchisimo al estudiante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Pocos exámenes']::TEXT[], '2024-02-10T00:00:00+00:00'::TIMESTAMPTZ, 'fb3fc62489b0ce623093417fa9bebbc822d7c7927360c96ff9948e20097e2d45'::TEXT, ARRAY[2602]::BIGINT[])
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
