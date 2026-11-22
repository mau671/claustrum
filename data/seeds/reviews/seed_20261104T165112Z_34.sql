-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=34
-- TEC-DATA-META years=2020,2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.032522+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (34::BIGINT, 'Si eres mujer y tienes chance de llevar sus cursos pero en otra sede, no la dejen pasar. El nivel de acoso con este señor es altísimo, no entiende un NO. Se enoja por el rechazo y después la tiene entre ojo. Lo que una tiene que pasar para poder estudiar, es lamentable...'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-09-15T00:00:00+00:00'::TIMESTAMPTZ, '0a5cea068dcbbe4d09d4a3a99534bec94e7836a4d2a6642756f6c981e9bedc09'::TEXT, ARRAY[1707]::BIGINT[]),
    (34::BIGINT, 'Es lamentable que el CAL tenga a este señor como coordinador, se les insinúa a compañeras, actualmente tiene una relación con una compañera, y el teniendo hijos y esposa. Hay demasiado favoritismo.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'e2add76c11007c51a55cb81367b01de63b25103d3c971f3a605ca1c0ba228c82'::TEXT, ARRAY[1707]::BIGINT[]),
    (34::BIGINT, 'El profesor es 0 profesional, es irrespetuoso y no es un buen ejemplo como educador del TEC, también he sido una de las que ha acosado, insinuándose a cambio de favores como asistencias o dinero por estar con el.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2024-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'c8a750fdc2500819375e1dd74f36b8218cc63a971568e57a137cf546777318fd'::TEXT, ARRAY[1707]::BIGINT[]),
    (34::BIGINT, 'Un hombre posesivo y prepotente, tiene aires de grandeza por la fama que le han brindado. Además tiene relaciones íntimas con distintas estudiantes (compañeras de clase) de la sede, y hace creer que es muy respetuoso por tener una esposa, solo tiene de queridas a muchas en CAL ENFERMO'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2023-08-05T00:00:00+00:00'::TIMESTAMPTZ, '5be65577a11528b41246d3c2224442e41474e7712f434a34955369280abcf5d2'::TEXT, ARRAY[2948]::BIGINT[]),
    (34::BIGINT, 'Profe muy colaborativo, las clases llegan a ser muy personalizadas, lo recomiendo, a veces deja evaluaciones refritas pero sales bien'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-18T00:00:00+00:00'::TIMESTAMPTZ, '336290391fcd925425347736ec4968f2a7bda205edf419cce1c6109d75e90131'::TEXT, ARRAY[1707]::BIGINT[]),
    (34::BIGINT, 'Es un buen profesor, si pones atencion en clases o si deja clases asincronicas (ver videos de clases explicando materia) y haces todos los trabajos le ira bien, muy buen profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'f3911d74aecfd5e09f477ac3839dd2c3604072643f924dc35f12e7814853584e'::TEXT, ARRAY[1707, 1206]::BIGINT[]),
    (34::BIGINT, 'No lo recomiendo, aparenta ser serio y centrado y no lo es, es un acosador porque pasa insinuando a todas, me incluyo, y todo lo quiere ver como algún favor para según el negociar mediante $ex0 o bien dinero.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Da crédito extra']::TEXT[], '2023-01-31T00:00:00+00:00'::TIMESTAMPTZ, '597ea1e6fe92f368f983130491cdd703018f9168258c8af21cda791e52762f71'::TEXT, ARRAY[1708]::BIGINT[]),
    (34::BIGINT, 'Bastante recomendable, se interesa más porque el estudiante aprenda y es muy condescendiente, las prácticas son recicladas pero funcionan'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra']::TEXT[], '2022-11-28T00:00:00+00:00'::TIMESTAMPTZ, '0e5f7c1577ab578b726e25547af5d51d37f2589a927238f5674d4cd95f9c358f'::TEXT, ARRAY[2367]::BIGINT[]),
    (34::BIGINT, 'Virtual. Muy buen profesor, explica los ejercicios pero la solución no las sube por lo que solo queda en vídeos.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Muchos exámenes']::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '3ea69648d551e203cb864ff6eb47f5a21c4effdd1cd44bcfa81ec36ad94cb28e'::TEXT, ARRAY[1708]::BIGINT[]),
    (34::BIGINT, 'Utiliza materiales viejos reciclados con errores Situaciones de trato no apropiado a alumnas'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-12-23T00:00:00+00:00'::TIMESTAMPTZ, '8bab676e2355c8e9c6b4759549312e96878bd4efad77ad9dac399e180dfc23c5'::TEXT, ARRAY[1515]::BIGINT[]),
    (34::BIGINT, 'LOS QUIZ Y EXAMENES ENREDADOS TODAS LAS SEMANAS... PERO ES PURA VIDA DE PROFE'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2021-07-09T00:00:00+00:00'::TIMESTAMPTZ, 'f56526d8c548e5d23e8e2d1a316775e2edc1471ba4fc5e14e8caf02300986c79'::TEXT, ARRAY[2403]::BIGINT[]),
    (34::BIGINT, 'Es muy buen profe, se nota que sabe y siempre busca de la manera posible ayudar al estudiante, es pura vida , gran persona.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-05-19T00:00:00+00:00'::TIMESTAMPTZ, '9e26a039f1b169dc16e8e35a00fd51c19262205229052774d43c1b062e75a44f'::TEXT, ARRAY[2403, 1708]::BIGINT[]),
    (34::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '18fd1789aa70c36ce674974c971cbc1c03d0b675abb5985b037cd4e18220fb9e'::TEXT, ARRAY[1707]::BIGINT[]),
    (34::BIGINT, 'Es un buen profe que te va explicar varias veces hasta que entiendas, se preocupa porque el estudiante aprenda , los examenes son algo dificiles pero no califica tan duro, es muy pura vida.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2020-08-14T00:00:00+00:00'::TIMESTAMPTZ, '1729cfed6846524a77972a7a9c7c71c3163cd32abd50187c86b26d2508356ffb'::TEXT, ARRAY[2403]::BIGINT[])
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
