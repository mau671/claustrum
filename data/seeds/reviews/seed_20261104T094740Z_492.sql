-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=492
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:47:40.777268+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (492::BIGINT, 'El profe es buena gente pero dice que sube material de apoyo y al final no lo sube. A veces se enreda explicando.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('35','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2026-07-19T00:00:00+00:00'::TIMESTAMPTZ, '58af4aa88224bc04bf823584c7354965f9d1003c7949e0e3eebd914badaa8ef3'::TEXT, ARRAY[563]::BIGINT[]),
    (492::BIGINT, 'Es muy buen profe y cae muy bien, no es un profe que califique duro, sus clases a veces se sienten largas, pero se hace bastante práctica con el a detalle así que uno puede comprender muy bien los temas en clase.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-10-23T00:00:00+00:00'::TIMESTAMPTZ, '984211c746fc36cfdbacaa2f1e5ca80721b7c8836ba3a15dd768fb00ac4d0a0d'::TEXT, ARRAY[923]::BIGINT[]),
    (492::BIGINT, 'Hay que rogarle para envíe el material de clase, nunca responde mensajes, desordenado, cambia fechas de último momento, parece que lo están obligando a trabajar.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-02-06T00:00:00+00:00'::TIMESTAMPTZ, '3dcff6cbe02a7bf7d8776947efa52bd96cb3a5db384f92e31880ea0ad1f0a933'::TEXT, ARRAY[2439]::BIGINT[]),
    (492::BIGINT, 'Si quieres perder el curso, llévalo con el, explica del qlo, se le olvida lo que está explicando y no es de tanta empatía. Lo único bueno es que dejaba tareas y te daba el 100 y llevaba café a las clases (a veces galletas) pero no se entiende nada de lo que explica.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura']::TEXT[], '2024-12-09T00:00:00+00:00'::TIMESTAMPTZ, 'bdde60419c7a317031f9b222577f0f684f8b718960197f779803ca8ab04f4327'::TEXT, ARRAY[563]::BIGINT[])
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
