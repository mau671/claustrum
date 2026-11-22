-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=892
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.759709+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (892::BIGINT, 'El profe es super buena nota, explica muy claro y se nota que domina el tema, si no entiende le explica a uno con todo gusto. Tiene un buen sentido del humor y se tira datos místicos de mate de vez en cuando, sus clases son entretenidas. Si puede matricule con él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '5cdc6451babf1e79f1f8e54a379faa028be56931468327e78172d69aee9c1842'::TEXT, ARRAY[563]::BIGINT[]),
    (892::BIGINT, 'buen profe ayuda mucho, es muy claro, muy facil pasar con el, solo no falte a lo quizes, y siempre hace quizes extra para subir la nota'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '52834b5671477ba57dabd467f16c0e916d38b1b2fd568fdf96cc9c6279b9e0a2'::TEXT, ARRAY[563]::BIGINT[]),
    (892::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'ce968e4ffeaf5469521ca14730513bb9ef744fe1f1ed9ed3158c744e9bc33d56'::TEXT, ARRAY[563]::BIGINT[]),
    (892::BIGINT, 'Es un muy buen profe y además es muy graciosos. Los quices sí pueden ser un poco difíciles, pero casi siempre salen ejercicios parecidos a los de exámenes viejos o a las prácticas semanales. Si uno lleva el curso al día, hace las prácticas y estudia con examenes anteriores se pasa bien.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'eb19c3940770ed7e430d255615b89c4d096fa8d15abf70e4321e5d987bfb410c'::TEXT, ARRAY[563]::BIGINT[]),
    (892::BIGINT, 'El profe es muy bueno, explica bastante bien y siempre está muy abierto a contestar preguntas que uno tenga. Las primeras clases con él se sienten difíciles, pero luego el profe se vuelve mucho mejor y uno termina agradeciendo bastante haber metido con él. Califica duro al inicio, pero al final no.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'b60b961f7383509fc74bc9c95839efcbe064b9a7aaa7706e000e86e510f7df3a'::TEXT, ARRAY[1018]::BIGINT[]),
    (892::BIGINT, 'Es muy cómico, ayuda mucho y es super claro explicando. Siempre brinda ayuda. Hace muchos quices pero es para bajar el porcentaje de estos y que no pesen tanto en la nota. De los mejores profes de mate para matricular.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ, '2f516ea3d7c05051e6a1dd977241d42398f2ead72f69396183f4c3925db83f68'::TEXT, ARRAY[563]::BIGINT[]),
    (892::BIGINT, 'El profe es muy pura vida y explica muy bien pero tiene una fijación rara en que los trabajos sean escaneados en hojas en vez de digital.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2026-03-25T00:00:00+00:00'::TIMESTAMPTZ, '9eef609fe1bcc2876c6bbd7754f1a159695e79d79818a3cde6e7cf83307685cb'::TEXT, ARRAY[935]::BIGINT[]),
    (892::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2026-03-25T00:00:00+00:00'::TIMESTAMPTZ, 'c075c8997cf257a0bf127c4866b978352418fecf75ba0c01d0785b229d600f0b'::TEXT, ARRAY[935]::BIGINT[]),
    (892::BIGINT, 'El mejor profe de mate que he tenido'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-03-25T00:00:00+00:00'::TIMESTAMPTZ, '62511aff29a5652e2a61cbb8639a5b8326eb815e7d3d5fc91d70501886ee25b1'::TEXT, ARRAY[935]::BIGINT[]),
    (892::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-03-23T00:00:00+00:00'::TIMESTAMPTZ, '8cc1778c006d5e2b372858be2726dcc2c6d53983479fa585c13c39106c72159f'::TEXT, ARRAY[935]::BIGINT[]),
    (892::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2026-02-26T00:00:00+00:00'::TIMESTAMPTZ, 'e0e2932d89981102c0ff3966c1d107030e7a77b40c16758bce4da7a5594a7225'::TEXT, ARRAY[1018]::BIGINT[]),
    (892::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-02-18T00:00:00+00:00'::TIMESTAMPTZ, '5f6bf3fea115d5b3d7768c874e7c42f7cccaaaf2018b72b6d3b3c4c95b8ef625'::TEXT, ARRAY[935]::BIGINT[])
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
