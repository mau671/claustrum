-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=27
-- TEC-DATA-META years=2021,2022,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.280845+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (27::BIGINT, 'Excelente profesor de mi parte, es muy difícil quedarse si pones atención y das de tu parte, volvería a tomar de nuevo la clase'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-04-10T00:00:00+00:00'::TIMESTAMPTZ, '0494c218e9705ee8a8c7a9df3c778fdb03c9a7f2265f5748300fe3d18b0f65f5'::TEXT, ARRAY[2451]::BIGINT[]),
    (27::BIGINT, 'Da ejemplos de la realidad nacional e internacional, hay que apoyarse del libro, pero si uno va a horas consulta explica más a detalle y las veces que sea hasta que el estudiante entienda. El curso es complejo por la teoría y práctica, pero si uno le entiende los siguientes son más sencillos.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-04-10T00:00:00+00:00'::TIMESTAMPTZ, '642e3bfc9755602e56544dede07532d2ea04971817d18ddb2db6456d0ad1a41b'::TEXT, ARRAY[2371]::BIGINT[]),
    (27::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-04-09T00:00:00+00:00'::TIMESTAMPTZ, 'd2713d53d36ce0dd4542584cbbfd6984c9b298480346c7e0d17f0b5bcd8b2be4'::TEXT, ARRAY[2371]::BIGINT[]),
    (27::BIGINT, 'Las clases demasiado aburridas, es ver como presenta miles de diapositivas que al final ni entran en el examen. Las prácticas ni las explica. El tiempo de los exámenes ni alcanza. Usted debe aprender por su parte, ya que solo con el profe, JAMÁS'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2023-12-11T00:00:00+00:00'::TIMESTAMPTZ, 'de2db1d1bb74aa1181740b23e5a181a06f41208b593457c429384fbc6d3b3501'::TEXT, ARRAY[2371]::BIGINT[]),
    (27::BIGINT, 'En mi opinión es un buen profesor. Si es cierto que hay que leer para entender la materia. La asistencia es obligatoria. Si le preguntas algo sobre la práctica, te contesta con otra pregunta (que debes de saber). Es un profe accesible, las prácticas son "parecidas" al examen.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '2d69cae7ede8e84612fd66f6862c63c334b33158e315f397b8204593d0eca2d2'::TEXT, ARRAY[2371]::BIGINT[]),
    (27::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases excelentes']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '9d87654b589384e631832a8f7b6e5303edd15d27816a69a1841962467762b645'::TEXT, ARRAY[2451]::BIGINT[]),
    (27::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('50','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2023-01-10T00:00:00+00:00'::TIMESTAMPTZ, '8f3edffda4a65ba8607b4b2f340fe927abb209deb1b763d75aac49bc7448360f'::TEXT, ARRAY[2396]::BIGINT[]),
    (27::BIGINT, 'El proyecto es terrible, quedó a media clase con esa calificación, sus clases son aburridas, cero dinámicas. Sus exámenes son confusos y difíciles. Las tareas son fáciles pero califica duro. A veces se comporta un poco machista'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Deja trabajos largos']::TEXT[], '2022-12-23T00:00:00+00:00'::TIMESTAMPTZ, '76801a1051d4104cf777db516865fb58293d5b9c9408cf408fc75b1643495009'::TEXT, ARRAY[2396]::BIGINT[]),
    (27::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2022-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'fb57426251f947776bb2518babc5a81f032bcb567920f8178e0cc3c24e5e2e61'::TEXT, ARRAY[2368]::BIGINT[]),
    (27::BIGINT, 'No explica de forma clara, si sos nuevo ingreso no matricules con él.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'b474c676479ec19e86b514e5ab511fbb8c6847735a6ed807c74d8f91d6cab021'::TEXT, ARRAY[2442]::BIGINT[])
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
