-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=676
-- TEC-DATA-META years=2014,2015,2016,2018,2021,2022,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.845352+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (676::BIGINT, 'No se le entiende muy bien. Explica pero muy enredado. No hay mucha claridad en lo que quiere. Asistí a todas las clases e intenté poner atención pero sinceramente no entendí muy bien la materia. Es materia fácil pero lo complica mucho. Me hubiera gustado ejemplos mejor explicados para entender bien'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo']::TEXT[], '2026-06-03T00:00:00+00:00'::TIMESTAMPTZ, 'f63273e2bd70de109a699dbc7358412bbf3d1a336dd1bdbd6389cb48860bcd13'::TEXT, ARRAY[2587]::BIGINT[]),
    (676::BIGINT, 'Prepárese para el desastre, no espere que las fechas que le dicen se cumplan, nunca entrega nada a tiempo y al final, sin observaciones reales y con talleres mal planeados, llegas al final y te dicen “por que no está perfecto?”. Se pasa, sí, pero a que costo?'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, '06a6768d8a6f21e01834e12de32b46274a56961cc67f6477206e884f32794ce2'::TEXT, ARRAY[2590]::BIGINT[]),
    (676::BIGINT, 'Que curso, aquí es adivine lo que la asistente quiere, porque la profe te da el visto bueno en las revisiones del proyecto y la asistente te baja todos los puntos. ASCO'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '826c2faf3830f6de56400d18e5045dfd93700fb19ab6abcb999f69aaf5d24822'::TEXT, ARRAY[2587]::BIGINT[]),
    (676::BIGINT, 'La profesora es demasiado desordenada, se le olvida las evaluaciones y pasa posponiéndolas a cada rato. Pero, esto no es lo peor, lo peor es que se le olvida también asignar evaluaciones, o sea que un día puedes entrar al TEC Digital y encontrarte con una tarea para mañana que dejó hoy.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2022-11-05T00:00:00+00:00'::TIMESTAMPTZ, 'af052629624f407300a4932c65215e2c800f58ee1e27e92b3253bb729b1e1e6d'::TEXT, ARRAY[2537]::BIGINT[]),
    (676::BIGINT, 'No entiendo cuál es el objetivo de este curso en la carrera. Ella piensa que el curso es de 4 créditos pese a que el consejo le dejó en claro que ahora es de 2 créditos. Demasiadas asignaciones.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-10-21T00:00:00+00:00'::TIMESTAMPTZ, '7b529f4d4a7423ca24de31b54cf76a30b9bbd4f5d891b39e93e82a33c08f73f8'::TEXT, ARRAY[2536]::BIGINT[]),
    (676::BIGINT, 'Es demasiado irresponsable, no entrega las evaluaciones y es súper aburrida, si tiene que llevar el curso prepárese porque no va a aprender'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos exámenes']::TEXT[], '2021-01-20T00:00:00+00:00'::TIMESTAMPTZ, '2225a504ad64a38b8adc0edbb14d06707efddd18932764da4b3c7466cecba07b'::TEXT, ARRAY[2536]::BIGINT[]),
    (676::BIGINT, 'Es muy buena gente y le preocupa que los estudiantes aprendan sin embargo para este curso no es la mejor profesora , prácticamente confunde este curso con ingeniería de requerimientos y no enseña nada de Z.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'fba486731e95adcdf77ddfa76233a277f8dc3e2a63e0474a679e189d16e105c4'::TEXT, ARRAY[2591]::BIGINT[]),
    (676::BIGINT, 'No se aprende tanto, es un poco desordenada. Llega tarde y da muy pocas lecciones. Se ausenta y no repone ni brinda material adicional. Buena gente.'::TEXT, 8.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2016-11-02T00:00:00+00:00'::TIMESTAMPTZ, 'dd0e300228a752cc191ec1897e64e762412f3fb8fb68a57c0759d3e8ddc2ade8'::TEXT, ARRAY[2537]::BIGINT[]),
    (676::BIGINT, 'Las tareas y examenes son muy diferentes a lo que se enseña en clases, por lo que al curso hay que ponerle. Sin embargo se interesa por el bienestar de los estudiantes'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, '2b2567f01035ed9c7ea68abd057ccfe8c99d8a3575964668248a322ea99157cf'::TEXT, ARRAY[2536]::BIGINT[]),
    (676::BIGINT, 'Buena profe, deja muchos trabajos pero pequeños y realizables.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-29T00:00:00+00:00'::TIMESTAMPTZ, 'c6ad6ed1bded751aee650753ebb0e9a80c4de8c3552cc91a77ee892b3e564acc'::TEXT, ARRAY[2545]::BIGINT[]),
    (676::BIGINT, 'Algunas veces se pierde en las clases, pero trata de que los estudiantes aprendan.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, '95b90fa0bf7eb4190c6d4b2d009bb04ef4d2e7d6d8d05ed83a88f9be98d36d3a'::TEXT, ARRAY[2508, 2520]::BIGINT[])
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
