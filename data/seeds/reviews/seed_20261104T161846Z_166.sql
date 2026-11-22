-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=166
-- TEC-DATA-META years=2018,2019,2020,2021,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.790747+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (166::BIGINT, 'Hace las clases interesantes, explica muy bien, trata de ayudar para poder mejorar ciertas cosas'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2023-06-15T00:00:00+00:00'::TIMESTAMPTZ, '6c50dc2984ec972b1f4db3f4ee1d17ac1bec5914101c1d37a01cda6eae43ba33'::TEXT, ARRAY[554]::BIGINT[]),
    (166::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2023-06-01T00:00:00+00:00'::TIMESTAMPTZ, '73f302731d76b6db5f0801ab9321adf655fa0f762172054b64ca5eca8ea9364c'::TEXT, ARRAY[554]::BIGINT[]),
    (166::BIGINT, 'Está un poco desactualizada con respecto a aspectos tecnológicos, sin embargo sabe muchísimo de su campo de estudio. Se merece totalmente su título de doctora. Califica un toque fuerte, pero da retroalimentación y horas de consulta constantemente para sacar la mejor nota posible en los trabajos.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura']::TEXT[], '2021-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'cd2722939266cc3ab2f68f2a0b256adf7e55565b7961b162f168432f75790b8d'::TEXT, ARRAY[554]::BIGINT[]),
    (166::BIGINT, 'La profe hace muy interesante los cursos (a mi gusto por si solos los cursos no son tan interesantes). Sencillamente una ras profe, matricule con ella D1.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-17T00:00:00+00:00'::TIMESTAMPTZ, '62d6cd080b08ee5b3f684f1534c42b6e5aed03365b3e39678d6e9cab007449fd'::TEXT, ARRAY[600, 554]::BIGINT[]),
    (166::BIGINT, 'Matricule este curso, pense que seria una perdida de tiempo; sin embargo, esta profesora lo hace sumamente interesante el curso, corrige a todos sin excepcion con tal de que el estudiante aprenda, fomenta la participacion de los estudiantes en su leccion y es muy directa con su forma de pensar.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-15T00:00:00+00:00'::TIMESTAMPTZ, '8bbec69356e838de59ecc8df7fd06bfd611ad5b2c62aad9eed28660410eebc26'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'La profe sabe muchisimo, si usted es una persona que no le gusta ser corregida mejor no matricule con ella, de lo contrario si le gusta prender y mejorar, es como lo mejor que le puede pasar. Es un curso facil de pasar, sepa organizarse y va a ser un curso liviano'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, 'f3047c89f828de6e66072db46277f9ee8c29eabf0537b54637fe2cb99010d28b'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'La compa es muy buena y es un curso muy fácil, casi no consume tiempo, solo es de asistir a la clase y hacer la actividad y ya'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2021-02-08T00:00:00+00:00'::TIMESTAMPTZ, 'c6dffcfa146135ebb9a2c3ca56182fd96509bbf40473e57b1d27871e1a1ea214'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Es fácil virtualmente, a veces dice comentarios groseros/sinceros que pueden llegar a incomodar.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'La participación importa']::TEXT[], '2021-02-08T00:00:00+00:00'::TIMESTAMPTZ, '0f001f8bede4215ef2036727875f69c6c47a2c6901492cfb1bb6844a0767bb0a'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Se aprende bastante, es verdad que desde el inicio ella dice que no busca hacer amigos pero, la verdad es que cae muy bien y solo busca que uno se interese en el curso'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-02-01T00:00:00+00:00'::TIMESTAMPTZ, '423bc25b40c2d4a68edc1bc10383dbac104f44db608406f6c8e7c643df637ef7'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Exigente, pero se aprende mucho y los trabajos son cortos, se trabaja en grupo las actividades de clase y la exposición final.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Da buena retroalimentación']::TEXT[], '2021-01-23T00:00:00+00:00'::TIMESTAMPTZ, '2be643331d64d4021ec7768c392cfeccb153adf8b7fca3e495c540eae25860df'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Sinceramente una profe que se sale mucho de su rol de profesor, hace comentarios innecesarios sobre los estudiantes y los trata a todos de manera despectiva en ciertos puntos, una profesora mala en mi punto de vista, pero si es necesario el curso y no le queda de otra, no es tan mala.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa']::TEXT[], '2020-10-06T00:00:00+00:00'::TIMESTAMPTZ, '9c69b5efeb6a243d8768466618e909af732d8106b5fe4cfb58dd638b08bca404'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Desde la primera clase dice que no va a hacer amigos, y lo dice muy en serio. En cuanto a como califica, en definitiva es buena en lo que hace, sí enseña bien de redacción. Aunque a veces dice que algo está bien y luego en la entrega dice que está mal.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2020-07-29T00:00:00+00:00'::TIMESTAMPTZ, 'bf8d652201d1bfd8ffa8806805863ed34f44c9e31591d32539b3f179f6c06f2e'::TEXT, ARRAY[554]::BIGINT[]),
    (166::BIGINT, 'suele ser un poco amargada pero enseña muy bien'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-02T00:00:00+00:00'::TIMESTAMPTZ, '8e2ecee24ac1c99e8a19d0583917f42087e4992e123ffe0258e9f24aa4822054'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2018-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'a1ec42b12280e891dbc0b1c9c8a36afd3f98991b714ec1350d594c9c3ed45c8c'::TEXT, ARRAY[600]::BIGINT[]),
    (166::BIGINT, 'Es una excelente profesora, sus clases son muy entretenidas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-20T00:00:00+00:00'::TIMESTAMPTZ, '64f4dff8552e65d43a30216b734445903009c3d1b24adc6cbeee23a73d8fa240'::TEXT, ARRAY[600]::BIGINT[])
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
