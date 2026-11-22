-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=323
-- TEC-DATA-META years=2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.128550+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (323::BIGINT, 'No brinda las presentaciones que usa en las clases. Se sobrevive a punta de sus apuntes y los de sus compañeros, es materia muy pesada pero hace quices toda las semanas presenciales para evaluarla. No lo recomiendo pero el curso se pasa.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación']::TEXT[], '2026-03-25T00:00:00+00:00'::TIMESTAMPTZ, '04beb9e2529e24af7c1be0bc2514e9cc567bf756b48d15dc979343a3fc05c1d9'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'Los proyectos son largos y las revisiones exigentes. Empezó a hacer examen final este semestre. Y deja 50%+ del semestre para las ultimas 2 semanas terminando en semana 19. No lo recomiendo.'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Deja trabajos largos']::TEXT[], '2025-12-05T00:00:00+00:00'::TIMESTAMPTZ, '24931e62a0e34df701c79cfa1f62a29d25b7157b4ac9362d69f5a0fe46f7f6c7'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'NO lo recomiendo, las clases son con presentaciones que el mae ni las brinda, es super arrogante. Quices todas las semanas donde la mayoría los sacábamos malos incluso más de la mitad teníamos puros ceros. De verdad trate de evitarlo para que no haga sufrir más'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas']::TEXT[], '2025-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'ba52f4953c8bb4f06b7f013a9e14242a1a0f32bad212487821fd6f6ce28dfc91'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, '1 presencial, 1 virtual, los proyectos q deja son totalmente asequibles, el problema es q las clases son el con una presentación (las cuales no da) por 2 horas, quices difíciles casi cada semana, toca sobrevivir de los apuntes q haga usted o sus compañeros, el curso se pasa ez mas no recomiendo'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Muchos proyectos grupales']::TEXT[], '2025-07-03T00:00:00+00:00'::TIMESTAMPTZ, '6583992dabf6d12a47b38ec7b4c28acdcaa49136a268cf647ab8edaffc5e1d59'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'Dos clases a la semana: una presencial. Quices casi todas las semanas (es lo más pesadillo del curso). Los proyectos son muy interesantes y se aprende un montón. Siempre que le pida ayuda se la va a brindar. No dude en matricular con él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-28T00:00:00+00:00'::TIMESTAMPTZ, '77f4fbd325203c272b135a6d260feaf929adf797e7ef87ea68a02b765a08a825'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'Excelente profesor, brinda apoyo cuando se le solicita, se apunta a las mejengas, las evaluaciones son claras y da el tiempo necesario para poder completarlas y aprender. Volvería llevar el curso con él. Aparte lo más importante es que está actualizado con los estándares de la industria.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Da crédito extra']::TEXT[], '2024-06-28T00:00:00+00:00'::TIMESTAMPTZ, '1547c58ce5e20555f011a78721c990a6f07ea111e6603bd68f08aaca9a066c54'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'Buen profe, los proyectos son interesantes, no son dificiles pero si hay que tomar bastante tiempo para sacarlos. Las clases se hacen muy largas ya que es mucha informacion por clase y el profe casi siempre toma las dos horas completas'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Aspectos de calificación claros']::TEXT[], '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ, '231b426142ac46f3036099723a9591f6d43c2196b51ab68debc4e03c28bd67a6'::TEXT, ARRAY[1162]::BIGINT[]),
    (323::BIGINT, 'Curso chill, deja 3 proyectos no son dificiles pero tampoco regalados es simplemente sentarse a hacerlos, en general el contenido del curso es interesante y de provecho ya que da una clase muy conectada con la industria actual. El resto de asignaciones son bastante sencillas.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-20T00:00:00+00:00'::TIMESTAMPTZ, '626258860c04d365cea16e81fc5486d69bf144cda9c182f29896f64024ac5c45'::TEXT, ARRAY[1162]::BIGINT[])
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
