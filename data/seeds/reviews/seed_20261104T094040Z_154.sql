-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=154
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:40:40.733958+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (154::BIGINT, 'Fue virtual, su clase no es cansadísima y la verdad me pareció muy dulce. Siempre busca ayudar y sus evaluaciones no son nada del otro mundo. Recibiría más cursos con ella si tuviera que matricular más'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2026-07-28T00:00:00+00:00'::TIMESTAMPTZ, '685ad94dd5e4d23dd392f079018b5f767e15c55d4b1558bfa6ad6354d433cc26'::TEXT, ARRAY[3263]::BIGINT[]),
    (154::BIGINT, 'Muy buena profe, explica bien y es muy llevadera. Se pasa muy fácil y practicas bastante, sobre todo hablando con los compañeros.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, '2b15f5ad5ff8a0e88e70ee1a75ebb1504a9236dc05307056e7830d2a8cbaa47c'::TEXT, ARRAY[545]::BIGINT[]),
    (154::BIGINT, 'La verdad es una excelente docente, basa mucho de su enseñanza en plataformas digitales. Sinceramente si usted quiere aprender inglés ella le da las bases, pero dependerá de usted practicar y fomentar su inglés. La profe es muy chill y buena gente, es divertida incluso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2025-11-11T00:00:00+00:00'::TIMESTAMPTZ, '966af1734608ffaab7ee00f757c6afead31a14a74e3630b53e481acf89cf9204'::TEXT, ARRAY[625]::BIGINT[]),
    (154::BIGINT, 'La profe es excelente, siempre está para ayudar, es muy comprensiva y explica extraordinariamente bien. Hay mucha participación en clase y hace mini actividades entre compañeros. No califica duro y nota el esfuerzo de las personas a las que les cuesta el inglés'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-11-27T00:00:00+00:00'::TIMESTAMPTZ, '6c388d374e275be2b0473cf8408ec32a17d93466aeefa466134535c98ad33d51'::TEXT, ARRAY[547]::BIGINT[])
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
