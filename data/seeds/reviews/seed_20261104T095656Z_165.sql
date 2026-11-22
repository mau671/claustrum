-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=165
-- TEC-DATA-META years=2018,2019,2020,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:56:56.136054+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (165::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, 'aa69acc7e88a720b75c171d065b79452dcbec210937f587ea89d201ee424ee78'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'Un excelente profesor!! Estimula la creatividad y pensamiento crítico del estudiante y sus clases son muy amenas y participativas. Calidad de profesor y persona!! Súper recomendado!!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Clases excelentes']::TEXT[], '2022-07-23T00:00:00+00:00'::TIMESTAMPTZ, '23de80ce2f88ac01775d80e5c7224d76790aa4df5aa298b9b25c56f502920edc'::TEXT, ARRAY[890]::BIGINT[]),
    (165::BIGINT, 'Muy buen profe, las clases son interactivas, todas las clases dejaba un trabajo que se hacía en el mismo horario de clase y eran fáciles, preste atención porque hace preguntas constantemente'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, '2aa80827f9b48d4127a16c1c101fcdf6d40d4d458a50f6d5c107d51021f705e0'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'Teja de profe, hace corta, entretenida y practica la clase, hace que todos participen por lo que lo tiene atento a uno y con eso si algo estricto, todas las semana habia algun trabajo que hacer por lo que una ausencia injustificada podia hacer que se perdiera ese trabajo, pero super bueno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2021-07-01T00:00:00+00:00'::TIMESTAMPTZ, '8c1919f7cba7fc1b65bb774ed335c108992a3af49c93472206d171e92d6044aa'::TEXT, ARRAY[539]::BIGINT[]),
    (165::BIGINT, 'Tarda en contestar, deja trabajos y evaluaciones sencillas. El curso se hace de 1 crédito por el tiempo que recorta y la facilidad de las tareas.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'b21c863aa1adff5b081e5a96ba718d12771f8a3f9397e83f6e52f0ec0023e635'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'Se vuelve un compañero de clase, trata de hacer cómica la enseñanza de inglés. Es un profesor muy buena nota.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '50e54821c3e0cf856762096c47c1dc234a74ad1071038e4279cf7eed3194b51f'::TEXT, ARRAY[539, 545, 625, 547, 2379]::BIGINT[]),
    (165::BIGINT, 'Es un crack, se aprende un montón en sus clases. Es una excelente persona y un buen profesor. Le gusta mucho hacer la clases dinámicas y divertidas lo cual hace que se pasen rápido. Hace bastantes quices, la mayoría son fáciles. Usualmente califica suave. Se nota que ama lo que hace!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2019-06-17T00:00:00+00:00'::TIMESTAMPTZ, '1898df32aafe19c40a55833845e15305e6d07edb0de2cc58d58d53454a74c2fd'::TEXT, ARRAY[625]::BIGINT[]),
    (165::BIGINT, 'excelente profesor'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2019-04-10T00:00:00+00:00'::TIMESTAMPTZ, 'cd9b4d22b3276b53a4d62717a4f03612e9d494f21acc5d25d3de5d3f3cb1ff16'::TEXT, ARRAY[625, 545, 2379, 547]::BIGINT[]),
    (165::BIGINT, 'Excelente profesor. Sabe mucho, enseña inglés de manera divertida. En verano es super suave. No hay que pasar al frente de toda la clase a hablar sino que se hace con un compañero (menos estrés). Recomendado!!!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2018-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'def848eaf548d9b916d9af67fa3e55c014988dd11e365fe4888814716babdd38'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'Buen profe.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2018-11-19T00:00:00+00:00'::TIMESTAMPTZ, '235bfc33282fabc784af52d1004c5f6333548fec604440a9e3c9238b58b35dbf'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'Excelente profe, muy agradable. Usualmente hace quices en parejas de conversar, se aprende mucho!!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'e0208e09da3ce72cf497ad21c81a95b8e99ad97e0ba7a27f3601304d7056d22a'::TEXT, ARRAY[545]::BIGINT[]),
    (165::BIGINT, 'El profe es muy pura vida, hace muchos quices y examenes en clase y califica suave. Hay que ponerle mucha atención cuando imparte la clase. Y se aprende mucho con el.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Muchos exámenes', 'Aspectos de calificación claros']::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'e2f4b1ab90e145b602e1726187b670e5475dda8215fe7813329fb605cd7b1ba2'::TEXT, ARRAY[539]::BIGINT[])
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
