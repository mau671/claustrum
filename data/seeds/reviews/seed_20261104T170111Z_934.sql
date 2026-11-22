-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=934
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.036310+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (934::BIGINT, 'La verdad lo escogi con temor por las calificaciones pero es un profesor muy llevadero y si tienes problemas de cualquier naturaleza en los proyectos no teme ayudarte, es un poco desordenado en fechas y te puede dar apuros pero es buen profesor y amable, aparte le gusta integrarse como uno mas'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, '815a9a7c8f77202a718b9c9e9034ed94ee90e50f6f61ee3bd5a209a4ea849cdf'::TEXT, ARRAY[1299]::BIGINT[]),
    (934::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muy cómico', 'Da buena retroalimentación']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'f81b604def22705cd3ca1e00e6880669124d435bbc13aa7580fc7edc04b3480c'::TEXT, ARRAY[1255, 1252]::BIGINT[]),
    (934::BIGINT, 'malo malo malo'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'cf516ebb54b60926878150f5224b28c3898c59d08bf22c0d39061d7651ef3528'::TEXT, ARRAY[1255, 1252]::BIGINT[]),
    (934::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria']::TEXT[], '2025-11-13T00:00:00+00:00'::TIMESTAMPTZ, '486a7703e36276d78b3a54949ba9e69f0d256f850c97b05f0df44e8914a32feb'::TEXT, ARRAY[1255]::BIGINT[]),
    (934::BIGINT, 'no es muy bueno como profe, aparte de petulante'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2025-09-09T00:00:00+00:00'::TIMESTAMPTZ, 'e15c5b096234622dfef60cede3359be3a0d25f023f517c99a8b30bd339764058'::TEXT, ARRAY[1255]::BIGINT[]),
    (934::BIGINT, 'El mejor profe, realmente hace proyectos para que uno aprenda. Lo recomiendo demasiado, realmente es un buen profesor y se esfuerza por ser mejor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2025-07-16T00:00:00+00:00'::TIMESTAMPTZ, '6cfe0411afcf400809d87562edc8fb481761b294b2ba8d6b7235b9cad5c642ae'::TEXT, ARRAY[1252]::BIGINT[]),
    (934::BIGINT, '¿de dónde sacaron a éste tipo tan malo?'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2025-05-22T00:00:00+00:00'::TIMESTAMPTZ, '140c7b6502ecf7a05b0cce7ec78decb43ec14fd4816b9c9f2f468b44fa42a1aa'::TEXT, ARRAY[1255, 1252]::BIGINT[])
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
