-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=619
-- TEC-DATA-META years=2018,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.458304+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (619::BIGINT, 'Lastimosamente es un profesor súper poco colaborador y no ayuda para nada a sus estudiantes , en ningún punto del semestre. Parece como si los quisiera quedar , pésima evaluación y pésima clase en realidad. Se vuelve un ambiente MUY desagradable por parte de el y completamente innecesario.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'ad1b9c937f9df3fa48a0b6ed6a988f9e268b669e344ce4390af61a31376f702e'::TEXT, ARRAY[1854]::BIGINT[]),
    (619::BIGINT, 'El profe es muy buena gente, tiene muy buenas intenciones y se nota su pasión por lo que hace, sin embargo, sus instrucciones con poco claras, da mala retroalimentacion, habla mucho pero en un final no dice nada.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2018-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'f3109d38a4c56c0000f5cee0b33140eaf30c8e11e79fc50a5763c588c89b0e9f'::TEXT, ARRAY[1874]::BIGINT[]),
    (619::BIGINT, 'Lee el libro en clase, se equivoca mucho resolviendo ejercicios. Exámenes difíciles y largos.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2018-10-04T00:00:00+00:00'::TIMESTAMPTZ, 'd9b1ec6c33e378339e65f9f41d27f4a58d88fb025ace783f4a656487140b01da'::TEXT, ARRAY[1854]::BIGINT[]),
    (619::BIGINT, 'Pasar es fácil, pero siento que no aprendí ni la teoría ni nada. Fue más una clase que lleve con YouTube que con él.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2018-06-14T00:00:00+00:00'::TIMESTAMPTZ, '74718fd30f0c022e4d1fcb622754e33a3406519032c6cfeeb7f11851ba2938d8'::TEXT, ARRAY[1710]::BIGINT[])
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
