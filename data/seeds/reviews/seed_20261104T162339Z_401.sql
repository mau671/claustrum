-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=401
-- TEC-DATA-META years=2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.974832+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (401::BIGINT, 'Muy buen profe, hizo que el lab fuera un poco menos difícil que en semestres pasados. Eso sí es importante ya haber pasado sin el examen final, porque en este casi no se sacan puntos.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-12-17T00:00:00+00:00'::TIMESTAMPTZ, '0cffc37e952575c16af391785e86f35dea78f327bb3e48e04a04983a5f732683'::TEXT, ARRAY[3056]::BIGINT[]),
    (401::BIGINT, 'Pues más o menos. No es mal profesor y es respetuoso, sin embargo, es muy desorganizado a la hora de calificar las evaluaciones y se atrasa mucho, a tal nivel que un día antes de entrega de actas no había calificado quices que hicimos en semana 8. Solo si no está Mendoza.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, '73a5d8f4fdfb93c7ae195046e83793b1940e6adc786e27c004dffa7d745e6044'::TEXT, ARRAY[1301]::BIGINT[]),
    (401::BIGINT, 'Es muy buen profe, comprende a los estudiantes y siempre busca lo que mejor le sirva a todos, intenta q a todos les quede claro todo, lo único medio malo q tiene es que siempre anda como apurado y puede ser que ni responda correos, además que las clases pueden ser un poco aburrida pero hace lo puede'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-14T00:00:00+00:00'::TIMESTAMPTZ, '171c50b5c36f5f1d5f3cea3bcd30b5dc94263bc5899f9b1da9ac01f7bc5910eb'::TEXT, ARRAY[1290]::BIGINT[]),
    (401::BIGINT, 'El profe es pura vida , pero las clases son todas aburridas, además de que es muy desordenado con las fechas de las cosas. Hace un examen parcial y uno final , el curso es bastante pasable y conseguir un buen grupo de trabajo es esencial, ya que deja proyectos pesadillos.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, '247277eb150d608d1db5a491875d4f134bbad6bd4b2204aaa78de486e8b48fd7'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'El profe es muy bueno, pero le faltó un poco de organización con respecto a los tiempos. Es comprensivo con los reclamos de proyectos y siempre intenta ayudar. Es importante tener un buen grupo de trabajo.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra', 'Brinda apoyo', 'Muchos proyectos grupales']::TEXT[], '2023-01-11T00:00:00+00:00'::TIMESTAMPTZ, '83587f9f3eec3075039f4f8fd7261b7243171f9135f5809d1915cb8eaf9a85e1'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'Pues masomenos, siempre anda apurado y pasa en reuniones quien sabe de que. Sube presentaciones al tec digital como loco aunque no de tiempo de verlas. Redacta muy extraño los instructivos y cuesta entenderlos. Cuidense del asistente xq califica pésimo y tiene complejo de profesor (de los malos).'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-09T00:00:00+00:00'::TIMESTAMPTZ, '603cae06191aa8956f78c17628f163d1198b983326b501b4b0e85a0977ad2f56'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'El profe es buena gente, pero solo leyó presentaciones que ni eran de él. Es un curso muy pesado, se necesita un buen equipo de trabajo, el 50% de la nota son proyectos grupales. Califica justo y ayudó bastante al final. Las evaluaciones siempre chocaban con las de Comu'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2022-12-07T00:00:00+00:00'::TIMESTAMPTZ, '20238a074995553b5805b3d41b95180e57aa5c7739442e0a2f13cf2375abb9d0'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'Él sabe mucho, pero el curso es súper pesado, la verdad es poco amigable y solo lee presentaciones gigantes, no tiene tiempo para hacer sus propias presentaciones, el curso se pasa pero necesita un MUY BUEN equipo de trabajo.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-06T00:00:00+00:00'::TIMESTAMPTZ, '783f62ead8e8256ce5b92a2fa7260551923f5bd358fc855912a78cd24ed4f6ff'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'El profe realmente es excelente. Sabe muchísimo en la materia y usa buenas herramientas para que se entienda la materia. Un buen equipo de trabajo para los proyectos es indispensable. El profe califica justo, y se preocupa de que uno aprenda. Es súper comprensivo con los tiempos de entrega.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2022-12-03T00:00:00+00:00'::TIMESTAMPTZ, '46c3cdd00ac5b1c4d25916669df19aacd783330255fc44a7fd3617b603c4ee6a'::TEXT, ARRAY[1032]::BIGINT[]),
    (401::BIGINT, 'De los cursos más pesados de la carrera. Se llega con cero bases de digitales, de modo que es difícil entender tan siquiere qué le piden a uno. El profe es comprensivo y muy agradable. Califica duro, pero también brinda ayuda. Hay que ponerle mucho.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos proyectos grupales']::TEXT[], '2022-09-30T00:00:00+00:00'::TIMESTAMPTZ, '02f06ee83829f020c5c644a161a08ce220ac1683702d3969799b95f8d718fa2f'::TEXT, ARRAY[1301]::BIGINT[]),
    (401::BIGINT, 'Es buen profe, sabe mucho, quiere que uno aprenda, es un curso muy pesado.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2022-05-23T00:00:00+00:00'::TIMESTAMPTZ, '14de13a5fdf143a79f31f317901a244b6b075787897f013b7081964ad9a88307'::TEXT, ARRAY[1301]::BIGINT[]),
    (401::BIGINT, 'El curso resultó aburrido pero se pasa fácil. Deja proyectos muy largos, así que hay que hacerlos con tiempo.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Pocos exámenes', 'Brinda apoyo', 'Deja trabajos largos']::TEXT[], '2021-07-20T00:00:00+00:00'::TIMESTAMPTZ, '592b6a618531046dfbee4a446c13eceacf6a5363840e3e064413c84fbfeadd30'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'A veces se complican los trabajo y es bastante comprensivo al respecto. Para ser la primera vez que da el curso me parece excelente la verdad'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2021-07-17T00:00:00+00:00'::TIMESTAMPTZ, '0113acb1cea7eab941a92d2d1feaf69e9dd056d1c8f3ef11dddcce902993c07a'::TEXT, ARRAY[1301]::BIGINT[]),
    (401::BIGINT, 'Buen profesor, se nota que es muy preparado. La clase no llegaba con buenas bases del curso anterior, pero adaptó el curso para que se lograran comprender los contenidos de buena manera. Muy comprensivo en cuanto a tiempos de entrega y consultas. Se aprende mucho.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-15T00:00:00+00:00'::TIMESTAMPTZ, 'a3cd7636e86566042931b19732cef4b0330b5155a8ae5088564bdf3c1fc99e52'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'El profe sabe demasiado y es super buena gente. Realmente llego a salvar la parte de digitales de la carrera y el curso es muy interesante. Califica no tan rudo, nada mas hacer los proyectos con tiempo ya que pueden requerir mucho tiempo'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Muchos proyectos grupales']::TEXT[], '2021-06-29T00:00:00+00:00'::TIMESTAMPTZ, '04fb0173dfeaa828da87cf896c1b4cb2a31f123bc1747a7846f70e619d8d20b9'::TEXT, ARRAY[1313]::BIGINT[]),
    (401::BIGINT, 'Muy buen profe, muy preparado. Es muy considerado con los estudiantes, y si el proyecto es muy largo trata de dar más tiempo. Es bastante amable y casi siempre le aclara a uno todas las dudas'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-05-24T00:00:00+00:00'::TIMESTAMPTZ, '80e6829fb8062284549b96958ba10ee3693c46b58237d767cf626359a7671874'::TEXT, ARRAY[1301]::BIGINT[])
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
