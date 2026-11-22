-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=713
-- TEC-DATA-META years=2019,2020,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.877478+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (713::BIGINT, 'Este profe es como: Tarea 1: Aprenda ruso nivel nativo, escriba un ensayo de 1 hoja Tarea 2: gradúese de compu y atienda consultas de clientes Proyecto 1: estudie 5 semestres de electrónica en 5 semanas para que arme este aparato. Apunte lo que dice oralmente en clase porque sale en el examen.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2023-11-07T00:00:00+00:00'::TIMESTAMPTZ, 'cf462cdd7bcf0dceea9ff91770fe13a3295f9c38e178bfe5b7cc62bc74994b14'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'En clase es muy claro y ordenado. No maltrata mucho calificando. Atiende preguntas. Los trabajos que deja suelen ser muy, pero muy densos, y es relativamente difícil encontrar información sobre cómo resolverlos. Recomiendo siempre sobreestimar la cantidad de tiempo necesaria para completarlos.'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2023-06-20T00:00:00+00:00'::TIMESTAMPTZ, '0d1a5337f6cfa8daff81409c8716e934c73e30fdbd3b05cb89a69cde13d7ba60'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'En virtual. El curso es muy denso, se ven muchos temas, es muy interesante, pero si se debe poner atencion e intentar llevar la materia al dia. El profe sabe mucho de los temas que habla, y si pregunta siempre da retroalimentacion e intenta ayudar, mas no le va a regalar la nota. Pongale de una.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos exámenes', 'Clases excelentes']::TEXT[], '2022-01-11T00:00:00+00:00'::TIMESTAMPTZ, 'a219aa45cfbd0e1f389d409fcb23b67eefdb68c72790116f4e417629c62d4d83'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Es un profe demasiado bueno. Explica justo lo que se necesita saber, da muy buena retroaolimentación y ayuda. Es super claro con las instrucciones y le gusta que las cosas se hagan rápido. El curso de Micros es muy chuzo y recomiendo llevarlo con él se aprende bastante, los trabajos son muy chivas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2021-12-22T00:00:00+00:00'::TIMESTAMPTZ, 'c97048a8c113971a35fe262281301971d7cb9b6700ad650966a39c66622322f4'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Muy buen profe. Ayuda mucho en cada consulta, y explica la materia muy claramente. Habla rápido, pero a lo largo del semestre uno se acostumbra (o si no también es posible ver luego las grabaciones de la clase). Además, califica justamente. En general lo recomiendo, es de los mejores en meca.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2021-11-17T00:00:00+00:00'::TIMESTAMPTZ, '97c5a90a35de1d3d0d20832dc66b26eeeb4413dc0871fed09fc6664e89c50a92'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Ordenado, objetivo a la hora de calificar, domina la materia del curso y siempre responde muy bien a las dudas o consultas. Desde mi perspectiva, el mejor profe que hay en Meca.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-09-14T00:00:00+00:00'::TIMESTAMPTZ, 'fd0d8afdb04c605b32b739d4e74fad8922324b8dc0596a632f5a6f9ccd7b38bd'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Un profesor muy ordenado y organizado, bastante bueno en lo que da, sabe bastante y uno siente que está aprendiendo cosas que la van a servir para la actualidad y no varas desactualizadas. Califica MUY rápido las evaluaciones.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'a05b49bb01b050313f5e5728acbcd6cc801d2c9ed279679173272be199640860'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'El profe es una teja. Sí explica muy rápido, pero como se graban las clases no hay tanto problema. Maneja muy bien la materia y si alguien no entiende, él sin problema se devuelve a explicar. El curso es muy difícil, pero bastante pasable si haces todos los trabajos lo mejor posible.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Inspirador']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, '97fbcfbd7b7f2e44fcd633a89ba9f420e943f5e3762346a390bba9f84b3456d5'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'En camino a ser el mejor profe de Meca, es serio, imparcial al calificar, explicar súper bien, se adaptó muy bien a la modalidad virtual. El curso en sí es MUY difícil, pero con él se aprende. Solo le falta confianza para dejar de lado las tediosas presentaciones de Yeiner y enfocar mejor el curso'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2021-02-04T00:00:00+00:00'::TIMESTAMPTZ, 'ea605c5f35699b0ebb8536e1fee7334c1be16d8b1088bbba3fbf7d76a2fe6a0f'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Excelente profesor. Se adaptó muy bien a la virtualidad. Él explica MUY rápido, pero si usted es lento, mejor vea los videos con paciencia. Él es imparcial y literal al revisar, pero muy profesional. Es de esos profes que realmente te prepara para la vida. Disfruté el curso con él. Recomendadísimo!'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[], '2021-02-01T00:00:00+00:00'::TIMESTAMPTZ, 'ece853ffa7b20a81fceebacfe7d3c76c00b8290ce1226b5d734e27725aba7b90'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Un excelente profesor, realmente se nota el interés en el proceso de aprendizaje y además es comprensivo en caso de necesitar cambios en el cronograma. El curso no es regalado, se aprende bastante. Lo único es que la clase va como a teja veinte, entonces hay que morderse bastante.tip:getadreamteam'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2021-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'd83d71a514ef12a7902c269d7071cd5f9cbc0755b1289fa3f52b3690e43012be'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Muy buen dominio de la materia pero va muy rápido y a veces le cuesta darse a entender. El curso es pesado pero él califica justo'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-29T00:00:00+00:00'::TIMESTAMPTZ, '7f3516d0fde4d13fdd955c7d7c013e4dfffe2773319852220c543a5b92776bc2'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Es sumamente profesional e imparcial evaluando. Usted debe poner de su parte, pero se aprende bastante en el curso.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'e1fa3917930feaabfc39478f1bc163328496d0eef870ede94c16ea0181cbe43e'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Va bastante rápido con la materia pero la domina a la perfección, si ayuda bastante y explica las veces que sea necesario si le pedís que lo haga, es flexible con evaluaciones y busca siempre la manera de ayudar. Con la pizarra es un poco desordenado entonces hay que prestar MUCHA atención.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2020-02-03T00:00:00+00:00'::TIMESTAMPTZ, '0bc59779b41e71d72555a952b887d6c9f528e8f61e20c7255cfa9a83464271be'::TEXT, ARRAY[3066]::BIGINT[]),
    (713::BIGINT, 'Un profesor joven'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Pocos exámenes']::TEXT[], '2019-05-20T00:00:00+00:00'::TIMESTAMPTZ, '5af6869edea265d17ad9ff2a5c4bbcc9f1ffea022d6fe3d7ed9c4595f3b08ea5'::TEXT, ARRAY[3066]::BIGINT[])
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
