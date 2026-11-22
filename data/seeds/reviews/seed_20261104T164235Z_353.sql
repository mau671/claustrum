-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=353
-- TEC-DATA-META years=2016,2017,2018,2019,2020,2022,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.889247+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (353::BIGINT, 'Es flexible con las fechas de entrega.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'cfc7b8548959f68454e24535c7bfce28afbcd6734935a190a335198edcbf6414'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'El profe es un crack, explica lo justo y necesario. Se pasa super rápido la clase, se vacila y se aprende. Lo recomiendo 100%'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Brinda apoyo']::TEXT[], '2026-06-21T00:00:00+00:00'::TIMESTAMPTZ, '77c8b91b67d7ef09990a989b40785dcc3ef028b7e115137cb4ca58f8fce9346b'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'no es claro explicando, no resuelve los ejercicios dificiles en clase y cuesta que haga los procedimientos completos. Se pone creativo en los examenes y califica duro. Hay que ser algo autodidacta para pasar el curso.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, '57ba2b5b73abb87e4e75e8172c05df620bc019e29a23b8e071d5ac353486d9fa'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'El curso es facil mas el mae lo complica con ejercicios que no se ven en clases en terminos de dificultad. Ademas si le cae bien el grupo los examenes los hace facil y si no se pone creativo. Sean lavahuevos'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, '3457202f9ebf5144ceede2d4965a3d0e93c0be545af7ce678621e61b124a6983'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'Muy buena nota y flexible con las fechas de entrega'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-12-07T00:00:00+00:00'::TIMESTAMPTZ, '4896efd054879e5a32945b2f8e1b404b22dd593cf17466d0122f813c4b9e82e5'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'Es malo como profesor. Hace ejercicios 0 parecidos a los examenes. Da solo 40 min de clases con ejercicios sencillos pero en el examen se raja. Como persona es tuanis. Pero como profesor pesimo'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-12-06T00:00:00+00:00'::TIMESTAMPTZ, '03c8c75fdfabe241806c9b9384b309f3abdff730e952b9f07d359d64eadf9a60'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'Como persona es buena gente. Explica mal no es claro. Las clases son un jolgorio tras que no explica mal hay grupitos que se ponen en un chingue y se convierte en distracción. Los exámenes no son difíciles pero la materia es aburrida y el profe la hace aun mas aburrida porque no explica bien.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico']::TEXT[], '2025-11-27T00:00:00+00:00'::TIMESTAMPTZ, '54ca3a70260539f6b9df57a083e92f7f0b206c5aaa865d50c06f7ad6e46dc4b7'::TEXT, ARRAY[1195]::BIGINT[]),
    (353::BIGINT, 'Se parece a Rommel ????'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, '09c6106ae1fad526b737a691e0bd2f2f79ea5018ad92b59891223cfc8d1a9746'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Súper buen profe, ojalá hubieran más así, los laboratorios son largos, se sale 2 horas despues del horario, entonces no matriculen nada luego, recomendadisimo. Muy fácil'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2025-07-17T00:00:00+00:00'::TIMESTAMPTZ, '017e3566f3a264d2edde2a65a9ca1f105560777684d8c5f452a85f0eed82515f'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Es muy pura vida, siempre está dispuesto a ayudar y es muy compresivo con uno. Los informes son fáciles y las tareas también. El laboratorio en sí es muy entretenido y tranquilo. El curso casi ni lo va a sentir'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2024-12-06T00:00:00+00:00'::TIMESTAMPTZ, '0b133f70f414ac7affad61b45a6924d8bc1932e88cc77f9d3ba58fd5c96c2b98'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Una joya de profe. Super pura vida. Ayuda mucho a correr la entrega de las evaluaciones cuando verdaderamente se necesita. Las prácticas las hace entretenidas y hace que el lab sea una muy buena clase.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Aspectos de calificación claros']::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, '8293fbbfbc35b16c5c1165542ba22ab00d9495b914e7aedeffa14a1615198928'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, '¿Soy yo o el profe está guapo? Posdata: a veces hace quices con trampa'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2023-07-11T00:00:00+00:00'::TIMESTAMPTZ, 'c9dd11496076ee4aacd0d3b9a44149535cfb7a649f425c2d76f1e2ed57700f3d'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Un profe ak7, no califica tan rudo, es como si fuera otro estudiante pero que ayuda con las dudas'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-09-23T00:00:00+00:00'::TIMESTAMPTZ, '924360a62d9d4645396abff58a4157d30d625901fdd9301dd3e16fb3c9b9d39a'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'De los mejores profes que uno se va a encontrar en la carrera'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '5201c08863b3b77618dd7bfde5360cd08972670b04b1e3264088d6e084eb5f62'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo']::TEXT[], '2020-09-01T00:00:00+00:00'::TIMESTAMPTZ, '09555ce5c7360fe5d2448ec3bfe15c9b0c165d61432337594c41e559e786e3c7'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Es un profesor el cual sabe mucho, siempre esta atento a todas las dudas que uno le tenga, es super accesible. Su forma de ser con los estudiantes hace que uno ve el curso sumamente facil y aveces no llegue a ser muy claro, pero si uno se acerca a hacerle cualquier consulta, explica excelente'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-27T00:00:00+00:00'::TIMESTAMPTZ, '86f1013cee11a63aab346d7d33f0baf39913c790201accb03aa09a0741338646'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Un desmadre como profe, hace super sencillo el laboratorio, asi deberian ser los dems ya que a muchos no nos interesan esos temas jaja ! Crack como pocos'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'fe4c35e5b9620a63974357fe862d33f1bb2ab3fbbfb046819ebe8313211773e1'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'El profe básicamente es como un estudiante más, la evaluación del curso es bastante accesible, explica las prácticas de cada semana por encima, es un poco desinteresado, pero es super buena nota y se apunta a vacilar con los estudiantes, califica bastante normal'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-07T00:00:00+00:00'::TIMESTAMPTZ, '9c4e83af60bc74397cc04315fd0f3f8cd98f8dc4a2896c78a689478b954ead91'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Profe súper relajado y buena nota...... Hay que hacer esfuerzo para quedarse en ese curso!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '012addd8ac27d17e870bd667e4a55cab799cf15f61ef70c637554d5036065240'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'No es tan decepcionante jaja'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '930c1367dfc9da1a00362b279735a40076a5bd092af37f2487a90870f9a3ef7a'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Es decepcionante!'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muchas tareas', 'Pocos exámenes']::TEXT[], '2017-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'f17def0cd557e1d1e217633800f2ac1c8145fbb4b7fa74d534baa2a9b9a1d985'::TEXT, ARRAY[1208]::BIGINT[]),
    (353::BIGINT, 'Es un profesor regular, no le molesta que se note que no conce bien la materia, el primer informe lo califica duro.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-11-12T00:00:00+00:00'::TIMESTAMPTZ, '4c70afa322b2d1adc34a9bb83cb83bc747cca0e80e4d9e152f510282f0c99bb6'::TEXT, ARRAY[1208]::BIGINT[])
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
