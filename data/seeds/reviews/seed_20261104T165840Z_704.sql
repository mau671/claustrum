-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=704
-- TEC-DATA-META years=2018,2019,2020,2021,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.868243+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (704::BIGINT, 'Tenía expectativas de aprender algo interesante en este curso, pero la verdad es que no se aprende nada, el es buena persona y ayuda si necesita, pero siento que su conocimiento no se transmite, el curso en general necesita algún cambio tal vez'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2026-08-04T00:00:00+00:00'::TIMESTAMPTZ, 'dee267a597283779ceb5ec66b938a938ad1c49a7977018e1afeab0b6a3f3e977'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Es buen profe, pero las clases se pueden volver muy largas y aburridas. En general se pasa fácil y él está siempre dispuesto a ayudar a los estudiantes.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-30T00:00:00+00:00'::TIMESTAMPTZ, '264d464db05fabeff17b4616ba323ae1927a92961cdde07f1e85e22652c739c7'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Las clases las dan los estudiantes, no demuestra conocimientos sobre la materia. No le da importancia a las presentaciones ya que solo sirven para él no dar la materia. No demuestra preparación del material para las asignaciones.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-11T00:00:00+00:00'::TIMESTAMPTZ, '2ccea16ad2b9b975811b955bea576d5e251276cdbd492878496e2a41ef5cc36c'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Las clases son muy aburridas. No se explica bien y los talleres no tienen mucho sentido. El proyecto tampoco es muy relacionado al curso. Me hubiera gustado aprender más de redes, pero la verdad salí igual que como entré.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-06T00:00:00+00:00'::TIMESTAMPTZ, '73afe4f96accae941c694e6ec01d205e164e0551436a2416b556ddd889f6e451'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Increíblemente aburrido. Se pasa fácil, pero a veces es un poco difícil entender al profe'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-01-30T00:00:00+00:00'::TIMESTAMPTZ, '2a0f3259e92370cd7efcdd44f26d5e27f832125d406665e33909864ac3864e28'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Las clases las dan los estudiantes, no parece tener conocimientos sobre los temas.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2021-01-18T00:00:00+00:00'::TIMESTAMPTZ, '67c08306088d71401e6903fc025ec14c547da1262e060a9e860031284f8230f5'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, 'eb6aa33a1b0a2d28370b0e12acb34a640860cad3c95d4cc46f268662d0fe77fb'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'No puedo opinar del curso pues lo llevé durante la pandemia. Pero el profe fue muy comprensivo'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2020-08-17T00:00:00+00:00'::TIMESTAMPTZ, '538d8e972c78bbac7184d5edf89ec1e65ed528428065edaba0e9cf2e7f3b0ab3'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'Los estudiantes dan la clase con presentaciones.'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-14T00:00:00+00:00'::TIMESTAMPTZ, 'b22589c8954fa8e0696daec3ae2e2fef6838eb74f7f2e3ec826e1871bf04922d'::TEXT, ARRAY[2986]::BIGINT[]),
    (704::BIGINT, 'Es un taller, hay que asistir, hacer proyectos y aprender, califica de manera justa.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-02-13T00:00:00+00:00'::TIMESTAMPTZ, 'e13a9d51c5ca6a7aab33c6d11773e79e9448b728f0eed1b3fb0e7bcf994e81b0'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'Es solo hacer los proyectos e ir a clases, aunque el profesor no sabe mucho se aprende investigando'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2018-12-17T00:00:00+00:00'::TIMESTAMPTZ, 'ca235b40533f86c47bdb8d8aa03da67e17fcc6b46b545f87b90a96862c26721c'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'Mal profesor, cuando uno le pregunta no sabe que responder, parece que no conoce los temas, casi no explica nada, y el curso basicamente es hacer los proyectos buscando en google'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'ef0979438a9848716255d332666788ac9442e29179be5ee662e28ad10cde1729'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil']::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '6adf0df6b605bf553726617ef61feef7d8faa9857ca7afdd7374e55124b7a7dd'::TEXT, ARRAY[2980]::BIGINT[]),
    (704::BIGINT, 'El tiene conocimiento pero como profesor sus clases son bastante aburridas y con poca profundidad del tema'::TEXT, 10.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'e1d9215799fe5dd75ae02573bd47763a13d73dc16855d709c520d94fe8992eec'::TEXT, ARRAY[2986]::BIGINT[])
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
