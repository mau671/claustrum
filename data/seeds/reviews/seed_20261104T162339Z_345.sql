-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=345
-- TEC-DATA-META years=2023,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.949584+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (345::BIGINT, 'En clase lo que más atrasa son los compañeros, el profe responde toda duda y se devuelve mil veces, hay que llevar todo a día sí o sí, si se acumulan cosas prepárense para un 24 horas sin dormir, mínimo, buen profe. El curso se puede hacer un poco pesado, pero hay mucha practica.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'a41166c2657f7f1d888888df12fcca9a45fdda0cb32772dfefa110f752348289'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Excelente Profe, uno debe de ponerle para hacer todos los ejercicios de la carpeta de entregables, y con los exámenes y quices repasar bastante para salir super bien, si le cuesta mucho ya que el curso es Revit y AutoCAD se puede ayudar con videos en YouTube. Pero si le pone sale excelente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, '5baaee2c0ef4ba79ed6b929b7050fcdae40537f01cb475ce7bf1359202edb0d9'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Es un profe justo, y de recomendacion haga todo lo del principio apenas pueda, ya despues con Revit se pone duro el profe, y lleve bien las plantillas y plumas en CAD'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2024-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'afa39518bb340f482119e0c06387a320b4a447fbb628ae971af69fc1a1408911'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Participe en clases, es importante, preparase para los exámenes o quices que se pone creativo, pero en general es un buen profesor, si no entiende el le explica amablemente las veces que quiera, es un excelente profesor. Y guarde TODO lo que haga porque lo necesita para la carpeta de entregables.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'd8e4f02c35fe315cf6f5e591a6c1f8ee9969890eee3982945542cc27a9b7a5ca'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'El profe es muy buena nota, siempre es muy claro con todo y te brinda ayuda para comprender problemas, etc. Como recomendación: lleven el portafolio actualizado con el formato completo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2023-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'a8e0b97ac08f1ede0302b22f832c079e8e5f95baa5892dde9b0faa427bf551ef'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Respetado por los estudiantes', 'Aspectos de calificación claros']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'cf9132c7c88e5e03c58d0e12af99b56dddc87138d12f95632fd18e8dc755b8c7'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Es bueno, pero es demasiado matado y en vez de sentirse como curso introductorio a la carrera, se siente avanzado'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2023-06-25T00:00:00+00:00'::TIMESTAMPTZ, '06bb985841bd9d65e8efa999cb719fc50d6ada03044a757d4602500bbf0f1b0d'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Excelente profesor, muy claro en las explicaciones y siempre atento en cuanto a las dudas de clase y siempre te ayudará a resolverlas de la mejor manera. Las evaluaciones son un poco difíciles, pero nada salido de lo que hemos trabajado, un profe de mucha categoría, matricule sin pensarlo, el mejor'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'ebd72a694d1403a147f6cfc8a069e9c16fc69ea49144f4d1ec9e1b2bd13929b1'::TEXT, ARRAY[1179]::BIGINT[]),
    (345::BIGINT, 'Está atento a dudas siempre, explica muy bien y es considerado con los estudiantes'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-05-28T00:00:00+00:00'::TIMESTAMPTZ, '25ff6eb640d27443db103f3567fb62e736e68a538c1805a35bfcb7bf363dfce5'::TEXT, ARRAY[1179]::BIGINT[])
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
