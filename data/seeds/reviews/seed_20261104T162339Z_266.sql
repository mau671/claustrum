-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=266
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.921433+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (266::BIGINT, 'El curso es bastante exigente en la cuesta final del semestre, se juntan todos los trabajos importantes. Sin embargo, el profe enseña bastante bien, se nota tiene vocación, y es de lo más pura vida. Sin dudas volveria a llevar el curso con él.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2026-08-07T00:00:00+00:00'::TIMESTAMPTZ, 'a7c5d016d335e2b08ef7b08ffa2e9970a9b0ffce00c033ed81d38f5d42ec3652'::TEXT, ARRAY[1017]::BIGINT[]),
    (266::BIGINT, 'Muy buen profe, posiblemente les ayude mucho si le piden retroalimentación y muestran interés en el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Pocos exámenes', 'Tomaría su clase nuevamente']::TEXT[], '2026-05-26T00:00:00+00:00'::TIMESTAMPTZ, '34a2f3de384ac3a9e05b596241022a8fd14ec2892bf9d0e5577ae581f68250c2'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'La participación importa', 'Inspirador']::TEXT[], '2025-11-19T00:00:00+00:00'::TIMESTAMPTZ, 'd81d93adf92bc26c08055772363bfde832bcd7e757bdb072c5f52ab1ac62d146'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'Buen profesor y bastante agradable como persona. Califica normal y en los proyectos programa a la semana reuniones con los estudiantes para ir viendo los avances brindando retroalimentación.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'be9ce355379333fee3e94ffc0893b7c76887388629d2d93717d84a113156eacc'::TEXT, ARRAY[1154]::BIGINT[]),
    (266::BIGINT, 'De fijo se pasa si se presenta en todas las clases, ayuda bastante a los estudiantes y propone proyectos interesantes'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2023-06-24T00:00:00+00:00'::TIMESTAMPTZ, '439d6697697fc76fb6b6b85fdc4f850f155a1576deef9e35b2b8357ebb6c9084'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'Jorge es de los mejores profes que he tenido, la razon por la que sigo en la carrera... después de haber sufrido con Kirs**** topar con este profe fue lo mejor, los trabajos fueron en parejas e incluso el examen, los proyectos en grupo. El mae realmente quiere que uno aprenda.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '09e40b8153680d373d2abbff648666aebbd55a6ba0e0de726f878b926d92f269'::TEXT, ARRAY[1017]::BIGINT[]),
    (266::BIGINT, 'Es claro, la materia es fácil, las tareas y los proyectos, no me parece una clase entretenida, pero si usted es de Cartago matricule con el porque de fijo pasa, todos los profes de Cartago son lo peor'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-02-15T00:00:00+00:00'::TIMESTAMPTZ, '04added48ce15a01289d8ddee689613e57c443cc5b8932e7ca3a1ecfc8cc0686'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'En si el profe es super pura vida y siempre esta dispuesto a ayudar, a veces hay que recordarle porque es medio olvidadizo. Normalmente deja una tarea cada semana, los proyectos no son duros si se empiezan cuando el dice y se le pide consulta. Hace un examen final que es horrible la verdad jajaja.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-06T00:00:00+00:00'::TIMESTAMPTZ, '9083c197bdce4344402f45bdf653945e5b45c8fdb7dfff1bff125831e935714d'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'El Profesor es de los que sí ayuda cuando se le consulta algo. Lo malo es que se va por las ramas cuando explica un tema y en cuanto a las evaluaciones no se sabe exactamente que califica (las rubricas no son claras).'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases largas']::TEXT[], '2021-11-20T00:00:00+00:00'::TIMESTAMPTZ, 'e2b228b341250caf94466afa67baef40d5f84279fb0d29e616f360d0b3da9ab7'::TEXT, ARRAY[1154]::BIGINT[]),
    (266::BIGINT, 'Excelente profe, ojala diera todos los cursos de compu. Deja tareas todas las semanas, la mayoría son bastantes cortas como buscar información de cierto tema y compartirla en un foro. Hace solo un examen a final de curso que es bastante largo pero se logra. Definitivamente la mejor opción.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-21T00:00:00+00:00'::TIMESTAMPTZ, '769c1b9ba6576e3b7bc5a37e6e9a71f107eb1c43783837a642dbc5ffceb1a96c'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'El mae es pura vida pero tiene casi 0 pedagogía, las tareas son largas, el examen final del curso se puede describir en una palabra, brutal. El examen duró desde las 8:30am hasta las 7:40pm. Aparte de eso explica normalito, se entiende. No llevaría de nuevo un curso con él si tuviera otras opciones.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'dd85dfaeb2b73072109526cbe885cd7ae56efe0178142bd5f80a1bab07abbdc7'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'Excelente profesor, siempre dispuesto ayudar y su clase es muy interesante. Pero califica un poco duro'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Da buena retroalimentación']::TEXT[], '2021-06-16T00:00:00+00:00'::TIMESTAMPTZ, '6552f04e64432ae6ee98342c2518afdb88f2dde92655dd09689ccb71d37a46d7'::TEXT, ARRAY[1032]::BIGINT[]),
    (266::BIGINT, 'Excelente profesor, sin duda la mejor opción para los de Cartago es esperar extraordinaria por este profe, clases muy amenas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-05-23T00:00:00+00:00'::TIMESTAMPTZ, '6fe1b61386bd87e528813407ef24cc5ec529f86fb93c9371c7493426a4fb69ff'::TEXT, ARRAY[1032]::BIGINT[])
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
