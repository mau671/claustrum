-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=510
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.786681+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (510::BIGINT, 'Bastante amable el profe, muy dispuesto a ayudarlo si usted necesita. Por momentos puede sentirse aburrida y larga la clase pero igual el profe explica bien. A veces cuenta historias entretenidas.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Brinda apoyo']::TEXT[], '2026-06-16T00:00:00+00:00'::TIMESTAMPTZ, '0f592eccc6ae1192f97e61feecc4f47ae3ac552624a969edefce0ba35dea92b3'::TEXT, ARRAY[935]::BIGINT[]),
    (510::BIGINT, 'No llevé clases con él sin embargo si tuve horas estudiante con él y puedo decir que es de los profes más pacientes y agradables que he conocido en el tec me parece una muy buena persona y un excelente profesor definitivamente si tengo la oportunidad de matricular con él en algún futuro la tomaré'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2026-03-17T00:00:00+00:00'::TIMESTAMPTZ, 'c5d3916c31f6cbad1ea34f0cd13f68c19d7d07d55f391d9fd006d5e956f904f6'::TEXT, ARRAY[1018, 2439]::BIGINT[]),
    (510::BIGINT, 'agregando el profe'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-23T00:00:00+00:00'::TIMESTAMPTZ, '0b2fd32faf919c33a5aed6e317245e0690d9f1e3d17ee2f2407e024fc886e012'::TEXT, ARRAY[634, 605]::BIGINT[])
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
