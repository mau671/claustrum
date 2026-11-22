-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=609
-- TEC-DATA-META years=2016,2019,2020,2021,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.825634+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (609::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2024-11-08T00:00:00+00:00'::TIMESTAMPTZ, '5c7fc6201a9a19063b094978f95c7d7e0c6beac0563fdc7ac472031e99194aef'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-11T00:00:00+00:00'::TIMESTAMPTZ, '074a6cba109d41756bebd2b79a049e3ae3e60fbf958a97794e03bc16322eb1c0'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2022-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'd94830fc0e2d9914a26243905f82d28b2126b84d44283201504a3090da5410ea'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'd3039f27615e4f8b251c91df8290995ecb3b63fa467aed3e803ca3c1dc086b07'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2020-12-14T00:00:00+00:00'::TIMESTAMPTZ, 'bdcb5625cf38b34f14c41796575fa77ae4793f6dfe5db9bb806434db4f0a6c87'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2020-12-07T00:00:00+00:00'::TIMESTAMPTZ, '8a45286859e7791c31dc89b4369205232e3cc9acf944bb99ee8a11163bcb513e'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2020-11-03T00:00:00+00:00'::TIMESTAMPTZ, 'ad78697d563c531ca627caa315332ac25c043dcf1f55297a214cf7b4dc94609c'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Exámenes retadores', 'La participación importa']::TEXT[], '2020-02-11T00:00:00+00:00'::TIMESTAMPTZ, '1317d54c734669c62fe051cd7610faf75dad5e29cf76a248c61b5e250b50bc29'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Las clases se hacen eternas, y legalmente hay que leer todo!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2019-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e293ad271a19a295985002deea51366f93c551ab375ca05353daa24927321f89'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Pros: es muy buena gente, ve peliculas, hace alguna que otra actividad Contras: cuando agarra a alguien entre ojos, pues no lo quiere :v (no me pasó a mi) Yo si lo llevaria con ella pero si tendria cuidado a la hora de expresar las opiniones'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-25T00:00:00+00:00'::TIMESTAMPTZ, '33c097f83002b80b62b976ac03a7dd62da60fccb72e10fa3c5f83feeb18a1532'::TEXT, ARRAY[628]::BIGINT[]),
    (609::BIGINT, 'Las clases son poco interesantes, hace quices sorpresa, por lo que siempre hay que tener la materia al día. Dura mucho para entregar calificaciones de examenes, quices, proyectos. Por lo tanto, uno se atrasa con el proyecto. Es dejada para el proyecto lo deja para lo último'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores', 'La participación importa']::TEXT[], '2016-06-20T00:00:00+00:00'::TIMESTAMPTZ, '05717affdfd78f6b3e6034e847678017ac184244a8b9d923f9479cec66bd815f'::TEXT, ARRAY[628]::BIGINT[])
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
