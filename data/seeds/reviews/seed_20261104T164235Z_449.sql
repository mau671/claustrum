-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=449
-- TEC-DATA-META years=2021,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.958231+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (449::BIGINT, 'La verdad el curso y el profesor cero problemas, da todas las facilidades que podrias pedir, solo interese un poco por la clase y haga los trabajos, se le ve que realmente le interesa lo que da, por favor participe en clase, es buena persona y la verdad que inspira, a mi hasta me hizo reflexionar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Brinda apoyo']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'd89580b18cd5acecea81abb60b81ca31678689f5beb3f97a9445d2c2d9a2b716'::TEXT, ARRAY[1312]::BIGINT[]),
    (449::BIGINT, 'El curso se pasa muy sencillo la verdad. Sí es bueno que escoja un buen grupo para trabajar porque la mayoría de trabajos son grupales, y los que son individuales son demasiado sencillos. Lo más complejo son los exámenes que sí son muuyyy largos, pero el profe califica suave'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, '4e935eb65e3624a40f9a16228cec157d8969a0a220777d6aae5d304736b4fa40'::TEXT, ARRAY[1312]::BIGINT[]),
    (449::BIGINT, 'Sin duda el mejor profe para levar este tipo de cursos, hace exámenes presenciales pero son demasiado fáciles de pasar y con nota alta, en general es un muy buen profe, que no te carga en exceso, muy recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-11-25T00:00:00+00:00'::TIMESTAMPTZ, '3a5332c4d46226d9948315575862d93db489ff8e9ddad2212cbc4b4d42ac1aef'::TEXT, ARRAY[1312]::BIGINT[]),
    (449::BIGINT, 'Es super fácil tener buena nota con este profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-17T00:00:00+00:00'::TIMESTAMPTZ, '0e753883d3310d8fd30181ba3b18d42d156823342a3ec395ee88ada3731e8fe9'::TEXT, ARRAY[2450]::BIGINT[])
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
