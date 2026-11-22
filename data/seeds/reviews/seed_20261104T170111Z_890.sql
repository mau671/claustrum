-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=890
-- TEC-DATA-META years=2017,2018,2019,2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.034575+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (890::BIGINT, 'La profe es muy buena gente y se preocupa por los estudiantes, pero es muy desorganizada. Las instrucciones de las asignaciones son muy enredadas y no es buena respondiendo dudas. Uno aprende bastante y ella hace que uno se enamore de la carrera, en general es buena.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-07-10T00:00:00+00:00'::TIMESTAMPTZ, '757cc18276be3c0aabd9cc66990b7484f73ddd2aaddbb7a36ad7bd8ca945a581'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'La profe es muy desorganizada y no se le entiende nada en las indicaciones con los exámenes y trabajo grupales. Sin embargo, es una buena profesora y da muchas retroalimentaciones.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Inspirador']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '9af5849c24212d6d4c764b4afcc16e6a93073e745329bd866e9d4822f1f78e73'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'La profe es super dulce ,se preocupa por uno ,es super antenta, lo motiva a uno a continuar en la carrera ,se preocupa porque uno este bien ,explica de manera clara y se aprende bastante y al final del curso uno termina con gran estima y admiración por ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-30T00:00:00+00:00'::TIMESTAMPTZ, 'f4b170d5a04c146a674779dac3505560d6b6574c0e36e70e5c2fae3da6592241'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'La quiero mucho'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-07-28T00:00:00+00:00'::TIMESTAMPTZ, '459b3923830e7a417de6442ea8a00e1edc0ccf8da72834e8228ab657c66a1569'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Muy atenta y siempre brinda apoyo en clases, no se molesta en devolverse y explicar algo que ya haya visto Califica muy fácil y siempre ayuda al estudiante con puntos extras por participar. Solo se requiere ver las clases y aprenderse las presentaciones para pasar, hace exámenes y quices grupales'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'dc8004fa7ca6e683a71297902deed2abe09dfb134e2283b60f26681e1897bae1'::TEXT, ARRAY[155]::BIGINT[]),
    (890::BIGINT, 'Excelente profe siempre está de buen humor y es super amable, te motiva mucho a continuar en la carrera, lleva invitados que lo ayudan a tener un panorama más amplio de las áreas en las que se puede desempeñar como ingeniero, de verdad se aprende mucho'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2020-09-08T00:00:00+00:00'::TIMESTAMPTZ, 'f3ad7c826d4b45d0b35cdf661bf00dacf5848cfea595be22c876339636070647'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Muy buena profesora, da ejemplos excelentes. Lleva a invitados los cuales transmiten buenas enseñanzas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '8296e839146ee4f2565c70b6cabe8906a7c55e6a67588d62fa2f97db9deefb41'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Si tiene la oportunidad de matricular con ella, full recomendada ¿qué espera?. Da ejemplos que uno se va a encontrar en el campo laboral, lleva invitados especialistas a las clases para así mostrar un poco más de los campos de la carrera. Siempre va a estar de buen ánimo, es un amor de persona.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2020-08-21T00:00:00+00:00'::TIMESTAMPTZ, '8cbc705ae16e34d95019608ed136dcbd3be6e4306cd282e10d0139a558c490f6'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Es una excelente profesional. La recomiendo profundamente si alguna vez tienen la oportunidad de llevar una clase con ella. Su actitud siempre de respeto y a abierta a ampliar. Sus clases excelentes y siempre tiene invitados sumamente prestigiosos,'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-07-31T00:00:00+00:00'::TIMESTAMPTZ, '84562b6aba4c8a3d8a67025845dbd91eafd21376a57aff26201f748ee8b16ca2'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-06-17T00:00:00+00:00'::TIMESTAMPTZ, '0a615f4d56fb2a920087e243f6879de204254c09e881c4f07d4bbbfaf363ec8f'::TEXT, ARRAY[3087]::BIGINT[]),
    (890::BIGINT, 'Ella es excelente como persona y como profesora, sabe transmitir el conocimiento a los estudiantes y debido a su experiencia en el campo laboral, brinda ejemplos de situaciones reales que uno se encontrará en las empresas. Usa metodologías dinámicas que permiten comprender mejor la materia.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2018-06-29T00:00:00+00:00'::TIMESTAMPTZ, '8244761a9fc40155b84b66f432197ac5325193bf2fea70480ff88d501d0e93b6'::TEXT, ARRAY[1490]::BIGINT[]),
    (890::BIGINT, 'Ella es demasiado buena gente, súper ayuda y hace las clases y tareas muy dinámicas. Es una excelente profe, la súper recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2017-09-24T00:00:00+00:00'::TIMESTAMPTZ, '5964b00b8e602f1ad518e90731762b52ac3984a34e4f845f2afa423a362bfd7e'::TEXT, ARRAY[1001]::BIGINT[])
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
