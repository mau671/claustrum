-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=358
-- TEC-DATA-META years=2018,2019,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.890861+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (358::BIGINT, 'Excelente profe es un Dios en la materia. Dan ganas de ir a clases a si sean a las 7. Da buen material. De lo mejor del tec. Es un Dios'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Inspirador', 'Clases excelentes']::TEXT[], '2026-07-17T00:00:00+00:00'::TIMESTAMPTZ, '4384e6daa7552621055289c0043f4e3503d2e0a8d41f630f22c156ced434d3ce'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Exc profesor. Explica súper claro y ayuda mucho. La primera mitad del semestre es la más pesada porque deja mucha tarea y el examen es rudo, pero ya después es más tranquilo. Con que ponga un poco de su parte lo pasa bien'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '7514815eddb672542f2b7237f4283fa863b37a0ea1c16403b9ab864b6260d503'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Uno de los mejores profes de la carrera, se interesa por los estudiantes y explica muy bien, la verdad es que si usted va a clases de fijo pasa bien el curso. Hay que estudiar y ponerle pero en los exámenes se ven ejercicios muy parecidos a los de práctica.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'f8ccd674c564597651ebee02c570b63663e6ee9fbf0f46600a9f82b178911f7f'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Braulio sabe mucho y se nota que le gusta la parte de hidráulica, las clases son largas, pero es porque el curso es pesado y generalmente se ven varios temas por clase, ayuda bastante en las consultas y hasta motiva a los estudiantes a hacer asistencias relacionadas con la hidráulica'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Clases largas']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'd6d95d4701f3ea5b3c661d06dd83a2d68515eb65ff64ef6f04bc3e209d6b4c71'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, '(Virtual) El profe explica súper bien, las tareas ayudan un montón para los exámenes, si deja tareas extra, hágalas, salen ejercicios muy similares, en consulta ayuda un montón y entiende muy bien al estudiante. Los exámenes son extensos, pero realizables'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Aspectos de calificación claros']::TEXT[], '2022-01-24T00:00:00+00:00'::TIMESTAMPTZ, '76514c7c4226e2bffda3322c6dfd09f5bc6ad5b268729f264c5c0245622d6d3b'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2019-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'b75d41a91f7368a7f28923935dd8007dfa4aee83210e6ed5515fab99cf0c603b'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2019-06-23T00:00:00+00:00'::TIMESTAMPTZ, '07824a93d2d064dec14e554bb269b34394d6d5917300aff40c1c8ab34a27c6b3'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Hay que estar atento en clase para agarrar lo que dice. Lo pone a uno a pensar mucho y explica las veces que sea necesario. Es muy agradable y sabe mucho.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-05-16T00:00:00+00:00'::TIMESTAMPTZ, '603de0cd721746a52c15bc88aa1ab82234c135ac2ab6fb7d3705b1d54b8ef465'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'El profesor no es muy bueno explicando. Explica unicamente lo básico y de ahí en adelante tenés que jugártela. Los exámenes tiene el doble de dificultad que lo visto en clase y en reposición ni hablar. Hay que ponerle mucho desde el principio para no terminar tallado con la nota.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-23T00:00:00+00:00'::TIMESTAMPTZ, 'c3fa88a582bded61118d7797e3dd230f9d90fa0d6baacaa62299d530b5ef51ef'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'Quices y Tareas sencillos, exámenes difíciles y largos, sin embargo es comprensible con fechas y ayuda a que la mayoría pasen Ademas se aprende de verdad Hidráulica y no como con la profe pasada.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-21T00:00:00+00:00'::TIMESTAMPTZ, '936fb4dcf80e0e002cdd43db984dd822cd6099a0151138814b0ca4f7f11d91d4'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'El profe hace que usted aprenda o aprenda, los exámenes son súper complicados, mientras que las tareas y quices son bastante sencillos, si usted asistente a consulta o tiene dudas el profe siempre está dispuesto a ayudar, pero tiene que ponerle 100% desde el principio'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-07T00:00:00+00:00'::TIMESTAMPTZ, '9400dd44e0f28bf45ee4d03b5eab239babba22ea638bc366a75d0f773812cc17'::TEXT, ARRAY[1210]::BIGINT[]),
    (358::BIGINT, 'exámenes muy volados, califica duro'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2018-11-06T00:00:00+00:00'::TIMESTAMPTZ, '1da36b604b6fefe2269e00dc9ac241c9b8fb385f9984cd7588bfd6e209a8be81'::TEXT, ARRAY[1210]::BIGINT[])
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
