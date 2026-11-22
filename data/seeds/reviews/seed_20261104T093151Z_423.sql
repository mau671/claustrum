-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=423
-- TEC-DATA-META years=2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.754774+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (423::BIGINT, 'Si tiene la oportunidad de meter proba con este profe, no lo piense dos veces, hágalo. Explica super bien, las clases no se hacen tan pesadas, califica muy suave y es muy pura vida. A veces si usted se lo pide de la manera correcta puede pasar las clases a virtuales, de lo mejor que me he topado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'cda390194ccf2bdced69c9bb2714f9e7f43117a9aff5a600768313cbdacaa89c'::TEXT, ARRAY[1272]::BIGINT[]),
    (423::BIGINT, 'Profe galleta. Hace bastantes evaluaciones y son fáciles. Flexible, pero le falta comprometerse un poco más con los cursos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'bf395ce1b4340bc4925aea4c6d8ada69a35cb5f89fc83d09246083cfbcb1a6f2'::TEXT, ARRAY[1739]::BIGINT[]),
    (423::BIGINT, 'El profe es muy bueno, explica teórico y después da ejemplos prácticos para ir resolviendo en clase. Hace quices pero son de la mismas herramientas vistas en clase. Lo mejor es que como todo se va resolviendo en clase, quedan las herramientas ya echas y sirven para repasar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-07-29T00:00:00+00:00'::TIMESTAMPTZ, '6019cc887d0aa8812f8c0138ab3f4f880cf668a5609670bceafb56a07a65d04b'::TEXT, ARRAY[1757]::BIGINT[]),
    (423::BIGINT, 'Excelente profe. Genera un ambiente muy agradable en la clase. El curso no es difícil de aprobar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '42ed762ebf762f00667e3556918dff3826d0e39242ba98213593e098fe960a84'::TEXT, ARRAY[1727]::BIGINT[])
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
