-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=338
-- TEC-DATA-META years=2014,2016,2018,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.143411+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (338::BIGINT, 'Demasiado buena persona, lo quiero mucho. Es una joya adquirida del tec, le sabe a todo. Demasiado profesional y bueno. Hablenle bonito, cae bien. Le gusta star wars'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-10-29T00:00:00+00:00'::TIMESTAMPTZ, '705b5203d681192d677643b70f4e464cfa21e2b20d37c5671bd52c5b4cb49fbd'::TEXT, ARRAY[1030]::BIGINT[]),
    (338::BIGINT, 'Excelente persona, único problema es que es demasiado bueno.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('5','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-21T00:00:00+00:00'::TIMESTAMPTZ, '47cfcc08792006df72ed8fddd7e3f3a22a9884b47bc13c88ffe2e624110ac596'::TEXT, ARRAY[1030]::BIGINT[]),
    (338::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2018-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'f7e371fc305cda6099d165e5aa04e756a2c6b9e8cb9fb428d0a0347db6f49cf3'::TEXT, ARRAY[1030]::BIGINT[]),
    (338::BIGINT, 'Un profesor de primer orden, exelente persona.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ, '4626176edbce41c1f793c7b876e8e67d5af0dda951e92fe297da36810f3a6731'::TEXT, ARRAY[1030]::BIGINT[]),
    (338::BIGINT, 'De los mejores profesores que hay del TEC, super profesional y muy bueno explicando'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-02-05T00:00:00+00:00'::TIMESTAMPTZ, 'e3a6ff4cd15728ca0f1b3ac707c0aee5ceab5cf84f5d46920d65ffb5de836c21'::TEXT, ARRAY[1037, 1030]::BIGINT[]),
    (338::BIGINT, 'Muy profesional, explica excelente. Se preocupa porque el estudiante entienda. Sabe mucho y tiene mucha experiencia.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'b4d8556f161ebe901bbfd36b7641ae3c2310605ef0792e1eef30adfde996823c'::TEXT, ARRAY[1030, 1037]::BIGINT[]),
    (338::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'ffb8674c42fb63823e8240fd6292cef79b82356c06fb742382d2ed2a7080cb25'::TEXT, ARRAY[1020, 1022, 1037]::BIGINT[]),
    (338::BIGINT, 'Explica excelente y sabe demasiado. Me gusta que abarque temas relacionados con un buen diseño y código limpio. De los mejores profesores del TEC.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-18T00:00:00+00:00'::TIMESTAMPTZ, '522e03d4f6f377d6f5a1e18afa25c4224b4ec34e9faaba350b1966f75605adc1'::TEXT, ARRAY[1030, 1037]::BIGINT[]),
    (338::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, '5d11ad68afcc1a204750ce6cb36e8e5a57dd2bfa17d7674609c624a616bb64a3'::TEXT, ARRAY[1030, 1037]::BIGINT[]),
    (338::BIGINT, 'El profe sabe un montón de diseño y POO. No califica tan duro y está abierto a explicar que hizo en los proyectos (a diferencia de los profes que sólo califican funcionalidad). El único problema es que algunos temas no los abarca mucho.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, '791f9ae48c27100ac565b81d8e285bd0c6307eee7be2937c128710ff34397068'::TEXT, ARRAY[1030]::BIGINT[])
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
