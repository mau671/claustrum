-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=778
-- TEC-DATA-META years=2021,2022,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.862916+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (778::BIGINT, 'La clase de Raziel es excelente, pero su rúbrica incluye tareas de 20 páginas mínimo, exámenes de 4 h o más. Lo más decente es el proyecto (igualmente difícil) pero las evaluaciones son tan largas que la revisión te llega el día antes de la entrega de actas porque ni a él le da chance de revisar.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Deja trabajos largos']::TEXT[], '2026-02-26T00:00:00+00:00'::TIMESTAMPTZ, '4946cee8df7616ab59b6acf6dfe3884c6d0a42a8f553631b62aafa6e38069ae6'::TEXT, ARRAY[4146]::BIGINT[]),
    (778::BIGINT, 'El profe sabe mucho, pero hay que sacar demasiado tiempo para los bretes y redactar informes muuy largos. Evaluacion muy poco clara, si uno no redacta como el quiere le baja muchos puntos. Va a aprender y pasar pero el curso requiere demasiado tiempo y es bueno que lo tomen en cuenta.'::TEXT, 2.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2022-11-18T00:00:00+00:00'::TIMESTAMPTZ, 'b515f53079639a31b1621df14b132988c7696497d1d26f2670b860d292eae114'::TEXT, ARRAY[4145]::BIGINT[]),
    (778::BIGINT, 'El profe es super bueno explicando y las clases son super divertidas y se aprende más de metrología en este curso que en todo el resto de la carrera pero es muuuuuuuuuuuuy difícil porque el profesor es super estricto con los informes que son casi toda la nota del curso.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Inspirador', 'Brinda apoyo']::TEXT[], '2022-01-15T00:00:00+00:00'::TIMESTAMPTZ, '1b8551e902cfbe8c019a70a8c7e05d2a532735b29da067ded4b3d98238d83d0d'::TEXT, ARRAY[4145]::BIGINT[]),
    (778::BIGINT, 'Las clases son claras y se aprende bastante, pero sí evalúa los informes muy rudo, cualquier cosa que diga "opcional" hay que ponerla o baja puntos, además no entrega los informes revisados hasta como 6 semanas después'::TEXT, 2.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Deja trabajos largos']::TEXT[], '2021-11-29T00:00:00+00:00'::TIMESTAMPTZ, '82993eb4f1c3be2eb6ae7b837739d02d8712afc3ae49da8fda764e716fbf908f'::TEXT, ARRAY[4145]::BIGINT[])
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
