-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=51
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.479304+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (51::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2026-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'e363a179cd9d1694237a16b4eb179daa881a8eeab68cdb57f25fffac02cc1eb9'::TEXT, ARRAY[2396]::BIGINT[]),
    (51::BIGINT, 'Buen profe, un poco disperso pero se ve que sabe y que le gustan las clases. A veces es confuso entenderle lo teórico, pero con la práctica en clase sí se entiende. Lo más pesado del curso es el proyecto, tenga un buen grupo de trabajo para eso.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2026-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'da01ae94ed83253ccab1301cdb0b326af7d500ee4d8e60a667991b2ff4e5ab50'::TEXT, ARRAY[2371]::BIGINT[]),
    (51::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-03-29T00:00:00+00:00'::TIMESTAMPTZ, '6f5f58aa1241183f42332d8be70dfef54c131a2a711f2fb7d2d10fc51c918c86'::TEXT, ARRAY[2371]::BIGINT[]),
    (51::BIGINT, 'Demasiado buen profe, explica bien, es súper amable y hace las clases y evaluaciones súper dinámicas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'bf537b9f6b612463b91941e2494167b5b0cd1bd147cff7f8c6caa4d43557cbe5'::TEXT, ARRAY[2451]::BIGINT[]),
    (51::BIGINT, 'El curso se pasa muy facil con el profe y hace que las clases sean dinamicas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2025-07-09T00:00:00+00:00'::TIMESTAMPTZ, '4ddca57ad6e0062a1ac56b37928716a36347a12c82059f0c33a01b92291f3b78'::TEXT, ARRAY[2451]::BIGINT[]),
    (51::BIGINT, 'el profe es muy bueno y trata de siempre ayudar, aunque aveces explica un poco confuso'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'e36eb06cd03c1c3c6e54f1f6f290607bcf89f8de9ae549c626e443fdb42d9bae'::TEXT, ARRAY[2371]::BIGINT[]),
    (51::BIGINT, 'Buen profe, intenta hacer la materia entendible a pesar de la complejidad de la misma. Examenes con parte individual y otra grupal. Tareas casi todas las semanas pero no son complejas. Si le preguntas te explica y se nota que le importa el estudiante.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, '252985c40e06ac284164c681fb01ed3e1522773fc9d6ac275482196b7d1d99c9'::TEXT, ARRAY[2396]::BIGINT[]),
    (51::BIGINT, 'Es un profesor excelente. Explica bien, no es estricto, es super respetuoso, esta super dispuesto a ayudar. Pasar con el es super fácil solo que las clases son aburridas le encanta hablar de su vida e hijos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2025-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'e231f1919bc2c638aed8b23c9b654bd8ece0c1b4ba39160c0ea568e8a9e4757a'::TEXT, ARRAY[2371]::BIGINT[]),
    (51::BIGINT, 'Muy buen profe'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2025-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'd8b3585bf8552f058ae2a0dfb8c6f44e203a390aefcc9231dd87a676357badef'::TEXT, ARRAY[2451]::BIGINT[]),
    (51::BIGINT, 'El profe es pura vida, se pasa bien con él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-02-08T00:00:00+00:00'::TIMESTAMPTZ, '60fad1c60b2edcc0c1ae5d0cf2886ba4dbfe7886924c6c4d5e8c71b90a87c30d'::TEXT, ARRAY[2396]::BIGINT[])
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
