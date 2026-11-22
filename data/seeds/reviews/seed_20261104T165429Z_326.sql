-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=326
-- TEC-DATA-META years=2023,2024
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.132604+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (326::BIGINT, 'Le interesa bastante la comprension de los estudiantes con la materia brindada y le llama la atención que el estudiante sea constante, que presione y aprovechen las herramientas brindadas en clase.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da crédito extra', 'Muchos proyectos grupales']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '54af3879627e6d891a45899468188f0b6a8852ea30da8c1cae7b6e7de993514c'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'El profesor omite aspectos importantísimos en la explicación referente al manejo de punteros en c++ y también omite explicaciones sobre como funciona la syntaxis y tips del lenguaje c++. Esto repercute mucho a la hora de enfrentar los proyectos programados los cuáles son pesados.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Deja trabajos largos']::TEXT[], '2023-12-18T00:00:00+00:00'::TIMESTAMPTZ, 'dd6e1ff2b743cbd2a7e7d6df244164139c1be8ed2f69d18f1aa3d1ec4fc6889f'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'La clase no incluye instrucción sobre código y asigna proyectos grupales de forma aleatoria que requieren código muy complejo, el cual no se ha cubierto en clase. Además, modifica la rúbrica cuando ya está calificando y los métodos de entrega son innecesariamente complicados.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2023-12-13T00:00:00+00:00'::TIMESTAMPTZ, '301a877f3847c20d96ab2bb804a06bbceed32ca55913aa6e19e7e0747981e8c2'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'no aprendi mucho la verdad, pero es pasable el curso'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-13T00:00:00+00:00'::TIMESTAMPTZ, '4f8c9d7d4671699321a24081e836b284c4b2f2d2e81cb43f7f66ce5ac23a9083'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'El profesor domina el tema de los algoritmos, pero no tiene idea de cual es la conexion entre los algoritmos y la electronica, lo cual denota falta de experiencia. Da ejemplos muy cortos, no deja tomar fotos y parece que le molesta que apunten los codigos que da en clases o ensenar codigo.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'af9bec0d135c18b2597865f1d44d845a9dfdd6475796a989af7a74c166b687d3'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'Exige linux, pero no da ninguna ayuda si no has utilizado este sistema. En windows no brinda soporte si tienes problemas con el código.Habla muy rápido, y no explica de todo claro. Usa diapositivas, pero tienes que copiar todo lo de la pizarra, no permite fotos ni pasa la presentación.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-27T00:00:00+00:00'::TIMESTAMPTZ, '756fe01847fd820d33cd1cfd46770324ef5873db08425699e14376db49b17e16'::TEXT, ARRAY[1253]::BIGINT[]),
    (326::BIGINT, 'No se le entiende nada cuando habla, habla muy rápido y muy bajo, explica todo muy rápido y apresurado, explica mal, es nuevo y se le nota la falta de experiencia, ni cerca de ser un buen profesor'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-05-25T00:00:00+00:00'::TIMESTAMPTZ, 'db37bf6d7216f73ef295cccb4eec2d0b97bd889decbd71cea3b354d4d230920e'::TEXT, ARRAY[1253]::BIGINT[])
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
