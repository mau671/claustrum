-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=149
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.097898+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (149::BIGINT, 'La profesora es muy complicada, generalmente no explica bien y cuando no entiendes algo y le preguntas, te enreda mas. Si le pides ayuda en un trabajo, cuesta que te conteste y cuando lo hace te dice que corrijas algo, y cuando lo corriges te dice que esta malo igualmente.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2026-06-29T00:00:00+00:00'::TIMESTAMPTZ, '5dd4ce9f310f05cc6145bfbb63c6d4b4960fedbbe1b640668a41143c6ca29c47'::TEXT, ARRAY[554]::BIGINT[]),
    (149::BIGINT, 'Es super buena nota, super comprensiva y relajada. Con que ud entregue todo el curso se pasa super chili con ella.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2025-12-25T00:00:00+00:00'::TIMESTAMPTZ, 'b6e8fa01352d5f469617dc807f4750db26de5ecb59565cc073ef7fef002a3354'::TEXT, ARRAY[556]::BIGINT[]),
    (149::BIGINT, 'Una profe demasiado relajada, muy agradable y muy flexible, es bastante fácil pasar con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-16T00:00:00+00:00'::TIMESTAMPTZ, '21282ec59582cabf5b7aa659490c0d7cb684fff4a27cc290eb56fe7c99dc2032'::TEXT, ARRAY[601]::BIGINT[]),
    (149::BIGINT, 'Es buena profe, muy ordenada. Siempre dispuesta a ayudar. El curso es fácil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, '6335330505f40db44a33354dd5d2180b2e5166e444dbe36a373a3e2ec7e9ae04'::TEXT, ARRAY[554]::BIGINT[]),
    (149::BIGINT, 'La mayoría de trabajos se trata de mejorar la escritura y aplicar reglas gramaticales porque la verdad la gente escribe con poca o ninguna ortografía. La profe le da el enfoque correcto al curso y hasta repasa gramática del cole que a muchos nos falta'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Clases excelentes']::TEXT[], '2024-10-24T00:00:00+00:00'::TIMESTAMPTZ, '5d2fdfee680bd32ccc458db5474d249c07490ceef4a54cf7defa3e198082bf19'::TEXT, ARRAY[554]::BIGINT[]),
    (149::BIGINT, 'Es buena gente, la verdad es que no aprendí mucho en su curso pero el curso en sí es fácil, y si ud. le hace preguntas ella va a tratar de contestarlas. En resúmen, típica profe de universidad, el trabajo lo va a tener que hacer usted y ella es un intermediario.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-10-01T00:00:00+00:00'::TIMESTAMPTZ, 'ab7cb765ae86837ab54e461464e1fbe7c491f0948ac7af62f7c695df870757f4'::TEXT, ARRAY[554]::BIGINT[]),
    (149::BIGINT, 'Sinceramente no sabe evaluar en especial para ser un curso de primer ingreso, deja trabajos excesivamente largos, evalúa cosas que nunca enseño, en sus retroalimentaciones casi no se le entiende, es muy difícil pasar con buena nota, la profesora es buena persona, pero no compensa con su clase.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2024-07-04T00:00:00+00:00'::TIMESTAMPTZ, '6a91f2262eb44c30641bdd7701a5b3d2aad65c3fec66b26dff5471d1c7070392'::TEXT, ARRAY[554]::BIGINT[]),
    (149::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Pocos exámenes']::TEXT[], '2024-05-30T00:00:00+00:00'::TIMESTAMPTZ, '022177af03df59c00e97a3385aeb5a6f9aceb2bae43bc2432dddaa1c34824089'::TEXT, ARRAY[554]::BIGINT[])
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
