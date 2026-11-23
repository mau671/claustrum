-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=238
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:26:50.702128+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (238::BIGINT, 'El curso de base es bastante complicado y tedioso. Pero Vaquerano lo hace aún peor. Las clases se hacen muy aburridas. Los ejercicios de los exámenes no se parecen en nada a los que deja de tarea o quiz. Si no le queda de otra, estudie por su cuenta y espere que le vaya bien.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2026-11-18T00:00:00+00:00'::TIMESTAMPTZ, '5e37cea9964747d8bee81ddb312ff821ea98e6894f451e2f4ae39399a6bfe7dc'::TEXT, ARRAY[3049]::BIGINT[]),
    (238::BIGINT, 'Legalmente esperese a que Osvaldo de el curso, con vaquerano es una sufrida y media. Si no le sabe a los Vaque trucos... delo por perdido directamente'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2026-11-12T00:00:00+00:00'::TIMESTAMPTZ, '76de16a1c40e1f602e942984b9d07a4a0b4892777f16681cca82df76237f7e21'::TEXT, ARRAY[3053]::BIGINT[]),
    (238::BIGINT, 'Este mae no es profesor, es ingeniero, son cosas muy distintas, de todos mis años en el TEC este sin duda ha sido el peor profesor que he tenido por lejos, si tienen la oportunidad de matricular con él desaprovéchenla, a menos que sólo lleven ese curso "pesado" y a veces ni así, mejor estudie sólo'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'f240ab19b5f9a03046dd1aea6f08507602bd264ee6ecfd3bd05d22a2d7efa53a'::TEXT, ARRAY[926, 942]::BIGINT[])
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
