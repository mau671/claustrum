-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=739
-- TEC-DATA-META years=2016,2018,2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.227965+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (739::BIGINT, 'El curso es de lo que más te va a consumir tiempo en el semestre, entonces no meta muchos créditos por su propio bien. La profesora explica fenomenal, y se le entiende mucho, pero estudie bastante. Ella es muy particular en cómo pide las respuestas y los exámenes no son fáciles (el curso es pesado)'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'dcbde2b099d3768e4ce67dc57e6ec236b012d44cf652f6ae87ddd016ffb383de'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Me parece un curso super mal planteado, con un proyecto que consume todos los días del semestre, para que después un jurado decida no probarlo. Es el tipo de profesora a la que es mejor no hacerle consultas ya que ella siempre tiene la razón.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '91f3257a2c6c8bd0dcc8d8e12916cf345616cb7c9218eb75d40a22f7698a25c7'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Los quices son adelantos del proyecto final. Es una electiva super chiva. (Si se compara con Inge es super sencillo). Todas las semanas alguien lleva te y bocadillos, además este semestre tuvimos la oportunidad de trabajar con estudiantes de Chile, tuvimos gira y solo 1 examen (con partes grupales)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2025-01-17T00:00:00+00:00'::TIMESTAMPTZ, '11285c59fb3641a483c83037216652c2debed26bc39c77ee8e79027cf3714e62'::TEXT, ARRAY[3310]::BIGINT[]),
    (739::BIGINT, 'Inaccesible a reclamos, no da mucha retroalimentación. Explica muy bien pero la clase es tediosa. Le encanta que digan que su curso es dificil pero yo creo que lo hace innecesariamente más complicado de lo que debería ser. El trabajo extraclase va a consumir su vida eh'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'b45984e7e62e3bee25dcf1d2ee43a0bc7a1f92f5e3214da70912bb49ecdaea47'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Sus quices y reclamar puntos es complicado, pero es que EL CURSO es re pesado (hay que dedicarle MUCHO tiempo extra clase en el lab). Ella es de las mejores profesoras que he tenido. Sabe demasiado y explica muy claro, hace que sea fácil ponerle atención incluso en clases de 4 h. Es muy accesible'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2024-07-26T00:00:00+00:00'::TIMESTAMPTZ, 'aa3f146b8b3e3cc0d2a0724657fa93169cd26ff89aa909c5bd8ea38e3a9557be'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Extraordinaria profesora y profesional. El curso es exigente porque así debería ser. Sus explicaciones son super claras y nunca se pierde la atención durante su clase. De las mejores profesoras que he tenido en la carrera.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-09-03T00:00:00+00:00'::TIMESTAMPTZ, '768f4a3e24969310f850608241b97ae290eb431c76583d235c7e0a1fb772b2c1'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Sus clases son claras y se aprende bastante, sin embargo sus evaluaciones son bastante molestas, ya que siempre pide respuestas textuales a lo visto en clase y no acepta el mínimo reclamó. En cuanto al proyecto consume demasiado tiempo y es poco útil.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-08-19T00:00:00+00:00'::TIMESTAMPTZ, '78b610c340a62794de4da2349be8f0946cea3971c7133a0688865606a6094381'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Da explicaciones claras y hace el curso interesante. El proyecto consume muchísimo tiempo, pero se aprende. Los exámenes son fáciles, pero necesita respuestas concisas y es difícil que acepte reclamos'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '692ee9e46ce7dd53ee63c154c923a6419a71b26fe71dc8635864d690c0e46ab6'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Sus trabajos son largos y tediosos, califica demasiado duro y necesita de respuestas textuales. El proyecto no sirve para nada y quita demasiado tiempo.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, '961a71e670d4791fbe3902095a696bf7769986a37c0317d45e83a9f1ab9f94b9'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Sus clases son buenas, pero solo eso. Califica demasiado duro y de una forma incoherente a lo visto en clase, el proyecto toma demasiado tiempo para lo poco útil que es, con ella las cosas tienen que ser perfectas porque con un error mínimo se pierde la mitad de los puntos de toda la asignación.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-05-01T00:00:00+00:00'::TIMESTAMPTZ, 'fa6186633701b444262b65473e61c06c1fc11d166cb49d846bdd88d3ec0ee45d'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'La profe como tal es buena gente pero parece otra persona en el curso. Califica super duro, se requiere demasiado tiempo extraclase, los quices son una pesadilla y en los exámenes puede llegar a poner malo lo que dijo en clase. Se puede reclamar si está bien sustentado. Se aprende bastante.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '1835134fd0663a189b3a887a7c67ab8f6a1104ac15686f8549422f3f727cb806'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Es una profesora que se salta todo reglamento, evaluativamente es un dolor. En cuanto a materia el curso es muy fácil de entender y no da para ser difícil, entonces como no da para ser dificil, la profesora hace lo que sea para que sea dificil, eso incluye evaluciones muy injustas y sin sentido.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2021-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'd1ccfb442c54da508b356a800ca123bd38c13b90a63c78fb6954ac1c8ff47847'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Es una buena profe, explica bien y se preocupa de que el estudiante aprenda. Es demasiado exigente con los trabajos y es prácticamente imposible que acepte algún reclamo, ella siempre tiene la razón'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '83b29447489ae95917fd8c5e776f349c9543f43021628cc54098b44c2e6f1725'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Todo lo relacionado a evaluaciones es solo lo que ella dice y siempre tiene la razón. No califica claro y haya cualquier excusa para no aceptar reclamos, aunque sea con respaldado de sus propias clases.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '84f22318c76a2ed1bd9e4bef9887f4e056fdcd7acc45586fd7b2a08ad7dcbdac'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'La profe es muy buena explicando la materia y uno si aprende mucho. No obstante, a la hora de aplicar lo aprendido en los exámenes, podes poner exactamente lo que ella dijo en clase que te lo puede poner malo. Yo tuve que llevar el curso virtual y pues, el curso definitivamente consumió casi todo.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '9082fb5e5f7ec25ff793fbc0bab7ea437707337fac5b82d53238866cd99fcaa4'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'El curso es súper intenso con ella, nunca se le queda bien. Califica súper duro en comparación con lo que enseña y se pasa el reglamento por el piso. Hace lo que quiera y siempre tiene ma razón'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'cba2e163034d6cc9bf825b4e76568254389a8eee47969b0982d9332a4fa72dca'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Hace lo que se le da la gana con el grupo'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2018-05-29T00:00:00+00:00'::TIMESTAMPTZ, '5bdb536d6fed5f06c6142ac42d704900c4f650ccb82309e1f58f25b3f90c6910'::TEXT, ARRAY[3280]::BIGINT[]),
    (739::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, '283bd4b88dd714325a7c13a5511a208a410ed8b953f6560c2b9bd3baefac5cf3'::TEXT, ARRAY[3280]::BIGINT[])
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
