-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=621
-- TEC-DATA-META years=2019,2020,2021,2023,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:32:27.056880+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (621::BIGINT, 'Pésima profesora, no enseña, no explica, no ayuda, se ríe de vos, y califica como si hiciera todo lo anterior. Se le nota lo frustrada que tuvo la vida. No hay quite con ella, no hay más profesores, pero sepa que la va a pasar mal.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-10-08T00:00:00+00:00'::TIMESTAMPTZ, 'f054dfdbd33e6ddf9340efc2e30911bfed4eba52e6ba5aaf4c6a77aa9e1c6c54'::TEXT, ARRAY[1856]::BIGINT[]),
    (621::BIGINT, 'En general el curso es muy deficiente, pero siento que con ella es aún más difícil que sea llevadero. Es muy difícil pensar que hacer las cosas de este curso es fácil cuando no hay una preparación previa'::TEXT, 2.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, '161f6fbf78dd24ccb8b3b8e14e70700b11dd1a37f899d4aec18c1a43c9148872'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Como profe es decente, te puede tomar entre ojos al llegar tarde y a veces se nota el favoritismo. No da instructivos en los trabajos, después de semana 10 (presencial) casi que quedas por tu cuenta.'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Muchos proyectos grupales']::TEXT[], '2023-06-21T00:00:00+00:00'::TIMESTAMPTZ, '2651ea6fa86c00ad89e7bee47483e9c4d3e8764d374ef2c308c370003eee6dbb'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Es bastante amable, si usted va a consulta ella lo ayudará bastante para que sus proyectos salgan de la mejor manera'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura']::TEXT[], '2021-06-30T00:00:00+00:00'::TIMESTAMPTZ, '9d4a087c918d50f0e81ef3f0ec4e0cc109478be8ae6267e9882bee38ba99babe'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Que responda es con presión del director. La retroalimentación es muy escueta y no revisa el trabajo que le envían. Dar un 100 es deningrante para ella. No tiene tacto humano. Súper desordenada con los porcentajes. Es más ingeniera que diseñadora.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muy cómico', 'Deja trabajos largos']::TEXT[], '2021-01-26T00:00:00+00:00'::TIMESTAMPTZ, '646928396ff3f36d7e5a1175e628d3cdec28769f8e43d26aa900fda00457d38b'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Ella no tiene calidad humana, no le importa en lo más mínimo los estudiantes y es completamente imparcial. Su retroalimentación es vaga y no aporta en absoluto, solo critica sin dar ninguna recomendación. Todo lo aprendido es por uno solo. NO METAN CON ELLA. Sean felices.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'ad6c00531b531bee39b71df8f2bb53541e503e30a3118f338ca9f421affd5ab4'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'En modalidad virtual mostró que no tiene vocación como profesora, cuesta que este disponible, da retroalimentación de forma escueta, tiene favoritismos claros, se enoja si uno no entiende y no se pueden tener dudas o piensa que es algo persona en su contra y su trabajo'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor']::TEXT[], '2020-08-25T00:00:00+00:00'::TIMESTAMPTZ, '7c6a0c1092b9ff61a9955b8dc05d881784f0294fcc6615aa8701c5033a6d68dd'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Las guías no son claras y se enoja si uno le pregunta, diciendo que como es posible que no las entendamos y que estamos tratando de hacer que su trabajo quede mal. No tiene tiempo para los estudiantes, y es demasiado odiosa si usted no es de sus favoritos.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-08-13T00:00:00+00:00'::TIMESTAMPTZ, '9e75ef38ba98458dbe3b06de43f8f9c235edb8e8ddd97622d4a65cc5dcdcc878'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Es muy odiosa, pasa ocupada todo el tiempo y cuesta mucho que le preste atención a los estudiantes. No atiende a nadie fuera del horario de consulta y durante ese horario a veces ni contesta o deja en visto. Le gusta humillar a los estudiantes y no ayudar en nada.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-07-14T00:00:00+00:00'::TIMESTAMPTZ, '5b5c2bb8d9ba59439b1d18eb14e2ab17dd9ec807bb35eb0ba24b04a9ad6f8719'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Buena persona, tiene demasiada preferencia con algunos estudiantes y lo hace demasiado evidente. No tiene claridad en lo que quiere, siempre cambia de opinión. Difícil de complacer'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-11-13T00:00:00+00:00'::TIMESTAMPTZ, 'e9f70e614e50633c3faaaa7ba0d05839f2023234806c4f2814d75fac4d019117'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Si bien es una profesora impecable (en todos los aspectos) creo que su gran problema es que no toma en cuenta las situaciones de sus estudiantes al sugerir mejoras o cambios. Lo mismo ya mandaste a hacer algo que ella te pidió y a última hora te lo cambia.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Brinda apoyo']::TEXT[], '2019-07-26T00:00:00+00:00'::TIMESTAMPTZ, '634b4bf61fbd7bf6491eba37f97d34c9e695d3e38c94c2eeeaf553b1620d0040'::TEXT, ARRAY[1867]::BIGINT[]),
    (621::BIGINT, 'Olga es una verdadera leyenda en Diseño, ud va a escuchar que todo el que pasa por ella termina amándola, sin embargo, a veces es mejor vivir las experiencias en la piel propia. Es una excelente profesional, apasionada por lo que hace y capaz de llevarlo a dar lo mejor. Vaya mucho a consulta.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2019-01-17T00:00:00+00:00'::TIMESTAMPTZ, 'f68a0d5ff2ced63cccbf6f3516ac5ec427e4f5fca6c6e27ea7914773f6c7538a'::TEXT, ARRAY[1867]::BIGINT[])
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
