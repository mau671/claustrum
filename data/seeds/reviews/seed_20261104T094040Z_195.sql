-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=195
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.742437+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (195::BIGINT, 'Profesor que se esfuerza e intenta dar clases bonitas, pero es demasiado estructurado y todas las clases es lo mismo que puede llegar a aburrir un poco. Pero es cierto que los trabajos son sencillos y es fácil de pasar. Además, permite entregas tardías si son pocas.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo']::TEXT[], '2026-09-09T00:00:00+00:00'::TIMESTAMPTZ, 'f8283e4d6803ffa00d63db9c02c76dad171e32cf76b5716feea4d537091747ef'::TEXT, ARRAY[504]::BIGINT[]),
    (195::BIGINT, 'Muy bueno, trabajos no son dificiles, tuanis.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '8f1cc901acb1c8c97ceed28e26fb4253410a859926b30b197861f9ab0f5065fd'::TEXT, ARRAY[501]::BIGINT[]),
    (195::BIGINT, 'Excelente profe, no califica nada duro. Explica un poco la teoría pero el tiempo de la clase mayormente se utiliza para elaborar los dibujos, da toda una semana para entregarlo y esas son las tareas, no muy complicadas. Le gusta que participen y eso lo hace flexible en caso de necesitar una ayudita.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '9fabdddd5f5ffac2444a48614e0af44d0d635ab0d1720fea730b17a7b7616be5'::TEXT, ARRAY[501]::BIGINT[]),
    (195::BIGINT, 'Super buen profe, amable y le gusta enseñar el arte, si es responsable y lo sigue durante las clases de seguro aprueba y sale muy bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ, '06697e2f053467dd59a78e57a2dbf5091f6a19c001a41308588345e2bf4ad33e'::TEXT, ARRAY[501]::BIGINT[])
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
