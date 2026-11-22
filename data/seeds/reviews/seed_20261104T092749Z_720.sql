-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=720
-- TEC-DATA-META years=2015,2016,2017,2018,2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:27:49.825506+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (720::BIGINT, 'Busca parciales viejos por que simpre los repite, busca mucho la ayuda de la profe para entregarle lo que la profe quiere, sus clases son largas pero muy interesante'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-08-05T00:00:00+00:00'::TIMESTAMPTZ, '518bc5fea48ff56cb9a16cd5a86980afb3f5865e0718d90f884fae6f88d9b34a'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'No es mala explicando, pero hace preguntas en el examen super específicas y hay que leerle la mente para tener los puntos, quita puntos por cosas insignificantes y es una pérdida de tiempo hacerle consultas'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '7fb65dcce73f62022578d2d4fd8a4deef1a692eda03d3a5222df3d873fcc7c57'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Es flexible, graciosa a su manera y sabe explicar bastante bien'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Brinda apoyo']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '0675e232f849d0878ea6f440228347e4ca0ee2c6a6b131913eca941e071883da'::TEXT, ARRAY[3277]::BIGINT[]),
    (720::BIGINT, 'Excelente profesora. Super amable, ayuda demasiado. Sabe un montón y explica de forma super clara. Llevaría otros cursos con ella.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-05-31T00:00:00+00:00'::TIMESTAMPTZ, 'd233e8d4f74a532091f7be50104904f94d45789da0fc89514c5e3565c263d765'::TEXT, ARRAY[3277]::BIGINT[]),
    (720::BIGINT, 'La profe tiene un complejo de superioridad y es bastante arrogante, no deja indicaciones claras y si usted no le atina a lo que ella quería se enoja Piensa que su curso es el único curso que se lleva'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-05-24T00:00:00+00:00'::TIMESTAMPTZ, '4508f638ae7bed4ea63b518759133e6aa0068c9a9d10ea8134c827374e6b4e78'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'No entiendo porque tiene tan bajas calificaciones es de las mejores profes que he tenido en el TEC. Sabe mucho del tema, es super amable y ayuda un montón si usted se lo pide, sus clases son muy interesantes. Volvería a llevar el curso de nuevo cuando sea'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '3d40d5616bf67fb2b5dacd63c037dde2ad2e991ca302882bcefaedc9927a89a4'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Sus clases son muy interesantes, se nota que sabe mucho del tema. El curso puede hacerse un poco pesado porque es mucha materia, pero evalúa literalmente lo que se ve en clase. 100% recomendado para biotecs que quieran trabajar en DM, el curso es una excelente base.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2023-06-19T00:00:00+00:00'::TIMESTAMPTZ, '0e53619a4452b8483ce676ba07c44eb2744ec0d382a51d8b98d1726e2b9525c7'::TEXT, ARRAY[3408]::BIGINT[]),
    (720::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-07-17T00:00:00+00:00'::TIMESTAMPTZ, '6a8a8382125a7ecd89d66b8fc8f4a8e40efa41ef9029720eeee26d056b66dd03'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'La profesora maneja el tema, pero sus clases son aburridas y muy cargadas. Es exigente, poco flexible. Hay que leer mucho, ella es un poquito arrogante.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2021-02-06T00:00:00+00:00'::TIMESTAMPTZ, 'afb655a0ab73f1859c0e94a7978e6fab4eb0e0d23838dd92c564dfcc53383eda'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Conoce bastante, siempre atiende las dudas y aunque las clases son pura teoría las hace interesantes. Es mejor ir a consulta para los trabajos y hacer lo que ella tiene en mente.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2018-06-20T00:00:00+00:00'::TIMESTAMPTZ, 'b0db0c39d3d24a0aeaec0fef448f7f84d914674cd0f4d60c03d9c1d558ffb4a3'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Se nota que sabe mucho sobre lo que habla, muchos temas por cada examen pero no son imposibles. Lo mejor es llevar la materia al día.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-05T00:00:00+00:00'::TIMESTAMPTZ, 'eb09d374de2befdeab9f3ea7045361d140b826b71d7c81439b8f42a64e458385'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-01-31T00:00:00+00:00'::TIMESTAMPTZ, '6b4a1c3576dc36387efd6e6ca31da3502f7f1f04b6dc0a428656dd16f063a6cc'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2016-06-24T00:00:00+00:00'::TIMESTAMPTZ, '47d180df7230a54bcccdeff1e6f6f053dc464ca19716a61d0d0770a61b6ea412'::TEXT, ARRAY[3282]::BIGINT[]),
    (720::BIGINT, 'Es una profesora que conoce muy bien lo que explica, hay que estudiar mucho para los exámenes y lo mejor es hacerlo desde el primer día que comienza el curso.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-12-18T00:00:00+00:00'::TIMESTAMPTZ, 'd94405dbda55103c8626c2751909e80e6b7ba7a4402c09a85e7a876d199cb430'::TEXT, ARRAY[3282]::BIGINT[]),
    (720::BIGINT, 'Mucha materia, la profe explica, si uno va a consulta explica también.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2015-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'b4f0d3ff39af111a89c93e33d42c02e1e7e99b5757deb2660fbc234b954a1ea8'::TEXT, ARRAY[3183, 3185]::BIGINT[]),
    (720::BIGINT, 'Es una buena profesora, las clases son muy cansadas por lo pesado de la materia, se hacen solo exámenes y proyecto, hay que estudiar mucho.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-24T00:00:00+00:00'::TIMESTAMPTZ, '4f77fe78ea9b69b913c1ec380b58bd338522cf7b44a587bfdad7c32673dcce33'::TEXT, ARRAY[3183, 3185]::BIGINT[])
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
