-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=344
-- TEC-DATA-META years=2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.161569+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (344::BIGINT, 'Es muy buen profesor, en las clases teóricas tiende a preguntar mucho a los estudiantes, en las clases prácticas lo hace a uno hacer lo que él hace y se atrasa mucho la clase si alguno se queda atrás, al final los laboratorios o quices eran enviar lo que uno estaba haciendo con él y los proyectos ez'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2026-07-14T00:00:00+00:00'::TIMESTAMPTZ, '4ea7fd2d85bc978a0cc5b8f56c915ecacc2da7a85bcc3ff053a14b6c4c6ff42f'::TEXT, ARRAY[1148]::BIGINT[]),
    (344::BIGINT, 'Es un excelente profesor con una moral muy fuerte, sabe de lo que habla y explica 10/10. La participación durante la clase es fundamental para llevar un buen ambiente en las mismas y siempre hagan las tareas morales; recomiendo que hagan con tiempo los proyectos pq son largos pero muy recomendado.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-12-18T00:00:00+00:00'::TIMESTAMPTZ, '6118b6a004c858409a7ed0545fd1b1ea67776e275e3a802158b7e7929e7ea81f'::TEXT, ARRAY[1043]::BIGINT[]),
    (344::BIGINT, 'Como persona es muy tuanis, como profesor siempre pregunta si tiene dudas en clase, aspectos de evaluación claros. Pero tiene un horario limitado de consulta, y si le envía un mensaje, cuesta que responda. Realiza preguntas de la materia a cualquiera de la reunión, estar atentos en la clase.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2023-11-11T00:00:00+00:00'::TIMESTAMPTZ, '207e5fa1a5ec350a422cd13873215e14d1602677fff20a1f1478c63f48959ad9'::TEXT, ARRAY[1043]::BIGINT[]),
    (344::BIGINT, 'Deja varias evaluaciones pero no son muy complicadas si se hacen con tiempo, da retroalimentación y notas rápido. Casi todo es en grupos y se interesa porque los estudiantes aprendan. Las clases las da con presentaciones de power point y algunas veces muestra el código en sql. Se pasa fácil'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2023-09-23T00:00:00+00:00'::TIMESTAMPTZ, '5c46bd0c2609afb81d4a1eefc1d7bad7ff6ce00783fbc7702cc062512f210fb2'::TEXT, ARRAY[1043]::BIGINT[]),
    (344::BIGINT, 'De los mejores profesores que he tenido. Interesado genuinamente en el aprendizaje de todos los estudiantes. Deja muchos trabajos, pero siempre da las calificaciones a tiempo y con buena retroalimentación. Es fácil saber en cualquier momento del curso si uno va bien y está entendiendo. Excelente!'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-11T00:00:00+00:00'::TIMESTAMPTZ, '20b12a04f27cf39f84c3a44c388089d873716cdc7be63f8a3a07f9b91b23cb2d'::TEXT, ARRAY[1043]::BIGINT[])
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
