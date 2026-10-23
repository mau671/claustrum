BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Ella explica con bastante claridad, aunque a veces va demasiado rápido, pero siempre aclara muy bien cualquier duda. Es bastante desordenada en la pizarra y si uno es distraído lo puede enredar mucho. Es demasiado buena nota y califica justo, tirando a suave. No es la mejor opción, pero es pasable.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[] AS tags,
    '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7d1f1a3a2689e55b03b67628b846fde3673d189d7ac7f3152e50b3c8700e564b'::TEXT AS import_key,
    ARRAY[634]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '8153980a301915a5c2ce8b7f8ced44c467cdfa6dfa80559c5f36717147000db2'::TEXT AS import_key,
    ARRAY[634]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'No es mala. Explica DEMASIADO rápido; estuvo muy atarantada durante todo el curso. Se hacía mucho desorden ella misma en la pizarra y no daba tiempo de copiar. No meta con ella si se distrae fácil. En lugar de hacer quizzes, hace trabajos en clase (en pareja). Revisa TODO con mucho detalle.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c40b7c566f73f83349ea44021d9b225a8a50cdf1182dd014877687d92b8fc8ab'::TEXT AS import_key,
    ARRAY[634]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'súper simpática, dispuesta a ayudar y muy dulce en general, explica muy bien, hay que prepararse para practicar mucho y poner de su parte en los cursos de mate, especialmente si las bases no están tan sólidas aún'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[] AS tags,
    '2026-06-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '48812ea05cb0ee22a909e1f43e9d9e4725c93ec70b23f4c4580c22554f743424'::TEXT AS import_key,
    ARRAY[563]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'excelente profesora, explica claro, con mucha vocacion y dispuesta a ayudar ojala todos pudieran llevar con ella'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2026-02-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5ad126af3f08bea9eca7c387b7bf9a8a8f37af56b517743ea6f2c584684a4222'::TEXT AS import_key,
    ARRAY[605]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Excelente profe. Explica muy bien la clase, califica suave en los exámenes, y siempre está muy atenta a dudas que pueda tener. Deja bastantes ejercicios de práctica que funcionan como tarea, entonces usted de fijo practica.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2025-12-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '124b859729bd53fb4f9edd1f20d233be2b42a710c2d01397e0bad2c7157f9f14'::TEXT AS import_key,
    ARRAY[605]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Es una profesora de 100, Ayuda mucho, califica suave y explica muy bien. Es un curso aburrido, pero si ponen atención y le solicitan a la profe consulta, los va a ayudar bastante.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3de10e1b5efc1bb3f9502e3915c736146a3126e60258491c32e839f365804750'::TEXT AS import_key,
    ARRAY[935]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'La mejor profe de la escuela de mate, super bella persona, simpática y siempre dispuesta ayudar, deja practicas para los exámenes sus quices si estudia le va bien y deja mucha tarea, que ayuda mucho, mucha vocación es un amor de profe y de persona, no dude en matricular con ella.'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2025-11-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd91c3a85bc8eb66c3ac4aeaf24b408cf5af29674875f34bc38483845c45f4767'::TEXT AS import_key,
    ARRAY[605]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Fácil top 3 profesores de mate, es muy buena persona, explica súper bien y si no entendiste algo te va a ayudar hasta que entiendas. Sus clases son más dinámicas, aveces explica y aveces se hace práctica. Es muy cómica lo cual crea un bonito ambiente dentro de la clase, matricule con ella.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-07-28T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '630a4648250a7f88bc66c157b129792eb3a8115d77abf55c98dae06a1dd24f8d'::TEXT AS import_key,
    ARRAY[1057]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Súper buena nota, hágale sin miedo, si ella ve que le está poniendo al curso te ayuda bastante, ella era consiente de que los exámenes de ED estaban más rudos que los semestres anteriores, sólo es cosa de ponerle un toque (ver videos de JJ Fallas y Samuel Valverde) con eso pasa bien'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Da crédito extra']::TEXT[] AS tags,
    '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e4a8ba1681c9e5d924a0cfedc327e7972395c68966d6b22c67be0c1939bca331'::TEXT AS import_key,
    ARRAY[935]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'La mejor profe que he tenido de la catedra de mate, excelente profesora y excelente profesora, con mucha vocación de profe, ayuda mucho y siempre dispuesta a que uno entienda.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b4cc383ee5d7f1adb9d4281cdea9c30dc8b93637813182a076bee9d00131bfe1'::TEXT AS import_key,
    ARRAY[1057]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Es muy buena profe para eds, no diría que la mejor, pero si la recomiendo, es un amor de profe, y los trabajos que deja pueden llegar a ser un poco pesados pero generalmente se pueden hacer en pareja y deja buen tiempo, dura un toque revisando examenes y respondiendo mensajes pero nada del otromundo'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2f6f34607b1094842bef234fd340b88dd1d62ef5a02a1ff33871077e9140b352'::TEXT AS import_key,
    ARRAY[935]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

WITH review_input AS (
  SELECT
    481::BIGINT AS professor_id,
    'Es una profe supper buena, un amor de persona, y se dedica a que aprendamos la materia de la mejor materia. Ella comprende que las matematicas pueden ser complejas por eso nos brinda horas consultas de buena calidad y espacios de retroalimentacion. La amoo como prof'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'La participación importa', 'Inspirador']::TEXT[] AS tags,
    '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'fe96c5fbeecd8428543c76a59c362c1240a882ea7096d3948671939c110d2b94'::TEXT AS import_key,
    ARRAY[2439]::BIGINT[] AS course_ids
), inserted_review AS (
  INSERT INTO public.professor_review (
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    status,
    reviewed_at,
    created_at,
    updated_at,
    import_key
  )
  SELECT
    professor_id,
    comment,
    ease_score,
    quality_score,
    clarity_score,
    fairness_score,
    attendance_required,
    grade_received,
    engagement_level,
    tags,
    'approved'::public.professor_review_status,
    now(),
    created_at,
    created_at,
    import_key
  FROM review_input ri
  WHERE NOT EXISTS (
    SELECT 1
    FROM public.professor_review pr
    WHERE pr.professor_id = ri.professor_id
      AND pr.created_at = ri.created_at
      AND pr.comment = ri.comment
      AND pr.ease_score = ri.ease_score
      AND pr.quality_score = ri.quality_score
      AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
      AND pr.tags = ri.tags
  )
  RETURNING id
), target_review AS (
  SELECT id FROM inserted_review
  UNION ALL
  SELECT pr.id
  FROM public.professor_review pr
  JOIN review_input ri ON ri.professor_id = pr.professor_id
  WHERE pr.created_at = ri.created_at
    AND pr.comment = ri.comment
    AND pr.ease_score = ri.ease_score
    AND pr.quality_score = ri.quality_score
    AND COALESCE(pr.grade_received, '') = COALESCE(ri.grade_received, '')
    AND pr.tags = ri.tags
  ORDER BY id
  LIMIT 1
)
INSERT INTO public.professor_review_course (review_id, course_id)
SELECT tr.id, course_id
FROM target_review tr
CROSS JOIN review_input ri
CROSS JOIN LATERAL unnest(ri.course_ids) AS course_id
ON CONFLICT (review_id, course_id) DO NOTHING;

COMMIT;
