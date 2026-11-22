-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=333
-- TEC-DATA-META years=2021,2022,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.073442+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (333::BIGINT, 'Kervin es un profesor bastante bueno!!!'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Requiere mucha lectura']::TEXT[], '2026-06-15T00:00:00+00:00'::TIMESTAMPTZ, '3cfa7122bd64228bb469add45160c15727ca4b904cef6b652a2556981db3fba3'::TEXT, ARRAY[1032]::BIGINT[]),
    (333::BIGINT, 'Es muy buen profe, es carismático y me gusta la forma en que domina el tema, claro que al el dominar mucho la materia que imparte también exige mucho en los proyectos los cuales aveces son bien complicados pero al final se sacan, deja quices extra para que uno recupere puntos aveces'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Exámenes retadores']::TEXT[], '2025-07-29T00:00:00+00:00'::TIMESTAMPTZ, 'f52affb4db7e6e8718ccf9b3ebc81e929ffc5979d0bc28dc7f31ad9aa7881423'::TEXT, ARRAY[1032]::BIGINT[]),
    (333::BIGINT, 'Está muy al tanto de los estudiantes y proporciona un ambiente muy agradable para aprender. El curso exige mucho trabajo, pero el profesor es razonable con el tiempo de entrega. Los exámenes pueden resultar un desafío, pero no son imposibles.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-07-13T00:00:00+00:00'::TIMESTAMPTZ, '9d49f653e2dbf5f1e61fdc902b1d06f86b5811376094ee2b870d5784230f8f72'::TEXT, ARRAY[1261]::BIGINT[]),
    (333::BIGINT, 'Es de los profes que sabe mucho pero le cuesta explicarse. Los examenes son de nivel TEC pero da bastante tiempo. El curso tiene otros metodos como tareas/exposiciones/resumenes que ayudan a ganar puntos.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-13T00:00:00+00:00'::TIMESTAMPTZ, 'b4c39d50d0c6b7a7bbef5865697793657c9fc29de4dde405319e82119b2db1e5'::TEXT, ARRAY[1286]::BIGINT[]),
    (333::BIGINT, 'Las clases aportan poco o nada al contenido evaluado. Muchas evaluciones de relleno que no aportan nada. Cero retroalimentación, no entrega una sola nota hasta dos días antes de entregar actas. No califica duro, pero aún así es difícil. No se niega a ayudar, pero no explica muy bien.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Aspectos de calificación claros', 'Exámenes retadores']::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '2f979e08605c3a1bbc37c665875ea8ecbf18e6876df4316098ff260f7144630a'::TEXT, ARRAY[1253]::BIGINT[]),
    (333::BIGINT, 'Siempre dice que todo es "obvio" cuando la dificultad de lo que solicita es completamente diferente a lo que explica en clase. Exámenes y proyectos largos y tediosos. "Se lava" las manos diciendo que la culpa es de los estudiantes. Brinda todas las calificaciones hasta el final del curso.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '5106820ac68657c46bc6881689de95b6b88897fd03525f24e4deca2bb5c627f6'::TEXT, ARRAY[1253]::BIGINT[]),
    (333::BIGINT, 'No he explica nada ,solo cosas superficiales en la clase que sirven muy poco o nada para las practicas y talleres que deja . Mal profesor.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '6b4cfeb3f99861bfefc8f9aa776c51bf765fafe1ab7ef68d6031b82e02139493'::TEXT, ARRAY[1253]::BIGINT[]),
    (333::BIGINT, 'Solo explica teoría y hay que ser muy autodidacta, toca conocer la sintaxis de C++ por otros medios. Los exámenes, proyectos son tediosos y consumen mucho tiempo; además la dificultad de estos es muy dispar a lo visto en clase. Califica los trabajos hasta final de semestre, cero retroalimentación.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, '518eba43d4b218bf677d25a565daec5576923e7766426dab3dffbf8bfec75e42'::TEXT, ARRAY[1253]::BIGINT[]),
    (333::BIGINT, 'Muy buen profe, recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-03-05T00:00:00+00:00'::TIMESTAMPTZ, '6b2f682766d667c214cedea4723cbb10f847b97995dad20a3864fe97f1f67cb9'::TEXT, ARRAY[3792]::BIGINT[]),
    (333::BIGINT, 'Se adapta muy bien a la metodología virtual, sin embargo, las prácticas programadas puede que no sean de ayuda para los exámenes. Brinda apoyo en el caso de poseer dudas. Da la posibilidad de obtener puntos extra. Los exámenes y los proyectos son bastante complicados.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2021-02-05T00:00:00+00:00'::TIMESTAMPTZ, '3f3b79ff58eff14ad9cebf27646e5fbcbadadeed080ecb229a0e35239ebd511d'::TEXT, ARRAY[1253]::BIGINT[])
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
