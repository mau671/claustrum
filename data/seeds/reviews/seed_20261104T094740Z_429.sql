-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=429
-- TEC-DATA-META years=2019,2021,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:47:40.722746+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (429::BIGINT, 'Un excelente profesor, si tiene la oportunidad maticule con él. Ayuda muchísimo, evaluaciones justas y es un excelente profesional.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-08-25T00:00:00+00:00'::TIMESTAMPTZ, 'd957572bc807a86f8bad92f558e2b41fe34c814059f39f18d9eed21580bc5d7c'::TEXT, ARRAY[1719]::BIGINT[]),
    (429::BIGINT, 'El profesor es excelente, siempre explica con claridad en las clases, da ejemplos útiles de los temas que se ven y da buena retroalimentación de los quices, exámenes y proyectos. Es importante prestar atención en la clase y tomar apuntes de los ejercicios que se resuelven.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-08T00:00:00+00:00'::TIMESTAMPTZ, 'c0f0a46486baf1c05742f5b83e409313b6eb50a2d257c94f3789ac9eebdad9af'::TEXT, ARRAY[1778]::BIGINT[]),
    (429::BIGINT, 'Es probablemente el mejor profesor de la escuela de Ingeniería en Producción Industrial. El profesor explica todo muy claro, ayuda en las consultas y las evaluaciones son con ejercicios similares a los que se resolvieron en las clases. El inglés no es limitante para aprender los temas del curso.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-07-02T00:00:00+00:00'::TIMESTAMPTZ, '6ed540b4a2600eb0b8c90fbeb264c3c8ccf46e01719ab3336ff499f697b44ed0'::TEXT, ARRAY[1779]::BIGINT[]),
    (429::BIGINT, 'Es muy buen profesor, se nota que sabe enseñar, sin embargo es cierto, es algo arrogante. Brinda ayuda para las evaluaciones.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, 'b34ef33126b5a55330d48ec18d3ccb38d6904011d0127be6c688b879aa1d3cd3'::TEXT, ARRAY[1719]::BIGINT[]),
    (429::BIGINT, 'Tiene mucha experiencia y es excelente profesor. Un poco arrogante lo que vuelve tenso el ambiente en clase y para consultas fuera de horario, en virtual no sube ni le gusta mucho la difusión del contenido de la clase o videos. Muy pocas evaluaciones, lo que vuelve al curso difícil de aprobar.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Pocos exámenes']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, '4fc7397907b68fd08adcac2fb19dd23805ad9b35498bfcdaf7397949381a1303'::TEXT, ARRAY[1719]::BIGINT[]),
    (429::BIGINT, 'Para virtual todas las evaluaciones fueron en grupo, los exámenes y quices son basados en los ejemplos que él da. Si tiene dudas el de fijo se las va a resolver.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Aspectos de calificación claros']::TEXT[], '2021-02-08T00:00:00+00:00'::TIMESTAMPTZ, 'e23df1c3e006127273349de9b5a5cf71b64799092aee9018aa61bcf4d02fc386'::TEXT, ARRAY[1719]::BIGINT[]),
    (429::BIGINT, 'Uno de los mejores profes que tiene la Escuela de PI. Realiza evaluaciones congruentes a lo visto en clase y es muy accesible para revisarlas. Es muy bueno y tiene mucha experiencia en el ámbito laboral, es de los profes que hay que sacarle el mayor provecho de su conocimiento.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2019-10-28T00:00:00+00:00'::TIMESTAMPTZ, 'b1357f4d51d919f03d4ef1e990609c90f999f200546b402c6c582358ba94a1cf'::TEXT, ARRAY[1742]::BIGINT[])
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
