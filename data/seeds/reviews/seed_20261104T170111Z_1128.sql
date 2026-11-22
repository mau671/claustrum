-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1128
-- TEC-DATA-META years=2019,2020,2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.074197+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1128::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-03-12T00:00:00+00:00'::TIMESTAMPTZ, '17e85985ff686f71ce7ff6c549d463fe0a6580ddbbcaf5daeb989e904ecbfb03'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Explica bastante bien, además de siempre estar para el estudiante. Al ser genética el curso suele ser bastante pesado. Deja muchas lecturas pero medio obligatorias. Exámenes fáciles y da puntos extra!'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, '43468fc3048e89a7449e2d1e1201c428466d0f7596b2d4968327d2ce4650b37b'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e86fc69515321866281bd73da2a8b7f0a03a0bee6a73514f98a77f13a44ee29c'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Es buena profe, enseña de forma muy directa. Suele dejar lecturas para la casa pero no es necesario leerla a profunidad.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'af241574b243eafe052cbe21b16c87683af20a23f7b6639c98b7401a3bcd3f06'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Todo es bastante directo. La profe suele tener buena disposición para ayudar a los estudiantes. Las clases no son súper entretenidas, pero la materia se entiende bastante bien.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-20T00:00:00+00:00'::TIMESTAMPTZ, '609ff4ae4f30b987be453cc047e53b7130728965a59162fd23f96d822fae7ae5'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Sus clases son entretenidas, pero las evaluaciones las hace demasiado complicadas y requieren de conocimientos muy específicos.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2023-06-17T00:00:00+00:00'::TIMESTAMPTZ, '114eaaf735b469cf812cfb2f7a7c789d3d0d2be32704453b08e9bd76ef744f8a'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'La profe explica bien y da buena retroalimentación, aunque los exámenes sí pueden ser algo complicados, aunque siempre está dispuesta a atender reclamos y consultas.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Exámenes retadores']::TEXT[], '2023-01-21T00:00:00+00:00'::TIMESTAMPTZ, '155efcbe0cb6285f4a86bdfc9e9b85e3f5360fcf7adba4aecbc3d43d86ee2992'::TEXT, ARRAY[3283]::BIGINT[]),
    (1128::BIGINT, 'No pensé que el curso fuese tan pesado, y con esta profe uno pierde el interés. Hace clases demasiado largas, que se entiende por ser pura teoría, pero se pasa. Deja lecturas en inglés larguísimas para los examenes. Hay actividades por puntos extras, como hacer memes, así que no desaproveche.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Da crédito extra']::TEXT[], '2022-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'c74b46642ba114911ef53422f33da6635380ebda220559d1a62d457d8b0eb4b5'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'El curso de por sí es denso, pero muy interesante. Solo que la forma en la que lo evalúan desmotiva. Los exámenes son difíciles y con muy poco tiempo para resolverlos, asigna muchas lecturas (como si uno no llevara más cursos). Da oportunidad de puntos extra pero de verdad hay que ganárselos.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2022-06-11T00:00:00+00:00'::TIMESTAMPTZ, '39923a7a62f8310b622ac494661b3651a1a28f7bd0979a1ec906207c02a295e8'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'El curso es super dificil y es muy cansado, cuatro o más horas conectado lo deja a uno frito. Es mucha materia y se dejan muchas lecturas. La profe sabe un montón por ende espera que los estudiantes también se inerensen por saber, es ruda calificando pero es muy amable y dulce.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2021-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'abf60372d785ec9c54a4d68fed687801a8cf4a0c7d3057f9380fa613f2f6ee64'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'El curso es difícil y la profe lo complica un poco más, deja muchas lecturas como si fuese el único curso, sin embargo, se aprende bastante con ella. Sabe muchísimo de la materia y es super dulce.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2021-07-06T00:00:00+00:00'::TIMESTAMPTZ, '2d8f077eee0b8ec8774119809a205533554a62df2c5e41756128c6a80e55293c'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'La profe explica bien pero sí es pesado el curso, hay que memorizar mucho y las preguntas pueden llegar a ser muy específicas. A pesar de eso la profe realiza actividades para puntos extra que ayudan mucho. En general la profe es muy buena gente.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Da crédito extra', 'Exámenes retadores']::TEXT[], '2021-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'a4cf70fbdefe50b64bbcb1706223b3648925c50c8c8d6d6db3d77a631d65447b'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'El curso es bastante pesado así que hay que prepararse por estudiar e investigar bastante. Sin embargo, la profe Laura hizo que los temas fueran interesantes, dinámicos y claros. También siempre está pendiente de atender las consultas de los estudiantes. 100% recomendada :)'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-28T00:00:00+00:00'::TIMESTAMPTZ, '1e1106e9e79294e4930e16cdc1cde3285ac706b0cab96e57fcfee9d0c44c4af2'::TEXT, ARRAY[3283]::BIGINT[]),
    (1128::BIGINT, 'Se nota que le importa que los estudiantes aprendan, además de que también sabe muchísimo sobre el tema. Tal vez tarda un poco en contestar dudas por fuera de las clases, pero cuando lo hace, quedan 100% claras. Le gusta salir con fun facts y papers de la nada, pero es bueno si le gusta el curso'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, 'cff8f11e4493dc9db026f4f1d4674a8fb4dd32422f1a30b2c2192f1b36ad8c86'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'El curso es MUY pesado pero la profe es excelente, le importa mucho que aprendamos e intenta hacerlo menos duro.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, 'cdd7bccf36107cdf857ba0aeedf4d8c1be4fe5af2992e22b7fc31bb345a6601c'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, '01a3f19fec1a19a38756ace4cad4d96e42208d6aae0d8ce9cb1cf492b6df0500'::TEXT, ARRAY[3268]::BIGINT[]),
    (1128::BIGINT, 'La profe es demasiado buena. Da puntos extras y hace diferentes actividades para salir de la rutina. Realmente le interesa que los estudiantes aprendan :)'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-07-25T00:00:00+00:00'::TIMESTAMPTZ, '87095321c4468d7009a169d01414d8e375abb696cb0826fee906fda735a71d12'::TEXT, ARRAY[3268]::BIGINT[])
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
