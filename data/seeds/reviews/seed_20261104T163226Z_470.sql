-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=470
-- TEC-DATA-META years=2020,2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:26.979768+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (470::BIGINT, 'A mí me cayó bien, siento que sí es accesible y buena gente, y dispuesta a ayudar. Pero sí es muy desordenada. Quiere explicar mucho y se ve que le apasiona, pero termina haciendo enredos por lo mismo. Pero al menos es buena persona.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-06-17T00:00:00+00:00'::TIMESTAMPTZ, '60a961851365370866180c17727cdfe64d7cb321fbf3eaa6a442b76664310b95'::TEXT, ARRAY[3089]::BIGINT[]),
    (470::BIGINT, 'Inespecifica, no le interesa el estudiante, solamente le importa que le paguen su salario. Si le caes mal no cuentes con ayuda,'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'ba80baf473a60bc3f1310baaa0cd683f90b1551c12a0bcf8124575073e8561df'::TEXT, ARRAY[3590]::BIGINT[]),
    (470::BIGINT, 'La materia no es tan clara, cuando se pregunta le da mil vueltas a la respuesta y al final no llega a nada. Trabajos extensos. No planifica bien las clases y sus PPP son un poco desordenadas. Se ve que sabe bastante, pero al final no se aprende mucho.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2021-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'ff3bca84c493d91313337b164876db4d852b2ea3e2f7367d3c3a676fc4e58531'::TEXT, ARRAY[1468]::BIGINT[]),
    (470::BIGINT, 'La profe sabe muchísimo y se nota su conocimiento, pero a veces al preguntarle algo, se enreda y en realidad no contesta la pregunta. Los proyectos que deja sirven mucho para aplicar lo que se ve en el curso, pero no organiza bien las clases y pierde mucho tiempo en cosas innecesarias..'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2021-06-19T00:00:00+00:00'::TIMESTAMPTZ, '67a5840e0fc78a38209e7694240d67ecde477880c5c68432574b520a1050ed72'::TEXT, ARRAY[1468]::BIGINT[]),
    (470::BIGINT, 'Deja demasiados trabajos, extremadamente largos, la rúbrica con la que califica es otra a lo que a uno le pide que haga entonces hay que estar haciendo reclamos para ver si arregla la nota. Las últimas clases literal son los estudiantes quienes las hacen ella ni las explica. (I semestre 2021)'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2021-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'f232a4d41dbf38c6cd5d5365caaaa46c130f6939bf28fb70b216fb2bcaa5d387'::TEXT, ARRAY[3089]::BIGINT[]),
    (470::BIGINT, 'Es muy buena profe, trata de que el estudiante entienda y se interese en su clase. Deja trabajos casi todas las semanas pero son grupales y relativamente cortos. Califica suave, el curso se pasa fácil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-17T00:00:00+00:00'::TIMESTAMPTZ, '755f5e88acdb50ff88b910c5c41e06bb1c1d21ad60b8c53b1c98758f7f2bab03'::TEXT, ARRAY[998]::BIGINT[]),
    (470::BIGINT, 'La profe es buena y califica suave, pero aveces no mantiene bien organizado el tiempo para ver bien todos los contenidos del curso y deja trabajos bastante largos pero buenos para entender mas la materia.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ, '8e27a99d84e4ff231281a2bec979cb4825b6b30c30738da60c46088163460569'::TEXT, ARRAY[3089]::BIGINT[])
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
