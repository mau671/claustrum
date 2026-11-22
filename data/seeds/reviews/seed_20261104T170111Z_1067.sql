-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1067
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.070227+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1067::BIGINT, 'Demasiado estricta con reglas sin sentido. Indicaciones poco claras y desproporcionadas con los creditos del curso. El curso es pasable pero sigue siendo un dolor.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'aa5648306c7ac33e0bc9356340cceb009dd122cf860db74008c12cbd9804ed4a'::TEXT, ARRAY[556]::BIGINT[]),
    (1067::BIGINT, 'Excelente, es la definición de una profesora dulce. Matricule con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-02T00:00:00+00:00'::TIMESTAMPTZ, 'ce032934f3d3fdc7ca976e1274eba0bbcbf1cb65819cb81ad401be3ce73ff2e8'::TEXT, ARRAY[600]::BIGINT[]),
    (1067::BIGINT, 'Realmente es un amor de persona y profesora, siempre tiene la intención de ayudarte y que puedas aprender sin tanta carga. Deja al menos un trabajo por clase pero son tan sencillos que si tienes un buen compañero, los puedes terminar en el mismo transcurso de clase y rápido.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-02-20T00:00:00+00:00'::TIMESTAMPTZ, 'd8b81c543799e10d33ad690005aa03f3e660d18dbc5613e9a081b43be9707711'::TEXT, ARRAY[554]::BIGINT[]),
    (1067::BIGINT, 'Una profe excelente. Lo ayuda a uno cuando lo ocupa y explica hasta que uno lo entienda. Deja trabajo, pero lo suficiente como para aprender.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-01-18T00:00:00+00:00'::TIMESTAMPTZ, '0e4c93123d3ca23a82a45ef3d9776a931b635e5ad13a8772a2c9ec079fe0cadb'::TEXT, ARRAY[600, 554]::BIGINT[]),
    (1067::BIGINT, 'Hágase un favorsote y matricule con esta profe, es de las mejores que usted va a encontrar. Es super comprensiva y da muy buena retroalimentación. Lo único malo es que cumple las 3 horas de clase, casi nunca sale temprano con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'a4a8e879fc28f2e0a38db610c7f264e4ad3df590d9f81c9851a34ba1978a7da6'::TEXT, ARRAY[600]::BIGINT[]),
    (1067::BIGINT, 'La mejor profe y excelente persona. Haz todos los trabajos y pasas fácil. No dude en matricular con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, '965b8d216e0ee754f385948967f55760ca87573f38124db2b5b326c6e9075fa0'::TEXT, ARRAY[600]::BIGINT[]),
    (1067::BIGINT, 'Las clases son muy fáciles y la profe es un amor. Suele dejar muchos trabajos pero se hacen rápido, incluso da tiempo a hacerlos en la clase el día de la entrega. Si quiere tener un 100 asegurado tiene que hacer todos los trabajos y entregarlos a tiempo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, '70c56e991066ea9e0225aaf67cb7ad9721e7bdf13326289e59171d366d2410aa'::TEXT, ARRAY[555]::BIGINT[]),
    (1067::BIGINT, 'Las tareas son casi siempre en grupos y da bastante tiempo. También da tiempo para hacer los proyectos grandes en clase. Saqué 100 en casi todo pero hay gente que le fue mal por no tomarselo enserio. Si llega tarde le pone tardía, siempre hace clase pero a veces se sale un toque antes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'ad4cfa12549b50c7376824e58d57fe02763fb9e9aefbc31f940836a78b07acb2'::TEXT, ARRAY[554]::BIGINT[]),
    (1067::BIGINT, 'La profesora es un amor, pasar con ella con una buena nota es casi que asegurado, da oportunidades de corregir un trabajo para así no tener que quitar puntos, volvería a tomar clases con ella sin duda'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-05T00:00:00+00:00'::TIMESTAMPTZ, '6eb60ea4b5cb8dd9663bb99ea23a09e764bf3f2d4f08e8704225329f921a473b'::TEXT, ARRAY[554]::BIGINT[]),
    (1067::BIGINT, 'Una profe que es literalmente un amor, demasiado facil pasar con ella, lo disfruté un montón'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-20T00:00:00+00:00'::TIMESTAMPTZ, '3019089762210588e144c2c64452424480acacba0c9da40a6d271b053da97b1d'::TEXT, ARRAY[555]::BIGINT[])
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
