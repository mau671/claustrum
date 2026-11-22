-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=161
-- TEC-DATA-META years=2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.789704+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (161::BIGINT, 'Las clases están bien, la profe participa en congresos y a veces tiene reuniones por lo que deja clases asincrónicas, no suele calificar muy duro, es muy amable y simpática. Recomendeishon'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2025-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'fb376793a4b12546d57c56c47c0bb13582e7e10d574b6e7d453d67a0d71421a8'::TEXT, ARRAY[545]::BIGINT[]),
    (161::BIGINT, 'Muy buena profe, para ambos cursos, planea bien la clase, las evaluaciones están a nivel de lo que se estudia, muy divertidad y amable.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, '6bde3905389be412a8ae5518aea686d6d615052ee2cc024f31d089e4ab8da344'::TEXT, ARRAY[539, 545, 625, 547, 2379]::BIGINT[]),
    (161::BIGINT, 'La profe es muy buena explicando y hace las clases entretenidas, no califica duro, lo unico que es un poco aburrido son las tareas pero porque son muchas, pero son demasiado faciles. Matricule sin miedo es muy buena profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2025-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'c71e4cfb6026572146d9a17d8144458e49ea526bd22ba3b00effa602e077ba58'::TEXT, ARRAY[545]::BIGINT[]),
    (161::BIGINT, 'Muy buena profesora, hay muchos trabajos grupales y también trabajos individuales, se aprende mucho pero hay que participar mucho en clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'La participación importa']::TEXT[], '2025-06-16T00:00:00+00:00'::TIMESTAMPTZ, '0b24b01379c75f4b8f42349cf63d9fb7f8e0691d47d5b8a278e7ce83196b06c3'::TEXT, ARRAY[625]::BIGINT[]),
    (161::BIGINT, 'Le gusta a participación en clase, las clases son fáciles y trata de que sean dinámicas. Se pasa fácil, pero si deja muchas tareas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '764b77a68ec3ada3aa038829b4eeda4c0c063e2f8efc228d52fb857bf145c697'::TEXT, ARRAY[625]::BIGINT[]),
    (161::BIGINT, 'Muy buena profesora, hizo el curso interesante a pesar de la virtualidad'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-06-12T00:00:00+00:00'::TIMESTAMPTZ, '8055204e0792c7ef0b5d61fa706d441caa91c0a89eedab0c81531e7a4727a17e'::TEXT, ARRAY[648]::BIGINT[])
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
