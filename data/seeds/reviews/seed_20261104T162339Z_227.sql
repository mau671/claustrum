-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=227
-- TEC-DATA-META years=2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.908446+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (227::BIGINT, 'En general el profe es buena nota, ayuda bastante para ser de mante jaja, en clases a veces se enreda pero todos los ejercicios son del libro y ahí están bien explicados. La tarea es demasiado extensa y hay que investigar bastante. Los examenes estan bastante apegados a los ejercicios de clases.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Deja trabajos largos']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '2826c32e509332c6e3bd5c25f17d0bade780ed6f23af4bc3dc69c87d5baeaaaf'::TEXT, ARRAY[1305]::BIGINT[]),
    (227::BIGINT, 'Explica muy bien y ayuda a evacuar cualquier tipo de duda. El examen es muy accesible con practicar con el libro y los ejemplos de clase. Es estricto con la entrega de la tarea y tiene una fijación con el inglés pero en realidad es buen profe jaja'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-30T00:00:00+00:00'::TIMESTAMPTZ, '2d2674921a2b4a76f1229d5a998eb6639b9d2e23088060eeb0786ab890285dea'::TEXT, ARRAY[1305]::BIGINT[]),
    (227::BIGINT, 'El curso en sí es difícil, pero guerrero es buena nota si toman interés por el curso y la clase. Da buena ayuda durante la clase.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-09-29T00:00:00+00:00'::TIMESTAMPTZ, 'e49ab394cbe2dd69de020123c5256af07eac7d9f3391f3c6de93b479b992c11a'::TEXT, ARRAY[610]::BIGINT[]),
    (227::BIGINT, 'Su clase es una hora de consulta, no ayuda en nada, pasa hablando entre inglés y español de forma risoria, el de los peores para llevar estática, evitelo, el proyecto es demasiado grande lo cual complica aún más el curso'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2023-06-29T00:00:00+00:00'::TIMESTAMPTZ, '3c52451e32b4bc0ab6312ff58c36687abf24a8f6c3711b08464ef7c548181e81'::TEXT, ARRAY[636]::BIGINT[]),
    (227::BIGINT, 'El profe se siente superior en todo momento a los estudiantes, es súper estricto con la entrega de tareas y exámenes y califica como le da la gana, para nada lo recomiendo de una clase de 26 pasaron 4 personas nada más, busquen otro profesor mejor'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'e23f069112fc8ae399e5ad15bed50819a6171bcbd3040456fe15cf6fdbf31fa0'::TEXT, ARRAY[610]::BIGINT[]),
    (227::BIGINT, 'Califica los informes muy suave, le interesa que usted los mejore y aprenda a hacerlos bien. Si va a consulta y no tiene algo claro él investiga para explicarle, muy buena gente pero a veces al responder es un poco concho a veces un poco humillante.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'f034a1866ea92236d39ba664cb51914e569eff658e18092fa2984f8dc6cf3de9'::TEXT, ARRAY[925]::BIGINT[])
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
