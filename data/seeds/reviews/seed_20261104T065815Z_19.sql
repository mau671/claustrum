-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=19
-- TEC-DATA-META years=2016,2018,2022,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T06:58:15.268639+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (19::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-11T00:00:00+00:00'::TIMESTAMPTZ, 'b097691c6910e18a1288eacf9cd743203271c962b9243cac55764fd5eb596b57'::TEXT, ARRAY[3518]::BIGINT[]),
    (19::BIGINT, 'El profe en si no es malo, solo que si hay que dedicarse más tiempo al curso del que uno esperaría, evalúa cómodo y es bastante accesible si se plantean ideas de propuestas para cambiar la evaluación. Si quiere aprender del curso le toca leer bastante.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Da buena retroalimentación', 'Requiere mucha lectura']::TEXT[], '2024-08-13T00:00:00+00:00'::TIMESTAMPTZ, '47a46887e183b7edd69154d14a47f7f07e031b84c14fdc6e76d9776331a0d98a'::TEXT, ARRAY[92]::BIGINT[]),
    (19::BIGINT, 'Hace las evaluaciones muy difíciles, y explica poco'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2024-05-08T00:00:00+00:00'::TIMESTAMPTZ, '47cec7665718fd4bcf5ff054b5ec92b4193bb8833c7dc1f2146cbb04b7723d60'::TEXT, ARRAY[92]::BIGINT[]),
    (19::BIGINT, 'Los temas son complicados de entender ya que no realiza los ejercicios en clase, se basa en muchos libros y asume que puedes leerlos todos en un semestre y entender el tema.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura']::TEXT[], '2022-11-23T00:00:00+00:00'::TIMESTAMPTZ, '3addcfa2277e4a82cc141a7502130db426cc945291b75a6cb7889f006d8c3a2b'::TEXT, ARRAY[1782]::BIGINT[]),
    (19::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Clases largas']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'f1bc138a46f5645ba481dd528c41612db811a7b390e1fce3dbd9039b716fe77d'::TEXT, ARRAY[2475]::BIGINT[]),
    (19::BIGINT, 'No es claro en las asignaciones de tareas. Las diapositivas que utiliza no son claras, son hasta desordenadas y de ahí es donde uno se basa para realizar trabajos. El material de clase lo envia posterior a la clase, donde lo usual es al inicio para aclarar dudas.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-09-05T00:00:00+00:00'::TIMESTAMPTZ, '680d1a1298e3c15d4a9394163a5fb03ce894b1becd504fbfa3b68ba69b597f6b'::TEXT, ARRAY[3518]::BIGINT[])
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
