-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=118
-- TEC-DATA-META years=2019,2020,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.721000+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (118::BIGINT, 'La profe es muy tuanis, pero eso no significa que vaya a regalar el curso. Se recomienda tener un buen grupo de trabajo para no batallar de más. Si se hacen los trabajos medianamente bien pasarán el curso sin problema. La participación puede llegar a ser importante.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-30T00:00:00+00:00'::TIMESTAMPTZ, '90c9699042b28bf23691425cde17d85d8f1a1db7f266f5bb4604d70c597dcf8f'::TEXT, ARRAY[1004]::BIGINT[]),
    (118::BIGINT, 'La profe es muy muy buena gente, desordenada aveces. También hizo una competencia jugandose 5% de la nota donde no más de 3 grupos podían participar por pregunta y eran como 7. Al resto le ponia 0 aunque se la supiera y le insistiera. Cual es la lógica??? profe si lee esto, no vuelva a hacer eso'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2022-11-30T00:00:00+00:00'::TIMESTAMPTZ, '17a04fa8104712079334f130f8adcd226d71b5009696236530d692acb27a658b'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Esa señora deja un pichazo de trabajos, califica súper asquerosos, es muy pura vida, pero se pasa de caca calificando los trabajos, siempre deja trabajos grupales y la asistente que tiene es tan hp que ni siquiera se digna en responder cuál fue el error que tuvimos en "x" trabajo'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2022-11-10T00:00:00+00:00'::TIMESTAMPTZ, '8e66019c1f6d7cec72bb198b6ac0352c4e31d9282a14922a5d830bd973604738'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Excelente profe, explica demasiado bien y es muy clara con las tareas(la mayoría son grupales). Hay que leer bastante, sin embargo, las clases son muy entretenidas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-01-27T00:00:00+00:00'::TIMESTAMPTZ, '3c1607d95f700624faa9fef90b54eff3453cc08d89b16ad835ceaaf3a4710ea8'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Excelente profesora. Las clases son muy participativas e interesantes, los trabajos son algo largos, pero no complicados. Se pasa fácil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-01-24T00:00:00+00:00'::TIMESTAMPTZ, '3bc3ff4a289e384dbcddf294eff4e864a59cc5d954f26197ea06f7e421c40f08'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Ella es una profesora excelente, sus clases son muy entretenidas y algo participativas. El único problema es que deja trabajos muy largos para el poco porcentaje que valen, pero si los hace como a ella le gustan, no va a tener ningún problema en pasar.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-01-15T00:00:00+00:00'::TIMESTAMPTZ, '555563f3b69088b954fa4afd8168552bd040591e3f358451776b7c8ff208ee62'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'La profe sin dudas en muy buena, las clases no se hacen para nada largas y son en su mayoría algo participativas, no todas las clases son sincrónicas. Si usted es como yo que ODIA los trabajos escritos, créame que los va a odiar más porque deja demasiados y ya cansa. Califica suave. Se pasa fácil.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, '28021a0ce0f7152b8c93a2b72b6218abf718aba14d91d69bf563debbbd721b66'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'La profe cae bien y busca que los estudiantes aprendan de temas interesantes. Sin embargo, deja muchos trabajos para un curso de 2 créditos, tareas, análisis de casos, foros, presentaciones, proyectos y demás cada semana. Si entrega todo se pasa fácil.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2021-07-06T00:00:00+00:00'::TIMESTAMPTZ, '90ca80dea13b6b42ad3a3314d99c080a9cb8173035ded7b694ee6eafcdb30c41'::TEXT, ARRAY[1004]::BIGINT[]),
    (118::BIGINT, 'Buena profe, el curso es aburrido pero ella lo mantiene despierto al menos'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-09-01T00:00:00+00:00'::TIMESTAMPTZ, '4137a9b71984b491a73b3ff3cf74415dd15e13ad3050c1575216195ecb71afab'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Muy buena profesora y buena persona. Muy dedicada a su trabajo, ahora en modo virtual es muy considerada, deja algunas lecturas interesantes y clases dinamicas. Recomendada'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2020-08-24T00:00:00+00:00'::TIMESTAMPTZ, '5893618a4e1a4a9ee7021896f1086c300e65ab0f2fa5851b2b26525ae1c3a556'::TEXT, ARRAY[1004]::BIGINT[]),
    (118::BIGINT, 'Es una persona pura vida, pero se toma en serio su trabajo.Está muy atenta a los comentarios y recomendaciones de los estudiantes . Si a usted algo del curso no le parece se lo puede decir con confianza. Es bueno pedirle la rubrica de los trabajos porque a veces no las pone.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '99b34cb834c3c43c697e33d51f435340fb0fac671974b3abc0a0a4ae93367cb3'::TEXT, ARRAY[1004]::BIGINT[]),
    (118::BIGINT, 'Hace que la clase sea muy interesante aunque sea larga, al ser psicóloga le da un enfoque diferente a la clase, muy ordenada y buena gente, si puede matricular con ella hágalo, es un curso en el que puede tener una nota alta.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-19T00:00:00+00:00'::TIMESTAMPTZ, '0ad84437ee359587284c13084da875088b8555ad05e0f759aa3d1672cf588a1b'::TEXT, ARRAY[628]::BIGINT[]),
    (118::BIGINT, 'Muy buena persona'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Pocos exámenes']::TEXT[], '2019-05-29T00:00:00+00:00'::TIMESTAMPTZ, '535130e90416eaf0c2049cbfb39c713fc75763830cd1e4f2ae90fc7ddeddf70e'::TEXT, ARRAY[628]::BIGINT[])
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
