-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1133
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.018964+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1133::BIGINT, 'La clase en sí es autodidacta ya que el profe solo da un documento con las instrucciones y usted es quien debe buscar cómo funcionan las cosas. Es muy fácil de pasar porque solo es de asistir y ya. El profe es buena nota y si uno le pide ayuda o no entiende bien algo, él con mucho gusto lo ayuda'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-08-17T00:00:00+00:00'::TIMESTAMPTZ, 'be77863f880255194a2f5f9f8bd879737e7241df02bcb88b9b69666733bf059d'::TEXT, ARRAY[1252]::BIGINT[]),
    (1133::BIGINT, 'Las clases son muy fáciles y el profe es buena nota. Para cada práctica deja un documento y usted tiene que buscar como hacerla (osea hay que ser un toque autodidacta) pero si uno de verdad no entiende él lo ayuda.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2026-07-21T00:00:00+00:00'::TIMESTAMPTZ, '8e88c2f5eaf45640b71ebc00456c67eabbd80b830e85bd88f635d74fc6a806a2'::TEXT, ARRAY[1252]::BIGINT[]),
    (1133::BIGINT, 'Solo deja un documento en el tec digital con la información de lo q tiene que hacer y de ahí ust ve cómo aprende. Si no sabe q es una protoboard, no recomiendo, aunq siempre tiene la opción de no hacer nda pq lo que cuenta es asistir. Ayuda cuando se da cuenta de q lleva mucho tiempo sin avances'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2026-07-06T00:00:00+00:00'::TIMESTAMPTZ, '6208abc378b0a39409ee55bdc1b6cc809eb9ee92ae47cabd560f5d421c7dd2dc'::TEXT, ARRAY[1252]::BIGINT[])
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
