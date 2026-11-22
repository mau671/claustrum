-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=742
-- TEC-DATA-META years=2015,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.901055+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (742::BIGINT, 'Un amor! Es demasiado buena profesora y ella con todo el gusto ayuda y regala puntos cuando uno consulta. Le importa muchísimo que usted sepa la materia y ponga atención en clase. Ojo; no es tonta, si usted falta o hace malos trabajos lo nota y te evalúa cómo es, por que encima se aprende nombres.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'a4be43db0654252fe83368bd454f1741816fb7d727d30b2d0bdc8f4fa78f8337'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'Instrucciones poco claras, clases largas y muy picky para calificar'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Brinda apoyo']::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, '7c71de0e53466fd66b2513db5b45d13d3c496a51927adcd6896aa73dbf46d407'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'La profe es super linda persona, ayuda muchísimo. La clase es super larga y aburrida. Las instrucciones son poco claras pero califica justo'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, '570dc1e9729f180ffb0bfec00ee72751a6252fb3e0b4855de905381eb55407d6'::TEXT, ARRAY[3281]::BIGINT[]),
    (742::BIGINT, 'Extraordinaria profe. Muy buena gente y ATENTA a sus estudiantes. Da muy buen apoyo.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-09-03T00:00:00+00:00'::TIMESTAMPTZ, '2d962ff6aa962efb0f2c69cca5ed8cdeab1a923daff7c6f4dce80d57f26e18ef'::TEXT, ARRAY[3281]::BIGINT[]),
    (742::BIGINT, 'La profe es muy linda, siempre dispuesta a resolver las dudas de los estudiantes y ayuda mucho con los proyectos. Sin embargo, sus clases son largas y pueden llegar a ser un poco aburridas, es difícil poner atención todo el rato. Hace ejercicios en clase, le gusta que los estudiantes participen.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Brinda apoyo']::TEXT[], '2023-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'a928e6bd5718604dfd836f4f1584d0707aa4239ec94e20397a1d688799900f54'::TEXT, ARRAY[3131]::BIGINT[]),
    (742::BIGINT, 'La profe es muy buena explicando y está atenta a las consultas y reclamos. Califica duro, pero de manera justa y si está fundamentado, le dan los putos de reclamo. Muy recomendada.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2023-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'f03341acef712041b0eb0489acc942c37a71561d172b170494cdc1db252809a7'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'La profe es muy buena gente y está dispuesta a responder dudas cuando el estudiante lo tiene. Además, explica muy bien y califica de manera justa.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '1a4e81bd2c23784372bc7fe10e7986772ec45fd682d2448438113b38c284b3a0'::TEXT, ARRAY[3281]::BIGINT[]),
    (742::BIGINT, 'Lo llevé virtual y fue la mejor decisión, lo supe al escuchar a les demás quejarse sobre les otres profes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, '0173bb1d5e7a397b635c9cd903f65edea90aa460ce20fbbb3922bf551c78f42e'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'Es una profe super linda, toma en consideración los comentarios de los estudiantes y da mucho apoyo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, 'f461b608abc5cf2d1cfd8b1b3a1b7430be1284736243c131018f512861a9f77c'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'Una profesora y persona increíble, sus clases son excelentes y muy claras, muestra un respeto admirable hacia todos, el curso es de cátedra por lo que las cosas negativas del mismo fueron por los otros dos profes, es la mejor opción para este curso y cualquier que imparta, dan ganas de abrazarla'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-02-07T00:00:00+00:00'::TIMESTAMPTZ, 'a1d9a30536eda9ccae52586f22e6eedd9f4c724a0e0dffff0b4e5a03cd11caad'::TEXT, ARRAY[3282]::BIGINT[]),
    (742::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'e3acc2e703d7b04e853415828cbc0b3d4e7a1b38aeba0a7492d25a23cf8160bc'::TEXT, ARRAY[3386]::BIGINT[])
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
