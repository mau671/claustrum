-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=273
-- TEC-DATA-META years=2021,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.868505+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (273::BIGINT, 'De los peores profes de compu, las clases son un bostezo y explica lo mismo una y otra vez, los proyectos son un poco pesados y pues nada similiar a lo da en clases. El curso era Diseño de Software y lo que menos se vio fueron principios de diseño.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, '1c94ecd7dfabe80d5d608350b9fbf203fa3c8eaa300935f7d2d83af91179e41d'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'El curso parece más de metodologías ágiles que de diseño de software, las clases sirven para poco y nada. Da libertad creativa en las herramienta a usar, no espere que enseñe nada de código. 3 proyectos, 2 móvil y 1 web además de 1 examen para la casa. Califica suave pero busque buen grupo.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muchos proyectos grupales']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, 'b457ddf7b35d9e41e21452702a4dc1784d96c2c34c9ef1cd8aa2aafeab113403'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'Demasiado aburrido. 4 largas horas del profe hablando y hablando. El curso no estuvo mal y el proyecto se trabajaba en clases lo que ahorraba tiempo para otras materias. Sin el minimo esfuerzo igual se pasa. Aburrido pero facil.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-28T00:00:00+00:00'::TIMESTAMPTZ, '16d0dac96aae2eec6a57b6b87a5f5d13345610688d9386ea1cb6c5f522b91233'::TEXT, ARRAY[1039]::BIGINT[]),
    (273::BIGINT, 'Horrible, hace la clase muy aburrida, pone la presentación y no para de hablar, cero práctica. Califica demasiado suave, cualquier vago pasa.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '45e2a7c002222bfca92dec73f05ff27702a14a7e2f10004e705b9c9c33464aea'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'Muy aburrido, clases largas donde repite mucho de lo mismo durante todo el semestre. Parte de la clase es trabajo en el proyecto pero no ayuda practicamente en nada y pasa a revisar siempre hasta el final de la clase'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Muchos proyectos grupales']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '69b51a45c06f1867a7af89863ce8118e6e152e71025d2d8205767f54177cce7f'::TEXT, ARRAY[1039]::BIGINT[]),
    (273::BIGINT, 'Excelente profesor de lo mejor del TEC'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-03-12T00:00:00+00:00'::TIMESTAMPTZ, '58610919bfead946f926ac2cfb9647ee7864d2ccfa35a48fac4b7346c49af5c1'::TEXT, ARRAY[2926]::BIGINT[]),
    (273::BIGINT, 'Sabe muy poco. Los proyectos no se relacionan con lo que se ve en clase. Toca investigar todo lo de los proyectos. Viendo el lado bueno, aprendes web y mobile de forma autodidacta de forma obligatoria. Desde este punto de vista se aprende pero no por ayuda del profe.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Da crédito extra']::TEXT[], '2021-12-16T00:00:00+00:00'::TIMESTAMPTZ, '396c11c592e19ba6cae64af9175ef9a24a541b57446d64b815a4785e00349fba'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'El curso no fue lo que imaginaba la verdad. El defecto principal es que en clases se ve pura teoría y muy redundante... y los proyectos programados son muy diferente a lo visto en clase. 3 progras (web, mobile y otro). Ni una línea de código se muestra en clases NADA. Prepáresen para investigar.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos']::TEXT[], '2021-05-13T00:00:00+00:00'::TIMESTAMPTZ, '101c0d3a0ea756e14b177953540985cb385e53b7a7ab9d297553121faca3d42d'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'Con todo respeto, es sin duda alguna la clase más aburrida que he llevado en el tecnológico, en las clases no enseña más que teoría repetitiva y la dificultad del proyecto no concuerda nada con los temas vistos en clase, cero recomendado'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-03-09T00:00:00+00:00'::TIMESTAMPTZ, 'd255836e14937324ddb727ed8a8db91b762b7eed0d44a8f09d9efcc3f062c07a'::TEXT, ARRAY[1047]::BIGINT[]),
    (273::BIGINT, 'Clases largas, proyectos exagerados.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-03-09T00:00:00+00:00'::TIMESTAMPTZ, '919723cf478d4fb667fb1f3c250a65abf6761f4084443eb00f727cbb28266953'::TEXT, ARRAY[1047]::BIGINT[])
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
