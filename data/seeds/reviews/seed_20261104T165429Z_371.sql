-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=371
-- TEC-DATA-META years=2015,2017,2019,2020,2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.197127+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (371::BIGINT, 'Da clases largas y aburridas, esperaba que el curso fuese mas chiva pero es pura teoría. Al profesor no le cuadra que no se conecten a la clase aunque esta quede grabada y no sea obligatorio hacerlo.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2022-03-23T00:00:00+00:00'::TIMESTAMPTZ, '7cc149fe133c4435da3eff9c0a9c79ae2e4ddceece490ad2801791c7ba2babb6'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'El profe deja trabajos excesivos, extensos con poco tiempo, además no es comprensivo y no ayuda a los estudiantes, así que si entregas un trabajo o examen en otro formato al indicado automaticamente tienes un cero, también hay que tener cuidado con las evaluaciones del gaap.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-20T00:00:00+00:00'::TIMESTAMPTZ, '892de0ee99ddd712d486fac3ae1e0add317b99f40499de0029198866bd50e3cd'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'Las clases son demasiado largas y cansadas, el profe es un poco mala nota y si las cosas no son como el dice se molesta. Proyecto y examen dificiles y grupales, pero se aprende mucho si se tiene interés por lo eléctrico'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Exámenes retadores']::TEXT[], '2021-07-18T00:00:00+00:00'::TIMESTAMPTZ, 'ace003244bcb69ef513eeb1654420c9702cfb9ffc32e8239d3e8df794e064425'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'En realidad no es mal profesor a la hora de explicar pero cree que este curso es el único que se lleva entonces deja muchos trabajos llaménse proyectos y tareas con plazos absurdamente cortos'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2021-04-10T00:00:00+00:00'::TIMESTAMPTZ, 'bf40c17f1d992ac0b7760c0f5a31b89bd70c282444f1b36654c794c61ef62faa'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'Tareas y proyectos excesivos, nunca sabe nada con seguridad ni es flexible, el curso es pesado.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2021-04-10T00:00:00+00:00'::TIMESTAMPTZ, 'bc571d80f62eb793860eeb7146654b9783977637bb72354a7448ad10f7599fc3'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'Es muy poco comprensivo con los estudiantes, deja tareas y proyectos largos con poco tiempo de entrega.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-04-10T00:00:00+00:00'::TIMESTAMPTZ, '81114fc8f70aacedd2b6dca9b29e574e76896fbdd085cb536642e7f76ae14dca'::TEXT, ARRAY[1224]::BIGINT[]),
    (371::BIGINT, 'El profe hace que el curso sea muy autodidacta, a veces ayuda y no siempre es flexible , no es el peor profe , sin embargo califica duro y un poco injusto'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2020-02-11T00:00:00+00:00'::TIMESTAMPTZ, 'fc9a1c8d189eaf8784d9fb0591b1b2d407ab7afba3a744584f0d274c24d64672'::TEXT, ARRAY[610]::BIGINT[]),
    (371::BIGINT, 'si se le pregunta algo la respuesta siempre es como. Busquelo en las diapositivas ahi debe de estar, o vaya a la biblioteca y busquese el libro de reglas. Califica muy duro'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2019-11-10T00:00:00+00:00'::TIMESTAMPTZ, '676d61c6a76fdd5071c77d3788d1d43c02233d3ac8417744b331c3351bd43620'::TEXT, ARRAY[610]::BIGINT[]),
    (371::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-20T00:00:00+00:00'::TIMESTAMPTZ, '275d1242a7cd29d118f9debad8e0c7dbfc0e2a050a3123f031b857f336f4f684'::TEXT, ARRAY[610]::BIGINT[]),
    (371::BIGINT, 'Tiene la intención de que uno aprenda pero le cuesta transmitir la información, tal vez fue por ser la primera vez que daba el curso, aunque si es buena gente y ayuda si ve que todos van mal'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-28T00:00:00+00:00'::TIMESTAMPTZ, '2afcd027c69c10c99f6fd5656cb1cd7a449cda3112688d737071eea1dd0b5bca'::TEXT, ARRAY[942]::BIGINT[]),
    (371::BIGINT, 'El laboratorio no es Fácil, pero se aprende muchísimo!!! y te ayuda, ademas deja un proyecto muy tuanis, con el cual uno aprende cosas nuevas (matlab-simulink-latex)'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Brinda apoyo']::TEXT[], '2017-01-29T00:00:00+00:00'::TIMESTAMPTZ, '36bf8d5b07b80f93ae2b179c2507d4146af0bd518d368e238114da25ecac79fe'::TEXT, ARRAY[960]::BIGINT[]),
    (371::BIGINT, 'profe muy buena gente y explica muy bien'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-18T00:00:00+00:00'::TIMESTAMPTZ, '8f18c0507c4d749dfab100521973ac453236629f4985d3a14e62d6c5ae6d26fa'::TEXT, ARRAY[636]::BIGINT[]),
    (371::BIGINT, 'Los quices son muy dificiles aunque el profe explica muy bien'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-07-02T00:00:00+00:00'::TIMESTAMPTZ, '70e54fb48c83a73be2f25b549031f4a068a0658464300058d075c4db1ea9afa4'::TEXT, ARRAY[636]::BIGINT[]),
    (371::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'a7a9814cef6223cf61625200b9dddbecbf68a697226d99857a4905d90f51f1fa'::TEXT, ARRAY[636]::BIGINT[])
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
