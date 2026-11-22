-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=672
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.828464+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (672::BIGINT, 'En mi opinión no es una profesora para un curso introductorio, NO explica lo importante, todo lo importante usted lo va a encontrar en una guia pdf de 80 paginas que le solicita a la IA al igual que los trabajos. Si tiene posibilidad de matricular con otro profesor, hagalo'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2026-08-27T00:00:00+00:00'::TIMESTAMPTZ, '3e2931e2defb83ab6c4290c037512c312a8cafdbf56578c405574ee5cb41c140'::TEXT, ARRAY[2523]::BIGINT[]),
    (672::BIGINT, 'Pucha, es difícil hablar de esta profe porque es una excelente persona, pero como profesora si está rezagada. El verdadero problema es que ella cree que uno tiene el conocimiento básico de un curso de bases de datos como para resolver problemas que no son sencillos, y los trabajos muy largos.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-07-16T00:00:00+00:00'::TIMESTAMPTZ, '41bb34584d4a02a5e52f3af13eebf0447bf3a5f5921b9c1b8dfbc18ff1d40cd7'::TEXT, ARRAY[2523]::BIGINT[]),
    (672::BIGINT, 'La va a sufrir con esta profesora durante todo el semestre. Los trabajos que dejan están redactados con IA, deja trabajos todas las semanas (50 páginas aprox. c/u). No explica NADA y asume que usted ya es experto. No la recomiendo. Si puede matricular con alguien más, hágalo.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'b9aa9acdbe9b473cbebc8af5ebce8bfa27155435fff00124a015a0d603f8b46e'::TEXT, ARRAY[2523]::BIGINT[]),
    (672::BIGINT, 'Realmente el curso es muy fácil, es solo dedicarle tiempo. Da notas muy lento, el mismo día de la entrega de actas. No responde a consultas a menos que sea en la clase. Siempre supone que el estudiante sabe lo mismo que ella. No llevaría el curso con ella a menos que sea la única opción.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2025-07-03T00:00:00+00:00'::TIMESTAMPTZ, '1906b2e255157236813444ab1dc2e1cfb53137d9f6121f174025b3963027b30d'::TEXT, ARRAY[2523]::BIGINT[]),
    (672::BIGINT, 'La profe cae súper bien y súper buena persona. Pero explica como si uno ya hubiera pasado por un curso de bases y los laboratorios no son difíciles pero no da instrucciones claras entonces hay investigar mucho, no explica bien lo importante.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-05-20T00:00:00+00:00'::TIMESTAMPTZ, 'c998d7a5335893ab7d6e9106dcaa332d477ad6a7cfedcd13e4f121614bfdfd4f'::TEXT, ARRAY[2523]::BIGINT[]),
    (672::BIGINT, 'Excelente profe, matriculen con ella. No se van a arrepentir!!'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '4296a1ba63b051f0a413c0b19199117db91054eddee1d054f8e70b1a10577a4c'::TEXT, ARRAY[33]::BIGINT[]),
    (672::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-13T00:00:00+00:00'::TIMESTAMPTZ, '70672f1d1108d39079fb1f369398b256e18b061ea7961abe30a71101a98a2bcf'::TEXT, ARRAY[2510]::BIGINT[]),
    (672::BIGINT, 'La profe es muy tuanis, pero sí siento que se le fue la mano. Los exámenes son complicados y los proyectos el doble. La materia volada en algunas partes y ella asumía que uno trae los mismos conocimientos que los de computadores. Hay que entregar todo y dedicarle mucho tiempo. Se aprende a la fuerza'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2023-11-26T00:00:00+00:00'::TIMESTAMPTZ, '41533d8222734fd3b8110d1b6eeb11acc80ff70629f56a3fd3030cf8645be0b3'::TEXT, ARRAY[1044]::BIGINT[]),
    (672::BIGINT, 'La mae cree que uno es un dios del código pone proyectos largos y difíciles. No recomiendo llevar cursos con ella, demasiadas tareas y proyectos con poco tiempo de entrega.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2023-08-29T00:00:00+00:00'::TIMESTAMPTZ, '6f38f455d375fe24b3afd8b002748df1e51a6904651627af007442ab0fc98899'::TEXT, ARRAY[1044]::BIGINT[])
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
