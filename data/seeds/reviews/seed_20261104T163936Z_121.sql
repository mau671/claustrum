-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=121
-- TEC-DATA-META years=2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.319292+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (121::BIGINT, 'Excelente Profe, duran bastante las clases, ayuda si uno tiene dudas, la participación en clase es importante porque puede ser que te ayude al final con la nota o eximirse, los exámenes no son difíciles pero uno debe de entender la materia o repasar para salir super bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Clases largas']::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, '5273163e11d561f820d096d7f9ed5c4999af120e0d75edd1868a5ad9f18e281a'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Tiene una vibra tuanis y valora mucho la participación si acaso las pruebas plantea ciertas preguntas de manera muy rara y no se termina de entender lo que pide, las respuestas pueden estar correctas pero no se le logra quedar del todo bien y de algo baja puntos, fuera de eso es chill y se pasa bien'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, '432fd816ba9a85c7ae76da7a25485e82c4e4885353c107ec7dc5209d8315989a'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Explica bien, pero sus clases son un poco aburridas. Lo bueno es que deja sus examenes para fines de semana y uno nada más los entrega entre esos días. Califica un poco duro, pero con que uno elabore todo bien.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas']::TEXT[], '2025-07-30T00:00:00+00:00'::TIMESTAMPTZ, 'de6853db265bb2c70b304e415997151d8139c52c5066c8e7c631784678a4f45a'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Con este mae se pasa easy relaciones, los examenes los deja para todo el fin de semana y se hacen con ayuda externa, evalúa rudo entonces tenga cuidado que pone ahí. 9+ fijo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Muchos exámenes', 'Deja trabajos largos']::TEXT[], '2025-07-17T00:00:00+00:00'::TIMESTAMPTZ, '45adec4aec61c7c23800a5b630f266689758d1bf0de3537ee3db7c539f8785fd'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Es un excelente profesor, él es nuevo en el TEC pero es clases en otras U públicas y se denota que sabe muy bien como dirigirse a sus estudiantes. Le gusta que uno participe y opine, los trabajos dirigidos son bastantes claros y se aprende mucho. Con él no se siente el curso.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '9114372421881a4fb1308e1015645542131f9636fa337f3e3515c1896a2a38d9'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '425ec395c64064f35480f189e432a60745fe39e5bdb3185266ebe3f7aed3652a'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'El es excelente profesor, busca que aprender y se interesen por lo que hace o ve en el curso, ayuda en los exámenes haciendo practica previa y valora MUCHO la participa. En general el curso es fácil siempre que ponga algo de su parte y le de un poco de su tiempo para leer e interesarse'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'bb9ca2c2e4cb80c0cf45d992cc23c65d7c31f6f2254781670512c45ed60168ab'::TEXT, ARRAY[629]::BIGINT[]),
    (121::BIGINT, 'Es un excelente profesor, nuevo en el tec, el curso se pasa facil con solo ir a las clases y tomar nota de lo que el explica y tener un buen resumen y las presentaciones a mano a la hora del examen, si son participativos y le preguntan varas al mae, si les va mal en un examen seguro les tire curva'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2022-11-28T00:00:00+00:00'::TIMESTAMPTZ, '66bfe4d9705bf5bcb91c41df8835aca10bc0cff5d6b3efe7e1665704ea2b6e8a'::TEXT, ARRAY[629]::BIGINT[])
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
