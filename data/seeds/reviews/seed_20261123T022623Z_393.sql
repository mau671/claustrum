-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=393
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-23T02:27:03.128219+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (393::BIGINT, 'El mae solo es claro en los temas introductorios después, es un asco. Otros profes del TEC son duros, pero explican bien; este no tiene por dónde salvarse. Se escuda en el aula invertida para justificar sus pésimas explicaciones. No es algo de ahora me sorprendió ver comentarios desde 2014.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos exámenes', 'Exámenes retadores']::TEXT[], '2026-11-23T00:00:00+00:00'::TIMESTAMPTZ, 'fccdedc04ec3bff4378ceeb583fe009d7d8fa160dbd3806afff0d9f7e0ba4906'::TEXT, ARRAY[3049]::BIGINT[]),
    (393::BIGINT, 'Simplemente es un mal profesor, recomiendo evadirlo hasta donde sea posible, cuando explica lo hace bien pero pierde todo el tiempo de la clase hablando paja y explica las cosas a la carrera cuando podría simplemente ponerse a dar materia bien, califica 100% binario, el procedimiento no importa.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2026-04-13T00:00:00+00:00'::TIMESTAMPTZ, '15670fe9ce7cef08071c25b1cc43974a4fa38a73000a6de55d866c9113a06692'::TEXT, ARRAY[3049]::BIGINT[]),
    (393::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2025-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'ec37d3a303c4bee5471c04b464ca6203eead25bba5f50c0cf3911f2bbc447797'::TEXT, ARRAY[3049]::BIGINT[]),
    (393::BIGINT, 'El profesor le gusta explicar pero no hace ejercicios del tema y explica lo mas basico, hay que estudiar por apatre porque los examenes nada que ver con lo que el enseña en clase, examenes dificiles y califica binario algo bueno es que regala puntos extra en examenes o trabajos a final del curso'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Da crédito extra']::TEXT[], '2025-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'a43a695e13d414f001e3b330f98a75ddacde0e2777a1678d2b0f41afc5ecd1c8'::TEXT, ARRAY[3049]::BIGINT[]),
    (393::BIGINT, 'Explica bien, digamos que es un buen profe, cumple, pero es bastante desorganizado con las fechas, los examenes son bastante duros pero intenta ayudar dando credito extra en examenes o asi, pero aun asi es bastante dificil aprobar con el'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, '8278df22d14e6cbd009991f7a76abe1314eec97992e515755575eaddd83eeb31'::TEXT, ARRAY[3049]::BIGINT[]),
    (393::BIGINT, 'Por los comentarios tuve miedo al inicio pero luego a lo largo del semestre el profe es vacilón. Suele hacer 4 quices, 4 exámenes y 4 tareas. La asistencia a la clase la evalúa. Los exámenes suelen ser muy parecidos a lo que él explica, no es nada que nunca se vio.En los exámenes/quices es estricto.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Da crédito extra']::TEXT[], '2024-10-23T00:00:00+00:00'::TIMESTAMPTZ, '84ed316bfcc23243d3b1fe711e55be1e4c6e2568dbd96a6a6889a4f2f70a82c6'::TEXT, ARRAY[3049]::BIGINT[])
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
