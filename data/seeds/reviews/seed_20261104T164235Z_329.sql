-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=329
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.886446+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (329::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2026-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'e24d591f1710a47b04206fb0bbffa8a83ae2c6a581268659cbfe31cce42c8b8e'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Si van a llevar introduccion a la programacion, full recomiendo con Alex, el curso es algo dificil, pero, sus clases son de mucho provecho, y, si se tiene alguna duda, el los va a ayudar con mucho gusto'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-06-15T00:00:00+00:00'::TIMESTAMPTZ, '3f2888f24ae7e47cd131b138fe2bede080b0dee3bcf4d45e88f31a870d8f3bde'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-11-04T00:00:00+00:00'::TIMESTAMPTZ, 'daf01aa01407a3f96428acfead4dfe5bf42e83d1633607334731155821142d4c'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2025-07-28T00:00:00+00:00'::TIMESTAMPTZ, '601dbc0ca6c29d3385bb307fb6d3eb75cadad7a87919fc8525ab36bff3b131f1'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'c35bf8a37f982047453cee6cf290c6923806378557608aa3f3eb56bb03e85f5c'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Es un muy buen profe la verdad, es gracioso y si se le pide ayuda o que vuelva a explicar lo hace. Califica un poco duro pero sus clases lo compensan'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-01T00:00:00+00:00'::TIMESTAMPTZ, 'ec4512b155fb4df26277e6587a804c1775b7b30cb5b4055d67a8cb099d99bd65'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Profesor en ascenso'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'daeae0c1f40c066bf92e488db846d8832867eb49b23d5e954f67d1f77646e360'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-23T00:00:00+00:00'::TIMESTAMPTZ, '7ad0bec688f743b5fd467eff62f725b1f114b4148b55443a193a1e638486209e'::TEXT, ARRAY[1020]::BIGINT[]),
    (329::BIGINT, 'Alex para ser un profe nuevo, es MUUUY bueno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2024-06-23T00:00:00+00:00'::TIMESTAMPTZ, '8649a618a2df52a066d34ea6501714530a4514cf45db57ee1c0ace1356f97697'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (329::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2024-05-03T00:00:00+00:00'::TIMESTAMPTZ, '9d2674fbe051206dee3ce9b5acb28a9363fa72de3681ec5dce563c77794bb435'::TEXT, ARRAY[1020]::BIGINT[])
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
