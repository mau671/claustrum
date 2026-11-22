-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1114
-- TEC-DATA-META years=2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:46:48.130566+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1114::BIGINT, 'Es el mejor profe que he tenido de Contabilidad aqui en el TEC. Explica muy claro, es muy ordenado, brinda machotes, tiene paciencia, sus examenes no son dificiles e incluso algunos los hace virtuales, tiene mucha experiencia profesional y de verdad quiere enseñar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-10-28T00:00:00+00:00'::TIMESTAMPTZ, 'f5dc78e73bdfa9d8dff45c1209bb068eb0c355e93f62eb625af4f1dd8db08556'::TEXT, ARRAY[2366]::BIGINT[]),
    (1114::BIGINT, 'Sin duda uno de los mejores profes que he tenido hasta el momento. Siempre está para ayudar, es atento y busca que entiendas bien la materia. Los exámenes son sencillos y claros, las tareas y las actividades en clases ayudan un montón. Lo recomiendo montones'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-11-27T00:00:00+00:00'::TIMESTAMPTZ, '535e937a76bd1e6140d9a61f0967ebb45fdd9137af96bf91477cdb8321e62e2c'::TEXT, ARRAY[2366]::BIGINT[]),
    (1114::BIGINT, 'DEMASIADO bueno. Va uno por uno a explicarles en clase lo que no entendieron. Hace algunas clases virtuales y bien hechas. Las tareas y prácticas muy relax. Hace 3 exámenes que se pasan fácil. Se ajusta a lo que quieren los estudiantes. Las respuestas de las tareas y exámenes las da en PDF, no Excel'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '9cd0174fbf40b696c48732797662b2212385b084a7794388d4cb78965f79a0f3'::TEXT, ARRAY[2361]::BIGINT[]),
    (1114::BIGINT, 'El profe se devuelve a explicar todas las veces que el estudiante se lo pida aparte que para realizar las tareas da mucho apoyoy realiza varios examenes virtuales.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-10T00:00:00+00:00'::TIMESTAMPTZ, 'b862bff54ce718ebd16830429fb5bea86383e17d0b87b20dd20bdae1c40d40e7'::TEXT, ARRAY[1708]::BIGINT[]),
    (1114::BIGINT, 'Tanto un excelente docente como persona. Hace los exámenes virtuales. Los trabajos en clase son evaluados al igual que las tareas que se dan todas las semanas. Super buena nota y ayuda un montón. Siempre dispoible y genuinamente se preocupa por el bienestar y educación de sus estudiantes.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Inspirador']::TEXT[], '2024-01-12T00:00:00+00:00'::TIMESTAMPTZ, '563fd91956cb26e8324a50edeee7b514e4d799a480698509cfd7067ab90b0c93'::TEXT, ARRAY[2366]::BIGINT[])
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
