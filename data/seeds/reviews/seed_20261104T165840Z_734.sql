-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=734
-- TEC-DATA-META years=2020,2021,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.897302+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (734::BIGINT, 'La profesora es inteligentisima y sabe demasiado del curso, pero el curso en si es demasiado pesado. Los exámenes que hace tienes que tener mucho cuidado con la parte teórica por que puedes perder puntos fácil. Hace buenos horarios de consulta. La materia es mucha eso si; 2 presentaciones por tema.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'daf85f5e253847d69f4f5cf07daf5c0b8eb64e7ad61e3e0691f14f5ac0c65610'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'No sé cómo será la profesora en futuros cursos, pero en este laboratorio me pareció muy buena, ella tiene mucho conocimiento sobre la carrera, sus clases son claras, solo hay que hacer lo obvio, estudiar antes de ir a clases para los quices semanales.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2025-06-19T00:00:00+00:00'::TIMESTAMPTZ, 'fce49b62ddb699f9c5717d1dc32d58e5c9d250416ad3c4c93fefc2592deaf387'::TEXT, ARRAY[3267]::BIGINT[]),
    (734::BIGINT, 'De las peores cosas que me han pasado en la vida es el tener que hablar con ella'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, 'eeb731531cf8c51582105a0c4f63be2c6038f7d28822edc313f23bfa79e2482c'::TEXT, ARRAY[3283]::BIGINT[]),
    (734::BIGINT, 'Clases aburridas y un método de enseñanza que deja mucho que desear, poca retroalimentacion, hace preguntas específicas y no acepta reclamos y tiene claros favoritismos con los estudiantes de su agrado'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-08-07T00:00:00+00:00'::TIMESTAMPTZ, '646c14497fb7c1ea18d8d0461a5f0620891af25fe2a4b5cbb91f8a5f7c66bd81'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'La verdad es que ese curso está todo mal hecho, la cantidad de materia demasiada por lo que no culpo a la profesora. Sin embargo, su metodo de enseñanza deja bastante que desear ya que espera que antes de la clase usted se aprenda las 100 diapositivas que sube y ni explica durante la clase.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, '26532e80ca983079880486e48c550dbbb2851c66bf2517b0f4b4b549c182265b'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Hay muchas ideas erroneas de la profesora. Si, si califica duro pero es excelente dando las clases, excelente con la metodologia, da muchas oportunidades de puntos extra y quiz sencillos y se aprende mucho con ella. Si usted se porta bien, le hace las clases bien, le ira bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'c443870b7e4df613e69c495c8919a1dc7986271729f9c05166fd529608682339'::TEXT, ARRAY[3267]::BIGINT[]),
    (734::BIGINT, 'No acepta reclamos, no responde dudas y las preguntas que hace para el examen son complicadas. Totalmente inferior al otro profesor.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2024-03-12T00:00:00+00:00'::TIMESTAMPTZ, '08d63bbe10cd084855d78849fd3645fd5baa88e549aebef7683b1deef1ea3577'::TEXT, ARRAY[3283]::BIGINT[]),
    (734::BIGINT, 'La materia es pesada y es mucha. Los exámenes son muy complejos y largos, más las partes de desarollo o si deja algo para investigar. Sin embargo la profe es muy accesible. El curso requiere de mucho tiempo y mucho estudio'::TEXT, 4.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Deja trabajos largos']::TEXT[], '2023-12-25T00:00:00+00:00'::TIMESTAMPTZ, 'a4cf7db7d685d6430d953b95f6f49c41192a3b0e5b1ba78e468ad481736a3756'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Pésima dando retroalimentación. Sabe mucho pero no sabe enseñar. Actúa y califica como si los estudiantes fuéramos expertos en la materia. Baja puntos por pequeñeces, hace los exámenes sincrónicos en el GAAP que falla mucho, las preguntas de estos son DEMASIADO específicas y no acepta reclamos.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos proyectos grupales']::TEXT[], '2023-12-03T00:00:00+00:00'::TIMESTAMPTZ, '7288d079eb04f8f14feb5e5bc3ccac748e1c394a2f00cfdb8b49eabdca6876ae'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Para todas las clases tiene un Nearpod y una Presentación y alguna info de la presentación no está en el Nearpod e info del Nearpod no está en la presentación, por lo que hay que estudiar las dos. Además, los temas no los deja del todo claros y los exámenes son algo complejos.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-30T00:00:00+00:00'::TIMESTAMPTZ, '64d7e67d5c4fde3a8efaa0bffb996a93b5b599f3b650200c386b1645895ab721'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'El principal problema de la profesora son las evaluaciones y su forma de calificar, ya que tiende a crear preguntas complicadas que requieren la aplicación de conocimiento muy específico, evaluaciones virtuales las hace en el gaap2 que falla mucho y no acepta reclamos ni responde dudas.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria', 'Exámenes retadores']::TEXT[], '2023-11-29T00:00:00+00:00'::TIMESTAMPTZ, '1b5492867654f5f4f984145a06f1d6ae70380de014d22e7d4b4f08bf43bd1d37'::TEXT, ARRAY[3283]::BIGINT[]),
    (734::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2023-06-23T00:00:00+00:00'::TIMESTAMPTZ, '361e1ff59afd240a26e23aa810f3ee703d36d7b21b14c4eba0e20752f93342d6'::TEXT, ARRAY[3267]::BIGINT[]),
    (734::BIGINT, 'Sus clases son aburridas y califica duro, me desagrado totalmente la forma en que califica, como si el estudiante es experto en los temas, tambien a la hora de responder correos y dar retroalimentacion es totalmente inútil, es mejor no pedirle ayuda nunca.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2023-05-01T00:00:00+00:00'::TIMESTAMPTZ, '5a70df9255e99cd8035a26dad5ea9ef2bf3a589a9a0c440adab9cfbd779a5d8b'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'La profe es buena gente y responde rápido las consultas. Puede calificar duro pero de manera justa. Al principio califica suave pero luego califica duro. Las clases son muy interactivas (realiza actividades todas las semanas).'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Aspectos de calificación claros', 'Clases excelentes']::TEXT[], '2021-12-04T00:00:00+00:00'::TIMESTAMPTZ, '577863d29b66feb06a8d58860952b7accc204275c45dee6e81daf7a5661adcf8'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Hace muchas actividades en clase y es muy amable'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Brinda apoyo']::TEXT[], '2021-02-15T00:00:00+00:00'::TIMESTAMPTZ, 'bb527f8855c275e15b27a65233cb70fe8bcb5843b8a04b2b4accddc060fb1653'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Es un 10 de profe se nota lo mucho que sabe de la materia. Se esfuerza demasiado por que las clases sean interesantes y se adaptó excelente a la virtualidad'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '3273b20c65b084c2b280a96a9bd220dcfac72c2afad8bab7886b5cb851bfa569'::TEXT, ARRAY[3271]::BIGINT[]),
    (734::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Aspectos de calificación claros']::TEXT[], '2020-12-10T00:00:00+00:00'::TIMESTAMPTZ, '5a72cd76981382e29db6d85cebe3d0020ac7d7daf690cf63587a940882406e48'::TEXT, ARRAY[3267, 3271]::BIGINT[])
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
