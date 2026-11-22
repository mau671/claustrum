-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=365
-- TEC-DATA-META years=2016,2020,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.177964+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (365::BIGINT, 'Excelente profesor, explica muy bien. El curso como tal tiene muchas tareas, pero con tiempo se saca. Lo más largo es el proyecto y los grupos son aleatorios, así que es pura suerte! Si puede compre el folleto, ahí está toda la materia.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '2fe02d539fd6ef5747f4aa014bf7bb3d101ca475ab011fb95556acb89de60266'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, 'El profe sabe muchísimo, pero no explica de la mejor forma. La materia no es complicada pero si es mucha cantidad. El proyecto es pesado porque usa un software super obsoleto. No es un curso super complejo, pero hay que poner de su parte.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, 'def98146dfeb0c272ee172a6197496d400b740139dbec27a3c52d95b3da57148'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, 'Una burla de profesor. Se pierden la mitad de todas las clases viendolo hacer mil ejercicios a la velocidad de la luz o hablando absoluta papaya. Exámenes ridiculamente largos que no tienen nada que ver con la clase y un proyecto enorme con grupos que el elige al hacer. Vaguísimo.'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-09T00:00:00+00:00'::TIMESTAMPTZ, '5e04a73ebb8688a6ffd51d34145399073b0671bb8a490f3b697c8998da98d4af'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2020-09-01T00:00:00+00:00'::TIMESTAMPTZ, 'f8c5991f5e55e5eed361034821834b7aba6a8377274efceebeac18803c129cf2'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, '[virt]El profe es super desordenado utiliza software desactualizado. Si no sabe usar Civil3D, él tampoco, entonces tiene que ver como aprende para que le salga el proyecto. Los grupos son al azar y hay que pasarle recordando al profe las cosas. Cuesta mucho sacar cita para que atienda y se le olvida'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2020-08-14T00:00:00+00:00'::TIMESTAMPTZ, '82e7fb48c1d63787a9c82b8bddfad141ee9b05ea63b0fb7e58b0abd221998b90'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, 'Curso pesado. El profesor es un poco irresponsable y desordenado, pero se aprende mucho. No es nada flexible a la hora de compartir el material de apoyo, todo hay que recordárselo. Es bueno enseñando pero espero no toparlo en otro curso.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2020-07-30T00:00:00+00:00'::TIMESTAMPTZ, 'a6e463d5605e9eb16897a884f4d40bc355f0bd2796d71ed12d281e3d604ca840'::TEXT, ARRAY[1221]::BIGINT[]),
    (365::BIGINT, 'Es un excelente profesor, explica muy bien la materia, ayuda mucho a los estudiantes y se interesa por el aprendizaje de todos. Recomendado 100%, el curso es pesado, pero se aprende mucho.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2016-11-12T00:00:00+00:00'::TIMESTAMPTZ, '27cb89dd749b70a87c453189b4a9d5dc429f530bc324c7d5f178bc51f1a6cc94'::TEXT, ARRAY[1221]::BIGINT[])
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
