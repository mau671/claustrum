-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=169
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2020,2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:56:56.137227+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (169::BIGINT, 'La clase se pasa sola, las evaluaciones son un regalo. Es virtual y no pide cámaras. Ella es super buena gente y comprensiva por si uno no se puede conectar o lo que sea.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-13T00:00:00+00:00'::TIMESTAMPTZ, '3970774afe6421efa9a9e4f572c9d9225ae8d56a28c7332bac885aa3eb3d4bc3'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Llevar culturales con ella es super relajado, usted nada más entregue los trabajos. Ella no es exigente, solo que los estudiantes sean participativos en clase. Es muy amable y comprensiva.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-06-30T00:00:00+00:00'::TIMESTAMPTZ, '88425717c5c5f0f188a8e718fe8b2a801e14c1793e5344d1c9042931c9248cdb'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Excelente profesora. Es muy buena persona, explica bien los temas, es clara con las evaluaciones, y siempre está dispuesta a ayudar. Las tareas y proyectos que ella deja no quita mucho tiempo, y con solo entregarlos y asistir a clases, se pasa fácil'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-17T00:00:00+00:00'::TIMESTAMPTZ, '895566f4e90b406e50ae112721bffbe7c44c1f66334e3c6f02455882ad4537e5'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es muy creativa, hace muchos juegos en clase, allgunas veces no le gusta explicar por segunda vez las instrucciones, se fija mucho en el comportamiento de los estudiante, como llegar tarde, poner atención en clase'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'f9fcac70e3580159079e71104af4064b4746c1912110d1c8bb6dd62109cbbc3b'::TEXT, ARRAY[3132]::BIGINT[]),
    (169::BIGINT, 'Una excelente profe! Hace muy amena la clase, siempre está dispuesta a dudas de los estudiantes, y las atiende de la mejor manera! Me gustó mucho la clase con ella! Se aprende bastante, el curso es muy bonito! Super recomendada!!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2023-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'eed7b39adebb94291274aaec28bf9acb5c1deac2fc8f598bb2b82e47bce10681'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es muy buena profe, las clases son un poco aburridas pero tiene cosas muy interesantes y se aprende bastante'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-04-25T00:00:00+00:00'::TIMESTAMPTZ, '1582c0da6b38b8de941a6ef3a7b387a901af5051b387e01659f96961e24c6323'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Dele sin miedo, las clases son muy chill y entretenidas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2023-02-02T00:00:00+00:00'::TIMESTAMPTZ, '4d933d1016fe1839e9a47ccad252aaacc8f2571103fdede815db5578ff602bc5'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'La mejor profe, si puede meter con ella ni lo dude. Los trabajos son fáciles y las clases son entretenidas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '9f2f6aaf4ffa770ad2cc35a6cb979c4ce55017344d600e70e9befe475fcde3af'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Muy buena profesora'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'cca146b80d42da5d6dea42d82b177b337e7f96ab6917cb4a00106b23b7cc276c'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Podría ser de mis profes favoritas, cae muy bien, super amigable y cómica. Tenga presente el tipo de curso, porque si no le llama la atención lo cultural, le va a parecer difícil y aburrido. Aunque la profe es muy sencilla para calificar, sin duda la recomiendo, es interesante y se aprende.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2021-06-04T00:00:00+00:00'::TIMESTAMPTZ, '1447e381bd52d58422a2e37590811be1c0eff6e8cbe77cff790f38b1dbf82dbb'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Le gusta su trabajo, se preocupa por los estudiantes, una profe increíble en todo sentido de la palabra. Los trabajos que pone son acorde a la materia. No se va a arrepentir si mete esta cultural con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Aspectos de calificación claros']::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, '2c03464ed5b903720ae048d9832ccc3cabc8ae8190eda95f9072f1840043ce98'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es excelente profe y persona. Se preocupa mucho por el bienestar de los estudiantes y la salud mental de todos. Califica super bien y las clases son muy entretenidas y sencillas. Es una profe que recomiendo al 100%. Tienen muchísimas probabilidades de llevar una nota excelente y subir el promedio'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2020-12-07T00:00:00+00:00'::TIMESTAMPTZ, '9e2a9bc1d7d07e9ffd10bbe518d90e4d3aada95a5f6c51796d582ea6074f6e34'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'El curso depende de los trabajos. Si se hacen correctamente, todo muy bien. Es sencillo pero si ponerle ganas a los trabajos para pasar fácil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Respetado por los estudiantes', 'Deja trabajos largos']::TEXT[], '2019-12-05T00:00:00+00:00'::TIMESTAMPTZ, 'f2318b0291fdbc22142c378ef85bee89f02e26d95620c9a2b1ef46c00c972cad'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es demasiado progre y chancletuda, sin embrago es muy buena nota, deja 2 trabajos bastante grandes de los cuales depende su nota, si los hace fijo pasa relativamente fácil.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2019-06-24T00:00:00+00:00'::TIMESTAMPTZ, '10d8693c5fe8a1faf1b6cefd052372a6fddc9baf76f83f40b300a77f84836d66'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es buena profesora, no califica duro, pero deja trabajos que quitan mucho tiempo. Hay clases que se hacen largas y aburridas, pero excelente persona.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2018-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'ec9f5515abd99c69918e77a2200b0e6c0c7ad208a32f63d09e9de3dff46cb758'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Es buena nota, solo que no entiende que su curso es una cultural, entonces pone dos trabajos grandes que si uno no los hace puede quedarse.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'd606dfe65d4e7f97f0ce94522f2f622117ff6e0590018f1d6e103a34eac317c6'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'A pesar que el curso sea una cultural, ella es demasiado buena nota, si usted ocupa ayuda o algo, ella con gusto lo va a ayudar. Pone dos trabajos grandes, pero no es nada del otro mundo. Súper recomendada'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-11-04T00:00:00+00:00'::TIMESTAMPTZ, '92a8f81ca22432f459f657f93aa69318c2e51a43f383b3d30bd6eed4feb44975'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'cf57c2453577e8d5001928f35c609951fe57584ce1fe327716157dc79f61ba03'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Demasiado buena'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'a66b46eecf2384f5e5764097f3196f03f4073a7e6084cd96400523b35111d5a7'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'No hay mucho que decir, es acción social, es una clase entretenida, y vale esos 0 creditos ;) Además Sofía hace la clase muy entretenida e interesante. recomendada al 100%.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Inspirador']::TEXT[], '2016-06-28T00:00:00+00:00'::TIMESTAMPTZ, '436072f9b82183d052ce03bc1dad5341624f7ab46ab4ad4753895f5ca1cf14db'::TEXT, ARRAY[499]::BIGINT[]),
    (169::BIGINT, 'Super simpática. Tiene ideas muy interesantes sobre reciclaje. Incentiva (y califica) la asistencia a actividades culturales como conciertos y obras.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, 'a569b6d4a62f861e18776f05beb7208feaa8feb299f44577c6e98cb49646501f'::TEXT, ARRAY[499]::BIGINT[])
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
