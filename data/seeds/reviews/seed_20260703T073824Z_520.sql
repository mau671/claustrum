BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input AS (
  SELECT
    520::BIGINT AS professor_id,
    'Gran profesor, ayuda muchísimo a los estudiantes que se esfuerzan, explica muy claro y atiende dudas. La clase es con folletos y apuntes digitales y si van bajos organiza una actividad final para levantar nota. Simplemente Parra, es un profe muy humano, muy recomendado 10/10.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '406b2c30a6cea8db22fdcc2820ac8ebc9c017393b896c57f76423e9fec4290ae'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Excelente profesor, puede estudiar de su folleto y las prácticas de la cátedra y le irá súper bien. Recomendadísimo.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '100'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3fb1d6d2be3258f937ed9de2db27a7e2c1e7dd156b7cba39e6ceec8feaf8d387'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'El sistema de evaluación diseñado para este curso es pedagógicamente ineficiente y no ofrece un margen real de mejora para el estudiante. Al asignarle un peso del 60% a los exámenes y un 40% a quices semanales que funcionan como pruebas cortas sin espacio a la retroalimentación, el curso castiga sev'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    4.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Clases largas', 'Muchos exámenes']::TEXT[] AS tags,
    '2026-06-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd87fc73802ab0a3489ed4ddc92d0f488b059edcb556c1a2cc5cc4398bcee0ab1'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Es muy buen profesor y es super buena nota. Intenta explicar los más claro posible por lo que se toma la clase con calma y puede llegar a ser un poco aburrido. Los quices son sencillos, es muy flexible y super ordenado, además de que no califica duro.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '65'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '024949a2c9c97c1d2d2945641db032766677866298765468699cf48e3ca52cad'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Hace que las clases son aburridas, explica muy lento se hacen solo como dos ejercicios por clase, aprendí más por mi cuenta que yendo a clase. Por otro lado los quices son muy fáciles 25% regalado si práctica antes.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1ce972affcab5dd324b0ad17e6105f6f360e39fe90ebb0298cf8d16111dee80c'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Es el goat. Es muy ordenado en cuanto que va a hacer cada clase y en general las clases las hace muy bien, explica la teoría y luego hace todas las prácticas del tema. Lo único que podría poner a mejorar (si acaso), es que tiene una voz bastante monótona entonces puede volverse aburrido. Un exc prof'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f686e55f45e568091092511cdcab80496ce93c758233653318780dbe7cc72e23'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Las clases se hacen largas y aburridas, pero el profesor es buena nota, brinda bastante ayuda y proporciona bastante material'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-12-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7634467408931133bded63c80397bbee2b0283693929976dbe98f152945eb75b'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'el mae da buen material fuera de clases y se agraddece, pero explica super confuso y se para y medio'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    5.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas', 'Brinda apoyo']::TEXT[] AS tags,
    '2025-10-09T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '93943e6256cef1b68290b5fb9db8456d6122245141ea6befffbc1f1d4f96dc6d'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'El GOAT de Superior, sin duda, explica súper bien, hace nada más 3 quices bastante normales (nada muy duro) y 3 tareas (igualmente bastante simples), y califica muy muy suave, se pasa super bien el curso con él y se aprende bastante'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Pocos exámenes']::TEXT[] AS tags,
    '2025-08-10T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ab99c2d2ab8f5a5e583065b766bf58c568e7edb54032083b4366ae3b9fecf481'::TEXT AS import_key,
    ARRAY[923]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'A pesar de que califica algo duro, es un excelente profesor y es una gran adición a la escuela de matemáticas. Los quices son difíciles, pero en clases cubre todo, entonces los exámenes se pasan fácil.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[] AS tags,
    '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '8c688dfe50b4c678b9521766e6196f0f12319b4a9f4172a8d909e3c4b29da8b8'::TEXT AS import_key,
    ARRAY[923]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Es un excelente profesor, explica muy claro y realmente se interesa porque el estudiante aprenda; siempre está muy anuente a explicar en consulta y es muy buena persona. Además, ayuda bastante con las evaluaciones si pones de tu parte y ve que te esfuerzas. Ultra recomendado para CDI.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '46b529b980723059c5f51d7f970350b29825069598bc75ed309efea9e7a229ab'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Excelente profesor, hizo mi experiencia en CDI muy gratificante. Logré aprender mucho con este profe. Súper amable también. Aunque el curso es difícil, es posible pasarlo aun sin tener mucho tiempo para estudiar (mi caso). Gracias a que con las clases uno aprende mucho, estudiar es muy liviano.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-07-16T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ea11e959fb5deb45dee9ffabbc2705c99acddfb3c2261857b069a711fe5314c8'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2025-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f654c48376e319a9fee3c93438320a2d1444180c79f58ed8625bbb88b15fefa7'::TEXT AS import_key,
    ARRAY[923]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Excelente profesor, las clases son muy claras pero si califica un poco fuerte'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2025-02-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ae1ce3922a8d001e1978d715d3632cfc3b8102d1d304baefe2268131cfa438ab'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Muy buen profe, no tiene mucho rato en el TEC por lo que es poco conocido. Estudie los ejercicios que el hace en clase para prepararse para los quices, suelen ser con dificultad media/alta para prepararlo para los exámenes. Recomendado.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2025-02-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9d7b77ccb0b4414084ed4a2e50c1d67f07d1e1c831eed1b92643b3326ad20620'::TEXT AS import_key,
    ARRAY[923]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Domina la materia, es muy amable, muy buena nota. Califica justo, además, aprecia su interés, casi siempre está disponible para consultas. Los quices hay que prepararse bien. En general muy buen profesor para proba, pero como consejo, estudie mucho también con exámenes viejos y cosas de catedra'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[] AS tags,
    '2025-01-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2f508bd04d5dae5afa2d7a090dbbdae72ac66150000e033081afc5b216a1e6ef'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'El profesor califica de manera justa, se preocupa por que el estudiante entienda y le vaya bien. Es mejor estudiar con examenes viejos o material de cátedra. Tareas sencillas pero quices un poco rudos. Excelente profe.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-11-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '5f0c951e38afbf941c9d170924858dfd6ea65ff2cf6cd3b85efa2f0a37e0868e'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'El mejor profesor de matemática que hay en el TEC. Explica la materia de forma muy sencilla con ejemplos muy variados. Se le entiende a la perfección y tiene preparada la materia de todos los examenes para poder imprimirla y seguirla durante la clase. Califica justo. Solo prepárese bien para quizzes'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-11-30T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f3755c9d92af097bf25cb649d2d321280745247babf5b43128a44e4a8d1eff86'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'El profesor domina excelente la materia y explica muy bien, pero explica cosas complejas que no se evalúan nunca en los exámenes. Califica justamente, y los quices y tareas son bastante claros. En general, siempre está dispuesto a ayudar. Si lleva con él estudie con material de cátedra mejor.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[] AS tags,
    '2024-11-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '6f0cf130533105118885a9193ecc7d2301028e359c761675b511fbeb71ec02f1'::TEXT AS import_key,
    ARRAY[1049]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Muchos exámenes', 'Exámenes retadores']::TEXT[] AS tags,
    '2024-08-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b1826845311948a8990f3b283d648e109935c3834a9c3450489c60177f814257'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[] AS tags,
    '2024-06-04T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '79d54dd9da3a682e4ebde3f1096abfd8ef673ce53441ab46e49041bf6b73a85d'::TEXT AS import_key,
    ARRAY[923, 605, 634]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Excelente Profesor, de los mejores de la escuela de Matemáticas, volvería a llevar con el.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-05-25T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '11ba5b2d02fe3aecaaf124b692a76b5e1d508355d1cb881c2486517806f9a150'::TEXT AS import_key,
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
    520::BIGINT AS professor_id,
    'Normal'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas']::TEXT[] AS tags,
    '2024-05-03T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1ec7066484089dbfcc22a9404e5721aad66076214ecf4b75911589020deefb00'::TEXT AS import_key,
    ARRAY[923]::BIGINT[] AS course_ids
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
    520::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2024-01-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e80cdc43c3c659390fccfcfc4144c21175a92913c89cc06efd7935dbae18258a'::TEXT AS import_key,
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

COMMIT;
