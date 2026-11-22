-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=460
-- TEC-DATA-META years=2021,2022,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.244124+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (460::BIGINT, 'El profe se esfuerza porque a una le guste la materia y es muy amable.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, '8f913f3026219ec82313327c564bd626ad4079590fbf1b197640e8585613b34f'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-04T00:00:00+00:00'::TIMESTAMPTZ, '02480e61cd268dc804a274013ca47f7c70a5d4a2518a11739e4bf3c720172087'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'Él es un amor de profe, las clases las da súper claras y los exámenes son de lo que se ve en clases, los trabajos en grupo se hacen fácil y rápido y si se aprende con él. 100% recomendado, se pasa fácil y se aprende.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-19T00:00:00+00:00'::TIMESTAMPTZ, 'b84e7e602f35610c93a916700e324e4dd428ddae077a44fb09b95e5286e94d19'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'El profe es muy pura vida, las evaluaciones son en grupos y da mucho tiempo para realizarlas, no son complicadas y califica al suave. Uno sale certificado de SolidWorks.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-07T00:00:00+00:00'::TIMESTAMPTZ, '9c5d19c85aeadf5f98900b9946279d178bfe899959f1f641188780fbd9d7dc4b'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'El curso es muy fácil, hace varias clases virtuales y no pasa lista. Muchas tareas en grupo pero todas sencillas y el examen es fácil, sirve estudiar con cosas del semestre pasado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-06-25T00:00:00+00:00'::TIMESTAMPTZ, 'ca5776d2d74f838b2bd8c5234cc4aee8347933271e14bd763789e9ca03b26246'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'El profesor explica muy bien, a veces las clases son largas, pero el curso es sencillo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '42cf3e721f87eeb31fb91f31bc656cebe0403ebbb06eab838cf637107395dfc0'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'Es un curso de 4 créditos con un 100 regalado, las tareas son muy fáciles y el proyecto es muy poco trabajo para tantas personas. El profe es muy buena gente, pero no se aprende nada nuevo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Pocos exámenes', 'Brinda apoyo']::TEXT[], '2023-06-17T00:00:00+00:00'::TIMESTAMPTZ, '8004336077cda65fa140b216ed46614190500103e4cf7484e5211d6ef789fa07'::TEXT, ARRAY[3071]::BIGINT[]),
    (460::BIGINT, 'Para la cantidad de creditos y lo que uno espera, se aprende muy poco. Es muy facil, pocos trabajos, con hacerlos se pasa casi que con 90+, pero es muy buena gente y se nota que busca inspirar al estudiante, pero si deberia hacer el curso mas provechoso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2023-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'b74d65ea7de6245f6e32a0aaadfcaa48208e3074bc9666feb2d9a06914868d82'::TEXT, ARRAY[3071]::BIGINT[]),
    (460::BIGINT, 'Muy buen profe que hace una clase aburrida poco pesada. Además de que explica muy bien. Entregue todo y va a pasar con 90 o más.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Tomaría su clase nuevamente']::TEXT[], '2023-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'b43c5d3b96aab3666fc7bd7fc47546b539b26bcee14ce659012753fc892e8ace'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'Excelente profe, hace giras en el curso, se aprende bastante, lo recomiendo. Se pasa solo el curso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-12-06T00:00:00+00:00'::TIMESTAMPTZ, '7b364412d9498dc7b51eb9e9a6c5f6d64b4945826209862194b71833017c0a77'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'De lo mejor que tiene la escuela, un profesor super atento, responsable que se nota que se esfuerza por hacer la clase lo menos pesada posible. Ayuda muchísimo a los estudiantes en caso de que necesiten algo, 20/10'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-16T00:00:00+00:00'::TIMESTAMPTZ, '73130a4a428474b2641d06c61413e96c371a67945ee9bcd7d523089c7efcff08'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'Una bendición de profesor, de lo mejor que he visto en la carrera, es super preocupado por los estudiantes, comprensible, enseña bien, califica lo justo, Amé el curso con él, super recomendado. :)'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-15T00:00:00+00:00'::TIMESTAMPTZ, 'bead14ae65f8db04a4d734a43c4a6f327dc52c3fa84fdf88d1962d01e806a5da'::TEXT, ARRAY[1756]::BIGINT[]),
    (460::BIGINT, 'Excelente profesor!! Técnico y clases son muy dinámicas !! Excelente persona !'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Muchas tareas', 'Muchos proyectos grupales']::TEXT[], '2022-02-03T00:00:00+00:00'::TIMESTAMPTZ, '21d556f87de414a8b0963f7ecbfed9e04113c7127c3e478b3d265f5a4d27a47c'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'Excelente profe, ayuda demasiado si uno tiene dudas y explica las veces que sean con tal de que uno entienda. Da la materia de forma bastante dinámica.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2021-12-01T00:00:00+00:00'::TIMESTAMPTZ, 'da36c36e813e0834ac684f2495a54b3aaa2439e50adefb4dcf60f0c9b9d8423c'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'Un profe muy flexible, pero se debe cumplir con todo, ayuda bastante la materia que se ve es muy útil y es fácil porque explica con mucha paciencia y con ejemplos, si uno pierde una clase cuesta ponerse al hilo con la materia casi que cada clase se ve algo distinto. Ocupan buena compu por programas'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-10-08T00:00:00+00:00'::TIMESTAMPTZ, '390a9a5f442a0b92506cc7e0c7f7952fac0d689cb91159fb7879cf8188662c38'::TEXT, ARRAY[1795]::BIGINT[]),
    (460::BIGINT, 'súper práctico el curso, muy flexible, si no les urge esperen a poder llevarlo presencial para que puedan usar las máquinas del lab, no hay examenes'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-06-11T00:00:00+00:00'::TIMESTAMPTZ, '9273e0400e3d2531ef2213e2593ed309d1a5747d586daf690786230a677a14cc'::TEXT, ARRAY[1795]::BIGINT[])
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
