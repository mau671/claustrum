-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=685
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:49:38.573581+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (685::BIGINT, 'Es una profesional excelente, con mucho conocimiento para brindar en las clases. Explica las veces que sea necesario, es muy paciente y siempre va a dar una respuesta a cualquier pregunta. El curso es demandante pero con poner atención en clases el estudio se facilita un montón. Recomendada.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-04-08T00:00:00+00:00'::TIMESTAMPTZ, 'f42a13038b81c9f30c11f5ac4ad941c174901348726dc2f8784cef5b7a58c04e'::TEXT, ARRAY[2607]::BIGINT[]),
    (685::BIGINT, 'Falta de profesionalismo impresionante. Es el tipo de profesora pick me que coquetea con alumnos y un profesor específico de la carrera, lo que resulta totalmente desagradable. Si sos mujer sos una mierda a sus ojos. Ojalá hubiera en la escuela otra opción para no volverla a ver nunca'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-09-22T00:00:00+00:00'::TIMESTAMPTZ, '439a434f76b658cbcebad432b0d64a046b30d79dd93d2dd175c1af5379f24e63'::TEXT, ARRAY[2607]::BIGINT[]),
    (685::BIGINT, 'La profe es muy buena, sabe muchísimo del tema, le gusta que los estudiantes participen en la clase. Los exámenes son difíciles porque es de analizar. Prepárese bien para el proyecto final ya que le pregunta bastantes cosas.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2023-02-04T00:00:00+00:00'::TIMESTAMPTZ, '54d888cad73ccb2aa7ea4d4889e167262e390057eb5b82c8e564a1f41c7129b0'::TEXT, ARRAY[2607, 2614]::BIGINT[]),
    (685::BIGINT, 'Explica bien, es estricta y a veces es muy safada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases largas']::TEXT[], '2023-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'e5feeaaea1e3f522a2dc264f37ab7eef65568e2259e80a07e66a95f28f056837'::TEXT, ARRAY[2607]::BIGINT[]),
    (685::BIGINT, 'Es muy buena gente, los cursos que importe son de mucha materia por lo que las clases son bastante pesadas. Los exámenes son duros porque son de analizar la materia. Ella siempre está dispuesta a ayudar a los estudiantes. Es un poco desordenada con las notas, todas las sube al final del semestre'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'cd37a5b30d1785947cdc3558b44ffee548f82b2adb925cf4d057ad1c02e67c85'::TEXT, ARRAY[2614, 2607]::BIGINT[]),
    (685::BIGINT, 'Ella es una excelente profe, explica bien, pero los exámenes suelen ser complicados por la cantidad de materia que se ve en el curso y porque son de análisis. Se aprende bastante y es muy interesante.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '1176943f0d13d31318aeb72ada133d978c914ccf4230a9c2cd1f72dece0ac959'::TEXT, ARRAY[2607, 2614]::BIGINT[]),
    (685::BIGINT, 'Es buena profesora, explica muy bien y sabe lo que está hablando;'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-04T00:00:00+00:00'::TIMESTAMPTZ, '89737df66f310eaa260fa948b19e75411e0cdb7224bacaef0108f7a9695f49b8'::TEXT, ARRAY[2607]::BIGINT[]),
    (685::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2021-09-14T00:00:00+00:00'::TIMESTAMPTZ, 'e4c1f8782c9196c3023b381b1ceb025d271ec351214207217bcd5c3c0b6fdfb3'::TEXT, ARRAY[2607]::BIGINT[])
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
