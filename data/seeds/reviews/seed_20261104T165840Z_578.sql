-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=578
-- TEC-DATA-META years=2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.806837+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (578::BIGINT, 'Por favor no matricule con este señor, sin exagerar, ha sido de los peores profesores que he tenido en mi vida. En clase pone a los estudiantes por media hora a hablar entre sí. Solo lee la ppt. Las notas las da la última semana de clases y pone calificaciones bajas, el desglose no existe.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2025-07-18T00:00:00+00:00'::TIMESTAMPTZ, '86b2b9d6101fdaed8560d36bba70302e4ac51ed2b6fe5e4abf6f5d0cdba1b4ca'::TEXT, ARRAY[314]::BIGINT[]),
    (578::BIGINT, 'Una completa burla de profesor, especialmente a nivel de maestría. Gasta los primeros 30 minutos de las clases en poner a los estudiantes a hablar paja entre ellos (no estoy exagerando). Pone a los estudiantes a dar la clase con presentaciones. Se nota que no sabe lo suficiente de la materia.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-13T00:00:00+00:00'::TIMESTAMPTZ, '235cc655c9ce9857c47f4323ba1419038b85f0ef608d5d0162c15ffac4fa5543'::TEXT, ARRAY[314]::BIGINT[])
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
