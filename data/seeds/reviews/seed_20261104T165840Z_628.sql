-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=628
-- TEC-DATA-META years=2017,2019,2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.829984+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (628::BIGINT, 'Es una profesora muy amable y comprensiva, en las lecciones se enreda un poco y aveces es difícil entenderle, hay que depender mucho del libro por que es probable que se equivoque mientras enseña, fuera de eso no califica duró'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2025-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'edb1be99a39d0e856b8099af75d218e6787e4c5e6a062a4c546090e5a3c99583'::TEXT, ARRAY[2014]::BIGINT[]),
    (628::BIGINT, 'En este curso se mostro muy amable y muy clara al explicar, su voz es de sueño, pero en general explica bien. Se puede llegar a equivocar pero no son errores graves. Se lleva muy bien con los estudiantes. A mi me gusto.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Brinda apoyo']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '7b82448dad1415d4503657d8d3ee5f186884467723696b248412047841913305'::TEXT, ARRAY[1981]::BIGINT[]),
    (628::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'acbff9383ea5c2e71e0fc861a1d8b43dc3fc15c9420f3b15a562f6afaf0c5a94'::TEXT, ARRAY[2002]::BIGINT[]),
    (628::BIGINT, 'Es de las peores profes que tiene la escuela de Ing. Agrícola. Tiene un doctorado pero no le sirve de mucho porque es demasiado pésima enseñando. Depende 100% del libro del curso'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, '009b50ff1dba078b29f282107dd6828bd98ad6bf1b01127d7e8b555f8d233c21'::TEXT, ARRAY[2002]::BIGINT[]),
    (628::BIGINT, 'La peor profe, no da la materia clara, se equivoca mucho y prácticamente hay que estudiar solo.'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'd721b2c40ba9e1874c1207f009816a97f46b8009c5c9212e49928c1b8f976ad0'::TEXT, ARRAY[2002]::BIGINT[]),
    (628::BIGINT, 'No domina la materia del curso, depende mucho del libro que a veces tiene errores yo personalmente sentí que no aprendí mucho'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-03T00:00:00+00:00'::TIMESTAMPTZ, '6355003facb1f0326519563b6eac9ca4f2295fd0f2713b54bd90a1cb903b0195'::TEXT, ARRAY[2002]::BIGINT[])
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
