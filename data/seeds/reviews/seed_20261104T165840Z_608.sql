-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=608
-- TEC-DATA-META years=2015,2016,2018,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.818905+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (608::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'ed9f4067aaeec05efba24bbf57dccc046a1ade806c8e50626da6110d60abb7bf'::TEXT, ARRAY[1631, 1629]::BIGINT[]),
    (608::BIGINT, 'Cómo profesor da clases para que al estudiante no le vaya mal, pero si se trata de debatir sobre las posiciones de los estudiantes y la de él, entra en conflicto porque no le gusta dar la razón. El último semestre actuó de la manera más rencorosa con el grupo. Alteró notas por rencor.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-02-06T00:00:00+00:00'::TIMESTAMPTZ, 'e548efe53b7a1e7209f98cf9917f5543e3f5b4c44d10ae6f7452cf537e727089'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'He quedado sorprendida de ver estos ultimos comentarios sobre Rosales. Ya sabemos que son las mismas vagabundas de siempre! Según se nos comunicó el curso fue aprobado por 33 de 42...el que no pasó fue por vago e irresponsable...la mayoría pasamos con solo dos exámenes...es excelente Rosales.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'dab510b268e5bb1df2ebee03de23401939dc79636bd55d092271293988bf3e2f'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'Comenzó bien, explicaba bien, normal. Al final del semestre cambió la evaluación y alteró notas (los quices venían con notas tachadas) para quedarnos a varios hasta por 0.01 puntos en el TD. No soporta que lo cuestionen, lo contradigan, etc. Dicho en sus propias palabras “el que sabe aquí soy yo”'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, '2cd6dc11ac9a16a326f52dc78592bb7ab80ca4b537900249114c186cea087d87'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'al inicio fue súper buena gente nos dijo que nadie iba a perder el curso, hasta que compañeros le cuestionaron la fecha del examen debido a amenazas en el tec y el mae se TRASTORNÓ, nos empezó a poner notas bajísimas, sin rúbrica y burlarse de la atención psicológica, poco profesional y loco xd'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'cf87b54e23c81b5acfcefb19604088968b5e4a9f812695074c05a48d04f735f0'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'Hace el curso fácil y califica suave, pero es un rencoroso y un ardido. Califica con el corazón, no con el cerebro. No teme en burlarse del estudiantado en media clase. Convenientemente ajusta notas y tergiversa conversaciones. 2/10'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '75f6458054d7fbd4f014d5b01ce77bdfc8a12c41154daacc03902b47b33f03a4'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'Es un profe muy tranquilo y muy bueno para explicar la materia. Hace cualquier clase simple. Es algo disperso, pero hace la clase más dinámica y divertida'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Da crédito extra']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'e3eacad83141c3c1489a3a340fe3aa1bb11eb507856c69ebe5e5e98b3cdee32b'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'Hace métodos de enseñanza mas fáciles y te prepara para el examen, califica suave'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-29T00:00:00+00:00'::TIMESTAMPTZ, '9132feb12b211093c28f1c2f817cd8ac0be651e38f1380d2ea528c1edb0c5eff'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'Me sorprende que no haya más comentarios sobre él pero es una persona formidable. Es un muy bueno en las mates y se nota, bastante amigable, cuenta historias muy buenas en clase. Aproveche y lleve el curso con él si necesita un buen profesor. Casi no tiene grupos en el tec xq da más clases en la ucr'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Inspirador']::TEXT[], '2025-05-27T00:00:00+00:00'::TIMESTAMPTZ, '7ce577b05cf8498dc0aa3f74a3884a83fd55583c7285fe1566be3cc0b9aa6dfd'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'Hasta ganas dan de volver a llevar un curso con él (difícil en el TEC). Nada más que agregar a lo dicho antes, un sol de persona y un bicho como profe, la mate nunca se había visto tan sencilla como él lo logra.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-11T00:00:00+00:00'::TIMESTAMPTZ, '6ce794d81290f2dcdb0b5d5da578c962cdc9d07459a7bb904b2fc5624eca40de'::TEXT, ARRAY[1864]::BIGINT[]),
    (608::BIGINT, 'Matricular con el es lo mejor que puede hacer, es un excelente profesor, sus clases son bastante entretenidas. Recomendación nunca falte a clases y vaya a consulta.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'f4bc5890f99deecacd304b6678449577e18c8c9549a1176f82950c0282514625'::TEXT, ARRAY[1034]::BIGINT[]),
    (608::BIGINT, 'Me alegró ver otros comentarios de este semestre que pasó mencionando lo buen profe que él es :D, de verdad el mejor profe de mate en el TEC. Casi no tiene calificaciones porque da clases principalmente en la UCR. El profe hasta clases repaso da antes del examen. El café no falta en la consulta. :)'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2023-06-28T00:00:00+00:00'::TIMESTAMPTZ, '846f2937b86f3eeb8557e547fe16b90f99943f5c9555b789a1f3fc6c6026e8b2'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'El profe rosales es el mejor profe de mate que el TEC puede tener, las clases claras, divertidas. En consulta es genial cualquier duda queda clara y pueden hacer ejercicios extras. Si pueden matricular con el hángalo será la mejor decision de su vida y para calificar es muy piadoso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '4187dab5ae1d07b424b47f472fb84ad5f5752013516200567f91120b13f37126'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'Una teja de persona y de profe. La verdad ninguna queja a alguna de sus clases. Nunca falta a clases, explica bien y siempre da consulta después de lecciones que ayudan mucho.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '8199ac4ad6cc97832eaf7afa9b704f4c4edf34157611819f395afdd889c22f4a'::TEXT, ARRAY[634]::BIGINT[]),
    (608::BIGINT, 'Excelente, este profe es un bicho'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Muchos exámenes']::TEXT[], '2022-03-25T00:00:00+00:00'::TIMESTAMPTZ, '25d622e81ed286321a5c0f3e41ab61ece1232c8867040147494112ace0322dbc'::TEXT, ARRAY[1672]::BIGINT[]),
    (608::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2018-11-27T00:00:00+00:00'::TIMESTAMPTZ, '0c70a79e2aeeaf2e9927a4c2de06f2a4d6f5dd1e8d9ef875f448d0265eac8abf'::TEXT, ARRAY[1672]::BIGINT[]),
    (608::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2016-06-28T00:00:00+00:00'::TIMESTAMPTZ, '9ddcb7709caeff91fa87e5827961d280e5702b0c56c0e4ab0f2177d9c85f88d7'::TEXT, ARRAY[261, 2444]::BIGINT[]),
    (608::BIGINT, 'Excelente'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'f5860087196d31de7d20fcc7a3080030dcab19c6370848ac7bd2edb9f43990d8'::TEXT, ARRAY[261, 2444]::BIGINT[])
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
