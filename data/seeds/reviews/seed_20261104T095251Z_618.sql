-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=618
-- TEC-DATA-META years=2017,2018,2019,2020,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.455351+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (618::BIGINT, 'Excelente profesor y persona'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[], '2026-07-23T00:00:00+00:00'::TIMESTAMPTZ, 'aacc2305c4f8c84a0f99f075e3f3ea1c05e5a5ce8f4bc2d8f9a5aa0ecdf73604'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'Es fácil pasar el curso, pero a veces muy fácil. Se ve que le interesa la materia pero no da a respetar los créditos que pesa su curso. Podría hacer del curso algo más desafiante y entretenido si se lo propusiera. De momento son 3 créditos regalados, pero buen profe.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Muchos proyectos grupales']::TEXT[], '2025-09-06T00:00:00+00:00'::TIMESTAMPTZ, '7c4b6cd3a0c5d328d93a42050379216054432df477a2d092f8133ee56d38b1fa'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-02-03T00:00:00+00:00'::TIMESTAMPTZ, '8e6b192a9dbb7852d9e0c055ddff9db447462e9346d4860a856165fa0aeadc87'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muy cómico', 'Respetado por los estudiantes']::TEXT[], '2019-10-26T00:00:00+00:00'::TIMESTAMPTZ, 'f3764052f4e8a4cd36a14d1c1d8d4d2493961be4afa7024e17299a37bc7dfc9e'::TEXT, ARRAY[1898]::BIGINT[]),
    (618::BIGINT, 'De los mejores profesores del TEC. Simplemente EXCELENTE!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2018-07-16T00:00:00+00:00'::TIMESTAMPTZ, '3f2dccde1b1ea2dfa833490560a1d3551cf036e4a73e2c2013f9af32815825af'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'A David en serio le importa si usted aprende o no, ojalá el curso fuera más largo para aprender más y más con este profe, super buena gente.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'bf92d425da30d264915e5aac91a5111e416bf51fb5d16762dcbf8d136f47f8ff'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'Es una lástima que la página baje la nota por facilidad, pero este profesor se merece un 10. Se explica excelente, deja muchas tareas que le permiten al estudiante poner en práctica sus habilidades creativas y mejorar en la materia y enseña a programar con lo que la carrera necesita. De lo mejor.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2017-12-03T00:00:00+00:00'::TIMESTAMPTZ, '78a5c032485c431c70cfb5cf4bd0b0ca0502d7dd943505b171b979b6cd28ec12'::TEXT, ARRAY[1865]::BIGINT[]),
    (618::BIGINT, 'Excelente profesor, de los mejores de la escuela.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[], '2017-11-25T00:00:00+00:00'::TIMESTAMPTZ, '022a25d529ce34b7a36453653d215d25862eb6b4627d075636df830af4ef0fec'::TEXT, ARRAY[1865]::BIGINT[])
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
