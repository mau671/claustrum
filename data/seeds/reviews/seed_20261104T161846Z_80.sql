-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=80
-- TEC-DATA-META years=2021,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.756907+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (80::BIGINT, 'Lleven el lab tambien con la profe, es buena profesora y explica bastante bien, pero si es un poco sarcastica y burlista, pero no irrespetuosa.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'bdfd0acc42900d652d663bc73701066f07628a7bc81137d411caa0009ecebf7c'::TEXT, ARRAY[3161]::BIGINT[]),
    (80::BIGINT, 'Como profesora no es mala, pero como persona es muy desagradable, hacerle consultas no tiene sentido ya que ella siempre tiene la razón, en el mejor de los casos no va a responder, lo cuál es mejor a una humillación'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '6162909650ec85eec0e2ce6f01f0287e62fcbeb3799cc9bf916ab39e769d0765'::TEXT, ARRAY[1446]::BIGINT[]),
    (80::BIGINT, 'Califica durillo, recomiendo ir a horas de consultas (para que le corrija cosas de los trabajos porque los califica duro) y no dejar los trabajos para último momento. Tenga en cuenta algún grupo de trabajo bueno porque casi que todos los trabajos son grupales. Para el examen dejó llevar un resumen'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'cf129d5a33df8b1154b8f8187888734f4f525116d78d28a4855e6731f6bfb684'::TEXT, ARRAY[3162]::BIGINT[]),
    (80::BIGINT, 'Bastante desagradable, su buena actitud dura unas pocas semanas y ya después las clases son eternas, hace malas caras cuando compañeros preguntan, es sarcástica, y prácticamente hay que estar detrás de ella para consulta, porque no responde correos, solo de forma presencial.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2024-06-08T00:00:00+00:00'::TIMESTAMPTZ, '78ea9ccf5bfa103d44797aada26ec600f05e3e07f1c38aac912838e1fe21ce2b'::TEXT, ARRAY[3162]::BIGINT[]),
    (80::BIGINT, 'Es una profesora demasiado incomoda, si se la pueden saltar háganlo. Super irrespetuosa y solo malas caras. Su ¨"método de enseñanza" es humillar y llamarlo a uno estúpido si no sabe nada'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2024-06-01T00:00:00+00:00'::TIMESTAMPTZ, '9ca7071d7558bb35dae47dc64fda33401de7fb289ea7770c020535884bb8eaea'::TEXT, ARRAY[3161]::BIGINT[]),
    (80::BIGINT, 'Es una persona desagradable, falta al respeto a los estudiantes con su cero ganas de enseñar, incluso con gritos y siempre tiene mala cara. No la recomiendo, es pésima profesora y no le apasiona lo que hace, ella no debería de dar clases.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-04-10T00:00:00+00:00'::TIMESTAMPTZ, '5e242ff0cd09692370e44c28bdcecd10694a15ff1509511268aae6dbc8475d83'::TEXT, ARRAY[3161, 3163]::BIGINT[]),
    (80::BIGINT, 'Hay que ir constantemente a consulta para que te evalue de manera decente ya que hay que hacer justo lo que pide y en clases no explica bien las istruciones, preparese de paciencia por que sus consultas son con caras, cometarios y tonos algo despectivos, asista siempre por que pasa lista silenciosa'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2024-01-26T00:00:00+00:00'::TIMESTAMPTZ, '733ea950ba14afb9cd844fbe437f0ea6c86bace2577a327419dee8b923460128'::TEXT, ARRAY[3162]::BIGINT[]),
    (80::BIGINT, 'Una profesora aburrida que solo sabe poner mala cara'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'La participación importa']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'd46040303c2bf9a87e9622f23a0e5c22b054881b9a1a378a9208d6d4741fb87d'::TEXT, ARRAY[3161, 3163]::BIGINT[]),
    (80::BIGINT, 'Es mala enseñando y siempre anda con mala cara, si es posible mejor evitar sus cursos'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'Asistencia obligatoria']::TEXT[], '2023-05-27T00:00:00+00:00'::TIMESTAMPTZ, '39b568d7aaa9fdffabb370241052c519f10c99b89f1d5eb92c9501e8f79bd4b3'::TEXT, ARRAY[3161, 3163]::BIGINT[]),
    (80::BIGINT, 'Es una fracasada en biotecnologia, que al ser tan mala profesora fue relegada a dar cursos simples como laboratorio de biología, en el cual tampoco funciona.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2023-05-01T00:00:00+00:00'::TIMESTAMPTZ, '40f54b157b98d68ae713a35f0916ba687ab9e0ceaed862482f30d5ea76a4c6a8'::TEXT, ARRAY[3161, 3163]::BIGINT[]),
    (80::BIGINT, 'El curso no es difícil y la manera de explicar los temas es regular, sin embargo tiene muy mal carácter, siempre parece enojada, y no es muy buena aclarando dudas y las instrucciones de los trabajos son un poco confusas.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '787cfdb5ddc1cc59716bc3a10a20175d3c42db0c295619a39700829b00990561'::TEXT, ARRAY[1979, 3160]::BIGINT[])
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
