-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=838
-- TEC-DATA-META years=2021,2022,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.726932+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (838::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-21T00:00:00+00:00'::TIMESTAMPTZ, '6def56fc2e708c32678138370c91c414824fceae171b7c3c9e6f13aed3fcb43e'::TEXT, ARRAY[2445, 2456]::BIGINT[]),
    (838::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa', 'Aspectos de calificación claros']::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'a10983802942caf52e2cd983a93fd65c3d5180dbb30b5cc45972af989b1beaf2'::TEXT, ARRAY[2445]::BIGINT[]),
    (838::BIGINT, 'Excelente profesor, muy amigable y además muy accesible. Se interesa porque usted aprenda la materia y puede repetirla hasta cinco veces si es necesario, los exámenes son muy sencillos de 3 o 4 preguntas, pero le gusta que se explique bastante. La participación en clase es muy importante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '21bc67683ed7c46881ac01feb2767ff42c2777fe4538367463a052a947a78f38'::TEXT, ARRAY[2456]::BIGINT[]),
    (838::BIGINT, 'Modalidad: virtual. Se aprende bastante. Las clases son cortas pero de bastante participación. Los exámenes no suelen ser difíciles pero se debe evitar la brevedad.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2022-05-10T00:00:00+00:00'::TIMESTAMPTZ, '214fa13f61b25b7ceccb0cce14560b20d001e0d04cc65251111270e2f4f448c7'::TEXT, ARRAY[2456]::BIGINT[]),
    (838::BIGINT, 'No deja tareas, la evaluación es 70% exámenes y 30% participación en clase. Mejor no falte, participe en todas las clases y haga sus apuntes que le van a servir mucho en los exámenes. Clases cortas (1:30)'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2022-03-14T00:00:00+00:00'::TIMESTAMPTZ, '51707d114df01721016af59a656147b49bd2e8525f63f4d749e73e5a629e0211'::TEXT, ARRAY[2445]::BIGINT[]),
    (838::BIGINT, 'Es un excelente profesor, da la materia de manera sencilla de entender y siempre busca la manera de dar ejemplos que puedan apoyar sus argumentos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Brinda apoyo']::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, '6c82f8890329b90032e1b1586466ad969011ad43bb3e83af32a4f215d947ac67'::TEXT, ARRAY[2445]::BIGINT[])
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
