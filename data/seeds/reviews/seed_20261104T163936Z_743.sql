-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=743
-- TEC-DATA-META years=2018,2020,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.235331+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (743::BIGINT, 'Un profe ordenado y considerado con los estudiantes, es amable y responde dudas super rápido. Sus clases siempre son claras y también los aspectos que va a evaluar. No califica duro, pero las cosas tienen que estar bien hechas (lo normal). Es un gran profe!!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'aa6e974336a1488003266786356e2bd6b90e06cc0ba9c1daf16e45f527984a5f'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Un profe super ordenado, nuestra clase era en la noche y regalaba té, café y llevaba algún bocadillos. No califica duro, pero le gusta que las cosas estén bien hechas. Sabe muchísimo también, es un profe excelente'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2025-01-17T00:00:00+00:00'::TIMESTAMPTZ, 'e5a09e30c98c4e7436882a56eaee6a76d2c7e7cae785035d0fa8f4d53d273575'::TEXT, ARRAY[3282]::BIGINT[]),
    (743::BIGINT, 'Super ordenado, brinda apoyo y da pistas. Muy buen profe, explica de manera clara.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-25T00:00:00+00:00'::TIMESTAMPTZ, '68a3f7f73ea6e25a1f33de5538ee8fd22799c181712f5c8e713ca67c9d19936c'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Es un profe increíble. Muy ordenado y explica muy bien. Los exámenes pueden ser un poco complicados, pero él mismo da pistas sobre cómo resolverlos. Siempre está dispuesto a atender las dudas de los estudiantes, le interesa que aprendan. ¡Recomendado para este y cualquier otro curso que dé!'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2023-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'ee0abf46c0a2edc84e0e1b37d5e82bc19060d6bad63045921eb02253aafb47c2'::TEXT, ARRAY[1779]::BIGINT[]),
    (743::BIGINT, 'El profe explica muy bien, siempre está dispuesto a ayudar a los estudiantes y responde los correos muy rápido; sin embargo, califica duro en los trabajos y en los exámenes.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'f874446a0783e36b337652ba8e868289b69ed6acfd8093de0da6ff3560669236'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Es súper ordenado y siempre está demasiado dispuesto a ayudar en lo que uno necesite.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-10T00:00:00+00:00'::TIMESTAMPTZ, 'bb82e6a7f94f591659f603335e7e033ef628300f3fb9784b6775a81663d0ad80'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Un profe excelente, literalmente es un Dios de otro nivel el su área, explica muy bien, es ordenado, mantiene las notas actualizadas, es respetuoso, para nada grosero, muy neutral y siempre está dispuesto a ayudar, contesta correos literalmente cuando sea y a cualquier hora sin problemas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2021-06-27T00:00:00+00:00'::TIMESTAMPTZ, '2495f3784316fa9ecc608363f1095e6b36068e2f63ae26e27b0e8f58bd2d9086'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'El profe es bastante serio, pero muy bueno, las clases se tornan un poco aburridas por lo largas que son, pero si le ponen atención son muy provechosas. Sabe muchísimo del tema y está anuente a aclarar dudas y ayudar a los estudiantes como pueda. Los exámenes son complicados pero no exageradamente'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, '6976df193cff0a564ea0274cf24c55f5b752a11034c36aba2f6d54a83040d668'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Muy buen profe, le interesa que el estudiante aprenda y siempre está disponible para atender cualquier duda. Sus exámenes son un poco complicados pero no califica muy duro (tampoco califica suave...)'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '15803513891ffdd8da875cc4d3f2d69fd379b219052d96e2c024f66b1f60c4a3'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Las clases son un poco aburridas porque son muy largas y magistrales, no obstante el profe ayuda muchísimo con cualquier duda y sabe DEMASIADO del tema, entonces si estás interesado en la materia podes aprovechar la clase demasiado.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Aspectos de calificación claros']::TEXT[], '2020-08-16T00:00:00+00:00'::TIMESTAMPTZ, '7acba2042a1fa79dd3c8c47da41a74e50e5c6069e2ea467f24e73b7a436cc7f4'::TEXT, ARRAY[3281]::BIGINT[]),
    (743::BIGINT, 'Muy bueno, un poco aburrido por el tono de voz. Excelente calificando, no demanda mucho.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'fc35e1814b26eab0bf5fa04dd7551d2a01a2e4b82d18d4c2d4051dd25d33534d'::TEXT, ARRAY[3281]::BIGINT[])
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
