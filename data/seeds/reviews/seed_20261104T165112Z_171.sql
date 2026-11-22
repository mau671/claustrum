-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=171
-- TEC-DATA-META years=2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.103341+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (171::BIGINT, 'Como profesora es muy agradable sus clases, ahora el curso como tal yo entre porque quería aprender a bailar si estas en las mismas, te lo recomiendo a medias porque la primera mitad fue full contempo medio aburrido la verdad lo bonito fue apartir de semana 7 u 8 ya comenzó ahí con bailes populares'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '0df247e636fd8fbfe117bb950881c3a64e90ff2eb66a783ae8ce6c0522d6ad3b'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'Es una clase muy relajante, la profe hace que la clase se ha un lugar seguro para el movimiento, si le interesa la danza, contempo super recomendado!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-09-19T00:00:00+00:00'::TIMESTAMPTZ, 'ad899efbe9e64844d1f3c008e390a1569902f9342dcc42905a1e3fe56f60e8a0'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'No vas aprender a bailar nada, es una pura loquera. Hay cursos más interesantes que este.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-01-31T00:00:00+00:00'::TIMESTAMPTZ, '13b13ee30ee6cefea9c63458756593b75cd7b2fb1e0313a76d79d41807a32096'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'Excelente profesora y persona. Las clases son para desconectar de todo el estrés de la semana. Es un lugar muy ameno para aprender acerca de danza y las capacidades de nuestro cuerpo. Si es importante aclarar que el curso con ella es más de danza que de baile popular.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Clases excelentes']::TEXT[], '2023-11-23T00:00:00+00:00'::TIMESTAMPTZ, '8cec245d92fab9aa9d55f843bf9fe17cf9c351fa82339a18721f68ca54e834fe'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'Es muy buena persona, pero si quiere aprender a bailar, no es el lugar. Las clases son muy relajantes y se disfruta mucho, pero se la van a pasar haciendo movimientos raros y arrastrándose por el piso del salón casi todo el semestre, si lo que quiere es saber bailar ritmos latinos aquí no es.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Brinda apoyo']::TEXT[], '2023-11-07T00:00:00+00:00'::TIMESTAMPTZ, '2284d816bd6aa46dc1601036a0887928f4481f1d9476ca83fbeebeab7c569417'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'Excelente docente y bailarina. Hace de la clase un lugar ameno y seguro para todos. Como persona es super empática y llena de mucha energía buena, trasmite paz en sus clases. Si tiene oportunidad de matricular danza con ella no lo dude'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'd43deab8b76332a384e88e8ee6d413f08c3e32fb0ceee6dc952a47df0ff0e487'::TEXT, ARRAY[500]::BIGINT[]),
    (171::BIGINT, 'La mejor profesora sin duda alguna. Hace de esta clase un verdadero espacio seguro para disfrutar y desestresarse, ella es súper carga. El proyecto final es una coreo de mínimo 3 min y durante el semestre se debe asistir a algunas obras en el Centro de las Artes para analizarlas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'e6420983065146908b2d892d6c15d84d6391a1d29f7e40bbb756ed2706cbf113'::TEXT, ARRAY[500]::BIGINT[])
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
