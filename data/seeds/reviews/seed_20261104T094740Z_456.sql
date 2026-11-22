-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=456
-- TEC-DATA-META years=2016,2017,2018,2020,2021,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:47:40.750091+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (456::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, '5f71292527e6ec6a905ad6a7b851871a53f82b840511e7c69272eb8891d3b574'::TEXT, ARRAY[1749]::BIGINT[]),
    (456::BIGINT, 'Explica bien, ayuda con la aclaración de dudas, da tiempo para que nadie se atrase en la clase y es flexible con los tiempos de entrega de las evaluaciones del curso.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Brinda apoyo']::TEXT[], '2025-02-07T00:00:00+00:00'::TIMESTAMPTZ, 'bf144e5d8ac914e7efd6875032c428510d9bbad189e6c5f69eede63cea8de12c'::TEXT, ARRAY[1788]::BIGINT[]),
    (456::BIGINT, 'El profe es buena nota, el curso es un toque aburrido'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-01T00:00:00+00:00'::TIMESTAMPTZ, 'ef5c5f34db0bb9adbdd3afe6050ed2f3280e25c49ca92e43aa429f10773747bc'::TEXT, ARRAY[1776]::BIGINT[]),
    (456::BIGINT, 'El profe es muy pura vida, tiene mucha calle por lo cual, brinda ejemplos reales de situaciones que uno podría enfrentar el día de mañana. El curso es sencillo, las tareas aveces son recicladas (de semestres anteriores), el examen y proyecto final es en grupo. Califica suave.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-07-11T00:00:00+00:00'::TIMESTAMPTZ, '71b19c2d0183f8ccd8f5b4183e4595626e381cd5e48ffd55954f834a41acf04d'::TEXT, ARRAY[1776]::BIGINT[]),
    (456::BIGINT, 'El profe es super flexible con la fecha de las evaluaciones y da la clase de forma muy amena. A veces es muy teórico por lo que es un toque aburrido pero aprendes a usar aplicaciones como Project y Adonis (por cuenta de uno, eso sí). El curso se pasa fácil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-05-24T00:00:00+00:00'::TIMESTAMPTZ, '71ed574b30fad04ba56ff2163cd4776136d7fbcd92b5a0bbedd85b1582db4d0c'::TEXT, ARRAY[1776]::BIGINT[]),
    (456::BIGINT, 'Hasta el momento es un completo incompetente. Gasta 3 horas mostrando a donde puede uno acceder a la clase asincrónica que ya tiene grabada desde el semestre pasado. No sabe mucho de lo que habla. Solo habla del proyecto final, no da materia. De los más aburridos profes que hay.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2021-09-02T00:00:00+00:00'::TIMESTAMPTZ, 'a4d03acd449bb27e0dfd4dde7ad3a8f33c2057497eae757a1d1f765109fff387'::TEXT, ARRAY[1776]::BIGINT[]),
    (456::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-24T00:00:00+00:00'::TIMESTAMPTZ, '978abc37b00ba447f69ffef3faefb8c0434b58d58a8259ea0b9ee2c182d0ae56'::TEXT, ARRAY[1795, 4246, 1790]::BIGINT[]),
    (456::BIGINT, 'Muy fácil, solo que las clases siempre pasaba durmiendo, no se le saca mucho y son muy pero muy aburridas, como clase magistral'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, 'f8d6a2cb0ca464688f05210c205ca3a3167df45355015fcd512fa75c33b23fe9'::TEXT, ARRAY[1777]::BIGINT[]),
    (456::BIGINT, 'El cuuuurso es muy fácil por lo cual lo va a pasar, pero el mae por ejemplo no nos dio lo que había que hacer en el proyecto desde un inicio porque "lo terminábamos muy rápido", mae que putas , esa es la idea. Suuuuuper aburridas las clases'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-12-20T00:00:00+00:00'::TIMESTAMPTZ, 'bef3cc3b84bd6be7c66202137dcfa0913baa47f6dc5602943f5dc7858d04579b'::TEXT, ARRAY[1777]::BIGINT[]),
    (456::BIGINT, 'Creo habla mucho y no sabe de que habla. Un completo vago'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-04-20T00:00:00+00:00'::TIMESTAMPTZ, '5dd67329d17f18cd5ec2f5107a3a14d1cf11d538312e698e81ed4d617f7935dc'::TEXT, ARRAY[1788]::BIGINT[]),
    (456::BIGINT, 'Nos puso a trabajar en grupo, las clases casi nunca fueron aburridas-'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-01-24T00:00:00+00:00'::TIMESTAMPTZ, '91a18d6d21ba1eec767ee3e928265fbe606ad46ae9c8bfc0a45c06d5d862fa4b'::TEXT, ARRAY[1777]::BIGINT[]),
    (456::BIGINT, 'Es raro, el cree que sabe pero me da la impresion no tiene idea de que habla. No lo recomiendo para nada.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-01T00:00:00+00:00'::TIMESTAMPTZ, '5c88ccf077ed5054d7a7ca40a8b7029bd24c90d1f376a14fb9fd740de85ec629'::TEXT, ARRAY[1788]::BIGINT[]),
    (456::BIGINT, 'Vago vago vago, aparte de aburridisimo pasa el curso con buena nota pero no aprende nada, es como no haberlo llevado'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-11T00:00:00+00:00'::TIMESTAMPTZ, '525c4663b9265322bdbf1d6668a197b042665d292284c6eaa9e5fff7e8b5e497'::TEXT, ARRAY[1738]::BIGINT[]),
    (456::BIGINT, 'Es super aburrido más que el curso es muy teórico, es muy vago hay que estar encima de él, ya que casi no explica nada. Califica normal, el curso es regalado con él.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'ba15d16f2e3aefb6d809ad6edc93dc2c6faf25812870cfd5e3060fc6d293123e'::TEXT, ARRAY[1738]::BIGINT[]),
    (456::BIGINT, 'Aburridísimo'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-09-08T00:00:00+00:00'::TIMESTAMPTZ, '6b5404543b05af4a3e1e8f7a045555b8cc962f32cc9eaf216d699309c23c6c03'::TEXT, ARRAY[1738]::BIGINT[])
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
