-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=20
-- TEC-DATA-META years=2022,2023,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.279329+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (20::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2026-07-05T00:00:00+00:00'::TIMESTAMPTZ, '05c21d14b75ea4f2eb20b64c53ad39223b9bc859c40fe6014455c69a003b4422'::TEXT, ARRAY[1883]::BIGINT[]),
    (20::BIGINT, 'La mae se mofa de todo y de todos, cero respeto, todo es grupal y realmente lo poco que se ve de materia es demasiado desactualizado.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2026-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'a427c8c308f9997b78f2aaee7d3ad068a1a6ad40565cf578757e7ed2ff157e23'::TEXT, ARRAY[1883]::BIGINT[]),
    (20::BIGINT, 'La MEJOR profesora en temas de mercadeo que he visto u oído. NO duden de llevar con ella, háganse de un buen grupo y elijan una empresa que sí vaya a querer compartir su encuesta con sus clientes (ojalá la empresa tenga base de datos). Ella es sabiduría pura en mercadeo y comprende al estudiante :D'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-28T00:00:00+00:00'::TIMESTAMPTZ, '38739958bf76af293888cf35f7dddb871923625cecbc1ac6ef111e80839af6e7'::TEXT, ARRAY[2453]::BIGINT[]),
    (20::BIGINT, 'Una profe muy vacilona. Las clases no son pesadas y los trabajos son interesantes. Parece que siempre está enojada, pero tiene un humor muy bueno. El curso no es difícil y se aprende bastante si usted pone de su parte. Los examenes grupales son interesantes y sencillos. Buena profe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-08T00:00:00+00:00'::TIMESTAMPTZ, '6848cde1cbcf251b674b3bb88d40fdc622768b6a47c479969215cc5d93be676f'::TEXT, ARRAY[3435]::BIGINT[]),
    (20::BIGINT, 'Excelente'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2023-08-11T00:00:00+00:00'::TIMESTAMPTZ, '68edca559c35248a5d54b7735edacaf30bfb23860bb16e5579440ee9d56f2662'::TEXT, ARRAY[1883]::BIGINT[]),
    (20::BIGINT, 'mala profesora siempre tiene cara de culo, se hace la buena gente pero cuando te das cuenta nada que ver, es una profesora mediocre, no recomiendo para nada matricular con ella'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2022-12-22T00:00:00+00:00'::TIMESTAMPTZ, '2f42d3f9f7851bd11015fb3224a5a7d5256e472f012a5dd5870158306a3653a4'::TEXT, ARRAY[1883]::BIGINT[]),
    (20::BIGINT, 'Cancelada, la mae es super subjetiva, todo grupal y las clases demasiado largas y pesadas'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-11-03T00:00:00+00:00'::TIMESTAMPTZ, '52cf8c9f8c60888bd0b1fb77c5cbb7f7da391937cb81b644de6f581fac6e492f'::TEXT, ARRAY[1883, 2453]::BIGINT[])
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
