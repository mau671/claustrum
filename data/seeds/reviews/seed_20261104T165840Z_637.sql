-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=637
-- TEC-DATA-META years=2017,2018,2019,2020,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.833578+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (637::BIGINT, 'Un rotundo crack!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2024-01-09T00:00:00+00:00'::TIMESTAMPTZ, 'be42ba546c105b19d51ccfb9105a11ee5c108e5daf4640a6296e3c35540cbd6c'::TEXT, ARRAY[2017, 2023]::BIGINT[]),
    (637::BIGINT, 'El curso es muy dinámico por la cantidad de mini proyectos, lo que hace que todas las clases sean interesantes. El profesor siempre está pendiente del avance de los estudiantes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '074bc93fb1af2cf659b0afbff70aee694a61090fb1aec2ea05329dc7c9508bfe'::TEXT, ARRAY[2023]::BIGINT[]),
    (637::BIGINT, 'Excelente profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-12-06T00:00:00+00:00'::TIMESTAMPTZ, '0d6f18a5f19f5373a3ee5d323c8bb92c5b6ff06c10dbe66c54854f478273c57b'::TEXT, ARRAY[2017]::BIGINT[]),
    (637::BIGINT, 'Las clases son muy agradables. Se debe mantener la práctica de ejercicios para un buen desempeño en el curso. El profesor brinda mucho apoyo y se preocupa para que ningún estudiante se quede atrás.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-08-17T00:00:00+00:00'::TIMESTAMPTZ, 'ae22f8ac8c285a6edb9238a5b7bfa7f143b05a6a157acf4dcfdfc1f132364816'::TEXT, ARRAY[1992]::BIGINT[]),
    (637::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-05T00:00:00+00:00'::TIMESTAMPTZ, '73e6f8d9ad3869a06f5ae2472fdacd7f1ebd820532b7567c041d8dd5c1989f37'::TEXT, ARRAY[2023]::BIGINT[]),
    (637::BIGINT, 'Es un A M O R de profesor, recomendado %100'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2020-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'ff047bb7862f160029aa49bd6e3a418220de3aee32bfe8c8ed1c13f5f56bf06f'::TEXT, ARRAY[2017]::BIGINT[]),
    (637::BIGINT, 'Excelente profesor, las clases son muy entretenidas. Se aprende mucho.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2020-01-22T00:00:00+00:00'::TIMESTAMPTZ, '1844a4272b04b358130c223bd3009044ba1f5c52ca3150a3b147b2aec937e258'::TEXT, ARRAY[1985]::BIGINT[]),
    (637::BIGINT, 'De los mejores profes que tiene la escuela de Ing. Agrícola.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, '6e9f40416581fa531b1575aeec485732a6d9d4a6bd1c8710552d3f0c85f12e82'::TEXT, ARRAY[2017]::BIGINT[]),
    (637::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2018-08-30T00:00:00+00:00'::TIMESTAMPTZ, '038a4b9dcf1059a46138e17efe337ea6f69a0053296bdf46a6aa9b18ee020bd9'::TEXT, ARRAY[2017]::BIGINT[]),
    (637::BIGINT, 'Es excelente profe! siempre dispuesto a ayudar y ademas incorpora muy bien el uso de la tecnología, habla mucho del desarrollo profesional en la calle y hace ejemplos y exámenes muy aplicados. recomendado.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'b5cbf365544764f5761ff0393a28b9f42dd1364d812d434e2c5d05e7e75a175e'::TEXT, ARRAY[2017]::BIGINT[])
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
