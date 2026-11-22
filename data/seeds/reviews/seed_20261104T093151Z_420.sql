-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=420
-- TEC-DATA-META years=2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.754243+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (420::BIGINT, 'Este profe es pura vida y confía mucho en lo que los estudiantes le entregan. A mi me dio un 54 en un examen cuando no me lo merecía. El curso fue virtual y casi no se aprendió nada, si quiere aprender no es el mejor profe, pero si quiere solamente pasar los cursos llevelo con él de una'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2025-10-13T00:00:00+00:00'::TIMESTAMPTZ, '874458a521cd823cd64aed54ea8217058081a725a6bba58ead57a50a73b70dd7'::TEXT, ARRAY[1267]::BIGINT[]),
    (420::BIGINT, 'si quieres pasar el curso, matricula con él (pero no vas aprender). Sí quieres aprender (no es la mejor opción ).'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-03-17T00:00:00+00:00'::TIMESTAMPTZ, 'a03eb1d94a2bf9672a6a70f07a0836b178ad32f52ebacc3d2ded38f18d3c4094'::TEXT, ARRAY[1255]::BIGINT[]),
    (420::BIGINT, 'El curso es muy fácil, son 3 créditos regalados , si se entrega todo y asiste, se pasa con 100. El profe es muy amable y muy pura vida, es flexible con fechas de entrega y califica suave. Las clases a veces se tornan un poco aburridas porque es llegar y escucharlo a él leer una ppt.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-01-28T00:00:00+00:00'::TIMESTAMPTZ, '8927a55be9c96fb5a61e0979435da708265cef2d3730ffa8adc2985498677e0d'::TEXT, ARRAY[1315]::BIGINT[]),
    (420::BIGINT, 'El profe de verdad es muy buena persona, pero la verdad es que tiene deficiencias en la parte de explicación ya que en clase solo resuelve ejercicios hechos y casi nadie asiste a las sesiones. Es fácil de pasar con el porque califica suave, pero realmente no se aprende como debería.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'de57f366099c01f89e3957f1e01b87ee09eec3566ad3efecda3595b7b4c90156'::TEXT, ARRAY[1294]::BIGINT[]),
    (420::BIGINT, 'El profe es buena persona, pero como profesor es un completo inutil. Se dedica a leer diapositivas y "resolver ejercicios" en los cuales simplemente va leyendo la respuesta a ejercicios sacados de internet. No se aprende nada.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Pocos exámenes']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '15358b1a77457272c604a24e195f3f8e7e77edf898046d6d162874988af57ec9'::TEXT, ARRAY[1294]::BIGINT[]),
    (420::BIGINT, 'Como persona es excelente y entiende al estudiante, pero como profesor es pésimo la verdad no sabe explicar es una perdida de tiempo ir a las clases por que no se aprende nada'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Exámenes retadores']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'b69b4a466f9b75cc8c717da04dd6ee415d8028c06dfef462c444080ea9481509'::TEXT, ARRAY[1294]::BIGINT[]),
    (420::BIGINT, 'Solo lee diapositivas y saber cristo de donde salen las formulas, por tanto, no se aprende a hacer los ejercicios. Las tutorías se pueden copiar de semestres anteriores ya que saber cristo como se hacen... Califica suave y los exámenes de semestres'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('40','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2022-06-13T00:00:00+00:00'::TIMESTAMPTZ, '9c5e59d9c29cccbba1bb74bd41caff43d61c14d310883a824c4393e9b8e6288c'::TEXT, ARRAY[1267]::BIGINT[]),
    (420::BIGINT, 'Usó las clases grabadas que ya tenía y era solo escucharlo repetir lo que ya estaba en las diapositivas, por lo general, solo decía las fórmulas. Solo eran dos exámenes de 45% cada uno y tareas semanales con un total de 10%. Solo era una clase sincrónica donde "resolvía" los ejercicios de las tareas'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'caa9e06fa220a847956ba0e329386bb9314a604a8b04f348d1251826041f17e8'::TEXT, ARRAY[1294]::BIGINT[])
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
