-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=8
-- TEC-DATA-META years=2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.735107+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (8::BIGINT, 'Busca que todos comprendan por medio de su amplia experiencia (pues tiene su edad ya) no le molesta explicar cosas que explico hace semanas porque su objetivo es que todo lleguen a entender todo lo que se pueda. No es exigente en los exámenes y las tareas como los quices son fáciles.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'ef742134c3554f608c31b9ec452879b13ffec0444f2213a45b34d32e25da51b5'::TEXT, ARRAY[1707]::BIGINT[]),
    (8::BIGINT, 'Es una eminencia, tiene ya una edad muy avanzada entonces tiene muchísima experiencia, así que no se anda con muchas cosas el tema de evaluar no lo toma con tanta firmeza como otros profes, está más interesado en que usted entienda lo práctico, es muy sencillo pasar con él.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2025-11-28T00:00:00+00:00'::TIMESTAMPTZ, 'b3bb8f18c2d208d765f5a56b3e7b52b03aed4ccff479eb6865ca32d2529fbd9a'::TEXT, ARRAY[1707]::BIGINT[]),
    (8::BIGINT, 'muy buen profesor, deja siempre los temas muy claros y es una excelente persona, logra que la clase sea entrenida y participativa, un profesor muy completo'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-03-03T00:00:00+00:00'::TIMESTAMPTZ, 'aecaa3a5a02f8d0d943a1ff660e30bf5d81b82ee191d0537d6f19c55ac27b9d6'::TEXT, ARRAY[1707]::BIGINT[]),
    (8::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '7be93fd44588264e88490156565ea83da12fff94133599e5ad85c15d7275f9cc'::TEXT, ARRAY[1782]::BIGINT[]),
    (8::BIGINT, 'Virtual. Es muy buen profesor trata que el estudiante entienda, es muy accesible. Las prácticas tienen algunos errores. Se pasa bien.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2022-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'f6d8f780606fc7aa19947d028f075216ec1faca6148295c5aeb1e455c7157095'::TEXT, ARRAY[2361]::BIGINT[]),
    (8::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases largas', 'Clases excelentes']::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'd55dfe4a9a68d0fa2810a6cf32c836474aa22cb158afce56a9f2c56a12539255'::TEXT, ARRAY[2361]::BIGINT[]),
    (8::BIGINT, 'Le importa mucho que los estudiantes aprendan de verdad y siempre está disponible'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'e33889f08c6d91cc4a85075e1a99d9c0e0b8d16b7ddc5072e6e3ca5fd23bd633'::TEXT, ARRAY[2361]::BIGINT[]),
    (8::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '9202f25fba825300400c8b98640949d11e580639c9c75a0b3e5c9da7a6a2b3d8'::TEXT, ARRAY[1782, 2403]::BIGINT[]),
    (8::BIGINT, 'El profe es pura vida y trata de explicar lo suficientemente bn, los exámenes y trabajos son sumamente fáciles , si es por pasar el curso, este profe es el ideal'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo']::TEXT[], '2022-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'dbe59b3e4e439ac948afc916f0a18e49511f27aa61796648aeb48343c40cbe9a'::TEXT, ARRAY[2403, 1782]::BIGINT[])
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
