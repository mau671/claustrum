-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=623
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:48:31.819310+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (623::BIGINT, 'Pasivo agresivo a más no poder y con un sentido del humor que sólo a él le hace gracia. Responde a todas sus preguntas pero no como quizás usted lo espera. Manténgase al día, haga los trabajos con tiempo. Se rehúsa a usar el TecDigital. Curso casi obsoleto que puede ser un taller.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2025-09-13T00:00:00+00:00'::TIMESTAMPTZ, '4c99cac8a8c03df39ceba1982842416f51c42cf44bd5f1a389818b4c71caec25'::TEXT, ARRAY[1876]::BIGINT[]),
    (623::BIGINT, 'Trabajos largos, si quieren aprender a usar Ilustrador, este es el curso, sin embargo, el curso llega a ser repetitivo a cierto punto, la clase puede ser virtual o incluso asincrónica y no afectaría en nada.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Aspectos de calificación claros']::TEXT[], '2025-09-06T00:00:00+00:00'::TIMESTAMPTZ, 'aec55f14df9c62f8cfde878aebc8a5b51392dca7005f10e268c15fa45fd5f690'::TEXT, ARRAY[1876]::BIGINT[]),
    (623::BIGINT, 'Fernando es un excelente profe, recomendación lean las lecturas, póngale en los trabajos, cuiden sus medidas, no corten con tijeras, quita puntos por cada mm de más o menos, el formato es lo más importante. Es un curso donde se aprende demasiado.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Clases excelentes']::TEXT[], '2019-11-18T00:00:00+00:00'::TIMESTAMPTZ, '28541f74b8bf4bf2798a5975e634fe607796e23471163c9221ad38eb31ff007c'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Fer es un profe peculiar. Es muy buen profe y sabe un montón de Diseño Gráfico. Recomendaciones: -Vaya al día con las lecturas. -Las medidas son sagradas. Quita puntos por cada mm de más o menos. De verdad, el formato es lo más importante. -La puntualidad es súper importante. No juegue con ella.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2019-11-12T00:00:00+00:00'::TIMESTAMPTZ, '667f6896b24b7201d99e17a5e0f427feb057a86fc676f0154e08c17340898943'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Es el mejor profe del mundo no dude en matricular con él????????????????'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2019-05-31T00:00:00+00:00'::TIMESTAMPTZ, '6bed8b6a45638b4a592107d86fc99844aeaa28356c40a401ac582a5be633beb9'::TEXT, ARRAY[4749]::BIGINT[]),
    (623::BIGINT, 'Los proyectos que se realizan en clase son demandantes, pero muy interesantes. Es exigente y perfeccionista pero te guía y es claro en lo que quiere. Además es una persona demasiado linda, se vuelve como un amigo para uno, ir a clase es de lo mejor.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2019-05-29T00:00:00+00:00'::TIMESTAMPTZ, '0053b00afd4dff301c71eac2daa254e06edc1152c6f37015a7d4d469973cb9fb'::TEXT, ARRAY[4749]::BIGINT[]),
    (623::BIGINT, 'Es buena gente pero a veces pierde mucho tiempo en clase. Exigente y perfeccionista.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas']::TEXT[], '2018-08-18T00:00:00+00:00'::TIMESTAMPTZ, '01304dfdd7e0b33cd9b5ac121f70d409cf7848a0e0cf8bc87f898c7a43221f12'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Es una persona super especial que más que un profe es un amigo. A veces se perdía bastante tiempo en clases, pero en general super recomendado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Deja trabajos largos']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'ce8964c808fbe19b7cfc0fcf1e1ece41185b09fd7b8c4491f10aaab2740a1149'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Es un profesor excelente, solo que hay que ponerle bastante ya que es bastante exigente con los trabajos. Es excelente persona y dispuesto a ayudar'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-20T00:00:00+00:00'::TIMESTAMPTZ, 'c9aabc7bc2272479031b3d9a7575f90cd04061acf07a8be954124ceaa5d80001'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Excelente profesor, se aprende demasiado pero hay que ponerle'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2017-06-26T00:00:00+00:00'::TIMESTAMPTZ, '1bd7521f3404f7d6cbe6f64bee0ac40b208d8ee94527b52a532b9e608c5d4fdb'::TEXT, ARRAY[1710]::BIGINT[]),
    (623::BIGINT, 'Estricto pero demasiado pura vida, es directo y se aprende mucho'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-01T00:00:00+00:00'::TIMESTAMPTZ, '35377183995cf10d222fbbd1ba346b3394e53244d5ed0745052c4a94f80f88fb'::TEXT, ARRAY[4749]::BIGINT[]),
    (623::BIGINT, 'Es buena persona, pero es un profe que no sabe que quiere un día te dice que le quites algo a tu trabajo y al siguiente te dice que se lo pongas, el mismo se confunde y luego pone malas notas porque nunca se supo explicar.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-19T00:00:00+00:00'::TIMESTAMPTZ, '74add5657976bf98303b1333b7d8bbba9c25c7b34f66541b11ff84f7be0efed4'::TEXT, ARRAY[1933, 1929, 1925]::BIGINT[]),
    (623::BIGINT, '¿Qué decir de Fernando? Un profesional excelente. Es buena gente, se aprende bastante en sus cursos y es super perfeccionista, pero así como exige, da. Lo único malo es que a veces se enreda con lo que pide y si una semana te dice que quités algo, la siguiente te dice que lo agregués.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-18T00:00:00+00:00'::TIMESTAMPTZ, '4a99a0a29c933a2bddb6b15ad620f04f5d460babe1e23db6721567a13968515c'::TEXT, ARRAY[1915, 1926]::BIGINT[]),
    (623::BIGINT, 'Muy buen profesor, se aprende bastante, eso si es muy estricto con los trabajos pero si se saca el curso'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-07-03T00:00:00+00:00'::TIMESTAMPTZ, '5a30564e47c086ade42142218de089773bf71a7a0d3dc9974d27a4b096d32707'::TEXT, ARRAY[1929, 1925]::BIGINT[]),
    (623::BIGINT, 'De los mejores profes de la escuela, por mucho :)es muy estricto pero se aprende de verdad.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'f94f855cc347f5520e26305b204a80d73001489956baaab10ff82415465ca69b'::TEXT, ARRAY[1929, 1925]::BIGINT[])
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
