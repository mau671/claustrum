-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=997
-- TEC-DATA-META years=2020,2021,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.068418+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (997::BIGINT, 'Maravillosa docente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-18T00:00:00+00:00'::TIMESTAMPTZ, 'cfc588bac850fc5ee6362b94268cdb078b3b16a7994e1dd00b295541d4b87819'::TEXT, ARRAY[600, 554]::BIGINT[]),
    (997::BIGINT, 'Si tiene la opción de matricular con ella comu oral tomela, es una excelente profesora y ayuda mucho mucho al estudiante y califica muy suave 100/100 muy recomendada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2024-09-27T00:00:00+00:00'::TIMESTAMPTZ, '51d31590527a807a25d857964bc36a2e3a16760b2152b401d6c1e7e652d6c3e0'::TEXT, ARRAY[554]::BIGINT[]),
    (997::BIGINT, 'Explica todo súper bien y siempre está dispuesta a dar retroalimentación. Siempre ayuda con todas las dudas en los trabajos asignados e intenta que puedan terminarse en clase. Una muy buena persona y profesora.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2023-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'c7579153f212ae06f8c40baa128e8ac3caf5fc4a7f6f2644ccdf66c37f2c834e'::TEXT, ARRAY[554]::BIGINT[]),
    (997::BIGINT, 'La mejor profe sin duda. No lo piense más, lleve el curso con ella. Es muy ordenada y clara con las asignaciones, las calificaciones las lleva al día. Da buena retroalimentación y se interesa en que sus estudiantes aprendan. Es empática y respetuosa. Clases sincrónicas y asincrónicas.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2021-02-08T00:00:00+00:00'::TIMESTAMPTZ, 'd65500e5082e8b19fea09df17e81b2ed4408e05463c03d396b9b7ad3d70f8fce'::TEXT, ARRAY[600]::BIGINT[]),
    (997::BIGINT, 'El curso con ella es bastante fácil, califica suave y ayuda bastante si se le pide. Llevaría otro curso con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-28T00:00:00+00:00'::TIMESTAMPTZ, '1a58ca0245dce99982ee2cef22a5874e4388616be7c2e9a53a21975a3d400c07'::TEXT, ARRAY[556]::BIGINT[]),
    (997::BIGINT, 'La profe es muy amable y atenta, si necesitas algo no temas en pedirle ayuda ella lo hará si puede'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2020-08-24T00:00:00+00:00'::TIMESTAMPTZ, 'cdf2c23dcab3d6291c316e0f0e8a5babe729d83c84b5ff0f0699a9a807dbaf79'::TEXT, ARRAY[554]::BIGINT[]),
    (997::BIGINT, 'Califica super suave y explica muy claro todo, además es buena nota y comprensiva si uno ocupa ayuda o tiene dudas de algo o tiene algun caso especial. El único problema es que sentí las clases muy aburridas pero tal vez es porque comu escrita es muy aburrida en general.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases largas']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, 'a560438de4cdd9e5c4d5d21090583d7bd7b550f7a4b04ff20c5cdf98552b2cce'::TEXT, ARRAY[554]::BIGINT[])
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
