-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=432
-- TEC-DATA-META years=2016,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.990999+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (432::BIGINT, 'Excelente profe, a veces puede ser un poco aburrido pero ayuda bastante si uno no entiende La mayoría de evaluaciones eran en parejas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'e720a91c02d8786e7d7bc670a10d796cb1f38659e1d8a67746814eb7c82a81de'::TEXT, ARRAY[1749]::BIGINT[]),
    (432::BIGINT, 'Clases un poco aburridas por el horario, explica bien, muchos exámenes'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos exámenes']::TEXT[], '2016-11-18T00:00:00+00:00'::TIMESTAMPTZ, '91a77ea6ef8461e20466a7ce3ee64e5aa2a78359b9562c2cba17ac6a51c9a11b'::TEXT, ARRAY[963]::BIGINT[]),
    (432::BIGINT, 'Las clases son aburridas sí, pero uno termina aprendiendo mucho a pesar de todo. Los exámenes y quices no son nada complicados y el profe es demasiado buena nota.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-18T00:00:00+00:00'::TIMESTAMPTZ, '55ec93f55063f210eb80120915a20d46e296a5d521e67daf6def4fe233d291d9'::TEXT, ARRAY[963]::BIGINT[]),
    (432::BIGINT, 'El curso es bastante sencillo y el profesor no lo complica, los quices son fáciles, los exámenes tambien. Las clases son un poco aburridas porque las hace muy lento. Es muy buena persona y le interesa que uno aprenda.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2016-06-14T00:00:00+00:00'::TIMESTAMPTZ, '4740f41ca2053f2303db9fe2597359aa38c008aa6137097f0d7b38ace37d6fff'::TEXT, ARRAY[963]::BIGINT[])
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
