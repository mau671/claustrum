-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1123
-- TEC-DATA-META years=2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.017386+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1123::BIGINT, 'Un buen profesor, se nota que le gustan los temas del curso, toca puntos importantes para dar un opinión crítica, pero deja muchos trabajos que quitan mucho tiempo y lleva la clase muy rápida.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2023-05-16T00:00:00+00:00'::TIMESTAMPTZ, '14cbc3dd9f7a46784281e71d0fc02d933a76e9f2d7ce1063da2d985a793f370b'::TEXT, ARRAY[4518]::BIGINT[]),
    (1123::BIGINT, 'Un curso la verdad sencillo, que puede pasar con ver el material que deja y hacer su análisis en 2 horas. Además de que él es pura vida, la clase es interesante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-28T00:00:00+00:00'::TIMESTAMPTZ, '39c0bd2c3fa9294c5ecf0c49b8aa64e2978417d959baae3a3ae98c713d1cd63f'::TEXT, ARRAY[688]::BIGINT[]),
    (1123::BIGINT, 'Es un buen profesor, sin embargo algunas de las tareas semanales demandan mucho tiempo. Las sesiones son cortas, no más de una hora y siempre atiende las dudas que puedan surgir.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Deja trabajos largos']::TEXT[], '2021-11-20T00:00:00+00:00'::TIMESTAMPTZ, 'd76a1d736a69269fce54979acfa3c902458d9acaede4f11094ad208ccd943fee'::TEXT, ARRAY[688]::BIGINT[]),
    (1123::BIGINT, 'DEMASIADO para un CFH y si llega a faltar o llegar 1 minuto tarde prepárese para hacer aun mas trabajo'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2021-10-15T00:00:00+00:00'::TIMESTAMPTZ, '1cfbd2ca21c450b53b241d48a77bf9f154f8d99b0b89efa588faf876d4a3e25c'::TEXT, ARRAY[688]::BIGINT[]),
    (1123::BIGINT, 'Deja mucho trabajo para ser un centro de formación humanística'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2021-01-24T00:00:00+00:00'::TIMESTAMPTZ, 'd0e9144d0fcf317803ffe025810b2e19bad1ddf176c251913f4304d973befc9c'::TEXT, ARRAY[688]::BIGINT[])
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
