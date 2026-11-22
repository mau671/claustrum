-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=737
-- TEC-DATA-META years=2016,2017,2018,2019,2020,2021,2022,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.093935+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (737::BIGINT, 'Es un muy buen profe. Sus quices son duros y los examenes son mucha memoria (Sabes, o no sabes) y siempre sus clases son muy enfocados en experiencia de industria y no necesariamente en teoría pura. Cae muy bien, chistes... curiosos.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Aspectos de calificación claros']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'c59dca24de83e6bfce78cb7850486a3e2481ae377c4d30b48d42d6af83935d4c'::TEXT, ARRAY[3272]::BIGINT[]),
    (737::BIGINT, '¡Un gran profesor! Simpático y sabe muchísimo, explica de forma interesante. Ojalá le dieran más cursos que parcelas y lab de cultivo. De verdad de mis profes favoritos. 100% recomendado'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2024-07-26T00:00:00+00:00'::TIMESTAMPTZ, 'c21a7070a31c9bd5c81d0c76b976dd17af213fe7e367c6a5fd46393cac0fcd42'::TEXT, ARRAY[3279]::BIGINT[]),
    (737::BIGINT, 'El profe pasa contando anécdotas en clase, entonces aunque la materia a mi se me hizo aburrida la hace llevadera. Califica súper suave y hace los quices y exámenes fáciles, eso sí mucho de memorizar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'a60e3f0d9d2a6a998146dfae76b0d965f46d7fe888fc0230f8c939a015a7f4c0'::TEXT, ARRAY[3272]::BIGINT[]),
    (737::BIGINT, 'Es super buen profe. Explica bien y hace que sea más bonito el curso. Full lo recomiendo.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-07-18T00:00:00+00:00'::TIMESTAMPTZ, '79c6d249e6c4e6158cbe87098f9480dff381228b116cb9d633ce2cd85d6e5bd7'::TEXT, ARRAY[3279]::BIGINT[]),
    (737::BIGINT, 'Es uno de los mejores profes de la escuela, explica todo súper bien y le interesa que todos los estudiantes aprendan. Se esfuerza para que su clase sea amena y se pasa fácil. Si tiene la oportunidad lleve todos los cursos posibles con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '1e292c9080e3a2d201bd90e8d8b2c6bc0693ced19a7c3b14e644802c29bdf9b3'::TEXT, ARRAY[3279]::BIGINT[]),
    (737::BIGINT, 'Realmente se aprende mucho en el curso y él lo hace interesante. Volvería a llevar un curso con él :)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2019-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'f8394700a4d308bc924e9c789dcbac97387c13a4e7f76157316912b88db6a2e3'::TEXT, ARRAY[3272, 3273]::BIGINT[]),
    (737::BIGINT, 'El mejor, se pasa muy muy fácil y de verdad se aprende.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'cf46053065f01fbe46dc5d959896ef8e1cfa9bc916c493e4d8a6f3619affb5e0'::TEXT, ARRAY[3279]::BIGINT[]),
    (737::BIGINT, 'Excelente profe! siempre ayuda mucho! No duden nunca en meter con él'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Exámenes retadores', 'Clases excelentes']::TEXT[], '2017-12-27T00:00:00+00:00'::TIMESTAMPTZ, '37643abf18bb3618dcba519cd52cf4311cabe75cb63c11ecbbe0d9ec98cf92e0'::TEXT, ARRAY[3273]::BIGINT[]),
    (737::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Exámenes retadores', 'Brinda apoyo']::TEXT[], '2017-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'f5f67b3bc1e0a503f41d021a7c3bf3c264f18bf08ac856d353e6141aee914d22'::TEXT, ARRAY[3272]::BIGINT[]),
    (737::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, '24701f12d32bcd1da2a90fcd296b9c1245da7dc0c0b036d7fd3b464919c02c7b'::TEXT, ARRAY[3272]::BIGINT[])
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
