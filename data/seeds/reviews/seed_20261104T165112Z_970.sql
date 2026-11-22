-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=970
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.008033+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (970::BIGINT, 'Asqueroso profesor, háganse un favor y no matriculen con él, el mae no sabe nada de la materia, presentaciones hechas con ia, exámenes hecho con ia, y la retroalimentación también la hace con ia.'::TEXT, 4.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-10-28T00:00:00+00:00'::TIMESTAMPTZ, '3210c8574a61b89d0fbd497ec503ee174e3d0d8c64eb455276dbabff4fc5d523'::TEXT, ARRAY[2366]::BIGINT[]),
    (970::BIGINT, 'Las tareas son normales aunque dependiendo de la tarea. Las clases son normales, lo que si le falta es completar ejercicios en la clase, porque no suele explicar mucho. Los exámenes son fatales, se para atrás y ve los monitores a ver quien copia y utiliza herramientas anti IA en sus examenes'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-10-28T00:00:00+00:00'::TIMESTAMPTZ, '85b623dc855a2959a6433201118823437390ceaa249f47eba21b1095b45b253e'::TEXT, ARRAY[2366]::BIGINT[]),
    (970::BIGINT, 'El profesor no explica muchos procedimientos, no hace clases prácticas de contabilidad, uno tiene que estudiar por afuera y estar adivinado que está haciendo. Los exámenes no son nada parecidos a las tareas o material que deje. Usa mucho la ia para realizar presentaciones y trabajos, pero resolverlo'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2026-10-28T00:00:00+00:00'::TIMESTAMPTZ, '35b1beedbb22d0c10cdd08b2a9718a46ac99df3aabdb227e65d50300e8a161ff'::TEXT, ARRAY[2366]::BIGINT[]),
    (970::BIGINT, 'Es un buen profe, con solo que ustes haga lo que deja en clase pasa el curso fácil. La asistencia es obligatoria, si usted faltó 3 veces lo va a quedar, no se fíe. Es desorganizado con el cronograma que deja, no lo cumple al 100. El proyecto que asigna es muy confuso. Clases super aburridas y largas'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas']::TEXT[], '2025-07-19T00:00:00+00:00'::TIMESTAMPTZ, '0c5559f786c9ea6318ffc4bbc0fd835f879b55e3e0b13f16319d27d328a08fb2'::TEXT, ARRAY[1206]::BIGINT[]),
    (970::BIGINT, 'Usted haga las tareas y fíjese en la retroalimentación que da. Revisa las tareas en clase y con solo hacerlas ya tiene los puntos, no vaya a copiarse con otro compa porque sí se da cuenta de eso. Hace los exámenes en grupo, siempre ayuda bastante y te explica de nuevo si no entendió. Lleve con él.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '106c5560dba8f5ab2f8b54e0574144b2cdf1b3f2ab1bcd018ead5fbb2e2dc8e0'::TEXT, ARRAY[1708]::BIGINT[]),
    (970::BIGINT, 'Es un excelente profesor, las clases son bastante entretenidas, solo que los estudiantes deben poner de su parte ya que si deja bastantes tareas, pero son súper sencillas.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Da crédito extra', 'Aspectos de calificación claros']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '0705abfdca8eb48a13e3d291b014a728aafe5b89d6ee6ed61efbef44c6aa23a2'::TEXT, ARRAY[1206]::BIGINT[]),
    (970::BIGINT, 'Este profe es muy buena gente, y de verdad quiere enseñar a sus estudiantes. Es un poco confuso a la hora de dar instrucciones, y a veces la forma en que redacta puede ser ambigua. No es difícil pero tampoco fácil. Lo recomiendo pero practiquen mucho.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-13T00:00:00+00:00'::TIMESTAMPTZ, 'b642554f658237d9d135bb61be3f1d02efffec7324cc147445e9283c753a4831'::TEXT, ARRAY[2394]::BIGINT[])
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
