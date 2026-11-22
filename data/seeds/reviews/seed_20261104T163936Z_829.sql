-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=829
-- TEC-DATA-META years=2020,2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.252208+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (829::BIGINT, 'Muy buena profesora, clases bastante entretenidas, haciendo distintas actividades. La recomiendo. Ella tiene que ver su interés en clase y lo va a ayudar bastante.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2026-07-21T00:00:00+00:00'::TIMESTAMPTZ, '3e758180cb95d4c124f445bb0f3d6a6bbd2ad034433024a6ca460a0df56fd5e0'::TEXT, ARRAY[600]::BIGINT[]),
    (829::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-18T00:00:00+00:00'::TIMESTAMPTZ, '5378c0ba0959d7d5f855635829353eb6592e8b75d2fb0a24237bf3977a0c4c79'::TEXT, ARRAY[554]::BIGINT[]),
    (829::BIGINT, 'Ella es el equilibrio perfecto entre hacer la clase entretenida y hacer que los estudiantes aprendan.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2024-03-01T00:00:00+00:00'::TIMESTAMPTZ, 'e49533589167be8688cd549c30d02b67bf50a05c487218bfce81d0882446e5a8'::TEXT, ARRAY[600]::BIGINT[]),
    (829::BIGINT, 'Excelente profe. Super amable, y las clases son un relajo. Matricule con ella!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '0d89ebf11b665633ca7266d45f17726934ffe690ba35a9f6d233f71a291746b2'::TEXT, ARRAY[554]::BIGINT[]),
    (829::BIGINT, 'La mejor profesora que tuve este año, ella esta dispuesta a ayudar al estudiante si ve que uno de verdad intenta hacer las cosas, si en algún momento tienen la posibilidad de matricular con ella, no lo dude, además, uno aprende mucho con ella.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-14T00:00:00+00:00'::TIMESTAMPTZ, '572d91ecb1c749044131e3f863ff9d102485ac763bc90151cc95256784cd2e53'::TEXT, ARRAY[554, 600]::BIGINT[]),
    (829::BIGINT, 'Excelente profesora, explica muy bien los temas y además brinda muy buen apoyo a la hora de realizar los trabajos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Aspectos de calificación claros']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e8bae1773cef32c2bb67d1a2df56b85b68a63b179dd517d296266fdc5365d808'::TEXT, ARRAY[554]::BIGINT[]),
    (829::BIGINT, 'La profe es muy amable, acepta trabajos tarde y se preocupa por el estudiante. Califica durillo, pero nada más de usar la hora consulta para que revise los trabajos antes de enviarlo y así no le baja tantos puntos'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación']::TEXT[], '2022-03-14T00:00:00+00:00'::TIMESTAMPTZ, '545e2290984432a69da93131c3ef4066aa595a7e857e96487b57e6c4bb41014b'::TEXT, ARRAY[554, 600]::BIGINT[]),
    (829::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Aspectos de calificación claros']::TEXT[], '2021-01-26T00:00:00+00:00'::TIMESTAMPTZ, '201bfbe3f5e41a209dddade4305f41f698bf0c207ca261fe7c0c7ebee30380f7'::TEXT, ARRAY[600, 554]::BIGINT[]),
    (829::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-23T00:00:00+00:00'::TIMESTAMPTZ, 'be92fcd95bfd3897f099bc27b072e9c5e401501dd8112619c88800a3f8f88317'::TEXT, ARRAY[554]::BIGINT[])
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
