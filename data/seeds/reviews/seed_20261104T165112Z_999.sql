-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=999
-- TEC-DATA-META years=2017,2018,2019,2020,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.009630+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (999::BIGINT, 'De mis cursos y profe favoritos! El curso se disfruta muchísimo y la profe es excelente. Virtual fue chiva ya que entre ella y nosotros estudiantes aportábamos para acomodar las clases a la nueva modalidad. Los proyectos enseñan mucho y ella califica súper y da muy buena retroalimentación.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-04T00:00:00+00:00'::TIMESTAMPTZ, '76340367505286706e316427468a388978cc490ea56b998f6dfac83374ada403'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'En realidad es una profe muy fácil. Es necesario ser sociables con ella (“tiene sus preferencia” ) pero es fácil ganarse la confianza. NO es excelente en conocimiento porque todas la practicas la hace el esposo y ella llega a reproducirlas. Pero eso la hace más fácil para evaluaciones.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Brinda apoyo']::TEXT[], '2020-08-18T00:00:00+00:00'::TIMESTAMPTZ, 'ed73063a5b5f73ec4610aa017cbf80f278c47e643be4ea7050af5737e3b97dff'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'De las mejores profes que hay. Explica super bien y hace la clase muy interesante, además califica justo y uno aprende demasiado para la carrera y para la vida. Fue mi curso favorito del semestre.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2019-12-03T00:00:00+00:00'::TIMESTAMPTZ, '6b077934737888e03e8adac1046e0e98e4bc224ab0529e0357824b98ab45cc22'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'La mejor profe que existe! Se nota el interés para que los estudiantes entiendan, así como su pasión y entrega por dar clases. Explica muy bien, los exámenes no son difíciles. Hay mucho trabajo en grupo como tareas, informes de laboratorio y proyectos, los cuales tampoco son difíciles.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, '1b61ecc95e0adc4af16c6a76ae7083edc899e5b247540a36b3d722f9cfba4c02'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-29T00:00:00+00:00'::TIMESTAMPTZ, '253aaf54d5f6f9edf10c67c367588646776fdb64ea2fbde9f183f76bc7d5330f'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'La mejor profe que he tenido! Las clases son llevaderas y divertidas, uno aprende mucho y los proyectos que deja son muy chivas! Nada de que preocuparse cuando se matricula con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2018-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'b486347e2b407c1a113cf308000f37d24f4939c526df91bcbacc6bb58d2a3499'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2017-05-27T00:00:00+00:00'::TIMESTAMPTZ, '60a12a0c66a16f217911bc6c9ae55ef221c805b71212ea5a9ca198bcefa1411a'::TEXT, ARRAY[3172]::BIGINT[]),
    (999::BIGINT, 'Es de las mejores profesores que tiene la escuela de Ambiental. Excelente explicando, deja proyectos muy interesantes en donde uno aprende un montón. Definitivamente la recomiendo mil veces!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-23T00:00:00+00:00'::TIMESTAMPTZ, '8c920f4c76b27de4b8d981f163527506d44ba5cf5a784d3a5eee58fd6d0c0b40'::TEXT, ARRAY[3172]::BIGINT[])
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
