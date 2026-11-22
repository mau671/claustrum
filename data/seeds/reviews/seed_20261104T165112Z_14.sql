-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=14
-- TEC-DATA-META years=2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.022215+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (14::BIGINT, 'Excelente profesora, si quieren pasar los cursos de estadística y entenderlos matriculen con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '28bc096c532a97280fd8d48d045f24d70f44e7e72f04867280ff61cc619f787d'::TEXT, ARRAY[2374]::BIGINT[]),
    (14::BIGINT, 'No esconde su favoritismo con algunos estudiantes, les deja pasar cosas que a los demás no. Si uno le pregunta algo, ella no proporciona respuestas útiles. Cambia mucho de mente y de opinión. Hace muchos comentarios indeseados, ha llegado a ser clasista'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2026-06-14T00:00:00+00:00'::TIMESTAMPTZ, '45147a9001991df8ece449dcb8fd5531f18eb2f08939b9d82c742fa87ff9b55c'::TEXT, ARRAY[1883]::BIGINT[]),
    (14::BIGINT, 'Al principio no sabía qué esperar, pero superó toda expectativa. Es una persona con una experiencia muy amplia, sabe muchísimo a nivel de mercado, además de tener una personalidad encantadora. Casi siempre se expone y alienta a que todos participen. Muy organizada! Lo llevaría con ella nuevamente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ, '6ebdf3e06d9a063f2a06b7691a3f0482a5c5d4829ca4fe957316f5b986994fcf'::TEXT, ARRAY[1883]::BIGINT[]),
    (14::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-10T00:00:00+00:00'::TIMESTAMPTZ, '5987771481d48d283b505b9b6542a66ae3d27be0a0484437bb0b0b9fb70a270e'::TEXT, ARRAY[2374]::BIGINT[]),
    (14::BIGINT, 'A pesar de lo que había escuchado de ella es una excelente profesional. Si ud estudia y practica le va a ir super bien en el curso.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-11-25T00:00:00+00:00'::TIMESTAMPTZ, '4efb4bb45ea58ee0cbd70d71adc4950c526cbdcfc74858ed6a8621a69cd2270e'::TEXT, ARRAY[1892]::BIGINT[]),
    (14::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Inspirador']::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '0077a1ca17256c6fee4ec81623f28ce448b2b6ffa55a75059dd28179026d6cb6'::TEXT, ARRAY[306]::BIGINT[]),
    (14::BIGINT, 'La profe es muy comprensiva y apoya a los estudiantes. Explica un poco confuso pero trae muchos expositores y material de apoyo. Es muy agradable la clase y tiene mucho conocimiento. Hace trabajos grupales y muchas exposiciones. Súper recomendada.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ab89bd897226d6c744e1dea30072d23d45cd1f477fba68ff161dcb36ecf0a689'::TEXT, ARRAY[306]::BIGINT[])
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
