-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=68
-- TEC-DATA-META years=2016,2017,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.055405+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (68::BIGINT, 'Excelente profe para el curso, ella entiende que su curso es de relleno por lo que entiende que estamos por obligacion, pero muestra la importancia que puede tener el curso en la vida laboral, tener buen grupo de trabajo, suele olvidar asignar las fechas en el TEC digital, entonces hay que recordarl'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2026-02-04T00:00:00+00:00'::TIMESTAMPTZ, '63b2080665a9ad6486fb2f93fe207546c2cc00da4a81b5788f8238e1465b1772'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'Materia de relleno, deja trabajos casi que semanales y a veces un toque largos. Califica muy suave, todo se maneja en grupos de 5 o más. Deja como 4 presentaciones, pero no es mala opción para llevar este curso, se pasa con buena nota.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, '78040d9912ebb785ee2877d28310a97786434f554a63b9ca3de768926623f28d'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'La profe es muy flexible con las entregas, este semestre el cronograma fue desordenado. Hay muchos trabajos grupales pero califica suave. Clase sumamente larga y aburrida'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, '859c4aa7405bb900fdeb7a2e77f56d1ee10381d04569a01439eca8328c3ce275'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'El curso en sí es fácil y la profesora lo hace ameno, da más plazo para entregar los trabajos si uno lo pide y la mayoría de trabajos son grupales Conseguir un buen grupo de trabajo es más importante'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[], '2024-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'c1d2191e40ab6051257b8c50397e57648bf48d541963b65a26af282b77ac8d8d'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'La profe es muy simpática y hace una clase amena. Está empezando a dar D. Emprendedores de nuevo y considero que ha mejorado bastante, se aprende de una forma entretenida diría yo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'f775e88d0cf1ba6bceb38d5f441bf3ad9f5b261f6a94cc49e5fb4b987751b61c'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'La profe es buena nota, pero ella nunca da la clase se la tira en puras exposiciones y es un poco desordenada. El cronograma lo cambia como 100 veces en el semestre. Pero es fácil.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-29T00:00:00+00:00'::TIMESTAMPTZ, '6bb36e71737cfa24fb4d1eda5f4d678623c6a2a108733aa9ef6b4f35366ca64d'::TEXT, ARRAY[99]::BIGINT[]),
    (68::BIGINT, 'La clase la dan los estudiantes para que sea "dinámico". Muy desordenada con aspectos de evaluación, no planifica las clases'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Muchos proyectos grupales']::TEXT[], '2017-06-12T00:00:00+00:00'::TIMESTAMPTZ, '14031d89d6f2ef4f08b948481c48808b239270e1f53b7e336ef0506c6907e6d9'::TEXT, ARRAY[99]::BIGINT[]),
    (68::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2017-02-09T00:00:00+00:00'::TIMESTAMPTZ, '96515bddd29da54b0d0bb7bcde32255f1003e3c46fa3391e6c7a10105535985c'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2016-06-27T00:00:00+00:00'::TIMESTAMPTZ, '1a35784f35cba28086ec60cf370a87c4de7686f3a9fe0f2fff9e1ee9a34be560'::TEXT, ARRAY[965]::BIGINT[]),
    (68::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-27T00:00:00+00:00'::TIMESTAMPTZ, '8364ea2f5bf693e2472bf9ddda76f236d579964b1ccd43809a8d815cad3b2ca3'::TEXT, ARRAY[98, 2363, 2359, 96]::BIGINT[])
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
