-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=717
-- TEC-DATA-META years=2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.091140+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (717::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'f8aa446603afa777dcc26d4f32f5c82184ba4972b1c8f712f7f3fa2296bff0a9'::TEXT, ARRAY[3158]::BIGINT[]),
    (717::BIGINT, 'Tareas muy fáciles y solo se hace un examen que también es muy fácil. Ama su trabajo y se nota que sabe enseñar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes']::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '3b5d5dbf4383b52a9dd7563031f2cf3b3c8f1d884623d8a1086e8845273af09b'::TEXT, ARRAY[3158, 3159]::BIGINT[]),
    (717::BIGINT, 'El curso en sí es muy facil ya que no tiene exámenes, las tareas las califica muy suave, las clases pueden ser extensas por lo que fijo le van a dar sueño, pero normalmente no son los profes quienes dan la clase, sino invitados expertos en el tema.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases largas']::TEXT[], '2023-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'f72b6afdb664eee44e5214356f1dc97e5ab27d6cb1ea7fbc7f9066bed76e6806'::TEXT, ARRAY[3158, 3165]::BIGINT[]),
    (717::BIGINT, 'Muy buen profe, califica muy suave las tareas, solo hizo como tres quices y para el trabajo final había que crear un videodocumental. Es muy chistoso y siempre esta dispuesto a ayudar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2023-06-19T00:00:00+00:00'::TIMESTAMPTZ, '3bb0dc3fc837e9e89e0e36476c46cf131a61d50bad291e58c82ed1ffb1dab4f5'::TEXT, ARRAY[3159]::BIGINT[]),
    (717::BIGINT, 'El curso se pasa fácil y todas las clases son charlas de invitados. Eso sí duerma bien porque las clases son largas y la voz del profe da sueñillo, pero es muy comprensible, flexible y buena nota.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases largas', 'Brinda apoyo']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '5203160c3b6df3aa0c127219e899fd6ef36076d46685f99ca52eb95ec784809c'::TEXT, ARRAY[3159]::BIGINT[]),
    (717::BIGINT, 'Este curso es muy fácil. Deja como 5 tareas cortas y fáciles, y 4 o 3 quices fáciles. Hay un trabajo final en grupo también sencillo. Las clases como tal las hizo tipo charla con "invitados". Algunas fueron aburridas y otras interesantes. Se aprende lo básico sobre algunas áreas de ing. ambiental.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'f6aaae1316664cf6211582943af8344bf1b366d5d63cba390c84ea02619270b6'::TEXT, ARRAY[3158]::BIGINT[]),
    (717::BIGINT, 'es buen profe, tiende en algunas a veces ser comico importa mucho la asistencia, es comprensivo no hay queja alguno.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases largas', 'Clases excelentes']::TEXT[], '2022-12-06T00:00:00+00:00'::TIMESTAMPTZ, '329282c9509e1d4f008416ca13bb56d8c519d23609425ea7dc52ff9ce76f29b5'::TEXT, ARRAY[3158]::BIGINT[])
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
