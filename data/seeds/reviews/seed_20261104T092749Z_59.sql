-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=59
-- TEC-DATA-META years=2014,2015,2016,2017,2018,2020,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.826312+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (59::BIGINT, 'Buen profe, sabe mucho y se nota todo un profesional. Hay que leer MUCHO-MUCHO, pero son normas y estándares entonces es importante porque no se puede escapar de ellas. Me encantó su clase.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Muchos proyectos grupales']::TEXT[], '2025-12-13T00:00:00+00:00'::TIMESTAMPTZ, '3a925752d7f42efa348090f86bcf3c91e0d6eacf7c561e86e5107de2700f6bb5'::TEXT, ARRAY[2414]::BIGINT[]),
    (59::BIGINT, 'El profe como tal puede que lo intimide porque es algo estricto pero si usted participa en clases el curso es muy ameno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2025-07-09T00:00:00+00:00'::TIMESTAMPTZ, '7cf16df5eaf90a6c8482f79a4fee5a4adf4aba34889714f699f1355548787ffa'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'El profesor es estricto, pero justo, si va a matricular con el le recomiendo que juegue limpio, porque ese señor siempre buscará beneficiarlo a usted como estudiante, con el es fácil pasar, pero siempre le tocará hacer trabajos y participar importa demasiado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2024-12-21T00:00:00+00:00'::TIMESTAMPTZ, '33644c195cbbf5b6c876da1573b8859647683a357d599936e48dfdc3669138d0'::TEXT, ARRAY[2414]::BIGINT[]),
    (59::BIGINT, 'Las clases son aburridas y a veces no se entiende muy bien lo que explica pero si uno hace las prácticas aprende un poco más'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Brinda apoyo']::TEXT[], '2024-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'e051255ef7efa436bdcc34c471bb8d0da9822961d9124970780f7a1b56170a7b'::TEXT, ARRAY[2403]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-06-25T00:00:00+00:00'::TIMESTAMPTZ, '261bc69ebd916b8dd7432cfb3ee4555e2bf1c1f6b8aaa633c39492faed9e2eaa'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'En general es un buen profe y algo que rescato mucho es que es sumamente puntual y sus clases son muy cortas. Sin embargo, hay ocasiones en las que en los exámenes mete los temas de forma distinta a como se vieron en la clase por lo que llega a generar cierta confusión.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '7dfdbbb03dc1fb556a8121cd86d43313770d65db7d76a5e45d83f5ab37cf0df9'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'Es un buen profe. Los exámenes son sencillos y los trabajos también. El proyecto grupal es fácil si tiene un buen grupo.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, '3811d62f499a7035880ac83433318e589d19f898b0c19212b20a5bf81415509d'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'Excelente profesor, le recomiendo hacer fichas de fórmulas de lo que se va viendo, sin duda matricule con él!'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2023-01-28T00:00:00+00:00'::TIMESTAMPTZ, '4abfb832b728d0f7b539425e265927026d1126ef981f3d0b90b5d1b1fd7c986c'::TEXT, ARRAY[2403]::BIGINT[]),
    (59::BIGINT, 'Las clases virtuales son cortas, los exámenes son relativamente fáciles. El profe es súper accesible.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, '21e5e476285570a9b3de52fe95b834ee303d99fe3f305baedb12c8156d58681c'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'Virtual. El profesor es respetuoso y amable. Los exámenes son muy fáciles y las tareas también. El proyecto es resumir un libro entonces es sencillo. Las clases duran poco pero explica bien. Con él es muy ligero el curso pero se aprende. Me parece un buen profesor y la clase se disfruta. 100%'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-12-21T00:00:00+00:00'::TIMESTAMPTZ, '5623ba58e37e2b2da526910f7c6f8b46c9779cfcb3de5183e3353ee9377ba00e'::TEXT, ARRAY[2403]::BIGINT[]),
    (59::BIGINT, 'Me parece un muy buen profe, no explica super bien pero se entiende, los exámenes son muy fáciles, uno puede hacer su propio formato de fórmulas en Excel.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2020-08-06T00:00:00+00:00'::TIMESTAMPTZ, '8ab3fe631711715cc4db0c4aec87338262f5e8ea242c1eb3aa80a51c053d6b76'::TEXT, ARRAY[2403]::BIGINT[]),
    (59::BIGINT, 'Deja muchas tareas, pide resumenes de capitulos, examenes iguales a los de años anteriores con otros numeros.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2018-04-13T00:00:00+00:00'::TIMESTAMPTZ, 'c192e5ba25dc9d1df15d997e323d9c769ac99ee27f5eccd36b3a4a226ae7505a'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-12-06T00:00:00+00:00'::TIMESTAMPTZ, '2f0f812beade20eab8851c0714948729f1bb6e19a414d3424e18576c232485fc'::TEXT, ARRAY[1708]::BIGINT[]),
    (59::BIGINT, 'Muy buen profesor, la única deficiencia significativa, es que va a un ritmo muy rápido y uno se queda atrás.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2016-10-29T00:00:00+00:00'::TIMESTAMPTZ, '50e486711f60d711d7b600255a6a9af628f0d16a9cf719d696c69645a9add681'::TEXT, ARRAY[1782]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'a671b7fccf62add5b6bd3a082881ad3cd31f962809c512e84f832d117a36d486'::TEXT, ARRAY[2414]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Da crédito extra']::TEXT[], '2016-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'b2376d33a5d6bc6754a92360b31ec9e62dabb211817d8f24849239f1982ec1b6'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases excelentes']::TEXT[], '2016-04-28T00:00:00+00:00'::TIMESTAMPTZ, 'e4bf6734870fdb61d61dfbb424810eee0bf6977884df3761d049f99c193fbae8'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-30T00:00:00+00:00'::TIMESTAMPTZ, '8212ad008b7552057ba2bc6485bec69ba88f345d6806e9e4818ed8123d750ca6'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Hay que aprender a entenderlo y esforzarse haciendo la práctica'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-23T00:00:00+00:00'::TIMESTAMPTZ, 'a661d7c9610d188dbdd3b52ae37742022b69268119c3d3711192cdbee01fe61a'::TEXT, ARRAY[1527, 1530, 1531, 223]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-10-10T00:00:00+00:00'::TIMESTAMPTZ, '85fdc1323b045250ed86368d6b88539216e6e7680c2b38ccc97a8e7c39a76d59'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Da por hecho que usted ya sabe la materia, y sus bases de conta son malas se tiene que esforzar al doble, examenes muy dificiles, pero muy buen profe, explica bien'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-09T00:00:00+00:00'::TIMESTAMPTZ, '115525864396f3da8d0d3e6f2f9e637a9027a59499678424d2272fa8dd1733ab'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'f7f2857217c1bafcd5c485aa60ec2d11fb20235ff2d100f4f7fadb08afbe47fd'::TEXT, ARRAY[1527, 223]::BIGINT[]),
    (59::BIGINT, 'Excelente profesor. Se entiende bastante bien la materia.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-07T00:00:00+00:00'::TIMESTAMPTZ, 'a7f639be30ba0bfb64b73a6cbd4c9e320dec1295c4d3ee51d6b71844584cf3f5'::TEXT, ARRAY[1527, 1530, 1531, 223]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, '56a2061f1bf88a8607a6f729f14120459467c629bdd5d1785da23b6aca48c179'::TEXT, ARRAY[3575]::BIGINT[]),
    (59::BIGINT, 'Buen profe, clases pueden tornar un poco tediosas. Deja tareas todas las semanas,pero eso ayuda a estudiar para los exámenes.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, '257521c1a23f3426c4910644a4b28b1b282dc9b21573b5c5417de55ce8bb89f3'::TEXT, ARRAY[3575]::BIGINT[]),
    (59::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, '6dbbd148f9dd4d44363231b28574cbb66c1a573c0edb5baa031dad78f35e787c'::TEXT, ARRAY[1527, 223]::BIGINT[])
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
