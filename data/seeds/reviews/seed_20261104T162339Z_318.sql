-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=318
-- TEC-DATA-META years=2014,2015,2016
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:23:39.944038+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (318::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Clases excelentes']::TEXT[], '2016-11-17T00:00:00+00:00'::TIMESTAMPTZ, '429618d814da82ded59ed5f455454f51ef0258bc8e2b7888c59462dc246f81f2'::TEXT, ARRAY[1029]::BIGINT[]),
    (318::BIGINT, 'Muy buen profe sabe mucho, los proyectos son rudos pero de verdad se aprende demasiado.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-06-17T00:00:00+00:00'::TIMESTAMPTZ, '3ddc7e6238e399841ac57d609055d5f9614b8c05c36cffc6461d3795e5adecf1'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Profe muy pichudo, lastima que ya no va a dar el curso.. pero el mejor'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da crédito extra']::TEXT[], '2016-06-11T00:00:00+00:00'::TIMESTAMPTZ, 'abf04951276a8ffa906e84ae6113a19c88d6b71e65b326539006d91123ceee66'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Los proyectos son duros, pero esenciales, es una de las bases de la carrera. Algunas ocasiones se desvía del tema fácilmente.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Inspirador', 'Clases excelentes']::TEXT[], '2016-06-06T00:00:00+00:00'::TIMESTAMPTZ, 'cb68a6926d28a1172ba732a420ec23d930f1d06edfedd57e90d2cfe1c4180948'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'El curso es dificil por si solo, el profesor explica muy bien, sabe demasiado y aveces se sale mucho del tema por lo que pierda claridad. Las proyectos que deja son grandes y dificiles en extremo pero los califica suave a excepción de la documentación. Deja lecturas super largss (+200pags)'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2016-04-17T00:00:00+00:00'::TIMESTAMPTZ, '8c0a223eb63f0b2c8907e25b5e3f530e898cea4ebff4998555a2cc0f6364bae2'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'El profe ayuda en todo lo que pueda, si tiene alguna duda va se la aclara a la perfección, lo unico es no contar con el feedback por correo, pero por lo demás super recomendado, las progras son rudas, pero nada imposible, al fin y al cabo hay que saber y poder hacer de todo en sus cursos.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-12-03T00:00:00+00:00'::TIMESTAMPTZ, 'fc6d3e14f0ee90af151eeeb3f8aaa55c47c9f2bf4e0e3f3eed0a85650fbe18fc'::TEXT, ARRAY[1031]::BIGINT[]),
    (318::BIGINT, 'Es pura vida, a veces cuesta entender lo que explica pero hay que tomar en cuenta que la materia es muy compleja (datos 2 especialmente), deja progras muy rudas como debe de ser en estos cursos. Es muy comprensivo y si usted se esfuerza bastante puede que le ayude en muchas cosas.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-26T00:00:00+00:00'::TIMESTAMPTZ, '2e8f3966255752fadf643e84cb7f6bb67f4973376cbcc1cc524e99e18a16c8ca'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Este profesor sabe bastante pero se excede en los trabajos que deja, al fin y al cabo de los trabajos se puede aprender lo mismo pero no hace falta q sean tan matados... No trata bien a los estudiantes y hace comentarios fuera de lugar, le falta mucho para ser un buen profesor.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-03T00:00:00+00:00'::TIMESTAMPTZ, '8f5ef0dfbf90124420dae15cb478a1e141133e07bbe6038db88446416cdcf24d'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'aba9e9155260fb0a54797a7a0399bbd6b219f67703562975c952582efbd6bd7d'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'b3ec42be5cb6875fea9c44b9674e1de6a8372a189f8ac79916b62c396e11ccfb'::TEXT, ARRAY[1037]::BIGINT[]),
    (318::BIGINT, 'muy bueno en cuanto al curso, ayuda al estudiante, sin embargo no tiene el mejor modo'::TEXT, 2.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-06-05T00:00:00+00:00'::TIMESTAMPTZ, '987d0a057569f13f7e532f75c5a9908ab870a902416e5f3d21b687621512986b'::TEXT, ARRAY[1035, 1029]::BIGINT[]),
    (318::BIGINT, 'Muy buen profe, el curso es duro, pero termina con muy buen manejo de los temas'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, '36e297e0164d07baf040b8f2eff9e90fb3da2378e33da797b9945b241aeb9cb6'::TEXT, ARRAY[1031]::BIGINT[]),
    (318::BIGINT, 'Los que se quejan de el no deberían estar en la carrera, un profe muy bueno, los que se merecen pasar pasan. Sabe demasiado y se aprende igual.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-05-29T00:00:00+00:00'::TIMESTAMPTZ, '6e4bbab35e7e295c632502542687bf243aa04beb64d65bb6c981840d09b31a92'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-02-19T00:00:00+00:00'::TIMESTAMPTZ, '6f8ffb2941a5a60fb7cb33b64f3cc9304a557ef4090e05d4c419a9c76b2bc90f'::TEXT, ARRAY[1035, 1029]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-01-19T00:00:00+00:00'::TIMESTAMPTZ, '41729efbf1927ca8e588c20dd6a780423b020152f590d5e17113abce30571633'::TEXT, ARRAY[1037]::BIGINT[]),
    (318::BIGINT, 'Progras extremadamente dificiles casi imposibles de terminar, el profe sabe mucho pero lo que no sabe es como transmitirlo a los estudiantes, asume que uno ya es un programador.'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-28T00:00:00+00:00'::TIMESTAMPTZ, '08dcb5c235c44d46c4726ebe5dccfabaf15383e4fb6a3ae9f701db118562905d'::TEXT, ARRAY[1037]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-22T00:00:00+00:00'::TIMESTAMPTZ, 'c71b17fd52331d9364b8d62166d60c4212ababeb23a48f9574572cc086c053ab'::TEXT, ARRAY[1031]::BIGINT[]),
    (318::BIGINT, 'En este curso no se puede ir a pasar muy fácil, las progras que le van a dejar van a ser MUY difíciles, en serio... Pero va a aprender CANTIDASES, puedo decir que fue el profesor con el que mas aprendí, facil no es pero bueno si.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '097a5f91494808bbe99630dd4837a218407476faffc915bf8cfbd0448efeab32'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'b648ffc37607589554d7ff53aa4a91dedb57d3578ad52d2c2e4ff1ca6a75a5fa'::TEXT, ARRAY[1031]::BIGINT[]),
    (318::BIGINT, 'uno no busca profesores faciles. Queremos que nos formen como se debe.'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '3eafc760639bd66584e1573f06a1c913c4f6c4c4d96eca20765b04d8c546c97f'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'e6a1efc69cd2506602a6636e8a90397dc061b3a5f2bcedb29162ce99d0237a28'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '520d6f973ae32925b71438b4922345def514a07e281aaf09c7ff2f7b3c1ede60'::TEXT, ARRAY[1031]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('10','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'eff1bd081504301fea2222fcfdfba83c734e2568a484e6628c3478e5f0c3056b'::TEXT, ARRAY[1043]::BIGINT[]),
    (318::BIGINT, 'Ninguno'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('65','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-14T00:00:00+00:00'::TIMESTAMPTZ, '89eb3684e9943154a5687cbd55fcb7ae7ddd332aeda6054cd0537d31bbd056e8'::TEXT, ARRAY[1037]::BIGINT[])
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
