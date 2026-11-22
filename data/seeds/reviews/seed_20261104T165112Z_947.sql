-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=947
-- TEC-DATA-META years=2021,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.006462+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (947::BIGINT, 'Se hace llevadera la clase porque procura trabajar eficiente para que podamos ir saliendo antes, pero eso no quita que si se aprende'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-08-03T00:00:00+00:00'::TIMESTAMPTZ, 'b58f8d79a73aa3e8db297d8dbfea6ecce60febb7b437c77a24329f303e76e4f6'::TEXT, ARRAY[554]::BIGINT[]),
    (947::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Deja trabajos largos']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, '27f2e47cc2ca554cce5713df6243ad253b8bc9ab24c0eca18e338fbe43a78503'::TEXT, ARRAY[554]::BIGINT[]),
    (947::BIGINT, 'La profe es muy buena y súper amable, normalmente este tipo de cursos son aburridos pero con ella ni se siente ya que todo se hace en clase, la profe se hace amiga de todos y es muy buena gente, califica un toque duro, es bien crítica pero pues normal. Ayuda mucho.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-11-13T00:00:00+00:00'::TIMESTAMPTZ, '1d6f220198924cefdb3f8c5a8d8f8d8302043123ed26842acab088e05f8629cf'::TEXT, ARRAY[556]::BIGINT[]),
    (947::BIGINT, 'Ella es demasiado linda, califica un poco duro el ensayo final pero el curso se pasa casi solo, solo cumpla con las tareas, aunque parezcan tontas y aproveche el curso.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2023-06-28T00:00:00+00:00'::TIMESTAMPTZ, '7285c4a4dd2465d45d23b2108446cc7cd738d662c8d1cef2356b3b5572bff15d'::TEXT, ARRAY[554]::BIGINT[]),
    (947::BIGINT, 'Muy llevadero. La profe es muy buena notay eso se le agradece para este tipo de cursos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'b5119075c6672ec70dc4bcf83cec8a9622743c5fe713a19579a8b6c8b2244726'::TEXT, ARRAY[554]::BIGINT[]),
    (947::BIGINT, 'La profe es demasiado linda, brinda apoyo, explica demasiado bien, el curso se hace super llevadero. No dude en meterlo con ella, siempre esta dispuesta a ayudar :)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '1bbdbd1c69c9e89f553e54d5f03b57dd58b6ce5eee2bc9d2985c43bec8dccb35'::TEXT, ARRAY[554]::BIGINT[]),
    (947::BIGINT, 'La profe explica muy bien y es super amable. El curso se pasa solo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-08T00:00:00+00:00'::TIMESTAMPTZ, '52464204cd67c96a425295897eb13f8db931db5449457dbfd17f8555aa99be07'::TEXT, ARRAY[554]::BIGINT[])
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
