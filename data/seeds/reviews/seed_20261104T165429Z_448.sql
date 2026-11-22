-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=448
-- TEC-DATA-META years=2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.231962+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (448::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-01-27T00:00:00+00:00'::TIMESTAMPTZ, '311c6319fa0fa4244504f20210d257d317f0d5a60637440b1c5014cf221517b2'::TEXT, ARRAY[1191, 1274, 1272, 4836, 963]::BIGINT[]),
    (448::BIGINT, 'No sabe ni de la materia que esta dando, y que hace son presentaciones que son copy page del libro. No explica los ejercicio e ir a consulta es tedioso ya que no sabe nada sobre el tema. Si lo matriculan procuren tener un compañero de estudio y hacer lo posible por entender la materia.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('10','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '8805c63579361fcc65f1222f5df226381b1ae219fc1ec306bdc5176a3f94215e'::TEXT, ARRAY[963]::BIGINT[]),
    (448::BIGINT, 'No matriculen con ella, solo lee dispositivas no hace ejercicios (es un curso matemático). No tiene tiempo para consultas ni para resolver practicas de copy paste del libro que deja. En guerra avisada no muere soldado.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2022-05-20T00:00:00+00:00'::TIMESTAMPTZ, 'e3c645200bd751606cbc4d91c86f044700a8573b8c43f1bfcd024c486675d215'::TEXT, ARRAY[963]::BIGINT[]),
    (448::BIGINT, 'Como pusieron arriba, preferiría no llevar el curso a llevarlo con ella, se sienta a solo leer diapositivas, no explica NADA, ni ella sabe que está haciendo, no sabe ni resolver los ejercicios, se enoja si le hacen preguntas, no tiene tiempo para los estudiantes, y ella hace el curso el más duro'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-05-20T00:00:00+00:00'::TIMESTAMPTZ, '50d107eb2f6397b65084a8e586776d88212d9a4a0ef7018373d17df913c561b9'::TEXT, ARRAY[963]::BIGINT[]),
    (448::BIGINT, 'Preferiría no matricular el curso a matricularlo con ella. La forma de explicar es sumamente confusa y cuando se le indica, culpa a los estudiantes y su falta de estudio. Un curso sencillo se volvió aburrido con clases donde solo lee presentaciones que ni siquiera sabe explicar. No se puede aprender'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-04-21T00:00:00+00:00'::TIMESTAMPTZ, 'a87946f3494f181c6123b995ff72832df0f69c07a6d89f97ed2f24a481c6fa49'::TEXT, ARRAY[963]::BIGINT[])
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
