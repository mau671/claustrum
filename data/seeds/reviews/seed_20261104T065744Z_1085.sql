-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1085
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T06:57:44.681567+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1085::BIGINT, 'Le pregunté 3 cosas en todo el semestre y no me quiso responder ninguna. Aún así prefiero el estilo que tiene de enseñar la materia que otras profesoras, en clase es tuanis en realidad si el grupo es participativo. El curso es normal si es de Meca, si es de Física sufre el doble.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-01-15T00:00:00+00:00'::TIMESTAMPTZ, '9fc821e1c4c2267b8ad3864b2991ae57b566809942db27a26126a07a3d051d80'::TEXT, ARRAY[3064]::BIGINT[]),
    (1085::BIGINT, 'No esta bien que solo vengan para comentarios malos. Excelente trabajo.'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Exámenes retadores']::TEXT[], '2025-10-02T00:00:00+00:00'::TIMESTAMPTZ, 'bd7a677aa73e20555a59dcb63e05ce4c39ecf218db324e9c9362d33122cb18a9'::TEXT, ARRAY[3064]::BIGINT[]),
    (1085::BIGINT, 'La profe ayuda mucho si uno va a las clases. Las clases me gustaron mucho, se hacían muchos ejemplos y siempre respondía todas las dudas. Si no sabía alguna la investigaba y respondía en la siguiente clase. Da varias clases asincrónicas'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Brinda apoyo']::TEXT[], '2025-07-28T00:00:00+00:00'::TIMESTAMPTZ, '6ad1c813654f4f18693eaf0fb06e6746963e310a3fb8f9877b4e10108c8d3faa'::TEXT, ARRAY[3064]::BIGINT[]),
    (1085::BIGINT, 'Yo lo llevé el año pasado cuando no había exámenes sino quices. Pudo haber preparado mejor el cronograma; hubo muchos cambios de último minuto que molestaron a muchos compañeros (ninguno grave), pero en medio de todo eso, en lo personal, me parece que sí cumplió como profe.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-21T00:00:00+00:00'::TIMESTAMPTZ, '8e086103ab1c8243e5b1d3fe9a2a68159ca2b462203ff44e9265b584ae304838'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Profe de Temu, parece que llega a r0bar el salario nada más, trabajo en clase improvisado, clases aburridas, evaluaciones extrañas y califica con el hígado. Es un curso de relleno donde a estas alturas ya la mayoría de la materia se ha visto en otros cursos y se vuelve repetitivo y tedioso.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Muchos proyectos grupales']::TEXT[], '2025-02-07T00:00:00+00:00'::TIMESTAMPTZ, 'f65fdd8b92e1d772fffe7f9fd1f23844bce03cf269f1dd102b61ffad1f4fde32'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Muy mala profesora, no sabe dar clases y no respeta al estudiantado, cree que el curso es el unico que existe.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-01-05T00:00:00+00:00'::TIMESTAMPTZ, '11ce037642a3f2302fb390d7d73cf59a772bbe4152c26a8a0ba562850f051297'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Dice textualmente que algunos temas no van a entrar y luego esos temas entran en los examenes, debería de ser coherente en lo que dice.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-01-05T00:00:00+00:00'::TIMESTAMPTZ, 'bdfe82286c06e1e6f56add870ade863f422c80ea236aae602db5c5928299fa96'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Es la peor profe de la carrera, no volveria a matricular nada con ella'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-01-05T00:00:00+00:00'::TIMESTAMPTZ, 'ebb1f732a1eb916fd4e8f5f0141d31ca4380f1b636ac92ca2cda450e93053611'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, '80% de la nota se calificaron en el proyecto grupal y el examen grupal, que más que un examen fue un proyecto mezclado con investigación y elaboración de técnicas digitales. Malas clases, no la recomiendo para nada.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2024-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'b2fd50078a6649217ae9242cd5800bc026e570e8321fa51e001d9a7072d18b96'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Los examenes toman mucho tiempo'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-11-16T00:00:00+00:00'::TIMESTAMPTZ, 'e55db61123255e311c0d7a0d4cd83a6c230cb687c999cc82b73c0af2c24ccb35'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Es de los peores profesores que he tenido, las clase muy mal planeadas, casi no se ve materia relevante, para cuando uno llega al examen, es la cosa mas gigante y lleno de cosas que no hemos visto durante el curso. No sirve como profesora, no explica, califica horrible. Eso de conexion con los estud'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2024-11-12T00:00:00+00:00'::TIMESTAMPTZ, '8b5736e67037f6546616ebf2e17ddbfbebe7eaf4e539baf1b60b0929f2bd69d4'::TEXT, ARRAY[3071]::BIGINT[]),
    (1085::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2024-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'c341770dcae80de76e7436ce8385afabcb65abb05f5729c2a77e5dc1f932202b'::TEXT, ARRAY[3071]::BIGINT[])
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
