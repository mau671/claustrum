-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=831
-- TEC-DATA-META years=2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.476936+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (831::BIGINT, 'El mae como profe es muy bueno, califica bien. Como persona a veces es un poco carepicha para decir las cosas pero tampoco es que se le va a cagar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '8480db464493ef33541726105167f4d470c44b63b08bc59b129db0d063b120de'::TEXT, ARRAY[600]::BIGINT[]),
    (831::BIGINT, 'Las tareas son de 100 corrido. Las exposiciones si las califica duro, por lo que recomiendo prepararse.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '7af3afac0b2105e8cebfff9a9c5e82e80730c880d45916195f84012930a3fef8'::TEXT, ARRAY[600]::BIGINT[]),
    (831::BIGINT, 'El profe es super buena nota, te brinda mucho apoyo. En cuanto al curso es bastante facil si usted hace todo a tiempo. Recomendacion: Consigase un buen grupo de trabajo porque la mayoria de cosas son grupales y es un estres estar haciendo varas con gente vaga.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2022-06-09T00:00:00+00:00'::TIMESTAMPTZ, 'f945e8c4e46b55b683bf315e6a33c7d452ad2e0ecaf70012c5a608607b040479'::TEXT, ARRAY[554]::BIGINT[]),
    (831::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Pocos exámenes', 'Clases excelentes']::TEXT[], '2022-02-25T00:00:00+00:00'::TIMESTAMPTZ, '33e99dd65dc563738d1ce797b14e40f78b794f05ece5f3992be1fbeba5c0d5b5'::TEXT, ARRAY[600]::BIGINT[]),
    (831::BIGINT, 'El seminario fue muy entretenido, no es obligado leer las lecturas pero hace que la clase sea más interesante y tampoco son largas, definitivamente hace el intento de que las clases sean bonitas y es buen profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Clases excelentes']::TEXT[], '2022-01-25T00:00:00+00:00'::TIMESTAMPTZ, 'e68aff42885758d6d454d09cc62526dc145a23db2c8b476e35d8dcee855dbe56'::TEXT, ARRAY[736]::BIGINT[]),
    (831::BIGINT, 'Es un buen profesor, durante la modalidad virtual las clases de comunicación oral y escrita no son obligatorias, deja tareas cortas por semana las cuales son una pequeña contribución de los trabajos pesados. Es un excelente profesor, ya que brinda apoyo durante todo el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, 'b24c60c60d3107a37f4d7df83254c4bf9665517b0deee35c00ccc4ebfdeedc4e'::TEXT, ARRAY[600]::BIGINT[])
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
