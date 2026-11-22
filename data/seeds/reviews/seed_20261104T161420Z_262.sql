-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=262
-- TEC-DATA-META years=2019,2020,2021,2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:14:20.022415+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (262::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2025-12-09T00:00:00+00:00'::TIMESTAMPTZ, '1c92cde5023056aafbfa62dca5afbff388a807860caadec3f1490822647d43cb'::TEXT, ARRAY[1159]::BIGINT[]),
    (262::BIGINT, 'El profe es buena nota, sin embargo, no explica muy bien como funcionan las cosas. El videojuego se realiza en roblox y el lenguaje es muy sencillo de aprender. Si tiene un buen grupo de trabajo pasa sobrado.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2025-02-05T00:00:00+00:00'::TIMESTAMPTZ, '1544fb2ce911d58c0d74ff7cb97066c2433c7571f8b96f019baeb9a00b4303c8'::TEXT, ARRAY[1139]::BIGINT[]),
    (262::BIGINT, 'Su manera evaluación es diferente de lo común, el mae no es de tareas o de trabajos que ocupen documentar. Solo se hace un proyecto, y se trabajan en grupos. Busque un buen grupo, ya que el profesor no es bueno explicando las funcionalidades que tiene roblox, y al ser verano se tiene poco tiempo.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clase fácil', 'Muy cómico', 'Da buena retroalimentación']::TEXT[], '2025-02-04T00:00:00+00:00'::TIMESTAMPTZ, 'ecab80334e13ce582ea4c8222af7d2bf2be3b39af79a7c3bde2ed54c9aa037b5'::TEXT, ARRAY[1139]::BIGINT[]),
    (262::BIGINT, 'Arma grupos desde el inicio del semestre y le importa que todos trabajen. Con no dejar las cosas para el final se saca el curso facilito. Además el proyecto lo asignó luego de haberlo hecho él mismo, y nos ayudaba un montón.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2022-01-31T00:00:00+00:00'::TIMESTAMPTZ, '975b47def5094cc7dafd4ded82cc9c4b88f4a64fbd725aedf7d850e0c8dfea6a'::TEXT, ARRAY[1045]::BIGINT[]),
    (262::BIGINT, 'El curso me asombró bastante pues hicimos videojuegos bastante buenos a pesar de hacerlos en la plataforma Roblox'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2022-01-27T00:00:00+00:00'::TIMESTAMPTZ, '0e63466166c7df86ae04edc6672dc9a95c8254ec449f0735c1dc2ec0dd24cb08'::TEXT, ARRAY[1430]::BIGINT[]),
    (262::BIGINT, 'Buen profe, crea grupos desde el primer dia y asigna los proyectos luego no hay clase como tal si no son reuniones donde se comparte que se hizo durante la semana. Si usted le pone a aprender, hacer tareas y realizar trabajo del proyecto le va a ir super bien. Buena nota 100%.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2021-12-02T00:00:00+00:00'::TIMESTAMPTZ, '7056e8725b176ddaaec36d00516f562dba1cd1b5ae45ef6e5ca4675b11150add'::TEXT, ARRAY[1165]::BIGINT[]),
    (262::BIGINT, 'Buenas clases, buena explicacion, buen profe'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2020-12-05T00:00:00+00:00'::TIMESTAMPTZ, '284189a834064aa2d3a6d326a4221e0bd0984041ea3f80de78ef2fc0c435e280'::TEXT, ARRAY[1029]::BIGINT[]),
    (262::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Tomaría su clase nuevamente']::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, '0fa79d8afb1fe61836e977ebb1d03632edad15e96c344ac1c540f92ec76454ad'::TEXT, ARRAY[1017]::BIGINT[]),
    (262::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Asistencia obligatoria']::TEXT[], '2020-01-25T00:00:00+00:00'::TIMESTAMPTZ, 'bd26e7b1e7cd9fda17fd835fbbf8bf6f3c1b216f1eeb7f53ac7c7e735248005c'::TEXT, ARRAY[2918]::BIGINT[]),
    (262::BIGINT, 'Excelente profesor'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Exámenes retadores', 'Tomaría su clase nuevamente']::TEXT[], '2019-12-12T00:00:00+00:00'::TIMESTAMPTZ, '573aa6773649a99427860c3d4d2fb1d2187bf01ae78940561a7f3520bfbd0be1'::TEXT, ARRAY[1029]::BIGINT[]),
    (262::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2019-09-19T00:00:00+00:00'::TIMESTAMPTZ, '5f3ed3cbc76a90943759950a82a2f87273a6b2071c194e93c7d361da78ddcf20'::TEXT, ARRAY[1249]::BIGINT[])
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
