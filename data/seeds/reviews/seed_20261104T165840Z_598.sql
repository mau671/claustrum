-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=598
-- TEC-DATA-META years=2020,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.814881+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (598::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'f81fb407a5ec803686d83717a233d901ab638b71accc16b1b44cdc2814f66790'::TEXT, ARRAY[2438]::BIGINT[]),
    (598::BIGINT, 'Super profe, se nota que tiene vocacion por enseñar y que esta dispuesta a trabajar con los estudiantes para ayudarles. Una de las mejores profesoras que he tenido y definitivamente una muy buena introducción a Admin de Empresas!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-09T00:00:00+00:00'::TIMESTAMPTZ, '4ee055f686e4b3017d5251827a5c349046ffa136ff03adffa34f8da3a78f3385'::TEXT, ARRAY[2438]::BIGINT[]),
    (598::BIGINT, 'Muy buena profe, les recomiendo mucho que lleven con ella si estan empezando la carrera, debido a que lo motiva mucho, enserio se nota el amor por enseñar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2023-06-15T00:00:00+00:00'::TIMESTAMPTZ, '4cbccb2a98f35c42aae4527eae3ff9f10767ef20a8726ed2cb857fd23b4ea61c'::TEXT, ARRAY[2438]::BIGINT[]),
    (598::BIGINT, 'Es buena profesora, no la mejor pero tiene experiencia. Es amistosa y da buena retroalimentación, es abierta a cambios. Sus clases son un poco aburridas pero yo culparía a la materia, no a ella. Los exámenes son fáciles y las tareas también.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2022-12-23T00:00:00+00:00'::TIMESTAMPTZ, '64660f7655b6367c79b3ad1eaea0a4f897e489958f06e9c3b3b1861623e3611d'::TEXT, ARRAY[2955]::BIGINT[]),
    (598::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Respetado por los estudiantes']::TEXT[], '2022-11-09T00:00:00+00:00'::TIMESTAMPTZ, '70fffaf57b73104faaca7f87f3156c2b32cc66525514503cc7be0f4340b972b8'::TEXT, ARRAY[2955]::BIGINT[]),
    (598::BIGINT, 'Si busca un profesor con el cual sentirse cómodo, relajado pero a la vez aprender un montón...ella es la indicada. Está atenta ante cualquier duda cuantas veces se necesite, es amable y le dá valor al estudiante. Clases virtuales muy completas y su método de enseñanza es muy bueno.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ, 'b077931d3d5d84d66113a2bb9fbae01ca9eff105eccc11aa47e099f1c1469666'::TEXT, ARRAY[98, 2363, 2359, 96]::BIGINT[]),
    (598::BIGINT, 'Muy buena profe, explica muy bien y le interesa que los estudiantes aprendan. Sin embargo es muy estricta en el proyecto y no siempre es claro lo que pide. Yo la recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, '0625810bddaea1ce1643546e600a6349047791b25f4054ac93152d1735a9afc3'::TEXT, ARRAY[2419]::BIGINT[]),
    (598::BIGINT, 'La mejor profesora.. Le interesa mucho el aprendizaje de los estudiantes, el curso lo educa excelente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, 'f1f2b350383989c6e6fe336ed438dbd9ae6652d609924fb4d6b5eb8243f75f98'::TEXT, ARRAY[2419]::BIGINT[]),
    (598::BIGINT, 'De las mejores profes del Departamento de Administración. Muy atenta y siempre cordial'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-07-20T00:00:00+00:00'::TIMESTAMPTZ, '4dd6ac2862094dc5f12ad56d81b1a6b5773de2fa7e4a52f1dce319692f4b4054'::TEXT, ARRAY[98, 2363, 2359, 96]::BIGINT[]),
    (598::BIGINT, 'Es una profesora excelente. El proyecto final se lleva durante todo el semestre, pero cuantas veces le consulte siempre está disponible a aclarar dudas. Para las clases virtuales también la recomiendo. Siempre tiene a un invitado experto en temas afines a la carrera.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Aspectos de calificación claros']::TEXT[], '2020-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'a77650a61413059fb7fc67b77e5d49c08c7d776630ac10ff32e70fa9e0c45bd6'::TEXT, ARRAY[2359]::BIGINT[]),
    (598::BIGINT, 'Buen curso'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2020-01-22T00:00:00+00:00'::TIMESTAMPTZ, '7732e2a4cad2d40818ffed8ad2b70a42169da91662a45d4b9b0449da0804bdb2'::TEXT, ARRAY[2419]::BIGINT[])
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
