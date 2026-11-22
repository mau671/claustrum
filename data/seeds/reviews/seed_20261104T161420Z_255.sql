-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=255
-- TEC-DATA-META years=2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.017407+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (255::BIGINT, 'El profesor es muy amable y ayuda en el laboratorio explicando temas que tal vez no se entendieron del todo en la teoría de mejor manera.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2025-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'f6a1f4bdb31429738b522240666f8d049370d1cce8b5c561ed175cb07030a2d9'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'El profesor es excelente, superbuena nota y sabe mucho del tema, entonces lo ayuda mucho a uno. Además, sus clases son entretenidas y, con pocas excepciones, cortas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2024-11-27T00:00:00+00:00'::TIMESTAMPTZ, '3f0f4f3bba0f4d790d33e1714cca5796e5780777bbce3f823b6441aab8a5edff'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'Excelente profesor, explica de manera muy clara y da conocimiento práctico sobre cómo funciona la industria. No dude en matricular con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ, '09d98a71e83723566045abf1fced69c3eac0ef9e12cba6c2d292c51a18de4e58'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'Brinda ejemplos de la vida real siempre que puede, se esfuerza por que la clase no sea monótona, y sus evaluaciones son consistentes con lo que enseña. No es un curso difícil ni tampoco regalado... lo que usted da es lo que recibe.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'fe138895dcabcd19ce40daf7578c8fafdcbe57d890f567a7baf344c37850aba6'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Uno de los mejores profes de la escuela. Califica normal, ni suave ni duro. Da buenos ejemplos de cómo aplicar lo visto en clase en la vida real, no hay quices, 3 examenes y un proyecto. El curso es interesante y el profe lo hace aún más.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[], '2023-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'af380689a5a29dd1aec993533016e3e8f977adb7b9e8a9560e1c1cfb116a7cba'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Tejota de profe, de los pocos de la escuela de mante que valen la pena. Da muchos ejemplos de la aplicabilidad de la materia que se está viendo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-03T00:00:00+00:00'::TIMESTAMPTZ, 'a5af1a691f726a5d3080d3b6ecf7d1ff00cb1be3f8e35a10969fd93d923d364f'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Es super bueno, ayuda mucho y hace el curso facil, es bastante comico, califica suave.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'b624df77aa12a82caa05bb1afc43f667f08d277cff969122b687ca6a341ade5b'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'Un profe super divertido y excelente. La clase se hace super amena y divertida por la actitud del profe. En la última clase nos regaló barritas energéticas que él hace.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-17T00:00:00+00:00'::TIMESTAMPTZ, '3a2b1420c510ee53d3c0575ce467cd1484abbda762d0674cd2685af8f0ab849c'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'Presencialmente se manejó muy bien, de los mejores para llevar el lab'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '84684cc86835d8fef107cc21ae3bb932105fd3a49567e0fde99bc3a23fe076a9'::TEXT, ARRAY[3053]::BIGINT[]),
    (255::BIGINT, 'El curso es medio aburrido al inicio, deja 3 exámenes y 3 evaluaciones extra. Los exámenes fueron en form y daba poco tiempo para hacerlos, hay que guiarse bien con las presentación y entender lo que dice en clase. El curso es sencillo, pero aburrido.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '4412ac5a30d76b5d76aaa7fff90e3a7b58086fb5c26141d3ac67600556541150'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Un excelente profesor, ayuda un montón en consulta o clases, califica extremadamente suave y es muy comprensivo. En general ni una sola queja y la mejor opción para el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-19T00:00:00+00:00'::TIMESTAMPTZ, '4123dd15c4eb48226baeb16c371431c74e76b98d40c3f079a71fbade9886dba4'::TEXT, ARRAY[3054]::BIGINT[]),
    (255::BIGINT, 'Muy buen profe, califica justo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-12-23T00:00:00+00:00'::TIMESTAMPTZ, '126537a61d3fdb4af72940166380f162d4964860c1aff43a85c086d528fa392f'::TEXT, ARRAY[941]::BIGINT[]),
    (255::BIGINT, 'Las clases son cortas y concisas. El profe explica bien, lo recomiendo mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-12-10T00:00:00+00:00'::TIMESTAMPTZ, '1e4a9e6a5ea4e4182078cc00904f9f0ad7d7b4e149fbdac9619449fa57e0db83'::TEXT, ARRAY[925]::BIGINT[]),
    (255::BIGINT, 'Como en 2019 lleve predictivo con él, era uno de los primeros cursos que daba en el TEC. Y no me pareció tan buen profe como dicen. Según mi experiencia no lo recomendaría, pero al parecer es buen profe para otros cursos.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2021-07-05T00:00:00+00:00'::TIMESTAMPTZ, 'f759ef9c11952d5f373817c284d6c1249637c437cd8d76cf01baaae3818b143c'::TEXT, ARRAY[120]::BIGINT[]),
    (255::BIGINT, 'Explica claro y revisa justo y suave. Todo es de cátedra entonces no hay mucha flexibilidad, el proyecto es bastante largo, pero se pasa fácil'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'c5d99dcda828ae335f30d1935225f1327f91ebecd1a0845fcea5c3da9b81c93c'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Excelente profe, se esfuerza mucho porque uno aprenda, resuelve dudas, pone ejemplos y tras de eso es divertido. Matricule sin miedo, la dificultad es la del curso en sí.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-03-02T00:00:00+00:00'::TIMESTAMPTZ, '1ab5b850e4efe640bfd7f8bb96ca80fed74bf6492db838c59575e35c06643450'::TEXT, ARRAY[3050]::BIGINT[]),
    (255::BIGINT, 'Hijo de Piedra'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2021-01-26T00:00:00+00:00'::TIMESTAMPTZ, '11998a70eaf64c0d46860c03d3a8995765d84bf6f754922be329704654aa07f1'::TEXT, ARRAY[996]::BIGINT[]),
    (255::BIGINT, 'El profe es muy buena nota y explica las veces que sea necesario.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-23T00:00:00+00:00'::TIMESTAMPTZ, 'b3fee8be83792e5494dae1837138a4020671477d6ad7b73929e019f25d001f9e'::TEXT, ARRAY[941]::BIGINT[]),
    (255::BIGINT, 'El profe tiene muchas disposición a ayudar pero el curso se volvió aburrido al no haber exámenes y se volvió un poco pesado porque dejaron 2 proyectos muy largos pero en general el profe es muy bueno y flexible'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '9477d72b8f356a3c4336c0e1020785d258611e1bb388b4b4bfc9369595592a1b'::TEXT, ARRAY[976]::BIGINT[]),
    (255::BIGINT, 'Excelente profesor. Se preocupa porque uno realmente aprenda y siempre está dispuesto a ayudar, no califica muy duro.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '0459a15377c46b5e10164396be077d0f99493a2e28aaa5fba28c27715fb389b7'::TEXT, ARRAY[3050]::BIGINT[])
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
