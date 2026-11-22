-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=299
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2020,2021,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.126159+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (299::BIGINT, 'Pasar es fácil, brinda buen material y tiene mucha experiencia en el área así que aprender depende del interés de uno. Es muy teórico así que es tedioso pero las clases siempre terminan antes. ¿Algo negativo? Instrucciones no tan claras, pero si le preguntas al profe él te explica. Full t. grupales.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Requiere mucha lectura']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '35f7f04691bb57ce2a399db8f9dbafb80f332a6c0611742d107dd441d9b04f8a'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'El curso requiere mucho esfuerzo personal porque las clases son muy teóricas. Lo único malo del profe es que las instrucciones de los trabajos nunca son claras, siempre tienes que adivinar qué quiere que uno entregue. Se pasa fácil pero hay que dedicar mucho tiempo de trabajo'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-04T00:00:00+00:00'::TIMESTAMPTZ, 'cf7725b76019301a98d5e9438133dd9c91be49ad0f8b460ea4f85221270fba1b'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Curso muy teórico, pero se aprende bastante si presta atención. Pasar es fácil si hace todas las entregas bien.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2025-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'e80d4a7b98ab37dc7a38057b597b98746cc51935505333b064be7c061030397d'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Es un curso muy teórico, las tareas son mas que todo documentación al igual que una parte del proyecto. Los exámenes son algo fáciles, las clases suelen ser un poco aburridas. El curso se pasa facilmente. El profe brinda buena retroalimentación.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2023-06-30T00:00:00+00:00'::TIMESTAMPTZ, '6a62c888cff15955b7e06fa4cedace1374a27be56b0f36dc961a98acb130e835'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'El profesor es muy amable, no es muy claro a veces con lo que pide pero es muy bueno dando retroalimentación PRESENCIALMENTE. Los exámenes no son muy difíciles, busque una pareja de equipo que le guste escribir y escribir. Lo único pésimo es el horario del curso, muy tarde.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'fdf943ce73b72e6e80bbb4661082f61649f2043aa5295e8a7650f7a9d8a804f7'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'El curso es algo aburrido pero es sencillo y se puede aprender bastante de él'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos exámenes', 'Deja trabajos largos']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'ac7dd62cfa9bce6537aa7431fb2726257eadfcf1c5461f973faf0ae1c916a1cc'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'El profesor es muy pura vida y se preocupa por los estudiantes. Pero sus clases son aburridas, para explicar algo dura 30 minutos, cuando lo puede hacer en menos tiempo. Deja trabajos complejos en poco tiempo.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2021-07-03T00:00:00+00:00'::TIMESTAMPTZ, '75b79fb7fa276d785e2fc2afd98972298c196a6d5d78a83d40b77e72a0435ad2'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Es un excelente profesor en todo el sentido de la palabra, conoce bastante del tema y trata de enseñarlos de la manera más clara!! De igual forma responde muy rápido cualquier duda que uno tenga y lo ayuda si uno se encuentra medio perdido. Definitivamente volvería a llevar un curso con él'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2020-08-23T00:00:00+00:00'::TIMESTAMPTZ, 'cee26649b5fd21e6a08332af3ca5bc3652edbf444ddbe170227a1490023b489d'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-09-03T00:00:00+00:00'::TIMESTAMPTZ, '0235ae81c408a809b00e2bdfdac9d5decdae933ec48d60759da8c1ec2af8085f'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Es un profesor que conoce bastante y tiene demasiada experiencia, pero no sé que hace dando un curso como este, nunca tuve una percepción de que tratara el curso. Lo que rescato es que da mucha risa y que da buenos consejos de detalles laborales.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación']::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, '4355b4b9ad5763bbdb3eaf574e25ebcf806a51086286b6326fb8e8df98510831'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Terrible profesor, no se aprende nada, no es respetuoso con los estudiantes, califica de manera totalmente arbitraria, no dice que va a evaluar en los proyectos ni en las tareas. Al final de semestre da una nota completamente injustificada.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-12-06T00:00:00+00:00'::TIMESTAMPTZ, '37292c4b3e7fa5d828bdffd572effc70e91c8fa8c68e00d4fc8e878f2295f297'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'No aporta nada en el aprendizaje de la materia que imparte y posee métodos de calificación que no son congruentes con lo establecido al inicio del curso, al final las notas son completamente aleatorias'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2017-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'b51e9e3c03a62420a5fcc186e6a6ddbb08d1c62609afec5467ecbb542d77b339'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Pasar con él es fácil aunque casi no se aprende. Los exámenes son para la casa y relativamente fáciles, una que otra pregunta es complicada. Hace exponer en la clase los avances del proyecto para que todos aprendan de los errores de los demás.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2017-06-23T00:00:00+00:00'::TIMESTAMPTZ, '4b9904a3dc3b78822bc5bf153ffb101508b0386044a592bfb31289786da66ca2'::TEXT, ARRAY[1047]::BIGINT[]),
    (299::BIGINT, 'Si se quiere pasar fácil es buena opción, deja exámenes para la casa y se pueden pasar bien, además los proyectos no son nada del otro mundo. Lo que se aprende es poco, vale más guardar sus presentaciones pero es un curso fácil si se está muy cargado con otros'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2017-06-13T00:00:00+00:00'::TIMESTAMPTZ, '6de2ac27261ef30852b0f2cde4a1006e1e2268c2a31a7d4f17add4492b542e51'::TEXT, ARRAY[1047]::BIGINT[]),
    (299::BIGINT, 'Pésimo, no se aprenden absolutamente nada útil, solo habla paja, y es sumamente irrespetuoso.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'ed968a8d2fb711828030328435b3810db06966282c09a2acb27ea179156dc6fe'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Para pasar facil matricule con el , si quiere aprender mejor matricule con otro profe'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2016-12-09T00:00:00+00:00'::TIMESTAMPTZ, 'db83070cc70772eeb796c570ee2ce7ce0dfbf708f340bba49e1c2ab347fe23df'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Siempre cambia las cosas que dice, un día quiere X cosa y al día siguiente quiere Y. Califica duro los exámenes, los cuales son confusos y ambiguos.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Pocos exámenes']::TEXT[], '2016-12-05T00:00:00+00:00'::TIMESTAMPTZ, '29c216b73be3ae37c0893e7e8cc60fb15a392f3d13a873be09a24cc6f7f4612d'::TEXT, ARRAY[1039]::BIGINT[]),
    (299::BIGINT, 'Que profe más MALO por Dios. Lastimosamente no se aprende absolutamente nada, sus clases son una burla. Me arrepiento mil veces de haber matriculado con él, porque se puede pasar hasta con 100 pero el conocimiento ganado al final del curso es nulo.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-08-10T00:00:00+00:00'::TIMESTAMPTZ, '4f454c57f7dbf88d2b1807fb53257617424f80b149c0f36a5accc8f4c5a74945'::TEXT, ARRAY[1047]::BIGINT[]),
    (299::BIGINT, 'Un profesor con poca claridad en dar la materia. Los exámenes los deja para la casa, pero las preguntas son ambiguas y califica duro. Las progras son sencillas.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'fe989aa83e4e8a17c07c2e6f7becc1423b30cb9dd9d28265f1e40ad0aa21fd1f'::TEXT, ARRAY[1047]::BIGINT[]),
    (299::BIGINT, 'Pésimo, la verdad no aprendí nada en su curso. Con los proyectos si es super flexible y fácil, pero dando clases no es bueno, todo lo repite.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-07T00:00:00+00:00'::TIMESTAMPTZ, '8a3ea2dc76c96affa198617a2459f1d3f553c5a17ce535c72df2888f1290afdf'::TEXT, ARRAY[1047]::BIGINT[])
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
