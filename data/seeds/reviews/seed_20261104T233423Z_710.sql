-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=710
-- TEC-DATA-META years=2022,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:34:23.257806+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (710::BIGINT, 'Gran profesor, siempre ayuda a aclarar cualquier tipo de dudas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2026-07-31T00:00:00+00:00'::TIMESTAMPTZ, 'faa331b9ceba30ab4f187833869955b3f5da8b4cb253b6ec0bbf51d38a7a0e9e'::TEXT, ARRAY[3050]::BIGINT[]),
    (710::BIGINT, 'Por la demanda del curso, se requiere mucho tiempo y esfuerzo, pero no califica duro, sabe lo que es ser estudiante. Es de los profes que he visto que brinda más apoyo. Esta constantemente cerca del laboratorio.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'edc50116ac994ef60de694b5767aebabbadf1563c4b8d5eccb9440ba7745cf8f'::TEXT, ARRAY[3060]::BIGINT[]),
    (710::BIGINT, 'Muy buen profe, lo mejor que tiene la cátedra, ayuda con las tareas que dejan, y es muy comprensivo. No dude en matricular con él, va a aprender bastante y si no entiende algo él se devuelve a explicar. 20/10'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '0ab5a6df6e7c4ee118bc08df85238fb4b2959ebda7033eaeb27e894a1a5fd341'::TEXT, ARRAY[610]::BIGINT[]),
    (710::BIGINT, 'Súper buen profesor, ayuda con las tareas de Cátedra que sí son un poco largas, da buena retroalimentación y siempre está dispuesto a ayudar en lo que necesite. Totalmente recomendado.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'db76a89d965c94fba36332c8ed6f36e21e6eb1ae7ff1c925349c1095bb5ea66c'::TEXT, ARRAY[610]::BIGINT[]),
    (710::BIGINT, 'Súper recomendado, el curso es largo por las tareas de la Cátedra, pero en las clases le ayuda con esas tareas. Exámenes durillos, pero matricule con él totalmente, es una teja.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, '6f2643cb281745c626790e944767bcc91186e6ff423f3fcef39b574aaa607c90'::TEXT, ARRAY[610]::BIGINT[]),
    (710::BIGINT, 'Es un excelente profesor, hace las clases entretenidas y brinda bastante retroalimentación. Lo recomiendo mucho'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-05-31T00:00:00+00:00'::TIMESTAMPTZ, 'a0831c3aa2a539b44d040d799c9b265a4a93ebe11e129e5c312be840395a4ee1'::TEXT, ARRAY[610]::BIGINT[])
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
