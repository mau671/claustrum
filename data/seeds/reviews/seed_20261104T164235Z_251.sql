-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=251
-- TEC-DATA-META years=2016,2017,2018,2019,2020,2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.851109+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (251::BIGINT, 'Muy pura vida, da ayuda y tiempo siempre que uno lo ocupa y deja reponer labs y practicar para exámenes. La parte teórica de los exámenes es muchísimo más ruda que con los otros profes y hay que estar muy atento a lo que dice en clases. Recomendado pero si busca pasar más fácil es mejor otro profe.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'b3d983eb013569201659f495fdb7d516e30884aa885b05de578e3a2ac436c145'::TEXT, ARRAY[3054]::BIGINT[]),
    (251::BIGINT, 'Es un profe de la vieja escuela. Muy anuente al cambio de fechas o a hacer acuerdos. Los primeros 2 exámenes son bastante normales, califica bien, para el último tira a matar, así que mejor no depender de él. Varios quices y tareas, 2 proyectos, que se sacan en un finde.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas']::TEXT[], '2023-11-26T00:00:00+00:00'::TIMESTAMPTZ, '624509b1091633beb067688573c85ab364a46b9ca803cfd6cb69a266455f288c'::TEXT, ARRAY[992]::BIGINT[]),
    (251::BIGINT, 'Se pasa fácil si usted le pone, vaya a consulta y participe en clase. Los exámenes no son tan duros'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo']::TEXT[], '2022-12-11T00:00:00+00:00'::TIMESTAMPTZ, '4271906886ba6ce36eac52471b3802ac0a99f459f6e00850d4090fd99088096a'::TEXT, ARRAY[992]::BIGINT[]),
    (251::BIGINT, 'Buen profe'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '1a527434ca7452049f751a3ab7d7b64ceb0e23abbd263c37de2b68247ee5639a'::TEXT, ARRAY[3054]::BIGINT[]),
    (251::BIGINT, 'Este lab se tiene que pasar prácticamente solo con ayuda de compañeros que ya lo llevaron ya que los profes no explican nada de lo que se va a hacer la siguiente semana, solo se ve un poco en teoría pero no siempre coincide la materia. Fuera de eso califica suave y si entrega todo de fijo pasa.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, '49828b947d579d4bc2256e9108439be00c79979bb1d70f9244a8627a8efb5791'::TEXT, ARRAY[994]::BIGINT[]),
    (251::BIGINT, 'Da mucho que desear como profesor. Muestra poco compromiso con su trabajo con lo desordenado que lleva el curso y el trato impersonal a los estudiantes. Cualquier duda mejor ir con Osvaldo directamente.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2021-02-11T00:00:00+00:00'::TIMESTAMPTZ, '6c4c37fe03724c09086d09ec4c35d3c159afffa6919691c81dd626fb0a6524c2'::TEXT, ARRAY[3054]::BIGINT[]),
    (251::BIGINT, 'Se tiene que ser autodidacta en todo el curso, el profe solo ve los videos y ya, no explica nada, no da retroalimentación, a veces ni sabe de qué trata el laboratorio de la semana, las notas las pone a conveniencia, es muy desordenado, es un desesperado por terminar la clase, pero se pasa fácil'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '425f33f8368f326f3912d9f75802255921479e276a5a318a29b07d2b60b008c3'::TEXT, ARRAY[994]::BIGINT[]),
    (251::BIGINT, 'El curso es 100% autodidacta, el profe solo se limita a "revisar" la entrega de cada semana (a veces ni siquiera sabe que se tenía que presentar ese día). No explicó ni una sola cosa en todo el semestre. Hay que dedicarle mucho tiempo al curso.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2021-01-27T00:00:00+00:00'::TIMESTAMPTZ, '07436d2c080095c8b034e9dbf5f91ece823b2430407486883ccc9591c98669d8'::TEXT, ARRAY[994]::BIGINT[]),
    (251::BIGINT, 'El legítimo Mamerto, cree que es un genio y lo que hace es hacer el ridículo. No sabe la materia, se inventa las notas y no responde a las quejas de los estudiantes. No es imposible pasar, pero se va ha llevar un mal rato con lo obtuso del mae.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2021-01-27T00:00:00+00:00'::TIMESTAMPTZ, 'd9ecb44a56040cc40212578df9815e511580bcd809a6586bd2cbbda787915bbc'::TEXT, ARRAY[992]::BIGINT[]),
    (251::BIGINT, 'El profe no es una mala persona pero deja demasiado que desear, no maneja muy bien la materia, hace los examenes muy dificiles sin medirse el nivel ni el tiempo que da, ayuda a los que le caen bien, piensa que lo sabe todo a la hora de responder reclamos siempre intentara evitar subir punto'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2021-01-24T00:00:00+00:00'::TIMESTAMPTZ, 'f553d25f016b5c7cfc5148305047e289b74e5d60bbfdeafa3f3dd4bef6ecfc32'::TEXT, ARRAY[992]::BIGINT[]),
    (251::BIGINT, 'Es de los peores profesores de los que he tenido la desdicha de conocer, manejo de la materia nulo, califica duro sin fundamentos, terco, doble cara, aprende mas investigando uno solo que con el, piensa que es un genio y todo lo puede pero no! No se vayan con el timo de que es el facil jovenes'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-24T00:00:00+00:00'::TIMESTAMPTZ, '1b5d0bf3873af5f704f43d5597017cd71e57c7d5277dafb2cf7eaf37f5a81067'::TEXT, ARRAY[992, 994]::BIGINT[]),
    (251::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2020-11-09T00:00:00+00:00'::TIMESTAMPTZ, '4ecf86550d73f3bc101b6c91db7f3de488a8c9e3df96103f7dd3d4d0f1b75864'::TEXT, ARRAY[992]::BIGINT[]),
    (251::BIGINT, 'Muy simpático, se esfuerza por preparar una buena clase pero le falta dominio de la materia. No revisa bitácora.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2019-02-10T00:00:00+00:00'::TIMESTAMPTZ, 'cef16cdfadc89fd027830e00aff1113891a8e78696a50c72f893e5cdc3ea50d0'::TEXT, ARRAY[941]::BIGINT[]),
    (251::BIGINT, 'El curso requiere de mucho tiempo, pero el profe es accesible'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-26T00:00:00+00:00'::TIMESTAMPTZ, '08548fda040082876b1a67b37ba92948dd038cba3b97de428a19ff40cc047921'::TEXT, ARRAY[994]::BIGINT[]),
    (251::BIGINT, 'El curso por si solo es muy pesado, el profe lo sabe y lo hace accesible cuando es necesario. Lo recomiendo bastante para ese curso tan pesado'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2017-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'ed999606ad041361a85ef17af9efdf24ed167333c19330916642e3f46a9baf50'::TEXT, ARRAY[994]::BIGINT[]),
    (251::BIGINT, 'Buen profe'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-28T00:00:00+00:00'::TIMESTAMPTZ, '244f806e40dc370e5537f1e12c0d5d598e3cf85820db207088119070ff8279d4'::TEXT, ARRAY[941]::BIGINT[]),
    (251::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-26T00:00:00+00:00'::TIMESTAMPTZ, '528065b827b2fabe94d2f671c34519d8dbc6e3358fc9ff9e8805d227162d6ee4'::TEXT, ARRAY[941]::BIGINT[]),
    (251::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ, '27ab506ed96cbe8f17e3646bc8988c6eba1dd42d140e103baf28919eda66a0f2'::TEXT, ARRAY[996]::BIGINT[])
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
