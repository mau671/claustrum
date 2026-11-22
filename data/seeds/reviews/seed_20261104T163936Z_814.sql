-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=814
-- TEC-DATA-META years=2021,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.242375+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (814::BIGINT, 'Excelente profesor, siempre dispuesto a ayudar. Explica muy claro y califica muy justo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2026-10-24T00:00:00+00:00'::TIMESTAMPTZ, 'e32d03892417dc1de9336935cc17eb4c264b375a7e892f020bc11cb778b4b954'::TEXT, ARRAY[1049]::BIGINT[]),
    (814::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, '50e0e7283c8d98f74c2b50a943bdeb15d971a91bd2303e413b5d8610f599d6f2'::TEXT, ARRAY[605]::BIGINT[]),
    (814::BIGINT, 'Excelente profesor, matriculen con el Mate general y cálculo diferencial. Es super ordenado con su clases y explica muy claro. Es un profe con demasiado vocación.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'dace19d455f72d0e2f22c184b3f69405334b586ee46d6739fde0091603724ef7'::TEXT, ARRAY[563]::BIGINT[]),
    (814::BIGINT, 'Es un excelente profesor, inspira confianza en las clases y es comprensivo, sabe mucha mate entonces puede llegar a explicar a un nivel más elevado, pero siempre que se lo pidas volverá a explicar es muy justo y valora el esfuerzo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'a0edebbef521e55a8e0f32b2444a42f7dc803f959fc066bc1d9a03bfd33344de'::TEXT, ARRAY[563]::BIGINT[]),
    (814::BIGINT, 'Un charlatan'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'ddce08eda76f6aea13c3469cb416d65524f374735408266458224e327d549470'::TEXT, ARRAY[563]::BIGINT[]),
    (814::BIGINT, 'Demasiado buen profe, como persona es un 100 y como profe otro 100, dan gusto las clases con él. En lo personal nunca me gustó mate porque me costaba, pero el recibir clases con él cambia eso, explica muy claro y las veces que lo tenga que hacer, recomiendo siempre matrícular con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-02-03T00:00:00+00:00'::TIMESTAMPTZ, '87b77a40d6ac2ee16cc47829b05c7fb935b559d575f858c9c02c4ce21cf8aa3e'::TEXT, ARRAY[1018, 563]::BIGINT[]),
    (814::BIGINT, 'Verano lo divide en un examen semanal lo cual hace que los temas no se acumulen demasiado y explica de una manera muy clara y ordenada. 10-10.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-21T00:00:00+00:00'::TIMESTAMPTZ, '696b5abcc3efaa941712d9934114d62de6a97cbf16cf80b5128a029dd5383cdb'::TEXT, ARRAY[605, 923, 634]::BIGINT[]),
    (814::BIGINT, 'Es muy buen profe, y califica super suave. Matricule con él de fijo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, 'badfc21b4d1e3445c90fb2b5cc65afe357d56c3efb77533e6013fdf48a889d33'::TEXT, ARRAY[605]::BIGINT[]),
    (814::BIGINT, 'Si tiene la posibilidad de matricular con el ,ni lo piensen ,explica demasiado claro y valora mucho los esfuerzos de los estudiantes. Los quiz son fáciles y el cae muy bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'c9fdb4dc73e80950ea8d5e964e06353068257570e084b0e69d847c20bc358201'::TEXT, ARRAY[605]::BIGINT[]),
    (814::BIGINT, 'De los mejores profesores que puede tener el TEC. Un amor de persona. 100/10'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2023-05-12T00:00:00+00:00'::TIMESTAMPTZ, '7681c8baaa64881af3082aa89a1d061d5920ccea6ca469a32e87d1519e017a7a'::TEXT, ARRAY[1018, 563]::BIGINT[]),
    (814::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-04-23T00:00:00+00:00'::TIMESTAMPTZ, '84f20891eaee019dc756c26bdb453b5f24b0ccce48155a148c756e3aba8e4a36'::TEXT, ARRAY[605, 923, 634]::BIGINT[]),
    (814::BIGINT, 'Llevé verano de forma presencial, el profe explica bastante bien y aclara todas las dudas. Es compresivo a la hora de calificar y siempre motiva a los estudiantes. En general, excelente profe.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-01-24T00:00:00+00:00'::TIMESTAMPTZ, '56f11477aa086a8ebc9fbb8d489bb4a281e2b961ddb6807e0ef600c58b63a0fb'::TEXT, ARRAY[605]::BIGINT[]),
    (814::BIGINT, 'Dividió el curso en 6 exámenes solamente. Explica muy bien, a veces redunda o se extiende mucho, por eso las clases suelen ser largas. Por lo demás, ayuda mucho a los estudiantes, es comprensivo.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-05-19T00:00:00+00:00'::TIMESTAMPTZ, 'b71964a389697a09675d5e6c074cf4c55030f5a40f3ac0e60f150b8f8762ab7f'::TEXT, ARRAY[1057]::BIGINT[]),
    (814::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Requiere mucha lectura']::TEXT[], '2022-04-29T00:00:00+00:00'::TIMESTAMPTZ, '7d793a552338fa81c97d16247ea1c35ecbb1362a9b7bb4159b049a19d6de96cf'::TEXT, ARRAY[634]::BIGINT[]),
    (814::BIGINT, 'Excelente profe, todo se le entiende, es muy claro en sus clases y organizado. No dude en matricular con él. Además, de que siempre está dispuesto a ayudar a los estudiantes si tienen dudas.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-02-07T00:00:00+00:00'::TIMESTAMPTZ, '1053e02bdf356e811033f4e340d58a395b86ee0564af8ea8f7577321789b9022'::TEXT, ARRAY[1057]::BIGINT[]),
    (814::BIGINT, '10 de 10 este profe, a pesar que lo lleve virtual y en verano, fue excelente este profe. Ya no tengo que llevar más mates, pero si tengo que hacerlo otra vez sin duda con él de fijo :=)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-02-02T00:00:00+00:00'::TIMESTAMPTZ, 'aa9a21bb07efdaf3563d31f53c05c709611a85f9baa84b0c01695a3d0155a707'::TEXT, ARRAY[1057]::BIGINT[]),
    (814::BIGINT, 'El profe es excelente, se le entiende bastante bien y por lo mismo el curso se hizo sencillo a pesar de que el 100% del curso se dividió solamente en 6 exámenes'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-01-27T00:00:00+00:00'::TIMESTAMPTZ, 'c3339484fcd70caf4b2a1f5b08692c29ed88ddabd7d7e6f880e424b597589aae'::TEXT, ARRAY[1057]::BIGINT[]),
    (814::BIGINT, 'Administró el curso a la perfección, explica de una manera excelente, de fijo volvería a matricular con él.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2022-01-21T00:00:00+00:00'::TIMESTAMPTZ, 'f8966cee74b8b63630a79c19f6c512195a2320fe879f37fb428e23f00360eb71'::TEXT, ARRAY[1057]::BIGINT[]),
    (814::BIGINT, 'Explica bien y repite si es necesario. Sin embargo, el curso es muy difícil porque las consignas semanales de la cátedra son muy malos, entonces cuesta mucho entender la materia, ya que la clase es solo para aclarar dudas. Es uno de los mejores profesores para este curso, pero igual es difícil pasar'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos exámenes', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2021-11-30T00:00:00+00:00'::TIMESTAMPTZ, '23949acbb3ee7bec0031717a5d1978033ef8cc4c58ece4b93a53d1f97d9a54d9'::TEXT, ARRAY[1049]::BIGINT[]),
    (814::BIGINT, 'Excelente profesor, sus clases son de las mejores que he llevado y explica perfecto, es de los que mejor se adaptaron a la virtualidad. Graba las clases y brinda todo el material excelente, revisa muy rápido y es muy amable.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-23T00:00:00+00:00'::TIMESTAMPTZ, 'f3d32e7882090a13b8d4eafeaca3d70592901ebd0ac0725f61ca604926800b25'::TEXT, ARRAY[1049]::BIGINT[])
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
