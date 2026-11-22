-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=823
-- TEC-DATA-META years=2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.246898+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (823::BIGINT, 'Aunque es buena profe hace las clases super largas y aburridas. Si sabe inglés matricule con ella, si no es así, mejor busque otro profe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '3e8c51e1fbb47021dd9947b20bde08ca0d29d5b835dca4948a4d179eb8cf5243'::TEXT, ARRAY[539, 625]::BIGINT[]),
    (823::BIGINT, 'La profe es cae superbién, le va a ayudar en lo que ocupe y sí contesta los correos, pero las clases son aburridas, poco participativas y los exámenes a veces tienen sus cosillas.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo']::TEXT[], '2022-03-14T00:00:00+00:00'::TIMESTAMPTZ, '1bcd4b4f3f9619764115b6bb7ddb1f1f70d84ee6bc6a7fc72200da25dfb98bf8'::TEXT, ARRAY[545]::BIGINT[]),
    (823::BIGINT, 'Sonia es un amor de persona, pero a veces parece que hasta a ella le cuesta el idioma. Sus exámenes son un desastre, utiliza formularios de google donde hay partes de escucha y mientras uno está reproduciendo los audios ella está hable y hable en la video llamada. No lo lleve con ella si le cuesta.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2021-07-18T00:00:00+00:00'::TIMESTAMPTZ, 'd0d0eab07fdc5149670b7a0ad5be7494b6fb72b43126088363798833b3bce9d5'::TEXT, ARRAY[625]::BIGINT[])
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
