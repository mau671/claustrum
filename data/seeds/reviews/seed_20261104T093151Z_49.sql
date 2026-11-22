-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=49
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.763354+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (49::BIGINT, 'El profe es muy buena gente y de verdad se interesa que uno aprenda. Los exámenes tiene su nivel de dificultad, pero es cosa de poner atención. Si uno lo busca con dudas, el profe le ayuda a uno y aclara.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-04-13T00:00:00+00:00'::TIMESTAMPTZ, '9ae24216ffc1048282d6a935141f18323657c968e97efe12d47359647a4239aa'::TEXT, ARRAY[2366]::BIGINT[]),
    (49::BIGINT, 'Excelente profesor, muy amable y de los pocos que les interesa ayudar y si uno tiene un problema el le ayuda dentro de lo posible.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2026-04-13T00:00:00+00:00'::TIMESTAMPTZ, 'c5116e783ba6ee75a5eb46313d80d358ab22ca39728b606b211b8dab55e6a77a'::TEXT, ARRAY[2366]::BIGINT[]),
    (49::BIGINT, 'Hace muchos trabajos en grupo, el profe es bastante buena nota, aunque a veces se enreda un poquito. Da mucho material de apoyo, solo que de verdad hay que tomar apuntes. Si lo vacila lo suficiente puede que haga los exámenes virtuales.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, '832bba911fed5520f72347297bebfdae7ce92089c59d3a5aa12a7a3ac551ca2a'::TEXT, ARRAY[2366]::BIGINT[]),
    (49::BIGINT, 'No sabe explicar la clase, cuando se le busca fuera de clase ya sea por Teams o email no contesta , deja trabajos muy largos y muchas veces no sabe expresar lo que quiere, pero la mayoria de parciales son para hacerlos en la casa'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos']::TEXT[], '2025-10-28T00:00:00+00:00'::TIMESTAMPTZ, '6f4f0fc51b18851b05dc11539eb3ed74457d1db3b6ff00848f529d1fa4591412'::TEXT, ARRAY[2442]::BIGINT[])
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
