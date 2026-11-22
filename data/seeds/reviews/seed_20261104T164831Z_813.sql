-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=813
-- TEC-DATA-META years=2018,2019,2020,2021,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.865477+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (813::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '3d073afda1cc8581f2d86dfb3ee06925a93e6d8c694dedf83296920e0d33c935'::TEXT, ARRAY[2439]::BIGINT[]),
    (813::BIGINT, 'Hay que ser autodidacta, tiene que andar uno preguntandole a otros profes, porque ella quiere que aprendamos solos.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-11-03T00:00:00+00:00'::TIMESTAMPTZ, 'b4a43a72fa3b9126576c6a905e30a85e402517242a7501eab5462dc0b3acb1e7'::TEXT, ARRAY[634]::BIGINT[]),
    (813::BIGINT, 'Es una muy buena persona pero se pierde bastante en las explicaciones, llegando a incluso a usar expresiones que solo ella se entiende. Llevelo si sabe ser autodidacta'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-01-28T00:00:00+00:00'::TIMESTAMPTZ, '701f71b78ff856eede45835d000668607574b778e7416becbac1ddd23c5dbb27'::TEXT, ARRAY[634]::BIGINT[]),
    (813::BIGINT, 'No es tan mala profe ni mala persona, pero dura DEMASIADO en entregar calificaciones.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo']::TEXT[], '2024-11-12T00:00:00+00:00'::TIMESTAMPTZ, '2114679940b4ddf4f712334c7985c8765361ae2c30c1fb7c1b661b5565953ae8'::TEXT, ARRAY[935]::BIGINT[]),
    (813::BIGINT, 'De las mejores profes que he tenido en esta universidad, ella es muy amable con el estudiante. El curso no es de las cosas más fáciles, pero ella siempre trata de ayudar al estudiante, en los exámenes siempre busca rescatar puntos para que uno no salga tan mal. La recomiendo full.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2024-01-11T00:00:00+00:00'::TIMESTAMPTZ, '10c8d05b8b3601cd9a14fafb75cbc8696bc421580529ef69868de3ee50586671'::TEXT, ARRAY[605]::BIGINT[]),
    (813::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos']::TEXT[], '2023-10-10T00:00:00+00:00'::TIMESTAMPTZ, 'a5220936e579fc0771e3f95c118896e53bbf6e949913aaf0469475a91c4da6a6'::TEXT, ARRAY[605, 634]::BIGINT[]),
    (813::BIGINT, 'Realiza los quices a base de ejemplos visto en clases y la practica semanal, califica como es pero en los parciales ayuda a salvar puntos. Las clases sin largas por horario y ella intenta hacer trabajos en grupo para no aburrir. Se recomienda participar.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '709fbae0ae80dbf4f529bcbea6df0bb1bc91c2644bf8644361bf939691e0a6e4'::TEXT, ARRAY[563]::BIGINT[]),
    (813::BIGINT, 'Honestamente para mí es la mejor profe de todo el TEC, si usted pone verdaderamente su atención el curso se pasa solo, ella explica con muchos ejemplos y repite las veces necesarias para que pueda entender. Para ser clases de mate, son bastante entretenidas. Califica muy bien'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-31T00:00:00+00:00'::TIMESTAMPTZ, '40a3aafb227981425d520af7431a798a25c3cd596630e67193e2cb9b2266a500'::TEXT, ARRAY[563, 935]::BIGINT[]),
    (813::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '708ad2d02c87d3f3f198024cbc732e5311f1fa010b1c5c9f8b21371a529c085f'::TEXT, ARRAY[1018]::BIGINT[]),
    (813::BIGINT, 'hace los quices muy volados de la materia.deja unas tareas muylargas'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Exámenes retadores']::TEXT[], '2019-02-06T00:00:00+00:00'::TIMESTAMPTZ, '4bc2e797f91ea24e10632d8ce7b1242d2b698c3b31f772f40e5ccd8822c80a00'::TEXT, ARRAY[563]::BIGINT[]),
    (813::BIGINT, 'Parece ser muy seria, pero es muy amable y comprende al estudiante, ademas se nota que le gusta dar clases, de los pocos profes de TEC que tienen idea de docencia. EXCELENTE!!'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-12-06T00:00:00+00:00'::TIMESTAMPTZ, '0d7a2a4b244655d599d43f1c742b75c83d694c8154f76d5ea1bc670e6973d09d'::TEXT, ARRAY[605]::BIGINT[])
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
