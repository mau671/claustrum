-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=536
-- TEC-DATA-META years=2015,2016,2017,2018,2019,2020,2022,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.799341+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (536::BIGINT, 'Explica de marera excelente los experimentos que se llevaran a cabo en el laboratorio y no califica tan duro a diferencia de otros profesores. Da tiempo para la entrega de informes y si lleva el cuaderno de laboratorio al dia, repasa para los quices y estudia los informes para el examen, le ira bien'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2026-06-26T00:00:00+00:00'::TIMESTAMPTZ, '69d600cfd405e9bac81c657ff2204d9129ab876f22483db60e459b49c5a09f57'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Excelente profesor, explica de manera fenómenal los experimentos, ayuda bastante con los informes y no los califica tan rigurosamente. Díficilmente responde dudas por el correo, así que cualquier duda hagásela en la sesión de laboratorio.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2024-08-11T00:00:00+00:00'::TIMESTAMPTZ, 'c377799462ff018e913956444ac06754531d6193a2a72a5b3ec936636d9d84b8'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Muy bueno, explica muy bien y ayuda mucho con los informes, si estudia previo a la clase se pasa regalado. Le gusta la participación aunque no tenga mínima idea de la materia. Virtual era de trabajo muy autónomo pero siempre atendió las consultas'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'fce6d47dec821a650e9676946f366a6b52478dd8d7c2f46369ac62ccbfc1664a'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Muy buen profe tanto virtual como presencialmente, su único punto a mejorar es que casi no contesta las dudas si no es en la clase, dura mucho en responder por correo o teams'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Respetado por los estudiantes']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, 'cb8cf6f38424b2d682de1db774339a2fcffd12a9c41d777f3676f8075ab7585d'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Es buen profesor, siempre aclara las dudas que tenga.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2020-08-19T00:00:00+00:00'::TIMESTAMPTZ, 'd3d9ab7b6d45eb39c5a88460f500dc72f1e0babf9c89af2591e08ba03434bf25'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'El profe califica duro los informes y los cuestionarios previos aún más. Si le pedis ayuda hacelo con tiempo y a veces no contesta, hay que estar encima. En la clase solo pone los videos de la cátedra y contesta dudas que se tengan en ese momento.'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2020-08-10T00:00:00+00:00'::TIMESTAMPTZ, 'e9da8e867b3064057df9f5823b405e51f225af8361cdb997800c1163204290f9'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Quiz todas las semanas, él es buena gente, pero igual es estricto con las reglas del lab. Esos cursos son simplemente acatar instrucciones y se pasan solos, solo no faltar'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Muchos exámenes']::TEXT[], '2020-02-05T00:00:00+00:00'::TIMESTAMPTZ, 'edbce158514b608b5d4d78a81e219b97f8cb8de2aba74c6bdf9fcdbb5f090f61'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Full recomendado para este curso. Si usted hace su parte para Lab, no va a tener ningún problema con este profe y el curso. Es importante la libreta completa! Revisa los informes normal (no es TAN rudo) y los quices son en linea. El curso se disfruta y el profe es súper pura vida.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2019-12-18T00:00:00+00:00'::TIMESTAMPTZ, '3e49d7812c34d1aa5f93e2935a39546fbe49fbcd1e33cf562cdd5274ffda87f7'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Recomendable.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2019-12-15T00:00:00+00:00'::TIMESTAMPTZ, '9ac9d33b5361c81986b59162a3087b5f2971b57589759c9f9efc711100ee1ce5'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Es un buen profe, super claro, se aprende. Lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-19T00:00:00+00:00'::TIMESTAMPTZ, '3b5d4c516e2ea86d1ad63682a15a507ebdb6b4042ef286b6bc4d95124d7fe37e'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'El profe es super bueno, califica suave los informes, explica todo al inicio de la clase y te ayuda siempre que pueda. Los quices los hace por medio del TEC-Digital y todo lo que se pregunta está en el manual.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-16T00:00:00+00:00'::TIMESTAMPTZ, '04e75b808c18995cbdde5c74e40aedf01b79c590d1e747f92608b844b13aa819'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Es tuanis, explica al inicio de la clase muy claro, es muy sarcástico'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-12T00:00:00+00:00'::TIMESTAMPTZ, '0cc0954c8a2ca0bff0fb6e9caf8e4e5643b34ffa0be68dce3403dfa6e65223d7'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Me gustó mucho su clase, ayuda mucho a entender todo y lo repite si es necesario. Tomaría su clase de nuevo. Es muy comprensivo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-08T00:00:00+00:00'::TIMESTAMPTZ, '0da2d2562f7de7a270a9300ada1d8423f01233c3d9d70e4ca15518fcc7f4cd0d'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Explica muy bien las lecciones y los quices son normales. Califica bastante suave los informes. A veces es un poco sarcástico cuando uno le pregunta algo, pero luego uno se acostumbra. Deja hacer los exámenes al ritmo de cada uno. :D'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2018-12-11T00:00:00+00:00'::TIMESTAMPTZ, '6036712fe420b0120bd8362c1b9fcd785bf904fcf1601cf014c672b626b689af'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Explica todo muy bien. Ayuda cuando se puede. Califica normal.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-01-17T00:00:00+00:00'::TIMESTAMPTZ, '2e867f9c1da6dee1d77bb133f08a3f8ed37236a5af6b7d45fc313632410cbd1b'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'El profe es muy buena nota, si usted necesita ayuda el explica, a veces califica los informes un poquillo rudo, pero nada del otro mundo, las clases son entretenidas.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-02T00:00:00+00:00'::TIMESTAMPTZ, '266d63bb0f89c15c4bc570e3ed857c63ddcdc534b0ff46aae353e71c66e74e5e'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Fácil y ayuda bastante'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-18T00:00:00+00:00'::TIMESTAMPTZ, 'b5c42dcf4759d8c7809203c1bd77a80ebae38af29e07445ba7c28daf6e9698d1'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Excelente profesor, entretenido y de fijo pasa...'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'e80aa5f1ed2ec8bb9120b4c426ff8cd3b034d0405598b22c46894db12a19a1a4'::TEXT, ARRAY[567]::BIGINT[]),
    (536::BIGINT, 'Este profe es una teja, en los labs se disfruta, explica super bien, recomendado, hay que repasar para los quices solamente, excelente persona. Inspira y motiva.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-14T00:00:00+00:00'::TIMESTAMPTZ, 'e9ef1c313147f140f3acb138660d95a87ff6a14508a015cf170afb62b517c8c1'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Muy facil y encontro el quiz que me perdio :)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-01-06T00:00:00+00:00'::TIMESTAMPTZ, 'a0ae545c18d30b72cdd2525a900fc74c317c9ad6538b00b18e16c1939d9ff217'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, '54e54ea22da62044d82d9faf8b1cd427095d0634b71c2b66f1b14d5931bef4a5'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Es buen profesor, la clase no se hace pesada y califica suave. Me perdio un quiz, pero igual lo recomiendo.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-10-29T00:00:00+00:00'::TIMESTAMPTZ, 'f4ecd51e2ee74a081aa9b8130b4d512d2987263e1fa2f4b1bcd5c6a823fe409e'::TEXT, ARRAY[613]::BIGINT[]),
    (536::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-10-06T00:00:00+00:00'::TIMESTAMPTZ, 'a71e8c62d3befd67288a33aaf2f34f321015281ff3c7ccdc07b8ec6e8db8a4e6'::TEXT, ARRAY[613]::BIGINT[])
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
