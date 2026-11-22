-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=967
-- TEC-DATA-META years=2018,2019,2020,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.054704+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (967::BIGINT, 'Siento que hace la clase mas pesada de lo necesario, no es complicado pero el proyecto es innecesariamente largo.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2026-04-08T00:00:00+00:00'::TIMESTAMPTZ, '118062e6d3395aa50cf5b692b0dd8483c6deea4d54243e0829d205759ba1e205'::TEXT, ARRAY[92]::BIGINT[]),
    (967::BIGINT, 'El mejor profe de la vida. Me dio clases en la primera conta y eso me ayudó a pasar las otras contas. Se pone en los zapatos de los estudiantes y hasta dan ganas de ir a clases.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'c7e9af77eca9fd859f2201b910c8ee50385a74c712e4380e282ca40e9815ff5e'::TEXT, ARRAY[2358, 1707]::BIGINT[]),
    (967::BIGINT, 'El profe explica bien y uno aprende mucho, pero él piensa que solo estamos llevando el curso de él. Deja muchos trabajos y hay quiz todas las semanas. Exámenes difíciles porque es mucha materia. Es muy divertido y estricto para revisar. Si quiere tirársela rico, no matricule con él :)'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Muchos exámenes', 'Muchos proyectos grupales']::TEXT[], '2019-06-27T00:00:00+00:00'::TIMESTAMPTZ, '3c0d20031c0e90100444f9a857e37e54ea6490f18d99d467c6accead2cd17a20'::TEXT, ARRAY[2442]::BIGINT[]),
    (967::BIGINT, 'Él es excelente, siempre está dispuesto a ayudar. Explica muy bien la materia y de verdad le interesa que uno esté entendiendo. Lo recomiendo mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2019-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'fb82cda061cbd5141cdc2b73f2bdf6d1f36485059714e1c36ef2c7570857ae97'::TEXT, ARRAY[2442]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'dae7785d0eceb4f0e29be7703bc7c52b2e236ecb90522463aa683c018fc872d9'::TEXT, ARRAY[2442]::BIGINT[]),
    (967::BIGINT, 'Con lo poco que he llevado clases con él he notado que le encanta la ortografía. Explica bastante bien en sus clases, es claro a la hora de explicar y deja bastantes practicas calificadas. Con lo poco que he llevado con él he aprendido mas que otras personas que llevan varios semestres en el TEC.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2019-03-05T00:00:00+00:00'::TIMESTAMPTZ, '9cb71fd9a19c7e4b6511d2cdb64503e313555cfe67e471bc5342c1fdfc939625'::TEXT, ARRAY[2442]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2019-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'cf3f226ddb7ba4adf6678126ddffee9a7e7b6d8fb4ef7974240c32e6e9911cb2'::TEXT, ARRAY[1708, 1707, 2361]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra']::TEXT[], '2019-01-22T00:00:00+00:00'::TIMESTAMPTZ, 'b115bff79b626f1b470f0d7b52b0dc51bb20629413799dfd2a15a6321916596d'::TEXT, ARRAY[2361, 2362]::BIGINT[]),
    (967::BIGINT, 'Es el mejor profe! Si tiene la oportunidad matriculen con él. Aprenderán mucho!'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-14T00:00:00+00:00'::TIMESTAMPTZ, '501eedb3d996c5f3dd3098b7f2beecb4794de695d3676d4e25d802de8ba30010'::TEXT, ARRAY[1708, 1707, 2361]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2018-12-31T00:00:00+00:00'::TIMESTAMPTZ, 'abe2e0ebdfebeca9d2357d6c75d1407c2a3f4ed8bf6f6715759cbea609be8843'::TEXT, ARRAY[1708]::BIGINT[]),
    (967::BIGINT, 'Es muy buen profe, se interesa porque los estudiantes logren comprender los temas. Te deja muy buenas bases para los siguientes cursos de contabilidad. Recomendado'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[], '2018-12-03T00:00:00+00:00'::TIMESTAMPTZ, '069b8fb2144c55c81fade81f574a79f6d8e003e62ec37bb3b232f3f5304fbeb1'::TEXT, ARRAY[2358, 1707]::BIGINT[]),
    (967::BIGINT, 'Tiene la vocación para ser un profesor. Se le entiende todo lo que explica, a pesar de que va un poco rápido a veces. Si uno le pone le va bastante bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-27T00:00:00+00:00'::TIMESTAMPTZ, '234be41adc401ebd6bb1d5b9563cd096f4df54e390c9e13fe1474308aada1563'::TEXT, ARRAY[92]::BIGINT[]),
    (967::BIGINT, 'Busca que el estudiante entienda, es comprensivo. Es una increíble persona, explica muy bien, aporta guías muy completas que ayudan un montón. Hay que ponerle en las clases y en el proyecto porque el curso no es regalado. El curso con él no se hace pesado. Más que un profesor, es un amigo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'c35e6992db2f704ebf895fadad9006656aba73d8428abe5497a6f922f8b553ef'::TEXT, ARRAY[294, 1708]::BIGINT[]),
    (967::BIGINT, 'Es un excelente profe! Las clases son súper divertidas, se nota que quiere que los estudiantes aprendan y te ayuda mucho en consulta'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2018-11-17T00:00:00+00:00'::TIMESTAMPTZ, '3cda2eb47043db6f25b8c0d92ca0fc89343d84cae27f403f60f7af52c915f781'::TEXT, ARRAY[1708, 2368]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-26T00:00:00+00:00'::TIMESTAMPTZ, '1f901fc5fc76288a8554eae8ed9820b93016800861253d7fd9258ddeea609c99'::TEXT, ARRAY[1707, 2361]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2018-10-23T00:00:00+00:00'::TIMESTAMPTZ, 'd8adf398615935020dc22c1c46a5a00d60792a80d488bb4eca60eb470f92bc3b'::TEXT, ARRAY[289, 294, 3467]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-18T00:00:00+00:00'::TIMESTAMPTZ, '3908bd9b30649ea97c1c7c44f56f0e596ed11778a8bcc37d18993a00ff227d3e'::TEXT, ARRAY[289, 294, 3467]::BIGINT[]),
    (967::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2018-10-15T00:00:00+00:00'::TIMESTAMPTZ, 'da97643943a3896381150d5710a8cf5b827dde622446b92b2b78127ccd6bb050'::TEXT, ARRAY[1708, 2368]::BIGINT[])
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
