-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=103
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.764748+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (103::BIGINT, 'Es un amor de profe, es super amable y super considerado. Se aprende y se pasa fácil, se pasa con 9+. Él tiene demasiado conocimiento. Algunas clases son virtuales. Si mete con él pasa de fijo y con buena nota. Es demasiado nice.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, '4437fe6b536283b3b120da850a61776f31cfceb05c56b1faaab78d060db7a359'::TEXT, ARRAY[1205]::BIGINT[]),
    (103::BIGINT, 'Muy buen profesor, el curso no es muy pesado pero si hay muchos trabajos en clase en los que si es exigente en que todo esté bien citado. Es muy accesible para las dudas y se aprende todos los nombres de los estudiantes. Lo valioso, es su conocimiento en el ámbito laboral. Muy recomendado.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2025-07-04T00:00:00+00:00'::TIMESTAMPTZ, '9c99829b6216fba3c2ac3ef42fa65c4b9a4e953e631902de4f5c20904434dff9'::TEXT, ARRAY[1205]::BIGINT[]),
    (103::BIGINT, 'La verdad que un muy buen profe. Las clases son muy dinámicas y las evaluaciones son muy sencillas. Da puntos extras y la verdad que el curso es muy llevadero. 100% recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'dd2ad11e558056610527011fff6105f01782cc3e69d51a31e532dfa4efbef8e0'::TEXT, ARRAY[1205]::BIGINT[]),
    (103::BIGINT, 'Buen profe, aunque si le cuesta un poco expresar lo que quiere dar a reflejar respecto a la materia, aún así es muy buena gente da tareas y quices extras, el primer examen deja preguntas extras y normalmente a todos les va muy bien, en términos generales lo recomiendo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2024-06-18T00:00:00+00:00'::TIMESTAMPTZ, '6d1889e28a4af664c01c5642f884c18e9d14e097d3f0b0db276f5768a9587786'::TEXT, ARRAY[2765]::BIGINT[]),
    (103::BIGINT, 'Quizas no sea el mejor explicando, pero quiere que al estudiante le vaya bien, deja quices extras y preguntas adicionales en los examenes. Puede que califiqur duro tareas y proyecto, pero si sigue indicaciones todo va a salir bien.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Muchos exámenes', 'Brinda apoyo']::TEXT[], '2023-11-30T00:00:00+00:00'::TIMESTAMPTZ, '2a154130734edcdceefe20b5fdf08b6d1b5420611ee9811130d6050a66f06844'::TEXT, ARRAY[2765]::BIGINT[]),
    (103::BIGINT, 'Era su primera vez dando clases por lo que le costó tener confianza; le gusta llevar ejemplos a clase y hace actividades diferentes para sacar a los estudiantes de su zona de comfort.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Clases largas']::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'a4ca45391b6c6a2f477165f9332de4c9c05f12ce0362d5173ae8ac0051928f35'::TEXT, ARRAY[2765]::BIGINT[])
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
