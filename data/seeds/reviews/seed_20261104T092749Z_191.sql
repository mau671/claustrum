-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=191
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.843009+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (191::BIGINT, 'Realmente se puede aprender bastante pero como son muchas personas claramente se hace poco énfasis en el aprendizaje individual, y seamos serios, es una clase de futbol la vara es más de pasarla bien y conocer gente que de aprender cosas, aún así realmente sí ví mucho aprendizaje en otros compañeros'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2026-04-04T00:00:00+00:00'::TIMESTAMPTZ, '3779f5234cd4d7d08f55e18e905fb02e52a02f7ec6baee7771e8590c3bf00606'::TEXT, ARRAY[585]::BIGINT[]),
    (191::BIGINT, 'El mae es muy comprensivo, se ve un poco de técnica pero no espera que lo haga increíble, a las personas que sí saben realmente las apoya para que se luzcan en lo que se esté viendo. Vimos voley, futsala y balón mano. Sí es muy rígido con las ausencias y las llegadas tarde. (Está atractivo)'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, '8cac827aa9cfbef9b432402eaaecf36bb4c9c714fad0676fbd7af3ab63581a4a'::TEXT, ARRAY[493]::BIGINT[]),
    (191::BIGINT, 'El profe es un crack, muy buena gente aunque a veces no parezca al inicio. Se ve un poco de técnica y después puras mejengas al final de la clase. Se ve que le importa mucho el desarrollo de otras habilidades fuera del deporte, por eso deja un trabajo teórico donde da retroalimentación. Buen profe.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'd34b9ded667d11c5a00af57e6aa348517680e9cf8636f573cb6edf28431b85bd'::TEXT, ARRAY[585]::BIGINT[]),
    (191::BIGINT, 'Se ve que tiene conocimiento pero le faltan habilidades blandas con sus alumnos'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2025-10-31T00:00:00+00:00'::TIMESTAMPTZ, '86cca77252d555952f4257d1a20d5da311005714c44f1c57f26fed49731e33b6'::TEXT, ARRAY[585]::BIGINT[]),
    (191::BIGINT, 'El profe es muy buena gente, es cierto que puede ser una poco cerrado con los estudiantes pero es buena nota.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2025-07-12T00:00:00+00:00'::TIMESTAMPTZ, '512be3966a3fd721d9564c5f82d7d76152df02eaab5f23b5ec60ca35301f4a98'::TEXT, ARRAY[494]::BIGINT[]),
    (191::BIGINT, 'Apesar que fue una clase de relleno, la hiso entretenida, bastante flexible'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-12T00:00:00+00:00'::TIMESTAMPTZ, 'fdf7e59332c7aed28447c79fc352864af55953fd042c6ab1bc0772159366333d'::TEXT, ARRAY[494]::BIGINT[])
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
