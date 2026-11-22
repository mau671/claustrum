-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=691
-- TEC-DATA-META years=2015,2016,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.857709+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (691::BIGINT, 'Es un excelente profe. Es muy simpático y muy buena gente. Las clases son excelentes y explica de maravilla.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-07-28T00:00:00+00:00'::TIMESTAMPTZ, '2115ff555335a141fcb5ea5abf27946ebd6ac25b0b350c4c6beda7d29c9507d7'::TEXT, ARRAY[1464]::BIGINT[]),
    (691::BIGINT, 'Es de los profes que lleva presentaciones bonitas, explica con muchos ejemplos, las clases son muy dinámicas, hace varias actividades, califica normal.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a5beed7b8795f66dc4332d8586fa36826ca602ae6429a6ceb39c865c56a05f36'::TEXT, ARRAY[2643]::BIGINT[]),
    (691::BIGINT, 'Excelente profesor, se nota que tiene vocación para enseñar. Las clases son súper claras, y entretenidas, es uno de los mejores profes que he tenido.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ, '2a5af08c7ab8adbc5b9cab68f458eeacd9b57dd1473aebe22c5fb9ade734b2a4'::TEXT, ARRAY[2643]::BIGINT[]),
    (691::BIGINT, 'Nada que decir, es el mejor :D Super recomendado!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-22T00:00:00+00:00'::TIMESTAMPTZ, '6bd1fbab3bb1f741266ea4220469c80472be46984293fe1fa97f8258f317d880'::TEXT, ARRAY[2643]::BIGINT[]),
    (691::BIGINT, 'Demasiado buen profesor, de lo mejor que pueden tener en el TEC , muy comprensivo, es muy pura vida, enseña muy bien, tiene ganas de enseñar y también muy vacilon'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-05-19T00:00:00+00:00'::TIMESTAMPTZ, '8570a9863592ec9ada9b1bb8899f73e09d6ff022e8b0fbc8bc09a51b0d1ddb12'::TEXT, ARRAY[2643]::BIGINT[]),
    (691::BIGINT, 'De los mejores profesores que he tenido.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-02T00:00:00+00:00'::TIMESTAMPTZ, '3432d9fce7590f717c2fde932b0ac08237f5d3865a2a179a0a437cde59d7fe9d'::TEXT, ARRAY[99]::BIGINT[]),
    (691::BIGINT, 'Excelente profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, '2213dd9c2614a7a887c47acd60777b598d7545a6b1e5601b32f87eb5e391a88f'::TEXT, ARRAY[2643]::BIGINT[])
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
