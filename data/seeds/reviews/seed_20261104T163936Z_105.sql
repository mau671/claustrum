-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=105
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.317652+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (105::BIGINT, 'Explica muy bien tanto la teoria como lo que se va a hacer en los laboratorios, los quices los califica un poco rudo pero es muy buena profe'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2026-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'c1e1ebf4cd2d893129a4ed51093c483b938bbcf8292da81418e67dd00d0a341c'::TEXT, ARRAY[938]::BIGINT[]),
    (105::BIGINT, '10/10 las clases, como persona un amor, explica excelente, aparte que sabe mucho explica excelente. Es un toque exigente pero nada del otro mundo. 10/10 y la profe es una 1000/10'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2026-04-23T00:00:00+00:00'::TIMESTAMPTZ, 'a8f7bd76447cc607a1e43ff3cda8b57e392e463711ae210a9e84d0ef6dc62cea'::TEXT, ARRAY[938]::BIGINT[]),
    (105::BIGINT, 'Se le olvidó que el curso es de 2 créditos y que quimica ii no era requisito del curso. Demasiada exigencia en quices, proyectos y el primer examen para ser una profe que solo lee diapositivas. Casi que regaló el segundo examen por que si no se le iban a quedar todos'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos exámenes']::TEXT[], '2025-08-22T00:00:00+00:00'::TIMESTAMPTZ, '08ec2822f0ccd2a3684649dce5bd51b77aae51eb2bbca71fc5756a836b080427'::TEXT, ARRAY[937]::BIGINT[]),
    (105::BIGINT, 'No matriculen con ella, califica muy duro, solo lee las presentaciones en clase, se confunde al explicar y no da buena retroalimentación.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2025-07-05T00:00:00+00:00'::TIMESTAMPTZ, '38b22eae2625ed7ef6cd37ea05cac786d80099e70ea03b94145745b29f902a3b'::TEXT, ARRAY[937]::BIGINT[]),
    (105::BIGINT, 'Con esta profe se aprende lo que en teoría no, sin embargo, así como es de buena es exigente, ya que califica duro tanto quices como informes, siempre da retroalimentación y siempre esta dispuesta a ayudar moviendo fechas de entregas o en consultas. También algo a favor es que esta guapa'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Brinda apoyo']::TEXT[], '2025-01-14T00:00:00+00:00'::TIMESTAMPTZ, 'f18196287895b9fd4f2cf0f69def9f796d395670c6f2504eec79226988ab5f26'::TEXT, ARRAY[938]::BIGINT[])
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
