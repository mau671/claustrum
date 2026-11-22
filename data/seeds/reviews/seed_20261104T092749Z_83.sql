-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=83
-- TEC-DATA-META years=2018,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.803444+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (83::BIGINT, 'De mis profes favoritas lo mejor de la escuela'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-08-05T00:00:00+00:00'::TIMESTAMPTZ, '4f4f9c1bb198e8d74a75b845754ea85621fe14c15ab71a02efded9e748b9f9ea'::TEXT, ARRAY[2790]::BIGINT[]),
    (83::BIGINT, 'Profe increíble. Las clases pueden ser muy largas pero realmente se nota que es algo que le apasiona y emociona, por lo que la clase es bastante bonita. La mayoría de trabajos son grupales. 100% recomendada'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '073d693a9b60289632f307b37d7bb666b5007651108ff2819f421ef0f00e2372'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Demasiado buena profe, súper amable y las clases son largas pero ella trata de hacerlas lo más amenas posibles, se le entiende muy bien y los proyectos y actividades en clase que hicimos hicieron que me sintiera segura de mi elección de carrera jajajaja'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ, '4ae3482a7948a1f1ed0251337ea248d75a9690e021da9de5ff6af44f91f69047'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'De los mejores de la escuela de materiales, explica claro, sabe de lo que habla y tiene mucho interés en los cursos que enseña.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-08-11T00:00:00+00:00'::TIMESTAMPTZ, '24d3037293e5eb591969259b3c817313fc14af7734dbcb3c5ae3517eb753fd69'::TEXT, ARRAY[2796, 2790]::BIGINT[]),
    (83::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-01-27T00:00:00+00:00'::TIMESTAMPTZ, '8148f14126d891e07d719a41b9c807a2305aa7ae6606e4108de33c18626f937d'::TEXT, ARRAY[2790]::BIGINT[]),
    (83::BIGINT, 'Hace pocos ejercicios en Mathlab, casi todo es en Excel, el curso es algo confuso pero ella lo hace ver muy facil. Su personalidad es expectacular y ademas en MUY GUAPA motiva ir a clases jaja. No falten a clase por que si no se le puede complicar el curso.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'da2149a34094450e846c52cad9eb8896da720c9aff36f22b42c4328fab71b981'::TEXT, ARRAY[968]::BIGINT[]),
    (83::BIGINT, 'Muy amable e interesada por el estudiante. El curso es tedioso pero ella lo hace bastante llevadero con su personalidad. Además está guapa.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-25T00:00:00+00:00'::TIMESTAMPTZ, '8d545ff4b09f1f1127552840c5e590b04b2f0e058c103eb77adad2bb0df64d89'::TEXT, ARRAY[968]::BIGINT[]),
    (83::BIGINT, 'La profesora hace que el curso sea muy interesante y llamativo, además de que enseña con mucho interés y claridad, por lo que se aprende bastante y hace que el curso sea bastante ligero, a pesar de toda la teoría que involucra'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'd074b716af40e26d881c1f93b5f0d540ce8ffe88795f0e5283f7f7a2c57370c7'::TEXT, ARRAY[1205]::BIGINT[]),
    (83::BIGINT, 'Es una profe muy pura vida. Sus clases son ordenadas y claras, explica muy bien y guía en todo momento con el desarrollo de las fórmulas y procedimientos, se aprende mucho con ella.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2023-01-17T00:00:00+00:00'::TIMESTAMPTZ, 'dab5c10ccc8542da5eec6aaa5e5a4bb1b8ce851b444d795646c5c434114b9e3f'::TEXT, ARRAY[968]::BIGINT[]),
    (83::BIGINT, 'La profe es muy buena, las clases son claras, ayuda bastante y explica super bien. Los exámenes son largos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-20T00:00:00+00:00'::TIMESTAMPTZ, '1fed9097a886d74568276025dbd781e12718d9d39bb76d036d22e7d16be09e7a'::TEXT, ARRAY[968]::BIGINT[]),
    (83::BIGINT, 'Explica muy bien, ayuda mucho con los problemas, el curso es de asistencia libre, los exámenes son algo largos pero fáciles. Es muy guapa.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2022-11-16T00:00:00+00:00'::TIMESTAMPTZ, '010fd68b1db45c3ef0e2aae07461dd7aa4ae07f164a512293bbde48c6b599d2f'::TEXT, ARRAY[968]::BIGINT[]),
    (83::BIGINT, 'Muy buena gente y explica muy bien, nada más que, los quices y examenes son bastante teoricos, hay qu aprender mucho de memoria'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a3a4934fd86e33cd16b43631f66bdfb9cb3a49d6f8c2838fc0b0865cc4ac7f06'::TEXT, ARRAY[1205]::BIGINT[]),
    (83::BIGINT, 'Buena gente, pero las clases se vuelven tediosas (la materia no ayuda). Muchos quices largos y trabajos de investigación, hace un examen final con toda la materia. Pónganle al proyecto final, trabajen con tiempo pues es el mayor porcentaje de la nota.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '599ef3b3d9ac9b687b4217339adf5e0eec677c49bfe1082179b89aaa68b8501d'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Clases muy aburridas. Ella es muy amigable pero no explica muy bien. Califica muy duro.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, '21811e589a0bd0d8f4cd78a4b593b27dea0044286eacbe95386d2c87c47c8a6d'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Se nota que sabe demasiado, buena profesora y muy buena persona. El curso en sí es súper aburrido pero hace que la clase sea menos tediosa y que se pase el rato, califica suave y los exámenes no son del otro mundo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'c54c7edb0a6820ec9eaea2168f7aed098f1a32598883cfedaa73e266b4a4b288'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'd40887e8e133cdc160dbb6711b28724ada4f89f00880b62d0298858164b0c767'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Súper amable, la profe hace el curso menos aburrido y ella sabe muchísimo a mí el curso no me gusto porque era demasiada teoría pero en clases aunque fuera mucha materia ella la hacía un poco más amena y está siempre atenta a dudas que surgan. Muy ordenada con las notas, quices, tareas y proyecto.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-14T00:00:00+00:00'::TIMESTAMPTZ, '069142a9acf33e0dbc2e82554572e2ce01bfcc8ae121985eb93175fee225d0cf'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Excelente profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2018-05-27T00:00:00+00:00'::TIMESTAMPTZ, 'f4ce5eed15a403163c6cb3d45cdea283951a9f29503be8f1ddbcd6328cbcac44'::TEXT, ARRAY[2733]::BIGINT[]),
    (83::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2018-05-18T00:00:00+00:00'::TIMESTAMPTZ, '7f2bbc82bd92fbb4f610bd21a9c1dc47087955c5ddebf9909e29c4349eb8a834'::TEXT, ARRAY[2733]::BIGINT[])
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
