-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=91
-- TEC-DATA-META years=2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.763699+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (91::BIGINT, 'Las reseñas anteriores no concuerdan con la experiencia general del grupo del semestre recién terminado, todo lo contrario y buena nota. Grande el chavalo de los videos :)'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[], '2025-11-24T00:00:00+00:00'::TIMESTAMPTZ, 'a7f284955ed109d8487c4c8ba7807753d24ec7943664fccb5fd929fa30c8a2ea'::TEXT, ARRAY[968]::BIGINT[]),
    (91::BIGINT, 'Clases aburridas, no se parecen en nada al examen, super absurdo a la hora de calificar los exámenes, deja tareas ENORMES que generalmente no tienen sentido, el curso se pasa pero quita demasiado tiempo, no lo recomiendo en un semestre pesado, poco compresivo'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-05-21T00:00:00+00:00'::TIMESTAMPTZ, 'c65976354bbc0ae446887bde2f3ec8cfef14918ab2922d7d8d045649b4a5cc6c'::TEXT, ARRAY[968]::BIGINT[]),
    (91::BIGINT, 'Una tristeza. Aparte de pésimo explicando, da las clases con aburrimiento extremo. Deja tareas enormes y aniquila la nota con Gaaps mal hechos con muy poco tiempo para realizarlos. Deja tareas casi semanal y quizes tambien. Super invasivo en examenes virtuales. Pide camara, compartir pantalla y más.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2025-04-04T00:00:00+00:00'::TIMESTAMPTZ, '5d49e8899858c57363274a299c49c9f7077ca73bcb0b67340ed32b5f4059f904'::TEXT, ARRAY[968]::BIGINT[])
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
