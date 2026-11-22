-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=328
-- TEC-DATA-META years=2016,2018,2020,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.136307+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (328::BIGINT, 'Un muy buen profesor, que da su materia de una forma clara a pesar de haber sido la primera vez dandola; da a entender muy bien los conceptos que se tienen que llevar en el curso y se preocupa bastante para que sus estudiantes pasen entendiendo los temas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-04T00:00:00+00:00'::TIMESTAMPTZ, 'f0c3d97f04e3b7be0fd2fe841dba9fd4a67b971b96e5d1de81a40e0fe3583e6c'::TEXT, ARRAY[1253]::BIGINT[]),
    (328::BIGINT, 'Muy buen profe, hace que el curso sea 100% pasable, las clases son cortar y solo usa una para teoría, la otra es práctica (semanal). Se aprende bastante si le pones ganas. Es un 10 como profe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-13T00:00:00+00:00'::TIMESTAMPTZ, '4c15a48ac1746a71c2186df94d895608b5cb98654a89ca9b308680519e935a62'::TEXT, ARRAY[1249]::BIGINT[]),
    (328::BIGINT, 'Las clases son aburridas porque usa presentaciones algo viejas, pero las clases son cortas. Deja como 10 quizzes que son fáciles, de hecho, solo el primer proyecto es difícil pues si hay que dedicarle tiempo, por lo demás es un curso que se pasa fácil. Si se pone atención sí se aprende.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'a5782b0f4ddc6292e1cbea016196367b09de95935b7bb539221edea49845af74'::TEXT, ARRAY[1163]::BIGINT[]),
    (328::BIGINT, 'Explica bastante bien, su clase es MUY aburrida y habla muy lento pero suele terminar la clase antes y sus trabajos son realmente sencillos. Siempre responde dudas (solo traten de que no sea el mismo día de la entrega). No es asistencia obligatoria, yo me veía las grabaciones más rápidas y listo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'e26e2e3a1662432e2919bd99f9dd3090e7b1a4d17f594733c2bb75dee19b4c21'::TEXT, ARRAY[1017]::BIGINT[]),
    (328::BIGINT, 'Sus clases son un poco aburridas pero suele terminar antes. Los trabajos son relacionados a las clases. Los proyectos son de investigación por lo que tendrá que leer un poco más acerca del tema para lograrlo pero no suelen tomar mucho tiempo. Muy claro con las rúbricas y se ve que sabe mucho.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Aspectos de calificación claros']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '34c2bef8a794d44d53a3a11ed8e49b094a4276c7532e2d4d8d482ed05e577210'::TEXT, ARRAY[1017]::BIGINT[]),
    (328::BIGINT, 'El profesor se acomodo un poco mejor que otros a la virtualidad, es algo confuso y repetitivo en las clases sincronicas y los trabajos de las clases asincronicas son algo complicadas, así que los mejor seria que seas alguien autodidacta, pero si tienes una duda el siempre esta para resolverla'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2020-09-01T00:00:00+00:00'::TIMESTAMPTZ, 'bf7e77f1b5f383d0a6ec6c062e93bb0cb2cd10a05a0625b7c4f657d560bb65ef'::TEXT, ARRAY[1249]::BIGINT[]),
    (328::BIGINT, 'Explica muy bien, puede ser un poco lento al hablar, pero esto más bien es una ventaja. Es muy comprensible con los plazos de entrega. Sus trabajos pueden ser algo difíciles pero vale la pena hacerlos .'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-08T00:00:00+00:00'::TIMESTAMPTZ, 'e6ad3253208104c13e6a38be5133b8155faf975beac11f67ca064a725103c747'::TEXT, ARRAY[1249]::BIGINT[]),
    (328::BIGINT, 'Excelente profesor, totalmente recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2020-07-02T00:00:00+00:00'::TIMESTAMPTZ, '1427384fbf2c779d499971fa02b0dc24c8f91d3e8f1887c552bcdf4e1e58c72d'::TEXT, ARRAY[1249]::BIGINT[]),
    (328::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-06-30T00:00:00+00:00'::TIMESTAMPTZ, '21ae3dc308bd2da87195824c41fdc8b068e2f6430638ffaf8ad6b2d8782f46ab'::TEXT, ARRAY[1249]::BIGINT[]),
    (328::BIGINT, 'Un poco aburrido'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2018-06-05T00:00:00+00:00'::TIMESTAMPTZ, 'eb6c46ba318c1337082bd943988d3593b224f56162737b7b4e2c91992ea74f31'::TEXT, ARRAY[1017]::BIGINT[]),
    (328::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-05T00:00:00+00:00'::TIMESTAMPTZ, '11a508866c300516ad707d5a2443a57c6bd14c2fc3733c405d94e37a6c5cad60'::TEXT, ARRAY[1017]::BIGINT[]),
    (328::BIGINT, 'Un excelente profe, super recomendado n.n'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ad43f1d4169b9841fb2faf5e8d553d3cdb20a4b09bc9647cec84005fd6673912'::TEXT, ARRAY[1020, 1022]::BIGINT[]),
    (328::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-01T00:00:00+00:00'::TIMESTAMPTZ, '680a3ffdb52049819753835148ab45c5352e84045694476a020720908f441d6e'::TEXT, ARRAY[1021]::BIGINT[])
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
