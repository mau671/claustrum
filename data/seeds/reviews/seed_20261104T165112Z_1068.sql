-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1068
-- TEC-DATA-META years=2018,2019,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.014861+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1068::BIGINT, 'El curso ya de por sí es muy duro, el profe realmente es muy bueno, pero muy estricto a la vez. Con que no crome tanto los exámenes, entregue buenos proyectos y haga todos los talleres, tareas, etc, se puede pasar. Sí califica bastante duro, entonces recomiendo hacer los trabajos lo mejor posible'::TEXT, 2.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Da crédito extra']::TEXT[], '2025-12-15T00:00:00+00:00'::TIMESTAMPTZ, 'fe990631c8268dfb33399bc2e542c815fe1c2b3b2ce797fb03f058315b3723a5'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('30','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2025-12-10T00:00:00+00:00'::TIMESTAMPTZ, '8006c1548b5664cf50cb581e3da2554100f693e7bfb5582f2b86c7fd7a95d0be'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'A ver, sabe mucho (trabaja en el área), es amigable, pero a cm sabe, tiene expectativas del estudiante, es virtual y no graba clases, así q ponga buena atención y no se duerma q si no después le va a costar, el curso en sí puede ser pesado, es un buen profe, está atento para contestar'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Clases largas', 'Exámenes retadores']::TEXT[], '2025-12-09T00:00:00+00:00'::TIMESTAMPTZ, '3e1700cc14a80034a6e3a486a8f20c9258d087a32970afe5aa98238abfd312ec'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'muchas veces en la carrera se quejan porque no hay buenos profes y cuando tienen uno solo se quejan (??), tiene espectativas altas y es muy comprensivo, si a usted le interesa trabajar en diseño de hardware aproveche porque se aprende mucho con él pero si hay que ponerle.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-07-23T00:00:00+00:00'::TIMESTAMPTZ, '170f3f9d399f8987b4e9e1e42e08042cb637e87c42136ccae24ecc9462a55f14'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'Le tenía miedo por los comentarios que hay aquí pero se me hizo de los mejores profesores que tiene computadores. Sabe demasiado, explica varias veces si es necesario, clases interactivas y es muy comprensivo en las defensas. Arqui II es durillo por naturaleza.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra']::TEXT[], '2025-07-22T00:00:00+00:00'::TIMESTAMPTZ, '2b24a12aae09e1379a6ac9f7d576f027b0053f7b87c3d5aaeea3b4ab032dd9c1'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'ronald es super pura vida, es mega comprensivo y sabe DEMASIADOOO!! tiene experiencia de verdad a diferencia de muchos en computadores y realmente ayuda a aprender skills importantes para la calle. lo va a convertir en un ingeniero real. si ud queria estudiar computacion (ver abajo) ni se acerque!'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-29T00:00:00+00:00'::TIMESTAMPTZ, 'df62445d9735b20c8de27801fc3b6de2e1eae7bfd9e0ee63c83cd62cca316aca'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'El enfoque del profesor era bastante binario, lo que a veces limitaba la oportunidad de explorar matices y diferentes puntos de vista. Una mayor flexibilidad en sus métodos podría fomentar un ambiente más colaborativo y estimulante.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2024-01-11T00:00:00+00:00'::TIMESTAMPTZ, '549e9027ab8f983546349c27e2c542a24a642ff6e4ade955fc5e91afbb6a0afd'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'Regular y binario. Evaluaciones sin instrucciones claras.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa']::TEXT[], '2023-12-01T00:00:00+00:00'::TIMESTAMPTZ, '47b267d39378df8d8e417716b44fc093badfe948760ff3ff3bff07806a2c096f'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'No sé de qué habla el review negativo pasado. Muy buen profe, le encanta tener conversaciones con los estudiantes, es bastante flexible y da retroalimentacion. Muy amigable y sabe mucho. Si se requiere de ayuda o extensión para algún trabajo estoy seguro que él está dispuesto a escuchar y negociar.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-15T00:00:00+00:00'::TIMESTAMPTZ, '3b9ad46dd6494ff5bd545db089b045307e6c3be820a341bacdd17c41c9edd7bd'::TEXT, ARRAY[2982]::BIGINT[]),
    (1068::BIGINT, 'Le gusta ser profe y esta anuente a atender cualquier duda, uno de los mejores profes de la escuela.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-02-13T00:00:00+00:00'::TIMESTAMPTZ, 'a6243b61d19e750361e35b4ffa8388144144725660bfed5cd1aea66cc356f37d'::TEXT, ARRAY[2973]::BIGINT[]),
    (1068::BIGINT, 'Excelente profesor, sabe mucho de los temas del curso y hasta mas, trata de explicar lo mejor posible, califica rudo, los proyectos son interesantes y se aprende bastante.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-29T00:00:00+00:00'::TIMESTAMPTZ, '46c472e2cac7e56da8ff9ae6c5c561209846a80fecb84614c8102594644b5601'::TEXT, ARRAY[2973]::BIGINT[]),
    (1068::BIGINT, 'Excelente profesor, explica muy claro, tiene amplio conocimiento de los temas y ademas experiencia laboral con la cual ejemplifica de excelente manera'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-29T00:00:00+00:00'::TIMESTAMPTZ, 'f9cd894baffc79990a61a35b28da86c9edb5074393511bd20314077ba1ef3cdc'::TEXT, ARRAY[2973]::BIGINT[]),
    (1068::BIGINT, 'Muy buen profe, sabe mucho de la arquitectura ARM. En los exámenes las instrucciones no son tan precisas y califica duro'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-23T00:00:00+00:00'::TIMESTAMPTZ, '4de7833b14b2accf45906d1eb8bbc047bab381242569c07bfaeb24a688a0984d'::TEXT, ARRAY[2919]::BIGINT[]),
    (1068::BIGINT, 'Gran interés en que el estudiante aprenda, da lo mejor de sí para que la clase quede clara, trae expertos para reforzar los temas vistos, escucha cualquier tipo de sugerencia-reclamo, Aspecto negativo: No conoce con propiedad algunos temas de arqui I, se ven teoricos sin mayor detalle.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '3b819866daf21d3566917e014a901f9f9f3411f385dff2a40c4a4ca275d4b4b1'::TEXT, ARRAY[2973]::BIGINT[]),
    (1068::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Inspirador', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-22T00:00:00+00:00'::TIMESTAMPTZ, '741e0321a8f68f3cda4846c6351cee90e1a1022a99ec7e35fc55aceb6b5c0cc9'::TEXT, ARRAY[2973]::BIGINT[]),
    (1068::BIGINT, 'La clase ideal de profesor, explica muy buen, clases super interesantes, exámenes/proyectos no imposibles en los que se aprende mucho. Da una cantidad enorme de puntos extra durante el semestre y trae expositores a la clase para conocer lo que hay en el mercado.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'bf58217b806d3602dbbf28a93812de55a6c7e7533fc36b32713afef4407abc75'::TEXT, ARRAY[2973]::BIGINT[])
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
