-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=688
-- TEC-DATA-META years=2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.832655+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (688::BIGINT, 'La peor profesora, siempre llega tarde, hace exámenes virtuales y aunque un grupo de estudiantes lo hagan juntos y pongan las mismas respuestas tienen nota diferente. Sabe mucho de agronegocios en general pero como profesora es pésima, entrega y revisa trabajos cuando quiere.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Pocos exámenes']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '1f0fa5cbb939b1373bb4000cb3eac936cf6f78f106ebe09bc9dbeefa813cc596'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'La verdad la profe es muy irresponsable con las notas y mediocre con los exámenes. Hace exámenes en digital, los hacemos en grupo fuera del aula y aún así sacamos diferente nota ??? Muy confuso todo. La profe es calidad como persona pero mala profesora, siempre llega tarde.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2023-06-07T00:00:00+00:00'::TIMESTAMPTZ, '9c7bc137d0220fddb57404e2143166b3ed06ad14553984fa218ba5fa018ac7b0'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'Muy irresponsale para entregar notas y subir documentos, si da pereza estar con ella porqué le falta dinamismo pero entiendo y admiro lo mucho que sabe de los agronegocios y de la experiencia que tiene'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Pocos exámenes']::TEXT[], '2023-05-09T00:00:00+00:00'::TIMESTAMPTZ, '893e9de34d6f8dda0ebcb8d7e2d7e9e683e0384875ac24c7870adc27628c6d4b'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'Es una pésima profesora para el curso, no inspira a los estudiantes a seguir en la carrera. Es demasiado desordenada con las notas, las entrega cuando ella quiera y después no se le pueden hacer reclamos. Nunca contesta los correos. Ella conoce mucho de agronegocios pero es un pésima profesora'::TEXT, 10.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, '1989d0ac661403e5978b128219d1f94652994ed6e43bcfdcae7e1b1ecfc65515'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'es irresponsable ya que califica a lo ultimo ultimo'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases largas', 'Pocos exámenes']::TEXT[], '2022-07-28T00:00:00+00:00'::TIMESTAMPTZ, 'ad74219c9655032d45f65cb41175eba84a2da69b0e1cad40931281c1d3cb435a'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'Super irresponsable, entrega notas 1 día antes de la entrega de actas, no se puede apelar nada, desmotiva demasiado, entra a clase a la hora que quiere, no recomendada'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ec0e8cdd76987bd9232464ba52db23ce1c0a686911f82a52fd259b467c518944'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, 'ebdab3a4bdb85665fca2eb7bd63bcc111cd0db60752f3076dcaf9287ae7881ab'::TEXT, ARRAY[2596]::BIGINT[]),
    (688::BIGINT, 'Es una pésima profesora para el curso de introducción, siempre se atrasa en la hora de clases y nunca se sabe de donde saca las notas, ya que da las notas 3 días antes de la entrega de actas, es la peor profe de carrera que he tenido y además desanima en la carrera, por la falta de compromiso'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-05-04T00:00:00+00:00'::TIMESTAMPTZ, 'ebc122df5b7e69d4fe8482e4b1077e6d6fcc52da529c4e4a68c0832e28233c4d'::TEXT, ARRAY[2596]::BIGINT[])
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
