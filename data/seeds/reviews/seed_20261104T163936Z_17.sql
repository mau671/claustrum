-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=17
-- TEC-DATA-META years=2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.277678+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (17::BIGINT, 'Honestamente, no entiendo los buenos comentarios. El mae no respetó la carta del estudiante, parece que no sabe de absolutamente nada del tema, las evaluaciones están 100% hechas con IA, son larguísimas y muy complejas en comparación con lo visto. Espero que lo echen o que hagan algo con ese mae.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2026-09-30T00:00:00+00:00'::TIMESTAMPTZ, '73868d538e0917099b8b031c7becbff1481cd9f173a18d015e3dc8d14af8e37f'::TEXT, ARRAY[1151]::BIGINT[]),
    (17::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, '63a780f8bc9915124b2742ad95a2624be517576aac4d97de3612cf25e4be3b54'::TEXT, ARRAY[2376]::BIGINT[]),
    (17::BIGINT, 'El curso es sencillo, si tiene que leer mucho y poner de su parte porque tiene enfoque de inestigación, casi todo es en grupos por lo que busque un buen equipo, a veces hace clases virtuales, es muy buena gente y ayuda dentro de lo que puede. Se programa en R y Python, aunque es mucho de excel puro.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'd8781ae973a0fee044b3e46dbdf64ffcd7dbbe19f1e2ae505031b639c28ce682'::TEXT, ARRAY[1151]::BIGINT[]),
    (17::BIGINT, 'Mae hagase un favor y matricule con este profe. Es la clase mas buena que van a tener en su vida. Va a pasar con minimo 90s, cuando esten en clase y hagan trabajos/examenes se van a dar cuenta porque si son lo suficientemente vivos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'd6596947643d30f475b14cb7f4671b234b1bd92a761a4ebf675292ec29ded973'::TEXT, ARRAY[2454]::BIGINT[]),
    (17::BIGINT, 'No lo piense, solo matricule. Es un profesor que sabe mucho sobre el tema. Se enfoca en trabajos prácticos para ejercitar lo visto en clase, pero no suelen ser muy extensos y normalmente se hacen en clase. Manuel le gana mil veces a Saul. Si pudiera llevar otra vez con Manuel no lo dudaría.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[], '2024-10-29T00:00:00+00:00'::TIMESTAMPTZ, '37e87bb4548400f8e367f8c2c4ce7d5691e4af6f0e4bb83ab90f488ec31ff56b'::TEXT, ARRAY[1151]::BIGINT[])
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
