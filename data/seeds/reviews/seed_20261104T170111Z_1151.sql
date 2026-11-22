-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1151
-- TEC-DATA-META years=2021,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T17:01:11.079433+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1151::BIGINT, 'Ayuda mucho,los exámenes son lo que uno ve en clase y es amigable con todos.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Clases excelentes']::TEXT[], '2026-07-24T00:00:00+00:00'::TIMESTAMPTZ, 'e29e6e64d9878881ddbfa700462cdcc13d8eca4b10facb14fd461d89717b4edd'::TEXT, ARRAY[3092]::BIGINT[]),
    (1151::BIGINT, 'Buen profe, lo recomiendo'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Brinda apoyo']::TEXT[], '2026-05-27T00:00:00+00:00'::TIMESTAMPTZ, 'cbcc1437b9ea4e50ad5aa44ad67dc05df067402e77937da3ee3daead1d1e9480'::TEXT, ARRAY[1892, 2374]::BIGINT[]),
    (1151::BIGINT, 'Es un buen profe, explica con detenimiento. Las clases son prácticas y no son aburridas a pesar de que la materia lo es. Hace dos proyectos lo qu lo hace cansado. Da buena retroalimentación pero califica duro.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-04-25T00:00:00+00:00'::TIMESTAMPTZ, 'bace18e75cf7400170c1b4e66d87ddf63df96e91ac95c77d1d48d8a5efdf1777'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'Explica muy bien y creo que en clase y de manera individual es bastante comprensivo y amable. Desde mi punto de vista, fue bastante fácil. Fue un poco grosero con las presentaciones grupales pero ignorando eso, me gustó su forma de dar el curso.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, '77f2c3b3d89b2f5b94d3c5136e657693e9f6f802340cd1e53c4e4ef4ea9769ff'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'El profesor tiene mucho que aprender sobre como tratar a sus estudiantes, en muchas ocasiones es muy repugnante y prepotente. Además hace trabajos muy largos y califica muy duro. Vaya con Cindy, es la mejor opción.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2025-06-25T00:00:00+00:00'::TIMESTAMPTZ, '35e75ce961e992b7bf63b8a5f3f4deb2c08abea444001dc5b6e876651b44fcc8'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'Sabe mucho de su materia y atiende dudas siempre. Pero debe mejorar su actitud, ya que sí es prepotente y poco comprensivo. Los proyectos son muy largos, parece que califica duro a propósito incluso si lo haces como él te explica. Póngale si quiere pasar porque es mucho para un curso de 3 crs.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2025-06-25T00:00:00+00:00'::TIMESTAMPTZ, '1517e371c2e4056e6e188e769a9a00ec7dd32e09dd2e6aa63c6ebfb4bd978dd7'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'Es un profesor muy prepotente'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2025-06-05T00:00:00+00:00'::TIMESTAMPTZ, 'a4d2403d18278ebd26bc0828b5a98ae0957c8f7a93988e0696c7e5b843e49c7f'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'Un excelente profesor, explica super bien. Hace evaluaciones individuales y grupales. Sus clases son largas pero hay receso. Es buena gente, no es una materia difícil, esta super dispuesto a contestar dudas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '3673ed67fd65be847a59a47e9c544d33f312681c748d8d0ff313e211d0579e07'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'El mejor profe, las clases son prácticas y muy fáciles de entender.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-12-03T00:00:00+00:00'::TIMESTAMPTZ, '69ccab4005e08783c48ad3b8d28f110ea348d2056c630cdbcc0286242f9b0d33'::TEXT, ARRAY[2374]::BIGINT[]),
    (1151::BIGINT, 'Muy buen profesor, durante la virtualidad ha dejado videos, un poco largos pero explica súper bien. Siempre está atento a atender dudas. Lleve el curso con él. Tiene que estudiar pero de verdad uno aprende y no se hace tan dificil ya que ve la manera práctica y no tan teórica.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-11T00:00:00+00:00'::TIMESTAMPTZ, 'e63be0ba0fdd4b0d7f387371bee15f538d55df5655d237f5bb496562dcf69dd0'::TEXT, ARRAY[2374]::BIGINT[])
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
