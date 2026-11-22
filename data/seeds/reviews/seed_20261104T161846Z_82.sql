-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=82
-- TEC-DATA-META years=2018,2019,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.758433+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (82::BIGINT, 'Como persona es un amor pero como profe si deja mucho que desear. Califica muy duro y hace evaluaciones con preguntas muy específicas. La verdad para un curso de 1 crédito si pide mucho más de lo que vale.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2025-12-02T00:00:00+00:00'::TIMESTAMPTZ, 'ab14fc0fb4f6fcee854a34ae40a8b7654089e87d33ea82433a4bd8062b4570ad'::TEXT, ARRAY[998]::BIGINT[]),
    (82::BIGINT, 'Es una buena profe. Las clases suelen ser un poco cansadas y largas, pero no son difíciles. Además, da mucho apoyo a sus estudiantes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2024-06-10T00:00:00+00:00'::TIMESTAMPTZ, 'f8e0e914513da06d65c21c64954482eba9aaa6d89c91f59d5912c2a84ac8aa51'::TEXT, ARRAY[3094, 1505]::BIGINT[]),
    (82::BIGINT, 'Los quices en ocasiones son demasiado específicos sobre todo cuando es sobre un laboratorio, hace quices todas las semanas. Pero es muy buena profesora, explica claro y utiliza ejemplos y analogías'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2019-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'd9f429c736480973ec02e7a341fdaa8c5ba5cab37f558ef59fe5684d5ecdba2a'::TEXT, ARRAY[1460]::BIGINT[]),
    (82::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-04-12T00:00:00+00:00'::TIMESTAMPTZ, 'b51d76901c6188c08a724e285682bcf766d6e443625e5fe47da58ad1e7a54171'::TEXT, ARRAY[1460]::BIGINT[]),
    (82::BIGINT, 'es un amor de persona, excelente y sencillo de pasar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-20T00:00:00+00:00'::TIMESTAMPTZ, '4c0607a40efbd9380dfacb5846ac9525e979e68fcb24f99cdd14af9eaf9dec1c'::TEXT, ARRAY[1460]::BIGINT[]),
    (82::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-03T00:00:00+00:00'::TIMESTAMPTZ, '1a3f22b64b23ae0a8ec700113cdf313d5442ecf37e0b7382f7267180d57e74d7'::TEXT, ARRAY[1460]::BIGINT[])
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
