-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=248
-- TEC-DATA-META years=2016,2017,2019,2021,2022,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:42:35.849751+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (248::BIGINT, 'Al inició del semestre explicó una metodología de resolución de ejercicios que no usó nunca. Es condescendiente, hipócrita, desordenado y confuso. Las explicaciones de los ejercicios no son tan malas pero su personalidad vuelve el curso insoportable.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('60','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2026-08-07T00:00:00+00:00'::TIMESTAMPTZ, 'be80ac181595ed34eef71484700f5492a491b513ee87a39daf95a87129355310'::TEXT, ARRAY[931]::BIGINT[]),
    (248::BIGINT, 'Capaz que en toda esa escuela no hay un profesor decente para dar el curso de estática?'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-03-25T00:00:00+00:00'::TIMESTAMPTZ, '73db6d8f21bd83d428fe859a7481d7f4f36b709f9f5828a4e6e39be2e3e51792'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'El profesor explica muy bien, y es el mejor profesor con el que puede matricular estática, sin embargo, el curso es muy duro, y el profe no regala puntos, y si a usted no le queda claro el proyecto, el profesor no le ayuda a entenderlo.'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2021-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'ad1b1254c3eb4b83b5fa771696d460790f955150a6aacbdfe132a78f598afc04'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'En realidad es muy buen profesor, ya que explica muy bien, pero sus quizes son mortales ya que va a matar y no apoya, quizás no es lo mejor. En si es un curso pasable y el profe es bueno, aun así si tiene otra opción buena mejor evitarlo. *La catedra deja un examen rudísimo pero lo califican suave*'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2021-06-25T00:00:00+00:00'::TIMESTAMPTZ, '5caae27ef03ba0275441f290525c97532519348593994b4b1e9624136d53478b'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'Muy buen profesor aunque su personalidad podría chocarle un poco dependiendo de la tolerancia de cada quien. Sus explicaciones son bastante claras porque sabe de lo que habla. Es relativamente estricto en cuanto a los quices aunque nada extremo, con resolver los ejercicios que recomienda es un 100'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-12T00:00:00+00:00'::TIMESTAMPTZ, 'ce64b77994214095ef66ee780993b65bd5f4edfb84315a7f1e7e6cd3aa119099'::TEXT, ARRAY[931]::BIGINT[]),
    (248::BIGINT, 'Va muy rápido y da por hecho que todos entienden, pero es cuestión de ponerle y no tenerle miedo porque en realidad la materia es fácil'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'f5d28ee8ca1ad1d957d0b9157d2d6567e058e2d03ec9f87d5a89dd5ba6a3cb58'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, '53cb0cf86d8174b35217e997da0d7f96f3dfbfe8f4e63ba115fb912f0df700b7'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'Excelente profesor, la verdad explica para la vida.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-22T00:00:00+00:00'::TIMESTAMPTZ, '946cd84b2066132427288bc330a4b0240aee82e1bc8a107409e28b56e2b86b78'::TEXT, ARRAY[636]::BIGINT[]),
    (248::BIGINT, 'buen profesor'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2016-05-20T00:00:00+00:00'::TIMESTAMPTZ, '64b92ab35339e9aa605afd0912f044374b36613612866987bbc4f759dc0a1df1'::TEXT, ARRAY[636, 931]::BIGINT[])
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
