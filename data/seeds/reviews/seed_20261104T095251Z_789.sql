-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=789
-- TEC-DATA-META years=2016,2017,2019,2020,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.474601+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (789::BIGINT, 'Es el mejor profe de Forestal, la participación importa muchísimo, los exámenes y laboratorios son super super difíciles pero el profe trata de ayudar siempre, si te esfuerzas y pones interés él te lo reconoce y termina ayudando mucho. Le interesa mucho la vida de sus estudiantes.'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Exámenes retadores']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'ba8bf9ce6dad35f1c389ab3566ff1ad5480fd9d8fbb8bf17b0b4814846ebd840'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Es una persona super buena, clases magistrales, carismático y abierto a cualquier consulta.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, '03cec3c474e32044c15a6c23a2ca45a3cd020bc31e8766b31cd1ba22083343bf'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Excelente profe, le apasiona lo que hace. Brinda apoyo a los estudiantes y es muy atento, vale la pena tomar clase con él. Los cursos no son fáciles.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-02T00:00:00+00:00'::TIMESTAMPTZ, '7ecdbd67778b6252e9a77ff55684c30d89a0b8edcece3f25cb439aaa66161e7e'::TEXT, ARRAY[2166, 2161, 2160, 2162]::BIGINT[]),
    (789::BIGINT, 'Edwin sabe muchísimo. Con él se aprende sí o sí porque el curso no es fácil de ganar, hay que ponerle mucho pero, siempre está dispuesto a ayudar por Whatsapp o incluso en Teams.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2021-02-01T00:00:00+00:00'::TIMESTAMPTZ, '6d641c99c35bea166c52092f11811914bd0f287f3429ea9536e2a82133605fb0'::TEXT, ARRAY[2139]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Aspectos de calificación claros']::TEXT[], '2021-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'ed6bd3c74df4d62fde794a6c832c76b2a73c15816f7963e5ade11473a2207a4b'::TEXT, ARRAY[2159]::BIGINT[]),
    (789::BIGINT, 'Uno de los mejores profes de forestal, es una excelente persona, además siempre está disponible para ayudarte y crea un ambiente de confianza entre los estudiantes. Enseña muy bien, pero debes estar interesado porque si te tiene que reprobar te reprueba.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases excelentes']::TEXT[], '2020-08-03T00:00:00+00:00'::TIMESTAMPTZ, '1e5f10f85606d16a61c14307e1b602b95eddc2c61be974232bb977b2e4c79f67'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Se nota que le gusta lo que hace. Sabe demasiado. Siempre ayuda al estudiante si este muestra interés en sus clases. El curso es duro pero se aprende mucho.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Exámenes retadores']::TEXT[], '2020-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'c332005085b1277b7fd1f0522f933b19afba089dd99db380b44bb54477844e54'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2019-11-28T00:00:00+00:00'::TIMESTAMPTZ, '524ba80d750f0f8ee0247f2d60c369388ace9edf4229a5a45ea33d4b7ae0cc3d'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-09-12T00:00:00+00:00'::TIMESTAMPTZ, '91511c8df4e67f15e27faed75de8a6a9838f58111d93b40bbfa908246294f5ba'::TEXT, ARRAY[4314]::BIGINT[]),
    (789::BIGINT, 'Dependiendo del curso puede ser rudo, pero el profe siempre está dispuesto a ayudar y siempre se interesa mucho por lo que esté pasando el estudiante. Ama lo que hace así que lo hace muy bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2019-08-17T00:00:00+00:00'::TIMESTAMPTZ, '5f6a751eaf1b341eea8308177de83568fa6324a4f6461d11251f2449d17931f0'::TEXT, ARRAY[2130, 2131]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Clases excelentes']::TEXT[], '2019-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'ea04f6d705000e18ae832c58b80f564d809a7d2cd2b78ebc77534aa10bef50df'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Buen profesor. Hay que ponerle y cumplir con todo para ir bien. Entiende a los estudiantes.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2019-06-11T00:00:00+00:00'::TIMESTAMPTZ, '676582cb180a201e370333afdad28265c45f9aca249fc08a18322985b225755f'::TEXT, ARRAY[2130]::BIGINT[]),
    (789::BIGINT, 'Excelente persona, excelente profesional en la materia.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2019-01-31T00:00:00+00:00'::TIMESTAMPTZ, '30241c9236b39a054970dcd6e48a716180eaedc70d1cf04355bdd5b03b63655d'::TEXT, ARRAY[4314]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2017-11-22T00:00:00+00:00'::TIMESTAMPTZ, '0d08458f44a2175e8f87981f81c881faf7ff6bae8731f6687974cb4a7279f7ff'::TEXT, ARRAY[2131]::BIGINT[]),
    (789::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, '068dd614ffabaf677486b39eb9d521c94967bc307d2cbfd87281d203a46406e2'::TEXT, ARRAY[2166, 2161, 2160, 2162]::BIGINT[]),
    (789::BIGINT, 'De los mejores profesores de la Escuela de Forestal, su manera peculiar de explicar produce interés en el curso. Si uno le pone a los trabajos y exámenes, él te lo reconoce.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2017-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ab2ee06b165ee76ff1d06be2e1b1213d50b28123517c1a4ecaccbd82f8ab0f62'::TEXT, ARRAY[2139]::BIGINT[]),
    (789::BIGINT, 'Inspira mucha confianza, excelente profesor, nos hace ser personas responsables, si uno pone empeño en el curso, el ayuda.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '242b8395f9689056650b082c640728e2cfe404d6d151050c36b539fd460630dc'::TEXT, ARRAY[2139]::BIGINT[]),
    (789::BIGINT, 'La manera de enseñar es diferente a lo usual, es lo que lo convierte tan peculiar. Muy buen profesor!'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '66e95171e79320b30c9a0f31db2dec1b198516e56c25ddb2dead9c4a0d307a1f'::TEXT, ARRAY[2131, 2160]::BIGINT[]),
    (789::BIGINT, 'Es un buen profesor, ayuda a los estudiantes, califica justamente.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2016-12-07T00:00:00+00:00'::TIMESTAMPTZ, 'e2fb4f31dbe1512fc8f7f7f9969cbb9f582e86ff01cdecdfb78d749b86fb2064'::TEXT, ARRAY[2139]::BIGINT[])
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
