-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=77
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.063826+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (77::BIGINT, 'De las mejores profesoras que he tenido. Sus clases parecían como de colegio incluso. Es una profesora muy amable que se preocupaba por el desempeño de sus estudiantes. Nos dejaba hacer el reporte de lab virtual, y los quices también virtuales. Hizo que el curso se volviera muy fácil de pasar.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ, '360c0ce7a07d6b15c4b5c96a1c9295d97c3940fe03abc3b2861f2ec4edf0a4cf'::TEXT, ARRAY[1979]::BIGINT[]),
    (77::BIGINT, 'La profesora es muy buena gente, muy amable, graciosa incluso. Es de sus primeras veces dando el curso entonces ocupa aún encontrar el ritmo, pero no lo hace mal. Sabe del tema y sabe de las técnicas. Te deja un poco independiente. Eso si, estudie para sus exámenes; dos toques y mete 100 preguntas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, '431a3c3168a598ec03f86e15da3ffcbaf355aa4844ae4281845d1c8d75c0c494'::TEXT, ARRAY[3286]::BIGINT[]),
    (77::BIGINT, 'La profe es muy buena gente y en los labs se pasa bien pero califica duro, muchas veces en clase tiene un desorden que enreda a los mismos estudiantes y los perjudicados somos nosotros. No recomendaría llevarlo por el desorden que maneja la profe sin embargo es muy buena persona'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-01T00:00:00+00:00'::TIMESTAMPTZ, '67b627fac4d5cf8a52106c5149eb6265ea353c486caa8499072d01483acf4206'::TEXT, ARRAY[1979]::BIGINT[]),
    (77::BIGINT, 'Es bastante amable y se preocupe en que los estudiantes aprendan'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'd28a0b1b5e1f7959a8aa03c0ed97214fdf772cdffb769a3a04a21f5f26e5e9f9'::TEXT, ARRAY[1979]::BIGINT[])
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
