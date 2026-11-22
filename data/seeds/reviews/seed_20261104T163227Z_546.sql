-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=546
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.019116+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (546::BIGINT, 'Es la mejor explicando, ella quien no le entienda ya es mucha la cosa, ella siempre dice que pregunten que no se queden con la duda y busca todas las maneras que entiendas. Ofrece ayuda puede ser algo sería pero es un amor solo pierdele el miedo??'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2026-05-15T00:00:00+00:00'::TIMESTAMPTZ, '338ce3085d243319a56b6d4b9a6dac0a3ee34e2b44817f8ded329cea9a5abfd6'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'La mejor profe, califica duro, lo importante de las clases con ella es la participación, pero vale la pena, porque es de poner mucha atención en clase, donde se pueden aprender muchas cosas, si usted es una persona vaga o que no quiere aprender matricule con otro. Explica excelente.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Respetado por los estudiantes']::TEXT[], '2026-03-17T00:00:00+00:00'::TIMESTAMPTZ, 'b85d38d09200ff49c2bc8ad44dde48b6be6dbd50828f023668fc608d157b43e7'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'Es una profesora muy aburrida y a la hora de explicar solo lee las presentaciones y lo confunde a uno, lo único bueno es que algunos quizzes permite que se realicen en parejas.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-06-24T00:00:00+00:00'::TIMESTAMPTZ, '092976ff2a53389a88f590e3b1bf788f15532e8ff5f4614585293442d720aedd'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'siento que califica muy fuerte. si le cuesta demasiado quimica no lo recomiendo. es buena explicando pero hay mejores si se le dificulta mucho'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Exámenes retadores']::TEXT[], '2025-06-04T00:00:00+00:00'::TIMESTAMPTZ, 'ca659fdbc29c8b5b7f3f6a6d449d2b11688805e68ca29b458febf3f411ab2b41'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-14T00:00:00+00:00'::TIMESTAMPTZ, '2f7804a109f72ebcf2413e91eb5e388f7ee042f2afaf3a6e266adc16545be632'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'Pasa las diapositivas como si fueran historias de Instagram, no da tiempo de agarrar ni el lápiz, se equivoca haciendo ejercicios y entonces pasa a otro ejercicio y uno queda jetiando.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-05-08T00:00:00+00:00'::TIMESTAMPTZ, '65bea71aadadbed17ebdeecaa11dcd8152d1798f8ff3c3b5b305742b0288304a'::TEXT, ARRAY[568]::BIGINT[]),
    (546::BIGINT, 'Muy buena profe, explica claro y si uno tiene dudas las aclara al momento y reitera en ellas si se sigue con la duda hasta que uno entienda, también da apoyo convirtiendo trabajos como exámenes cortos en tareas, para así poder tener mejor puntaje, muy buena persona 10/10'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2025-04-01T00:00:00+00:00'::TIMESTAMPTZ, '2cf24c2e0e3b628f8bd15429912a3f9fe539cef5259dd327de04bdd2646e0353'::TEXT, ARRAY[568, 567]::BIGINT[]),
    (546::BIGINT, 'Solo se dedica a hacer ppt y leerlos en la clase. Le baja puntos hasta por respirar en las evaluaciones y explica bastante vago sin dar mucho material de apoyo. No volvería a matricular con ella.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Exámenes retadores']::TEXT[], '2024-11-07T00:00:00+00:00'::TIMESTAMPTZ, 'b7f62d076bb872d25d116ede7b00af12b017a44cbf7f5b271b51428446fb5954'::TEXT, ARRAY[568]::BIGINT[])
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
