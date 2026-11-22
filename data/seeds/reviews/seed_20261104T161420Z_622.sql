-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=622
-- TEC-DATA-META years=2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.143554+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (622::BIGINT, 'Los trabajos son bastantes dinámicos, es mejor en Análisis II que en Análisis I, ya que se encuentra más familiarizada con los productos digitales; la comunicación con ella es casi nula y el único espacio para conseguir retroalimentación es después de las lecciones, casi nunca contesta los correos.'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-01-06T00:00:00+00:00'::TIMESTAMPTZ, '592fbcf0106611a96e2f077468eae4d8cf1ec06e6e23e03bf537558516b88e90'::TEXT, ARRAY[1848]::BIGINT[]),
    (622::BIGINT, 'Es mejor que en Análisis I, hay que adaptarse a su manera de trabajar o de como quiere que uno trabaje, pero cuando le agarra el toque todo es súper fácil. TODOS los proyectos son en el mismo grupo, entonces hay que elegir bien a los compañeros.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-12-14T00:00:00+00:00'::TIMESTAMPTZ, '723a084615a225836f32b01a648160ad71af27a94df056db3828d4cbe335603b'::TEXT, ARRAY[1848]::BIGINT[]),
    (622::BIGINT, 'La profe es muy buena, pero muchas cosas quedan en el aire. La comunicación es un poco complicada y a veces la organización de las entregas deja mucho que desear.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, '10a80b661f209dc914f9f143d954ab5d066649dff37181be3c2eb63a8ec22ecf'::TEXT, ARRAY[1848]::BIGINT[]),
    (622::BIGINT, 'Es muy linda persona, sin embargo en algunos aspectos como profesora le falta mejorar. Comunicarse con ella es muy difícil y sacar consulta por aparte es casi que imposible.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-24T00:00:00+00:00'::TIMESTAMPTZ, '10ccafef8e7fda17370fd3640bbea29baccc9138e1ef3ac57f0c19a191df8efb'::TEXT, ARRAY[1845]::BIGINT[]),
    (622::BIGINT, 'Ella es la definición de enseñanza moderna. Sabe lo último en tendecias de UX y UI, ayuda mucho y es muy imparcial. Matricule con ella siempre que pueda.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Clases excelentes']::TEXT[], '2021-02-01T00:00:00+00:00'::TIMESTAMPTZ, '17d5473ac66c9cd0f9f7473bd25bb27bb0fb36ecd14c6f52fda9035c2716cc3e'::TEXT, ARRAY[1875]::BIGINT[]),
    (622::BIGINT, 'La mejor profe que pude haber tenido en comunicación visual. La materia súper clara, las notas se entregan rápido, la consulta es súper productiva, las clases son cortas y «a lo que vinimos»'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2021-01-25T00:00:00+00:00'::TIMESTAMPTZ, 'ad41e4111023630bf78153c787ddd73f021aa809acd7303afed36d6e643ffa7e'::TEXT, ARRAY[1848]::BIGINT[])
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
