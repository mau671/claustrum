-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=825
-- TEC-DATA-META years=2021,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.249585+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (825::BIGINT, 'Calidad de profesor, es muy carismático y entretenido. Hace que la clase no sea aburrida con trabajos grupales en clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Inspirador']::TEXT[], '2024-01-11T00:00:00+00:00'::TIMESTAMPTZ, '5d1b138f689db5cf000ff91a853373f81f899970949f93e98004d10366a6f4fa'::TEXT, ARRAY[625]::BIGINT[]),
    (825::BIGINT, 'Es un profe muy cómico y carismático, lo cual es muy bueno porque no te sientes mal por fallar en algo de la clase. Sus clases son largas, pero él las hace muy entretenidas y participativas. Lo recomiendo totalmente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-16T00:00:00+00:00'::TIMESTAMPTZ, '64b7e20e15ddf08da52f01725991a07bc029c96a6032e2b472c56682ed123c40'::TEXT, ARRAY[545]::BIGINT[]),
    (825::BIGINT, 'Muy buen profe. El curso es super sencillo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '8e114763e5b7889e238270f58198fcfb2e22e2ce01b2ba554c8ce4997cbd2e49'::TEXT, ARRAY[545]::BIGINT[]),
    (825::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'La participación importa']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '7f985e377516f6a8bc7a3a9a0b7266883f66292b012d8928c795ff4537803aa5'::TEXT, ARRAY[2379]::BIGINT[]),
    (825::BIGINT, 'La clase la divide en dos partes: teoría y practica grupal. Da la clase de forma clara, pero un poco rápida. Todas las semanas deja tareas con una semana de tiempo para entregarlas, las cuales revisa mediante classroom, pero no pasa las notas al tec digital hasta final de semestre.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'b91f4e7ed32fc7bde44b389f491ed6c2e49d9a700ead83da5631f73f83fc7562'::TEXT, ARRAY[539]::BIGINT[]),
    (825::BIGINT, 'El curso es sencillo y el profe buena gente'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, '4173129b30b09cd555984d56fa771bd20ae36419eaf470338b0082772490f40a'::TEXT, ARRAY[625]::BIGINT[]),
    (825::BIGINT, 'Es muy buen profesor, explica muy bien y ayuda bastante. Las tareas, examenes y proyectos son muy fáciles'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'a4b1a1d176ad0d3c1a417bd8abaa6ecf35e35b1f17c3e6fb5530b4c452210fba'::TEXT, ARRAY[2379, 625, 545, 547]::BIGINT[])
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
