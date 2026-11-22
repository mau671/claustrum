-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=427
-- TEC-DATA-META years=2021,2022,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.989713+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (427::BIGINT, 'Pésimo.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-09-12T00:00:00+00:00'::TIMESTAMPTZ, '134fb4639ff7badffc2f2d488ed21fad25e75b47ecd6ec2c91f6b2712c0f9c49'::TEXT, ARRAY[1728]::BIGINT[]),
    (427::BIGINT, 'Pésimo profesor. Lee diapositivas, no hace acepta reclamos y las clases son horribles. NO lo recomiendo.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Pocos exámenes']::TEXT[], '2024-11-12T00:00:00+00:00'::TIMESTAMPTZ, '9e316fddfcb3b33542195d9a9ce9083d54cb7c22534933813a26b2989ab4a633'::TEXT, ARRAY[1728]::BIGINT[]),
    (427::BIGINT, 'Los exámenes son súper confusos, no busca ayudar al estudiante, si puede lo queda a uno, solo lee las diapositivas y es aburrido.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2024-06-10T00:00:00+00:00'::TIMESTAMPTZ, 'bd0f557172d2f2192562960ac7e3500c5e3ca1d341d99846593081b6eae312d1'::TEXT, ARRAY[1728, 1742]::BIGINT[]),
    (427::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2022-01-21T00:00:00+00:00'::TIMESTAMPTZ, '68a29f56c0081d82b2e205b363ec20236596c3a50f35df896030ad0786e06bff'::TEXT, ARRAY[1727]::BIGINT[]),
    (427::BIGINT, 'Muy malo no sabe explicar solo se basa en diapositivas. Examenes muy confusos que ni él sabe explicar, tiene un machote para aplicar examenes así que busque gente que lo tenga porque siempre aplica el mismo PESIMO'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-17T00:00:00+00:00'::TIMESTAMPTZ, '676c138d5f4053ddd2d070129d38b59e4a84087910bd76d6995d3230007b3fc0'::TEXT, ARRAY[1727]::BIGINT[]),
    (427::BIGINT, 'No es buen profe legal, únicamente lee y explica diapositivas, pero al menos se le logra captar el mensaje, los exámenes son confusos.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '27b201efb0fcae36cceef233b712d9d09290563fa322f48a5315d84932cb4163'::TEXT, ARRAY[1742]::BIGINT[]),
    (427::BIGINT, 'Una basura de profesor, no ayuda al estudiante, busca perjudircarlo, hace quices cuando algunos estudiantes no pueden ingresar a la sesión, sólo lee diapositivas.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2021-02-16T00:00:00+00:00'::TIMESTAMPTZ, 'b6fe55bfc0bde49fcb5052ae07d45c95451a92de27600e3d2d9b8bf36c25a063'::TEXT, ARRAY[1728, 1742]::BIGINT[]),
    (427::BIGINT, 'Si de algo sirve es bueno mencionar que llevó el curso virtual casi que por primera vez, no lo llevaba hace muchos años según comentó. Es buena persona sin embargo son clases aburridas y no muy claras. Si tiene otra opción, mejor tómela.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '04a6d64609b73de8efd05678e5e9725697cc25b60531fe92c356217be7b922b3'::TEXT, ARRAY[1728, 1742]::BIGINT[]),
    (427::BIGINT, 'Los laboratorios y tareas son fáciles siempre y cuando no lo deje para último porque son largos. Buen profe, solo tiene que prestarle atención y más porque se la pasa preguntando. Siempre realiza retroalimentaciones.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'a91b4e22b4f8e43365cfcd6058df1387d23eae9463bf8f6f93a3b742552e59c0'::TEXT, ARRAY[1727]::BIGINT[]),
    (427::BIGINT, 'No explica bien, lo que hace es leer diapositivas, las clases son muy aburridas y desmotivantes. No se enfoca en el aprendizaje del estudiante sino en joderlo. Tiene preferencia hacia las mujeres...'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2021-01-28T00:00:00+00:00'::TIMESTAMPTZ, '4f8052edf03c64ac4470b7c1939d44656eebfd98a48cbc9dd37d5bc50f8a3a94'::TEXT, ARRAY[1728, 1742]::BIGINT[]),
    (427::BIGINT, 'Excelente profesor, tiene programadas todas las asignaciones para todo el semestre, se hacen 2 laboratorios bastante fáciles pero largos por lo que ideal es tener un buen equipo de trabajo. Lo único que no me gustó es que hace retroalimentación proyectando las cosas que tuviste malas a toda la clase'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-25T00:00:00+00:00'::TIMESTAMPTZ, '92b0a6c856287f37f7a45b539128915de066cba307d1afadd9b087779a1a73c9'::TEXT, ARRAY[1727]::BIGINT[]),
    (427::BIGINT, 'Deja laboratorios muy largos. Al principio parece duro, pero califica relativamente suave. Desde el primer día tiene todas las entregas y tareas programadas. Es bastante ordenado y se aprende.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-25T00:00:00+00:00'::TIMESTAMPTZ, 'c8008260b80e47d1242bc47f6c3198c56d03c2311b6403fbad6d76cf1309bc3b'::TEXT, ARRAY[1727]::BIGINT[])
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
