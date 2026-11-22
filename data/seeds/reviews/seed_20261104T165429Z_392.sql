-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=392
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.205421+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (392::BIGINT, 'La cabra, no hay más'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2026-07-27T00:00:00+00:00'::TIMESTAMPTZ, '6342be915203bb12d49c11ca116a867e322eeabd78761a37011e8f11cd09913f'::TEXT, ARRAY[1252]::BIGINT[]),
    (392::BIGINT, 'Es muy buen profe, explica muy bien y los ejercicios que hace en clase se le entiende perfecto, pero los exámenes son ejercicios mucho más complicados comparado con los de las clases, prepárese para cosas complicadas en ese examen, después de ahí tareas muy chill y proyecto lograble, tiene futuro.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2026-07-23T00:00:00+00:00'::TIMESTAMPTZ, '4ba7d2c34ea1b4c73bbda911ecc31d25a2e55b2376baa7cd37f878889a95a0fb'::TEXT, ARRAY[1257]::BIGINT[]),
    (392::BIGINT, 'Es el profeso mas papeador'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2026-07-23T00:00:00+00:00'::TIMESTAMPTZ, 'f1d8249d04b9adf18674bd3fcf2852a3fe86e7fdcac4bc5cf6da016a87dfd73b'::TEXT, ARRAY[1411]::BIGINT[]),
    (392::BIGINT, '2 examenes dificiles pero Fabian es la cabra entonces si pasan'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Exámenes retadores']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, '6578acd8d3e32d999f731dc0e9eefc6130d2bc075527f32df623288ec1b1a7ad'::TEXT, ARRAY[1257]::BIGINT[]),
    (392::BIGINT, 'Es nuevo dando CC por lo cual se nota que está un poco verde como profesor, sin embargo creo que está encaminado a ser excelente, eso si preparense para examenes duros ya que los ejemplos brindados en clase son super sencillos comparados con los ejercicios de los examenes, además de ser largos'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Pocos exámenes', 'Exámenes retadores']::TEXT[], '2026-07-17T00:00:00+00:00'::TIMESTAMPTZ, '7bd6b59ba102c9332fc7fc1fee25c503b41ae9ad1418b9ef77c2d9585089b6da'::TEXT, ARRAY[1257]::BIGINT[]),
    (392::BIGINT, 'El curso en sí es facil, con solo llegar uno pasa. Pero el profe ayuda a despertar interes, nos salimos un poco del plan del curso pero con actividades mas relacionadas con la carrerra.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-03T00:00:00+00:00'::TIMESTAMPTZ, '638c42f339a93ae677feccd794f0d75876b0d5d17de2eb466179034333fbff0f'::TEXT, ARRAY[1252]::BIGINT[]),
    (392::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-11-21T00:00:00+00:00'::TIMESTAMPTZ, '47977f431ed17ce736dde3b94e28501a1d2183029374d744c4c7c3d81c7167da'::TEXT, ARRAY[1255, 1252]::BIGINT[]),
    (392::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'f970e430e670a579ea40686512af2ad831d8f38f721284c2f332a39d8a698f0a'::TEXT, ARRAY[1252]::BIGINT[]),
    (392::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '125757362fc7cd85ad8659b8a182e9aeee13f35a9760c4bf006d23a91bef19af'::TEXT, ARRAY[1252]::BIGINT[])
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
