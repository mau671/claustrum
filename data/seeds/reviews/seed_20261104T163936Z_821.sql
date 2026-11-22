-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=821
-- TEC-DATA-META years=2018,2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.245407+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (821::BIGINT, 'Es un buen profe, ayuda mucho a sus estudiantes, trata de que la mayoría pasen, full lo recomiendo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ, '4d49b7bf362981bd913048ff3cb857627af553e27642547e7c504ff7b137cbea'::TEXT, ARRAY[568, 1434]::BIGINT[]),
    (821::BIGINT, 'Es un excelente profesor. Su manera de explicar hace que la clase sea muy intuitiva y es difícil perder el ritmo. Su clase es muy amena y la recomiendo al 100.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-23T00:00:00+00:00'::TIMESTAMPTZ, '554e6842cc4faf15e04f8a16c5b0232e0bf7f61f4f25eef96558f85b543eb9f2'::TEXT, ARRAY[614, 568]::BIGINT[]),
    (821::BIGINT, 'Me han dicho que explica muy bien pero yo no le entendía mucho, siento que daba información irrelevante de más, pero en general el buen profe, es tranquilo, no da las clases con prisa pero normalmente termina de dar los temas rápido.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '2ffcc0ceab0656418b9d374f647e79e6d0d1fded6826e7f3e467aab6a70c7b34'::TEXT, ARRAY[568]::BIGINT[]),
    (821::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, '0f2138fa13c4efe82638c3b6bfa31eb0769f3dbadc051c5c1e0ca536bcdfa14f'::TEXT, ARRAY[613]::BIGINT[]),
    (821::BIGINT, 'Es un muy buen profesor, explica con mucha claridad y sus clases no son aburridas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-12-30T00:00:00+00:00'::TIMESTAMPTZ, '2eb15e0ae5fcb493b1bd45e0097234807d030114cab2d1db41c222f1da6668c5'::TEXT, ARRAY[568]::BIGINT[]),
    (821::BIGINT, 'Buen profe, no hace sus clases tan aburridas o cansadas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '74dfa7581c5177c05fc5148c9599dcbed9d71745f4df5c2ee866eb1ce789a004'::TEXT, ARRAY[568]::BIGINT[]),
    (821::BIGINT, 'Es muy claro a la hora de explicar y está abierto a responder dudas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '5e1cc795be940d33a94902253e265b51aaaea30dd561e21f8d3af46fdf3c53f5'::TEXT, ARRAY[568]::BIGINT[]),
    (821::BIGINT, 'El más pura vida. Confía en la capacidad de sus estudiantes y es cómico mientras explica, llevando a clases memorables.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2023-04-23T00:00:00+00:00'::TIMESTAMPTZ, 'a8a189a222408d1eec597f1dc56919887e416ac431dea702d81647e0bdfd5974'::TEXT, ARRAY[568, 614]::BIGINT[]),
    (821::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-10-10T00:00:00+00:00'::TIMESTAMPTZ, '0f910bf034a62d3f5d4e0c859520893c626223c855ddefd7115d4be197f6cbb4'::TEXT, ARRAY[568, 614]::BIGINT[]),
    (821::BIGINT, 'Excelente profesor, explica incríblemente bien los temas, además ayuda a realizar los ejercicios con los estudiantes y va explicando paso a paso.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '98e12ef15431f26336ce3ed24b71bf59a06eb813a5b9171a145df61ec6a8a065'::TEXT, ARRAY[568]::BIGINT[]),
    (821::BIGINT, 'Profe demasiado bueno es excelente, se le va la mano con los quices que son demasiado rudos inclusive más que el examen Pero si se pasa'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, '7bf849633140bf780c7c9377be6b06cc1f34e35c3a2d65581a188e72084ec399'::TEXT, ARRAY[614]::BIGINT[]),
    (821::BIGINT, 'Explica bien, sabe del tema, pero algunas veces se le pasa la mano en los quices.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-05T00:00:00+00:00'::TIMESTAMPTZ, '9cd2506e071d4a96e856996d115b40568868637c8aa3eaa3ca95215558851733'::TEXT, ARRAY[614, 573]::BIGINT[]),
    (821::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2018-01-12T00:00:00+00:00'::TIMESTAMPTZ, 'a8b2a984472c6aa019083732a4c26fd64a600197a8f45bae7094076eef2d8b4d'::TEXT, ARRAY[568, 614]::BIGINT[])
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
