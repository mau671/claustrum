-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=25
-- TEC-DATA-META years=2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.740824+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (25::BIGINT, 'Le recomiendo no llevar cursos con el'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2023-09-09T00:00:00+00:00'::TIMESTAMPTZ, '9d293d222bd806499a88bd95c60cfc1c5b13703e81d6c0c864850b182f20313a'::TEXT, ARRAY[1707]::BIGINT[]),
    (25::BIGINT, 'Los exámenes son demasiado similares a las prácticas. Las tareas son funcionales para los exámenes también. El profe no es complicado, eso sí, la única manera de contactarlo es en el tiempo de la clase. Él está a disposición de ayudar y explicar de nuevamente. Si usted es autónomo lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '73cc7e580b8d94fa095a2fd71e00302f1eaa2788f3d22d0d0226fe0bfbd7b7b1'::TEXT, ARRAY[2394]::BIGINT[]),
    (25::BIGINT, 'El profesor es buena gente. Explica bien la materia. Pero para contactarlo, es más fácil contactar al presidente o al Papa. Los exámenes son muy parecidos a las prácticas que deja. La tareas con sólo presentarlas ya tienes los puntos. La asistencia no es obligatoria, pero mejor vaya si quiere pasar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Aspectos de calificación claros', 'Exámenes retadores']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'a073e710878a239c114140a05f59c1a110af0519b2583f59464d135bf3582109'::TEXT, ARRAY[2394]::BIGINT[]),
    (25::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'c58c38a919fb78c3782863989ea3be4e43c17d89d5fd77a06ac7008da0a0bc51'::TEXT, ARRAY[2394]::BIGINT[]),
    (25::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, '864ee1de451cc0de41fd2e8e72f9f86ebd6cd9308f8ee4cc5f81053bc3b3a027'::TEXT, ARRAY[1707]::BIGINT[]),
    (25::BIGINT, 'Con hacer las tareas completas (sin estar correctas) le pone el 100, a veces igual en los exámenes; pero para entender la materia 0/10, muy desordenado, no contesta consultas, revisa los trabajos hasta el final del semestre. Si quiere aprender, no lleve con él. Y use las horas consultas'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-03-14T00:00:00+00:00'::TIMESTAMPTZ, 'ef593445bfc61a8f8eb750de4228c67ed2923a83ad76b82ebd5137b26ea04bfe'::TEXT, ARRAY[1707]::BIGINT[]),
    (25::BIGINT, 'No aprenderá mucho, le recomiendo matricular si tiene conocimientos básicos de contabilidad, nada más.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, '6c68de8d99eea93b73aae323778dbbfe20f13c5eceb0b3e207cbb046be1844a9'::TEXT, ARRAY[1707]::BIGINT[]),
    (25::BIGINT, 'El profesor es muy buena persona, pero diría que no tiene buena vocación para ser profesor. Además, que es un poco desordenado. Sales bien, pero no aprendes mucho.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, '126272a55344aa5fefb72ef79ed6eaa57b5716fd4e236345255f20bf5057fdea'::TEXT, ARRAY[1707]::BIGINT[])
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
