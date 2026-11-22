-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=601
-- TEC-DATA-META years=2015,2017,2018,2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.816807+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (601::BIGINT, 'Es muy dulce como persona, siempre está más que dispuesto a ayudar. Los ejercicios son de internet así que las tareas pueden ser confusas, pero él si tiene buen conocimiento de la materia. Las clases son largas pero el curso es fácil de pasar con él, hay mucho trabajo grupal'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2022-07-19T00:00:00+00:00'::TIMESTAMPTZ, '094269e77e7b1765e222cc0ad8062a58f4fbde9598dae76efb0f22b71be0a6ee'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Muy buen profe, aunque sus clases son largas. Los trabajos son medio largos pero él especifica lo que quiere, entonces en eso ayuda bastante. Y en el TEC digital es muy ordenado. Súper recomendado'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2022-07-03T00:00:00+00:00'::TIMESTAMPTZ, '4c1be646165e8578f3ffbf166dc084197d80cba14429e77c3f519f34b16a070f'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Es muy amable y buena persona pero la clase es sumamente aburrida, ninguno de los trabajos ni los exámenes los realiza él entonces si existe una duda no sabe bien sin embargo si tiene el conocimiento sobre fórmulas y entre otros temas. Además la evaluación no es nada clara pero si es súper fácil pas'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2021-07-28T00:00:00+00:00'::TIMESTAMPTZ, '39209483c7c6eaefcd54765c8d9b3e81e5578f416aab872d83dfaac70aaacb88'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, '3a89c359dc1706ceb7090260aa47b967e3e5c833b8a1b31e65a027cc779658bf'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Es una excelente persona, siempre está dispuesto a ayudar y a explicar si no entendiste algo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-06T00:00:00+00:00'::TIMESTAMPTZ, '74c72050ed03f3d408ce36934e6558aa84313578109d26d57a59b498d6db095b'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Excelente profesor, es demasiado fácil la materia con él, explica super bien y es super buena persona. Muy recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'd4f6b18cafc7acc832eab671d9cac9b927dcd342e7c0b27e5944a01633aa7c50'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'Muy buen profesor, ayuda a los estudiantes, sabe mucho y hace que el curso no sea pesado, es flexible para los trabajos y tareas, recomendado llevarlo con él, computación y sistemas.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-26T00:00:00+00:00'::TIMESTAMPTZ, '41819065d8dec60a11817432351dfcc2d19dba3fd09ab19464ef0ed776c699f8'::TEXT, ARRAY[2399]::BIGINT[]),
    (601::BIGINT, 'Buen profesor, si ud tiene una duda, él se toma el tiempo para explicarte y es muy paciente, además sabe mucho y si ud es aplicado le va muy bien. su curso es muy estructurado, él específica muy bien que es lo que quiere ver en los trabajos y nada más es de seguir lo que pide, deja bastante tarea.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-02-03T00:00:00+00:00'::TIMESTAMPTZ, 'e999cb5000baac2085a5cd2f770ad654499113216624acb2f2df3f749809d5d2'::TEXT, ARRAY[2376]::BIGINT[]),
    (601::BIGINT, 'él es una excelente persona, ayuda mucho si uno de verdad está interesado en aprender. El único problema en la clase es que los estudiantes no le tienen respeto y hacen el escándalo que les da la gana. Por lo demás tiene una paciencia increíble y muchas ganas de enseñar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-18T00:00:00+00:00'::TIMESTAMPTZ, '4ffbab08741bb899af348e7e618fffed76a2c89e8718c3f3f87c12ebd94572ac'::TEXT, ARRAY[2376, 2399]::BIGINT[]),
    (601::BIGINT, 'Es buena persona, pero no tiene casi tiempo para ayudarte o atenderte.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-02-10T00:00:00+00:00'::TIMESTAMPTZ, '513d6495b9d091d1f54e5ebef8d320bcfcf2ed9802402fcae78cbade3ae62955'::TEXT, ARRAY[2376]::BIGINT[])
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
