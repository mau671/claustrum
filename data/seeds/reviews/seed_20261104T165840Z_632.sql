-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=632
-- TEC-DATA-META years=2017,2019,2020,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.831817+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (632::BIGINT, 'Buen profesor.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo']::TEXT[], '2023-11-28T00:00:00+00:00'::TIMESTAMPTZ, '9a1974ad7efa4e516cdf7b437813db5827ca51e64148202392f5725b81865a73'::TEXT, ARRAY[2038]::BIGINT[]),
    (632::BIGINT, 'El profesor es muy bueno, no obstante califica duro.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '2b5e8e1c75fb76fb9bdac6a5f428d311b63149bccb75ec6d807e789e5f1de098'::TEXT, ARRAY[2024]::BIGINT[]),
    (632::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'Muchas tareas']::TEXT[], '2020-08-24T00:00:00+00:00'::TIMESTAMPTZ, 'bdd67d8b65e3f159c7dc40c1b2ab3bb03c263e048402dd84615d7ca5181d46db'::TEXT, ARRAY[1981]::BIGINT[]),
    (632::BIGINT, 'En presencial se veía que era buena gente pero resultó ser pura pantalla, falta interés en los estudiantes.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Pocos exámenes']::TEXT[], '2020-07-28T00:00:00+00:00'::TIMESTAMPTZ, '4674bc96c8d564ba2d61967ae0bbc350d452f9484b3f2143101c38d6028edb7d'::TEXT, ARRAY[1981]::BIGINT[]),
    (632::BIGINT, 'este mae es un vago y califica como le da la gana'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2020-07-06T00:00:00+00:00'::TIMESTAMPTZ, 'c64766ba304d91783326c41557901d589c7ef3b5f2769b090d31f5aee625abb1'::TEXT, ARRAY[1981]::BIGINT[]),
    (632::BIGINT, 'En las clases se aprende bastante. El profesor es un poco serio pero las clases son agradables, brinda mucha motivación para seguir adelante.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '90d0254ee99dfb9a53a0c5abd7636397820cc8dbacd95e7eeabf9f6eeb73d18f'::TEXT, ARRAY[1981]::BIGINT[]),
    (632::BIGINT, 'La clase era básicamente escuchar su lectura de diapositivas, los quices eran fáciles. La calificación de algunos trabajos se las sacaba de la manga.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-06-17T00:00:00+00:00'::TIMESTAMPTZ, '22b683aca4ccb843ccf7cf4ab5d8a4d455121b8cf83c5795de9d863de2dfd3a6'::TEXT, ARRAY[1981]::BIGINT[]),
    (632::BIGINT, 'Mal profesor . No sabe explicar y no imparte clases. Hace cambios de horario a su antojo . Le disgusta dar clases.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Asistencia obligatoria']::TEXT[], '2019-01-21T00:00:00+00:00'::TIMESTAMPTZ, '2b9b0f88047e0c82347ea5967745e9a25482035f3f95c2a0ba07c85219fd773f'::TEXT, ARRAY[1985, 2024]::BIGINT[]),
    (632::BIGINT, 'Simplemente es mal profesor, o no sabe o no le gusta, parece que da las clases por obligación, le gusta mas dedicarse a la investigación, en un semestre tuvimos como 4 clases magistrales en las 16 semanas el resto o vino otro profe o no vino'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'c74d1f134fc302c26b400bce56f4663b65faec4fb5b2ba1ad945bd1558bffdb4'::TEXT, ARRAY[2038]::BIGINT[])
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
