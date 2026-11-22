-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=340
-- TEC-DATA-META years=2015,2016,2017,2021,2022,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.153709+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (340::BIGINT, 'A lo largo del curso hay bastantes evaluaciones. Lecturas largas, papers obligatorios, tareas cortas (que no son tan cortas) y proyectos. El profe es muy pura vida, explica bien y le importa que los estudiantes aprendan. Los proyectos y las tareas cortas son difíciles.'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Requiere mucha lectura']::TEXT[], '2025-07-08T00:00:00+00:00'::TIMESTAMPTZ, '2d0f0786e1f5077fb9cbdf30da31a701272c12dfc94649f49e7bfdaa50dfaed5'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'El profe es muy buena gente, las clases son bastante entretenidas y enseña un montón, aunque solo aspectos teóricos. Las progras son bien rudas y hay que investigar bastante. El curso es difícil, pero se aprende demasiado, no me arrepiento de haberlo matriculado con él.'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2022-06-23T00:00:00+00:00'::TIMESTAMPTZ, '7294e2f000b220fda35626967632812cf065e763dbe8a503766decec23d65ad2'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'Es la primera vez que imparte el curso, entonces todavía hay cosas por mejorar. El profe cae bien, las clases son cortas y llevaderas, y se aprende bastantes cosas por encimita. Si verdaderamente se quiere aprender a fondo, hay que leer mucho por su cuenta. Las evaluaciones no fueron muy claras.'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2021-11-23T00:00:00+00:00'::TIMESTAMPTZ, 'c5b2412969cee3dfa64fb5b10f86b2dc0a15c8e46f4b24cc1eecbf661fb0874f'::TEXT, ARRAY[1158]::BIGINT[]),
    (340::BIGINT, 'Es la primera vez que da este curso electivo. El profe llega tardecillo a las clases y las termina temprano. Aparte de eso, las clases suelen ser actividades o el profe explicando temas. Los trabajos son un poco largos, pero nada que no salga de Google o de los enunciados del profe. Se aprende bien!'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2021-11-23T00:00:00+00:00'::TIMESTAMPTZ, 'cee31538aea9ceeb0e05f45ab133323ed60d9875ffd5b3a1c82d542e2acfecef'::TEXT, ARRAY[1158]::BIGINT[]),
    (340::BIGINT, 'Sabe mucho, pero solo enseña lo teórico, va a aprender a la fuerza por toda la investigación, las tareas de 5% son prácticamente proyectos, son muy difíciles y da de tiempo una semana. Si las tareas cortas son difíciles, los proyectos son aún peor. Si mete con él se va a querer morir desde semana 1.'::TEXT, 2.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2021-07-14T00:00:00+00:00'::TIMESTAMPTZ, 'e8edd5b763ddb199c4199f993a8ae9f2ebf4597e1345aa51bb76a7944df6b926'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'La verdad es bien difícil el curso, si de verdad quiere aprender, Moraga es alguien que sabe mucho y lo transmite super bien pero las progras son RUDAS, es de investigar bastante y de pensar, si usted quiere algo calmado no matricule, si quiere aprender pues él es su opción, aunque es matarse mucho'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Brinda apoyo']::TEXT[], '2021-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'c07bc314f8ce83e8876f25040e6d76311938c93dbba9234f9eabe7ee8468db3b'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'Excelente profesor! lo recomiendo un montón, solamente hay que sobrevivir al final'::TEXT, 2.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Tomaría su clase nuevamente']::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, 'dc3a44a3a8fab75dee56acefe57721c490c1af9554990dc4b9271ab08ee009fa'::TEXT, ARRAY[1043]::BIGINT[]),
    (340::BIGINT, 'El mejor profesor, y del que eh obtenido más conocimientos. Los proyectos son duros si, pero se aprende el resto de los que comentan acá son un poco de vagos que no hacen nada dejando todo para último, así quien va a tener tiempo de terminar un trabajo.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-02-10T00:00:00+00:00'::TIMESTAMPTZ, '85f3d4788f374e3fcce7d3f514b6e2859c3360a37c60aa11aafe92b02048e81a'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-07T00:00:00+00:00'::TIMESTAMPTZ, 'd9d0aac0dbcdef166efd21ea62892662b97fcf5398e58b2bc1ec664c0d028473'::TEXT, ARRAY[337]::BIGINT[]),
    (340::BIGINT, 'Demasiado desordenado, deja proyectos super duros, muchas tareas con poco valor porcentual, en fin, si hay otro, meta con el otro...'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('25','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2016-02-05T00:00:00+00:00'::TIMESTAMPTZ, '0204b7e1a90d3e8b19eefbbe92f743944dd7d3919df0a4c3916f2dcf31af19cd'::TEXT, ARRAY[1163]::BIGINT[]),
    (340::BIGINT, 'si no quieren atrasarse en la malla y tener las progras mas feas de las sede(no solo yo lo digo), no le matriculen'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('35','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-09-06T00:00:00+00:00'::TIMESTAMPTZ, '4529e6cb6c8b976c04aec062291cd56957ece69c3d7cce7e5f6b7f66fe08e3c6'::TEXT, ARRAY[1037, 1043]::BIGINT[]),
    (340::BIGINT, 'Excelente profe! Explica muy bien las cosas y se preocupa por que uno aprenda. Usualmente las clases son divertidas porque él vacila con uno como si fuera otro estudiante más. Ademas al final del curso trata de ayudar a los estudiantes lo mas que pueda y reconoce el trabajo que uno realiza.'::TEXT, 8.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-30T00:00:00+00:00'::TIMESTAMPTZ, 'bff109b48def7ef8d04cda5d68815301645a78e1818cdb8f36245c7b23714c52'::TEXT, ARRAY[2973]::BIGINT[]),
    (340::BIGINT, 'Muy buen profesor de verdad que enseña mucho y es demaciado tuanis tambien, yo lo recomiendo en casi cualquier curso de compu.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'f35ef696968a0efdff0a61d680a6491a1cf57977b459e532cbd186ad43c9d9e9'::TEXT, ARRAY[323]::BIGINT[])
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
