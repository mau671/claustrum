BEGIN;

SET LOCAL search_path = public;

ALTER TABLE public.professor_review ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.professor_review_course ENABLE ROW LEVEL SECURITY;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1055::BIGINT, 'Excelente profesor, legalmente se preocupa porque todo el grupo este la mismo nivel y que entiendan bien los temas, hace varios ejemplos y da bastante práctica para que se diviertan un poco.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULL::TEXT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2019-05-10T00:00:00+00:00'::TIMESTAMPTZ, '7705dd62b2833b6ccc4bb770719e8f0a48891f45b3ce995ca508a58eb9a30c42'::TEXT, ARRAY[1684, 1686]::BIGINT[]),
    (1055::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULL::TEXT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-04-03T00:00:00+00:00'::TIMESTAMPTZ, 'bffe623b3f2986f6cfaaa71b77e67fcb0cb617cd5b3d55c182a360d49592a238'::TEXT, ARRAY[1684, 1686]::BIGINT[]),
    (1055::BIGINT, 'El mejor profe que pueda existir, simplemente es excelente! Si tiene la oportunidad de meter el curso con él, no lo dude!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, '85'::TEXT, NULL::SMALLINT, ARRAY['Muy cómico', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2017-02-02T00:00:00+00:00'::TIMESTAMPTZ, '64f7df946c4a6b53f06181ae5859678b9152961f9aa71875883ac7abfbfc1d5c'::TEXT, ARRAY[260, 2439]::BIGINT[]),
    (1055::BIGINT, 'Es bastante relajado, hace pocos quices y tareas (si revisa las tareas). Aveces se enreda un poco explicando pero por lo general todo bien. Como persona es muy pura vida y se interesa por que hagamos practica y entendamos. Revisa duro los examenes!!!! Relajado Bro!'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, '80'::TEXT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Brinda apoyo']::TEXT[], '2016-06-08T00:00:00+00:00'::TIMESTAMPTZ, '265d14fcdc533d5bc3ab9811a29cc32da9e0ffdba291d095f522f583644d4bde'::TEXT, ARRAY[1041]::BIGINT[])
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
