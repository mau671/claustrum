-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=383
-- TEC-DATA-META years=2021,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.203998+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (383::BIGINT, 'En mi experiencia los profesores de la escuela de Electrónica no hacen un buen trabajo explicando conceptos físicos ni matemáticos. A la hora de responder dudas quedan cortos. Esto es, dejan explicaciones sin terminar o no saben contestar. Es mejor ir a preguntarle a profesores de física.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-02-22T00:00:00+00:00'::TIMESTAMPTZ, 'a50a21ad0fe819465ad601f5d5609aa35101fe468aea969284a47ced954b60d7'::TEXT, ARRAY[1294]::BIGINT[]),
    (383::BIGINT, 'Mala persona, no sabe enseñar, no le interesa nada más que llegar a trabajar'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2023-11-17T00:00:00+00:00'::TIMESTAMPTZ, '436b2c5aabcdeb9072c1dab242f28c3c57743e368a19c34b859c9ab9abbd5efb'::TEXT, ARRAY[1294]::BIGINT[]),
    (383::BIGINT, 'Domina el tema pero responde de manera confusa las preguntas en clases. En mi caso, el curso fue bastante mediocre, creo que se aprende mas en un tecnico privado o otra universidad. Es joven y puede mejorar alguna cosas. El curso es pasable pero el TEC deberia apostar por gente con mas experiencia.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'b59f716e553297df274f114ffbdde4c965ddd0c5920b074951fefaf11d869adf'::TEXT, ARRAY[1256]::BIGINT[]),
    (383::BIGINT, 'Difícil pero ayuda bastante'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2022-12-02T00:00:00+00:00'::TIMESTAMPTZ, '61753da38a13f9d6a91d2bc87c90b9faa743d18f0bf8391a48b62d46cf2cc50b'::TEXT, ARRAY[1282]::BIGINT[]),
    (383::BIGINT, 'Las instrucciones de los laboratorios no son del todo claras, es preferible preguntarle al profesor lo máximo posible. Siempre está dispuesto a ayudar en consulta y en clase.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Pocos exámenes']::TEXT[], '2022-06-24T00:00:00+00:00'::TIMESTAMPTZ, '1ad3c7dc4ea8ca690e83b5e1e17b26a9541cca00c718f7a5305db56494c210a3'::TEXT, ARRAY[1256]::BIGINT[]),
    (383::BIGINT, 'El material no estaba adaptado a la virtualidad y las instrucciones no eran claras, sin embargo, al escribirle él estaba dispuesto a evacuar dudas y ayudar en todo lo posible. No califica gravemente y da retroalimentación.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, 'e3e2a636342c09dcb9afd5dd2b27ce11e17d5287a51f3783fc595238b99380ce'::TEXT, ARRAY[1256]::BIGINT[])
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
