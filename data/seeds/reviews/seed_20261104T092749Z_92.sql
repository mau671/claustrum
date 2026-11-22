-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=92
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.804197+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (92::BIGINT, 'No tengo sino mas que elogios para este profesor, pocos se le comparan a su calidad humana, dentro y fuera del aula, el curso lo da y lo hace muy facil, el no saber programar no es impedimento pese a que sea de programación aunque es cierto que cuesta aprender por eso, algo se aprende'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'e37ba6a9d02f9142c152bf767181da15f0f617bc755c96ff4cef226fe9387908'::TEXT, ARRAY[968]::BIGINT[]),
    (92::BIGINT, 'Es el mejor profe que he tenido, explica muy bien, te ayuda, todo se hace en compu, entonces es megafácil, en los exámenes tenés chances infinitas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'e00383bce2e22ee0290f65ab949ae10b2cf212ef35b9b7048b0b834af909b546'::TEXT, ARRAY[968]::BIGINT[]),
    (92::BIGINT, 'Profe muy pura vida, matricule sin miedo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases largas']::TEXT[], '2025-12-09T00:00:00+00:00'::TIMESTAMPTZ, 'de0c06ffd099366ebcb66d0403c6c3237156fb329645cea8e22b365dc3355757'::TEXT, ARRAY[968]::BIGINT[]),
    (92::BIGINT, 'Buen profesor pero si no sabes programar desde el comienzo se te va complicar matlab'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-08-21T00:00:00+00:00'::TIMESTAMPTZ, 'bdefe6aaa4130ece2a675a8ba6496ad9cd43a23a4f8041894032c301ce619d45'::TEXT, ARRAY[968]::BIGINT[])
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
