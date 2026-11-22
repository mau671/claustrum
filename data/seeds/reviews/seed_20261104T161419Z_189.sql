-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=189
-- TEC-DATA-META years=2017,2018,2019,2020,2021,2022,2023,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:19.979007+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (189::BIGINT, 'Me tocó clase asincrónica con él. Pero se aseguró que todas las indicaciones fueran claras; nunca hubo confusiones sobre qué entregar, cómo ni cuándo. Curso muy divertido.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-03T00:00:00+00:00'::TIMESTAMPTZ, '4e578396303f8cef4cde4ee58dcd9b1b70f17d013d715e27195910e42c45c043'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Es un profe muy amable. Sin importar tu nivel de ajedrez vas a aprender más y disfrutar del curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'a5e0701701028a812a877b62e98d64f878faeab0a5be6f0a0e6651b6bff23512'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'No hay clases como tal, pero te deja tarea de casos en el tablero, yo con eso aprendi y es entretenido, si necesitas una deportva esta es facil, no te quita tiempo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2023-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'dc9f2ecd4e3c81352d9bdc7012310e16924a9a0aeed92a9e4de326899d900752'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Se aprende ajedrez desde cero. Es fácil de entender a pesar de ser virtual y asincrónico. El profe no es muy estricto ni complica el curso, Recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-14T00:00:00+00:00'::TIMESTAMPTZ, '7039e0c88ebc17e84ea4483f8f11abfef75841168499ca45724c3b9eaaf8c115'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'El profe es super buena gente. Explica super bien y es muy paciente. Se aprende mucho en el curso y hay 3 torneos. No dude en matricular con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-25T00:00:00+00:00'::TIMESTAMPTZ, '4815e397c92776d428d0f8398c08e1209ef2a942b92e16fdfb845488ae5257bb'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Son asincrónicas, pero el profe es un amor, con que hagan tareas pasan. Al final hace dos o tres torneos de ajedrez, muy interesante. No duden en matricularla'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Inspirador']::TEXT[], '2022-01-29T00:00:00+00:00'::TIMESTAMPTZ, '492497740c0572214bf6faef96776d100cbfe7b472c97e550866735cf6221990'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Excelente profe y el curso es super lindo y sencillo de llevar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2021-11-25T00:00:00+00:00'::TIMESTAMPTZ, '09456f37bc264e3b9512cd86a134f79382cc126a6f9feeb22cba0703c08684d5'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'c43a0476e6ec7a0aec9e6ea0b80fd383e158a520e035945149e751da129ddd6b'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Se aprende un montón de ajedrez. Las clases son asincrincrónicas, pero deja pocos videos. Hay pocas evaluaciones. Si le interesa el ajedrez, vale la pena.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '026fcf083171a64f8129597c9717de8b8406b47591817c8704c324e6781c53c4'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-12-27T00:00:00+00:00'::TIMESTAMPTZ, '5ab13a8bb731d150298868f6b7e2e97d5e4f546ac1a424f37bb629b437f75323'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Clases virtuales asincrónicas. Las disfrute mucho, el profesor es muy accesible y se comunica rápido.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2020-12-26T00:00:00+00:00'::TIMESTAMPTZ, '12686fa3c65e3df6d9e65143d8482ff192a29039f910119f2c0ad4557535ec45'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Muy buen profesor. Paciente, flexible y las clases no hacen nada aburridas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Brinda apoyo']::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, 'bb759ef458357feb1f8d1b45f1a8bc3aeebf6b18ed7cccdb2d68ccf9cb3e73da'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'El profe es muy simpático, hace muchos chistes que lo hacen entrar en confianza a uno, le gusta la participación en la clase, explica muy bien el ajedrez, el es un apasionado por este deporte. Si usted no sabe nada no se preocupe, la clase es súper básica, igual se disfruta aunque ya sepa.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-02-03T00:00:00+00:00'::TIMESTAMPTZ, '4516c2b9321f1c5d5ba178fa208be60ce919922d302985ee43bf89efb70b260b'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'De los mejores profesores que he tenido, hace que uno se interese bastante por el ajedrez. Nota: si no sabe nada de ajedrez y desea aprender no lo piense dos veces.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'f4d5d16e2e32feb39bbccfc1b7284e457c14d249eaf8eb67d4e67ac411480e98'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Ya seas novato o medio sepas jugar, realmente te recomiendo que matricules, puesto que hay algunas reglas que pocos saben y el profesor te las explica muy bien'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-20T00:00:00+00:00'::TIMESTAMPTZ, '311ee68a0729323ec0cad9adc389c4ab1e2d0ca39a70212ea2ca80748ca0d67a'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Excelente en todo. Hace que uno ame el ajedrez. Matricule este curso, es superior a todas las demás deportivas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e99473eb526dba7d88288378c824da98b604d443c09dc530ccb778b5014c3ed6'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Simplemente uno de los mejores cursos, muy entretenido y el profe ayuda a que se vivencie un gran ambiente. Se juegan partidas al final de la clase, se enseñan grandes trucos e incluso el profe hace que te encante el ajedrez.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'a1e2e5108a0b30ce8e964a3f72cef5cd943217a52aadaaf832c60510f3c347bd'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Me pareció muy buen curso, si se aprende bastante de ajedrez, y se juega una partida al final de la clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, '00297c596649d8aa96da461327658336fa355fb5b01c46bd1265e7587ba46086'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Muy buen profe, se aprende ajedrez aunque no sepas nada, enseña tácticas y jugadas interesantes de personajes famosos de la historia, clase entretenida, muy recomendada.el profe sabe mucho, aunque no tolera mucho los errores pero todo bien'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('10','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'c203c1f3b966fef772300b87a02723948b9e62980e040d835488516df42a00db'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Deja un par de tareas regaladas, asistencia obligatoria,este profe hace que a uno le encante el ajedrez.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-11-27T00:00:00+00:00'::TIMESTAMPTZ, '1837e2d2cf8f43595dd5e2a6c34b012c4004035a155447b3833709a5a0c11ca7'::TEXT, ARRAY[583]::BIGINT[]),
    (189::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-19T00:00:00+00:00'::TIMESTAMPTZ, '9869c173105bd5d904f940e33aa9a069188a308ad6ca538accd210c974e83fbf'::TEXT, ARRAY[583]::BIGINT[])
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
