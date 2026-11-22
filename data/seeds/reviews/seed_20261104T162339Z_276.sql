-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=276
-- TEC-DATA-META years=2020,2021,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.923680+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (276::BIGINT, 'Poco profesional, no se le entiende lo que dice, explica mal'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-04-25T00:00:00+00:00'::TIMESTAMPTZ, '7d117d14ec4282a4d10358beae78257a67fc9115294c2709e9a2b2373993b418'::TEXT, ARRAY[1163]::BIGINT[]),
    (276::BIGINT, 'un increíble profesor, es muy motivador, le gusta mucho la participación en clase por parte de los alumnos e impulsa al idioma inglés, el proyecto de taller fue muy largo pero siempre estaba al pendiente de consultas, explica bien, una persona de confianza.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-08-05T00:00:00+00:00'::TIMESTAMPTZ, '236a7dc8b763b9be97a6a52d2a60072ebe1b093968aaf75e9e1dc12713c86d80'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (276::BIGINT, 'El profe como persona es muy bueno, te brinda apoyo y te motiva muchisimo. Como profesor pues es bastante confuso, si vas a llevar un curso con el debes saber que tendrás que ser autodidacta y averiguar por tu cuenta porque muchas veces pasa codigo sin explicar conceptos.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'f33616a5a1178cb8ba4e559fb88f66447bb0351187d3ba6d203d3870dbd02055'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (276::BIGINT, 'Es una excelente persona, suele ayudar mucho. A veces se enreda al hablar pero es de los mejores profes que hay. Te anima mucho y da grandes consejos.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, '3e6507f680203eba15fd5db465df736468ac3f7a42a8f2967d6369aa1ba94bb9'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (276::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Clases excelentes']::TEXT[], '2021-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'c59ef13938e0db32042deecd757c9b19d2dd34b1c1048997d308faf8988630d1'::TEXT, ARRAY[3022]::BIGINT[]),
    (276::BIGINT, 'Como persona es excelente y como profesor él trata de apoyar siempre, pero, aunque se le nota que da lo mejor de él aveces las explicaciones son confusas o solo pasa código sin explicar que hacen algunas palabras reservadas o cómo, es demaciado flexible y no califica duro, es muy comprensivo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Brinda apoyo']::TEXT[], '2020-12-20T00:00:00+00:00'::TIMESTAMPTZ, 'e3634d6b01454717180b6c18caca0c1beafb3ed232c24409485e489d496d8a1a'::TEXT, ARRAY[1020, 1022]::BIGINT[])
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
