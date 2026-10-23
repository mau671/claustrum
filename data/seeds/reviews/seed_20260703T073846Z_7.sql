BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input AS (
  SELECT
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    5.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Clases largas', 'Exámenes retadores']::TEXT[] AS tags,
    '2026-02-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '559b6b0b2572179bc59e07d2f381ff440b9f667b3a1609a1fa4cca3e6ed76e12'::TEXT AS import_key,
    ARRAY[2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Con el profe el curso de conta no es fácil, los exámenes hay que estar muy preparado para obtener una buena nota, ya que son difíciles, hay que ponerle bastante para pasar bien.'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[] AS tags,
    '2024-12-20T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4b8c01ea5a878548981c5f734f18c0864b649b49caf41fdd8e1b42c307d660a4'::TEXT AS import_key,
    ARRAY[1707]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Lo recomiendo para llevar el curso de Matemática Financiera. En contabilidad lo recomendaría solo si uno tiene buenas bases en conta o experiencia, ya que explica muy rápido, eso sí se nota que sabe mucho La única razón por la que pasé esta materia fue por el gran porcentaje que tienen los trabajos.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2024-06-27T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c0daa8c54d7ce815f5623defd237ba5e787fbf6a2b8d76820da6dd31d9f0f454'::TEXT AS import_key,
    ARRAY[1708, 2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'No explica y nunca me planifica sus clases'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    4.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '65'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchos exámenes', 'Exámenes retadores']::TEXT[] AS tags,
    '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '7a845ed9f92031df6456c69b5560aca315724ece7756beb3450edbd69db694ac'::TEXT AS import_key,
    ARRAY[1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Conta II y Mate Financiera son en si cursos rudos. Si recomiendo a Lino porque hace los examenes vía GAAP. Pero si debo destacar que hay que ponerle con él. Y procurar poner atención, de ser necesario, el vuelve a explicar la materia. Con el es dificil quedarse mientras se entreguen los trabajos.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '70'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[] AS tags,
    '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '559852901e02064f2936e5c8a4a8500050e0630cde100efcd77e409b4b7e185b'::TEXT AS import_key,
    ARRAY[2361, 1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Explica bien, pero no se puede contar con él para dudas extraclase. Cuesta mucho que conteste un correo, o Whatsapp. Nunca tendrás razón en apelar un examen. Si estudias por tu cuenta, presentas tareas, y asistes regularmente a clases, pasas. Atención a los exámenes: tienen cáscaras de banano.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clase fácil', 'Exámenes retadores']::TEXT[] AS tags,
    '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '920398d6a25e38bc4264aa926c49ade0b50d00a5defd34f23b2b6b350ac38eaa'::TEXT AS import_key,
    ARRAY[1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'El profe dura mucho entregando los trabajos, y no da la retroalimentación que uno espera, esto me costó para aprobar y no logré aprobar.'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '50'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Exámenes retadores', 'Deja trabajos largos']::TEXT[] AS tags,
    '2023-01-11T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '4c967ef8735d0cae5bde4271f038e9ff1d7a463168f2aa14aae49dc9db33f18f'::TEXT AS import_key,
    ARRAY[1707]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Es muy buen profe, muy buena gente y los exámenes son en el GAAP, entonces se pasa con saber la materia muy bien. La verdad si lo recomiendo'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2022-11-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b34fbac1a3c9d72f4bfac45bb8b14f513592fb11d82de9d0484e5e75b655eb70'::TEXT AS import_key,
    ARRAY[1707]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Juega de buena nota y ajá. Es más difícil contactarlo a él que al presidente. La mayoría de cosas las explica en presentaciones y claramente no se entienden sin la parte práctica de Excel. No es el peor profe, pero sin dudas queda a deber muchísimo. Los exámenes y quices nada que ver con lo visto en'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    4.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[] AS tags,
    '2022-11-18T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'f9c30bc6a725f4c5b520e55ed2384e3c44056db6f9c142c50444a0ffebaf1e90'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'El profe es muy accesible, pero los ejercicios de los exámenes no se ajustan a lo visto en clase. Igual es muy comprensivo y si lee del libro de fijo lo pasa'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchos exámenes', 'Brinda apoyo']::TEXT[] AS tags,
    '2021-07-21T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c73b363d7a66759128279187cc1f084a2e98387ab8df35affab6a9891e088e73'::TEXT AS import_key,
    ARRAY[1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '0d075c4122d8040450d51ecac1c2bf506df006b7eb48e42e0a63f4e04f36c40e'::TEXT AS import_key,
    ARRAY[2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'El profesor es muy bueno, explica bien y va al grano. Los exámenes se pasan con la materia vista y entendiendo. Se atraso mucho en entregar notas de varios exámenes. Los exámenes se hacen en forms y se basan en la materia dada, no hay sorpresas.'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchos exámenes', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[] AS tags,
    '2021-07-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'e64e2c95dbcb0513c8848040f148d9dfe8966525775a51132d73d174bed50f7b'::TEXT AS import_key,
    ARRAY[1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Lino es excelente profesor. Él siempre explica todo y siempre está dispuesto a ayudar. Es excelente persona y siempre califica lo que da en clase. Explica muy bien.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '3e66f319931e85045351273523c8ec52700a342339164fe6d69c27d4c55750b7'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Nunca entrega los resultados de los examenes a tiempo, no contesta correos ni mensajes de consulta.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    3.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '67935c5606fe66187e5465326e50a41e43248715166075cf1c67150b33d94895'::TEXT AS import_key,
    ARRAY[1708]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'En mi vida vuelvo a matricular con Lino.'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Muchos exámenes']::TEXT[] AS tags,
    '2020-07-02T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '71ad6b568295b78c7c7c0727a4a46f2f276c84c35bffd47f9437816a728b015f'::TEXT AS import_key,
    ARRAY[2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    9.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '95'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2018-06-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '97b82c289bc145df3f448f2a690bbd65b5d930fb87aae521a5e05b22175d9ce0'::TEXT AS import_key,
    ARRAY[1707, 2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-06-07T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '2b0c7d98f90219fff9ba7d68da07aa9781a24c17ddb46173b1c3c9ca07b1988d'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    2.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas']::TEXT[] AS tags,
    '2018-05-17T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '9cc4342e7fe70eaba643ad37047a552fbc2cc94d17545b8d638f082c80f6755c'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Se enoja por todo, no explica claro, se sale muy tarde, no da hora de consulta, no responde correos, los trabajos no tienen relacion con la materia. No lo recomiendo para nada.'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    2.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[] AS tags,
    '2018-03-12T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '1df298d1d3ce5d4d9718d13aa5e33caaa2cfa16bc8ab68694be50bde1ad6063d'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Es un excelente profesor. Las clases son super claras y si a alguno no le queda claro algun tema no tiene ningun problema en explicarselo las veces que sean necesarias, las practicas que da con muy utiles y las clases son dinamicas. Las clases si se terminan hasta la hora que dice el horario.'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-02-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'b5bf728ad489ff6136a26b18d168124d90af102108e44d598d7c7b03c7f79518'::TEXT AS import_key,
    ARRAY[1707, 2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    10.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '75'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[] AS tags,
    '2018-01-19T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'ed0aa949e61f365774fa1e66175758f90a275d8572edfd9e1fefdb34ac2e4fcc'::TEXT AS import_key,
    ARRAY[2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    8.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '85'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Clases excelentes', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2018-01-16T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'c614418f17af00edc931c15bcef30a33f42647b78a1efe46309adaca2367cbd1'::TEXT AS import_key,
    ARRAY[2361]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    7.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    FALSE::BOOLEAN AS attendance_required,
    NULL::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[] AS tags,
    '2017-12-26T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '0e0e407b1ee270cb036e1e3a31470cab66f7dbf2b50dd4fc5777878f7d494392'::TEXT AS import_key,
    ARRAY[2366, 2361, 1707]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Si uno no sabe de conta se va en todas, demasiado enojón, el proyecto es un enredo y no coincide con lo que se ve en clases'::TEXT AS comment,
    8.0::NUMERIC(3,1) AS ease_score,
    6.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-11-08T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'a3bc98c4660e28c6c2df5e4a8f620e76878b729365e0ec7abd7ef0237884ebec'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'No da practicas, explica muy rapido todo y no se entiende. Se sale hasta ultima hora. Si puede no matricule con este profe. Se enoja por todo, las evaluaciones son confusas. No da hora consulta. Trabajos de investigacion no son acordes al curso.'::TEXT AS comment,
    4.0::NUMERIC(3,1) AS ease_score,
    3.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '80'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[] AS tags,
    '2017-10-23T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    '29d9ca596e8cc7b6f8f7c23071f10bebe426a7afd68639296fb14672537a0fdd'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
    7::BIGINT AS professor_id,
    'Ninguno'::TEXT AS comment,
    6.0::NUMERIC(3,1) AS ease_score,
    10.0::NUMERIC(3,1) AS quality_score,
    NULL::NUMERIC(3,1) AS clarity_score,
    NULL::NUMERIC(3,1) AS fairness_score,
    TRUE::BOOLEAN AS attendance_required,
    '90'::TEXT AS grade_received,
    NULL::SMALLINT AS engagement_level,
    ARRAY[]::TEXT[] AS tags,
    '2017-06-05T00:00:00+00:00'::TIMESTAMPTZ AS created_at,
    'd103b32886c847d6cae92be4098de06b5168763354ae9e8f2ae02cb89bda08d1'::TEXT AS import_key,
    ARRAY[2366]::BIGINT[] AS course_ids
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
