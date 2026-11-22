-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=369
-- TEC-DATA-META years=2015,2016,2018,2019,2020,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.898218+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (369::BIGINT, 'Las clases son muy aburridas, lee las presentaciones y no se entienden las explicaciones, no pasa lista, pero califica duro los exámenes.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '3878160f214d74994a04420a659da4a4ef2e5ac946cdc7b9e585aca90eb42142'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'No se le entiende en las clases y los ejercicios que hace ya están en la presentación, por lo que casi no se entiende. Los exámenes son un poco difíciles pero el proyecto casi que lo regala.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Exámenes retadores']::TEXT[], '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ, '368b111017c46d0e4210fd3f3cad5c38c4284dd3a9b64b29ff61eaf68c42dc0d'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'No es mal profe, pero no sabe explicar bien. Los ejercicios que resuelve en clase son muy sencillos comparados al examen. Busque exámenes viejos que le van a ayudar mucho. El proyecto te lo regala eso sí. No es un curso imposible en lo absoluto, pero si hay que ponerle bastante que sino no se sale.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '50bd77151859765f46983e3e3bb44f6521d9f72cfeb0849fb8c883c525daf681'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'Las clases son poco claras, hay que ser muy autodidacta o preguntarle al asistente (que de paso es el que califica todo). El proyecto es regalado. Exime, pero hay que ponerle en los dos primeros exámenes. Tenga cuidado de que no lo agarre entre ojos.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, '6cd7398fa7a88882daff419f9daf1b43f7b8e11a512410c03cd39c4325f4e5c8'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'El curso es rudo, de eso no hay quite, pero el profesor realmente es muy estandar. Ayuda si usted se lo pide, es accesible a negociar fechas y practicamente regala el 30% del proyecto. Eso si, el curso es un maraton todo el semestre con las tareas que son enormes. El profe es un vago eso sí jaja'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2024-01-09T00:00:00+00:00'::TIMESTAMPTZ, 'cd0cecfdbbb8650a89be656eaffe5c3931e908c2a8b0d5f7d30eaf628d57b7a9'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'Muy buen profesor, explica lo necesario y se aprende bastante. Se adaptó muy bien a la virtualidad haciendo las clases lo más rápido posible. Con exámenes viejos se pasa el curso.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-23T00:00:00+00:00'::TIMESTAMPTZ, 'b3fa503cc08cc06c0e335d846d1a91a61fd72c952a40792263e8d373c4ada1f6'::TEXT, ARRAY[1235]::BIGINT[]),
    (369::BIGINT, 'Explica muy bien, un poco aburrido, hay que ponerle bastante para pasar por ser un curso muy denso.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, 'a6d3f6046a14787268c0a6949e72a0e09be6f3862c840cdc00f2aaf56d3713da'::TEXT, ARRAY[1235]::BIGINT[]),
    (369::BIGINT, 'Si tiene buenas bases en Est. Concreto se pasa facil'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2019-12-03T00:00:00+00:00'::TIMESTAMPTZ, '3a29bb43a17d7fff8acb2ffdd423916d6f052a8fea1dd674bfc36ff30ee9e591'::TEXT, ARRAY[1235]::BIGINT[]),
    (369::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Exámenes retadores']::TEXT[], '2019-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'aa3e2819ab26ce4c8c554652ab9306ed4ef7fb35e9289b23f9faeb4d5a1b67fb'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2019-11-12T00:00:00+00:00'::TIMESTAMPTZ, '9776349d1d3cfad0ddbdd9094d558275e79ddb64d3567c82145d8a579f4807e6'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'Es muy perezoso, da solo un ejemplo de cada tema y no le gusta aclarar dudas. PD: Me quiso robar mi novio. PD de la PD: Lleven Código Sísimico ratas.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-29T00:00:00+00:00'::TIMESTAMPTZ, '29c597825bd675852ab6d269c09bc046fcdeea546a3597c08c412611c6a0fd9c'::TEXT, ARRAY[1235]::BIGINT[]),
    (369::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-28T00:00:00+00:00'::TIMESTAMPTZ, '4856ad4e04919c74703d5ca8116a3eff82a04dfc2d38ec2ca19770161489379e'::TEXT, ARRAY[3015]::BIGINT[]),
    (369::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2018-06-10T00:00:00+00:00'::TIMESTAMPTZ, '6aff80f3ce161c704177d1bcfbe877b180024ee518c6f2aab30fb200462444a9'::TEXT, ARRAY[1234, 1239, 2122]::BIGINT[]),
    (369::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2018-01-30T00:00:00+00:00'::TIMESTAMPTZ, '8217d21e8c666f3d40088b1cc20d9adec42da32946c2ab234de053ab83f6b3fd'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'La materia que da la tiene de toda la vida sólo llega a copiar la materia en clases y la da muy fácil pero en el examen es otra cosa...'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'b55e21f4522843c22494d0ce88834141298259d1204ea69d0b98c32dd5b3d6cc'::TEXT, ARRAY[1214]::BIGINT[]),
    (369::BIGINT, 'Solo transcribe los apuntes de semestres anteriores, califica muy fuerte y las clases son demasiado aburridas ( no hay quite si recomendar o no , solo el la los cursos )'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('20','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'b86693f44a45a928bf94584489b44b4c511da6b97f9d777b01caf7a0b239f8a6'::TEXT, ARRAY[1214, 1235]::BIGINT[]),
    (369::BIGINT, 'Califica al bateo, muy rudo.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-12T00:00:00+00:00'::TIMESTAMPTZ, 'd83de6acf4748fa8b78da1790bb1d93ffb887cc6eb1926c94aa2dd7c97fbf37b'::TEXT, ARRAY[1214, 1235]::BIGINT[])
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
