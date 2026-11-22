-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=684
-- TEC-DATA-META years=2021,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.853761+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (684::BIGINT, 'Excelente Profesor'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, 'cced5bce75e42d45607e460bb008b3b6a97565e97ad3e28f75df2f39dd3718b9'::TEXT, ARRAY[2604]::BIGINT[]),
    (684::BIGINT, 'Curso Excelente 100% recomendado. Ojalá la Escuela tuviera más profesores como Rooel'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, '58a584237f627f912b0b31823f261dd981ede6d7c9041b671cf371d6c49d954f'::TEXT, ARRAY[3208, 3104, 3133]::BIGINT[]),
    (684::BIGINT, 'Excelente profesor. Desearía más curso con él.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2024-09-27T00:00:00+00:00'::TIMESTAMPTZ, '446e82afc0bd9271fee81d65812fae2eba2bb8294b2516fa4bf8b73936b41e94'::TEXT, ARRAY[3208, 3104, 3133]::BIGINT[]),
    (684::BIGINT, 'El curso no es fácil pero el profe realmente explica bien'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Exámenes retadores']::TEXT[], '2024-06-18T00:00:00+00:00'::TIMESTAMPTZ, '2f1d5116ec56c9bbcc7cd097f61c2e3c25264562a1ae3658304e8af88c9fdf99'::TEXT, ARRAY[2604]::BIGINT[]),
    (684::BIGINT, 'Excelente Profesor. El curso es duro, pero tiene un dominio total de la materia, da muchos ejemplos prácticos y totalmente claros'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-11T00:00:00+00:00'::TIMESTAMPTZ, '84a2a494dd72a55f11fb72a425575f3598b5d95ef0ccd44681a1042361a2e3dd'::TEXT, ARRAY[2604]::BIGINT[]),
    (684::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2024-02-06T00:00:00+00:00'::TIMESTAMPTZ, '845bd4a29d8179b9bd815ed99151c6c2b6104e440974ccb6901b8c7d6285f8bc'::TEXT, ARRAY[4157]::BIGINT[]),
    (684::BIGINT, 'Excelente profesor. Dominio total de la materia'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2023-11-02T00:00:00+00:00'::TIMESTAMPTZ, '2e600289ad13651b77d0fbd813d4788c5871261dfcb2ccbc3d53ac65d7fad719'::TEXT, ARRAY[3208, 3104, 3133]::BIGINT[]),
    (684::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[], '2023-10-18T00:00:00+00:00'::TIMESTAMPTZ, '280a87c5121dd8e16848f7ef49ea28e9d566a197f7d4e0f65a01ce348149ae67'::TEXT, ARRAY[3208, 3104, 3133]::BIGINT[]),
    (684::BIGINT, 'El curso es muy llevadero, con el profe todo se entiende y no califica duro'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-09-18T00:00:00+00:00'::TIMESTAMPTZ, 'a8cd0b6983e106a4bdff75747e3c10584923e6e1592222845aabe57b7c6d13b9'::TEXT, ARRAY[1763]::BIGINT[]),
    (684::BIGINT, 'Excelente dominio del tema'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2021-09-08T00:00:00+00:00'::TIMESTAMPTZ, '252e5fd3f2720ff7bad4b3823265d970c72fe842cd15593f25e179ba66631a51'::TEXT, ARRAY[2639]::BIGINT[]),
    (684::BIGINT, 'Explica muy bien, es claro durante las clases, sin embargo, los trabajos que deja son largos y mas completos, incluyen cosas a las que no se les hace énfasis en las clases'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos']::TEXT[], '2021-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'e8508a325e57d0ed16548594978aac9c5bceb089f3210ff67b5808ee8ba719ed'::TEXT, ARRAY[2603]::BIGINT[])
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
