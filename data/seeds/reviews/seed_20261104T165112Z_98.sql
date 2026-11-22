-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=98
-- TEC-DATA-META years=2015,2017,2019,2021,2022,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.073319+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (98::BIGINT, 'Gran profesor, el curso es muy interesante, hace los quites y los exámenes bastante complicados entonces hay que estudiar bastante. El curso es de 2 créditos pero debería valer más, aun asi es llevadero, el proyecto es pesado pero nada que con un buen grupo no se pueda sacar'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Exámenes retadores']::TEXT[], '2026-07-08T00:00:00+00:00'::TIMESTAMPTZ, 'ad1888867100c224f473c9daf0602545b167f129821b676d18252188645a545a'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Inspirador', 'Clases excelentes']::TEXT[], '2025-11-24T00:00:00+00:00'::TIMESTAMPTZ, '5cd374d39836b4ff1d78c344636e72a21b57732e7989d8e331816987e95f72dd'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Sus clases son algo aburridas, pero la temática es muy interesante. Son muy pocas las evaluaciones, pero no son tan complicadas y con el proyecto, es un poco tedioso, se entregan varios avances, pero se aprende mucho.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'Clases largas']::TEXT[], '2022-06-14T00:00:00+00:00'::TIMESTAMPTZ, '5cce9c1b3d1793ee6b784cc8e95535f70870a2eade6c1dd8be262ff9a0c726cc'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Es un profe muy aburrido, pero que explica y transmite lo que sabe muy bien. Para los quices/exámenes mejor léase el libro y téngalo a mano, le gusta mucho las respuestas textuales del libro y con el proyecto es muy tedioso, pero al final todo sale bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-02T00:00:00+00:00'::TIMESTAMPTZ, '5a74eec1910fb97fb52ae54fbd9e7ea63dd5525eacd6e1b435578655c4c20f7f'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Buen profesor, aunque el curso me llegó a parecer algo aburrido por ser totalmente teórico. Evaluaciones sencillas y claras. El profe le brinda apoyo y aclara sus dudas si así lo necesita. Él trata de dar el curso lo mejor posible y se nota realmente su esfuerzo y se le agradece.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2021-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'c1c10de90b5682146d05982936e6086f1f7ccc4e9f96941d6a2e35f7d2b5b507'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'El profe es muy pura vida y tiene mucha paciencia para explicar. No hace muchos quices y siempre avisa cuando van a ser. Los exámenes son fáciles y no califica muy duro.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '37837f061d2589fcc8b4ed903a70cc1da16caa079380f374501b182a9da19b22'::TEXT, ARRAY[937]::BIGINT[]),
    (98::BIGINT, 'El profe sabe mucho, los examenes son se las presentaciones que el da, el proyecto es largo pero se saca si se hace con tiempo. Buen profe'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-18T00:00:00+00:00'::TIMESTAMPTZ, '690890be438abd07d670d2cdaf929f0598381edaa858b19866c870a9e50186f1'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Excelente profe, de lo mejor de materiales. Tiene demasiado conocimiento y es demasiado educado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2019-11-06T00:00:00+00:00'::TIMESTAMPTZ, '8b7609d8502f880ffbea5ec387685b13f257baf3e2c2aea336e4097bba2c09e6'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Buen profesor, sabe mucho, explica bien la materia y es buena gente. Hace pocos quices, los exámenes son duros pero pasables (si estudia a conciencia). Los informes los califica duro, se fija en todo.'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Pocos exámenes', 'Aspectos de calificación claros']::TEXT[], '2017-12-06T00:00:00+00:00'::TIMESTAMPTZ, '8c5f9d00e3c310301293855ec13104f0f6106556857ca578bcb2a9c786696119'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Es muy exigente con los informes, revisa hasta la gramática. Pero el ambiente del curso es tranquilo'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-20T00:00:00+00:00'::TIMESTAMPTZ, 'ffd09af78917335455da2bcc519bde61246638f52c605a68ecd1ef81e46d3332'::TEXT, ARRAY[2755]::BIGINT[]),
    (98::BIGINT, 'Se enreda un poco al explicar algunas cosas, pero está muy bien preparado'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-07-01T00:00:00+00:00'::TIMESTAMPTZ, 'f55e42af2d6658351a18245a477e6443affd2868de5406a90dd64788156acbb3'::TEXT, ARRAY[2757]::BIGINT[]),
    (98::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-14T00:00:00+00:00'::TIMESTAMPTZ, '5d7559a49033c18ef8a6453f9be15da2f2ace576eaeef0ad86d08705c5b0a188'::TEXT, ARRAY[2757]::BIGINT[])
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
