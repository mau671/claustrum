-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=643
-- TEC-DATA-META years=2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.821389+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (643::BIGINT, 'Super calidad de profe, 1000% recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'd2b3b34ce43ad3a27e664f9b94d7598a22dc5febc3e71e731d66278509ea9e1d'::TEXT, ARRAY[2131, 2139]::BIGINT[]),
    (643::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'd6f409dd3b0dbc97ccbf6063a213d9a5f6a06801ce7c2c0015f9e9e2f97db45c'::TEXT, ARRAY[2131]::BIGINT[]),
    (643::BIGINT, 'Explica super bien, super ligado a los exámenes y dispuesto a responder dudas fuera de clases'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, 'da7ccf02666cdc1ef641f1221aa34e2c1f8150801db17ebd3404d55345dd304f'::TEXT, ARRAY[2139]::BIGINT[]),
    (643::BIGINT, 'Un excelente profesor, explica muy bien y hace bastantes ejercicios para que la materia quede clara, tanto virtual como presencial es un 20/10 y aclara todas las dudas. Se los recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '6cec4d6b390c246824a15c2e08eb6301858c266d162b710460cc2812b377c6d6'::TEXT, ARRAY[2131]::BIGINT[]),
    (643::BIGINT, 'Recomiendo a Mario en su totalidad, virtual es una maravilla ya que se hace más fácil (presencial también es 20/10) y si es necesario le da una clase solo a usted explicándole con muchos ejemplos. La clase es medio larga pero muy entretenida. Él es muy buena gente y comprensivo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-22T00:00:00+00:00'::TIMESTAMPTZ, '5a9e4e4dab8609b4e66e789d51b5e532090d590442260bfd9df2f478b0b7cc8f'::TEXT, ARRAY[2131]::BIGINT[]),
    (643::BIGINT, 'El profe esta atento a contestar cualquier duda que tenga, es muy pura vida'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-22T00:00:00+00:00'::TIMESTAMPTZ, 'f4604960f0329aa8843a2f9c0c02452b565a87d767bbe9624cd51a4ed9356dca'::TEXT, ARRAY[2131]::BIGINT[]),
    (643::BIGINT, 'El profe es muy buena gente, te ayuda mucho si no entiendes y siempre está dispuesto a ayudar.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-07-15T00:00:00+00:00'::TIMESTAMPTZ, 'e89aa087f268d5b437fe6c86fecd6b3398464700ea5135574300e894f26bb7ad'::TEXT, ARRAY[2131]::BIGINT[])
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
