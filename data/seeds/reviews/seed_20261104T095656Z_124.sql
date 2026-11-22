-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=124
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:56:56.107205+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (124::BIGINT, 'No matriculen con ella. Muy desorganizada, hace el curso muy pesado para ser dos créditos, no explica nada y la retroalimentación que se necesita la da el mismo dia de la entrega.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2026-11-02T00:00:00+00:00'::TIMESTAMPTZ, 'aa00f911b401636543fbed51eb1fbd5ba8e907ad60a7a67d147d7a13fcba1a18'::TEXT, ARRAY[2460]::BIGINT[]),
    (124::BIGINT, 'Muy buena profesora, se ve que le interesan los temas que desarrolla. Los trabajos son grupales, pero si tiene buen grupo, se pasa fácil. Al ser virtual y verano se pueden sentir la clases muy largas'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2025-01-30T00:00:00+00:00'::TIMESTAMPTZ, '98a6ef5e727b0b0794c482477c572e3026d88c00ac8a712b565e674edb065f59'::TEXT, ARRAY[2460]::BIGINT[]),
    (124::BIGINT, 'En materias no puedo decir que tal, pero en CFH sí, la verdad se me hizo muy interesante sus actividades. A pesar de ser cansado (curso intensivo), ella hizo que fuera de mucho interés la temática (femenismo). Si no tiene tiempo y desea sacar los CHF rápido le recomiendo con ella.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2024-05-07T00:00:00+00:00'::TIMESTAMPTZ, '27cea909ddcbb938b92a91dc4f120d55b1c61f5fff1ed2e685f1abb2816a83e0'::TEXT, ARRAY[648]::BIGINT[]),
    (124::BIGINT, 'Sus clases un poco aburridas y largas. Manda lecturas obligatorias en las cuales se basa para hacer los exámenes. Si no se leen las lecturas y no se toman anotaciones de lo que se habla en la clase, no se logran hacer los exámenes porque pide citas textuales en cada pregunta que uno responda.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2024-02-02T00:00:00+00:00'::TIMESTAMPTZ, 'c1c3140910afc179583f161d0ca576b9a481894bf5581767a12bfcb31650ed52'::TEXT, ARRAY[559]::BIGINT[]),
    (124::BIGINT, 'La profesora es muy problemática, sus instrucciones son confusas y califica de manera arbitraria, esperando que hagamos los trabajos de una manera que ni siquiera ella comprende. Se burla y menosprecia a quienes le hacen reclamos sobre sus calificaciones injustas.'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa']::TEXT[], '2023-09-26T00:00:00+00:00'::TIMESTAMPTZ, '1de774bdb35d32f3789db827d864170df249aa6c2d43a4735bcc7cceb36c01d5'::TEXT, ARRAY[2460]::BIGINT[])
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
