-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=715
-- TEC-DATA-META years=2020,2021,2022,2023
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.879420+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (715::BIGINT, 'Mi semestre se volvió de los más pesados de la carrera debido a haber llevado este curso con ella. Instrucciones no claras, no hay cronograma, no hay rúbrica, un curso completamente autodidacta, ella está desactualizada y no ayuda con las dudas, demasiadas tareas y evaluaciones. Llévelo con Asenjo.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2023-11-26T00:00:00+00:00'::TIMESTAMPTZ, 'b15f08f2e7e47cde7f7e8fbd599d1e7b33bdc54da8579d02cc6c9365001b460e'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Curso con mucho potencial pero, es imposible reclamar, las rúbricas para calificar son pésimas, la retroalimentación casi nula, hay que estar encima de la profe si hay cosas que no funcionan (aunque no sea culpa de uno), no tiene seguimiento del equipo que se usa,etc No es mala gente pero evítenla.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-11-26T00:00:00+00:00'::TIMESTAMPTZ, '01f95b787dd4652596ecaab3d572c3de0603894cefb70083d86e9d44c2c9d037'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Llevé el curso hace un año. Ella es agradable. Me hubiera gustado que hubiéramos aprovechado los equipos más. Dejó poco tiempo para resolver los proyectos finales, sin embargo sí aprendí a programar PLCs con ella y la bibliografía del curso por sí sola enseña mucho si de verdad le interesa aprender.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-11-25T00:00:00+00:00'::TIMESTAMPTZ, 'ae68ea6c1f8c271a7ee708af81cff30bd23769423fe507c879ca8625cfb89779'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'esta profe es genial, sólo le falta: explicar bien, dar retroalimentación, responder consultas, cerciorarse que los aparatos funcionan, dar enunciados claros, dar cronogramas, que no tenga que programar autodidacta. La profe no es mala gente, solo que es demasiado intransigente con todo. Evite'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2023-11-24T00:00:00+00:00'::TIMESTAMPTZ, '254e4490ed354b52666f59bdaf3185258398087be779d8e6b0c9d9c754a56822'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'La profesora no aprovecha el equipo de laboratorio, nos dio 1 semana para cada proyecto final, porque así salíamos más rápido(Ella salía más rápido).'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2022-11-21T00:00:00+00:00'::TIMESTAMPTZ, '707e452ed62163b06831b9d1a82ea9e1fada7bce968ff1331c897d53b7f9775a'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Las clases son bastantes claras, la profe tiene buena actitud, las presentaciones tienen todo lo necesario para el examen. Se aprende bastante de PLCs, da guías claras. Los proyectos son largos y da poco tiempo pero se pueden sacar.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2022-11-20T00:00:00+00:00'::TIMESTAMPTZ, '6a27f3ec6584010f34361d7edc4fd23a0878f668781a5edf99db44060ae899b4'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-03-01T00:00:00+00:00'::TIMESTAMPTZ, 'b0331177c50827a42910746e58a919f3f63fa12a4c9b6f53d24c5f2e2746035d'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Es una profe que tiene el curso muy organizado. Como tal el curso no es difícil y se aprende lo básico sobre PLCs'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2021-12-05T00:00:00+00:00'::TIMESTAMPTZ, 'a98335a102036b9472457aeb54764b551a3d7512e8c55755285f0043a268860e'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Explica la materia, y tiene buenas presentaciones, se emprende algo de PLC. La profe tiene mala actitud, interrumpe cuando se le está preguntando, no le gusta repetir aunque sean instrucciones de examen. Poco organizada, califica todo al final por dicha califica suave pero no da mucha realimentación'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2021-12-04T00:00:00+00:00'::TIMESTAMPTZ, 'c9adf0de7bd4636c740a133a1b8b6af322296629e2c91353f75ae4548ca978a7'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'No explica bien, no se aprende, molesta mucho con la puntualidad y seguir su cronograma pero pierde mucho tiempo'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-02T00:00:00+00:00'::TIMESTAMPTZ, '7ca603a084a9d01664a7ce5c6f3268eefc05f2f132037d4ec72d7810a93a488f'::TEXT, ARRAY[3070]::BIGINT[]),
    (715::BIGINT, 'Se nota que no sabe mucho de lo que enseña. Molesta mucho con la asistencia, a las 7:30 cierra la clase y de ahí en adelante los que entren están tarde (aunque lleguen antes de los 5 minutos que dice el reglamento). No deja instrucciones claras y se enoja si uno pregunta.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2020-02-04T00:00:00+00:00'::TIMESTAMPTZ, 'c9601e28b0049736da88280ee6b69284554baabe27ac5f4f9642a575416361b5'::TEXT, ARRAY[3070]::BIGINT[])
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
