-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=651
-- TEC-DATA-META years=2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.824004+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (651::BIGINT, 'La evaluación se sintió un poco experimental, sin embargo siempre estuvo dispuesta a ayudar al estudiante, siempre está muy pendiente a dudas, ofrece reunirse con el estudiante en horas extra para aclarar dudas sobre el uso del equipo. Es muy educada y ordenada, se nota que sabe mucho sobre su área'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2024-06-08T00:00:00+00:00'::TIMESTAMPTZ, '1c022b99a875585adcf10a7aa7f039eaa33eb244dc6433d3f832c1d1a0f51e3a'::TEXT, ARRAY[3170]::BIGINT[]),
    (651::BIGINT, 'La profesora tiene vocación, es atenta a las dudas y brinda mucho apoyo. Su retroalimentación en el curso es buena y tiene paciencia siempre y cuando usted ponga de su parte, tiene un orden impecable, quisiera que todos los profes trabajes así de ordenado...debe creer más en el estudiante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a7df3db80d5d588f51175be30ec30ab6049b3edb21f2674a563b20fcf2b708c9'::TEXT, ARRAY[2154]::BIGINT[]),
    (651::BIGINT, 'Es una profe llena de vocación por enseñar. Es muy comprensiva y flexible. Sabe muchísimo y las clases están muy bien preparadas y se aprende mucho. 100% recomendada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'c172dc09c7acef6a4950764da8d8b7c80ffcecf4b0cd669fd32d0b6f8f3e80fb'::TEXT, ARRAY[2235, 2224]::BIGINT[]),
    (651::BIGINT, 'La profe es muy comprensiva, y siempre está dispuesta a responder dudas, a dar ayuda y a cambiar fechas si es necesario. Es una persona muy preparada y da retroalimentación de los laboratorios.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2021-07-28T00:00:00+00:00'::TIMESTAMPTZ, '48e6170ad0e15556b6cc5d8a8a649c8598ade6107a1d93768ab4701943452143'::TEXT, ARRAY[2235, 2154]::BIGINT[]),
    (651::BIGINT, 'Super aburrido y tedioso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-08T00:00:00+00:00'::TIMESTAMPTZ, '7f09415e792fa18e2493b14fac67739a984edb9350de4566dc148e50a159c656'::TEXT, ARRAY[2154]::BIGINT[]),
    (651::BIGINT, 'De las mejores profesoras que he tenido, muy preparada. Se aprende mucho y es buena gente.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Aspectos de calificación claros']::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, '85417b51c5cde5e7b4f3b893cfd4a087271c2979665abb42b13a482ce018c1bc'::TEXT, ARRAY[2235, 2224]::BIGINT[])
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
