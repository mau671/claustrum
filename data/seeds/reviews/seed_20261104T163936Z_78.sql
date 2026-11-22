-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=78
-- TEC-DATA-META years=2017,2019,2020,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.304564+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (78::BIGINT, 'La mejor profe de lab. La extraño.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-08-06T00:00:00+00:00'::TIMESTAMPTZ, '93f5a08d40965f8a003e0ecc28c9cab4ebe7e6768661f07c624e34e11d3efc6b'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es un amor, siempre ayuda y le explica a uno con demasiada buena actitud todo lo q uno le pregunte. Genuinamente le importan los estudiantes, y hasta lo intenta ayudar a uno con cosas fuera de la clase si uno le pide. El ambiente es demasiado lindo. Esa clase era la mejor de toda la semana.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2026-07-05T00:00:00+00:00'::TIMESTAMPTZ, '94ecd2797b1c5a5ef6a7d9767e3cdbccb5b341b0104a15e86ccc3073512046c6'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'Una súper profe, empática y paciente, siempre dispuesta a aclarar dudas. Verdaderamente logré entender la materia con ella y hace que el curso no sea pesado.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'a405435c66f746dffb3498037c74472eae031193ca7e13e1d2c4bd5da319897a'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Exelene profesora, hace la clase bastante amena y lograr transmitir la pasión por lo estudiado. Tambien es muy humana y busca llevarse bien con sus estudiantes. Matricula con ella como primera opción si es posible'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, '6198f6cd8d6e91583ef47ad7c28d7e38674e94554e362a277e2dd22f32088794'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La mejor profe que he conocido, una muy buena persona, te ayuda y te comprende.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-03-11T00:00:00+00:00'::TIMESTAMPTZ, '59a892db0c8455fb32a7e23c16a9f3f87a2ed2e2201870d80880280da2eb69cc'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es demaciado relajada, muy buena onda y su clase es un respiro del resto de cursos. Suele ser casi una clase libre.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '7d6d130599a4cac1e5c2b25860dae4c044fbfd36c0dbe2c9435ec05623291833'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'De lo mejor de la escuela de biología. Es súper comprensiva y siempre está dispuesta a ayudar al estudiante. No dude en matricular con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '1135b51133e5b7368b8de50ab0d17538948a9a72296ff53fd429e3376e0bb2ef'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Increíble profesora, de lo mejor que tiene el TEC. La profe es súper buena nota y muy clara con la materia. Ayuda mucho en las prácticas y se nota que le interesa que el estudiante aprenda y disfrute el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'd5e90174022c58d373deb983392819e421ae7011c16c0c2b96ac4412d6ff78ca'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'La profe es muy tranquila y linda. Sí califica medio durillo pero se pasa súper bien con que sea responsable y entienda lo que haga. Ayuda y atiende dudas sin problema, la recomiendo mucho.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'c572e06700efdaf6e376a00e00355d7dd1e33e76f53cb16be32d769c99924176'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La recomiendo al 100. La clase es genial, explica muy bien de forma que quedan claro los temas, la profe en sí es un amor, los exámenes no son rudos pero obvio hay que estudiar de todas formas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '94678b4eb876c56ed341b2ffddcda558a505138de57be13a22e781921297dbf8'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es genial la tqm, explica super claro y es fácil pedirle ayuda si se necesita. Es muy comprensiva y no se enoja si tiene algún percance con algún trabajo. Se pasa super bien con ella, la recomiendo mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-05-22T00:00:00+00:00'::TIMESTAMPTZ, 'b05803a6f8e80259323da69e60dae8108fcca2b1d375ba78afa732b27760a324'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es muy buena explicando y siempre está disponible para consultas. No se enoja cuando uno se equivoca, más bien apoya cuando es necesario. Super recomendada.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2023-01-21T00:00:00+00:00'::TIMESTAMPTZ, '3e339190fadde9257a43719bf70a119acbdd42f2b663f6d077f07165dfd05a47'::TEXT, ARRAY[3284]::BIGINT[]),
    (78::BIGINT, 'Siempre atiende dudas amablemente, sus clases son muy interesantes y se aprende. Califica duro, pero dentro de lo justo.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2022-07-11T00:00:00+00:00'::TIMESTAMPTZ, 'f1eb6b9a9869780b5136c85a1c33271f0e5b1edfc9645e23ecee4e92bfd0ef02'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es un amor, contesta rápido, explica bien la materia y busca que el estudiante aprenda. Califica de manera justa los informes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '19fbfcaa3357c790bccb9137d5c04654bab2c6a90354ebca061224ea73c19163'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'La profe es super linda, entiende a los estudiantes y responde las dudas con buena disposición siempre, es muy clara y explica muy bien, tomaría más cursos con ella. Los exámenes son presenciales pero ella explica todo bien y califica justo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2022-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'fa24a3721176466d4b7fcc6d60968c2b907cd8f6bc0eea2381e6b418b473b9d0'::TEXT, ARRAY[1979]::BIGINT[]),
    (78::BIGINT, 'Es una excelente persona y profesora. En el lab genera un ambiente de confianza y es muy paciente. Los informes los califica un poquito duro pero dentro de lo justo. Las explicaciones son claras.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2021-07-06T00:00:00+00:00'::TIMESTAMPTZ, '2b66e17ac16044e53b92681ccf05598e53877e5412f7be86fdc30d10a1ecba0b'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'La profe es demasiado buena y paciente, está pendiente para cualquier consulta y si uno se equivoca en el lab no se enoja. Califica duro los informes pero de manera justa. Super recomendada.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-01T00:00:00+00:00'::TIMESTAMPTZ, '7a791abf7bb0e5907913f4968d311c29ee9c5219cdf5369e87c63763f7090b44'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Es excelente explicando y súper atenta con los estudiantes, además de que es muyyyyy paciente. Los informes los califica un poco duros pero gracias a eso se aprende bastante. Definitivamente de las mejores profes de la escuela'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '48b4b85c7c962f550c8649c250eaec94adfb8f88120ccf8c413af22ca7437020'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, 'b4a81d157bfe9fc132eff0a3ef19771bce3b567d2b9ddc620f4073dddd5e7343'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Me encanto llevar este curso con ella. Super amigable, justa y hace la clase interesante. Responde lo que uno le pregunta. Realmente genera un ambiente de confianza :D'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-07-25T00:00:00+00:00'::TIMESTAMPTZ, '9f705cb5d304eb9a6c118edea73dfda9b6ba5da3bd98a328bec4826bda682e4c'::TEXT, ARRAY[3267]::BIGINT[]),
    (78::BIGINT, 'Excelente profesora, como persona es un amor, explica super bien y califica los quices justamente. Se recomienda matricular con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-11T00:00:00+00:00'::TIMESTAMPTZ, '62b53605af49140cfa5830e7932532efd2354ccca180580dfa32ab79229e82f7'::TEXT, ARRAY[3267]::BIGINT[])
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
