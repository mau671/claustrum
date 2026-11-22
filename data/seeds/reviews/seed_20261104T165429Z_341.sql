-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=341
-- TEC-DATA-META years=2021,2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.159597+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (341::BIGINT, 'La profe es buena gente, pero en sí la dinámica del curso es algo desordenada. Muchas veces se confunde un poco con las fechas, y en sí el alcance del proyecto que propone es grande, ya que pide un mínimo de 60 requerimientos. Casi siempre está pendiente para aclarar dudas.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-08T00:00:00+00:00'::TIMESTAMPTZ, '5106376769418ed542f103c4ccf359e872061916e7663340c1ea935d5a69ead5'::TEXT, ARRAY[1159]::BIGINT[]),
    (341::BIGINT, 'La peor profesora que tuve durante la carrera, y eso que tuve clases con Eddy.'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, 'c27a149075d30d8a7365889d29dc31153979992f6a5057d2e0952722d2f9d693'::TEXT, ARRAY[1159]::BIGINT[]),
    (341::BIGINT, 'Cuando ella dice algo NUNCA lo tomes en serio, si ella dice que dará puntos extra por algo no pierda el tiempo en hacerlo, la mae nisiquiera lo va a contar de la manera correcta y aparte pensará que uno es el que la está embarcando, siendo que ella dijo otra cosa diferente. No lleve con esta profe.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2022-12-30T00:00:00+00:00'::TIMESTAMPTZ, '4cad8c4e8194821c4c89775167722f7118a865d653adb81eb41951d67abd57cc'::TEXT, ARRAY[5]::BIGINT[]),
    (341::BIGINT, 'El curso de Gerencia TICs es un complemento ideal para cualquier ingeniero en computación y la profesora López está muy capacitada y experimentada en el tema. Es un curso donde hay que ponerle, ya que hay que estudiar bastante material y hacer trabajos en grupo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'fefeb86989ea8935ab5b5e309fbd57f4e6e48330b235147a1da0d0157d7a1708'::TEXT, ARRAY[3485]::BIGINT[]),
    (341::BIGINT, 'ayuda a los estudiantes cuando tiene dudas, trabajos grupales varios, bastante trabajo en clase.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2022-11-17T00:00:00+00:00'::TIMESTAMPTZ, '8fd83efa8dcf7803caf440c73ec8d59e8c61e8606eeea1fd7a1ba9491f237940'::TEXT, ARRAY[3485]::BIGINT[]),
    (341::BIGINT, 'Este ha sido unos de los cursos más provechosos que he recibido en la carrera. La profesora Cynthia es estricta y tiene un amplio dominio de lo que enseña, por lo tanto, no es un curso apto para estudiantes poco aplicados. De su curso solo me llevo conocimientos valiosos y muy útiles.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2022-11-17T00:00:00+00:00'::TIMESTAMPTZ, '828c45a19344fe827363d4583594ce60cf66102c56722fcbb7926306dd73f4b6'::TEXT, ARRAY[5]::BIGINT[]),
    (341::BIGINT, 'Es una profe totalmente subjetiva, si usted le cae mal, prepárese para que se queje de usted todo el tiempo, es súper necia en muchas cosas que no tiene sentido, evalúa super subjetivo, si a ella no le parece algo (aunque esté bueno) se los va a poner malo y no acepta solicitud de cambio'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos']::TEXT[], '2022-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'f056fbd215d2106be51a3f6360ec7b5a9b062c434c379d2b0bc37ba8250d7fa6'::TEXT, ARRAY[3485]::BIGINT[]),
    (341::BIGINT, 'No puedo expresar con palabras lo asqueado que quedé de este curso está profesora si te agarra entre ojos te va a bajar puntos sin justificación, adicionalmente ella durante todo el curso habla sobre "puntos extra" durante todo el semestre, no pierda el tiempo haciéndolo, al final la doña no lo vale'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2022-11-12T00:00:00+00:00'::TIMESTAMPTZ, '8fb588c4383362daea86d2388a3f738dd2845bc65a9dd1d46ed5dfcbe021c32c'::TEXT, ARRAY[5]::BIGINT[]),
    (341::BIGINT, 'Si tienes un buen grupo de trabajo (que no sean vagos) el curso se pasa fácil, porque la nota se va a determinar por trabajos grupales, simplemente entregue todos los trabajos de la manera que pide y vas a pasar.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Muchos proyectos grupales']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '2eab5b5df53055fa4ec016868fedc5eb9470380d23edf2bc2777f29b46f169bb'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'Pésima profe, siempre se pasa de la hora, explica súper mal y califica subjetivamente y no basándose en materia, claramente agarra estudiantes entre ojos y les baja puntos sin sentido, para los exámenes casi no da tiempo de terminarlos y aun cuando la mayoría necesita tiempo no lo da, 0 empatica'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, 'b2f40e9802a4160cf32345e6e9924c0c6e7ea519f40d90056d8b082ec48ca676'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'Creo que una vez se durmió durante un examen'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-29T00:00:00+00:00'::TIMESTAMPTZ, '1b445b78b593193011914856ef0dfb0a2fcafb2acb9828f26b33f9714d50d65f'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'Irrespetuosa con los estudiantes y no le gusta escuchar, además para ser un curso de administración se siente todo muy desorganizado y claro.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-23T00:00:00+00:00'::TIMESTAMPTZ, '4c0ddf600a54da59a0ff30a9bce706bd3622620a451e99a15e8b7083656a04f9'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'No recomendada, casi todas las clases se pasa de la hora, deja trabajos que no explica bien hacerlos, se contradice mucho, a veces cuando se le preguntaba algo no respondía de la mejor manera.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-07-03T00:00:00+00:00'::TIMESTAMPTZ, '8ad85c4cf1d61bba4a2a92eecaaddcde1f24296033a56b021bda3dc7992944eb'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'No respeta a los estudiantes, no se puede negociar, en cada clase dice una cosa distinta, no toma en cuenta el tiempo, no sabe explicar, es una persona muy desordenada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2021-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'ed57e4196d947b20881e3f7772a83399c9e92511f4a5df8b8823acadd64de5da'::TEXT, ARRAY[1052]::BIGINT[]),
    (341::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Muchos proyectos grupales']::TEXT[], '2021-04-27T00:00:00+00:00'::TIMESTAMPTZ, 'f16593e829800499f397002cce79868de15a5de0ff6f6b216ddced61005970ee'::TEXT, ARRAY[1052]::BIGINT[])
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
