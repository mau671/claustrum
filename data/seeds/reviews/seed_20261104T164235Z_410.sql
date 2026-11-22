-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=410
-- TEC-DATA-META years=2021,2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.936522+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (410::BIGINT, 'Da buenas explicaciones y está totalmente dispuesto a responder consultas. No sabe redactar. Revisa de manera justa.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-06-28T00:00:00+00:00'::TIMESTAMPTZ, '3c89cd9f0e29c44f307a50438dba2117c107edaff778fadb0b4b398c232823e8'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'Es un muy buen profesor y ayuda bastante. Hace las clases cortas para dar tiempo y trabjar en los proyectos. Nada más busque un buen grupo de trabajo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'd2030932fb58e04c75a8e3bb68c61f7c7e9410d07f2e83afa84bda922f7a6436'::TEXT, ARRAY[1346]::BIGINT[]),
    (410::BIGINT, 'Es bastante claro y se le entiende , las asignaciones que deja son bastante realizables y esta dispuesto a escuchar al estudiante con cualquier duda o problema que tenga, es la parte buena del curso compartido junto con Mauricio por que luego con Adolfo es otra vara'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-09T00:00:00+00:00'::TIMESTAMPTZ, 'e9f95141d4d3718ef9b32cfcfc3affaefe4c1a795e0ff5f8513a5f6adda3342f'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'Undisputed GOAT para probabilidad y estadística. Regala 5% por ir a tutoria. Los exámenes son muy pasables si se estudian exámenes viejos. Es importante prestar atención en las primeras semanas, es fácil perderse. Profesor siempre dispuesto a ayudar, a pesar de estár en Alemania.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '49ead9f4ec1d9a9006cc3d8a762fbc0bda472b1743fd4760ac5219e40ef71b09'::TEXT, ARRAY[1272]::BIGINT[]),
    (410::BIGINT, 'Buen profe, pone varias tareas algo extensas pero son relativamente sencillas y casi que regala ese porcentaje. La materia en sí no es tan complicada pero despues del primer examen hay que tener cuidado. Si lo lleva virtual con ver las grabaciones pasa y aprende. No califica muy duro los examenes.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'db61f79b8bea84e8c7fd45b9cfa8c0557c121d7406b52269aa90b51a273bfff6'::TEXT, ARRAY[1272]::BIGINT[]),
    (410::BIGINT, 'Excelente profe, explica super bien, la materia después del primer examen se hace pesada pero igual la explica muy bien y da puntos extras usualmente al final del semestre'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-29T00:00:00+00:00'::TIMESTAMPTZ, '2e9fd62fd84c99c304692187f03deb6fc0526bae052d11bdd3981d9829630504'::TEXT, ARRAY[1272]::BIGINT[]),
    (410::BIGINT, 'Es entretenido y siento que si se aprende bastante del area fotovoltaica. Hay dos proyectos y varios quices, todo grupal. Se pasa facil si uno se mantiene al dia. La unica queja es que a veces da un solo ejemplo por tema y uno queda medio enredado para casos distintos'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-21T00:00:00+00:00'::TIMESTAMPTZ, '99fb49f3facd9b71abc7e2325f5b165ab41fb061d4b898d26677be30c7629374'::TEXT, ARRAY[1346]::BIGINT[]),
    (410::BIGINT, 'El profe es súper buena gente, el curso con él es relajado pero sí son muchos temas, da muchos puntos extras, no hace quicces solo tareas que sí son un toque largas pero con que las entregue todo bien. Califica suave la verdad y siempre ayuda.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2023-11-18T00:00:00+00:00'::TIMESTAMPTZ, '6accd1327c988552c5b14248bbadf1f4de299430ab3231771200864a6d10cd06'::TEXT, ARRAY[1272]::BIGINT[]),
    (410::BIGINT, 'Explica y da buena retroalimentación, las clases son muy llevaderas, a veces se emociona con la matemática y va muy muy deprisa, pero aparte de eso los exámenes y tareas son sencillos, cómo es en virtual uno tiene que organizarse para que no se le acumule todo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '97ba6eb5234821334f21960a116741144fa46391a8bab871452dbed39cfd4508'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'Excelente profe y muy buena gente, explica bien y no hace el curso más pesado de lo necesario. 100% recomendado'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '2f615fdaa9572125951fe37bc148dc8f10ce43e3c098d41e8e5f81b6e6b84112'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'Ayuda bastante a entender la materia, la clase va en conjunto con el laboratorio por lo que los ejercicios se parecen mucho a los del lab. Es muy buena gente y los examenes tienen su truco y no dejar que la materia se acumule. Es muy muy muy buen profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'b2f319b3082c873badfaefafc79d66e65819864ae8acf74f72d7fe87ec7ffb3e'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'En general es un buen profesor. Explica bien, hace clases entretenidas, y ayuda cuando se tiene dudas. A veces se enreda con desarrollos matemáticos, y las veces que escribe en pizarra va muy rápido, pero en general es bueno.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Clases largas', 'Pocos exámenes']::TEXT[], '2023-06-09T00:00:00+00:00'::TIMESTAMPTZ, '6be11a869ad1c242eece71d606e6b69baff6d6fba0520e6954bb865e39c530bf'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'El profe es excelente y se aprende bastante sobre el uso de matlab que es fundamental para el lab. Aveces se confunde, pero en los exámenes es accesible.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-30T00:00:00+00:00'::TIMESTAMPTZ, 'd5a7c4a655b64227e26ac0fd79cd2d10cae9ee2a1e1d27930d55005389c1768f'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'El profe es muy pura vida, pero se confunde enreda demasiado en ciertas cosas y se salta muchas veces parte del procedimiento (lo cual no dice) , por lo que la mayoria de veces no se le entiende nada, hace dos examenes los cuales sí son un poco difíciles, se hacen en pareja y en varios días'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-01-28T00:00:00+00:00'::TIMESTAMPTZ, '781cfe0da38bd915a2e8139cbb7028b60b51bb977ef5ebc54d839954d011c849'::TEXT, ARRAY[1316]::BIGINT[]),
    (410::BIGINT, 'En semipresencial, las prácticas de laboratorio son muy divertidas, y los informes son relativamente sencillos con LaTeX, se ahorra mucho trabajo. La dinámica es cada semana entregar tarea e informe, intercalados. No hace falta ir a las clases para poder entender, solo se ocupa saber usar Python'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, '658073bc60972c253f665a407772ba28f9dc03457b8dfeb400bb2c9a77354f94'::TEXT, ARRAY[4121]::BIGINT[]),
    (410::BIGINT, 'Muy pura vida, sabe un montón y se nota cuando explica. Flexible y siempre dispuesto a aclarar dudas. Califica duro los informes pero deja mucha retroalimentación. Hace el curso muy llevadero, su explicación siempre aporta algo más allá de los contenidos, sin llegar a desviarse.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, '079f47cd1055093ae5691c67a8fe152c3d73d564d29ca162dc9062584b8e1112'::TEXT, ARRAY[4121]::BIGINT[]),
    (410::BIGINT, 'Es bastante bueno y es muy compresivo. Califica suave y saca el tiempo para anotar buena info de retroalimentación en las tareas y proyectos.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2021-09-01T00:00:00+00:00'::TIMESTAMPTZ, 'f8623ea581be670071623d833186efd9d2acc528c829396b8c8ae5d8f851b5a1'::TEXT, ARRAY[1321]::BIGINT[])
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
