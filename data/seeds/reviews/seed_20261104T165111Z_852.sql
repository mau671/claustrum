-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=852
-- TEC-DATA-META years=2022,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:11.999653+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (852::BIGINT, 'El profe es muy bueno y simpatico, cuando uno no sabe que hacer con su proyecto el lo ayuda muchisimo a tener nuevas ideas. Pero lo ideal es que si hablan con él, tambien hablen con Ileana y le presenten las ideas, porque a veces las ideas que uno genera con él no convienen en la evaluación.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo']::TEXT[], '2026-08-08T00:00:00+00:00'::TIMESTAMPTZ, 'e92d2402ba69d7f2645c15c40d9e57971acb42d17317ad7f01b2dfc1cec36980'::TEXT, ARRAY[4748, 4757]::BIGINT[]),
    (852::BIGINT, 'Es un muy profesor, si cualquier persona le pide ayuda, el da ideas muy buenas'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-01-18T00:00:00+00:00'::TIMESTAMPTZ, 'c7c9207c7e21ae993161909c5caeb37fcb34e702e965d8a18757f1ca27c8ad5f'::TEXT, ARRAY[4758]::BIGINT[]),
    (852::BIGINT, 'Es un profesor increíble, 100% recomendado para los de nuevo ingreso. Cada vez que uno no sabe como evolucionar una idea él llega y le deja la boca abierta a uno de como se le pueden ocurrir esa clase de cosas y a uno no. Él prefiere que dejemos volar la imaginación...'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-03T00:00:00+00:00'::TIMESTAMPTZ, 'f0d701d68eeb2e720041fa8810fbc48f86580d399e1cc32dcd0e44735ce0acae'::TEXT, ARRAY[4751]::BIGINT[]),
    (852::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2022-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'caa64c083320c3c2eb01d405d56a9eb65ba36def18e9c33a1bd555c362af7d15'::TEXT, ARRAY[4751]::BIGINT[])
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
