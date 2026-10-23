BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'De los mejores profes que he tenido en toda mi vida, la mejor opción para matricular mate general, si tiene la opción de hacerlo no lo dude. Solo hay que estar preparados para muchos ejercicios que deja como tarea, pero tenga por seguro que si los hace aprende todo'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '57bfe1b59454bb6d6e60287a8ec455ccdcd72780ceb9ff0e7eff31affbe4f5d2'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'De los mejores profes que he tenido. Es imposible aburrirse en su clase y él está realmente interesado en que usted aprenda. Sin embargo organice bien su tiempo, ya que deja muchísimas tareas. Si tiene la oportunidad de matricular con él, hágase un favor y aprovéchela.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-07-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b4aa0db081288cd7bc4fbf8b2166e29c473afd4be379514c1fe9fc6b92523728'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe de mate. Explica superbién y se preocupa de verdad por que el estudiante aprenda. Además, es supercómico, así que nunca te vas a aburrir en sus clases. Eso sí, hay que ir al día con la materia, con que cumpla con las prácticas y exámenes decentes, se pasa fácil'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c0733a1bbbeb3427a0f0a572b90c869f643187502c10a1c6c3a8b6f4d231804d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da crédito extra', 'Clases excelentes']::TEXT[] AS tags,
    '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f0b7feccedb9fa73bf32694ab0d145056b35b1f0ae43c61a631fd14c98e47189'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Una maravilla de profesor y de persona sin duda alguna, aunque vaya un poco rápido a veces, siempre lo va a ayudar a entender y explica todas las veces que usted lo necesite, clases muy divertidas y va a disfrutar la materia completamente siempre que sea con él.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[] AS tags,
    '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '93fa39ae9b00014f42c89ef10d8e7a4c504bd6fd755c0de011371afb12329efe'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Un excelente profesor, es de las personas que adoran su trabajo y sabe como explicar la materia. La evaluacion se basa en revisar el asterisco, que usd lleve el cuaderno al dia y los examenes. No pierda la oportunidad de conocerlo y llevar este curso con el.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[] AS tags,
    '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f79b336f9abc334cc4e4ad7437c43c25bb8d9743781c6e7868e97afa09395c1e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'las clases son bastantes divertidas, se le entiende muy bien, eso sí explica muy rápido, pero, si tienes dudas él las resuelve inmediatamente. Se preocupa genuinamente por los estudiantes y hace actividades para tener puntos de respaldo, califica super suave (prepare al menos 3 cuadernos)'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[] AS tags,
    '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3b6eb8a890908d842e1a878eb8a18e0fb27d5b74ef67b55d1b9ab38236d2cb95'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Increíble pofe e increíble persona, sabe muchísimo de su materia, ayuda con todo lo que puede, no regala puntos pero si hace todo lo manda le puede ayudar, si cumple con todo puede llegar al ultimo examen ya aprobado'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '00e641f978b18821dd732fb2837930ef7d01a2d8a16346bd015695a880f47375'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Lleve mate general con el, demasiado increible se nota que le gusta dar clase y se preocupa por los estudiantes. DEMASIADA practica, tareas, actividades extras. Recomendacion: si lleva muchos creditos no lo recomiendo tanto por la gran carga academica que hace, si puede meta con el, es un amor'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Da crédito extra', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2026-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'db8660e3af3c20d26af9e18d67e2b1c6010fcc2fdb74304a946bc33a925cfd41'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-05-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1b8f86c1318fb301931924fc60f1af946ba0b8e82f60e3ca1a889a5784c43172'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'No hay clase de Marcial en la que ud no se haya cagado de la risa. Muy buen profe, explica muy bien. Eso si, si va a matricular el profe se tiene que preparar para enseñarle el asterisco (cuaderno de práctica) completo, ya que el profe deja mucha practica.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-03-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd7e3833382ee87b17524226a7a04cff94568e8117ffd547e01d30388a1f66ab4'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'La diría de dar la clase hace que a uno se le pegue la materia porque es muy entretenida. En cuanto al profe es un profe que puede cambiar la forma de ver la vida universitaria, un arquitecto de vidas. Matricule con él si tiene la oportunidad, el mejor profesor que he tenido.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-02-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b6c3bb273c713c1695f666881e8b19c61d4df4de1d5a6c0255f6532e1e8e75b9'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Como pueden ver me dio mate general y CDI me atrevo a decir que es el mejor profesor de la escuela de mate, demasiado carga, no hay dia que usted no salga muerto de risa de la clase, si tiene la oportunidad matricule sin miedo. Es de los profes mas solicitados, no desaproveche'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2026-02-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '381b80199a82f4dc7b46bbf48d9683db65e794a996b74f483dd9a03378140348'::TEXT AS import_key,
    ARRAY[563, 605]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'El mejor profe de Mate definitivamente. Muy cómico y se le entiende súper bien, Dios lo bendiga bastante.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2026-01-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '852defb002348ee88483073ed08a276a38e635b3366380c0a1cd419536359400'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Simplemente es un gran profe, muy comico'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Asistencia obligatoria']::TEXT[] AS tags,
    '2026-01-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '16efe839b9ae1d2262ce9842167bbcba4faf60dd59b0762557d170915fc85911'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es como un peluche gigante, es facilmente uno de los mejores profes de mate que existen. Es muy gracioso y bueno dibujando. Es como profe de cole, vaya a clases y haga todas las practicas y va a pasar. Si él nota su esfuerzo va a costar que se quede. Recomendado 100/10'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-12-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '45951fab7467d4e5e6b8cf95b415dbf8cb022d7ca9be51742a3b69521ae062a4'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Lo considero el mejor profesor de matemática con el que he recibido clases, sin embargo, no es para todos. Su método es de mucha práctica y trabajo duro, es a la antigua ya que incluso exige el uso de cuaderno. Y recuerde que si quiere pasar le tiene que entregarle el asterisco (tareas).'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Inspirador']::TEXT[] AS tags,
    '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'cca6ebb403c48836d4f3a9bddfcfd7e55cb581c72aae0c140c9c037b861ba431'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Recomendadisimo, excelente profe explica bien es super buena gente y gracioso hace que las clases sean entretenidas deja muchas tareas pero lo vale ya que ayudan un montón hacerlas para el examen y son muy sencillas son puntos regalados pero lleva sus buenas horas, matricule con el 100%'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'cc084996b8ee6bfb4aedcd804218dbfee474e77d1beb25f17d0f8104bd3d35fc'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'En mi opinión uno de los mejores profesores de matemáticas del TEC, explica muy claro y no tiene problemas en volver a explicar, es un muy buena nota y gracioso por lo que la clase se vuelve super llevadera y entretenida, eso si deja muchas tareas pero son de mucha ayuda para repasar.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2025-11-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '8f2b3b0c596bdf73d57c036d245b7af1a877070b67bf325dd3b8cd0032865352'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Si buscas al maestro supremo de las artes arcanas del saber, aquel que convierte números en hechizos y problemas en criaturas dóciles, no busques más: el mago Marcial es tu guía. Con su poder, cada clase se vuelve un ritual de claridad brillante y sabiduría eterna.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico']::TEXT[] AS tags,
    '2025-11-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ce2faeb7ea4297933e77f408fecbf83c945b353dcb54440c92b58a5f1fa5b697'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es súper cómico y tiene un humor bastante peculiar (sin ser ofensivo) lo que hace la clase divertida, eso si explica muy rápido y deja una exageración de tareas que le ayudan a repasar, pero si usted necesita ir lento mejor no lleve con él, califica justo y quiere que usted aprenda!'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases largas']::TEXT[] AS tags,
    '2025-11-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'fbe7e8b2e0a8508fa0f2eac9249d73c729eb24598d8ebbf2e3f07bf34d6b44e0'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Este profe es un teja como persona y como profe, explica muy bien, deja mucha práctica para que le vaya bien en el examen, califica suave y hace las clases entretenidas que hasta da gusto ir a la cálculo.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2025-11-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ace604c550a075029b2688cf2649bfd513e857e7d2d7a9bf018712178509275e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    '100% recomendado, excelente como persona y profesor, te ayuda muchísimo dejando innumerables tareas, póngale mucho! No se va a dormir en clases pues son entretenidas y chistosas, son de esos profes que ya no hay, se preocupa genuinamente por sus estudiantes y califica suave, sea organizado eso sí.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2025-10-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c8e228db607c826eebdf1bd586dcefe27aa78e748cb7404dbb839e3b20509a33'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, Si deja mucho trabajo pero ayuda a los exámenes un montón, intenta que todos pasen'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-07-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f213038489954f8154f78e4b91f706c4d9a9b6d1d922ce225842db3a1d85d78b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Un profesor increible la verdad, aunque si pueda dejar bastantes trabajos y tareas, la verdad es que lo prepara uno bastante bien. Es alguien muy simpatico y se interesa por ayudarle a uno a entender'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'be7ba28cb9fa766b4cd52263ed25f9439525cfda1722383a99946df2a4715776'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profesor del tec, todas las clases se pasan volando, si usted no entiende el explica las veces que sea necesario y siempre cuenta historias y hace chistes para alivianar la clase, no dude en matricular con el.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '34ba351097ed257102948b7fe96c05d53dc3137e080441b514c85bb34e1afcaa'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente persona, explica muy bien y no tiene problema en volver a explicar , le gusta mucho que uno practique y que tenga el cuaderno ordenado ,para seguirle el ritmo la atención es indispensable, volvería a matricular con gusto otro curso con el'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'La participación importa', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '32d0ffee9462c1689a27f38daa73b3c3d245c8e4300b041426cb5cf0fb8b931a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Muy buen profe, explica muy claro y pasar es muy fácil siempre y cuándo el estudiante haga las cosas, las clases son muy entretenidas y es muy servicial.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2025-06-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ef013d5833b40c7da6c653b18612a6dae00dcb2d24c3b4593a17bacfea3ba6be'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Llevé con el en verano ,es excelente ayuda mucho con las tareas para aprender, explica claro y no tiene problema si le piden que vuelva a explicar , para los estudiantes que no son organizados deben trabajar fuerte para cumplir con los trabajos , el profe es muy respetuoso y considerado'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'La participación importa', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-03-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2be5e9050b36475a18bbb58536cf4d628689bff527c6384cc7aae0abfe7e12d0'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Si buscas al más grande de los matemáticos, al mentor que transforma números en poesía y convierte problemas en soluciones elegantes, no busques más: el profesor Marcial es tu guía ideal. Con su pasión contagiante, cada clase se convierte en una sinfonía de aprendizaje y descubrimiento.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Inspirador']::TEXT[] AS tags,
    '2025-03-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '66adc1a83138c5623d46961223aed6c635e2fb7e4e587344984f66724afbd295'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Califica duro y si queda la gente manda mucha tarea'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor']::TEXT[] AS tags,
    '2025-02-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'fdf8a35f27a29aa162f80230f0918b35cccfc060a32e77181dfe250d5578bc8a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe marcial es muy bueno, y pasar con el en verano es un queque SIEMPRE Y CUANDO usted ENTREGUE las tareas y se esfuerce. El profe ayuda mucho a que usted pase, pero tampoco va a pasar a los que no hacen nada. Pero bueno, lo más importante es que HAGA EL CUADERNO DE ASTERISCO *'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[] AS tags,
    '2025-02-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c2c2b2a4c38b764d8cab1aa72bb5531f4df4587a658cff71906d8beb6c32c127'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Muy buen profe, muy dinamico, si lleva por primera vez el curso tiene que estar muy atento ya que asume muchas cosas y deja demasiada tarea.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Da crédito extra']::TEXT[] AS tags,
    '2025-02-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '297afa3af2356700426bf2d2b83a2859741e45e267d8ace6871f74bef25a0a47'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un excelente profesor.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2025-02-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd2396a3d21d37aaf8149d323de13421538a784c37cc2482b1fa417298853a0a3'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe para matemática general. Es demasiado cómico y nunca faltan las risas en su clase, además crea muy buenos lazos con los estudiantes. Explica bastante claro y se devuelve si uno pregunta. Deja bastante tarea, pero lo deja a uno muy bien preparado para los exámenes.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-01-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'bd9e4827115ed6ae72dad57bcef805b2b079fddfc9056c65f13dd5bb192bc18f'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es excelente con la materia que imparte. Hace que cada clase sea muy cómoda y entretenida para los estudiantes. Recomendadísimo.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-01-29T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'aeeb6e8783fe779190b5165578202c3a33a99d092e6ca6ab6c35bb4de6d8f974'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Si usted entiende lento o normal, entonces noeta con el, es demasiado rápido explicando y uno se pierde completamente, deja un montón de trabajos a tal punto de que tuve que gastar dos cuadernos y medio con el, y al final me saturaba todo, no lo lleven con el'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    5.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '25'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da crédito extra', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2025-01-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '917783705c385e8dd4b969e1d7f4696a24db5996d9d6c2dc8ff7ae7bb5899001'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es un profesor excelente, pero hay que trabajar mucho. Si usted es vag@ mejor no meta con él. Si usted se adapta al ritmo de él pasa fácil y va a disfrutar mucho sus clases con las historias y anécdotas que no afectan la clase y hasta aporta.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '50'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-12-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4294475835e0f6261b0b0f374f07e7397c723f353faaac73f101eb821928d772'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es el mejor profe de mate que hay en el TEC, el profe es muy cómico, deja muchas tareas y prácticas que si uno hace a conciencia y se toma en serio el curso pasa fácil. Explica de una manera muy original que ayuda a los estudiantes'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2024-12-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '072c8b6efe8ed18cf234c7ab20f0bd90fdeea59b0c51cbef5033905c5b9a62c7'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor. Deja mucha práctica para que usted pase. Hace las clases entretenidas y también hace prácticas grupales. Suele hacer un grupo ws para consultas.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2024-11-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '81ec385d5a41820b515b5161f8ee15b8056c7dc1802a2528db71217f923f08fe'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Si mate no es su fuerte no meta con él, es buen profesor para quien tiene buenas bases, si usted no las tiene esta es su última opción, es gracioso y deja una cantidad absurda de tareas. Si mate no le cuesta vaya con él.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '50'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Muy cómico', 'Muchas tareas']::TEXT[] AS tags,
    '2024-11-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1787ec8103e7c9533a15c820b1ce401fa7669baed71ec5a5257651af4f35bffd'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe hace sus clases muy interesantes y llamativas para los estudiantes. Hay que acostumbrarse a su humor pero como profe es un 10/10. Explica muy bien solamente que deja DEMASIADAS tareas. En general, si lo recomienda para mate y van a ver que nunca se van a aburrir.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2024-11-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f2d7405b50aa37692ea61df8442625298bdd3ec7f2ad5356e8afc3aaa877d14e'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-11-13T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '23e9115b24f697a2b603533edac6c21f03b2ec758b482059b367c7e8d071c30d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe de todos! Sin duda matricule con él, explica excelente y encima es muy buena gente y gracioso. Hasta dan ganas de ir a clase con él'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '249d823f4a4bd1cc46dd358251198aa73466e1815fa6964f8d8745b3756f776c'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe de mate por diferencia! Sus clases son súper graciosas, y por más de que tenga un ritmo rápido, si ponés atención entendés claro.De verdad se preocupa de que uno entienda. Si pudiera, tomaría un curso de nuevo con él.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2024-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '18bea49de92134de4ae2b712d0f6740e4c7a1e32d6dfac6e5d2d0adcd49be67b'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'El mejor profe de mate que he tenido, explica toda la materia de forma perfecta y entendible, deja mucho trabajo pero vale la pena para entender todo. Sumamente cómico y dispuesto a ayudar siempre. Mientras usted sepa lo que hace en el examen y lo demuestre pasara.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e0766cc48881689cdc799e8509d91cd36523f826b27f715d98b280656c0cb289'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un profe que exige tener un ritmo rápido, con tantas tareas que deja al mismo tiempo se asegura de que siempre haya algo que hacer, muy buen profe pero su forma de enseñar puede no ser la adecuada para cualquiera.'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '6e94c8cc2054d67c1c678ef7bb0fb479d7153ca99af3902c77f64c35cb1054fd'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profesor es excelente pero deja demasiadas tareas y muy largas, sin embargo, evalúa trabajo en clase y otros rubros que ayudan bastante a pasar más fácil el curso. Volvería a tomar clases con él.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'de7d982f0b696583bdcfd072401ff5efb34cfb0ec9844ab4d83f42d285e1886b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'En general el profe es muy bueno, pero debe saber que va a hacer muchos más trabajos que con otros profes. Cassi siempre vale la pena, ya que siempre toma en cuenta el compromiso para ayudar a sus estudiantes. Explica de maneras creativas y permite aprender bien, pero en serio es mucuha tarea.,'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Da crédito extra']::TEXT[] AS tags,
    '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '06f7d961e689929f36a109ed3213481c3886de18b257bcb0e7c182e779b1d746'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Un profe muy bueno, solo es de poner atención y practicar con el mismo material que él deja y pasa el curso fácil'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[] AS tags,
    '2024-06-16T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '664450b2a352bc4ed3ffec01d8123b5941583874281ab599a807232dbac83d57'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Excelente profesor, la verdad si me saque esa nota fue por que me afloje en el último examen jajajaj. Súper buen profe y creame que si está con él y le pone va a pasar. Eso sí da demasiada práctica que demanda demasiado tiempo pero gracias a esto ud no tiene ni que estudiar para el examen.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Muy cómico', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd92d82bec67ffb72178a26a87604efedcc188c2418092708b69f45699b13945b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe primero que nada es demasiado divertido, hace que la clase sea bastante llevadera, sólo que deja muchos trabajos y a veces en clases se pasa de intenso, pero al final uno se da cuenta que sí aprende un pichazo con el profe tqm marcial'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e34fe6a96a652bfe5c7d89e05674f789c48dc969b168171e8ed1ebb926a36ea1'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es muy buena nota y sirven mucho las prácticas que deja, se puede ir con eso al exámen y fijo pasa'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '068e648206f8ce557611df39dd35e64f25c25a081fda8b5160d8ebdde1760dce'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Tenga cuidado con quien matricula; el profe es buena nota y es chistoso pero no es para una persona que está empezando, si no sabe nada de la materia mejor matrícula con otro.'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2024-06-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '31583f4746002e1d58b67a1f1fa98e95e8a0571fff755a227ad71603e0497e78'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Recibir clases con Marcial es una maravilla, téngalo por seguro que tendrá que ponerle, practicar bastante , pero definitivamente si logra hacer todo lo que él le pone a hacer, en los exámenes le va a ir bien además que uno nunca se aburre en su clase y siempre da consejos para aprenderse mejor todo'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-05-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ed35486f4cceb1070b9c0bd96c357e165f2f6e72173f454ea3b28141f0581a9d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2024-02-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '57205ab4a8777514a389f964c1d04dc650199a69843525bdc331542688e988b8'::TEXT AS import_key,
    ARRAY[2439, 563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es el mejor profe de la escuela de mate. Va a tener que ir a todas las clases y hacer todas las prácticas y tareas, pero creame que si las hace va a pasar sobrado. Él es excelente explicando y siempre ayuda al estudiante.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-01-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3f5580a3e6bea202d40dae44be5a0078c95c419cbe2ad86f18a4a3e757a07561'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El curso se pasa fácilmente con él por como evalúa y prácticas (hay que ponerle). Eso sí, en el tema de trigonometría da recetas sin explicar el por qué de las cosas. En los cursos de matemáticas más avanzados es crucial COMPRENDER qué es todo eso. No se queden solo con lo del profe :)'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2023-12-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '6e2cb248ed5fc59dee66aede70e1815516035186194f7274f430889846fa2934'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor y persona. Las clases son muy buenas, bastante práctica con ejemplos y tips para los estudiantes. El profe es muy cómico entonces nunca van a ser aburridas las clases. También es muy motivador con historias de él y de sus estudiantes. Lleve mate general con él, es demasiado bueno.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[] AS tags,
    '2023-11-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '77adfd773a706f0e7e1c7660249feb187b90742ff7b64f1e63b600e4676ab665'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'De los mejores profesores de mate del tec, las clases son super entretenidas y aunque el profe a veces piensa que uno sólo matriculó con él, si usted le mete un poquito de tiempo al curso y hace las prácticas tenga por seguro que va a pasar el curso.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2023-11-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '14b935a5c970c4dee7d44bf632df667dd64c1229be0f0f2e5c9f1b31a5a569f5'::TEXT AS import_key,
    ARRAY[1018, 563]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'El profe es muy bueno y se nota que le sabe bastante pero es mejor profe con los que están repitiendo el curso por que explica muy rapido, si lo esta llevando por primera vez mejor escoja un profe que explique desde 0'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2023-11-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd40f85273563d037001e302ea52e29404955cda262dc051002723905168609eb'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Lo amo mae, quierase y matricule con el'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2023-06-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e3d4b28afdc4b1d4f2489cc167c65bd6dbc1ce7760e1f62c91a9e1a88f630488'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es muy entretenido, manda muchas tareas pero no las revisa muy detenidamente, igual vale la pena por que la clase es muy divertida.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico']::TEXT[] AS tags,
    '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5f520a753babe8f509fefa1017b3bec5e2142586e0a973875cf8fb55935e1777'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Excelente profesor , muchas tareas y practicas pero vale la pena para estudiar para los exámenes, todo cuenta , revisa el trabajo en clase y las tareas con mucho orden , los ejercicios deben estar correctos'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4b333864ecb66ed7c625d102566cce33223893ffaae32a5b88803e2a6e72ebb6'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es un profesor muy bueno, de verdad se nota que ama lo que hace, deja bastante práctica. Las clases terminan a tiempo, va a un ritmo rápido pero se preocupa por hacer que su clase sea entretenida y de aprendizaje, llevaría de nuevo el curso con él. Brinda apoyo si ve que usted pone de su parte'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[] AS tags,
    '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ed7af4a5fa7d958db7b8f4842573867686e65725cbf389b6164f78e1e47a7b3d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un muy buen profesor, aunque mande muchísimas tareas vale la pena.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '23bb31b0236833b2f63337fe01c0be1a7bd6b92f34915d50ac1f49d6c0cce0fe'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es un profe que ayuda mucho con la nota, los porcentajes que no son examenes de catedra y se ganan muy facil, solo es hacer el cotidiano y quices ni tienen que estar buenos, deja muchas practicas para ayudar a estudiar y si quiere pasar mate discreta de una matricule con Marcial'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2023-06-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f0e11502196d4cd4e78dbd55845c494071a7d81cf6dc20935eeff1e3b8dffe2c'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es la persona mas amable y divertida del Tec, deja muchos ejercicios pero busca que sus estudiantes aprendan y se diviertan y le gusta que hagan todo en orden sus estudiantes'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2023-04-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '39be76909ef796250e86e03422f7dbac19195930f2a41c9a6035f9576fdf245a'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[] AS tags,
    '2023-02-16T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ef7504960a8c8b4211fbd719a43e569661a784ba8de295c9de400e36a3faeb58'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'La mejor persona que he conocido en el TEC. Ayuda muchísimo, explica genial y es una teja de persona, eso sí preparase para hacer práctica porque manda una cantidad enorme, sin embargo todo es para que le vaya bien en las evaluaciones que son de cátedra, pero con Marcial una ya va preparado.'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2023-01-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5ce5ee5abff078396cead38ba7c88498a82dc8c076b3ebac4be048c7c0e7fa3e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2023-01-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'bfcf4768ee7db2373cd6f4e2a201d0a33e86fe41c30026af960ca3784dd707d4'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es toda, de todos los profes con los que he recibido clases él es el mejor. Con el montón de ejercicios que hace en clase es fácil entender los temas. Además, las clases son muy entretenidas, es un pacho, a veces sale con chistes medio turbios pero todo bien.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[] AS tags,
    '2022-12-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1a6c3465713e56c44420d808488d08b8eb5de30402a2f57058666ef1f1f08c3b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe para cálculo, explica super bien y deja BASTANTE practica, lo que hace que uno vaya muy preparado para los exámenes, . Da las clases super divertidas.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Inspirador']::TEXT[] AS tags,
    '2022-12-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2538a7259c114cf6fb3fa060b0f09a7360a0c26b16a470f637a8f03e7af8a5b5'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'De los mejores profes del TEC para cualquier matemática, las clases son excelentes.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-11-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '82a02750600249894b858eb4735d6cdc0d663c74b3adb9a21767f4db84fd9979'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Maravilloso profesor, preocupado y atento porque sus estudiantes entiendan, explicaciones divertidas, claras y muy sencillas! Las clases muy dinámicas y organizadas, si le tenía miedo a las mates, con él se le olvida eso. Se hacen muchísimos trabajos, pero vale la pena 100%.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '877af3899415c3d383078d209e4c23414b6822f05f088884ecc479835455e371'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2022-06-29T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9d9f1f974d0920279ba172fcd3315952f15716fa291be58896023036eb871b0b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un profesor excelente, creo su clases somos bastante divertidas, y se encarga de q todos los estudiantes comprendan la materia ,ademas de q brinda bastante apoyo en las consultas y dudas que no tenga. Matricularia con el denuevo sin pensarlo.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '223019c3fea3bf07cc6b7ed9903a52b98b743ed7cbccab146918691c3b156533'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es el diosito de la docencia en matemáticas. Fue maestro del mejor profesor de mate que me topé en la UCR (Jose Acosta) y de verdad que ambos son unos monstruos. Si matricula con él, va a disfrutar demasiado cada clase.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2022-06-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ad5946a9ac69926fda835bf8d1faa407f816f181e52c3e6ce9f4508d42d676f5'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Explica un poco rápido, pero es un profe muy bueno Deja mucha tarea que si ayuda, pero quita bastante tiempo'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2a41c7003312f1bd62f9e6bd2d5861427fda2dd08f203af1be51da8655a28dd8'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Cuenta historias muy cómicas que hacen que la clase sea más amena , explica muy bien y deja buena práctica talvez un poco más de lo deseado pero en general muy buen profe'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo']::TEXT[] AS tags,
    '2022-05-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f28f954919c2b0f7671cc16d762aa2c873ff21cb5f75e206f14b8daf5e2b5189'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, me ayudaron mucho sus prácticas para reforzar la materia, siempre aclaraba las dudas y repetía la materia, muy agradables sus lecciones, lo recomiendo al 100%'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-05-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '30bda105aa80fdc9e5493d904c01d7cc17fda07d8ecab7e3fffde7be59f7ef12'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es una excelente persona, pero es un exagerado para dejar trabajos, cree que solo llevamos su curso. No matricularia de nuevo con él.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases largas']::TEXT[] AS tags,
    '2022-04-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f6f837484906d8ef04c1f546e8c64a69b0ee248b7b307da870476cdb3a59d098'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'La participación importa']::TEXT[] AS tags,
    '2022-03-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9d5653dff72762972ddac6a058b8832adf0aea16e72db2a826b936434dc6670e'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es el mejor profe de mate y yo creo que de todo el TEC, sus clases son súper entretenidas, explica todo bien y con ejemplos que lo ayudan a uno a entender mejor, y si tiene que explicar muchas veces hasta que se entienda, lo va a hacer, deja bastantes trabajos pero son muy entretenidos de hacer.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[] AS tags,
    '2022-01-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3f05eaced144dc35a165f4bc8ee79358a5578585d9321f84ea7deabdcc10f007'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un excelente profe, deja muchas tareas, pero se aprende bastante.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-01-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '22a316087f7a6afc5f80042726d8f5d9ef962d6c858f29fdfabc4e98ddd55fdc'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Excelente profe, hágase un favor y matricule con el'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-01-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '8e4a0d1c7c1a973492236e2a4c6f523192537038587928d8c57e74262374e2f9'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es el mejor profe, es super cómico, hace las clases entretenidas, él da las dos sesiones entonces logra abarcar todo lo necesario y deja muchas prácticas que al final le sirven a uno un montón'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'La participación importa']::TEXT[] AS tags,
    '2021-11-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e16b76ded830e1733d916615c98e75eb322e4114028d424de9c14392a1dd685c'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Super bueno Marcial, lo mejor de lo mejor, es extremadamente dinámico, le interesan cada uno de sus estudiantes, lo que más destaco para quién lo elija deja mucha tarea llamadas V´s que son muy pero muy largas que van de la mano de las Colecciones y que mínimo cada una supera los 100 ejercicios.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Clases excelentes']::TEXT[] AS tags,
    '2021-11-15T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'a81c7be5d6eb80a940d9539f3b3531b7e575b8396689fe9709c54a38b6e8b7a6'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es de los mejores profes, deja demasiadas tareas pero estas son muy útiles para estar preparado para las evaluaciones de la cátedra, explica excelente y no es de esas típicas clases bostezo, el único punto malo es que es muy exigente, no lo recomiendo si quiere llevar el semestre suave'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2021-08-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1e2100f5f4b1ea23cd2e14fd38544913da3af4723969ba1991db32bf479171f2'::TEXT AS import_key,
    ARRAY[563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es súper buena persona y muy gracioso. Hace que las clases se vuelvan divertidas y que los estudiantes se sientan cómodos. Deja muchas prácticas pero con el fin de que el estudiante aprenda bastante. A veces hay ejercicios más difíciles en los quices y en exámenes que los que explica en clase.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2021-07-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '33db2daf77b376d567baae6ab521dac400de215b75f2b060ceb3e75546bc68ba'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4fd10100f7be82d1d6731bfcfd58df9dccd9aa9dd3eaabee5adbde9dad405afe'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Muy buen profe, hace las clases muy entretenidas y de verdad es gusto asistir. Explica algo rápido pero no tiene problema en devolverse a explicar algo en caso de decirle. Deja bastantes trabajos pero no tienen tanto valor y si usted los hace lo más probable es que le vaya bien en los exámenes.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2021-07-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd33a280723ef5751a077075f50cf614f5fe129a908dcd8482067bb382d892522'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es muy buen profesor. Muy buena gente. Lo único es que deja muchos trabajos como prácticas, pero si dan bastante conocimiento. Si quieres aprender bastante llévalo con él. Los ejercicios en clase se explican un poco rápido debido al tiempo'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[] AS tags,
    '2021-07-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ac9874f24b0a82d3d6004e30833dfd3faf50efb358609a52689d9f59ac4df126'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Hace la clase muy amena con sus chistes y su gusto por enseñar. Deja muuchos trabajos, pero valen muy poco y ayudan mucho a entender la materia de los exámenes. Recomendado.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'db9f9d5ed685adb5656fa2b1b8e5a48c41a44caa016b9447aeb6d4fc4fb55f3e'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Él profe es excelente las clases son muy claras sin embargo, deja mucha tarea y a veces con poco tiempo para la entrega, en ocasiones no da toda la materia o no explica bien todo y en los quices lo pueden notar.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2021-06-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9ac8d16e9662c40ba833d5d595b29992831a1ec0a37d8428893fc19766d4be35'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'De los mejores profes. Ayuda mucho al estudiante. Deja mucho trabajo, pero resuelve dudas y estos trabajos ayudan al estudiante a entender mejor. Muy divertida su clase'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2021-06-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3a16c345a655a843839604c7217c2dce4b3f2fa376643ce1f8ed3144970e5358'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2021-06-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '18f143da75af01f82c3bbd0dc3c86dd5c8ac818638ddf117ac8897bb28dfd499'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Si puede matricular con él no lo dude. Es súper carga (inclusive a veces cuenta chistes) y hace un curso bastante pesado, muy ameno. Deja mucha práctica pero eso ayuda bastante en los parciales. En ocasiones explica un poco rápido pero siempre está dispuesto a aclarar dudas.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[] AS tags,
    '2021-05-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5d0c8d98aa60cc87a4e86fd43ff5c45fb7f59e49f9a64ab9740c617af114f9e3'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'A pesar de que seguramente en presencial es buen profe, en virtual es de lo peor. Se conecta tarde, se le cae el internet, hay que estarse cambiando de llamada, se confunde mucho con signos y a la hora de explicar lo enreda. Ni la evaluación es clara. Si puede matricule con otro.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    5.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases largas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2021-03-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '846481dc77018bb7a5ed0e62abd00e60b5fa70462381de021f10e7cd30f1ca38'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[] AS tags,
    '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '16d7a08fb0bf3611864fce7058bb96b7d24d93669c7e834c683de65c222e40ec'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Las clases son muy amenas, cómicas, cortas y provechosas. Ama lo que hace y es inspiracional. Eso sí, muchísimas prácticas y ejercicios pero que lo ayudan a prepararse para el examen. A veces explica muy rápido, pero está muy dispuesto a evacuar dudas. Es una odisea que grabe las clases y las pase.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '79f4111628023949ba4097a60c0ed83e113d55deba16b2a326724effa2eea7ec'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'EXCELENTE profe, hace una materia relativamente pesada sumamente cómica y amena. Si deja muchísimas prácticas pero que al final sale a cuenta porque los exámenes y quices se hacen fáciles por ello. Uno realmente no se siente en una clase de cálculo, pero igual aprende muchísimo, tira muchas bromas'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2021-02-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'da9d5f3d89da8a5056f49f13281171a55c8d13db7153dce8349dee7272a08891'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe es una teja, deja muchas practicas y si usted perdio un quiz por el tec digital, echele tierra, cuesta que los reponga. Pero de fijo matriculen con él, Se interesa en los estudiantes y le tiene amor a lo que hace.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Asistencia obligatoria']::TEXT[] AS tags,
    '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e64566a86448979896db29e9c6dca69f6c22af811bc5aec374f49c9a3c645d04'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es un excelente profesor, pero para matricular con él es un gran compromiso, deja muchas tareas, al final las tareas son tantas que se componen 300 ejercicios para solo tener un valor de 1/2 % de la nota, las tareas son pesadas pero muy útiles'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd1e61ce9208e2092ff200535bd654be7a39b88a00e1ec74ccb10e1dd7a7a84c6'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[] AS tags,
    '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '75d5d89a6705e54d5067afa097f06a744e78c7e3ca52ab5d616cadaab957ae5c'::TEXT AS import_key,
    ARRAY[2439, 563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Un profe muy bueno explicando, muy claro y bastante fácil de entender, además de hacer sus clases muy amenas. Es un excelente profe, pero hay que comprometerse ya que deja mucha práctica.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f127cde690208caeb9e692c624bf7c5cdfdc698f020ba77542ea401f02b02abc'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'En el modo virtual, se desenvolvió bien. Hay una carga alta de trabajos, tareas, quices y practicas en casa. Es muy buen profesor, pero uno debe estar comprometido.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Da crédito extra']::TEXT[] AS tags,
    '2020-08-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '300b09ad238c645936c6748b8411e37c6aad17f0a7363bec8b169159acc6e1ee'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es buen profesor, deja mucha tarea pero es por su bien , eso sí en virtual le costó un poco adaptarse pero al final lo hizo porque le interesa mejorar y sus estudiantes, recomendado'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'La participación importa']::TEXT[] AS tags,
    '2020-08-09T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f59886bef4e80cefe6b0e183feae3352f17c2911405668b89cf8c5cf1351472e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es el mejor profe que he tenido, tiene mucho conocimiento sobre los temas y lo sabe enseñar, las clases son muy provechosas. Si usted necesita ayuda con algún ejercicio el profe de fijo lo va a ayudar. Hace bastantes prácticas en clase y eso es suuuuper útil-'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2020-08-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '6e93cc96fc86c548878969b31bce2e73bd8a3bb7b1a262468ef5b0a47c9827dc'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, súper creativo con sus actividades tanto presencial como virtualmente. Se nota que le encanta enseñar.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2020-07-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '01a90521bbf452631f2bf5f9050b1cdf49db1d31d6ed90b76c27e9deaa053fff'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Excelente profe, sabe como captar la atención de los estudiantes y hacer que la matematica no sea aburrida ni tediosa. Gracias a este profe ahora me gusta mas la mate y se me facilita'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[] AS tags,
    '2020-07-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '34532c3f785886b6360ee1ef6b8d9021bf073280be2af73ea8b821862ad5cfa2'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es el mejor de los profes, tendría otra clase con el 100%, es muy divertido y le hace pasar a uno un buen rato a pesar de los trabajos que envía, sin duda alguna, de los mejores'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2020-07-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '120464a56d2ed0a16b2e17c98677741aa38f8443ac46bc80233560106cfe6230'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Marcial es de los mejores profes del TEC, nunca faltan las risas en sus clases. Si de verdad quiere aprender bien, lleve el curso con él, pero tenga en cuenta que debe llevar un orden en el cuaderno y pegar todas las prácticas, para él eso es importante.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Clases excelentes']::TEXT[] AS tags,
    '2020-07-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '71e8ff3462c0f4c7426a10913e3e881d7be3964df7838ff73ed9be20abff6869'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Es súper buen profe, revisa el cuaderno porque siempre da muchas hojas de práctica, pero si uno hace todo lo que él le da y trabaja y practica va a pasar sin problemas.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2020-02-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '0d42f4a4e1144ff7a38d4f92a3da2e3c32904df124eea42c324a4f82dd8f9e71'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'DEL TEC, POR LEJOS EL MEJOR PROFE'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2020-01-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd8dc20e263299d565384994f09c5383573a22554dd6f292b6d01fb5cd42aec5d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2020-01-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'df067dc19e1b1c667718085a1951272407a0c1c00b4a2b8fb81b4d0f18ec7b41'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Me ayudó demasiado a aprender lo que no me enseñó el colegio'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2019-11-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '614964f5411b81de5e5d59aafc2acce66fcbe051f55522f89b9d6decee2ae840'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Clases excelentes']::TEXT[] AS tags,
    '2019-07-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'a882ba0b402f1651c054bd048b31f0b36c34168f8875030ea44b553583052974'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Mucha práctica, explica super bien.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2019-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '59450e8278b0efaacf6b8564bbb806841d9818e9226d0b97ea5c0d5c8b80c080'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Se le nota su amor por enseñar, matricule con él y sin duda pasa el curso'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '881221798f1647cb2547a2d635c76ea60809e447d800d87ea840da10a5559acf'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2019-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c10c740f9a59cd03fb3b6444754068faac5d9a410fe6bfd81e0d5efd1e90a3cb'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Mucha práctica, el mejor!!'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Brinda apoyo']::TEXT[] AS tags,
    '2019-04-29T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7b13dd78e0903f7c847ae3422babbe68a26edc8f098e8708a742c252470f13d9'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Marcial es un crack! Es imposible no entender con él, deja mucha práctica y es súper vacilón jaja! SI usted presta atención y hace las "colecciones" es imposible que pierda el curso'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2019-02-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c9473378b58942364810e37fe435ca94aa3c23c4dbf6ce3ecb7d08ed25f625a8'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2019-01-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '83e104db44d2fe0a0e03183628ddbaed9be79f1e3fd6f311d86f1c21d9c260b9'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe que pueden tener. Explica muy divertido entonces es fácil de aprender. Deja mucha práctica pero sirve mucho para el examen.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2019-01-28T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '91e6e3182f63e313f179bb7747fc3cbba6eeb40fedda1ea0ef019a459ef868d5'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, el mejor que he tenido. Clases muy entretenidas y explica de una manera sencilla, deja muchas practicas que recomiendo hacerlas.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[] AS tags,
    '2019-01-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '56b18f9b6c76359049605bc7a0b1529a261af7511f5be366dd3dd5be320ed0ba'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'De mis profes favoritos en todo el TEC! Es demasiado gracioso, la clase se pasa super rápido con él y explica excelente, uno siempre termina entendiendo. Manda como mil ejercicios de pura práctica, pero eso es lo que ayuda al mejor entendimiento de los temas. Más que recomendado! Amé el curso por él'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2019-01-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5b353337a3130061ee01927468e2c306505ce68f4e10f542e132bf34c444d7c2'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    '5mentarios xD Es el dios de CDI! Otro nivel de profe, imposible no entender. Lo amé.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Clases excelentes']::TEXT[] AS tags,
    '2019-01-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9c03963c46a19b5cf526c9eb7dc0df1581ee41b9ad1bd64bcc83b2131b2dad8b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Marcial es algo así como un super héroe del cálculo.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2018-12-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '514ed87da17cbfddc9b4449b2a721178358050b34eb01f1f436f69be756b3da3'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Probablemente el mejor profesor de cálculo. Explica de una manera muy fácil y busca que todos entiendan. Deja demasiadas tareas y ejercicios, pero eso sirve demasiado para entender el curso. Lo recomiendo, matricule con él :D'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2018-12-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7dd432d99c323fcd505368136488253d0175beca3cb7cc395a4967021cc2b91b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente. Es muy divertido y hace sus clases muy entretenidas. Es el mejor profe de Cálculo. Va rápido, deja las famosas "Colecciones" que es una recopilación de ejercicios muy buenos. Sus tareas y prácticas son muy útiles. En consulta es muy amable. Explica muy claro.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[] AS tags,
    '2018-12-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7976820fa3a4f5dc488c3eaebb0b4f4a0193aaf381c27bce2efb40de4a6a1b4f'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profe, deja muchas tareas que al final ayudan demasiado a entender la materia Atento con dudas de los estudiantes, califica como se debe'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '355b7546ebf3dafaee0fc6f5c74cabe5af84114048a8ddcab4420143ed6cf7be'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'EL MEJOR PROFE!! Explica demasiado bien, todo se entiende, además es divertido entonces uno aprende super fácil. Super recomendado, con él uno además de pasar saca buena nota. Solo hay que tener fe.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da crédito extra', 'Clases excelentes']::TEXT[] AS tags,
    '2018-11-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '94500333f607d79ecdc6aa3eda940802e35ab26863e9173abff9bd29e7a414ea'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Simplemente el mejor profesor del tec. Es una belleza ir a sus clases. Es súper divertido y amable, él de verdad se pone en los zapatos del estudiante. Es excelente, sus métodos didácticos funcionan. Matricular con él es lo mejor que puede hacer.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-11-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ef5247e41b561c7825533ce1adcbea51a2ff3c4bf48485b75a2e811eb1dc5395'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Con el profe, no es necesario sentarse a estudiar. Deja demasiada práctica que se tiene que llevar al día pero esa es la ventaja. Prácticamente ve la materia de todo el examen en dos clases pero, no se asuste, usted le va a entender todo! :)'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2018-10-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'da93101ac7fab13efa955f3a03d0ba980320320e5799247375ba0ff572f2dc6f'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, clases divertidas y con mucha practica que hacen que al final no sea necesario estudiar para el examen. Con él se aprende un montón.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2018-09-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '424f6b5d52b537e561bd2d7b4dd3b7ab749ab4276d011bf6c63db385eac6ed8a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El verdadero "dios" de la escuela de mate, ayuda con los quices, explica cómo ninguno (aún mejor que Murillo en lineal) , y se preocupa por sus estudiantes es muy buena gente. Es divertido y creativo con las copias de práctica. Se le agradece un montón por todo el esfuerzo.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-08-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9e4f83945166ff6a00032a2c5900079c67470ca8bd8028f7e8f89e255208a825'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Pocos exámenes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'af74aabe4dff241d9e014bcf6f197d764bc673459b0224bfb6d9e0dcc86fd0f6'::TEXT AS import_key,
    ARRAY[1690]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Muy buen profe y además, muy divertido'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-06-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'de7ac811736b09506c669cc247ff4c64e54ddebe54d70291ad790edd723951c8'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'No hay que estudiar aparte si el profe es este profe. Las practicas que uno hace en clase son demasiado buenas.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-06-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '444828ece9ee0a54cabaa636d0e209e0c6943da224460a2e01088b9e442c8fa4'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profesor'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-06-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '11ec7f8004ca20740a3caa3071daede75b32f79ca28b57bc1f806b7c0e76e8ab'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es el mejor profesor que he tenido. La clase es super entretenida y eso que no e gustan las matemáticas. Deja muchas tareas pero fáciles y ayudan un montón. Esta interesado por el aprendizaje del estudiante. Muy divertido y amigable.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Inspirador', 'Clases excelentes']::TEXT[] AS tags,
    '2018-06-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'fdc08818c7756abaacf7be855e0d853e7b622ad3f7e9a0b3b75fdef15a398ea5'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-05-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '17b4bcfd4b67e6bf16cf5f57227a7c9437c128da55032115385b755276696e6a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Hace demasiadas prácticas que ayudan un montón, no lo piense dos veces. Es el mejor.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Brinda apoyo']::TEXT[] AS tags,
    '2018-01-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c7ca1b58b6b71f71177884663fe1d31c3f6a8e201e0b77580a22dde19df7193d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-01-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'dba7b59d540387fe1b7203e6acff793ff889b1751417dbd4de4e143ba6ed3e7c'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Buenísimo profe, de lo mejor que usted va a encontrar en la escuela de Mate, recomendadisimo, hace las clases divertidas y eso hace que usted le ponga bastante atencion!'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2017-12-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ea5b6ba295647cebccbde16acd654687737ff60b2a0e4c105db06be86cbe99fa'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profe, ayuda bastante, hace que todos entiendan y se preocupa para que todos pasen. Recomendadisimo, es un profe super tuanis'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[] AS tags,
    '2017-11-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ac3a3416b06eecfe621ee673c0328a139102645e01b7d0d573bae89c6cca0b7e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente persona y profesor. Clases super entretenidas'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '613ebe781798d49147c6d5a4e90a2ce83d5063a75d7c33883bd006885763f361'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Simplemente si puede matricular con él, no lo piense 2 veces, el mejor.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'bd0a79bf887fc3e0a36356de5cc087bb5c455b506bd87ecb3cf47c2584a08e83'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profe, deja mucha práctica lo cual ayuda mucho en el examen, los exámenes son muy similares a las prácticas.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases excelentes']::TEXT[] AS tags,
    '2017-06-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c90b8b7b883f39e61f492c9ccfe23691f84e0f9185041951bcea5b0231694563'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2da92bcdf9ecda944cf23a2683b364bec65c92d99ace771e6706ad5eb5f06a60'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Simplemente genial! Ayuda mucho a la hora de calificar los exámenes, hace las clases super divertidas, es claro para dar la materia y prácticamente se gana el 25% de quices solo con hacer todas las practicas en clase'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-09T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '47a1ed66061336619fde6cbab972ff247fa1c15f648a5867fca55a4cf3f9a66e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Es un profesor con el cual usted no se puede quedar, simplemente el lo ayuda a pasar los parciales, hace mucha practica y nunca deja quices, las practicas en clase las toma como quices, asi que nunca falte, super recomendado.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2017-06-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3e7d12153ec8c626df7578554a189f7b879082a04bd2c537d5d6da7f010f48f0'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'De los mejores profesores que he tenido, explica demasiado bien, se hace mucha práctica en la clase y estas se hacen muy entretenidas porque pasa haciendo bromas (hacen que uno recuerde detalles importantes en el examen). Simplemente es de esos profes que nunca se olvidan.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '69b9cf21b763e506020e4687a9a45390271c6ccd980660b839015539a2c92b3c'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2017-06-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3d4ef64feaa8bbe4d2c0d8cfa476de7632fe40a3e6f712db3a9a70e8e832da2a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Muy buen profe muchos ejercicios en clase y es muy buena gente, la clase no se hace pesada con él'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-02-16T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7c44e4d666df41e6e5b273e01c1680957dd9507fced37b949993b5d6fd2ce4c1'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Lo mejor de lo mejor, bueno explicando deja bastante practica pero muy sencilla y de una manera muy entretenida! En otras palabras es un crack!'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-02-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'cc66eb0a917796875ee6c923010cecf57382388fe1956f93a4fe106df83f8625'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'el mejor profe que he tenido'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2017-01-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '15a8fbde7c5f8194250d86c66b8636bd3d70fea1550c60f26ce30d53a7a56e6d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2017-01-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9b059b1ff1cd77525ba43a1d21918870b393027390dd83bd5b5255ddee856c9c'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Uno de los mejores profesores en el TEC, sin clases interactivas donde uno aprende mucho'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases excelentes']::TEXT[] AS tags,
    '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2a504f6a2d05a5f257cedd7ef3149149355d9308a6867bbe70695ab5aa1c9ca5'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Explica súper bien la materia, se hace mucha practica e clase y uno llega súper preparado para el examen, a parte se pasa la clase haciendo chistes y es muy entretenida'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2017-01-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c5e7d9a778187a00d8612949d03f2c634d6fea939df8f37dd5faaa24040a7380'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'No sabe nada del curso de Matematica Discreta'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    4.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas']::TEXT[] AS tags,
    '2016-12-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '6e54311f2fdea4414db9d71e4067f752a0d315b596fd9d2ff9c2386539e24dd9'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Es un excelente profesor, si ve esfuerzo en sus estudiantes, los ayuda a que se motiven aún más, se preocupa por los estudiantes que dejan de asistir a sus lecciones, dedica tiempo a preparar sus lecciones, por lo que es más el interés que genera en los estudiantes.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[] AS tags,
    '2016-12-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5605b81cc12ad2ec4e4a78301d91a1715ff27578acc46713a2b5de7810c857ff'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2016-10-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ff1a668b6177ad1b1d328e0c545b0bebfae0b03db9e60cea59dc7cc66b556e94'::TEXT AS import_key,
    ARRAY[2439, 563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-09-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f10c434c86824c23be5818bcf7e61c737d7bf40cf3b84aa0d1fa462b7cd507f7'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profe La clase es entretenida Ayuda en quices y exámenes Se aprende mucho'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2016-08-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'fec45b9b0280bea0a62d48fe44667a3bd67e2a0b6e4d56140f420d640c730249'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor profesional :)'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-07-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f71a19d55b7d020fa51a705fe70181132a45ee5eabfaa37725d5fd32815612a9'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-06-28T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '08c463ddda18fb3e5499a812f69c60769e39c7b1e387a330468d52a9473873c8'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'el mejor'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f3fc6abfb6b46d2bde2b9a68f3dfeb3120395dd0b89e5d546082df96d6901032'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[] AS tags,
    '2016-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '28f179f2ba7563599285087b8c581d5b0f671b122f4ca89b30176fde22488ff3'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor, sabe explicar y se preocupa de que uno entienda.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '11646b12b7d87dadc11f88ccff4e35a56a7720f988e6df992a0f2f7698bc3e7b'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Inspirador', 'Brinda apoyo']::TEXT[] AS tags,
    '2016-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'af869dc51d803cb1da50fe0be15be914d5c9169c3cfbc9cc7c0f91d810233981'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El profe llevaba años sin impartir el curso, no entendi NADA'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    4.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['La participación importa', 'Da crédito extra', 'Brinda apoyo']::TEXT[] AS tags,
    '2016-06-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ad0121630eff452194589eb53ee1b5c17131ed755ae9870851c985acd88ac245'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-06-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '990b786bf503195fd701eca74c19cc7241e26a939b9847023b6d4f6ec3edf726'::TEXT AS import_key,
    ARRAY[1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'EL MEJOR PROFESOR QUE HE TENIDO. EL CURSO DE MATEMATICA ESPACIAL SE ME HIZO FACILISIMO CON ESTE PROFE. RECOMENDADO 100%'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-06-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5edf13c7f6e7f67e65a059746b2fedd62d7ba3ce379df62516aa7c65d8b6795d'::TEXT AS import_key,
    ARRAY[563, 2439, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c394bc22c866b1d6741c8bf9febb4724078c7a80a68d044fdb990f5b286a093d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Imposible aburrirse con este profesor. Explica muy bien y mantiene el interés de los estudiantes, además ayuda cuando se necesita. Si quiere aprender bien sin llevar estrés innecesario, este es su profesor.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[] AS tags,
    '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '795314720c701a4a08a4bf1a99c62007c7b0d930aad94237d66f504db8819509'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'El mejor de todos. Punto.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-06-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '122e3e53e0140c7c28230f4d35fdf7a3f73ac15d2fc1d95813c2260a3237a02a'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Se le pasa la mano con jueguitos que al fin y al cabo no son de mucha ayuda, es interesante sin embargo las actividades deberian ser reducidas a la mitad y dejar las que tengan una enseñanza plena.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2016-06-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7813a302ce9bdeb2caf63d6eb42f5f0da23c2d6e6a8788c2277a166fcf3bde21'::TEXT AS import_key,
    ARRAY[1620]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'se pasa muy bien en todos los aspectos con el solo esforzandose es que se pierde el curso'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[] AS tags,
    '2016-06-01T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '77268989b641303d694b8fec60964414e3f21b9d3e89a7d10d755b6195a76a22'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Vuelve a explicar las veces que hagan falta'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-05-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '0f21f0407a14ef495ce49524ca51d1c08396daae3de4f1717373ed43ad71a83d'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Requiere mucha lectura', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-05-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '65a492f584abcf0d549bee4069b0527f04cb02dc0bd35a48094336f1f93b6e6f'::TEXT AS import_key,
    ARRAY[1620]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-04-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '38bc74411de5c659939f88e317523a800c448b231ccb8c4050e847e5dfe4d021'::TEXT AS import_key,
    ARRAY[2439, 563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[] AS tags,
    '2016-04-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4dd49db810164cc9b5da239cb24aa6c0c1f9615d643414232965fa64c037176c'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[] AS tags,
    '2020-09-29T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '08563ec8523b467465b2a35b0ce00a1b57b2b9f8608e58974053af54a61155fc'::TEXT AS import_key,
    ARRAY[2439, 563, 1018]::BIGINT[] AS course_ids
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[] AS tags,
    '2020-08-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5686938fee24570d604faf0e246ea8494d08048a38c396a462e557ebe84511d6'::TEXT AS import_key,
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

WITH review_input AS (
  SELECT
    480::BIGINT AS professor_id,
    'Excelente profesor, explica súper bien y hace mucha práctica. Si pueden matriculen con él.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[] AS tags,
    '2017-08-31T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f84f13c4ed81e9ed0b267c1cc86c9c55c0032a80b37c96f211d60c0e0b76660e'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'No duden en llevar cualquier curso de mate con este profe, lo mejor del tec'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c07e8715ced9a46adbb086cc5f9cdda7c61324ec40186358bd7598fb808cffa1'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Marcial es un super profesor, si tiene la oportunidad de llevar con él, hágalo. Sus clases son entretenidas, claras, llevaderas, explica muy bien, ama lo que hace, inspira a los estudiantes, da crédito extra, si usted es un excelente estudiante aproveche (los cupos se van volando)'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '99836ec37a287685b053c54d7305ed61076b0ad55253f90e940e9c79aaf203d3'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Vea, si quiere pasar cálculo a la primera llévelo con él y si está repitiendo tambien, el profe te dá todas las herramientas para que estudies y practiques, CLARO llega a ser mucho y sale caro por los 3 cuadernos que se necesita, pero si usted QUIERE pasarlo ahuevo y se esfuerza, a la primera ????'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Muchas tareas', 'Respetado por los estudiantes']::TEXT[] AS tags,
    '2025-08-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f16f3b91e6cc428b5e459136f8c34e04d00403d3df691bfabfe29de862a42da4'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Excelente profesor deja muchos trabajos para practicar, se preocupa porque entienda el alumno, si se equivoca corrige inmediatamente, explica muy claro y cuantas veces se lo consulten. De los mejores para calculo diferencial, las clases son muy agradables'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-10-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5dcb48c3c501de148efe26e113e24bd5cdcd948c0398ce6f225bdc99ae526e6f'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Para calculo es pésimo, deja cantidades absurdas de tarea sin tomar en cuenta los demás cursos o la recarga de su propio curso. Para el último tema acelera el paso y explica mal'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    3.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Exámenes retadores', 'Clases largas']::TEXT[] AS tags,
    '2024-10-15T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '29b53008f966d62118e8eee59814b4d22e2d1f1c3d90d141462b24eb85e40d46'::TEXT AS import_key,
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
    480::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[] AS tags,
    '2024-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '58c81430eb29e9b1bb9ef33320973c7bff81847df643baf7a02b81458fe52282'::TEXT AS import_key,
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

COMMIT;
