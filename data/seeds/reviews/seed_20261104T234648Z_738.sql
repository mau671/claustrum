-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=738
-- TEC-DATA-META years=2018,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T23:46:48.128856+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (738::BIGINT, 'Los exámenes valen 30% y valen 30 pts, por ende si pierde un pto, pierde un 1% de la nota y eso perjudica a los estudiantes, sobre todo porque es muy estricta calificando desarrollo, usted pierde pts por no adivinar la precisión que ella esperaba. Fuera de eso es bella persona.'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Exámenes retadores']::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, '74810c6b7d0b94af4d83bc2cd3dd5eaf0525d070cd67d2a46f0c367812833471'::TEXT, ARRAY[3279]::BIGINT[]),
    (738::BIGINT, 'Como PERSONA es super dulce y linda, pero como PROFESORA solamente ella tiene razón. Es muy específica para calificar, pero uno le agarra el ritmo. Su forma de preguntar es muy diferente a como acostumbran los profes de la carrera, pero no es nada de mor!rs3, tampoco es como que va a perder el curso'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Clases largas']::TEXT[], '2025-01-17T00:00:00+00:00'::TIMESTAMPTZ, '7b793993ccbb873eb6534f5d5f90cc3b4362b566d00314e569ee9588dc0c7abe'::TEXT, ARRAY[3286]::BIGINT[]),
    (738::BIGINT, 'La señora, como persona, es un amor; sin embargo, como profesora, deja mucho que desear. Sus explicaciones son deficientes, y es muy exigente con los formatos. Aunque estos problemas pueden resolverse consultando a alguien más, en teoría, esa es su responsabilidad, y no está cumpliendo con ella.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Exámenes retadores', 'Muchos proyectos grupales']::TEXT[], '2024-11-20T00:00:00+00:00'::TIMESTAMPTZ, '797732df5664f2477edf2c275068fcef30f69a350004920e05fcdb7c25e29cd1'::TEXT, ARRAY[1979]::BIGINT[]),
    (738::BIGINT, 'Demasiado exigente para el curso que da, los examenes son cortos lo que es malo considerando el valor que tienen y pregunta cosas que no tienen sentido para la clase que es'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2024-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'a103f63a3e5a04582aaa72da202322ceea7d8380a600c03b2e6e207a26c84368'::TEXT, ARRAY[3286]::BIGINT[]),
    (738::BIGINT, 'Es muy linda persona, pero como profesora parece estar un poco perdida con respecto a lo que se enseña en el curso teorico. Exige mucho para el curso que es.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Clases largas']::TEXT[], '2024-10-24T00:00:00+00:00'::TIMESTAMPTZ, 'd1f8fee169b6c6dd72d07f2ae6a00ee5d841448bc60a3c0b6b11bc495102098b'::TEXT, ARRAY[3286]::BIGINT[]),
    (738::BIGINT, 'Demasiado extricta para dar un curso de un crédito, yo recomiendo matricular con otras Profesoras, buena persona pero mal profesora, pide cosas que otras no.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, '72a6da6361950b0338dd13a4d9be845ad3879886ff1c0ab77d9521cb4c0effa7'::TEXT, ARRAY[1979]::BIGINT[]),
    (738::BIGINT, 'Sobrevalorada,'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2018-11-05T00:00:00+00:00'::TIMESTAMPTZ, '6609895db6eed0a65d741fbf503472ef2027c1fb3951631e80ff5cde2b0f73c9'::TEXT, ARRAY[1979]::BIGINT[]),
    (738::BIGINT, 'Es una excelente profe, ayuda mucho, la metodología excelente, como persona increíble es una profe excepcional y las clases son muy entretenidas y se aprende demasiado, además hace muchos quices y tareas que al final ayudan mucho.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, '10b077e7b1b392b29d0e1152472e696053fc77d8b00d1b14c721700f194ac529'::TEXT, ARRAY[1979]::BIGINT[]),
    (738::BIGINT, 'No entiendo por qué la calificación está tan baja, la profe es un amor de persona, es súper atenta y siempre está dispuesta a ayudar ya que de verdad le interesa que sus estudiantes aprendan, califica suave, da puntos extra y vuelve el curso súper fácil y divertido, llévelo con ella, hágame caso.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'f26229676101bb7477035642200f879e51aedf5fb66dfba6666bad31712920fe'::TEXT, ARRAY[1979]::BIGINT[]),
    (738::BIGINT, 'Un amor de persona. Da muchos puntos extra por participación, responde todas las dudas que uno le pregunte, tanto de manera presencial como por correo. Lo único difícil son los quices, de ahí en fuera califica suave. No me arrepiento de llevar con ella :D'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Clases excelentes']::TEXT[], '2018-06-13T00:00:00+00:00'::TIMESTAMPTZ, '620c53efbd2e5c3280aaa3efe889e430c3cd33cc63e6ac203eb14f8ab280ecf8'::TEXT, ARRAY[1979]::BIGINT[])
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
