-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=79
-- TEC-DATA-META years=2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T09:31:51.763767+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (79::BIGINT, 'Una lastima que ningun@ otr@ profe de el curso, es practicamente imposible mantenerse despierto en las clases de teoría, asigna trabajos y proyectos super largos y pesados, los examenes de lab son incomprensibles. Muy mala experiencia con el curso y no aprendí casi nada.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2026-07-08T00:00:00+00:00'::TIMESTAMPTZ, '08fedcb0adb361f61cf107c33abb9155bb73198d8e8f3de7102a9d26eabd3097'::TEXT, ARRAY[1975, 1976]::BIGINT[]),
    (79::BIGINT, 'La profe es un poco grosera y sus clases no son las mejores. Explica muy rápido y no te deja interrumpir si hay alguna pregunta durante la clase. Si uno ocupa ayuda con los cortes hay que rogarle mucho para que le ayude. El proyecto final hay que empezarlo apenas lo asigne porque es muy pesado!'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2026-02-04T00:00:00+00:00'::TIMESTAMPTZ, '328fc0326f942be7cb8189f4ee422d923111274b70e7bebd4fe41c35e1a47661'::TEXT, ARRAY[3262]::BIGINT[]),
    (79::BIGINT, 'Es increíble lo mala docente que es. Muy grosera y apática con sus estudiantes Los exámenes son incomprensibles, pregunta cosas sumamente específicas. Se enreda un montón, es imposible entenderle y mantener mas de 30 minutos de atención. No matriculen con ella. 0/10'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores']::TEXT[], '2025-09-27T00:00:00+00:00'::TIMESTAMPTZ, '80e1e1dfaba59745f2697d3d1200c69219a14521ac41f6492a57e765ee125df3'::TEXT, ARRAY[1977]::BIGINT[]),
    (79::BIGINT, 'Hágase un favor y no matricule con ella, creo que es la peor profesora que he tenido, no aprendí casi nada. Es una profesora muy desordenada y sin tacto con los estudiantes (ni digo más porque me enseñaron a quedarme en silencio si no tengo nada bueno que decir)'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2023-12-25T00:00:00+00:00'::TIMESTAMPTZ, 'c2766ae0ac962fc70e5d4b5a4143ecb32c616287f710726fff7e65214d7a7f9e'::TEXT, ARRAY[3270]::BIGINT[]),
    (79::BIGINT, 'Pésima profesora. Casi que no explica, la mayor parte de la materia fueron presentaciones por nosotros. Las instrucciones de los trabajos son cero claras y le gusta bajar puntos por bajar, aunque ya haya dado su visto bueno. Demasiado desordenada'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'b4addb83b5cefbf2ac46ec120a4c1889fd60c01bbc76d3553f6644c4a45893d3'::TEXT, ARRAY[3270]::BIGINT[]),
    (79::BIGINT, 'Está bien. Las clases pueden ser pesadas, pero así es la biología. Ayuda mucho al estudiante, si se aplica una cuota de esfuerzo, se pasa el curso.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2023-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'eca67e6737ceb5b534a9ded6c8d4f2d0727ca85d6c6638d51248810425d317a0'::TEXT, ARRAY[1976, 1975]::BIGINT[]),
    (79::BIGINT, 'El que no pasa es porque de verdad no se esforzó ni un poquito'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-21T00:00:00+00:00'::TIMESTAMPTZ, '0e7067957e398e178c84937532418ca6ec4cf059a6d6ab29dd463c672b7360b1'::TEXT, ARRAY[1977]::BIGINT[]),
    (79::BIGINT, 'Trabajos muy extensos'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2021-08-24T00:00:00+00:00'::TIMESTAMPTZ, 'd2cb67c1ed74f44c33362dd225051db8b7e0c7657aa7d38da777f224616fe1d4'::TEXT, ARRAY[3270]::BIGINT[])
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
