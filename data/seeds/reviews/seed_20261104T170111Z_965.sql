-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=965
-- TEC-DATA-META years=2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.052994+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (965::BIGINT, 'Demasiado buena esta profesora'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-12T00:00:00+00:00'::TIMESTAMPTZ, '4cae72c61d1085ed81c67abfe3c79c6746a6d8dfdc8726547872d007921ce24b'::TEXT, ARRAY[554]::BIGINT[]),
    (965::BIGINT, 'En general se pasa bien, no es difícil. La profe es muy cómica, hace chistesillos pero honestamente aveces se siente pesado recibir sus clases por la duración y que en general no es un curso muy divertido'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2024-01-08T00:00:00+00:00'::TIMESTAMPTZ, 'e3bac4bb3272480221ec01ade07a673826e08ba6258b42ae720daf4d1ceafdd0'::TEXT, ARRAY[600]::BIGINT[]),
    (965::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-20T00:00:00+00:00'::TIMESTAMPTZ, '8197813af4626db7756be13dc8e0f2548f70d158597179a0dc75f6d9afee75ea'::TEXT, ARRAY[554]::BIGINT[]),
    (965::BIGINT, 'Profesora súper organizada. Deja muy en claro las instrucciones, hace la explicación teórica y luego pone práctica en clase llamando a cada persona para comprobar que entendió. Deja unas cuantas tareas sencillas. Le gusta que colaboren y no falten el respeto. Se aprende mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, '556a621138ff813651c06c58a6fa861d074a35cea1416aa68729fc94149abb9e'::TEXT, ARRAY[554]::BIGINT[]),
    (965::BIGINT, 'La profe es muy ordenada para las evaluaciones y actividades que se van a hacer, desde el inicio deja muy en claro los aspectos a evaluar y las actividades. Ella no se complica mucho, es una clase sencilla pero buena. Además es muy buena gente, tranquila y hace muy llevadero el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-10-09T00:00:00+00:00'::TIMESTAMPTZ, '9596db7b0501fe15711f108a92ac630b475aed97159eadb4cc0eb231cbc1b9c9'::TEXT, ARRAY[600]::BIGINT[])
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
