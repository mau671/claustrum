-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=408
-- TEC-DATA-META years=2021,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.924372+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (408::BIGINT, 'Una lástima que sea piedra en el camino de tantos que quieren salir adelante'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2026-09-28T00:00:00+00:00'::TIMESTAMPTZ, '0bf3fa2b621063f50b3ba3d0f05a2225b0e899fe9ae414b9b219b9be625b5873'::TEXT, ARRAY[1296]::BIGINT[]),
    (408::BIGINT, 'Triste llevar cursos con él. Esconde la miseria en chistes malos'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2026-02-23T00:00:00+00:00'::TIMESTAMPTZ, '384979cf1109837f5e33a08da46408cb22834c27fcd918148fa4e7322a007301'::TEXT, ARRAY[1296]::BIGINT[]),
    (408::BIGINT, 'Es alguien que sabe bastante del tema. La dinámica de la clase puede no ser la mejor dependiendo de cada quien.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, 'e154571b4f1b2757bb629255f4051399d0cc9a73e2bbc1a114e6858c3bbf5a67'::TEXT, ARRAY[1296]::BIGINT[]),
    (408::BIGINT, 'Es el mejor profe que he tenido en la vida, ayuda mucho, domina la materia, es muy humilde y aunque uno le pregunte algo obvio, él sin ningún problema responde cuantas veces sea necesario. Se interesa porque uno aprenda.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-06T00:00:00+00:00'::TIMESTAMPTZ, 'ed38a76104f4b26589bce5c96eada8a76771357cb9e257401aa2ea72af11eb6a'::TEXT, ARRAY[1336, 1117]::BIGINT[]),
    (408::BIGINT, 'Curso básico, el profesor da páginas de la web para ver ejemplos. Es muy cansado, quita mucho tiempo, al final NO APRENDÍ NADA. Existen cursos en línea excelentes con profesores de alto nivel con mucha experiencia en el mercado. NO RECOMIENDO ESTE CURSO BÁSICO'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Muchos exámenes', 'Muchos proyectos grupales']::TEXT[], '2021-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'ea664f93b7cd6e31e7cb59215fb4f7ba55a298a68d52f65fbadf0f8947502354'::TEXT, ARRAY[1336, 1117]::BIGINT[])
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
