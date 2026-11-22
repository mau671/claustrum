-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=824
-- TEC-DATA-META years=2019,2020,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.248120+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (824::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-08-15T00:00:00+00:00'::TIMESTAMPTZ, 'fda0429eb693d776ea494955e1424ad1d1dfbc3451ca6497cafd449e2e3e1693'::TEXT, ARRAY[539]::BIGINT[]),
    (824::BIGINT, 'En mi opinión es un excelente profesor, el semestre pasado asistí a inglés básico con él, sufro de ansiedad social diagnósticada, entonces me era difícil estar concentrada en una clase, pero el profe tiene una actitud bastante cómica y agradable, su clase realmente me gustó.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a9406e6b8cd76882f1ac7dcac346d8f5fb12cd7c54d78bae8739785264a7e3f7'::TEXT, ARRAY[539]::BIGINT[]),
    (824::BIGINT, 'Si usted es muy bueno en inglés, metalo de fijo. Las clases son bastante entretenidas y se aprende mucho (no se apega tanto a libros). En general, es muy buena nota, aunque en exámenes puede calificar un poco confuso.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico']::TEXT[], '2023-01-17T00:00:00+00:00'::TIMESTAMPTZ, '49f26c510407592aa309a8fcfdc52b13ebbf0a2fff0272e6c867f5c617f75e7c'::TEXT, ARRAY[625]::BIGINT[]),
    (824::BIGINT, 'Es buena nota, las clases son entretenidas, pero en algunos exámenes puede calificar un poco confuso. La verdad no es una mala opción, en especial si se tiene un buen nivel de inglés. Se aprende.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2022-11-12T00:00:00+00:00'::TIMESTAMPTZ, '44f1144605821f6b695df41a9365cca71487e27309bebb845275c19408530f66'::TEXT, ARRAY[625]::BIGINT[]),
    (824::BIGINT, 'Es bastante buena nota, pero para calificar es bastante duro. Muchas veces asume que todos sus estudiantes están en un mismo nivel cuando no es así'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Exámenes retadores']::TEXT[], '2022-11-03T00:00:00+00:00'::TIMESTAMPTZ, '4823c4a73c704dcb5450ff0715644738e72660f9d97a15e35e541ead6066dd38'::TEXT, ARRAY[625]::BIGINT[]),
    (824::BIGINT, 'Muy buen profe, es diferente a los demás, sus clases son bastante entretenidas, generalmente interactúa con todos los estudiantes,no es como otros profes que nada más le dan una hoja con ejercicios, él hace la clase muy interactiva y uno la pasa muy bien.En cuanto a las evaluaciones no son muy duras'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2022-10-18T00:00:00+00:00'::TIMESTAMPTZ, '60b61b933e97a9abd1fc7791dfdb67a3363760877a4c9c2c59fe83ec702fa170'::TEXT, ARRAY[545]::BIGINT[]),
    (824::BIGINT, 'Es buena gente, hasta que te revisa los exámenes. Muchas veces parece que hay estudiantes que saben más que él. Si el dice que algo está malo, ESTÁ MALO, aunque no sea así. Las clases se pasan relativamente rápido, sin embargo, sino te gusta trabajar bajo presión, mejor buscar otra opción.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2022-10-14T00:00:00+00:00'::TIMESTAMPTZ, 'f78ab920fc4bd9fc9cc47307b5a5687bac7bcf9e3e23a01cc3eecbde7434acc5'::TEXT, ARRAY[625]::BIGINT[]),
    (824::BIGINT, 'El profe es buena nota, pero califica confuso, deja guías semanales que son largas y aburridas. Los exámenes son largos y son calificados muy duro'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2022-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'bc332db3e38144ead8518803e528120b86933e52ca725b0fa46fe40febe68d74'::TEXT, ARRAY[545]::BIGINT[]),
    (824::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2022-01-26T00:00:00+00:00'::TIMESTAMPTZ, '247f6967bdf271eccd0bce9777f581e379520fbba156632c6bc5e9d56e9cedb1'::TEXT, ARRAY[545]::BIGINT[]),
    (824::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-29T00:00:00+00:00'::TIMESTAMPTZ, 'b257132bec35e07cb8eeb951ae3ca0ff044df4e3a5e6482cc3daf46b9da46ef8'::TEXT, ARRAY[625, 545, 2432, 2379, 547, 2433]::BIGINT[]),
    (824::BIGINT, 'Es un profesor de mucha calidad, hace ver la mayoría de cosas super sencillas, si pueden matricular haganlo y verán que se aprende mucho y se disfruta de la clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '689c299fdeb6c842112739541785e28aef242e286469572482e75af4806f85c4'::TEXT, ARRAY[625]::BIGINT[]),
    (824::BIGINT, 'El mejor profe, que tuve en el semestre. Súper buena nota.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, 'bc6d245cbff1695c0a83be1f5212aa31bd95d4b02cd1f5e546c76d05fb3fd082'::TEXT, ARRAY[625, 545, 2432, 2379, 547, 2433]::BIGINT[]),
    (824::BIGINT, 'Es un excelente profe, la forma en que imparte las clases de ingles son muy creativas e interactivas, explica super bien y de una manera clara y facil de comprender. Lo recomiendo 100%'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Brinda apoyo']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '50caa0de92b36297bafee9b8f211908b3e12f9423bf8fa522c1e7472a08a092d'::TEXT, ARRAY[625, 545, 2432, 2379, 547, 2433]::BIGINT[]),
    (824::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-24T00:00:00+00:00'::TIMESTAMPTZ, '8a256ae64567963ed0441195a8e960c036e85c70f7114cf66405ee0435bdaab7'::TEXT, ARRAY[539]::BIGINT[]),
    (824::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2019-08-08T00:00:00+00:00'::TIMESTAMPTZ, 'be2c9af3ede3091f586eb89b93f37717e73bc30db5ea931e3990256e0a945186'::TEXT, ARRAY[625]::BIGINT[])
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
