BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input AS (
  SELECT
    1234::BIGINT AS professor_id,
    'Excelente persona, muy interesado en el aprendizaje de los estudiantes.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '8f6b6b9d6806ef8d6520473918682b35f96cbb4d05ca309b1ef197d9c2ce82be'::TEXT AS import_key,
    ARRAY[3197]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'excelente profe'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2016-02-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '45cec7ae11d97eea80324b57f2191ae78238e62854124addf367ba73741f3a5c'::TEXT AS import_key,
    ARRAY[3159]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    NULL::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1a544806db7b503e85423d6d1457aaa9c76c0955c7b2e9267ac714d58abb24f9'::TEXT AS import_key,
    ARRAY[3189, 3188]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    NULL::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2015-01-15T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3330b36e1ad94f9f26a43718baca4509e39844641940c8413ddcbda700aecbb7'::TEXT AS import_key,
    ARRAY[3159]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'Excelente profesor y excelente persona, explica bien y califica suave, deja muchos trabajos pero la mayoría son accesibles, muy recomendado.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    NULL::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2014-11-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4f87ecd9833dffa9b7247e5ffe1456f4c96707f641cdb361cabeeef952afc310'::TEXT AS import_key,
    ARRAY[3159]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[] AS tags,
    '2017-06-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '24c6bc6ac5f623bfb34eca21ce88f86756eefdf7341a73b5468511b3b7a7f299'::TEXT AS import_key,
    ARRAY[567]::BIGINT[] AS course_ids
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
    1234::BIGINT AS professor_id,
    'Es un profesor muy suave y nadie se queda con él. Si tienen que llevar un lab, de fijo llevenlo con él'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[] AS tags,
    '2016-06-15T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2eb0173ac070d749216e4e45c3b44679f1fa3ae69ad76dfbf06e921d56b5d8b3'::TEXT AS import_key,
    ARRAY[607]::BIGINT[] AS course_ids
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
