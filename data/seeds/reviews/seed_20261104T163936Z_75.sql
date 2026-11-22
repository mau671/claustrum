-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=75
-- TEC-DATA-META years=2017,2018,2020,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.302440+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (75::BIGINT, 'Muy linda profesora, fue mi curso favorito del semestre. Matricularía de nuevo con ella 100x100 Apoya mucho, muy comprensiva, con entregar todo se pasa super bien, al menos en este curso no califica duró. No sentí que los quices fueran difíciles pero es mejor ir estudiados.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-06-11T00:00:00+00:00'::TIMESTAMPTZ, '329aa2eed82f9fe66ddf914689c76f19a01723a78ce9490bd1b19790f6da6cd3'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Un amor de profesora, super inteligente y sabe mucho de lo que habla en clase. Sus quices son basados en la materia entonces si vienes estudiado pasas volando. Exámenes son entre todos los profes del curso. Muy cariñosa, pero muy formal.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'af1a709952cb9c00f3f0e425cd2f74f323ceaf6868482d98476a5b00ffeee5bd'::TEXT, ARRAY[3275]::BIGINT[]),
    (75::BIGINT, 'La profe es buena gente pero, las clases son demasiado largas y cansadas. Las evaluaciones son algo complicadas'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Muchos proyectos grupales']::TEXT[], '2024-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'e30952b313b535dca6a3b2d6328f757df60295f0897d77511976a95f1555de94'::TEXT, ARRAY[3305]::BIGINT[]),
    (75::BIGINT, 'Sus clases son aburridas y lentas, explica temas de poca relevancia en biotecnología, sinceramente es una electiva que se puede evitar y optar por otra que aporte más como profesional. Además, sus evaluaciones son bastante complicadas y tiende a evaluar de manera muy estricta.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'Deja trabajos largos']::TEXT[], '2023-11-29T00:00:00+00:00'::TIMESTAMPTZ, '7fd88e3252d77797d278f107c4d390bde4ece64f08fab1ec91398b6fe835bf9a'::TEXT, ARRAY[3305]::BIGINT[]),
    (75::BIGINT, 'Muy buena profesora, hace el curso bastante entretenido y de mucha calidad. Se aprende un montón con ella. La recomiendo. Sin embargo, sus clases se hacen eternas, permite mucho las interrupciones innecesarias de compañeros. No sabe comunicar bien las noticias del curso.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2022-06-24T00:00:00+00:00'::TIMESTAMPTZ, '6ce73ce524f264cf657f0fb8f35a44784264d384fc4e7eef1175f0db0a5bec35'::TEXT, ARRAY[3313]::BIGINT[]),
    (75::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2022-02-21T00:00:00+00:00'::TIMESTAMPTZ, 'e0d6c3cc18cdd25e77ca3ee48874717961128b1f58e442c698e20b03989e4382'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Es una excelente profesora, persona y profesional. Sus clases están hechas con mucho amor y se esfuerza en ser una excelente profe, dos años ha ganado profe del Año en la escuela de Biolo. Califica duro para que aprendamos mas en informes y reportes pero ella da opciones para subir puntaje.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2021-10-05T00:00:00+00:00'::TIMESTAMPTZ, '754ee304daee12cd546b08cd6dc8e0f07dd106a0d8f3201b78c6cf193f6ed1e8'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Excelente profesora, si califica duro los reportes e informes pero si usted le hace caso a sus correcciones, va a tener el resto de esas asignaciones buenas, para los exámenes si hay que estudiar bastante.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2021-07-24T00:00:00+00:00'::TIMESTAMPTZ, '0212f307dd0f395b8b33f9ecb98efd82b8eeede58d13ade525d1bdd3f2dbb31e'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Es buena persona y profesora, explica con mucha paciencia, pero busca la perfección en todos los reportes y los quices, por lo que hay que estudiar mucho y dar lo mejor posible en lo que asigne. Los exámenes son fáciles. Hay que dedicarle muchísimo tiempo al curso con ella. No responde los mensajes.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, '067dbd0fcbdc1cfe579e0812752f11a999d97b662ddbb4c9f4efc945815cbc4b'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'La profe es muy buena como persona y como profesora. Se nota que sabe mucho y tiene pasión por lo que hace. Explica muy claro y es muy ordenada. Pero así como enseña de bien así exige. Ella espera calidad en todo y siempre está dispuesta ayudar. Si solo quiere pasar el curso busque otro profe'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-07T00:00:00+00:00'::TIMESTAMPTZ, '1b88e705d70c599cffa19139919164244f2abf2e50491064150ab0972f4af716'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Es una profesora que explica de manera muy ilustrativa y le gusta enseñar. Utiliza material actualizado y apoya mucho al estudiante si necesita de ayuda. Las giras fueron excelentes. En los laboratorios se aprende mucho con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-09-09T00:00:00+00:00'::TIMESTAMPTZ, '93e4f9ed903b495c890029079b36df5e39974517d725e959d06b5e47df728909'::TEXT, ARRAY[4744, 2650]::BIGINT[]),
    (75::BIGINT, 'La profe es súper pura vida. Siempre está dispuesta a ayudar y mantiene una buena comunicación con los estudiantes. Los profes mandan una presentación con videos para cada lab pero la profe se toma el tiempo de explicarlos por su cuenta. La profe sabe mucho y además es muy guapa (con todo respeto).'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2020-09-02T00:00:00+00:00'::TIMESTAMPTZ, '831931bd10c9b116dbb5b57420077b05a6c6fede7bdd28c3aeba259c3f8c997a'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'La profe esta atenta a contestar las dudas, es muy buena. Si tienen un buen grupo y trabajan bien la profe ayuda bastante. Para los exámenes estudiar bastante.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-22T00:00:00+00:00'::TIMESTAMPTZ, 'cd13bbffb911d61f97033810ec28acf4e23ff5f0dfa8dc19917bbac1903137e2'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Es buena gente, está dispuesta a ayudar y a que uno entienda todo. Le va súper bien si toma en cuenta lo corregido en los informes y reportes siempre y cuando también tenga un buen grupo de trabajo'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2020-08-21T00:00:00+00:00'::TIMESTAMPTZ, '2034098840fefe370c1fbaa92c7082b349eb75cf615f2ad103b54930c72a493c'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Es una profesora sumamente buena! Lo malo del curso es la cátedra, ya que les costó un poco adecuarse a la virtualidad y se tenían un desorden. La profe siempre estuvo super dispuesta a resolver dudas y reconoce a los estudiantes que dan "una milla extra".'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-17T00:00:00+00:00'::TIMESTAMPTZ, '5fe83c6290d6fca88129d4bdb1336984d1bab0b68f91aca4bdbc969f9b28ec1b'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Demasiado buena persona, pero es muy exigente con los trabajos, sin embargo, lo hace por el bien de los estudiantes'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2020-08-03T00:00:00+00:00'::TIMESTAMPTZ, '1e55bfd0b92bde104dfb5168deffaa0cb9851c2cb155c7f3b2296d98df66f06b'::TEXT, ARRAY[1979]::BIGINT[]),
    (75::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-08-29T00:00:00+00:00'::TIMESTAMPTZ, '24f095bf9ecbd9268783df6ff0f6fd6bdb74ae2f13104ead7e92f1a068c70456'::TEXT, ARRAY[3313]::BIGINT[]),
    (75::BIGINT, 'UNA EXCELENTE PROFESORA, QUE EXPLICA MUY BIEN Y DONDE DE VERDAD DE APRENDE. Califica conforme sus clases'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-12-27T00:00:00+00:00'::TIMESTAMPTZ, '3acf79bdd4b1f787d0c6b133f9efa8e06195ba0b64f0373c80c3d2dac4ccd2ab'::TEXT, ARRAY[3305]::BIGINT[])
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
