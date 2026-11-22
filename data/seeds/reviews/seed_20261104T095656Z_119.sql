-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=119
-- TEC-DATA-META years=2021,2022,2023,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:56:56.105820+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (119::BIGINT, 'Básicamente el curso es responder forms y despues hacer un examen que es otro forms hecho de los forms que usted ya respondió y un trabajo grupal bastante sencillo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2026-06-30T00:00:00+00:00'::TIMESTAMPTZ, '5e3f5740b502eee1a7416ab6e93dc28063b3367ec235a6aee57f1cf0376426b0'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Para ser un curso que a muchos no les importa él lo hace interesante. Asista a todas las clases y haga los trabajos que deja (que son fáciles) y pasa sobrado. Y preste atención, menciona muchas cosas importantes que le van a servir para la vida.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2024-12-12T00:00:00+00:00'::TIMESTAMPTZ, '03537b62188c41a6aef963c54fe916a440e902a7b08a98e4a499275ba5f81886'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Las clases son muy relajadas. Los quizzes y exámenes son muy fáciles. Califica suave.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'f933b8fdcdfc877d7f916efbea90e10ea1860c86b4659e437275d97c5a1859a3'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'El profesor es un Sol, ayuda demasiado y contesta súper rápido. Los exámenes son virtuales y hace el curso semipresencial aunque sea regular, lo cual es un respiro enorme. No aguante compañeros vagos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2023-12-04T00:00:00+00:00'::TIMESTAMPTZ, 'e0f27df6b993dd50272ffd9f2801fa93c2a9cac200a753c816d70cbcf9383c66'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Es un profesor excelente, se nota que busca que uno aprenda. Las clases y la materia se vuelven interesantes, además de que no hay trabajos pesados y todo se puede realizar en la misma sesión. Llévelo de fijo con él, un 10.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2023-11-28T00:00:00+00:00'::TIMESTAMPTZ, '967657acaeb8685dacb225b3e7c183baa9f87eeb30d460d76a9aebec7b7ad5be'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Es un excelente profe, se nota que le gusta lo que estudió. No deja muchos trabajos, normalmente los trabajos se realizan en clase y los exámenes son parecidos a los quices que deja. Si pueden matriculen con él.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2023-11-21T00:00:00+00:00'::TIMESTAMPTZ, '27e9a20420b0ab24d6af0aea90eacb0c95ad0a19c1bcb0f5cdd7fb4997201201'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '1f1294c49b38cbd6d520f158e85095a0cedd652fe7c45a66c9874b9871393eb0'::TEXT, ARRAY[559]::BIGINT[]),
    (119::BIGINT, 'Un profe muy tuanis, a pesar de que deja bastantes trabajos, son muy sencillos de hacer y se realizan en poco tiempo. Genera un ambiente de confianza en la clase que lo hace sentir cómodo. Recomiendo llevar con él'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-06-14T00:00:00+00:00'::TIMESTAMPTZ, '797289b13867cd19be50e2cfba73a4294f8048707b89a75504e9bb9fa97f4b86'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Este profe es el goat, llev con el y el curso se puede volver muy entretenido, hay siempre cosas que hacer semanales pero son muy faciles, los examenes son super sencillos'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Clases excelentes']::TEXT[], '2022-11-21T00:00:00+00:00'::TIMESTAMPTZ, '2130f7f6b503bf19958dd378fa85318be976b49bc89563692b813c8e99990606'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Muy buen profesor, recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2022-09-30T00:00:00+00:00'::TIMESTAMPTZ, 'dd286b05531a5075366f99b720f39a90f185b8850ce22b9edd861901a8f3b8f5'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'A pesar de que todos los días hay que ver clases previas y se hacen quizes, la clase en si es muy sencilla y explica todo previo al quiz, para ayudar a los estudiantes. Los trabajos son relativamente sencillos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2022-05-04T00:00:00+00:00'::TIMESTAMPTZ, '6be9832204ef2bd030bbf792cc59386f8c35a243defa06d0087d88408a914b81'::TEXT, ARRAY[559]::BIGINT[]),
    (119::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'd2e0c77ca23935626ecd5fdb94582cf14b382481f6b3f54bf785e058590f28dd'::TEXT, ARRAY[559]::BIGINT[]),
    (119::BIGINT, 'Este profe es lo mejor que puede existir'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'a60b2c864fb05f4e075d9f82016d9f56ffde3d2b4c9c587ffbc549ec69942383'::TEXT, ARRAY[628]::BIGINT[]),
    (119::BIGINT, 'Excelente profe, clases no muy largas, explica bien y brinda el material con el que explica para tenerlo a mano, los exámenes son fáciles con poner atención a la clase se puede pegar el 100 fácil y el curso termina el semana 16.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-01-18T00:00:00+00:00'::TIMESTAMPTZ, 'a89bac40762f72141746468257aaf5ed16661082c79c8b6a1b84653aea8359d1'::TEXT, ARRAY[628]::BIGINT[])
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
