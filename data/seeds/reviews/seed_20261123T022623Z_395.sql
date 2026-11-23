-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=395
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:27:04.220536+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (395::BIGINT, 'Es un profesor que califica sumamente duro, habla bastante bajo por lo que es mejor sentarse adelante, si es su primera vez y no le fue bien en cc, mejor ten una segunda opción, hay que tener en cuenta que es una clase bastante pesada y difícil, además no regala ni cede un solo punto.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2026-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'cce660bedb2694e219a6c190dfd7be17c799e287197867894d20245c49b84ec3'::TEXT, ARRAY[1262]::BIGINT[]),
    (395::BIGINT, 'Se sabe que ca es bastante complicado, igualmente siento que el profe explica bastante bien y hace preguntas para que el estudiante participe de la solución de los ejercicios, pero es cierto que califica DEMASIADO duro.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2026-07-18T00:00:00+00:00'::TIMESTAMPTZ, '42c488244867a2d6dcc050859cd6a93d2b8b84c90cd43d754f36a30b3635183d'::TEXT, ARRAY[3049]::BIGINT[]),
    (395::BIGINT, 'Es buen profe, explica bien, pocas son las veces donde no se le entiende algo. No se si será solo en CA pero califica extremadamente rudo, si usted se equivocó en una parte del procedimiento de ahí para abajo es 0. CA es un curso bastante pesado. A la hora de evaluar William es un Barbosa, binario.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2026-06-29T00:00:00+00:00'::TIMESTAMPTZ, '2fe8406fa6c634815e19ad4438ebf41b87204cc7f710d41e58a551aa3e2d9c8a'::TEXT, ARRAY[3049]::BIGINT[]),
    (395::BIGINT, 'Por mucho la mejor opción para llevar CA, hace que el curso sea un poco más llevadero. Explica súper claro todos los temas y califica normal. El curso es duro e igual demanda poner de su parte, lo mejor es aprovechar las tutorías para obligarse a estar practicando y así ir más preparado al examen'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2025-12-07T00:00:00+00:00'::TIMESTAMPTZ, 'fe4ebda1ca59498a68c4349570486d6b89680f3abbe59d7f4aba7bbe0b46390a'::TEXT, ARRAY[3049]::BIGINT[]),
    (395::BIGINT, 'Cuesta mucho entenderle en clase, habla muy bajito entonces al inicio cuesta mucho prestarle atención. En general, es buena gente y califica normal, pero CA de por sí es un curso complicado.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Aspectos de calificación claros']::TEXT[], '2025-12-06T00:00:00+00:00'::TIMESTAMPTZ, '0cff37784fc42cd64c1b12f3e1451b9e5c653f2ba634f1ddab403d69345f2604'::TEXT, ARRAY[3049]::BIGINT[]),
    (395::BIGINT, 'Lo bueno es que califica justo en los exámenes, y para un curso como CA es más que necesario. Sus clases se entienden si pones mucha atención, no hace muchos ejercicios, pero con las tutorías eso se resuelve. Habla muy bajito y si te sientas atrás te cuesta mucho entender, pero es el mejor para CA'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2025-12-02T00:00:00+00:00'::TIMESTAMPTZ, '1d7196d5a3a7ab5b991b7161a3c7579205adc9a82309a04a45b06ea0d08d1d1d'::TEXT, ARRAY[3049]::BIGINT[]),
    (395::BIGINT, 'Muy buen profe, califica de manera justa en los examenes. CA es un curso muy denso pero con práctica se logra pasar. Si lleva tutorias, se obliga a estudiar más y llevar la materia al día haciendo el curso ligeramente menos pesado. En clase el profe trata de explicar de la mejor manera.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Da buena retroalimentación', 'Exámenes retadores']::TEXT[], '2024-11-30T00:00:00+00:00'::TIMESTAMPTZ, '95da504823a624d9403e20f2e065c4d0d0b312f1740f8b648e3d7ac970965093'::TEXT, ARRAY[3049]::BIGINT[])
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
