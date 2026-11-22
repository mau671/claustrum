-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=267
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.863602+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (267::BIGINT, 'Clases aburridas y largas. La profesora califica que forma bastante dura y deja trabajar innecesariamente largo. No muy disponible para consultas y cierta condescendencia cuando si lo está. No llevaría otro curso con ella.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ, '1e076595d4ae17fd844cf95550ee9a31a535717fb24ed0cc81a616fccf83f85c'::TEXT, ARRAY[1249]::BIGINT[]),
    (267::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Clases largas']::TEXT[], '2025-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'b30ce0164056e96060cb5fc53ac8c03cf199af50a153975366ddcf6393eb2864'::TEXT, ARRAY[1249]::BIGINT[]),
    (267::BIGINT, 'Las clases son cansadas y aburridas. La profe es algo amable, sin embargo no llevaría otro curso con ella.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '6f20efc288653c16771ea2b053f32500c429be7432cd031c4d046ba5c2d0dfff'::TEXT, ARRAY[1249]::BIGINT[]),
    (267::BIGINT, 'Da crédito extra pero a sus favoritos. Prepárate para la evaluación más subjetiva posible, por rúbricas que se van por el camino que la profe desee. La tutora del curso ella la elige y parece que se basa en su perspectiva personal.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Da crédito extra']::TEXT[], '2023-04-15T00:00:00+00:00'::TIMESTAMPTZ, 'e5e1d1f9bad4eb245be88663ba14ac4ff7a7f5f346e1e8059cffe58791f14671'::TEXT, ARRAY[1017]::BIGINT[]),
    (267::BIGINT, 'Académicamente es excelente docente en cuanto a claridad de los temas, vocación por la labor decente y pedagogía sin quejas. En otros aspectos, es una persona que tiende a "medir"a las personas por sus notas, por lo que va a tener favoritos en sus clases. Se deja llevar por prejuicios.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Pocos exámenes', 'Exámenes retadores']::TEXT[], '2022-12-24T00:00:00+00:00'::TIMESTAMPTZ, '3f424d85bc58b12f6e0654822b532d69af53ee32405e961472c4665c85c84f20'::TEXT, ARRAY[1017]::BIGINT[]),
    (267::BIGINT, 'Es buena persona pero nada buena como profe. La mayoría de sus clases eran leer presentaciones, hacía muy pocos ejemplos de codigo, súper enredada. Las tareas y proyectos muy complicados y aunque respondía las dudas por Whatsapp, no aclaraba nada. Cuesta demasiado entender y pasar.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2021-11-30T00:00:00+00:00'::TIMESTAMPTZ, 'c56d96f1eb11affe06f238011805a3af7e5eb5ec29be0e7c3adc40d61e559017'::TEXT, ARRAY[1253]::BIGINT[]),
    (267::BIGINT, 'Buena profesora, dispuesta ayudar. Explica muy bien los temas y a pesar de que el proyecto de ensamblador sea complicado, ella trata de abarcar el tema de la forma más clara posible.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-11-21T00:00:00+00:00'::TIMESTAMPTZ, '996b32f49e4966259fb0ebeff3fd31da45b1ae9a13b27c3c64cb819acff3af6b'::TEXT, ARRAY[2918]::BIGINT[]),
    (267::BIGINT, 'La profe es buena nota, da buenas lecciones y si no entiendes ella te hará hacerlo.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases largas', 'Exámenes retadores']::TEXT[], '2021-02-23T00:00:00+00:00'::TIMESTAMPTZ, 'babd9581901a1e561b00d09b8206593d07052b0e46af1bff9de8e4458dc8673e'::TEXT, ARRAY[1249]::BIGINT[])
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
