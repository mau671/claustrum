-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=751
-- TEC-DATA-META years=2021,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.861674+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (751::BIGINT, 'Califica durísimo y se enreda mucho al explicar, no lo recomiendo'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'ed9d0fa92aae26915c35cc5fcbdb84447b41b19ce104c4280525a8d59b8f4c57'::TEXT, ARRAY[294]::BIGINT[]),
    (751::BIGINT, 'Aveces ni el mismo se entiende. En los exámenes habían veces en las que se equivocaba y cuando uno le decía que hacía falta algo para poder terminar con todos los procedimientos se enojaba y se cerraba. Si puede no matricule con el, de los peores profesores del TEC'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2025-12-22T00:00:00+00:00'::TIMESTAMPTZ, '8460a4614465e3517f503c1e03f595fd292f2fe7141c588bdbe98aa3d69a8270'::TEXT, ARRAY[2394]::BIGINT[]),
    (751::BIGINT, 'El profe hace que el curso sea más difícil'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Exámenes retadores']::TEXT[], '2025-10-06T00:00:00+00:00'::TIMESTAMPTZ, 'a3e947e2ac83e5c946f06c5722ad5a2233fac62491356d8ccada30176d2911d6'::TEXT, ARRAY[294]::BIGINT[]),
    (751::BIGINT, 'Es el primer profesor que siento me da a explicar de A a la Z sobre contabilidad. Califica demasiado duro, si no tienes bien el inicio y el resto malo, pues desde el inicio lo tendrás malo hasta el final. Explica bien, quices son teóricos. Llámelo, no le escriba por correo o WhatsApp por dudas.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2024-11-28T00:00:00+00:00'::TIMESTAMPTZ, '1e324dc1bce29103db4dce4bc45a8998580f38942434b8e46364055528b42004'::TEXT, ARRAY[2394]::BIGINT[]),
    (751::BIGINT, 'Es un excelente profesor.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-02-07T00:00:00+00:00'::TIMESTAMPTZ, '8020a7954837e975dc959e947b251f4e129687b1f5678ace5cd270b06160d388'::TEXT, ARRAY[289]::BIGINT[]),
    (751::BIGINT, 'El mejor profesor del tec sin duda alguna'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Respetado por los estudiantes']::TEXT[], '2023-11-20T00:00:00+00:00'::TIMESTAMPTZ, '16d22e51357506675da7fbf4f8ea81ec0f3b8a298d80dfe7c362b933f733516f'::TEXT, ARRAY[2394]::BIGINT[]),
    (751::BIGINT, 'Los exámenes son completamente otra cosa distinta a todas las practicas hechas en clase'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Exámenes retadores']::TEXT[], '2021-07-22T00:00:00+00:00'::TIMESTAMPTZ, '0a48dbe917263b923aabdc47d18a1ffac7abe942c7c402c831994cf4613d3e10'::TEXT, ARRAY[289]::BIGINT[])
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
