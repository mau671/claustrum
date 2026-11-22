-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=24
-- TEC-DATA-META years=2020,2021,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:34:23.271688+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (24::BIGINT, 'Pésimo profesor. Fue muy grosero con los estudiantes. Si la respuesta no es exactamente como él espera, la nota suele ser muy baja o 0. No comparte las presentaciones y se molesta si un estudiante toma fotos de la pizarra o pide volver a una diapositiva. JAMÁS VOLVERÍA A MATRICULAR CON ÉL.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '9e6c36db36f73680def1b543c036b14ea5c9e698ccc9eabbc46cda665f169fc4'::TEXT, ARRAY[1883]::BIGINT[]),
    (24::BIGINT, 'El profesor Allan es grosero, no fomenta el pensamiento crítico ni el debate en clases. Te pone un 0 si no escribe lo que dice la presentación la cual no pasa entonces tenes que estar tomandole fotos a la pizarra o a un teams., No existen trabajos prácticos. NO MATRICULAR CON EL NADA EVITEN'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Pocos exámenes', 'Exámenes retadores']::TEXT[], '2026-05-31T00:00:00+00:00'::TIMESTAMPTZ, '85c9d82d83583939adc86b1d85a8657130c34089c0d6338e522dafa48eb98a7c'::TEXT, ARRAY[1883]::BIGINT[]),
    (24::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Pocos exámenes']::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, '4ca9783bc0ced7c569a7dfa2df5ea1e9098f2819539086cdc8be4aab94bdb0ec'::TEXT, ARRAY[1883]::BIGINT[]),
    (24::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'eba2383776e6cfc28df5ba29d2bb4cb33f8ec5ecd029d72b06ef49375ce08a2f'::TEXT, ARRAY[1883]::BIGINT[]),
    (24::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '9699dbe28cd75fbbad16133420552a17f40069cfefc5d7bfdc1a3e28e803d251'::TEXT, ARRAY[1883]::BIGINT[]),
    (24::BIGINT, 'Es un profesor muy pura vida y respetuoso. Las clases son entretenidas. Lee las filminas pero da muchos ejemplos, no las comparte entonces tómele screenshots. Los trabajos que deja son sencillos y si estudia los pasa bien. Los examenes son sencillos y el proyecto también. 100% recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-11T00:00:00+00:00'::TIMESTAMPTZ, '4b8a439632328b2e6e6f24c64e40cd0cf8a29347bd71e320c58fee72fbeec81a'::TEXT, ARRAY[2472, 2470]::BIGINT[]),
    (24::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-26T00:00:00+00:00'::TIMESTAMPTZ, 'c5026ae4109f03ecf7fae24f5ce1cd3e3f8a3d24ef1ed0335ec6533842f095c7'::TEXT, ARRAY[1883]::BIGINT[])
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
