-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=810
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.721428+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (810::BIGINT, 'Excelente profesor. No tengo más palabras que añadir, además de tener pasión por la enseñanza este también es una excelente persona. No califica tan duro, las clases son divertidas y le apasiona la materia. Su forma de enseñar es excelente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-08-07T00:00:00+00:00'::TIMESTAMPTZ, 'fced3892c81378d9c2ab3a01ae0ff4958669ee89d71d78f2380df3a434375a09'::TEXT, ARRAY[563]::BIGINT[]),
    (810::BIGINT, 'Lo considero el mejor profe de mate, es excelente explicando y siempre ayuda a evacuar las dudas, sus metodos de enseñanza son muy buenos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'cbb4409d967a60c4a8b340358cf2215d765692169b8febb72c63c9a63dcbdacf'::TEXT, ARRAY[563]::BIGINT[]),
    (810::BIGINT, 'De los mejores profe para llevar cálculo, los quices son muy acordes a los exámenes y califica suave, tampoco es que le va a dar puntos por cualquier cosa, pero califica bastante bien. Explica genial y sin duda llevaría su clase otra vez, gracias a este profe las integrales las manejo al dedillo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'e2fb2525e0e3b5bb1cdbda862a1975f6c253d6eeae3081a8583200e2c6c22644'::TEXT, ARRAY[605]::BIGINT[]),
    (810::BIGINT, 'Le faltan bases y explica muy rápido, es buena gente, pero siento que no sabe suficiente como para explicar'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'efd2d08a0f23e5fd44cfd2406b9064129400444b34b5d630e8f2eec6c2097c20'::TEXT, ARRAY[634]::BIGINT[]),
    (810::BIGINT, 'El Profe explica un poco rápido pero demasiado bien, todo se le entiende, realiza varios ejercicios y eso ayuda mucho; el curso no es muy fácil, hay que dedicarle varias horas de estudio. Los quiz son cuaderno abierto pero es necesario practicar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '452c416d2e26a0ae17af3a91b18c9f0ad81af5775a70cb4559a3b5b1c28f51be'::TEXT, ARRAY[563]::BIGINT[]),
    (810::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-18T00:00:00+00:00'::TIMESTAMPTZ, '6a33d47d892fe649cfe761dd94f0fea283baf78fa170093fd534e4d167b97657'::TEXT, ARRAY[634]::BIGINT[]),
    (810::BIGINT, 'Es un excelente profesor, se nota que enseñar es su pasión. Motiva a los estudiantes, explica con paciencia y de forma clara, suele compartir el material de clase, hace repasos antes de los exámenes. Es de los mejores profesores tanto si se desea aprender o simplemente pasar el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-01T00:00:00+00:00'::TIMESTAMPTZ, '4322e2fd62a107ae44c3fc8a41f4b999ce97501e68ae0f1f8c77271f0f504a0a'::TEXT, ARRAY[605, 634]::BIGINT[]),
    (810::BIGINT, 'faltan palabras para describir lo bien que ensena este proferos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-28T00:00:00+00:00'::TIMESTAMPTZ, 'bf69d10bc5862b24df059ef0f43aaf14aebf4560ca1adaca1dc9128689c3f2bf'::TEXT, ARRAY[563, 2439]::BIGINT[]),
    (810::BIGINT, 'Profe explica muy claro y a detalle, su método de enseñanza preferido es la explicación de desarrollo de distintos ejemplos, le gusta dar la teoría bastante resumida para una mejor compresión y la aplica y explica durante el desarrollo de los problemas. Da buenos consejos y tips para comprobar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2024-05-02T00:00:00+00:00'::TIMESTAMPTZ, '077f3906fd3bf18debca5735135d02ed29f969277ad0723b9379b34b88a7cb6a'::TEXT, ARRAY[563]::BIGINT[]),
    (810::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2024-02-15T00:00:00+00:00'::TIMESTAMPTZ, '31d4bcafd40d2f96e0547ec35db627b5a58620003fa1355e2567cda03e2bed0c'::TEXT, ARRAY[2439, 563]::BIGINT[]),
    (810::BIGINT, 'Explica bien mate General'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2023-09-27T00:00:00+00:00'::TIMESTAMPTZ, '3fd4dd76df0423ee4695fb6442ae06e1db432169f80e16f610765a5a11f2c7e3'::TEXT, ARRAY[563]::BIGINT[])
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
