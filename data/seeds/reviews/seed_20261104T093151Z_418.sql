-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=418
-- TEC-DATA-META years=2014,2015,2016,2017,2018,2019,2020,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.753461+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (418::BIGINT, 'Se nota que conoce la materia, pero las clases se vuelven monótonas. Explica bien la materia, pero a veces se extiende mucho en demostraciones. Brinda la materia completa, pero no realiza ejercicios de ejemplo, queda en uno buscar ejemplos para estudiar. Sin ejercicios de práctica, no se pasa.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-15T00:00:00+00:00'::TIMESTAMPTZ, '43873976c65d8ab4aec92bace7bacdd2404bcf42bc64cc1a9ce0207e18ddd1bc'::TEXT, ARRAY[1252]::BIGINT[]),
    (418::BIGINT, 'De los mejores profes, muy dinámico. Califica justo'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes']::TEXT[], '2020-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'bb7ad54018d19a76dd4efcb26b1c30c99e5e4a5ea9ab2411daf1f4614dca4260'::TEXT, ARRAY[1252]::BIGINT[]),
    (418::BIGINT, 'Buenos ejemplos'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2019-10-16T00:00:00+00:00'::TIMESTAMPTZ, 'db09d8e72562b8e7081dcdeec5cf0ce7423d7a82dd41a13b5bb59a9ac9455c43'::TEXT, ARRAY[1323, 1325]::BIGINT[]),
    (418::BIGINT, 'Aprendí muchas cosas aunque estaba repitiendo el curso'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2018-11-26T00:00:00+00:00'::TIMESTAMPTZ, '1294fdb8d39cd61a4ae17c22ce1c579e14ebb70ae4ec6ce3999a1de1a0e1a2ef'::TEXT, ARRAY[3556, 1297, 1386]::BIGINT[]),
    (418::BIGINT, 'Se esfuerza con ejemplos para que la materia se entienda'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2018-10-16T00:00:00+00:00'::TIMESTAMPTZ, 'c6a0306914de58580f99b4128140e0193aaaf34e56123a8b77decb9db387a24b'::TEXT, ARRAY[1323, 1325]::BIGINT[]),
    (418::BIGINT, 'Explica bien, aclara bien las dudas en consulta, de los mejores profes del TEC'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-16T00:00:00+00:00'::TIMESTAMPTZ, '7e82d44f66e0e9cef8033f6217feef154c0af1e55af652948a15c996c8c6cd56'::TEXT, ARRAY[1252]::BIGINT[]),
    (418::BIGINT, 'Claro pero exigente'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-11-13T00:00:00+00:00'::TIMESTAMPTZ, 'c8ec701a3f1d0a7480b3959af71a2bd761f7d8ce165edde29baa5953ae9baefc'::TEXT, ARRAY[1307]::BIGINT[]),
    (418::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Respetado por los estudiantes']::TEXT[], '2016-09-01T00:00:00+00:00'::TIMESTAMPTZ, 'aa83a96ba225af3c1c3fa92ba0d7000c4215db21e271189579bc3b01ede5b045'::TEXT, ARRAY[3556]::BIGINT[]),
    (418::BIGINT, 'muchos ejemplos y explica de forma amplia la materia con comprobaciones matemáticas que facilitan el entendimiento de la materia'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'e5a7619111b1dc39a45e8d7c4cb6685858356e6534e29877cae9b304683e0330'::TEXT, ARRAY[1262]::BIGINT[]),
    (418::BIGINT, 'De los mejores profes de electro, sabe de lo que habla y ayuda bastante en consulta'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-17T00:00:00+00:00'::TIMESTAMPTZ, '20f959037915ae7ccc2997a9e47475c24c7a1ce174b15b23e630c5d280fcb03f'::TEXT, ARRAY[3556, 1297, 1386]::BIGINT[]),
    (418::BIGINT, 'Uno de los mejores profesores de electrónica!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-18T00:00:00+00:00'::TIMESTAMPTZ, '48198597c5c238cb6cc4906ca620ac30f85c68874eb7eb39438ffbc5bc2a7229'::TEXT, ARRAY[1262]::BIGINT[]),
    (418::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, '4d55153aca1f6ea1283d9e798db90d1cbc2f792a07febae1a7b9cd93502e9931'::TEXT, ARRAY[1262]::BIGINT[]),
    (418::BIGINT, 'Excelente profesor, aprendí mucho mas de lo que esperaba a pesar de que estaba repitiendo, todo me quedó clarísimo'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '9f94f3ef8039bbf5608dbb7184d8713eadfe66c6774fa330a188496b7b8a36b1'::TEXT, ARRAY[1257]::BIGINT[]),
    (418::BIGINT, 'Excelente profesor, explica clarísimo y los quices son sencillos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '00b1becc9dd241d7329d01fd36503cf050cf16ed45e3b2fd9054550934b5ceb2'::TEXT, ARRAY[1262]::BIGINT[]),
    (418::BIGINT, 'Muy buen Profe'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '757706c9005ddcdad5635caad0f19ea6822fb3199668058479b4c49b1d4763c6'::TEXT, ARRAY[3556]::BIGINT[]),
    (418::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '8a9d2f86a7e6dacfbb22e7f84cf5c45acf1cd52ad6d847911314b160dd1d203f'::TEXT, ARRAY[1257]::BIGINT[]),
    (418::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-14T00:00:00+00:00'::TIMESTAMPTZ, '1e76f40cade301baa2f7e589d9a890cfba370049ae6c8840555e1984dbca5ab5'::TEXT, ARRAY[3556]::BIGINT[])
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
