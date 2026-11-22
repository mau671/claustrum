-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=106
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.833262+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (106::BIGINT, 'Muy bueno el profe, sobretodo para este lab de aleaciones'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'b25d5f3afb56de6176bec5b92fbbd2408884bb49be9a1ca95af0906e81b57a00'::TEXT, ARRAY[2755]::BIGINT[]),
    (106::BIGINT, '10/10 De los mejores profes de la carrera. Si tiene la oportunidad de llevar con él, no lo dude. Se aprende un montón y las clases son muy divertidas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2026-06-01T00:00:00+00:00'::TIMESTAMPTZ, '457b8bfa9d40acbe859371e941bbd3417602210a0f447b4af5741bb4896108fb'::TEXT, ARRAY[2755]::BIGINT[]),
    (106::BIGINT, 'No se complique. Si puede llevar con Fernando, lleve con Fernando'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-27T00:00:00+00:00'::TIMESTAMPTZ, 'e9dde92ad86f3582a21523a73453bd5ee70ce85cdcfe6c5d1d2b1ec9040de56b'::TEXT, ARRAY[2755]::BIGINT[]),
    (106::BIGINT, 'La cabra De verdad sabe demasiado y le va a transmitir la pasión por la carrera. Proyectos super interesantes que son una verdadera probadita de la carrera. Es super relajado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-09T00:00:00+00:00'::TIMESTAMPTZ, '714269c3de206fa426a5db5efcbb5a8090a4923aab2cedddb9696df9e61bc90d'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'Profe Dittel deidad es sin duda la mejor opción para el curso. Explica muy bien la materia, el plan del curso queda claro desde el principio y evalúa de forma adecuada sin duda el objetivo de él es que usted aprenda. Se hace un proyecto final muy genial con él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2025-07-24T00:00:00+00:00'::TIMESTAMPTZ, 'aef2f290c4cfb6d333cc8d61906981f1d530f6727ed3dd0ff1beded592bc2f4c'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'Muy buen profesor, pero igual deja muchos trabajos, si se sienten los 3 créditos que vale el curso'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2025-07-04T00:00:00+00:00'::TIMESTAMPTZ, 'de898026989b636ff5a3ac2863d92177d437b8a46e532da72443ec14290f57bf'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'Es un excelente profesor, da mucho apoyo en los trabajos, siempre dispuesto a ayudar y a aclarar dudas, una excelente persona también, tqm profe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'e48ac632696b9a81ae18b9f57240676ba789a83f5ed7ed8fe18f33323fb758c8'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'Excelente profe lo queremos mucho'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Exámenes retadores', 'Clases excelentes']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, 'f9ebcf2ed69acb1847ecd5d970c0e6f4823e85f7ecf289688434795f97db7004'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'El mejor profe????'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '1e7b92d68852523580a88d7e5b0ce00f485d7bfe7d06b2111d7540afe4a113e5'::TEXT, ARRAY[2733]::BIGINT[]),
    (106::BIGINT, 'Es un muy buen profe, sabe mucho del tema y explica muy bien'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2025-02-25T00:00:00+00:00'::TIMESTAMPTZ, '51ff5da8fe6a39f2b0f6611d52723f47c550dff7ee10afea338531ae00f76b12'::TEXT, ARRAY[938]::BIGINT[])
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
