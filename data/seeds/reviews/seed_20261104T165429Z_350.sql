-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=350
-- TEC-DATA-META years=2016,2017,2018,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.167350+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (350::BIGINT, 'El profe es buena gente, pero se confunde mucho y no tiene claridad.Es muy comprensivo. La asistente si sabe bastante, con mi cuadrilla siempre estuvo muy anuente. Las notas las da muy después pero se pasa fácil. Llegue temprano.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'a4caeb9919912c780b96dd447d219ab31dcc78163086556dd3a90604c74c98db'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'El profe es bueno ayuda mucho de ser necesario, la asistente es pésima no sabe lo que está haciendo, duran mucho calificando. Llegue temprano a clase porque sino pierde la evaluación semanal, elija un buen equipo de trabajo y aunque él diga que no, repartan roles en todo momento y no los cambien.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2026-06-21T00:00:00+00:00'::TIMESTAMPTZ, '9de2581697a6671630d4013aa4526f7ea077a6cfc12d575f46970860207f5f34'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Buen profe, ayuda bastante con las dudas; dura un monton calificando'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-06-29T00:00:00+00:00'::TIMESTAMPTZ, '6374c03a61a4f1aa5282c1aeb986d6d4f86c2887db2f34f001b93dc6e4282ce3'::TEXT, ARRAY[1186]::BIGINT[]),
    (350::BIGINT, 'Todo bien con el profe, es buena nota, en práctica está un poco confundido pero es por el equipo, dura mucho calificando.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '443d39955720c74790706b6f24172b0767bc66a86dec038c9ebda95ca75cfe32'::TEXT, ARRAY[1186]::BIGINT[]),
    (350::BIGINT, 'Muy buen profe, ayuda mucho es muy comprensible, califica suave. Vale la pena ir un sábado si es con él. Solo que dura demasiado calificando la libreta.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'ea567963301fb489eba646bb2574b2912cb03fc211641964206d4cf60e110307'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Ojalá todos los profes fueran como él, es excelente y no porque regale el curso sino porque uno realmente aprende, hace valer la pena ir un sábado a la u. 100% recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2018-07-12T00:00:00+00:00'::TIMESTAMPTZ, 'f8bf5fd31d6e54900ade17723a90e96ec80d5da658ef0136ae6be79bc3e61ac2'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'El mejor profe que tiene la escuela sin duda alguna, es súper buena nota, si uno no entiende algo él siempre está dispuesto a ayudar, explica todo súper bien, hace actividades muy entretenidas, de verdad que él es un modelo de profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'adc7c047b5f1878b419064af365878fb83da932a2ba5e9ae97e05c2f9317b5ee'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Es excelente, es el mejor profe en constru con el que me he topado. Enseña muchísimo e incluso enseña más de la cuenta en el sentido que cualquier herramienta útil que encuentre para el curso o para la vida, el la enseña. Es excelente persona y excelente profesor y atiende siempre las consultas.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'c86428302724043712147fe3ea953d0dd58aa8a0bd488bfbcba44e4921b6fa58'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Excelente profesor. Es un curso pesado por lo cual es necesario tener una buena cuadrilla.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2017-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'fd1d71002b477cb3ffd0eb8d9fb56bf656267aec6547a3c3af679ca9252b747f'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'El profesor más profesional y humano que he tenido, su prioridad es que usted aprenda, el no duda dos veces en ayudarlo y es muy buena gente, al final es como un amigo, ojalá todos los profes fueran como el. 10/10'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'b3a0df6ae6ca5b126b2626460a7fc34a9710b0e508c750390cfe8ea331584d45'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Es muy buena gente, ayuda,atiende cualquier duda, se aprende bastante, para los quices solo hay que estudiarse bien las presentaciones que sube, a pesar que son sábados vale la pena!!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'f4ae26b75d118bf7da466dfa7b701438a8af68a0571b8bee7e3e0df00fe70d0b'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'No hace examen, hace proyecto. Atiende consultas toda la semana, se aprende y el mae enseña muchas herramientas. Es demasiado buena gente, se preocupa por el estudiante y al final es un compa más. Califica normal. Vale la pena meter los sábados con él.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-07-01T00:00:00+00:00'::TIMESTAMPTZ, '868dd70de7c4c0892f82c0c0b7f4fa4a1b17d249525db6eeacd3682589048598'::TEXT, ARRAY[1194]::BIGINT[]),
    (350::BIGINT, 'Buen Profe, es un muy buen profe, va a aprender y a pasar con buena nota si le pone interés, recomendado, no tenga miedo de ir un sábado!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'cb3becb5f006e169505c4c4b9132324f4d066226eb6e097f26324b1478e149fe'::TEXT, ARRAY[1194]::BIGINT[])
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
