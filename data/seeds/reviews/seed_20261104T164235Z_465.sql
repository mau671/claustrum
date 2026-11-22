-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=465
-- TEC-DATA-META years=2020,2021,2022,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.965758+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (465::BIGINT, 'Ha mejorado mucho como profesora, sus cursos son pesados pero con atención se pasan fácil, se le puede contactar fácil y responde dudas'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2025-08-05T00:00:00+00:00'::TIMESTAMPTZ, '157707136b1bc1dacd704c23f5bfff3f93348bcf62bdc59b1963d839b68a30d0'::TEXT, ARRAY[1739, 1722]::BIGINT[]),
    (465::BIGINT, 'En algunos aspectos es buena profe, pero de un tiempo para acá piensa que uno todo lo hace con chat gpt, no logra aceptar que uno escribe bien y redacta bien. Es muy pasivo agresiva en los comentarios que deja en los documentos, tiende a comparar mucho a los estudiantes y eso me afectó bastante.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2024-11-18T00:00:00+00:00'::TIMESTAMPTZ, 'afb1387d890065db41a3d722c0eae4796af1699e7bb1d45a9c2e4210ce6ae763'::TEXT, ARRAY[1722, 1719]::BIGINT[]),
    (465::BIGINT, 'No recomendable matricular con esta profe, en un año y medio tuve que soportarla con su montón de tareas extra, clases obligatorias, había que hacer incluso un bendito portafolio de evidencias y ni ella misma sabía cómo utilizar la página que solicitó usar, califica horrible.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2024-10-11T00:00:00+00:00'::TIMESTAMPTZ, '78e482da98b2a449ea68ad5cce472f88deb87b0b3efb3ae2a6a744f182cd2c88'::TEXT, ARRAY[1739, 1749]::BIGINT[]),
    (465::BIGINT, 'Demasiado mala, dizque explica materia y lo que hace es confundirse hasta ella misma, justifica su mediocridad con frases añejas y siempre se victimiza, si la intentas corregir te irá mal, no recibe sugerencias y en conclusión es una PÉSIMA profesora y una profesional mediocre.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2022-06-29T00:00:00+00:00'::TIMESTAMPTZ, '0187a4efd790a0298d1002141f94b51a3748be5e977285e2782ef45b2fc84796'::TEXT, ARRAY[1722, 1719]::BIGINT[]),
    (465::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2022-06-28T00:00:00+00:00'::TIMESTAMPTZ, '185ecbebf34420d2fb3d2e81bd9eb898ee7e9d6fa315a7d36b3c310dd6a2bc26'::TEXT, ARRAY[1749]::BIGINT[]),
    (465::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-07T00:00:00+00:00'::TIMESTAMPTZ, '4b0bd3b4f43f88966682f42a9af48ebb95047cb514b6c28d5d145baba056d999'::TEXT, ARRAY[1739]::BIGINT[]),
    (465::BIGINT, 'No matriculen con esta tipa, como profesora es PÉSIMA. Da "explicaciones", pero sólo confunde más a los estudiantes. Cuando se le pide ayuda para que explique un trabajo, es un dolor de cabeza para que solvente la duda. Deja trabajos como que si uno sólo matriculó curso con ella. Material confuso.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2022-06-01T00:00:00+00:00'::TIMESTAMPTZ, '752a9aeae88a25528ec3b16efcf83ba9140e2b908302aa9468295ed34c486e24'::TEXT, ARRAY[2376]::BIGINT[]),
    (465::BIGINT, 'No sirve, la peor profesora que tiene el TEC, es demasiado confusa, ni ella misma se entiende, califica como si explicara excelente y es una profesional muy mediocre, si le pides ayuda no lo hará, si eres primer ingreso o no, te recomiendo que no te embarques.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2022-03-31T00:00:00+00:00'::TIMESTAMPTZ, 'd08a1641a337eb3e031d4e5acf7df2519d8aadd6ddd8c89bba59533a01bb0295'::TEXT, ARRAY[2376]::BIGINT[]),
    (465::BIGINT, 'La peor profesora que he recibido clases en mi carrera de Admi, deja demasiados trabajos piensa que solo se cursa esa materia, las clases son demasiado extensas, las clases asincrónicas son peor que las presenciales porque es entregar muchos trabajos. Para resolver los exámenes se toma casi un día.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-05-27T00:00:00+00:00'::TIMESTAMPTZ, '769ed3722b889debcc3b136346e03a0f1a94c369faf1f3791eaf0a14bf5c4088'::TEXT, ARRAY[1749]::BIGINT[]),
    (465::BIGINT, 'Deja material adicional para complementar lo que no sabe explicar en clases, se pasa fácil pero no se aprende.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2021-02-24T00:00:00+00:00'::TIMESTAMPTZ, '3a398710aff02565cc9fe0ac3567bb88227dfa24e58b337b07c29e2e725137a6'::TEXT, ARRAY[2951, 1749]::BIGINT[]),
    (465::BIGINT, 'De forma virtual deja demasiado trabajo. En clase explica cosas basicas y uno debe investigar el resto, habla mucho por lo que se extiende demasiado la clase y no se aprovecha nada. Evalúa muy duro. De verdad que fue mi principal causa de estrés durante la virtualidad'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-25T00:00:00+00:00'::TIMESTAMPTZ, '64f562a5342397eae60f73e859359590bc74cf567e19726d8c291b95171cef57'::TEXT, ARRAY[1739, 1749]::BIGINT[]),
    (465::BIGINT, 'Si tiene que explicar 20 veces lo hace. Las horas consulta me sirvieron mucho. Por la clase virtual y lo práctico da muchos videos que ella hace y explica otras cosas en directo. Para mi es buena profe pero es estricta y califica duro. Si ud le pone ella lo reconoce. Si es vag@ va a chocar con pared'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2020-09-08T00:00:00+00:00'::TIMESTAMPTZ, '7571c0f89ccbdd43fedc37353dfe4a0061d70bdf5ed4019d1cca9d230648ef98'::TEXT, ARRAY[2951, 1749]::BIGINT[]),
    (465::BIGINT, 'Se enreda al explicar, deja material extra (videos, tutoriales,etc) para complementar los temas que casi no explica, si quieren aprender se debe ver los tutoriales que deja más otros encuentre en youtube. Deja mucha tarea que sirve de práctica para los exámenes. Recomendado ir a horas consulta ????'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Muchos exámenes']::TEXT[], '2020-09-03T00:00:00+00:00'::TIMESTAMPTZ, '05e39b0c298f8386acf5099512265e279f0a69ef3b277ca04d62d49e682eabf5'::TEXT, ARRAY[2376]::BIGINT[]),
    (465::BIGINT, 'Como profesora es pésima. En la clase explica temas extremadamente básicos y pretende que todo lo complicado se aprenda de forma autónoma con guías. Llevaba materia de semana 3 en semana 5. Pretende que se revisen videos, guías, la clase, tareas cada semana, proyecto, es imposible cumplir con todo.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos exámenes']::TEXT[], '2020-08-28T00:00:00+00:00'::TIMESTAMPTZ, 'd9d9b8e9b644280e738dba1cc875497da565ecd0b2866c9fac6cadc2630adc0b'::TEXT, ARRAY[2376]::BIGINT[])
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
