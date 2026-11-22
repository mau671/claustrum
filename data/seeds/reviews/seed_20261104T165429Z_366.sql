-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=366
-- TEC-DATA-META years=2018,2020,2021,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.179450+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (366::BIGINT, 'No da retroalimentación ni ayuda en consultas, sus clases son videos grabados de años anteriores con pésima calidad de sonido y apuntes ilegibles. Se enoja si los estudiantes consultan algo con respecto a las calificaciones. Por otro lado, el curso es fácil, interesante y se pasa solo'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2026-07-03T00:00:00+00:00'::TIMESTAMPTZ, '5834f01301fd37ccbd4ab22d40f48980d8fc9e3bf55c952cb60b2441236bb223'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Aunque el profesor tiene conocimiento en la materia por su perfil profesional, la dinámica de la clase afectó seriamente el aprendizaje. El curso se basó únicamente en videos con mala calidad de sonido y explicaciones confusas.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Pocos exámenes', 'Muchos proyectos grupales']::TEXT[], '2026-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'c4415e902f50a3f06b8781d2a5e290e34b0c5d64647d3230e65b1e37b7f1ef3d'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Malo este profe, no valia la pena ir, sin embargo la clase es obligatoria, es una tristeza que de suelos 2, los examenes son super raros, no se entienden, y no sabe explicar'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Clases largas']::TEXT[], '2025-08-20T00:00:00+00:00'::TIMESTAMPTZ, '5e5b29b7fe9d8a96bd60f8908d96a6b192dced466151a1df78a3f27a24166057'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Buen Profe, el curso es relativamente fácil, pero hay que asistir, si le piden que haga los examenes virtuales los hace así. No es tan pesado, pero si hay que tener cuidado'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Asistencia obligatoria']::TEXT[], '2025-07-17T00:00:00+00:00'::TIMESTAMPTZ, '312a45a5209b4b8b6f3a886e91381967c65cb0822a85b5fa321200a8dbf05ba4'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Se ve que sabe mucho, pero es un pésimo profesor. Tiene una letra imposible de entender y explica rarísimo. El curso realmente se pasa solo, vaya a clases, entregue todo porque los exámenes son virtuales y muy similares los ejercicios de clase.'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2024-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'd66287e1b8a2358c595091e79fc85b422e151cfb1db704fc11aac882f6b8eae9'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Clases larguísimas en las que solo se ve al mae resolver ejercicios que nadie entiende. Los examenes son virtuales y literalemente imposibles de responder en el tiempo que da. Es un vagazo para entregar notas y nunca se sabe como va uno en el curso hasta el último día.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2024-01-09T00:00:00+00:00'::TIMESTAMPTZ, '36c0cc3501ddabdf093e59283a28bd453519897ac22faa170314a1d77aa459f0'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'La mitad de las clases fueron videos de semestres pasados y eran muchos y muy largos, hace muchos ejercicios en clase pero no son muy claros. No hay de otra solo ese profe lo da.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2021-07-18T00:00:00+00:00'::TIMESTAMPTZ, '88dfaf749c34fe7e94e3c41408385c1c4809b6845a3583e8adcc45ef113a2ccc'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura']::TEXT[], '2020-09-01T00:00:00+00:00'::TIMESTAMPTZ, '0613a36442127661e9cdf2be04707d0d15ba6fd858f8045f5699e20015b9aef2'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, '[virt] Es un curso con mucha materia. Hay que llevar el curso al día si no se vuelve muy pesado. Es importante tener EXÁMENES VIEJOS, siempre son muy parecidos. El profe explica bien y aclara dudas, pero uno tiene que buscarlo'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Deja trabajos largos']::TEXT[], '2020-08-14T00:00:00+00:00'::TIMESTAMPTZ, '9c6a320f42fe7bffb9c48469157746c099d0c981bc0c70addd9b16c610574174'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Super aburrido, se aprende poco en clase ya que el profe se la pasa contando acerca de sus viajes, busquen compañeros para hacer plantillas de excel.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2018-11-21T00:00:00+00:00'::TIMESTAMPTZ, '48ea91bd9284aa1baf0de311204a21ee310d64eb9835e56643158b9efd72b878'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'Las clases son súper aburridas y el profe habla la mitad acerca de sus aventuras en USA o temas que no tienen relación al curso, la materia no es difícil, pero si requiere dedicación, siempre hay que hacer reclamos después de los exámenes, creo que el profe podría mejorar mucho el curso'::TEXT, 8.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-07T00:00:00+00:00'::TIMESTAMPTZ, '981dc5d1a45490eb5142e6e111b2e6e498fe193272350f1de7bb32ca88c2b811'::TEXT, ARRAY[1212]::BIGINT[]),
    (366::BIGINT, 'El curso por si solo es algo complicado, él profe explica bien y los procedimientos son bastante largos. Los examenes son de selleción única en compu en el tecdigital y nunca dan las respuestas, así que hay que hacer reclamos. Pero se aprende y es interesante'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases largas']::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'ea5d08188be98e8ce9f735ee225c878a1617cf25d0ba28b216f87944b7e97850'::TEXT, ARRAY[1212]::BIGINT[])
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
