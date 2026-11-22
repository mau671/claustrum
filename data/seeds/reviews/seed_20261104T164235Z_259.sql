-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=259
-- TEC-DATA-META years=2017,2019,2020,2021,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.862218+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (259::BIGINT, 'No volvería a tomar clases con ella, me parece muy poco inspiracional, se estresa con facilidad. Simplemente no me parece una buena profesora, no la recomiendo en lo absoluto.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2026-08-07T00:00:00+00:00'::TIMESTAMPTZ, '2600c659803e7cf0ce9b9428fb5dbf91054d2fe50fe73a2ac978cb5054995392'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'Califica duro, no tiene vocación para explicar, las clases son aburridas y solo se dedica a leer las presentaciones cuando debe explicar'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, 'b45d975d71068d34813ee9d16bf751171d870ba636e2481ba06b5e10f5027f1f'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'Esta profesora me enseñó a querer las físicas. Entregue un procedimiento ordenado y decente y es poco lo que le baja. Participe en clase, eso lo valora mucho y es un amor de persona. Siempre está dispuesta a explicar las veces que sea necesario para que uno entienda. LLévela con ella, créame.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2026-02-07T00:00:00+00:00'::TIMESTAMPTZ, '01086f1a894d413d0bb28d2f7f33f23048761722458f93b8d9a3ef08af170809'::TEXT, ARRAY[630]::BIGINT[]),
    (259::BIGINT, 'Llevé Física I con esta profe y fue de lo mejor que me pudo haber pasado. Califica justo, sin embargo al ver esfuerzo le reconoce un poco más. Lo más destacable es que suele hacer actividades extra para algunos puntillos en la nota, aproveche y participe todo lo que pueda. Pongale y pasa, nada más.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Da crédito extra', 'Brinda apoyo']::TEXT[], '2025-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'fefb94bd8aa3edee99ef1fce745f05b1095d4949d7e9ed3e2fe644fcba5474fd'::TEXT, ARRAY[604]::BIGINT[]),
    (259::BIGINT, 'Califica duro pero si se entrega un buen trabajo es muy poco lo que le baja, en las clases explica muy bien y se interesa porque los estudiantes entiendan, suele hacer preguntas por lo que la participación importa, en resumen es una buena profe solo de ponerle y se pasa facil.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2021-12-22T00:00:00+00:00'::TIMESTAMPTZ, '7588a839292f53f8c1b4fcff7b637d8827057e9f75598326012180ed1c0cb0dc'::TEXT, ARRAY[631]::BIGINT[]),
    (259::BIGINT, 'Explica muy bien y hace que la clase no se torne pesada. Resuelve ejercicios durante la clase, lo cual por supuesto es de ayuda. Siempre está dispuesta a ayudar.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, '49e1e5b99b42025d2b7c3d83affbb6d8dfdb7ed7ef5622356e119917955145bd'::TEXT, ARRAY[922]::BIGINT[]),
    (259::BIGINT, 'Lee las presentaciones y deja tareas de youtube'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Asistencia obligatoria']::TEXT[], '2021-09-04T00:00:00+00:00'::TIMESTAMPTZ, '1c69682b46fa378a398f6d239507d33164007a9eb4260646b6049aab9dfecc4e'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'En forma virtual se pule mucho en las asignaciones , da descansos para que uno no se canse y siempre en las horas consultas es muy flexible (Algunas ocasiones hasta responde los fines de semana).'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-19T00:00:00+00:00'::TIMESTAMPTZ, '5ab93f41042b1e76c440dd0022ba373226d3db520f13a569b92281fed3f67c72'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'Es excelente profesora, eso sí, valora mucho el interés individual por el curso, pero es muy flexible para atender consultas fuera de clase (importante). En clase explica muy claro y muestra dominio del tema. Es comprensible y busca que todos pasen. Si quiere aprender ella es muy recomendada.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-21T00:00:00+00:00'::TIMESTAMPTZ, 'ca9a46f8a8e4744c1761aa6bc5096fc2a93cc8ce68ad2eefced44b17fb0a2cdc'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'Solo llegaba y leía las presentaciones, las clases eran muy malas y aburridas, tenía preferencias con los compañeros'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2020-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'dedb86c321d80c2fbf4a5983f4efa99ece767d823afb4b78da53b69fe89e0c55'::TEXT, ARRAY[610]::BIGINT[]),
    (259::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'a782ff8f29df7d1cb3390658485394e6b353b54fc17709565e16d2c80f5cdcb6'::TEXT, ARRAY[1726]::BIGINT[]),
    (259::BIGINT, 'Es una excelente profesora para ese curso aunque puede llegar a ser un poco aburrida la clase. Se entiende todo perfectamente'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2017-10-30T00:00:00+00:00'::TIMESTAMPTZ, '09fa42e61e63c6c8c047a12aef7b0f2cee2f8a792ada12c84082d33fcf92ffcd'::TEXT, ARRAY[610]::BIGINT[])
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
