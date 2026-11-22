-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=28
-- TEC-DATA-META years=2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.282546+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (28::BIGINT, 'Varios trabajos que se hacen el proyecto final. Como los grupos son grandes, cada uno hace poco e igual es cero serio lo que pide. Muy atento, disponible a consultas y ayuda. Habla bastante pero no hace preguntas. Pasa lista pero no se enoja si faltó y si fue tardía le consulta y lo pone presente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-01-29T00:00:00+00:00'::TIMESTAMPTZ, '26d414ea3abf7658ddfa82de367abc5121229aae56727f72df05db564b9ea2e4'::TEXT, ARRAY[965]::BIGINT[]),
    (28::BIGINT, 'No lo lleve con él en verano, es demasiada pérdida de tiempo, hay que ir a todas las clases y dura 3 horas o más, las tareas son de 100 todas, pero son muy largas comparado a lo que se hace con otros profes. Avisa cosas el mismo día. Habla mucha papaya.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2024-01-03T00:00:00+00:00'::TIMESTAMPTZ, '25d97bb411212a634206c2f9e2154073019dbe9f1ee7c1d25eb758b203daa51a'::TEXT, ARRAY[965]::BIGINT[]),
    (28::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Clases excelentes']::TEXT[], '2023-10-30T00:00:00+00:00'::TIMESTAMPTZ, '2522a3ffa4d03411b46ac1f6021a5c790856b3aab4fbc6c7810b5d4c8b12bbbd'::TEXT, ARRAY[1892, 2374]::BIGINT[]),
    (28::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2023-01-10T00:00:00+00:00'::TIMESTAMPTZ, '4359b08c692ce9682f07306cfe430fb0372dfcbfec7001c1afc33c50615aaa5f'::TEXT, ARRAY[1892]::BIGINT[]),
    (28::BIGINT, 'Clases largas y aburridas, muchos trabajos, pero muy fáciles, si hace todo, pasa sobrado, pasa lista al inicio.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Da crédito extra']::TEXT[], '2022-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'd5d71cd7d44755d89a333a78d2f2aeea7cec993fc1f123d0524fbe6313d2d134'::TEXT, ARRAY[965]::BIGINT[]),
    (28::BIGINT, 'Este profe se toma muy en serio el curso, por lo que deja muchos trabajos y extiende cada clase hasta cumplir con las 4 horas. Sin embargo, los trabajos son bien fáciles y los califica súper suave, además de que ayuda bastante si lo ocupa.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2022-11-20T00:00:00+00:00'::TIMESTAMPTZ, 'cd1686b3873743840e4673babea2ff395af1881fdb39b5c48b9b2969501364b4'::TEXT, ARRAY[965]::BIGINT[]),
    (28::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, '1b5585ec50fbd45fde26bbb5865dbc67ab9f54fba157f6b85f051a928b9515f1'::TEXT, ARRAY[2374]::BIGINT[]),
    (28::BIGINT, 'Excelente profesor, ayuda siempre que puede'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2022-01-20T00:00:00+00:00'::TIMESTAMPTZ, '274f9070d968c2b4fd8b50595c51d08fa56d4f2d38d9c6c2060eefbf0165795e'::TEXT, ARRAY[2454]::BIGINT[]),
    (28::BIGINT, 'La verdad se toma muy en serio el curso a pesar de que en realidad no importa, deja demasiadas exposiciones y trabajos, además de que da las clases de 4 horas sin excepciones. Si tiene mejores opciones tómelas o le toca sufrir por un curso todo equis, además usa Teams'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-11-04T00:00:00+00:00'::TIMESTAMPTZ, 'e2cf0ca6522b82a315f7ce16c9a5a9965f028b56bb672fecbd3b4e6ecc3445d3'::TEXT, ARRAY[965]::BIGINT[]),
    (28::BIGINT, 'Buen profe, brinda apoyo y le interesa lo que hace'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Inspirador', 'Brinda apoyo']::TEXT[], '2021-08-22T00:00:00+00:00'::TIMESTAMPTZ, 'fbd1bb73f78eb5fa357af4a6b4fd67c86a3a442a8edc32761d89115842f682d4'::TEXT, ARRAY[1892, 2374]::BIGINT[]),
    (28::BIGINT, 'Es un profe poco claro con las instrucciones, pero ayuda bastante y atiende consultas.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'ef25a50f6dfe4e1d95e41f718f70173d0756f2be46ef0390221c0739968ec8f1'::TEXT, ARRAY[2374]::BIGINT[]),
    (28::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'de5e1c983942360873da630785ff004fbbcb8367852ff4356eeda8254fb9f584'::TEXT, ARRAY[1892, 2374]::BIGINT[]),
    (28::BIGINT, 'El profe deja bastante tarea, al menos una por semana. Además, todas las evaluaciones son en grupo. Pero en general, se aprende bastante con él y atiende dudas en cualquier momento. Eso sí, hay temas que no los explica muy a bien.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Brinda apoyo']::TEXT[], '2021-06-27T00:00:00+00:00'::TIMESTAMPTZ, '0d85ec450c67b8f3fb58be34969bcec977085c78c2509594ccc17db1d7353537'::TEXT, ARRAY[2454]::BIGINT[])
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
