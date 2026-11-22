-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=39
-- TEC-DATA-META years=2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.034545+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (39::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, '844f5778fe6f53adca632328f58c9bb1ae7c9f36568156c2e6cbd320a91544e0'::TEXT, ARRAY[1722]::BIGINT[]),
    (39::BIGINT, 'Buen profesor, las clases son algo largas y aburridas, pero si se pone atención a su clase, él explica muy bien, buena retroalimentación en las tares, exámenes muy duros.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Exámenes retadores']::TEXT[], '2021-11-08T00:00:00+00:00'::TIMESTAMPTZ, '6a55f625fcffcf44957c083bdab8eb0c98a7c97fc9c10d75c855b52937a122fb'::TEXT, ARRAY[1722]::BIGINT[]),
    (39::BIGINT, 'El mejor, ni lo piensen'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'ea46323e9fa21c4905904f92a995108ac41ee9362144d4525af7e7066e70ad4b'::TEXT, ARRAY[1722]::BIGINT[]),
    (39::BIGINT, '(Virtual) califica súper bien, es bastante claro, solo dos exámenes y un proyecto grupal, explica las veces que sea necesario, atiende dudas todos los días, muy amable y sus exámenes son largos pero no son duros, lo recomiendo bastante, y explica bastante bien con Excel para repasar después'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, '9024810291fd453a3eaf124f0ca32ca7e821da11c796e94780b70cabcd0ed622'::TEXT, ARRAY[1719]::BIGINT[]),
    (39::BIGINT, 'Es muy buen profesor, de los mejores en Limón, eso sí, tienen que ponerle, pues a el profe le gusta que los alumnos se esfuercen.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-26T00:00:00+00:00'::TIMESTAMPTZ, 'f7593f7b2bbd563c5d593f67c7fdabfeefceebf2532a9b70e98f01622098d19e'::TEXT, ARRAY[1720]::BIGINT[])
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
