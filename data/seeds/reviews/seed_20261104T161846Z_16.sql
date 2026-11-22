-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=16
-- TEC-DATA-META years=2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.738359+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (16::BIGINT, 'Extremadamente fácil de pasar con buena nota. El Access es de poner atención y dey, es una herramienta técnica, así que toca meterle algo de mente. Los examenes fueron grupales y super fáciles. La clave es que hace un curso pesado en un curso fácil de pasar. Eso sí, es demasiado cuadrado a veces.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'c492750b7cf916eaa3e1e0f71400a15b8c632df42fb08af683e9506dee629b2e'::TEXT, ARRAY[2399]::BIGINT[]),
    (16::BIGINT, 'Lectura en clase, responde consultas, en Access se medio confundía un poco, no puedes llegarle con problemas del grupo en el que estés. No nos enseñó los temas de los avances en el orden establecido en que se había quedado. El programa decía Av2 Formu y Av3 Consu, fue al final Av2 Consu y Av3 Formu.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Brinda apoyo']::TEXT[], '2025-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'de59bcf3b2e7ae14037c0a659d96d7bfe00a39628f76048a7abe6d29a9d306a7'::TEXT, ARRAY[2399]::BIGINT[])
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
