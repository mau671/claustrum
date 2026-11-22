-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=360
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2020,2021
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.176219+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (360::BIGINT, 'Las clases suelen ser largas y aburridas, deja muchos trabajos en clase, en los exámenes suele dar poco tiempo, califica algo confuso, si no responde justo lo que quiere baja muchos puntos. En si el curso es un poco aburrido pero no es tan dificil.'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2021-12-22T00:00:00+00:00'::TIMESTAMPTZ, '86d360fbba91d2039e387a08d1df6ee5e4f03d9fd011b667988a12453215953a'::TEXT, ARRAY[3534]::BIGINT[]),
    (360::BIGINT, 'Las clases son un poco aburridas, la profe avanza muy rápido y debes ir copiando todo. Es muy estricta con la ortografía de los trabajos y con las referencias (bibliografía). Los examenes los califica justo. En sí el curso si hacés todo se pasa fácil. En general, es buena profe.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2020-01-26T00:00:00+00:00'::TIMESTAMPTZ, '79e5cee4974b436a1a5f55e77bf73b5ab2fa5f731d7adb3787f24e295b8a4428'::TEXT, ARRAY[3534]::BIGINT[]),
    (360::BIGINT, 'Hace que la clase sea demasiado aburrida y parece que quiere que los estudiantes reprueben, baja muchos puntos en las presentaciones y se toma todo muy en serio'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2019-02-07T00:00:00+00:00'::TIMESTAMPTZ, '5533a130f8d1726f5e3f26924039e95bc54133d854ae58cbcd9d592b9e773092'::TEXT, ARRAY[998, 155]::BIGINT[]),
    (360::BIGINT, 'Las clases son aburridas'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-26T00:00:00+00:00'::TIMESTAMPTZ, '9fb5104185be7eeafaa769189393e5b59cb5126db1eb83832360f1a422df7b1a'::TEXT, ARRAY[998]::BIGINT[]),
    (360::BIGINT, 'El curso por si solo es muy bonito, la profe muy buena gente, la metodología permitió el desarrollo de muchos trabajos en grupo, inclusive se lograron impactar varias comunidades de la provincia de cartago gracias las asignaciones.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, '02e9f18b4f1928c4cbef65fd9b3c0a44acf494d4558004642eefe089a8f94ef5'::TEXT, ARRAY[3098]::BIGINT[]),
    (360::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'ed71b2ac6cf93034710cf5134ff7571b3208c04c7a352ca2b25ca6e906c14192'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Los exámenes son largos y la materia puede ser un poco confunsa, las tareas y quices son fáciles. Las clases son largas y aburridas, no cambia el método de enseñanza'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2018-06-25T00:00:00+00:00'::TIMESTAMPTZ, '6c6dccc5e92a4060940f397a040c6de984447fa04cd4a942056e7b2bc003f0ef'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'ac4aeceb9cd21490d22ceaac36db0d7bda6e1720da29b7091a73bb25b2fdc097'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'estricta y califica duro, es demasiada teoria para un curso'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Muchos exámenes']::TEXT[], '2018-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'cd3055d62d343be243f2a128efc64d484ce1b5c2c7f2f81cc17a66f3b004a6cf'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Se aprende bastante, aunque si es un curso algo pesado en teoría'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-05T00:00:00+00:00'::TIMESTAMPTZ, '29e56c27bc99ce1673396d29a342ea573e76f7f7fa893f3c61c3bce536b3d8f2'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Es buena gente, sin embargo califica muy duro, y los exámenes son bastante extensos'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-05-28T00:00:00+00:00'::TIMESTAMPTZ, 'ad788ed47b215d9f5d490ac9e99bc22aa1126ef4a912d2a2c7e6aa5f92471f58'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2017-05-22T00:00:00+00:00'::TIMESTAMPTZ, 'f85eb07a4d817f1dd2aa89d67003e706e604a4a637f1bc1d668d810624b23676'::TEXT, ARRAY[3087]::BIGINT[]),
    (360::BIGINT, 'Es muy ruda calificando ya que los exámenes son desarrollo y solo tienes que responder únicamente lo que ella pone en sus presentaciones, presentaciones las cuales no envía ni deja tomar fotos por ende o copias o pones atención a lo que ella va diciendo en clase y va rapidísimo.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-01T00:00:00+00:00'::TIMESTAMPTZ, '72848956398d0668322ea0a7b684bf2475d657f97ddcc43775cef27a812b3069'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'Explica bien, califica muy duro pero siempre está dispuesta a ayudar siempre que el estudiante muestre interés.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2017-01-09T00:00:00+00:00'::TIMESTAMPTZ, '5a68b57f07d7c881d5854409e3d77cdda6c1c802c086c355edb103c93da71420'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'Muy buena profe. Evaluaciones duras pero que pretenden los que comentan? Somos del TEC compas..'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-05-27T00:00:00+00:00'::TIMESTAMPTZ, '8c88a5be00d57b8820fce8b51cb390f0eb1f30f5d7dbd2335ffb06ad762b94a7'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'Buena gente, de todos modos ese curso es súper fácil'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-26T00:00:00+00:00'::TIMESTAMPTZ, '074236252b665dbc4964f6217dbe4d27b72134478ebeef0eaa5f90388ff705df'::TEXT, ARRAY[998]::BIGINT[]),
    (360::BIGINT, 'La clase más aburrida y larga que se pueda tener...Califica muy rudo, lo único bueno es de que trata de que todos entiendan.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-21T00:00:00+00:00'::TIMESTAMPTZ, '9750c27b34d3345fcdfa3d42abe43515f9e5024c4dafbd2555229f5f1d648acb'::TEXT, ARRAY[1001, 155]::BIGINT[]),
    (360::BIGINT, 'Califica muy duro en los examenes con respecto a lo que enseña.'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-21T00:00:00+00:00'::TIMESTAMPTZ, 'b862922215c29265c86b35bed9265c5885ecf83dae6d5167d2880746fbc0644f'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'Califica muy duro, las evaluaciones son mortales'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-05T00:00:00+00:00'::TIMESTAMPTZ, '29418a35a3807ade27d26e70a34d6364e65498d68a98f035fac1eda1cab050bd'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, '8a8600ff509b7c875c5b7650215fb40e412eea1df0d9ba78d7775feaeab9804a'::TEXT, ARRAY[1001]::BIGINT[]),
    (360::BIGINT, 'petulante, y da temas por entendido que no explica en su totalidad, y en los examenes los evalua por completo'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-23T00:00:00+00:00'::TIMESTAMPTZ, '4c592dc07ee7859e54f40b5daedcf502d20919a42f37012570afb5c4ed81270a'::TEXT, ARRAY[1001]::BIGINT[])
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
