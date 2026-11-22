-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=620
-- TEC-DATA-META years=2017,2018,2019,2020,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.142352+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (620::BIGINT, 'Con ella nada es ni claro ni de acuerdo al cronograma, teníamos que hacer tres giras con sus respectivos informes y solo hicimos una. Dura mucho en calificar y parace que no se pone de acuerdo con Mario (segundo profe). Al final del día uno pasa mágicamente, solo tenga la vara para la entrega final.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-12-13T00:00:00+00:00'::TIMESTAMPTZ, '352a87be4490cac341a3eac3022987bd5eedbc5b368d64fc2a1baa260cae3ea1'::TEXT, ARRAY[1861]::BIGINT[]),
    (620::BIGINT, 'Una buena profesora, el curso es muy llevadero y fácil de entender por los cursos que se llevan de antes, talvez se puede pensar mejor el tema a desarrollar cada semestre para crear más interés en los estudiantes y una mejor organización.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-09-06T00:00:00+00:00'::TIMESTAMPTZ, 'a2b2864b8db59e48012e825a24e327dd16c7dd5739fe3a66aa2a361cec9d091e'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Muy buena profe. Es muy buena gente y todo lo explicaba bien!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ, '7bc8c2acefce027aa32c4f2b59a01949e22518517dd1a403e2df7ef73a33f18c'::TEXT, ARRAY[1848]::BIGINT[]),
    (620::BIGINT, 'Las guías de trabajo no son claras, ademas de que se enoja si uno no entiende las guías, las notas las da un mes después y la retroalimentacion es pésima, una vez le pregunte por un correo que le envié y lo que me dijo fue que lo vio y lo ignoro porque tenia otras cosas que hacer. No la recomiendo'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, 'c4dd2fbf7fa6a327d65ca9f59d86ba5f0b9e04e540f2ee6cc8592d0651ef3a3d'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Muy buena profe, ayuda siempre que puede, da la clase muy clara entonces uno no termina enredado a la hora de hacer los trabajos, lo único es que dura mucho tiempo revisando así que Armese de paciencia, pero siempre revisa con rúbrica clara y si usted hace lo que pide en la rúbrica le va a ir bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2019-12-02T00:00:00+00:00'::TIMESTAMPTZ, '376d0663979962f779b35b8531d6018b9cfdfa20051eb302d1f05ba08e0adede'::TEXT, ARRAY[1850]::BIGINT[]),
    (620::BIGINT, 'buena persona pero como profe le falta un poco. siempre va a ayudar cuando ocupen ayuda, pero las cosas que te dice que cambien son las cosas que luego suele ver mal.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'f0a6a695c8b2b8dcbdced4c77de8781a6dd8c91b3341ee3e84d09822c10f3b1b'::TEXT, ARRAY[1852]::BIGINT[]),
    (620::BIGINT, 'La retroalimentación no es suficiente, no le dice directamente si algo esta mal'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '8b25c0fa623d0cd1ee3a4a85cf1cd4f700869503e4578701106404c6bad9cc84'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Solo con decir que han pasado semestres en donde más de la mitad de los alumnos se le quedan ya queda claro que no es buena profe. Muy buena persona y profesional, pero no pedagoga. Si le sale Leo en la matrícula, sin duda váyase con él.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales']::TEXT[], '2019-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'a62e45d62033a36e471d93ed0542292b473b09ee88e72b11aa795a379800682b'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-13T00:00:00+00:00'::TIMESTAMPTZ, 'a633c72a5fc1a8a47e828c1623056775fd21ff4d37f7d9f57e098e2dca59197e'::TEXT, ARRAY[1852]::BIGINT[]),
    (620::BIGINT, 'El peor curso de carrera hasta el momento. Un proyecto final MASIVO (palmadas seguras) y completamente obsoleto en el mundo real. La retroalimentacion por parte de la profesora da lastima. Además califica DURISIMO y la rubrica es inexistente sino que hasta despues de haber calificado.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2018-12-03T00:00:00+00:00'::TIMESTAMPTZ, '111a9b7a356bfb7e0078cc0198270b57ef92a93a9514cf7e8e1232e938ea06bb'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Es una buena persona y seguramente buena diseñadora industrial, pero no es buena profesora. Las clases no aportan más que las lecturas del curso y se enreda mucho. No comunica los criterios de evaluación (rúbrica) antes de entregar un trabajo, por lo qué hay que pedírsela.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-26T00:00:00+00:00'::TIMESTAMPTZ, '62b582301ff5f9ed68ce59a1ebd49964f9a157517ada150ed8a77938d1483c49'::TEXT, ARRAY[1868]::BIGINT[]),
    (620::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, '1ec4377cf6cae69d85f4b71f9a8837e698cbcc07dd8d604ab609c9fd502744d5'::TEXT, ARRAY[1920]::BIGINT[]),
    (620::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Inspirador', 'Brinda apoyo']::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '52f30178c2eb43ded2e21d37bb9bbaccb78410e6239745375002efdd2a1d72a2'::TEXT, ARRAY[1852]::BIGINT[]),
    (620::BIGINT, 'Muy buena profe.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2017-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'e33434bc23b0c9e46d964ba82f49f00ceaf9692fafbb32b16c2988efc4d51ed1'::TEXT, ARRAY[1867]::BIGINT[]),
    (620::BIGINT, 'La profe es un amor, una de las mejores profes de diseño, se nota que sabe y califica de acuerdo a lo que da en la clase. Se preocupa por los estudiantes!'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'ec388b5fd25ebc90559c265122a52f2ee54e1b9527d3cd8f344df943fa21b5ce'::TEXT, ARRAY[1867]::BIGINT[])
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
