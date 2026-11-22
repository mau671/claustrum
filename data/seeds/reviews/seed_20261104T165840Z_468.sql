-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=468
-- TEC-DATA-META years=2014,2015,2016,2019,2020,2024,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:58:40.773893+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (468::BIGINT, 'Ella tenía tiempo sin dar clases y tal vez, eso perjudicó la metodología. Muchos trabajos para un crédito, pero honestamente muchos compañeros creen que un crédito equivale a ir a hablar y usar el telefóno en clase. La profesora siempre fue respetuasa e intento ayudar, los temas son aburridos.'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas']::TEXT[], '2026-07-09T00:00:00+00:00'::TIMESTAMPTZ, 'ce0173024d491a356a5622e127ea4c7ac2d58aa782b62d787e402bdf45733933'::TEXT, ARRAY[998]::BIGINT[]),
    (468::BIGINT, 'Se cree que la clase de ella es importante, habla paja al extremo y la verdad demasiadas estupideces. Para un curso de 1 credtio pidio demasiado. Hizo hasta examenes y califico super duro. Rubricas extensas la verdad, solo para joder'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2026-06-30T00:00:00+00:00'::TIMESTAMPTZ, '39eef35f6745484df04a2b2d5d5aa561e83554db9e8f14680ee1323855ce7660'::TEXT, ARRAY[998, 155]::BIGINT[]),
    (468::BIGINT, 'La peor profesora, habla súper bajo, lee todo, se queja que uno no ponga atención en su materia de relleno, para tener tan pocos créditos pone trabajos enormes y exámenes peores,calificando hasta la ortografía, en las últimas semanas proyecto enorme, deberían de cambiar a una mejor profesora 0 recom'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Muchos proyectos grupales']::TEXT[], '2026-06-12T00:00:00+00:00'::TIMESTAMPTZ, '18d9de221b26dc03b11f3dde5e5368ba4fbad50fbcd393b1607b07ca54b8cef2'::TEXT, ARRAY[998]::BIGINT[]),
    (468::BIGINT, 'Llevé el curso en verano y fue muy fácil, la materia es simple y las evaluaciones tambien, el curso no fue pesado y tambien ella se preocuba por hacerlo dinámico.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2024-02-01T00:00:00+00:00'::TIMESTAMPTZ, '9e2293bda635c4b117be79279f44a6b5d843cd1c0865550a6005d74d4b2d2cf8'::TEXT, ARRAY[155]::BIGINT[]),
    (468::BIGINT, 'La profesora no domina el software básico para realizar planos de iluminación, además se confunde mucho dando la clase.'::TEXT, 6.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2024-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'fcb312a26f092c6cf7c4ff8d2332b59e1018f0436866721ee46886d553ecee26'::TEXT, ARRAY[1453]::BIGINT[]),
    (468::BIGINT, 'Es la mejor profe para este curso, lo llevé en verano y no hay cosa más fácil. La profe es muy joven y es demasiado buena gente! No entiendo las malas calificaciones de acá. Se interesa porque uno aprenda y si está hablando sobre algún instrumento ella lo lleva para probarlo. Aprovechen el bug!!!!'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2020-01-23T00:00:00+00:00'::TIMESTAMPTZ, '1a48f8a0f83f841008d73361a11b30e1a1cde0669e77f1b1a8f8a989eb535e0a'::TEXT, ARRAY[155]::BIGINT[]),
    (468::BIGINT, 'La peor profesora que he tenido, no sabe explicar, no prepara las lecciones, llega a leer, pone tareas de temas que ella ni sabe, no se recomienda en absoluto.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2019-05-29T00:00:00+00:00'::TIMESTAMPTZ, 'd6e117bc431553ea83251996981acf38699fdb7fba54dad009f175a47f123c2d'::TEXT, ARRAY[3589, 3087]::BIGINT[]),
    (468::BIGINT, 'Va a la clase a leer las presentaciones, no sabe explicar, clases aburidísimas, es muy insegura, se sale de la clase para preguntar a los otros profesores lo que no sabe, no se aprende nada con ella. No la recomiendo para nada, deberían de cambiar a esa profesora.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2016-02-11T00:00:00+00:00'::TIMESTAMPTZ, 'b09f6c730536731fdd0c6b910c54dda7464f4a30a24185eab97ab40b1da18ca3'::TEXT, ARRAY[1001]::BIGINT[]),
    (468::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-29T00:00:00+00:00'::TIMESTAMPTZ, 'cb51e1ba87b0e6251d273176a0d20cbaf3f877d4f5bddded5efb4832d123d556'::TEXT, ARRAY[1001]::BIGINT[]),
    (468::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-23T00:00:00+00:00'::TIMESTAMPTZ, 'cb9a261b9fa5c52316b72defc04f983a3388bc5522586a1ebd777f8c15619145'::TEXT, ARRAY[1001]::BIGINT[]),
    (468::BIGINT, 'Las clases son aburridas, los ejemplos y ejercicios que realiza en clase ella no sabe ni resolverlos correctamente'::TEXT, 6.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-16T00:00:00+00:00'::TIMESTAMPTZ, '7cf5f7546fd745611dd041d2208f72c0a235473365ffba61cdee1856026d99dc'::TEXT, ARRAY[998]::BIGINT[]),
    (468::BIGINT, 'Es por mucho, LA PEOR PROFESORA Que he tenido en toda mi vida!! No prepara la clase, solo lee, no explica bien, lo que no sabe lo inventa! o lo busca en google y cree que nadie la ve...'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-15T00:00:00+00:00'::TIMESTAMPTZ, 'd0afed10b3d745b6232fba3a84d43f404b5313c7c3fccda286d436558b31bf62'::TEXT, ARRAY[1001]::BIGINT[]),
    (468::BIGINT, 'Es pésima profesora. Nunca ha trabajado en la industria por lo que ni siquiera tiene facilidad de ejemplos. Se le nota por montones que no prepara las clases con anticipación y sólo llega a leer presentaciones de power point. Es muy aburrida y deprimente. Casi no se aprende nada.'::TEXT, 8.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('10','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-12-01T00:00:00+00:00'::TIMESTAMPTZ, '4bb13555bf98e9096a70717a98194516f92db3f3cd53106e3b46c830d42338be'::TEXT, ARRAY[1001]::BIGINT[]),
    (468::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '851fdaeb4e9ecd612dbbfe82952b66ba087f1f94f342b1b8f5eec985fbaef669'::TEXT, ARRAY[1001]::BIGINT[])
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
