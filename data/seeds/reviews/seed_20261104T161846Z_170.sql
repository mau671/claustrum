-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=170
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.792185+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (170::BIGINT, 'No veo este curso como primera opción para llevar la cultural, en verdad uno esperaría algo mas chill pero el mae mete bastantes bretesillos y los trabajos no los indica el si no el cronograma. Pienselo dos veces antes de meterlo, y que tanto necesita la cultural.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2026-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'ea3d6a5f8b13f395bf4166867a984d54b3a608a50e820f487afca0c8e891e7be'::TEXT, ARRAY[499]::BIGINT[]),
    (170::BIGINT, 'Un curso bastante entretenido y fuera de lo que uno está acostumbrado. Las clases son dinamicas, se hacen actividades fuera del aula. Eso si, hay que hacer tareas y exposiciones pero son bastante sencillas y la evalucación es suave. Vaya con la mente abierta y algo nuevo se termina aprendiendo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas']::TEXT[], '2026-07-07T00:00:00+00:00'::TIMESTAMPTZ, 'f904a7060d9b09af386209a00f792a01f106779270e7f9dca2b8bce9522b1689'::TEXT, ARRAY[499]::BIGINT[]),
    (170::BIGINT, 'En este curso hay que pasar exponiendo y haciendo trabajos suele ser aburrido e injusto para valer 0 creditos, ademas que el profesor es de izquierda y todas sus clases se basan en hablar mal del oficialismo. Si usted apoya al FA lleve este curso aquí si vas a tener la minima atencion'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2026-05-26T00:00:00+00:00'::TIMESTAMPTZ, '04d4ba3ed425cff1b9f3e8eb7c99142ca06723b1751aa9e38da01614bd4091cc'::TEXT, ARRAY[499]::BIGINT[]),
    (170::BIGINT, 'Me gustó su clase. Hay que trabajar siempre en grupo y socializar, estar en movimiento constante. Una clase diferente que se puede tener en un semestre pesado y que le devuelve a uno sentirse humano durante el rato.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2025-12-13T00:00:00+00:00'::TIMESTAMPTZ, '3cece18f8d6ffa7911434c3f468b3baff05937077d88a8c63f424904dce9914e'::TEXT, ARRAY[499]::BIGINT[]),
    (170::BIGINT, 'Profe muy creativo y empático, hace las clases interesantes y le gusta que participen, utiliza juegos y actividades al aire libre. Muy pura vida.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'd49b95969f04d1db2517b0e9a6addd557c30c4a6c5f235972fe1419418f51712'::TEXT, ARRAY[499]::BIGINT[])
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
