-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=356
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.172868+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (356::BIGINT, 'El profe es buena nota, califica suave en el examen, en las demás evaluaciones si es un poco más estricto, lean bien las reglas del proyecto y aclaren dudas desde el principio, sigan las reglas que pone y todo les saldrá bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Asistencia obligatoria']::TEXT[], '2026-06-21T00:00:00+00:00'::TIMESTAMPTZ, '57bcdd96ba2f19beb36a019b31f2f0709ccaa9a6ea735cde05213d187e2e163e'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Profe buena gente pero fuerte cuando califica, tuvimos algunos problemas con un compañero del grupo del proyecto pero al final se sacó, de lo mejor que tiene la escuela.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-18T00:00:00+00:00'::TIMESTAMPTZ, '8847a1046dd252977c7cce0c008229cea55090f3e9505364610941672bd0f599'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'buen profe, ayuda mucho pero es bastante estricto y estructurado en los trabajhos del curso. con tener un buen grupo y practicar se pasa.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'fa1227d96e4d0d4d9fea7eb8a0328db2ba44ef78102335006394ed86d16421bb'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Estricto como ningún otro profesor, pero se aprende y tiene vocación por enseñar. Muy buen profesor y profesional'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación']::TEXT[], '2025-12-01T00:00:00+00:00'::TIMESTAMPTZ, '81f26fda1ae9e3bcc6dc5b2f1f890ebe798599efff873d920b760a2d929501e7'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'El profesor es muy estructurado con sus evaluaciones. Tiene que apender Robot porque sino lo suena en el examen, obviamente el profesor le da herramientas para practicar y aprender de la herramienta. Hagase con un buen grupo y es muy llevadero.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2025-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'a981639f4a2db4a1f389ccd718f014837c3306db6249321ca1b4c0d644cd1063'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'un buen profe con mucha vocación por lo que hace. Lo ayuda y guía a uno en lo que puede, aunque si uno se descuida lo hace sonado en algún avance del proyecto o el examen.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'a2affac2c43eb3c9cf0e6fc91f9a82fd8d0213700b002c06d506106db309832d'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Curso que si tiene un buen grupo de proyecto se vuelve llevadero, bastante estricto pero tiende mucho a ayudar y atender consultas, recomendado.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-13T00:00:00+00:00'::TIMESTAMPTZ, '81746215640d0f3fe68e039a9f8e8794b600ce486c01164fc43b9b43c9c07118'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Un profe estricto en las calificaciones..pero con muchas ganas por ayudar en el aprendizaje de una como estudiante…si tiene un buen grupo para el proyecto se hace un curso llevadero.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-19T00:00:00+00:00'::TIMESTAMPTZ, '42d45a04576b3ed813572e6099d147f6702ddb4d36a0f9014923015567876940'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Buen Profe , muy estricto con la calificación de las entregas pero tiene mucha apertura a ayudar a los estudiantes en consultas, es un curso mayormente práctico.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2024-06-13T00:00:00+00:00'::TIMESTAMPTZ, '77c84a549f3ce30c5a34c59621b2731c9bb2fdc9224ed6596d28aade15814ccf'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'No se aprende mucho lo teórico, pero en lo práctico es bastante bueno, las clases se hacen medio pesadas. Es demasiado estricto con los trabajos, califica duro y hay que tener un buen grupo para el proyecto'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2024-06-05T00:00:00+00:00'::TIMESTAMPTZ, '6658669a883b251ecee303dc6c45ec72c7d2eee175ea2c06cabed84c72c49576'::TEXT, ARRAY[1202]::BIGINT[]),
    (356::BIGINT, 'Buen profe. No es como que se aprende demasiado de aspectos teóricos, pero sí se aprende a usar lo necesario de ROBOT que es un software de modelación estructural. Elija un buen grupo para el proyecto porque sí es algo complicado y largo. Es un curso realmente sencillo, así que no se preocupe.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-04T00:00:00+00:00'::TIMESTAMPTZ, '5ced9c585f898f4d5a7447d1dfbc8a551c4820ceb3d4e6a49222ac7d12f9f57f'::TEXT, ARRAY[1202]::BIGINT[])
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
