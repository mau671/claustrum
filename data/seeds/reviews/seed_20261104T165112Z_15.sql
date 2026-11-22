-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=15
-- TEC-DATA-META years=2016,2020,2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.023614+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (15::BIGINT, 'El profesor sabe mucho de su campo y te da el material de principio a fin de todo el curso (fue lo que sucedió en mi grupo) El profesor Solis deja proyectos largos y tendrás que tener un buen grupo de trabajo, el profesor brinda ayuda pero tienes que saberte explicar. Los exámenes importan y mucho.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-17T00:00:00+00:00'::TIMESTAMPTZ, 'c59d57399d415d829fc626f43ad289949f3acf5c7ccc10563cfca45276881c70'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Es un excelente profesor y los exámenes son iguales que las prácticas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2025-09-13T00:00:00+00:00'::TIMESTAMPTZ, '3fc118f9a6e466caa2de9cc18af822eb2f2c3dcb0bb9784322f87aae3b95e19d'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Es mu buen profesor, super inteligente y se nota que le gusta lo hace. Resuelve dudas de forma rápida, a pesar de ser una materia un toque complicada usando R, él hace que sea fácil si usted pone atención'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'aea888f87be169093cd7ccdb919256438d61f47787a9d8aeba4e2e0e4d4f998e'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'ES UN PESIMO PROFESOR PRESENCIAL. NO LO RECOMIENDO POR NADA DEL MUNDO'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2023-12-13T00:00:00+00:00'::TIMESTAMPTZ, '21cf2cccdfc0da7b3282b40b55bf01e42549e2fbc1c8bc46c1f794bf333f3a79'::TEXT, ARRAY[1892]::BIGINT[]),
    (15::BIGINT, 'Es un buen profesor. En virtual, los temas los explica por medio de vídeos y luego hace una sesión para aclarar dudas. Siempre responde preguntas sobre la materia. Los exámenes son sencillos si estudia, pero califica duro y en ocasiones, subjetivamente.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Brinda apoyo']::TEXT[], '2022-11-29T00:00:00+00:00'::TIMESTAMPTZ, '46ee87ac30082e5de42c798440e1c7bf6d4a41796eff7f7ead620f245d441281'::TEXT, ARRAY[1892]::BIGINT[]),
    (15::BIGINT, 'Siempre son clases asincrónicas, si usted no puede concentrarse y establecer su horario para ver los videos, no matricule con él. La calificación es ruda porque el proyecto final vale 33% de la nota y es súper largo. Algunas veces califica subjetivamente pero brinda ayuda cuando la piden.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2022-11-20T00:00:00+00:00'::TIMESTAMPTZ, '824c5986e01c601c9eeb7794a0a0c37dc41f013a4852b0d1c68324e8c646b39b'::TEXT, ARRAY[1892]::BIGINT[]),
    (15::BIGINT, 'Este profe maneja el curso de forma asincrónica, y luego crea reuniones para aclarar dudad que surgieron en esa clase asincrónica. Siempre es muy amable al explicar y no deja el tema hasta que ya usted entienda. Es muy importante que pregunte.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-26T00:00:00+00:00'::TIMESTAMPTZ, '59bd47242788f7666f09a6fa393d3fd77d4d1aaca0dbdd11ef4a7c292f3451fd'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Es un buen profesor sin embrago si es de las personas que se distrae viendo vídeos matricule con otro profesor ya que para explicar lo hace por medio de vídeos y si algo no se entiende del todo bien lo ve en la clase siempre y cuando usted pregunte'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Exámenes retadores']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'f92b2670ad3fd5c2aa4b8f21d7b78844aa39bcf5fe69ab7d12e8753cae6fa6f1'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Virtual Buen profesor, explica la materia por vídeos asincronicas sin embargo vuelve a explicar en clases sincronicas si es necesario.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '96baba7fa58209d9527927dbaef18a95ab755a03f40be674d814b961f8157cd6'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo']::TEXT[], '2022-06-17T00:00:00+00:00'::TIMESTAMPTZ, '1a82dbded8edb41275aca7fdd81a3d467eb2efe13efac0d9d35c8f622fb717a8'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Las clases no se entienden, no ayuda ni explica nada. Califica subjetivamente.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil']::TEXT[], '2021-11-22T00:00:00+00:00'::TIMESTAMPTZ, '932bc546cc83acc598a6d6f669d6f81e8f271ca9641cffaff27e874616fae72f'::TEXT, ARRAY[1892]::BIGINT[]),
    (15::BIGINT, 'Excelente profe, en el caso de la virtualidad, la mayoría de sus explicaciones son con videos asincrónicos, los cuales dejan muy clara la materia, además siempre está dispuesto a abrir espacios de consulta para facilitar el aprendizaje del estudiante.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, '02308a1109a059c087465a913b248c60612ed2ca71a98856be5e0e1af4aa6ebd'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Al igual que en Estadística I, en este curso también se utiliza R. La materia la enseña en grabaciones, en las clases presenciales solo atiende dudas. Los exámenes y el proyecto son complicados pero se pasan estudiando de los videos que deja.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-01-21T00:00:00+00:00'::TIMESTAMPTZ, '15a89bcb78ab465ab9d828bd6c2c6e16f2c5af88c8e3cb6fa6dc375fe6f67fc4'::TEXT, ARRAY[1892]::BIGINT[]),
    (15::BIGINT, 'El profe da la clase con un programa que se llama R, sube vídeos explicando las funciones y deja tarea relacionada. Si hace la tarea al día se pasa fácil, lo recomiendo para llevar clases virtuales. Aclara las dudas que le hagan las veces que sean necesarias. Lo recomiendo'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '033335fa2e49a041e07bd253f884595dc9ec5aebccaad81353a09b2cedb53b41'::TEXT, ARRAY[2374]::BIGINT[]),
    (15::BIGINT, 'Muy buen profe, si se pone atención en clase se entiende la materia y los exámenes están relacionados. Si usted le hace consultas el las responde.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, '94436bd42cbde22ef23053a9feae994252eb130144b64fb701c81394cf35b6d5'::TEXT, ARRAY[2374, 1892]::BIGINT[]),
    (15::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2016-07-19T00:00:00+00:00'::TIMESTAMPTZ, '55c709afbc9d8d8757f35e50d481661697e70ef501c59a2098eb7b0220d8ff5b'::TEXT, ARRAY[1892, 2374]::BIGINT[])
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
