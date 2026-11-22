-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=415
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2020,2021,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.213487+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (415::BIGINT, 'Simplemente no sabe enseñar.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-08T00:00:00+00:00'::TIMESTAMPTZ, 'b3935f2b832da098ea4105aab850f28ea4bba321aa40f825fb1fbb30cd7ab6a8'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Parece que sabe mucho, pero NO es bueno enseñando'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-09-03T00:00:00+00:00'::TIMESTAMPTZ, '6cbc7f1049353bbe570b49c05a8156004e693b536b7c1c1d990ebc15279bce6d'::TEXT, ARRAY[1323, 1325]::BIGINT[]),
    (415::BIGINT, 'El profe sabe demasiado, aunque aveces las clases pueden ser no muy entendibles por eso mejor aclarar todas las dudas. Exámenes medio rudos y aveces se pone muuuy creativo. Las tutos ayudan bastante a prepararse para el examen'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, '5b23ba1b9e43ccdaeaf1746aee149278637062e1bb78655ae40f6b559dd72cbf'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'En virtual la teoría se ve en asincrónico y las dudas sincrónicamente, si lleva todo al día aproveche para sacar dudas. Las tuorías son largas, los exámenes son un poquito díficiles pero pasables. Para el proyecto, en los apartados busque relacionarlo con los temas del curso.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-06-27T00:00:00+00:00'::TIMESTAMPTZ, '60bbff444ea2c88967cee9f1657fc6e69f0b37ce62da1e4f41b188ea49bfe7e6'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Este mae es un genio, es brillante, pero simplemente no es un buen profe. Clases de pura teoría, el mae solo lee las presentaciones y habla muy rápido. En consulta ayuda más.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-12-07T00:00:00+00:00'::TIMESTAMPTZ, '5d1d67079a62824a157303e6e188a1184268fbf91c55dc9cc9f68bce556c4914'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Sabe demasiado, por lo que se emociona al explicar y muchas veces asume que uno sabe muchas cosas pero explica muy bien cuando se le pide que explique de nuevo.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2020-01-29T00:00:00+00:00'::TIMESTAMPTZ, '186facc3209071d4ba63087543a8d978894d1d93286d0f0fe2863d7a83e4e2ca'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'No tengo forma de agradecerle a este señor lo interesante y entendible que hizo el curso de Comunicaciones Eléctricas I. Sabe demasiado de la materia, deja mucha práctica antes del examen y califica suave. Eso sí, hay que aprenderse las fórmulas y las tutorías entregables son muy largas.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2020-01-21T00:00:00+00:00'::TIMESTAMPTZ, '48818391aa97dbec09d08436b2014cbf1e5b008cd94f43e8eb88d54f57738f1a'::TEXT, ARRAY[1323]::BIGINT[]),
    (415::BIGINT, 'Buen profesor, se nota que domina el tema y en general los contenidos del curso son fáciles, en clase da teoría y da mucho entorno de lo que habla, en que se aplica y cosas así. Hay tutorías que se pueden hacer perfectamente uno mismo y sirve para orientarse de que viene en el examen'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2019-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'b47e5ad5faf00218e6257bdc2d2fadd87f5979ea5a5eea70e6d28a93f903c586'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Se nota que sabe demasiado pero no es profesor. Sus clases consisten en casi dos horas de él hablando rápido sin para mientras nadie entiende nada. Casi no hace práctica en clase y se nota que nadie le esta entendiendo pero aun así sigue dando la clase a su ritmo'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2019-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'c3acbd35d7681b66064f65775af6a41346396d3b4fb97c07bb5ff16b5cbdec89'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Con un ejército de compas haciéndole el brete XD'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-08-21T00:00:00+00:00'::TIMESTAMPTZ, '728c49848212b38ce914fb89c8acc27a7cdcce1621ae01c316ba2795ec50f23e'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Explica bastante bien la materia, si uno tiene dudas se detiene para responderla. Es un buen profesor.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2019-07-16T00:00:00+00:00'::TIMESTAMPTZ, '831117d8c0032b040fba8ba9a27b992b1dcb43b1cb5522b09447ad3ad341a8e2'::TEXT, ARRAY[1325]::BIGINT[]),
    (415::BIGINT, 'Quién le dijo que es profesor?'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'a3ef5eb3e2aaf122a208bb936e29bd26ae474a669c6096db881903dafaedd4c5'::TEXT, ARRAY[1323, 1325]::BIGINT[]),
    (415::BIGINT, 'Es curso es bastante difícil pero el mae sabe demasiado a veces va bastante rápido pero en general es muy bueno y muy pura vida'::TEXT, 2.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-24T00:00:00+00:00'::TIMESTAMPTZ, '4cc8a963a2f7df46affc36ca6da7268a634aa7b10e2a4c6c1a0b344a9d7a5114'::TEXT, ARRAY[1323]::BIGINT[]),
    (415::BIGINT, 'Va demasiado rapido y no se le entiende mucho. Las clases son aburridas y los examenes son rudisimos pero es el profe que mas suave califica y tras de eso hace curva. Se aprende mucho mas que con Nestor pero puede resultar complicado'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-15T00:00:00+00:00'::TIMESTAMPTZ, '6d8f6d8695d9156a29e6ef6e934a95c360a33a6df87fc72131086d211bcfbaac'::TEXT, ARRAY[1294]::BIGINT[]),
    (415::BIGINT, 'Un curso sumamente dificil con él, cuesta entenderle de lo rapido que ve la materia. Los examenes son muy dificiles tirando a imposible, evalua normal'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'f8106d6d12eacdcf4c7427e2dd1507f2391b1afd3de9b328d6e921a572728a39'::TEXT, ARRAY[1294]::BIGINT[]),
    (415::BIGINT, 'Pésimo,no se le entiende nada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-05-01T00:00:00+00:00'::TIMESTAMPTZ, '6537e9574546fda2fab65ef6b4829e2716d989c4fe459a8492f47916428bfb5a'::TEXT, ARRAY[1294, 1307, 1359, 1334, 1310, 1295]::BIGINT[]),
    (415::BIGINT, 'En verano es bastante acelerado. Él habla muy rápido y aveces cuesta entenderle o se confunde por lo mismo. Es un crack y domina muy bien los temas. Los exámenes son interesantes...por eso hay que estudiar bastante.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'f64d4a67109b69dc1ba1512bf405f2e7ebf4051338732bb23ec6de8706513e20'::TEXT, ARRAY[1294]::BIGINT[]),
    (415::BIGINT, 'El mae es un genio, explica muy bien y califica tomando en cuenta la dificultad de los exámenes'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-19T00:00:00+00:00'::TIMESTAMPTZ, '073b592be5fb3e4da826d26f99cd54ce0bef512f13e80ed53b10803ff4405f03'::TEXT, ARRAY[1294]::BIGINT[]),
    (415::BIGINT, 'Habla demasiado rápido, el mae es un excelente Doctor/Ingeniero pero pésimo profesor...'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, '9eefa20d6ce7405dbce7d5e72200b0a1b694befac7ba3881c0a022dbd2de285f'::TEXT, ARRAY[1307]::BIGINT[]),
    (415::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-15T00:00:00+00:00'::TIMESTAMPTZ, '4307f1f06c84b25bd90a2436f33aaf3007996afa15a6c774cfb27c8d2126d824'::TEXT, ARRAY[1270]::BIGINT[])
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
