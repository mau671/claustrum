-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=385
-- TEC-DATA-META years=2018,2020
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.907338+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (385::BIGINT, 'Muchas paciencia, respetuoso y da el curso muy practico.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2020-06-02T00:00:00+00:00'::TIMESTAMPTZ, '8d8d3cf8afab89e0d9b1ae6d8e908bff6e65a184872a42aaa1ec8dbc14bcf8e7'::TEXT, ARRAY[3029]::BIGINT[]),
    (385::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes']::TEXT[], '2020-02-03T00:00:00+00:00'::TIMESTAMPTZ, '80c4386b007eabe61b4b34453c68f3bccac9fe183d589d3efc94e564c6e5845e'::TEXT, ARRAY[1304]::BIGINT[]),
    (385::BIGINT, 'Es un buen profe la verdad.poyo. Siempre busca como ayudar. Deja muchas tareas, se preocupa por prepara bien para los examenes y expicar las aplicaciones de los temas, hace siempre repaso antes de las evaluaciones.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Da crédito extra']::TEXT[], '2018-11-09T00:00:00+00:00'::TIMESTAMPTZ, 'a4ed9c910c03aed6545fc96be9b4574fdae2128af6b1728f66cc1e58a8266ff2'::TEXT, ARRAY[1304]::BIGINT[]),
    (385::BIGINT, 'Es un profesor que le gusta enseñar y que uno aprenda. Tiene mucha calle, experiencia en la industria, siempre amarra lo teórico conceputal con aplicaciones. Además es como filosofo en muchos temas, que lo deja pensando. Hay que ir a consulta y hacer los ejercicios aunque diga que es opcional!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-09-19T00:00:00+00:00'::TIMESTAMPTZ, 'e603673fae10898bd35c099d5d2cf5fc6a0eaa88ade79471d1512690159ffa34'::TEXT, ARRAY[3059]::BIGINT[]),
    (385::BIGINT, 'Profe tuanis. Las consultas son como espacio para hacer ejercicios y asi.. como tutoria. Hay que ir y pasa sobrado. Usa mucho pizarra. Si le pida ayuda de seguro se la dara. El mae es un crack en cosas practicas de laboratorio y varas de programación!'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2018-07-19T00:00:00+00:00'::TIMESTAMPTZ, 'a3685461cb5492434a60aead295eddee5e2397647bdb6e48db6081dc03915179'::TEXT, ARRAY[3059]::BIGINT[]),
    (385::BIGINT, 'Deja siempre practica para examen. Es bueno explicando la parte matematica de la teoria. Ayuda con informacion para los Labs. Es muy respetuoso, escucha y brinda ayuda siempre.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'adf9929f7501dc6e6a8b7bca4fe3edcdab0c42419a0be15780bb9bd652565448'::TEXT, ARRAY[1338, 1389, 3029]::BIGINT[]),
    (385::BIGINT, 'Buen profesor: ayuda, explica, y es respetuoso. Importante ir a consulta, son una especie de tutorias donde resuelve problemas y hace ejercicios. Los quices son rudos si uno pide reposición. Pero hace el curso sencillo!'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Clases excelentes']::TEXT[], '2018-07-03T00:00:00+00:00'::TIMESTAMPTZ, 'e2e06a07904a530472f65409251628b1029fc4312c797dedc05268fef8dca2f3'::TEXT, ARRAY[3059]::BIGINT[]),
    (385::BIGINT, 'Explica siempre en que se puede usar la teoria. No utiliza mucho presentaciones. Siempre hace práctica antes del examen y es mejor hacerla aunque diga que es opcional. Hace muchos quices, y también hace curva. Es la primera vez que daba el curso.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-07-02T00:00:00+00:00'::TIMESTAMPTZ, '7df1e8467c0a5b773ec686c277efdf6e8b5c7a5f9e073a242444c4df881349fb'::TEXT, ARRAY[3059]::BIGINT[]),
    (385::BIGINT, 'Super pasable con él. De aprenderse, no mucho. Pero es fácil y él ayuda en TODO. Es muy buena gente, aunque para aprender potencia no es la mejor opción. Pero sí hace un curso fácil. Aburrido la mayor parte del tiempo y no es muy claro, pero con consulta y un poco de estudio pasa sobrado.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'e6d001fde6174a746c2da0a14802ab197f057f7be216773a8744882435a70841'::TEXT, ARRAY[3029]::BIGINT[])
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
