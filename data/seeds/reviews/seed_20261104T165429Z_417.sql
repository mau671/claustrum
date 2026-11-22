-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=417
-- TEC-DATA-META years=2015,2016,2017,2019,2020,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.224764+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (417::BIGINT, 'Es muy buen profe, da una visión y posición muy excelente de la ingeniería, pero durante el semestre casi no se hizo notar, y en conjunto con el profe Ernesto, hubo mucha desorganización en trabajos y notas.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2021-07-12T00:00:00+00:00'::TIMESTAMPTZ, '1c840667b8ecf44903333c9f4c65cf9b54620eaf6139a499e7797eadf422d4d5'::TEXT, ARRAY[4120]::BIGINT[]),
    (417::BIGINT, 'En conjunto con el profesor Ernesto Montero brindaron una clase excelente. Su punto de vista como ingeniero resulta ser súper importante a la hora de dar las lecciones. El unico problema de la clase fue la notable falta de organización entre los docentes, pero eso no le quita la excelente clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2021-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'a1826fc74bd09c9c77e1cf9e8b9642fe184acce590b6b473796b324ab7dac149'::TEXT, ARRAY[4120]::BIGINT[]),
    (417::BIGINT, 'Es uno de los pocos profes de la escuela de Electro que tiene muchos conocimientos y a la vez humildad, excelente profe y explica todas la veces que sean necesario.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2021-01-30T00:00:00+00:00'::TIMESTAMPTZ, '88beda8ca42fdabfdb918e17ad9b33c976357e37435431441dfa61b14fc469d9'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'El curso me ayudó mucho para conseguir trabajo. Es el único curso Electivo que es tomado en cuenta en la industria. Si pueden matriculen este curso. El profesor es excelente, muy buena persona, se aprende muchísimo. Debería de abrir más grupos electivos de este curso. Recomendado. EL MEJOR'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-11-11T00:00:00+00:00'::TIMESTAMPTZ, '1d6706a4ef7bb40a96661008bd7f4a591eed2b80de57e7107923a7fcfa3ce3ac'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'Habla un poco rápido pero explica cuantas veces sea necesario. La verdad es un profesor basta completo, sabe mucho del tema y es organizado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2020-08-27T00:00:00+00:00'::TIMESTAMPTZ, '2888205f1fbac9d4c64b119be1deaa4e8146bf4f4efb2a4fbe9d58ae05328bc7'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'Excelente profesor, el curso es ameno por que siempre relaciona los temas que se ven con lo que se usa en la actualidad en la industria y las clases prácticas son bastantes provechosas. Si los lleva al SESLab lleven bloqueador para que no se quemen XD.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2019-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'b61af9464d53cfde3aa52e6f96c4992ea5fb34dcfbf46857d68915c7f359cec6'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'Es un genio. Excelente profesor en muchos aspectos. Proyectos realizables donde se aprende bastante. Explica demasiado bien y las clases son interesantes. La carga académica que ejerce es adecuada. Las clases presenciales son muy prácticas. Imposible encontrarlo en consulta.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'bca52f93d5dbb472b10db50b0a6eb0cfcc9b3cb655118c5c08491be4fd2c5d8b'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'Hace que este curso no sea pesado. No hay exámenes y los proyectos individuales son fáciles aunque un poco largos. Se hacen prácticas en clase y también enseña un poco sobre la parte practica del curso. Explica claro y da retroalimentación de los proyectos.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'bf5eb5f1e6a5379b7036f142f29e50040f0e150efe358d696c61b64c1791c28a'::TEXT, ARRAY[1346]::BIGINT[]),
    (417::BIGINT, 'Muy buen profe, la materia la presenta de forma muy clara y hace que el estudiante se interese por las clases.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2019-11-11T00:00:00+00:00'::TIMESTAMPTZ, 'bcf1ecb3d79f619a0c9c070e54ca24caf016ddb18d6f3d6f1a0c292d4dbd0903'::TEXT, ARRAY[1319]::BIGINT[]),
    (417::BIGINT, 'El profe da toda la materia pero tal vez no la explica de la mejor manera en clase, pero en la consulta siempre resuelve algunos ejercicios. En clase este preparado para pasar a la pizarra en cualquier momento.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, '3cf1f4a8798a80c772533125d625d0fd28ed88ab2cc8a7e33226975a4c97adbc'::TEXT, ARRAY[3558]::BIGINT[]),
    (417::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, '4ee3d00850bbe610594f17ae284df16a4b6e2f17b7b0beee28ea972f71bbc921'::TEXT, ARRAY[3558]::BIGINT[]),
    (417::BIGINT, 'Si uno no tiene muchos conocimientos en electrónica es el Profe indicado, se interesa por el aprendizaje de los estudiantes y casi siempre hace quices pero se aprende.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-21T00:00:00+00:00'::TIMESTAMPTZ, '2c158058138306dc9563cb8956f14eba35914251d0ff134361363e3275f347c9'::TEXT, ARRAY[1263]::BIGINT[]),
    (417::BIGINT, 'Lab de cc con Meza es un sencillo, las evaluaciones son muy faciles, el mae es buena nota y algo se aprende. Suele ser un poco irresponsable con el curso eso si.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'a28fe698817c67ab745ead40ec6ebd7ba79a3c0c665e584ec972153ed4b11114'::TEXT, ARRAY[927]::BIGINT[])
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
