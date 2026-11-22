-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=741
-- TEC-DATA-META years=2016,2020,2021,2023,2024,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.230244+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (741::BIGINT, 'Elige los grupos de trabajo (para el lab, expos y proyecto), sus tareas son muy largas y las clases igual. Para mí fue un curso complicado. Lo que entendía en clase no me servía para el examen. Pero es el único profe que da el curso (hagan las tareas aunque valgan poco, esos puntillos salvan al fina'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases largas', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, '3a68780b6f521d8d782ca5fc90a4a4f78320a3b39a8dcf8bf8913109f94271ea'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Complica las cosas más de lo necesario, las tareas y exámenes son 1000 veces más difíciles que los ejercicios en clase. Solo él da el curso así que ni cómo evitarlo. Califica con criterios cuestionables'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases largas', 'Exámenes retadores']::TEXT[], '2025-06-23T00:00:00+00:00'::TIMESTAMPTZ, '342341b3f28d3bf1d91af514d7f10b76212d0706fb107f3880f082ebf359e110'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Los temas son complicados y las clases largas y aburridas. Los exámenes son bastante difíciles y para responder consultas saca un folder con apuntes ya que ni siquiera él sabe como responder los ejercicios'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Deja trabajos largos']::TEXT[], '2025-05-23T00:00:00+00:00'::TIMESTAMPTZ, '172d4fe8f7d84867661e86dd7d40f65fdf7b16cbf3641ead88e70d4dbbc9f6ff'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'No sé si en cursos avanzados el profe será como dicen por acá, pero mi experiencia con él en este curso fue muy buena; sí hay que estudiar mucho para cada quiz e incóngitas ya que pregunta cosas muy específicas, pero conforme avanza el curso a mí se me fue haciendo más fácil.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura']::TEXT[], '2024-11-21T00:00:00+00:00'::TIMESTAMPTZ, '77cecb8421d85d4c2a7fb6e1cb46f8fd0b941cea02aad5136ced890cc801d7d3'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Es muy buen profesor, se nota que sabe lo que enseña.Si se le pide ayuda con algo es bastante amable. Eso sí, es exigente con las evaluaciones entonces hay que estudiar mucho para que le vaya bien en el curso. Pero en general es muy buena persona y profesor.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Inspirador']::TEXT[], '2024-11-01T00:00:00+00:00'::TIMESTAMPTZ, 'dcf92a73ee5538a4779ff6b97f8c5354309bf085f0432a72e41a872399f44cb8'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Lo amo, el mejor profe lo adoro, súper recomendado, demasiado buen profe'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación']::TEXT[], '2024-11-01T00:00:00+00:00'::TIMESTAMPTZ, 'd0a4aefcadc8417e486edbf9e34d50c946a26ce4337102806b7b32c5c0f9db5b'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Sus clases son aburridas y pone ejercicios que ni él sabe responder, los ejercicios son largos y antiguos y los copia de apuntes viejos.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas']::TEXT[], '2024-08-07T00:00:00+00:00'::TIMESTAMPTZ, '463352d2e1ce6046f9d872cf06b8a9be90a74efe69c4377bed1c915a8f42d455'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Es un incompetente y lastimosamente el único profesor que da el curso. Alexander tiene la tendencia de hacer evaluaciones demasiado complejas y largas, cambia los porcentajes de asignaciones cuando quiere y califica según su opinión. Aunque si eres mujer te va a dar mejores calificaciones.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'Muchas tareas']::TEXT[], '2024-06-18T00:00:00+00:00'::TIMESTAMPTZ, '70d8f47908a68d8ec85cdd926ed290191181f4fff0445566c07964cc202086e4'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Es buen profesor. Es exigente, lo que te obliga a prepararte bien a lo largo del curso, esto también ayuda mucho a aprender. Si no entiendes algo te ayuda con paciencia y de buena forma.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2024-06-11T00:00:00+00:00'::TIMESTAMPTZ, '8f9b33fc611665a24cb102e7e79752baa13079180fe1c17f0a83d3fbd680438f'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'No es mal profe como dicen algunos comentarios, siempre aclara dudas y se preocupa por el desempeño de los estudiantes en el curso. A veces hace comentarios toscos como decir que tal corte esta feo pero no es nada que se tenga que tomar personal'::TEXT, 4.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2024-02-01T00:00:00+00:00'::TIMESTAMPTZ, '9953de397392e8aa47140f905c108fa83dce45213efd200d7fbe02687cd52955'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Muy excelente profesor, no es malo explicando la materia como tal, el problema es que al ser tanta información y tan especifica es algo difícil, pero excelente profesor a pesar de ello.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Requiere mucha lectura', 'Da crédito extra']::TEXT[], '2024-01-23T00:00:00+00:00'::TIMESTAMPTZ, '16dc15a8c7ab3ebb0198fcbd8b949328ecde7a432496f157f8f0a7cc1ed09928'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Es un buen profe, hay que estudiar para las prácticas'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Respetado por los estudiantes', 'Clases excelentes']::TEXT[], '2024-01-15T00:00:00+00:00'::TIMESTAMPTZ, '36e337b05f3b96af9a1fb58395a42348d05d31586aa8f6a82f67e4e861e5e4c1'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'No es tan malo como dicen los otros comentarios aquí, a veces dice chistes que no dan risa pero en general es buen profe y siempre esta dispuesto a ayudar además de ser comprensivo'::TEXT, 8.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2023-11-15T00:00:00+00:00'::TIMESTAMPTZ, '859a2d882c49a11b53b6cc0f71ea7360fd7d99be0876591c9180092c24fec99a'::TEXT, ARRAY[3262]::BIGINT[]),
    (741::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Asistencia obligatoria']::TEXT[], '2023-10-03T00:00:00+00:00'::TIMESTAMPTZ, '6105364c937bbd40179709e09fa6934d89f0fd3b3029cf53fa24ce7d3637610e'::TEXT, ARRAY[3262, 3273]::BIGINT[]),
    (741::BIGINT, 'Es una lastima que sea el único profesor que da el curso, ya que sus clases son difiles de comprender, si puede evitelo.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clase fácil', 'Exámenes retadores']::TEXT[], '2023-05-27T00:00:00+00:00'::TIMESTAMPTZ, '2ca16790aee3486f0ce45c92fe13e54fb2c55fb144dc61e5d85441a7e196adcb'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Es un acosador, ya se sabe que tiene bastantes historias donde ha acosado a distintas muchachas y aún así ahí sigue en la escuela'::TEXT, 6.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-02-09T00:00:00+00:00'::TIMESTAMPTZ, '5b0843c382718e517eb9c5793924714700729c5b6b0248a01dce19946d4078b5'::TEXT, ARRAY[3273]::BIGINT[]),
    (741::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-12-10T00:00:00+00:00'::TIMESTAMPTZ, 'f290f05dc5b26c1b9492a3fba3b465d500ad89794dd373a5d87d9292e0bf78da'::TEXT, ARRAY[3273]::BIGINT[]),
    (741::BIGINT, 'Extremadamente fácil. Si es mujer, ya pasó.'::TEXT, 8.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2016-07-02T00:00:00+00:00'::TIMESTAMPTZ, 'dcc28977b19bd6d157bfe7a98f6020b71611470199af85431ee1c771c8cee34d'::TEXT, ARRAY[3289]::BIGINT[]),
    (741::BIGINT, 'Excelente profe, se aprende demasiado y es muy cómico.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Respetado por los estudiantes', 'Inspirador']::TEXT[], '2016-06-28T00:00:00+00:00'::TIMESTAMPTZ, '95257e4863379b40f17f725e4061f9bbb1699dc155401d8915579eba2c961c45'::TEXT, ARRAY[3320]::BIGINT[]),
    (741::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Exámenes retadores', 'Respetado por los estudiantes']::TEXT[], '2016-06-15T00:00:00+00:00'::TIMESTAMPTZ, '6c1f0275e2a84c0534a6f82604e2a33ed125c54f058e64dd79e741da9fbfb070'::TEXT, ARRAY[3259]::BIGINT[])
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
