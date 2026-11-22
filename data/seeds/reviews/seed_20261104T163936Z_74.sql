-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=74
-- TEC-DATA-META years=2021,2022,2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.295980+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (74::BIGINT, 'es fácil la clase, todo está en las presentaciones, no es necesario ir a clases y todo se entiende pero las clases en si son aburridoras'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-07T00:00:00+00:00'::TIMESTAMPTZ, 'ffbbf3619cc380fcb7325bd694c488d548bc91f735fff2b5f0fe215072a0e127'::TEXT, ARRAY[1977]::BIGINT[]),
    (74::BIGINT, 'El profe es muy buena gente y se preocupa porque uno disfrute y entienda la clase. Las clases teóricas pueden ser aburridas pero es por la naturaleza del curso. Le gusta mucho que uno participe y sus evaluaciones no son tan difíciles aunque si es un curso al que hay que ponerle mucho.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-07-10T00:00:00+00:00'::TIMESTAMPTZ, '46a680d78f8148133b4feef0c40e404b0808b8fd39598d65116994237ac5499e'::TEXT, ARRAY[1460]::BIGINT[]),
    (74::BIGINT, 'Es relajado, sus examenes un queque, las presentaciones son perfectas para estudiar, te quita todo el trabajo de hacer apuntes. No es nesesario asistir a clase y la verdad es que da sueño(los quizes osn presenciales).'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '2efb5b943752e5f6a73e15aff105f7812d03eb9c515211b2959f1a0b0ffd8761'::TEXT, ARRAY[1977, 1460]::BIGINT[]),
    (74::BIGINT, 'Se pasa fácil, le gusta la particiación, inspira confianza, los exámenes de biolo eran largos pero no dificíles. Aunque las presentaciones no tenían mucha info el explicaba bien'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'a4674fa144edd437bb9290b10232eef458498ca9e097c6f98565780ee2b73c06'::TEXT, ARRAY[1977, 1460]::BIGINT[]),
    (74::BIGINT, 'Explica todos muchas veces para que se entienda, las clases son un poco aburridas porque habla despacio pero cae bien'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-12T00:00:00+00:00'::TIMESTAMPTZ, 'bef9ee20c9707692e43328318709caecf77af503e31c6064f363cef0a8476543'::TEXT, ARRAY[1460]::BIGINT[]),
    (74::BIGINT, 'lo tqm, es un tipaso'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-15T00:00:00+00:00'::TIMESTAMPTZ, '38404771a80608fd4a4bd512412772ab4784d04f7e215c854695e726c550249f'::TEXT, ARRAY[1977]::BIGINT[])
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
