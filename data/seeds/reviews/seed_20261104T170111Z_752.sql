-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=752
-- TEC-DATA-META years=2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.014980+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (752::BIGINT, 'La peor de licenciatura !'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Clases largas']::TEXT[], '2025-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'd3a71bcb3148c2c88a956f1e717e6b9f2f18c9ea93e7064117906039ab8eecf0'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'No da retroalimentación durante el semestre y termina calificando duro . No da recesos'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Clases largas']::TEXT[], '2025-12-02T00:00:00+00:00'::TIMESTAMPTZ, '87a5da6a8471604eceba412b221a6727cccb427d3b203871a10aa7d141eff2ec'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'Las evaluaciones no siempre son totalmente sencillas y claras'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-09-02T00:00:00+00:00'::TIMESTAMPTZ, '979a881ba7cb6c1fbd1892be28fd264cf57a16039ebc070bffe1da25c4faac14'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'Una profe que es una mierda de persona, nunca llevaría con ella, dice una cosa y después dice otra y califica mal, No recomiendo ir con ella, si no quiere aprender lleve con ella.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2025-06-27T00:00:00+00:00'::TIMESTAMPTZ, '8b22084aac73f5469edc156a64784f9ca313eb15aaeeda648b45ab70fec09136'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'La profesora tiene muchísimo conocimiento. Les va a enseñar como se hacen las cosas en la vida real. El proyecto vale casi todo el curso y es pesado, pero se aprende mucho haciendolo. No da mucha ayuda en el proyecto porque espera que lo descubramos solo, pero intenta guiarnos. Es muy buena.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2024-11-08T00:00:00+00:00'::TIMESTAMPTZ, 'ee393cf23566d9c220fe72b20300ec1b956f8adfef3d27fd5abdb97afd0c5272'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2024-03-07T00:00:00+00:00'::TIMESTAMPTZ, '8cc5840effafd678b7aa962c1e933f9a828f5cb45ca8970751015929120fac11'::TEXT, ARRAY[310]::BIGINT[]),
    (752::BIGINT, 'La profesora tiene mucho conocimiento. Cae muy bien y trae muchos expositores. Califica duro y casi ni brinda ayuda en el proyecto. Consiga un buen grupo porque el proyecto es pesado. No brinda aspecto de calificación claros pero sí garantiza que se aprende bastante. Participe mucho.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Muchos proyectos grupales']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '3ddc9d14d7c85ac903a9a0a3736c19e6f22dc92228cbe7dffad8d30c814e99aa'::TEXT, ARRAY[3433]::BIGINT[])
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
