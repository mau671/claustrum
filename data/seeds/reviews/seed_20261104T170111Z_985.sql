-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=985
-- TEC-DATA-META years=2017,2018,2019
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.061101+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (985::BIGINT, 'El profesor domina los contenidos, pero aveces exagera con los quices y los trabajos. Tiene que tomar apuntes.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'd951530f0692e66a5b6e1c0628e3635ba0613007a5fb648428edf96ecd8cb231'::TEXT, ARRAY[3231]::BIGINT[]),
    (985::BIGINT, 'Excelente explicando, hace que uno le tome el gusto a la materia. Casi toda la nota del curso se basa en los talleres que se realizan en clase, por lo que el curso no quita mucho tiempo extra'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2019-01-29T00:00:00+00:00'::TIMESTAMPTZ, '61c0354f67968a78b7c6c6fa0dd6d3db25da97397aa4a423a5b5e2d086bb9200'::TEXT, ARRAY[3231]::BIGINT[]),
    (985::BIGINT, 'La verdad es un profe que se puede pasar la materia y los talleres son pesados y califica normal, en general es buen profe'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'e3c9e1788bd9c5a52ef4b38246786611c6673e6e80e46a6104b14b63f7b3f932'::TEXT, ARRAY[4053]::BIGINT[]),
    (985::BIGINT, 'La clase es aburrida y hay que tomar bastantes apuntes. Él es buena nota y se nota que domina la materia. Los exámenes son muy fáciles, pero, los talleres y en especial el proyecto final llegan a ser algo tediosos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ, '80e50f6f49d6e93d18791e0ae9251766b9e293ef452df009c254fddb93cf4212'::TEXT, ARRAY[3231]::BIGINT[]),
    (985::BIGINT, 'Gran dominio del tema, a pesar de que la materia del curso suele ser aburrida logra hacerla lo menos aburrida posible. Califica como se debe.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ, '9dfde937aa0fd976427f25e1605548347d3d4b4b017d384a266289234840eeac'::TEXT, ARRAY[3231]::BIGINT[]),
    (985::BIGINT, 'Las clases son aburridas. En ocasiones, el profe titubea sobre lo que está explicando, lo que genera desconfianza en el estudiante; se debe ir mucho a consulta para poder entregar los informe a como él quiere y aun así, muchas veces NO se le queda bien y se tienen notas bajas en los mismos.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2018-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'd9d11a1f4f4dde520c2c235e0461f23f320993a6a7c6e6426c33d6bd8df4c58a'::TEXT, ARRAY[1461]::BIGINT[]),
    (985::BIGINT, 'Poco conocimiento de los contenidos, explicaciones ambiguas y se nota su desconfianza. Lamentablemente no se le pudo sacar el máximo provecho al curso.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'b464713fb2257463a90c0f4df673a3cec8c5a7c220982f75eff73725288074f1'::TEXT, ARRAY[1461]::BIGINT[]),
    (985::BIGINT, 'Hace el curso demasiado pasable. Es buen profesor, pero se pasa de listo con el proyecto. Igual, lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'dc5b4139d3f0f28a770eb7412309729369041ac152f83a1907324331ecae958e'::TEXT, ARRAY[3231]::BIGINT[]),
    (985::BIGINT, 'Califica súper rudo para lo que explica y no tiene mucho dominio de los temas.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-20T00:00:00+00:00'::TIMESTAMPTZ, '5e8d15a75f4b951fdbdf134c39d9409d367cae7a62fa8891d07e8df710af4d21'::TEXT, ARRAY[1462]::BIGINT[]),
    (985::BIGINT, 'Califica DEMASIADO duro el proyecto, pero lo demás es muy fácil'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-12-04T00:00:00+00:00'::TIMESTAMPTZ, 'd3fcd4af136e46b5f4dd19c3dbc2cca253761be1a4a224097cfae9d461f6319b'::TEXT, ARRAY[4053]::BIGINT[]),
    (985::BIGINT, 'Muestra interés en el aprendizaje de los estudiantes, si deja alguna normativa para discutirla en la siguiente clase HAY que estudiarla y llevar la mayor cantidad de consultas posibles. Califica justo en talleres y exámenes (hay que dedicarles tiempo e ir a consulta con él para tener buena nota.)'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2017-12-03T00:00:00+00:00'::TIMESTAMPTZ, '49ad1c196dd1f8c5e600f8b3eb87de40a2726363fb1b95d3734f8e89de71776b'::TEXT, ARRAY[1448]::BIGINT[])
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
