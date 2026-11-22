-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=839
-- TEC-DATA-META years=2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.478365+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (839::BIGINT, 'Muy buen profesor, explica súper bien y siempre intenta que no queden dudas, deja muchos trabajos pero son cortos y sencillos. Vale la pena llevar un curso con él y lo haría de nuevo sin problema'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Tomaría su clase nuevamente']::TEXT[], '2026-03-03T00:00:00+00:00'::TIMESTAMPTZ, 'a2f83c30d4812416349858a682c05aeb229434e4e9bddc0e76dfa8de1baf9f7d'::TEXT, ARRAY[980, 2460]::BIGINT[]),
    (839::BIGINT, 'Es muy sencillo pasar, se deja foros y se discuten.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '83deb0c0f1307529f20ba3c48981093e53ddeafa4b2e102cca075a8445e9e755'::TEXT, ARRAY[915]::BIGINT[]),
    (839::BIGINT, 'El curso es super aburrido y él lo hace el doble. Al principio califica super duro, luego deja de hacerlo y califica con puro 100.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '01754ceb5e271e03327c0151c1037832bff4108772c7902cc3cb6b5d4f8a1783'::TEXT, ARRAY[559]::BIGINT[]),
    (839::BIGINT, 'Muy buen profe, es muy claro con lo que quiere desde el inicio y explica muy bien, hace ejercicios interesantes durante la clase, aun que a veces se hace un poco larga. Mi único punto en contra es que deja muchas evaluaciones'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Aspectos de calificación claros']::TEXT[], '2023-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'e2a2bdfd0ae48256ef9e65f69bf56a544e1b76d59d7e5331df8d3029829aed04'::TEXT, ARRAY[980]::BIGINT[]),
    (839::BIGINT, 'El profe es muy buena gente y hace las clases entretenidas. Deja pelis interesantes y sus asignaciones son muy fáciles. En general lo recomiendo mucho para cualquier centro.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2023-07-10T00:00:00+00:00'::TIMESTAMPTZ, 'f2a7897e095e05d808ecef9e943455b6bafe97158c6fa5f439f2b239a47abc9d'::TEXT, ARRAY[898]::BIGINT[]),
    (839::BIGINT, 'Muy buen profe, es compresivo y deja películas interesantes'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-12T00:00:00+00:00'::TIMESTAMPTZ, '430c0cc5926a7cc7252a6c41e964d7a339cf5004e44ee66585ee0ab72807fcc4'::TEXT, ARRAY[898]::BIGINT[]),
    (839::BIGINT, 'Muy buen profesor, ayuda mucho con el proyecto si uno le pide retroalimentación y deja muchos trabajos para tener puntos extras.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, '2e785a9a50daa3bf4d9a5a50101b2a7ff08ecf03087b768c21b06cfe602b6440'::TEXT, ARRAY[2460]::BIGINT[])
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
