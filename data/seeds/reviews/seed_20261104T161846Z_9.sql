-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=9
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.736246+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (9::BIGINT, 'Muy respetado, si quiere aprender de verdad matricule con él, eso si no apto para gente que vive de la IA'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes']::TEXT[], '2026-08-22T00:00:00+00:00'::TIMESTAMPTZ, '57d6e4fa80f9127eeb395dda4f4e2c5c0a0b1403f8e9c9b320ba8a30dce55290'::TEXT, ARRAY[99]::BIGINT[]),
    (9::BIGINT, 'Es un profesor muy bueno, explica bastante bien y si tienes dudas las responde con gusto. Los exámenes son largos aunque realmente son fáciles si puso atención y sabe razonar y resolver problemas. Hay que exponer bastante, a pesar de que no me gusta exponer, fue cómodo porque hay un lindo ambiente.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Aspectos de calificación claros']::TEXT[], '2026-07-10T00:00:00+00:00'::TIMESTAMPTZ, '50978964924137dbcb65852768bf0cb6abeb2036d52f88d3479031dd4a4904c8'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Muy buen profe, califica duro los examenes ponganle cuidado, es el estandar si usted quiere un buen profe y no va a perder el tiempo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Muchos proyectos grupales']::TEXT[], '2026-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'a84633dbbd2c7be26456a7d942241d3010d2489328d5c2bde34ea80b6465f744'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Profesor respetado por lo estudiantes por el excelente profesional que es, sus exámenes son largos pero realistas en ámbitos profesionales, pero no complicados, busca la participación activa durante la clase. La clase es si es excelente y al profesor lo recomiendo 100/10.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-11T00:00:00+00:00'::TIMESTAMPTZ, '38a42b7c0fc4a585398e8734c27f0fffe9c5e08d14bef19ab34f44cf8d73fd7d'::TEXT, ARRAY[99]::BIGINT[]),
    (9::BIGINT, 'Un buen profe, pero sus clases se sienten muy desorganizadas y casi todo el tiempo hay que exponer. Yo diría que esté profe es para los que de verdad les apasiona la administración.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2026-04-30T00:00:00+00:00'::TIMESTAMPTZ, '19335f374e988389179833c7b3304eee34c6e8ec236b8b502bf208f576d8c1fe'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Clases largas']::TEXT[], '2026-02-18T00:00:00+00:00'::TIMESTAMPTZ, 'cbc0bca9a4cab200ad9b20e57fc04b89749dd20be5b43e2c400c9ea38a2eb927'::TEXT, ARRAY[99]::BIGINT[]),
    (9::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '4a25793a1991f258ab77de44e6cc5252c8acc9e417f71916595c6c949bd8e802'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Muy buen profesor, explica muy bien y si le pones atención se pasa facil la materia'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-02T00:00:00+00:00'::TIMESTAMPTZ, '0e46a2c3e31e6b11b16fdebc0771ba00c8a49cce92d3efdb3bed05ed4f520beb'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Excelente profesor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2025-06-17T00:00:00+00:00'::TIMESTAMPTZ, '8cc29433e27834459d1f07313374d0b2bf52a8b76b713212fbf9ef5d80aa48f7'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'El profe es bueno explicando la materia, el proyecto es largo, necesitarán una empresa que se disponga a dar información de los puestos de sus empleados (nada comprometedor). Tener buen equipo es clave. Deja tareas grupales del mismo equipo y algunas individuales. Acérquesele sin miedo a preguntarle'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2024-11-29T00:00:00+00:00'::TIMESTAMPTZ, '471b90803c811eec329f7b5d6196b641d22e1e5e5e3129a3ab60ef76500875fe'::TEXT, ARRAY[2450]::BIGINT[]),
    (9::BIGINT, 'Deja muuuchas tareas que valen muy poco porcentaje, si estudia bien los exámenes son fáciles (póngale ingenio), casi todas sus tareas fueron grupales y siempre mismo grupo (elijan uno bueno). El proyecto muy largo y la guía no se explicaba muy bien lo que se debía hacer. Es buen profe, explica bien.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2024-11-28T00:00:00+00:00'::TIMESTAMPTZ, '391cef1d70964269229f3480fc85a35c0e01bb0fe47c7b8a7b8fe87e70781789'::TEXT, ARRAY[2412]::BIGINT[]),
    (9::BIGINT, 'Muy buena gente, acércatele sin miedo por ayuda. DEMASIADOS trabajos tanto individuales como grupales. El grupo con el que esté será por todo el curso. Busquen una buena empresa para el proyecto final que quieran un diagnóstico de comportamiento organizacional. Entienda bien la materia y pasa fácil.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '714f684656a12dc355e880de137fdc02c6b7f2f7602fcbf759853a7118151db8'::TEXT, ARRAY[99]::BIGINT[]),
    (9::BIGINT, 'Excelente docente, las clases son como las que uno imagina en el cole que va a recibir en la u. Lo recomiendo sin duda. Como advertencia, tratar de llevarse bien con el equipo de trabajo que tengan, el trabajo en equipo es vital para el éxito en la materia.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-05-30T00:00:00+00:00'::TIMESTAMPTZ, 'd866353041a4563a65c6cb712f53e0a8aa70fe88a37a527efb62dc3d27bd5ec0'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'El proyecto es largo, casi como una tesis pero uno aprende mucho de eso. Es flexible con las fechas de entrega de las asignaciones. Toma con seriedad la clase y respeto al estudiante. Las clases tienen una primera parte magistral y se hacen un poco tediosas pero la segunda se pasa bien'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Deja trabajos largos']::TEXT[], '2024-04-05T00:00:00+00:00'::TIMESTAMPTZ, '3290799bc83ce1afd596e7db1071a432b5350ee878f1346c36bc2258872f12c7'::TEXT, ARRAY[2450]::BIGINT[]),
    (9::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Clases excelentes']::TEXT[], '2023-12-26T00:00:00+00:00'::TIMESTAMPTZ, '6bd64ece14664189e226631c6b8ac5e3ffc853fb5bb7fbbaba032463ea7b1868'::TEXT, ARRAY[2438]::BIGINT[]),
    (9::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '8809fc3d09e0d1d12f6af3d23565103d2f1909e816177283ddf06154e6e32c9f'::TEXT, ARRAY[2438]::BIGINT[])
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
