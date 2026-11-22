-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=204
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.883277+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (204::BIGINT, 'Es pésimo, evítelo ya que no explica nada, no hace ejercicios de práctica y realmente no se le entiende. Sus clases son aburridas y la única ventaja es que no hace quices'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2026-06-16T00:00:00+00:00'::TIMESTAMPTZ, '43b172c00ac080e864c08850458f24021c7b532080b6354d0bf5055a313eabaf'::TEXT, ARRAY[604]::BIGINT[]),
    (204::BIGINT, 'Para mi es el mejor profesor de Física del tec, te enseña desde lo mas básico y se preocupa por que aprendamos, es el mejor profesor para aprender y pasar las físicas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-04-19T00:00:00+00:00'::TIMESTAMPTZ, '7e202af9af4e96d7ecda88f1493ce47fb1140c3e5a8b30078bd701e4eda4c41c'::TEXT, ARRAY[630, 604, 1423]::BIGINT[]),
    (204::BIGINT, 'El profe puede dormir un poco, ya que tiene un tono algo monótono, pero da buenas clases. AVISO, NO ES NECESARIO QUE UNO REQUIERA CÁLCULO PARA PASAR, pero sí te va a dar clases con la mentalidad que todo lo relaciones con CDI. Me gustó sus clases, pero en definitiva uno se duerme. Es buena opción.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Tomaría su clase nuevamente']::TEXT[], '2025-08-16T00:00:00+00:00'::TIMESTAMPTZ, 'e32c8b8e896603f7a655f5d49af13940375bc6d4e14c3d784ba7b09e22ee7810'::TEXT, ARRAY[604]::BIGINT[]),
    (204::BIGINT, 'Ha sido el peor profesor con el que he recibido clase, no se entienden sus explicaciones, tarda demasiado calificando por lo que no vas a saber cómo vas hasta muy tarde. Él solo retrasa la clase y después se queja de que "vamos" atrasados cuando es culpa de él.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Pocos exámenes']::TEXT[], '2025-06-22T00:00:00+00:00'::TIMESTAMPTZ, '8aa1307375f0ca0a8875b11d08f99f4500a43a1bbb438bcf0070cd2eb14a955c'::TEXT, ARRAY[604]::BIGINT[]),
    (204::BIGINT, 'Fisica 2 es dificil, el porfe sabe mucho pero a veces explica conceptos que no vienen en el examen, sin embargo, lo hace de forma clara. He escuchado cosas peores de otros profes.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2024-08-03T00:00:00+00:00'::TIMESTAMPTZ, 'a393086c390c1840bec07278dfcad494f5bed0a85e3e7718a33c74beac3bbf7d'::TEXT, ARRAY[630]::BIGINT[]),
    (204::BIGINT, 'El mejor profesor de física que cualquiera desearía excelente explicando las cosas, nunca ocupe el libro para entender, más bien el ya tiene toda una metodología para que justamente ud comprenda la materia como se debe y sin enredarse con el libro. Las clases son largas pero es la mejor explicación.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Clases largas']::TEXT[], '2024-03-01T00:00:00+00:00'::TIMESTAMPTZ, '460a4e29fba4869a35f6aa790b6f43e0851462cb7dbd0fc8b7170efdc0e11aa9'::TEXT, ARRAY[604]::BIGINT[]),
    (204::BIGINT, 'Las clases son sumamente practicas, a la mayoria lleva algun experimento o al menos nos saca para realizar alguna actividad y comprender los temas de la materia no solo de forma teorica'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-02-15T00:00:00+00:00'::TIMESTAMPTZ, '0bfab49a67f6adcc43e99554bbe43b34ada5df80bf8b57d2b648772b070a68c8'::TEXT, ARRAY[630]::BIGINT[])
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
