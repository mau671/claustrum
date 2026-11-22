-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=307
-- TEC-DATA-META years=2014,2015,2016,2017,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.942897+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (307::BIGINT, 'Se pasa bastante fácil si usted entrega todo, los examenes no valen tanto y son bastante fáciles, y para los labs él deja los ejercicios desde un par de dias antes, y es flexible con las fechas de entrega, muy liviano el curso con él.'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-04T00:00:00+00:00'::TIMESTAMPTZ, '5fa6da9eeb294856f9d060154b7374909943f2857f5aa9b84394aa0cf8c603a4'::TEXT, ARRAY[1253]::BIGINT[]),
    (307::BIGINT, 'El material que da es bastante útil y muy bien resumido, con eso basta y sobra para pasar el curso con excelente nota. Los trabajos no son largos, pero están bien pensados para que uno aprenda bastante. El volumen de trabajos no es nada pesado, pero da todas las notas hasta el final de semestre.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '195937014977fec44ab137cf6d40bc7468722145088f140798f42f5ea8cf4361'::TEXT, ARRAY[1154]::BIGINT[]),
    (307::BIGINT, 'NO MATRICULEN, es mejor esperarse y llevarlo con otro profesor lo digo por experiencia.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-07T00:00:00+00:00'::TIMESTAMPTZ, '195b76d571ab1a8a854d6104d276944a451722a870983cd98c33063a349dd348'::TEXT, ARRAY[1253]::BIGINT[]),
    (307::BIGINT, 'No explica los temas con claridad y algunos ni los explica. De un grupo de 30 pasan solamente 8 a lo mucho.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, '1dee2f624ccf24d002dc7bd2357842b1912acf79f49262c61b95a90c8ab6aff3'::TEXT, ARRAY[1249]::BIGINT[]),
    (307::BIGINT, 'Terrible. No se esfuerza en las clases ni le interesa que uno entienda. Deja proyectos muy difíciles con intrucciones confusas y es casi imposible contactarlo porque no contesta correos y se esfuma cuando termina la clase. Arruina un curso muy lindo. Evitar a toda costa.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Muchos exámenes', 'Exámenes retadores']::TEXT[], '2017-01-12T00:00:00+00:00'::TIMESTAMPTZ, '065c35e70bce14978fbd6f06a6a22255ce0a45ac1e3f5078e246e50c60026cdf'::TEXT, ARRAY[1253]::BIGINT[]),
    (307::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'f59e7f9d9f81f7ad57b3c5668375715ea0660dc33a1825f6e24076b472a3acb9'::TEXT, ARRAY[1249]::BIGINT[]),
    (307::BIGINT, 'El y su cursito de Computacion online'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-07-04T00:00:00+00:00'::TIMESTAMPTZ, '5bf027c72eed98136e35006d9b85b0a4a4994cf5c34ad11b603acea82adfbfe8'::TEXT, ARRAY[1029]::BIGINT[]),
    (307::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('20','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'e3f5c14204a0d71a38edb2669a4b7e8500e01d3003a57d62ebf5d7c2ce09029b'::TEXT, ARRAY[1029]::BIGINT[])
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
