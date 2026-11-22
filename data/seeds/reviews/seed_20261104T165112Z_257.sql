-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=257
-- TEC-DATA-META years=2020,2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.120418+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (257::BIGINT, 'La profe pareciera ser una buena persona con intenciones sinceras de enseñar (en esta escuela eso se agradece). Realmente lo único no tan bueno es la forma en que evalúa, revisen siempre las evaluaciones porque fijo algo puede recalificarse. Sí la recomiendo, es una profe con mucho potencial.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ, '5966612a92fc8538a2df6e781641114acc02591a4e45b379ed18bf8c39f8278f'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'En sí, la materia del curso es aburrida. La profe es muy buena gente y ayuda bastante. Nada más es de poner bastante atención y le aseguro que le va muy bien.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-05-27T00:00:00+00:00'::TIMESTAMPTZ, '4f4f2026124a3133499ca3bccc4135ea2da7e9e1e27047874dc36c0e4808e7f1'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'La clase es bastante aburrida, la profe se enreda un poco y no es muy dinámica, es buena persona y ayuda bastante. El curso es fácil, algunas evaluaciones son enredadas, pero en sí se pasa bien, no consume mucho tiempo.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'b88e3ec6ae85f31ac66dfba19767852642300206ba91ceef331000c779f3e9fa'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'En lo personal no le entendía mucho en clases pero con leer el libro queda todo claro ya que es bastante simple la materia a excepción de unos pocos temas. El proyecto es fácil y los exámenes tienen sus dificultades pero practicando del libro se pasan bien. Ella es muy buena gente y ayuda bastante.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'c60c095e67346d2b1ef3ed5a5aa73f939da2918fea029225f954832e9cd993f4'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'Con ella el curso no es difícil pero es muy aburrido. Si a usted no le gusta ir a las clases y trabajar por su cuenta con el libro entonces es lo ideal para usted.Generalmente no da rubricas, entonces es mejor hablar con ella para ver lo que pide. No le va a dar ni una milésima'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, 'f4019c0e3d65d45717fc0ed430fe3c95d82f177f739add98906d46dc986f44a8'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'La profe deja mucho que desear. La clase la dan los estudiantes con presentaciones y ella solo aporta comentarios al final de cada presentación que la verdad no sirven de nada. Muchas veces se le pregunta algo de la materia y ella no lo sabe, no se toma la molestia de leer la materia por lo menos.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-20T00:00:00+00:00'::TIMESTAMPTZ, '49492c3d4dcd47fdfc2202ee1822dc4bc09b607379d72fa44dc2ac30635b2461'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'Toda la materia la dimos los estudiantes por medio de presentaciones. Los comentarios que hacía para complementar no aportaban nada. Si uno tiene una duda y no está textual en el libro, ella no la puede responder. Aprender depende de sus compañeros o que uno lea por aparte, ella no hace nada.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, '185616edc814eb7616976fa057eb999f63da3a9799132e475c9a80f39ae72d78'::TEXT, ARRAY[2885]::BIGINT[]),
    (257::BIGINT, 'En modalidad virtual, al menos en su primera vez, puso a los estudiantes a exponer los capítulos del libro para hacer las clases más animadas, pero con esa idea ella no dio NADA de la materia, al final tocaba estudiar solo del libro para los exámenes. Para el proyecto final no dio ninguna rúbrica!'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-18T00:00:00+00:00'::TIMESTAMPTZ, '0b4054bd01f4d30c2ec828fb6df0220e90e08b23734bcc3bf5b62762955fd261'::TEXT, ARRAY[2885]::BIGINT[])
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
