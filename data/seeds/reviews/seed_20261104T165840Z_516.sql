-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=516
-- TEC-DATA-META years=2021,2022,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.785749+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (516::BIGINT, 'Muy buen profesor, prepara super bien para los exámenes y los quiz no son difíciles, tiene buen dominio del tema y sus presentaciones y videos ayudan muchísimo. Siempre dispuesto a ayudar y explicar, si puede matricular con él, es una excelente opción.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-07-02T00:00:00+00:00'::TIMESTAMPTZ, '2d1a06cde78f388d85dc0b0c29e3bec6527a3479f04936ea456cbe6f7cf40eab'::TEXT, ARRAY[1018]::BIGINT[]),
    (516::BIGINT, 'Geovanni es el mejor profe Discreta que puede tener, explica super claro y las veces que sea necesarias. Explica justo lo que entre en el examen y tiene un dominio del tema increíble, se aprende un montón y se le agarra amor al curso, de fijo volvería a matricular con él (segunda vez llevando MD).'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-04-21T00:00:00+00:00'::TIMESTAMPTZ, 'f9ae3d8fb1fe19cc3be5461bb5ef473340db368c8413c60250c3579bcaf67abd'::TEXT, ARRAY[1018]::BIGINT[]),
    (516::BIGINT, 'Aveces cuesta un poco llegarle a la explicación ya que explica un tema y hace ejercicios y los hace como muy automáticos y aveces si uno se queda con la duda es difícil repasar ya que el profe no usa nada digital. Pero el viejillo es buena nota es bastante relax'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'b44461f02596da3e89d2e792d011fb6f44f9c6a04e18cf7423234ceb96a4aaef'::TEXT, ARRAY[1034]::BIGINT[]),
    (516::BIGINT, 'Muy buen profesor, discreta por lo general es un coladero y él busca mucho que los estudiantes entiendan todo. Explica muy claramente, no me dejó tareas pero hicimos varios quices. Volvería a llevar cursos con él, demasiado recomendado'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-14T00:00:00+00:00'::TIMESTAMPTZ, '9d3be6b7a2d9daf88ec00e243b618acb7e1aa48fa1db87ae06636cb77ef5181d'::TEXT, ARRAY[1018]::BIGINT[]),
    (516::BIGINT, 'Hey ok, el curso es difícil, pero Giovanni es EL MEJOR profe de mate que usted puede tener, es super pura vida, SIEMPRE contesta (siempre es SIEMPRE), y explica super bien. Si puede, matricule con él.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'c00306bbb7b4c04072271a9363f514948236045d674441b8dc27c38ccfd4d86a'::TEXT, ARRAY[1050, 1049]::BIGINT[]),
    (516::BIGINT, 'Excelente profesor, con este mae uno pasa porque pasa, el mae enseña lo justo que entra en el examen además de que siempre está disponible para contestar dudas tanto así que a mí me las contestaba incluso los viernes y sábados a las 10 de la noche jaja gracias profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-05-05T00:00:00+00:00'::TIMESTAMPTZ, '300c13975788cd467b3a4eea37a718503fc3d13d01bd6df7c7976e2bbaa665fc'::TEXT, ARRAY[1712]::BIGINT[]),
    (516::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-16T00:00:00+00:00'::TIMESTAMPTZ, '780b44cad4a64b20308162bfffcea7b7133fcf210ff22d7336c54189bda12c58'::TEXT, ARRAY[1018]::BIGINT[])
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
