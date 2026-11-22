-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=335
-- TEC-DATA-META years=2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.139424+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (335::BIGINT, 'En general las clases se van a lecturas de presentaciones y ejercicios guiados. Como a partir de la segunda mitad del curso deja bastantes trabajos que se distribuyen en: Tareas, laboratorios y proyecto. Está dispuesto a aclarar dudas y le importa que ningún estudiante se pierda durante ej. guiados'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-08T00:00:00+00:00'::TIMESTAMPTZ, 'e4280bc40e5ceba1a394677da595b09a25d8541ab897a55d504464c83c03194e'::TEXT, ARRAY[1146]::BIGINT[]),
    (335::BIGINT, 'El examen es a libro abierto y es una comprobación de si puso atención, si asi fue será fácil. El proyecto grupal es una simulación de un proyecto de software que se trabaja durante todo el semestre, valora mucha que el grupo demuestre interés. Mucha experiencia laboral, brinda anécdotas valiosas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2024-08-12T00:00:00+00:00'::TIMESTAMPTZ, '6c5a51f2367407fd6fa46a4ca26b0b05e533c7bfc29d41767010238c9837be2b'::TEXT, ARRAY[1052]::BIGINT[]),
    (335::BIGINT, 'Es un curso fácil de pasar siempre y cuando se organice bien con su grupo. Las clases son más que todo lecturas de presentaciones, sin embargo, de vez en cuando incluía ciertas dinámicas que la hacían más llevadera. El proyecto se va entregando a lo largo del curso y el examen es a libro abierto.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-08-06T00:00:00+00:00'::TIMESTAMPTZ, '90309cc9e8c709778ec2213cb573f32e0349d17d0e1bee0e8615e9facdb553c9'::TEXT, ARRAY[1052]::BIGINT[]),
    (335::BIGINT, 'Este profesor me pareció bastante bueno para el curso. Lo pone a simular el desarrollo de un proyecto de software a lo largo del curso. Las evaluaciones son sencillas. Hace un examen final a cuaderno abierto. Atiende a tiempo las dudas. No baja muchos puntos por errores. No tengo quejas mayores'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-28T00:00:00+00:00'::TIMESTAMPTZ, 'd02643ea238372e76a3b5e74e2d2c9f472c36384491a05dd3201b67a20de9566'::TEXT, ARRAY[1052]::BIGINT[]),
    (335::BIGINT, 'Jamás me hubiera creído que este mae de clases en el TEC. Me tocó como "cliente" para el curso de Reque hace más de 1 año. Simplemente es una porquería de persona, cero empatía, tiene comportamientos infantiles, se cree mejor que todos. Seguro lo tiene Víquez ahí por argolla.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'a0af93b185a729ee1ffc5b59c9df314b4cb6a32f9a91a4e08d7acf2a6daf3336'::TEXT, ARRAY[1039]::BIGINT[]),
    (335::BIGINT, 'Es un absoluto chiste que le sigan dando cursos en el TEC en la carrera de computación. No sabe nada de Ingeniería en computación y posiblemente menos de pedagogía.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-07-22T00:00:00+00:00'::TIMESTAMPTZ, '5ebc5f8fbcafd45104ddcfa60a7328825863387e46dad136c7471ce584e89204'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Si estás viendo con que profe matricular una electiva, no escoja este profe, se me hace curioso que "se supone" que las electivas no se deben de repetir dos semestres seguidos y este profe lo logró hacer, siendo que no es una electiva disfrutable o entretenida, mejor pusieran otra electiva.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-30T00:00:00+00:00'::TIMESTAMPTZ, 'cf1a5c916796e44bd05ba353493fbb59b0b2aa5df0e99fd73811c1d2c70866dc'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Este curso está parado de uñas. Es obligatorio grabarse y subir las tareas a tiktok. El mae lo graba a uno sin consentimiento. Las clases son aburridas y las especificaciones no son claras. A parte, el mae es super inmaduro. Les aseguro que los comentarios positivos de este foro de fijo son de él..'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-21T00:00:00+00:00'::TIMESTAMPTZ, '5442f0605179a3937bcff73d2b614e32a1a19eae7ff58a38e49d5a9a215d74a5'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'El curso no me pareció tan malo; sin embargo, no me gusto ser grabado sin consentimiento, esas cosas se hablan desde el primer día y se toma en consideración la opinión de los estudiantes, era incómodo estar en clases y ver el trípode con el celular grabándote de frente todo el tiempo.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'fc80643875295d939aa724a690104f97b097f2bef28d3ec0fb8ae12911c0a5a5'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Es una falta de respeto que quiera ganar seguidores a costa de estudiantes, todas las tareas consisten en hacer TikToks y etiquetarlo. El objetivo final del curso es actualizar su sitio web, una breteada que no tiene nada que ver con el curso, sino con vender la imagen del profe.'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-11-17T00:00:00+00:00'::TIMESTAMPTZ, 'dcd82c1dfdf7bdbb7e2929948f1f3d7bc7da3023d28e3d58ca373e075f890853'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'La clase es aburrida, la gente deja de ir o se duerme. Serias fallas pedagogías, 0 manejo de grupo y aula , se nota que no le interesa el curso sino "vender" el siguiente curso. El curso es puro humo yespejos (literalmente). Es la personificación de la frase "el que sabe hace y el que no enseña"'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2022-11-16T00:00:00+00:00'::TIMESTAMPTZ, 'b295d52279d97d12ee61c3d3406051035f421812bbd1cde372e608506e2a2eac'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Cuidado con los demás comentarios puede que el mismo profesor haya puesto algunos de ellos. El curso rompe los estándares normales de un curso en el TEC. Sin embargo hay cosas que no están bien con él, puede llegar a ser irrespetuoso y tiende a caer en riñas con estudiantes(pelear como niños)'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Clases largas']::TEXT[], '2022-11-16T00:00:00+00:00'::TIMESTAMPTZ, '80d3d46a720fa00557ffbfc8a3c20a6adc80a61767bd915db49a7fca399692d5'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Mi opinión sincera de este curso (parte 1). No matriculen este curso. Si está leyendo esto antes de la matrícula del IS2023, meta GIS sin dudar (la otra electiva), yo ya llevé ambas electivas, con ambos profes. Ambas son demasiado fáciles, pero GIS es 1000 veces mejor curso.'::TEXT, 10.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-11-16T00:00:00+00:00'::TIMESTAMPTZ, '72feaf1de86432912254333cb25d21c49e63db5a90453c2b07763ca5a4550bb7'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Hágase un favor y no matricule con él si no quiere perder su tiempo. Es un curso enfocado al área empresarial, el profesor al final hace un evento que usted van a tener planear paso por paso. Crear toda la publicidad y básicamente hacer todo el trabajo por él. Incluso en su propio sitio web.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2022-11-11T00:00:00+00:00'::TIMESTAMPTZ, '82a65b9c1b6c1ef7241b56b6c5d9fda9999b191325504a649d5c8891a3c33907'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Es un curso que tiene que ver 100% con gestión empresarial, usted va a tener que crear una empresa con un proyecto “innovador” que va a llevar todo el curso. Las instrucciones de las tareas y proyectos no se entienden. Es como Naruto de todo lo que habla se le entiende un 10% el resto es relleno.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2022-11-11T00:00:00+00:00'::TIMESTAMPTZ, '41623b2393d276fd9541b788adfc7346176bbb6a8ca3297aec5b0c4855f46bbd'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Un curso extremadamente aburrido, donde el profesor habla durante 2 horas lo que se pudo haber resumido en 10 min.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-11-11T00:00:00+00:00'::TIMESTAMPTZ, 'd01e20bf50e359471d74daede81b6b6e961e3d9b07599ad7631284828875e551'::TEXT, ARRAY[1116]::BIGINT[]),
    (335::BIGINT, 'Pésimo profesor, es un curso electivo el men piensa que uno va a ser un gestor de innovación profesional, las clases son aburridas, el profe esta medio loco, el curso esta mal gestionado y no califica hasta el final'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2022-11-11T00:00:00+00:00'::TIMESTAMPTZ, '8fa7f7c8036f7a77dc6b27025f3f9766023874eb4e059ae9eb1ba63deeac9a92'::TEXT, ARRAY[1116]::BIGINT[])
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
