-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=444
-- TEC-DATA-META years=2023,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.949552+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (444::BIGINT, 'Los ejercicios son todos enredados, te habla feo y pesado, te pone a calcular embargos, pensiones, etc, en lugar de dar lo que realmente importa del curso por ejemplo como ser un buen líder, te da una rúbrica y te califica con otra. Se pasa con él, pero se sufre mucho'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '5d9163b36ce4ec37fdd2429b979536e9ad8575d4a32fc6d907eea09b7cc509da'::TEXT, ARRAY[1312, 1751]::BIGINT[]),
    (444::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Exámenes retadores']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'c1da121e6b323d261161d81f42a5637e2e30fb888e8a7d704164dca33e246fc3'::TEXT, ARRAY[1312, 1751]::BIGINT[]),
    (444::BIGINT, 'Buen profe, es compresible con fechas de entrega, a veces no es claro con sus proyectos, trabajos grupales casi siempre, clases largas y un poco aburridas.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2024-01-18T00:00:00+00:00'::TIMESTAMPTZ, '848fc39e87a11deef8bf2e993a36f3f33844d8776305ce8299fdcb18a1215c2b'::TEXT, ARRAY[1312, 1751]::BIGINT[]),
    (444::BIGINT, 'El mae es medio buena gente, las clases son largas y aburridas a veces pone videos solo se sienta a explicar los power point, los exámenes son en pareja así que busquen con alguien mordido porque son duros, hacer el proyecto final desde un inicio o desde que se ve el tema en clase'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-12-01T00:00:00+00:00'::TIMESTAMPTZ, '3265c332d292639f3a566342adaaf55e068393324c53a97cc5946042a8a9bd60'::TEXT, ARRAY[1312, 1751]::BIGINT[])
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
