-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=192
-- TEC-DATA-META years=2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.105957+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (192::BIGINT, 'Excelente profe. Solo nos tuvimos que conectar como 3 veces, deja varias tareas pero son súper sencillas y califica suave.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-20T00:00:00+00:00'::TIMESTAMPTZ, 'c927f959e4865a5f0ed4be4ffa7497f96465fd004455fad159d8890e4c540e81'::TEXT, ARRAY[499]::BIGINT[]),
    (192::BIGINT, 'Bien es cierto que sí deja bastantes trabajos para ser una cultural, pero son demasiado cortos y sencillos, hasta con chatgpt se pueden hacer todos. A ella le apasiona como mucho de lo que habla, es muy buena gente y califica demasiado suave.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-04T00:00:00+00:00'::TIMESTAMPTZ, 'a51fb8603fdfd443c2151296f6e76e3daa1abf4be9c80c81419d1054e7512227'::TEXT, ARRAY[499]::BIGINT[]),
    (192::BIGINT, 'Una cultural que es de 0 créditos, deja un montón de trabajos que hace que no valga la pena el curso, como realizar una entrevista, hacer un ensayo, una presentación, etc. El curso no parece de 0 créditos, y hace que en la peor parte del semestre uno esté preocupado por este curso.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '540231f96d660996a4d3c41230ff36b42db4fce8b3be8b7fa5939ed504be961b'::TEXT, ARRAY[499]::BIGINT[]),
    (192::BIGINT, 'Es una clase muy llevadera y sencilla, tareas muy fáciles que toman poco tiempo. A todo eso se le suma que la profe es una excelente persona y siempre está dispuesta a brindar apoyo en lo que se ocupe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2022-12-01T00:00:00+00:00'::TIMESTAMPTZ, '24aaf48abfc8cb2996be2e857a418e97e1f88b86fec477087487e52753457a8e'::TEXT, ARRAY[499]::BIGINT[])
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
