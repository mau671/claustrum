-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=139
-- TEC-DATA-META years=2014,2016,2017,2019,2021,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:56:56.116970+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (139::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Muchos proyectos grupales']::TEXT[], '2026-05-19T00:00:00+00:00'::TIMESTAMPTZ, '74d7071a8492e55cbff82c500d40f84d63e4ab4a8b3d6954146f887633f32271'::TEXT, ARRAY[539]::BIGINT[]),
    (139::BIGINT, 'La profe es super linda, sus clases son mucho trabajo pero relajado.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '5857c02579cf1a466d2a8c798c10fc229d5bedd1c18f22b3d712d37e4a07f1fa'::TEXT, ARRAY[539]::BIGINT[]),
    (139::BIGINT, 'Es una profe excelente, la participación importa bastante, siempre corrige de la mejor manera posible y es muy respetuosa. En verano se hacen varios trabajos pero bastante fáciles. Llevaría su curso otra vez.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-29T00:00:00+00:00'::TIMESTAMPTZ, '7fa0d595f54d3ea95b597642812e88be362126c8cd669000044bf4b61a941190'::TEXT, ARRAY[625]::BIGINT[]),
    (139::BIGINT, 'Excelente profe, al principio por el nombre de la materia no estaba seguro de si iba a ser buena, pero en realidad vale mucho la pena, solo se entregan 4 tareas simples y se pasa y en general las clases son muy amenas, apenas para despejarse de la U. Recomendadísima'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'ffb625b5c114f4fce049168c715e490a0d0c503ba4a03d95d897b1be83258509'::TEXT, ARRAY[799]::BIGINT[]),
    (139::BIGINT, 'Matriculen con ella, es muy buena'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-09-07T00:00:00+00:00'::TIMESTAMPTZ, 'b674aff55245280382db89172e398d9e1bbaa1ba0adbe10ce516a929d73189f5'::TEXT, ARRAY[799]::BIGINT[]),
    (139::BIGINT, 'La profe es un amor, de ella se aprende demasiado y es un ambiente genial con ella, de las MEJORES PROFES DEL TEC, no dude matricular con ella. La amo'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Inspirador']::TEXT[], '2021-02-05T00:00:00+00:00'::TIMESTAMPTZ, 'c16f0935b34f468417b834f6defbcdcecd845e15e8ab3e248cd9e601fb340f7a'::TEXT, ARRAY[2525]::BIGINT[]),
    (139::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '0a411d72f3ed0b29f66cdee4cd4507a8b65d5658ec49a5857487fd04cb97e046'::TEXT, ARRAY[547]::BIGINT[]),
    (139::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Clases excelentes']::TEXT[], '2017-12-04T00:00:00+00:00'::TIMESTAMPTZ, '9609874a77db82e50639ab8e8f7cb8f99337a43bd736a37bcf2e91fe0133621a'::TEXT, ARRAY[539]::BIGINT[]),
    (139::BIGINT, 'Se aprende lenguaje técnico y conceptos importantes. Se realizan muchos examenes pero nada del otro mundo. Muy buena gente y buena profe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Muchos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2017-11-09T00:00:00+00:00'::TIMESTAMPTZ, '4480a02cd79dfc251a96c711dab5143642c09679766f84c09ddab3db82bee37e'::TEXT, ARRAY[2525]::BIGINT[]),
    (139::BIGINT, 'Es una buena profe, hace las clases interactivas y es súper buena gente, súper recomendada!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-20T00:00:00+00:00'::TIMESTAMPTZ, '9d4b815739802a527d24c3b097efb83e6f4270529357568cb5ef78d478a79a39'::TEXT, ARRAY[627]::BIGINT[]),
    (139::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Muchas tareas']::TEXT[], '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ, '62305fe7c90689971325c01c149d9aa2d35c062db38193ae10472c2fedafb855'::TEXT, ARRAY[625]::BIGINT[]),
    (139::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'c539ceec0b4e934221bd8aa21c4b937a7ddef1db1c0ef06c5cc431710ae98e6c'::TEXT, ARRAY[547]::BIGINT[]),
    (139::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, '48f7fc46206ae601f712a6ec7ea6bb7b63980b13898121b9086463c7323b220f'::TEXT, ARRAY[625]::BIGINT[])
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
