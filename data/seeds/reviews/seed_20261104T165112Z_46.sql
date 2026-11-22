-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=46
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.041660+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (46::BIGINT, 'Curso fácil de pasar si lo lleva con ella, fácil de entender también si pone atención. Explica las veces que sea necesario. Los exámenes los hace fáciles si ve que el grupo está entendiendo el tema y poniendo atención en clase.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2026-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'f5654acecd5e40c19f5854255d7f5c80c95aa2c09856d7b96ac21ebe1c5e359f'::TEXT, ARRAY[1708]::BIGINT[]),
    (46::BIGINT, 'De los mejores cursos que he llevado. Es muy fácil pasar con ella y la verdad si se aprende bastante, casi todas las evaluaciones las revisa en clase antes de subirlas y hace exámenes iguales a las prácticas. A parte es muy atenta a los estudiantes y súper linda persona, aunque sea medio cuadrada.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'c5123f3680a206f466cc040657a5b147c80d422fccc48c2520539813432c9a1f'::TEXT, ARRAY[1708]::BIGINT[]),
    (46::BIGINT, 'Matricule con ella sin miedo, es la única que da este curso bien, con cualquier otro profe la gente se queja demasiado. Explica demasiado bien, si pone atención en clase y hace los ejercicios con ella, entiende de fijo. Resuelve dudas de lo más tranquila. Nos dejó usar plantilla para los exámenes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'd25f51a9ede5c9d2d9dbd57238851a5fefb6a3168c0e99d0cf11dbe98a8fde30'::TEXT, ARRAY[1708]::BIGINT[]),
    (46::BIGINT, 'Es muy buena profesora, organiza muy bien las clases. Los ejercicios más dificiles se hacen en clase, dejando para los examenes y las tareas los más sencillos, casi que todas las semanas quedan tareas pero son tareas sencillas que no requieren mucho tiempo, nos permitio usar plantilla.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-18T00:00:00+00:00'::TIMESTAMPTZ, '7913f4fbd50644718e1abe9537f0c3491676447c7b853e802a74ce94895b458a'::TEXT, ARRAY[1708]::BIGINT[])
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
