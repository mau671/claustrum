-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=232
-- TEC-DATA-META years=2019,2020,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.753242+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (232::BIGINT, 'la verdad es que es la cabra, el asistente califica duro pero nada del otro mundo, siempre ayuda con dudas, no ayuda solo si lo bombardean mucho de dudas pero eso solo pasó en unos pocos casos, a mucha gente se le hace difícil pero porque la materia es dura, no por el profe (en este caso)'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '0bffa0a21e9610a6db715fd181c8ab833ba9c99960c58524b811fcd2a332792e'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '7a5c63ba7136bcf6cae584e4be0ef56e9bce48ccf3b11fd20ece40a392e9aea9'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Explica muy bien tanto en teoría como práctica. Casi nunca hubo confusiones y cuando las había no le molestaba explicar algo varias veces o adaptarse.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'f0a50cc7b803c8cce367a8b5e7e18bd4d29122157460a7e8ad9fea7893bfdbbb'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Califica muy duro. Si quieren buena nota, no matriculé con él, baja demasiado puntos por todo. Aprende uno bastante, pero califica demasiado duro'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2025-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'a48d27832b004eefdb49d26b5b7ba11d7805de12ea0816cd17e6dddcf4aa36fd'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Califica demasiado duro, las tareas las califica el asistente que califica el triple de duro que el. explica con un ejemplo y pretende que uno sepa hacerlo todo.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-04-19T00:00:00+00:00'::TIMESTAMPTZ, 'ae80aa5bf5177109774ed7c9ee586140bc60212859ec0dff5a609039265ba387'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Sin duda, es un excelente profesor, explica demasiado bien y todo queda super claro; en ocasiones, puede ser estricto con la calificación, pero eso hace que uno aprende demasiado. He aprendido mucho del curso y me ha gustado. Matricule con él si quiere aprender de verdad. 10/10'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-01T00:00:00+00:00'::TIMESTAMPTZ, '1774312109ab1cc3145d225a3180bfb5553f8acdda22b6db485983bb88b444a8'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2019-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'fdbd01381fb9f0c68cd588d8806e8d9879d02ca88f9ebb3457c69978b0912089'::TEXT, ARRAY[610]::BIGINT[]),
    (232::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2019-06-21T00:00:00+00:00'::TIMESTAMPTZ, '63f8a9dc62f1e3dae439cca17378b163a766bc64e0acd25a62b3427049f4ef5b'::TEXT, ARRAY[610]::BIGINT[])
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
