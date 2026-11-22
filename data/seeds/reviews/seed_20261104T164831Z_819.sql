-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=819
-- TEC-DATA-META years=2017,2018,2019,2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.866984+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (819::BIGINT, 'Ofrece bastante apoyo si el estudiante se muestra interesado en la clase. A veces las hace un poco largas en explicaciones, pero todo con el énfasis que el estudiante entienda la materia.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2025-07-23T00:00:00+00:00'::TIMESTAMPTZ, 'bd5585e026c52d14487091aec47b5d2347cdf6a8129ac7a96c5b4f177634c994'::TEXT, ARRAY[613, 567]::BIGINT[]),
    (819::BIGINT, 'Explica muy bien, todo queda claro y es bastante comprensiva, los quizes se estudian con el cuestionario previo y con eso ya se pasan, tambien un poco estricta pero lo normal. Gánesela yendo a horas consulta, y así la clase se va a hacer más amena una vez ella sepa que a usted le interesa pasar.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'cbb0af9f77d998ddeea0ebe070bc8a7f445ef67629ff1c3f630ca91c8ce9a327'::TEXT, ARRAY[613, 567]::BIGINT[]),
    (819::BIGINT, 'Me quedo, cuando lleve su curso en UTN'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Exámenes retadores']::TEXT[], '2024-05-09T00:00:00+00:00'::TIMESTAMPTZ, '4a77d3f4f5eb8a096c376688541a3fbf5e57ada1fdef915e2d9a12865cc10223'::TEXT, ARRAY[1433]::BIGINT[]),
    (819::BIGINT, 'Buena profe. No hace la clase abrumadora.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '0dc78c6b4dee76a549f4eed1b30ca1d327831a673e6693bfce230106fa7cc6b8'::TEXT, ARRAY[567, 1433]::BIGINT[]),
    (819::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-11T00:00:00+00:00'::TIMESTAMPTZ, '0db27ca5587b574e392b9ed1fef4fb18b6518dcf2547349b9afea33fc49fe922'::TEXT, ARRAY[567]::BIGINT[]),
    (819::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-02-25T00:00:00+00:00'::TIMESTAMPTZ, '3fc0017ddbf6d4bb751c748588d819626fd83aa49857e37c1f03853bec58c1ac'::TEXT, ARRAY[613]::BIGINT[]),
    (819::BIGINT, 'Muy buena profesora, ayuda bastante, siempre se preocupa porque uno salga con todos la materia comprendida. Recomendada.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2021-09-02T00:00:00+00:00'::TIMESTAMPTZ, 'f4d64e63ae6115340a3bc10079ab9906fae6f47d8f608fb588dff0998bcd7875'::TEXT, ARRAY[567, 1433]::BIGINT[]),
    (819::BIGINT, 'Todas las clases son videos grabados anteriormente, no puedes preguntar en el momento, sino hasta el final, que es cuando empieza a dar clases en vivo :('::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-03-02T00:00:00+00:00'::TIMESTAMPTZ, 'f2af5d10d89b20ab6b19d8d72c1baa96a9253fe5f017acc675eeacbdf92cff06'::TEXT, ARRAY[573]::BIGINT[]),
    (819::BIGINT, 'Explica con mucha claridad, hace mucha practica durante las clases, aclara todas las dudas que tengas. Se interesa en que el estudiante pase.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2021-02-10T00:00:00+00:00'::TIMESTAMPTZ, 'd2da2c1af774f79348e8d6995a24f299af803a249d05cbc6f6dd560d37314ff4'::TEXT, ARRAY[567, 613, 1433]::BIGINT[]),
    (819::BIGINT, 'Pone esmero en sus clases, pero hay que estudiar y practicar bastante. Explica muy bien y se preocupa porque los estudiantes estén muy bien preparados para el examen.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2020-12-19T00:00:00+00:00'::TIMESTAMPTZ, '7ef32d6e3aac9b954a9c1a8831c312291b69a228f214abcc61b7c49e36bf9cca'::TEXT, ARRAY[613]::BIGINT[]),
    (819::BIGINT, 'Explica muy bien pero es sumamente exigente con los estudiantes, cree que solo se esta llevando el curso de ella, los examenes que escoje de lab son los mas duros ademas que en los informes siempre busca la perfeccion, y tiene argollas'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2019-10-16T00:00:00+00:00'::TIMESTAMPTZ, 'c368cb80ef508fc1f84a4aaa7e8513b4239c2f5165d241724e9d17b4a7423ef0'::TEXT, ARRAY[567, 1433]::BIGINT[]),
    (819::BIGINT, 'Explica bien, pero tiene mucha preferencia, y es muy argolluda con los que le caen bien, .'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-10-05T00:00:00+00:00'::TIMESTAMPTZ, 'a853a1e08700b90242ef05a19b6c4d6b0d23b1b2dd0028ae503ddf624d241a44'::TEXT, ARRAY[567]::BIGINT[]),
    (819::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2017-11-25T00:00:00+00:00'::TIMESTAMPTZ, '40bec1a8be172602dc6fe76a99456b3b396d292d8bbda9f79556fc7547410b5b'::TEXT, ARRAY[567, 613, 1433]::BIGINT[])
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
