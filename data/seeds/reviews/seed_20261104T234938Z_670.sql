-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=670
-- TEC-DATA-META years=2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:49:38.571945+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (670::BIGINT, 'El profe es un 100, la dificultada de este curso es debido a las asistentes. Evalúan como quieren, son muy rígidas en cuanto a instrucciones de documentos y aunque el profe en clase diga X, ellas siempre defenderán Y porque es lo que dice en el documento. Si pone atención en clase pasa.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-06T00:00:00+00:00'::TIMESTAMPTZ, '915221f43c98878b205e461d9a1eec6f32fa5513639574cdb0772eed1ed8716c'::TEXT, ARRAY[2521]::BIGINT[]),
    (670::BIGINT, 'Muy buen profesor, tiene experiencia y sabe de lo que habla, sus clases son bastante dinámicas y se aprende más fácil, es comprensivo sobre la situación de los estudiantes y no evalua tan esticto, recomendado, el mejor profe en lo que llevo del TEC.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ, '93952de18d5acfa1d95359eb20d367db318e34451ff427af5811e89fc315ffaf'::TEXT, ARRAY[2521]::BIGINT[]),
    (670::BIGINT, 'Es una excelente persona, la mayoría de ejemplos que da es sobre la vida laboral. Se puede negociar con el sobre las evaluaciones y da clases virtuales y presenciales. Si tienen la oportunidad, matriculen con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-13T00:00:00+00:00'::TIMESTAMPTZ, 'dbd83d9905642f932df4e84e112676118a6ed63e8c21622eb248bf586c72d63c'::TEXT, ARRAY[2521, 2528]::BIGINT[]),
    (670::BIGINT, 'Excelente profesor. Da ejemplos muy claros, sus clases se pasan rápido y se aprende mucho. El curso es demandante, pero vale la pena. Lo recomiendo por su conocimiento y como persona. Deben haber mas profes como el.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-09T00:00:00+00:00'::TIMESTAMPTZ, 'e2a1ff0dc5aa272b3402df85d1599672b6b814398241177b63687a1a9f6e599c'::TEXT, ARRAY[2528]::BIGINT[]),
    (670::BIGINT, 'Excelente profesor, si tiene la posibilidad de matricular con él no la desaproveche. - Hace quiz sorpresa de la materia, normalmente es al final de alguna clase, por lo que es importante tomar apuntes y estar atento, por lo demás es un profesor sumamente flexible y da receso a la mitad de la clase.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2025-09-10T00:00:00+00:00'::TIMESTAMPTZ, '7e9c8d44c5c3c9772b3ae8cdcc7b55668a874ae12c5c645bc13f6ecde7e91cb9'::TEXT, ARRAY[2521, 2528]::BIGINT[])
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
