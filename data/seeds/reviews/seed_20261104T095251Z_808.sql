-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=808
-- TEC-DATA-META years=2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:52:51.475640+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (808::BIGINT, 'En esta segunda ocasión, me tocó llevar física III con este profe. Tengo que admitir que esta vez me fue mejor con esta criatura, ya que en el primer examen me pegué un 89. Aún así, no se emocionen, si pasé con este profe fue por haber estudiado duro, sigue siendo un pésimo profesor en todo sentido.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2025-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'c662bef36beb683a79aea547866692a06dc816d4b76ef0d7e25d541d67ffb8ed'::TEXT, ARRAY[922]::BIGINT[]),
    (808::BIGINT, 'Mrd de persona, pedante, viejo verde, pierde los trabajos que uno le da, califica re mal, jalisco nunca pierde. NO matriculen con el jamás, les deja secuela el estrés de meter con esta kk con patas'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '8e8cf6fa0a21d1fde265fe4bb8d79a0cfa3b219f89559dc5e99343328cefa5f6'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'De los peores profe del TEC en general, solo él tiene la razón y es un arrogante. Cuando le piden ayuda los estudiantes, lo hace de mala gana como si lo estuvieran obligando. Esta tortuga prehistórica no sabe dar clases punto. No matriculen con él, háganos un favor profe y jubílese ya'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2025-03-21T00:00:00+00:00'::TIMESTAMPTZ, 'c64d0e4bd284d1294ca203391fc20d9f4b9ecdd532fd47b0826594b01856fbe0'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Tanto física como laboratorio los lleve el mismo semestre con este señor, la peor elección de mi vida. Perdió todas mis tareas de laboratorio como 3 veces y nunca me reviso una sola tarea hasta final de semestre por lo que nunca recibí retroalimentacion, ninguna de mis tareas paso de 40.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('35','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2024-01-18T00:00:00+00:00'::TIMESTAMPTZ, '7aa97eb311dc43703bb421298903e9fc6880634f097019e8517a85f4fff13252'::TEXT, ARRAY[607, 631]::BIGINT[]),
    (808::BIGINT, 'El peor profesional con el que me he topado en la carrera.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2023-10-14T00:00:00+00:00'::TIMESTAMPTZ, '868c8e7110541a196f2c0b379e53e4e9b29b85db101fabfdf5d69900162fdb7c'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Si usted se quiere no lo haga'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'd6323be610d71b405d233231d9c0c9a9d49db7527e6cb30b8101f8658eb127df'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'No he conocido a un profesor tan pedante, egocentrico y sobervio en mi vida, es pésimo para dar clases no se entiende nada de lo que dice, y claro él nunca puede perder, siempre debe tener la razón quita puntos hasta por volverlo a ver, además de ser un rabo verde, Nunca matriculen con él'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2023-05-25T00:00:00+00:00'::TIMESTAMPTZ, '22621c3a2477ed8ee6ced3c7198d47c25f9cd59acea9448a463336bb39f2ae22'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2023-04-23T00:00:00+00:00'::TIMESTAMPTZ, 'd49b9bea8d08d4c31490ec93d2043771c9201d1eafc12d3a197095d287275d2c'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, '"Les guste o no, la Tierra es plana" (Alv, 2019)'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Pocos exámenes', 'Exámenes retadores']::TEXT[], '2023-03-28T00:00:00+00:00'::TIMESTAMPTZ, '0b3252cfa258e3a99053eb77cd7392c53372c99df9727fd4e2d44092e0c902b5'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Evalua como si estubiese evaluando a personas con su mismo nivel de conocimiento. Todo esta malo, y solo él tiene la razón. Digale que la tierra es redonda y sería capaz de demostrarle que es cuadrada... En vez de enseñar es un obstáculo que desmotiva, solo ver la cara de los estudiantes dice mucho.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2023-03-16T00:00:00+00:00'::TIMESTAMPTZ, '42b124f6e1d911030c35964248de8911c27048999a0d384e2596709d0fb23267'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'No lo haga compa'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2022-09-28T00:00:00+00:00'::TIMESTAMPTZ, '444e67a01e7df7119b971084e4009c47916ed5fb8f924684f72a39011d3b3fa0'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'bae9128ed27c3a938afd8e508d47d5770034a2d36dcc622a26accaa3477bb817'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'Ausencia TOTAL de carisma, desmotiva al estudiante cuando tiene la las clases son aburridas y largas a más no poder y tras de eso se enoja cuando nadie le contesta. 2 años enteros de virtualidad y aún no sabe como hacer un grupo de Teams. Hagame caso, por nada del mundo matricule con este señor.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-02T00:00:00+00:00'::TIMESTAMPTZ, 'a8879d97d699d68d06da0310e0a6b8abc4d2bae24408b0516f88063a58c4d218'::TEXT, ARRAY[607]::BIGINT[]),
    (808::BIGINT, 'Es un profesor de mente cerrada, el tiene la razón y nadie más. Pasa quejándose de que nadie se conecta y el pobre que se conecta es acosado hasta el cansancio para que hable. La virtualidad se lo come. Pésimo profesor.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-10-20T00:00:00+00:00'::TIMESTAMPTZ, '700f561f9a0a2400bebaaa9fe87e57c4c89c7456accdf96d4a8f1404e69b24c0'::TEXT, ARRAY[604]::BIGINT[]),
    (808::BIGINT, 'No se adaptó a la virtualidad, la tecnología se lo come, es de mente cerrada, el siempre tiene la razón, no deja que uno elija los grupos, no hace grupo de WA ni de telegram, no sabe hacer un equipo de teams, en fin, es un curso pesado y meter el curso con el es garantía de perderlo, no se embarque.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-08-24T00:00:00+00:00'::TIMESTAMPTZ, '662f12824cf329b8c8fcdcb4f7abc35f1be9ec9fad3e5e29c9e66ffa5ef2e6c0'::TEXT, ARRAY[607]::BIGINT[]),
    (808::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, 'af4676545c8da7bcb0a735ef17293d3e6b7ace39bf9282db0d83adc10de4fd72'::TEXT, ARRAY[607]::BIGINT[]),
    (808::BIGINT, 'Es muy grosero al hablar y calificar, no se los recomiendo, todo lo pone malo'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas']::TEXT[], '2021-06-17T00:00:00+00:00'::TIMESTAMPTZ, '264413d88e5fdf57598716bc570a01612fcdc5ea98c3999d604ba58e9610f934'::TEXT, ARRAY[922, 630, 604]::BIGINT[]),
    (808::BIGINT, 'Clases largas, deja trabajos largos, no deja que uno eliga los grupos. De acuerdo con el comentario de los cocodrilos'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2021-05-28T00:00:00+00:00'::TIMESTAMPTZ, 'e1fc6300ef35795c7570b4bf3fb6c78f30ae2dbc535e77920065e3227bb24385'::TEXT, ARRAY[607]::BIGINT[]),
    (808::BIGINT, 'El señor pata pocha es muy inspiracional, más cuando dice que los cocodrilos del eco tec tienen más posibilidades de salir bailando a que pasemos el curso, es un físico terraplanista, súper amable y compasivo, carismático a más no poder, hasta queda enamorado de su personalidad, parece brad pitt.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-04-10T00:00:00+00:00'::TIMESTAMPTZ, 'c8928bf2d4d127f3d21cb2ffe99bdce7d7b4f6f7ff9899fd0eeae3335c964c40'::TEXT, ARRAY[604, 630, 607, 631, 922]::BIGINT[]),
    (808::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Deja trabajos largos']::TEXT[], '2021-02-16T00:00:00+00:00'::TIMESTAMPTZ, 'fd47b6c065ebc8e7fefc07b797b358937b9c66a4fdbf8b8bb61dc18b04c14a11'::TEXT, ARRAY[604]::BIGINT[])
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
