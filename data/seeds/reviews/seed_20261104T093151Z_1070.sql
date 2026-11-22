-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1070
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.760449+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1070::BIGINT, 'Profe 10 de 10. Nos tocó virtual pero explica super bien y no se hace tan aburrido. Hay trabajos grupales e individuales pero no son tan largos y es facil sacarse el 100. Definitivamente la recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-22T00:00:00+00:00'::TIMESTAMPTZ, '318e08c8440d5b039492e66c7fdd10736b8133d59449b26c66cd4506f3a54f5f'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'El curso se pasa fácil y además es una profesora que se interesa por los estudiantes. Las instrucciones de los trabajos son claras y se hacen rápido. Siempre está dispuesta a ayudar y es muy comprensiva. Volvería a matricular con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-07-02T00:00:00+00:00'::TIMESTAMPTZ, '7959ae1d817cd07aea6de361428fb56dc6e953681d5318bb7b17bcbf20809df9'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Ella es super amable y comprensiva. Sus clases so de asistencia obligatoria pero usualmente las finaliza antes. Usted pasa el curso con entregar los trabajos y ya, que no son muy complicados. De mi parte super recomendada.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-30T00:00:00+00:00'::TIMESTAMPTZ, '1190f8ab0c54d52318be950741c349ef08d4cffad252cfe114fe2534965acbc5'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2026-04-20T00:00:00+00:00'::TIMESTAMPTZ, '44a87e44fe03d88ba2127394a3fb6c1b6287f678f22af12111d86ac271ba04cd'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-02-25T00:00:00+00:00'::TIMESTAMPTZ, '209db4a3543b65d6173a5f59c79ec8bb90ff2d6d87019864fd9376e4b2bd0034'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Yo la adoro, es mi profe favorita. La lleva muy al suave, con que uno entregue las cosas todo bien. Es un amor de persona y sabe que su materia no es la única. Termina las clases antes usualmente. La amo, matriculen con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2025-07-30T00:00:00+00:00'::TIMESTAMPTZ, '2c6455fc533e27c619aac830b9b1a7449ff9d661aa3c9dfd46ec849b710adacc'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Mi crush. Super amable, divertida, ayuda montones, explica super claro, califica justo, los trabajos estan muy bien. Meta con ella. Se pasa facil el curso y si se aprende'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-16T00:00:00+00:00'::TIMESTAMPTZ, 'f799ec555a1071dd9bfa547bc52b657e5b69a57f0e0084164c1bbbc0033df1c6'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Buena profesora'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-14T00:00:00+00:00'::TIMESTAMPTZ, '801e46e6515b160b26888c3d2e7e2ce298ace94efd93840faace6e894642c2c4'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Es super buena y un amor de persona, sus clases en mayoria son magistrales bastante contenido, y le gusta que participemos o hagamos consultas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Inspirador']::TEXT[], '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ, '11a081a8e05e3b85a2bfd9e2eed09c25a035b0be4f741a1cc38b6551f1b14a20'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Es una excelente profe, siempre termina la clase antes entonces a usted le queda tiempo por si tiene dudas con alguno de los trabajos. Las evaluaciones son sencillas y es un amor de persona'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2025-06-18T00:00:00+00:00'::TIMESTAMPTZ, '9aa2632e92903bf01c46749ccf237b161fc9383fd75ef43dd6dcad74eb3ec928'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Es una excelente profesora y tiene una vibra muy linda. Sus clases son fáciles de comprender, y los trabajos que deja son entretenidos y de acuerdo a la materia que se ve semana a semana. No dude en matricularse con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2025-06-18T00:00:00+00:00'::TIMESTAMPTZ, '8802c7ed8dad8c61b02f5054a9c4829a2e3c6dfcedbb744265aada8ddf2fc42b'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Muy buena profesora. Tiene una vibra muy bonita la cual inspira y da ganas de estar escuchando atentamente a la clase. El centro fue muuuy sencillo y rápido. No dude en matricular con ella'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2025-02-19T00:00:00+00:00'::TIMESTAMPTZ, 'b2cb75f7cb29130acba082f563b6ea8bd5c7d85f99569a5b66946dca0e0596d4'::TEXT, ARRAY[778]::BIGINT[]),
    (1070::BIGINT, 'Su clase es bastante entretenida y fácil de comprender, no deja muchos trabajos, y los que deja son fáciles y de acuerdo a la materia que se ve semana a semana. Es muy buena a la hora de calificar. En general llevar el curso con ella, si se es responsable, es pasar automáticamente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2024-12-03T00:00:00+00:00'::TIMESTAMPTZ, '2f866283b445dd89a70204ae3e361daa4e779738ee28bb872714b06ddeea04f9'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Respetuosa y amable con los estudiantes, los trabajos no son pesados, no califica duro. El curso se pasa prácticamente sólo. La recomiendo ampliamente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Aspectos de calificación claros']::TEXT[], '2024-08-11T00:00:00+00:00'::TIMESTAMPTZ, '401aa555ed47c916c8c0b4b12555024babfbe7735c4055ee7a4a87de5b199485'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Excelente profe, explica de manera clara y sus evaluaciones no son difíciles, como es nueva se pone nerviosa y/o se enreda unas pocas veces, pero muy buena nota y califica suave, si haces las cosas bien pasas muy fácil, sus clases pueden ser aburridas, pero eso ya depende de cada persona'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '2e56ce6d3db25595a95a9e2383fb8bfaae3f175d5c0d37b0588c7dac0d6ce86b'::TEXT, ARRAY[554]::BIGINT[]),
    (1070::BIGINT, 'Excelente profesora, a pesar de ser nueva logra que las clases sean divertidas y las tareas estén perfectamente adaptadas a la carga de trabajo correspondiente a los créditos asignados. La personalidad es muy linda, súper recomendada!!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-22T00:00:00+00:00'::TIMESTAMPTZ, '47366f46b1f10f415f5c05dc9a72908d65048051e220b5f794f76df0ee540ed7'::TEXT, ARRAY[600]::BIGINT[]),
    (1070::BIGINT, 'Es una profesora super joven que recién entra, es demasiado buena; también clara y compresiba con las tareas que deja. Además, tiene una personalidad muy linda y no califica duro. Les recomiendo totalmente matricular con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Brinda apoyo']::TEXT[], '2023-06-14T00:00:00+00:00'::TIMESTAMPTZ, '46a18281374b81c3d985393e01b08c8549b7af9379209894755b25beadec507b'::TEXT, ARRAY[600]::BIGINT[]),
    (1070::BIGINT, 'Ella es muy buena profesora, califica suave, pero la participación importa, se pasa muy fácil, no es estricta, 100% recomendada.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-06-04T00:00:00+00:00'::TIMESTAMPTZ, 'c2f40719907810f6f800999c0eb705fb2a68d73d6003c5911c1c239b6b77a7b3'::TEXT, ARRAY[600]::BIGINT[]),
    (1070::BIGINT, 'Es una profesora muy joven apenas entró este año, no califica para nada duro y realmente uno si la puede pasar bien, es muy fácil pasar con ella. Tal vez fue un poco desordenada pero entró un mes después entonces no tuvo mucho tiempo para prepararse, pero lo manejo muy bien.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2023-05-23T00:00:00+00:00'::TIMESTAMPTZ, '1cf3f47b7b8c7d25c2b53239497856d2006099660e4c5fd60dffc9891eecc054'::TEXT, ARRAY[600]::BIGINT[])
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
