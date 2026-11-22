-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=325
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.130632+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (325::BIGINT, 'El profe Herson es sin duda la mejor opcion para un curso de ciberseguridad, le recomiendo que ademas vaya a las actividades del Hackatorio que el realiza. Lo unico malo son los quices semanales que el profe hace vague posting y no dice exactamente que entra en ellos, ponga atencion en las clases.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Clases excelentes']::TEXT[], '2026-08-14T00:00:00+00:00'::TIMESTAMPTZ, '47037ea7a24cdc6aac7ad2433303377f8fdab2bb22c84fd50c9daf6b9acf6867'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'Posiblemente lo mejor que tenga la escuela de computacion, muy calificado en su area y con demasiado conocimiento, su curso es muy importante para la carrera y lo da de una muy buena manera. Ayuda mucho a los estudiantes que demuestran interes en lo que enseña'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2026-06-11T00:00:00+00:00'::TIMESTAMPTZ, '5022c528671a1ab8ef64cab484625388dbec9baa9559c2789a02b018306379ba'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'Tomé la materia por levantamiento de requisitos estando en 3er semestre y todo lo explicaba tan claro y simple que no hubo ningún problema. 3 proyectos (1ez, 2largo/medio complicado, 3meh), varios quices fáciles y 1 examen simple . Con poner atención en clase y una repasada se pasa el examen ez.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2025-07-31T00:00:00+00:00'::TIMESTAMPTZ, '2d3865ab721124f36da60db40cf4a1b4fb0b7c1f9355a8be61f4eb2f464f342b'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'El curso es muy rudo para valer tres créditos. Ven NASM. Ocupan máquinas virtuales. Hacen examen al final pesadito y quizes suaves semanales. Tiene que ir bien al día con la materia. Son tres proyectos, el primero es fácil, el segundo difícil y el tercero masomenos. Tiene que invertir mucho tiempo.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2024-12-06T00:00:00+00:00'::TIMESTAMPTZ, 'cc53b2bb35493851c9eaa2e9b52c987ac92f6f07e0d5ac1f8066c8899602a0b6'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'El curso es pesado, hay quices todas las semanas pero califica suave. Los proyectos son bastantes difíciles en especial el 3° y el profe no ayuda aunque sepa que todo el grupo le va ir mal no lo hará.'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-06-28T00:00:00+00:00'::TIMESTAMPTZ, '1f2d3fd4b4d4281accbcdbcfca4c6cfb0a83039e5580374d112ac1dd902ad506'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'El profe es tuanis pero el curso es dificíl. En el tercer proyecto fuimos 2 veces a consulta y no sirvió de nada. Si le interesa el tema, el curso está tuanis pero si ocupa una electiva yo no lo recomendaría, si es parte de su plan ( 2020 ) pues salado. En quices ( semanales) califica suave.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2024-06-10T00:00:00+00:00'::TIMESTAMPTZ, '94602a7d77ff6223498b510aec8bb5cc1b2f7e321652ccf2d9f4609eb00981b2'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'Muy buen profe, explica super bien, el curso se nota que está muy bien planeado, se aprende un montón. Más pesado que otras electivas, pero nada exagerado. La clase no es obligatoria y aún así asistí a todas aunque viva en SJ. Quices todas las semanas, pero son fáciles, lo ayuda para el examen final'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-14T00:00:00+00:00'::TIMESTAMPTZ, '97cb8109ab0c6badcf94974de266defef0c9a9ca328acbaf0e5278d77820e691'::TEXT, ARRAY[1158]::BIGINT[]),
    (325::BIGINT, 'Un 10 de Profesor, ahora que seguridad del Software será materia obligatoria en el nuevo plan de estudios, asegúrense de llevar el curso con él. El mejor profesor que he tenido en la carrera y temas muy interesantes, lo recomendaría con los ojos cerrados.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'f5a355cebd29e8f28be85aaa496ef3d502904b2d015082f2585d9d85ab261f00'::TEXT, ARRAY[1158]::BIGINT[])
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
