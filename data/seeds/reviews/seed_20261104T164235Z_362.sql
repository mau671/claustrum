-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=362
-- TEC-DATA-META years=2020,2021,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.893362+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (362::BIGINT, 'Es un excelente profe, es un poco exigente, pero explica muy bien y la clase es muy práctica, Se pasa fácil'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, '5998d4a623cb94bef766bda23a15880344bd756b5961b7ad82734d6ff5deb5a1'::TEXT, ARRAY[1230]::BIGINT[]),
    (362::BIGINT, 'De los mejores profesores que he tenido en la carrera, hace el curso interesante, es respetuoso, tiene mucha vocación y está dispuesto a ayudar siempre. Como persona es muy buena gente'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa']::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'dd32f552150c0de1afe6f3c64ad299811a24959a130c872ce1f796dc6fdafb0a'::TEXT, ARRAY[1230]::BIGINT[]),
    (362::BIGINT, 'Muy buen profesor. Al inicio suele hacer muchas preguntas random sobre materia pasada para evaluar qué tan bien va el grupo en general sobre temas pasados de costos por ejemplo. Explica muy bien cómo usar MS project, tiene videos. En sí las evaluaciones son muy parecidas a lo que se ve en clases.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'b1afc317e172eb42467e56dad78c00fe466d57e08c09a1a6ee85ed3b66a2b5c4'::TEXT, ARRAY[1230]::BIGINT[]),
    (362::BIGINT, 'De los mejores profesores de la escuela, enseña lo que realmente importa.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-10-04T00:00:00+00:00'::TIMESTAMPTZ, 'c61b301a0e7b34069ef435e4583b33c7aab5974800d7b64392672fdfb1c0b6b3'::TEXT, ARRAY[1230, 1244]::BIGINT[]),
    (362::BIGINT, 'De los mejores profesores en la carrera, sino que puede ser el mejor, es consciente de las cosas que enseña y evalúa, brinda mucha ayuda al que se lo solicite.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-12-09T00:00:00+00:00'::TIMESTAMPTZ, '4a638ed2d6098a095d690bc2f8ed68ed6e9ecd216ce76b2aabff75caa05205ab'::TEXT, ARRAY[1230]::BIGINT[]),
    (362::BIGINT, 'Muy buen profe, de los mejores que he tenido en la escuela. Realmente se nota que se interesa en que los estudiantes aprendan y hace trabajos y evaluaciones realistas con los que él enseña.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-09-03T00:00:00+00:00'::TIMESTAMPTZ, '15b5ae61e5270902ff9d462c10cf5e6bbf4be31f8422082e771ef763eeb055a0'::TEXT, ARRAY[1230, 1244]::BIGINT[]),
    (362::BIGINT, 'El mejor profesor de la escuela, nada más que decir.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-23T00:00:00+00:00'::TIMESTAMPTZ, '06c6ed7d76e382f9c9fa11072baef7e528ba93622a5088f52b6d267b697a3301'::TEXT, ARRAY[1244]::BIGINT[]),
    (362::BIGINT, 'Por mucho, el mejor profesor que he tenido en la carrera, las evaluaciones tienen instrucciones sumamente claras, siempre apegadas a los temas vistos en clases. Tienen un amplio conocimiento de los cursos que imparte. Sin duda volvería a llevar cursos con el'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-07-31T00:00:00+00:00'::TIMESTAMPTZ, '6fa00e49b23f3622def4230ca61aa6937493939fc90af55756522f5ae309197b'::TEXT, ARRAY[1230]::BIGINT[])
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
