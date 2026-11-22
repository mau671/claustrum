-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=23
-- TEC-DATA-META years=2021,2022,2023,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.761343+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (23::BIGINT, 'Pésima profesora. Daba exámenes con requisitos tan estrictos que eran incoherentes (mandaba a estudiantes de SJ a vender chucherías a pie a Cartago, mientras ella cómoda dando clase virutal en San Carlos). Hace lo posible por no dar clase.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'be6e28eb0dcb2c42124d88281db86582f152c1eea268ecae34a27204b030d4c1'::TEXT, ARRAY[2463]::BIGINT[]),
    (23::BIGINT, 'La profesora siempre nos apuraba porque tenía otras reuniones en nuestro horario de clase. Básicamente no se le podía preguntar nada si no era en la clase. Todos los grupos eran al azar. Un poco arrogante la verdad, y no tiene paciencia para nada.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'd804ca486773f423fa5a1f5380981eb18850b4d0a869edce894363f91a893c98'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'La profesora es muy buena pero estricta, se aprende con ella. Las clases son cortas y hacia el punto. Maneje bien APA7. Los equipos de trabajo cambian en exámenes, tareas y trabajos. La asistente es lo malo, todo lo critica, juega de estricta y de ser la profesora, se refleja en su nota. (Virtual)'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2023-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'c7207fe421ecd4dd5bdfccbdb29e54f3f8c92f8d503026aa2f2410262be107a3'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'No sabe explicar, no comparte presentaciones, muchos trabajos tontos pero califica no muy rudo. Igual no la recomendaria'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2023-11-02T00:00:00+00:00'::TIMESTAMPTZ, 'bfb3e3409d262fefef03fc37f7870a036314afb8ea3568943d0713ba13863960'::TEXT, ARRAY[2438]::BIGINT[]),
    (23::BIGINT, 'No sabe trabajar calificar ni preocúpese por los estudiantes'::TEXT, 8.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2023-09-09T00:00:00+00:00'::TIMESTAMPTZ, 'da80a8b08c3b4db0bb9779af8e3f0e8c02eed102592d345839c977c557c35674'::TEXT, ARRAY[2438]::BIGINT[]),
    (23::BIGINT, 'La mejor profe que he tenido en la carrera. Las clases son cortas y al punto, se aprende un monton, los trabajos y examenes son super dinamicos. Se pasa facil y si se aprovecha el curso'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-02-21T00:00:00+00:00'::TIMESTAMPTZ, '4b2e3c3f2b32ff9e31829175b0d4f62ea5fbc70f64a005ebe464d096e8270282'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'La profe es excelente, clases cortas, explica bien, es justa al evaluar, etc. Su pecado capital es a la hora de las evaluaciones, ya que el 90% son grupales y los grupos son formados al azar, lo cual resulta súper tedioso por el hecho de trabajar con compañeros irresponsables.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2022-11-18T00:00:00+00:00'::TIMESTAMPTZ, 'b43e299657c0460fb890704c102a88a1939d79c390d065f5acfeddf66d694c4a'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'Clases 10/10, trabajos grupales al azar, califica duro el uso de APA 7. Los exámenes y proyectos debes justificar todo con APA 7, usar referencias y citas (importante usarlas), de lo contrario te baja muchos puntos.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2022-03-14T00:00:00+00:00'::TIMESTAMPTZ, 'cab83cb9b4696e007ba3751aef6d2ded5b67e084a56b805f42d63234a172ea5b'::TEXT, ARRAY[2438]::BIGINT[]),
    (23::BIGINT, 'Excelente profesora, el proyecto final es bastante largo y los grupos son al azar.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-12-21T00:00:00+00:00'::TIMESTAMPTZ, '40d5182e751151ada1af72668aa420565c669ca79991bbb9561a996f921ca447'::TEXT, ARRAY[2438]::BIGINT[]),
    (23::BIGINT, 'Excelente profesora y se preocupa por los estudiantes. Sin embargo los exámenes y proyectos se requiere con tiempo, los exámenes se hace en grupo al azar y con eso en ocasiones debe lidiar con algunos compañeros. Para el proyecto elija un buen grupo de trabajo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-24T00:00:00+00:00'::TIMESTAMPTZ, '6d4f307cbebdb76ce8a957dc399ead1a2faf6fb823d6b0fe78d193517af402ad'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'La profe es muy buena gente y explica súper bien, las clases son entretenidas. La mayoría de los trabajos son en grupos al azar. Los trabajos y exámenes no son difíciles pero si requieren tiempo.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación']::TEXT[], '2021-11-18T00:00:00+00:00'::TIMESTAMPTZ, '88de6b592b7e89b43337df433bf1f830622b7df446e29ce642425f6cfc851746'::TEXT, ARRAY[2412]::BIGINT[]),
    (23::BIGINT, 'Excelente profesora, se preocupa por el estudiante y da muy buena materia. El proyecto y los exámenes no son complicados pero sí se hace en grupo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Da crédito extra']::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'e56a9cef9bce6c1809c2b427e157a62cb92eef79aa0efaa4009f4e0ddbcebb8a'::TEXT, ARRAY[99]::BIGINT[])
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
