-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=384
-- TEC-DATA-META years=2014,2015,2016,2017,2021,2022,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.951683+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (384::BIGINT, 'Es un muy buen profesor, pero va bastante rápido con la materia porque señales es bastante materia pero explica muy bien y resuelve ejercicios que ayudan a entender. Si usted tiene dudas él le ayuda a entender.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-02-04T00:00:00+00:00'::TIMESTAMPTZ, '1e443cf25b0e2f5bd8017553ffeaf2e0e719f756117e0745c6d8fe7deb6f6a3b'::TEXT, ARRAY[1296]::BIGINT[]),
    (384::BIGINT, 'De los mejores profes que tiene Alajuela, si no el mejor, explica demasiado bien, le interesa que usted entienda.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2024-01-18T00:00:00+00:00'::TIMESTAMPTZ, '617dd2626384544394f0826f48c21c5988de3ee518645c49a7823d4991c6d7ff'::TEXT, ARRAY[1267]::BIGINT[]),
    (384::BIGINT, 'Puede ser un curso complicado, pero el profesor brinda el apoyo necesario. Da ejemplos útiles y explica la teoría sumamente bien. Definitivamente, se hace un curso muy amigable gracias a él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-07-13T00:00:00+00:00'::TIMESTAMPTZ, '078caa7c63a70b5be75129e7911e4f63af83c120c1165a241c97b1c4eb383187'::TEXT, ARRAY[1267]::BIGINT[]),
    (384::BIGINT, 'Creo que es su primera vez dando este curso, se nota que es un buen profesor, aunque realmente estaba muy perdido a lo largo del semestre con la teoria a enseñar. Es importante resaltar que los examenes son catedraticos, por esta razon le quedaba muy corta las explicaciones que brindaba.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2021-01-22T00:00:00+00:00'::TIMESTAMPTZ, 'f96c892e92afd433c027bb946935739faab66592daa5c8cf8ffbed1131f916ff'::TEXT, ARRAY[1267]::BIGINT[]),
    (384::BIGINT, 'No hay forma de perder el curso con él. Explica excelente tanto en clase como consulta, el curso con el no es pesado. También da ejemplos de cómo se aplican los temas y conceptos en la vida cotidiana. Práctica antes de los exámenes, los cuales son fáciles.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2017-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'c3979be8ddca61874dfc1f0b5a74b51d1e808929347ac9f2d6fdd21f41b69f55'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'Excelente explicando siempre da un repaso de lo visto la semana anterior, las evaluaciones son sencillas por lo general en grupos'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'ad8cd08184c35716d8f9285755031dfc9050b51daf82a18cd85349fd0324731c'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'El curso es muy fácil. El profe en sí no le da la importancia al curso que amerita. Son créditos regalados.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, '4c13128f54539fa2767b32cfa3ef5b4c41ac33447a2fa5dd7e9438b8a9f1030a'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'De los mejores profes que tiene el TEC, es un ángel caído del cielo, simplemente el mejor!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'a9d2870a1dec88a1a7e41a5684fd3c13cbfb8a5fe031c0586b4138595c915269'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-08T00:00:00+00:00'::TIMESTAMPTZ, '0aac3ac3ea0d59ae90defa17a6682ba0101000fa2ae97a3fefa97199431f5aa7'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'Muy facil'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'bf59237cf33056843e398e65765fc3ee50a9927194aad18ce1ae4b9f46c7a8c9'::TEXT, ARRAY[1277]::BIGINT[]),
    (384::BIGINT, 'Explica excelente, las evaluaciones son claras'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-17T00:00:00+00:00'::TIMESTAMPTZ, '1a7f9638c267d0a1770b59b48662e72f494b9169c3926a2cd7f78648113a8ade'::TEXT, ARRAY[1277]::BIGINT[])
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
