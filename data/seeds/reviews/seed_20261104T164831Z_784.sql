-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=784
-- TEC-DATA-META years=2019,2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.864147+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (784::BIGINT, 'Una de las mejores clases que tuve, el profe maneja la materia, la explica perfecto, hay que poner atención y tomar apuntes, y los trabajos son acorde a eso, siempre tenemos el espacio de retroalimentación y las horas de consulta, se les saca 100% provecho. Las bases para los próximos cursos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2026-10-03T00:00:00+00:00'::TIMESTAMPTZ, '53500be0e7e5b6128acb6320787f798d3bc5983030b94b1f32686ce799d3bb0b'::TEXT, ARRAY[4749]::BIGINT[]),
    (784::BIGINT, 'Exelente profesor, de los mejores de la escuela. es directo y comico pero esos dos aspectos ayudan a entenderle muy bien'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Respetado por los estudiantes']::TEXT[], '2023-02-01T00:00:00+00:00'::TIMESTAMPTZ, '102d9741212227b7764c8432db04ea8e7d1eb5a76439a73761c705bf0ecb1aab'::TEXT, ARRAY[4748, 4783, 4790, 4785, 4792]::BIGINT[]),
    (784::BIGINT, 'Es más exigente en taller 5 que en taller 2, pero igual es muy bueno. Es muy crítico, busca hacer bromas para expxlicar, lo que lo hace ameno y fácil de entender.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2022-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'ef003555a1059fd54324576856f77ad8eaa86cac6678c1ac18f28876480a9355'::TEXT, ARRAY[4785]::BIGINT[]),
    (784::BIGINT, 'Muy buen profe. Es muy directo en sus críticas, pero ayuda mucho a mejorar. Está atento al proceso. Muy ordenado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Respetado por los estudiantes']::TEXT[], '2022-02-12T00:00:00+00:00'::TIMESTAMPTZ, '6f59bffda4842723fb45284c77ae8ce0047d4348085e3d7d882da54046803e17'::TEXT, ARRAY[4758]::BIGINT[]),
    (784::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2021-12-01T00:00:00+00:00'::TIMESTAMPTZ, '203775d3db5dd37e03737fa93cd560be5272bd80016442577ffd4c6650a9c2a5'::TEXT, ARRAY[4765]::BIGINT[]),
    (784::BIGINT, 'De los mejores profesores de la escuela. Super recomendado, ayuda mucho a orientarse en el primer año, sabe muchísimo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-23T00:00:00+00:00'::TIMESTAMPTZ, '76ecd870c34f28317e91f592bff1ed7c3936406226f8edfe40beaf3e91d34387'::TEXT, ARRAY[4748]::BIGINT[])
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
