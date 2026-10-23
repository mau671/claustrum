BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (311::BIGINT, 'Mi opinión cambió, el profe es pésimo enseñando pero ayuda mucho, hagan todos los pts extra posibles y pasan'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, '85'::TEXT, NULL::SMALLINT, ARRAY['Muy cómico', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2023-06-08T00:00:00+00:00'::TIMESTAMPTZ, 'aaa2a4ac46439134a1b326df368af4fbe68016abbf397b7a67973d629b07a632'::TEXT, ARRAY[1032]::BIGINT[]),
    (311::BIGINT, 'Tengo un dilema con Kirstein. Me parece un buen profesor, se nota que sabe bastante y quiere que sus estudiantes aprendan, pero me parece que su planeamiento es erróneo, es como si fuera un curso de 6 meses para 4 meses de lecciones. Si no quiere sufrir, le recomiendo otro profe.'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULL::TEXT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2022-12-08T00:00:00+00:00'::TIMESTAMPTZ, 'b81254752bbbfa1b97f5ed3fa9037eeb992da5e71c063a67ae09fa8956a98efa'::TEXT, ARRAY[1032]::BIGINT[]),
    (311::BIGINT, 'Si el profe lleva el semestre organizado tampoco es un curso imposible. Deja varias lecturas por semana (4 - 5 Max) y una tarea programada en ensamblador con TASM por semana aprox. Si lleva muchos cursos se le va a hacer pesado, por lo que, tomelo en consideracion.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULL::TEXT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2020-11-23T00:00:00+00:00'::TIMESTAMPTZ, '80b0f6f31b2a56b50b99034b205d1972c590ada477c2e45e8bf596b22d6e855a'::TEXT, ARRAY[1032]::BIGINT[]),
    (311::BIGINT, 'Tiene un tono pesado, abrumador y tiende a enojarse e incluso ser condescendiente con los estudiantes. Deja algo que el llama "Resúmenes" minimo 4 semanales, mas tareas y exámenes que duran 2 días. Completando hasta 130 resúmenes en el semestre, y baja puntos hasta por el nombre de los archivos.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, '80'::TEXT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2022-05-03T00:00:00+00:00'::TIMESTAMPTZ, 'bb1d7f49831da0ffc1c98a219eb6315b4ee473da7a581d1eea0d0dcec3e745d1'::TEXT, ARRAY[1017]::BIGINT[])
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
