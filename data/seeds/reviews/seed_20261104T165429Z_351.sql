-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=351
-- TEC-DATA-META years=2017,2019,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.168920+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (351::BIGINT, 'El curso se pasa solo, consiga un buen grupo de trabajo, haga las tareas y las lecturas y ya con eso sale. Los exámenes los hace en un forms. Las clases son entretenidas la mayoría de veces'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, 'aa70b625245bfb680215be630069ad4bb532d8df53610bc47674b25e6404734b'::TEXT, ARRAY[1218]::BIGINT[]),
    (351::BIGINT, 'Deja tareas todas las semanas pero son fáciles y ayudan bastante en la nota. Hace actividades en clase que hacen que el curso no se vuelva aburrido. Los exámenes no son fáciles (hay que estudiar bien) pero califica suave. En resumen, el profesor sabe mucho y hace que el curso valga la pena.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo']::TEXT[], '2019-11-28T00:00:00+00:00'::TIMESTAMPTZ, '1e273248da493911ae8218960d5eeedb02291145f41d03c642d97e11d754322c'::TEXT, ARRAY[1218]::BIGINT[]),
    (351::BIGINT, 'Excelente profe, las tareas que deja y estudiar esas tareas para los quices orales, ayudan a que no se acumule la materia, los exámenes son durillos pero pasables, explica muy bien y ayuda bastante.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2017-12-06T00:00:00+00:00'::TIMESTAMPTZ, '9f8937e143e624d6b8fabd273968adfd57322e1f6b4685410523654fae79526c'::TEXT, ARRAY[1218]::BIGINT[]),
    (351::BIGINT, 'De los mejores de constru, sinceramente llevaría cualquier otro curso con él.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-24T00:00:00+00:00'::TIMESTAMPTZ, '4b6dd989bc3ae30d303c38fe4a5c6044619917ec6d6ad0e54e2275ca887ac24c'::TEXT, ARRAY[1218]::BIGINT[]),
    (351::BIGINT, 'Es muy buen profesor, sabe mucho de la materia, los exámenes son difíciles, deja muchas tareas, explica las veces que sea necesario, es atento y flexible a la hora de negociar fecha de los exámenes'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Exámenes retadores']::TEXT[], '2017-06-05T00:00:00+00:00'::TIMESTAMPTZ, '01ecb2c6831c44acbd69c9c9ed08fc61576dcc2eb293825e48db13b4874512e7'::TEXT, ARRAY[1218]::BIGINT[])
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
