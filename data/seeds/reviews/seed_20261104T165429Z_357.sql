-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=357
-- TEC-DATA-META years=2016,2017,2018,2019,2020,2025
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:54:29.174452+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (357::BIGINT, 'En el curso realmente se aprende bastante, pero el profe es bastante rudo para calificar y aparte no da instrucciones claras para los trabajos ni la rúbrica, por lo que uno no sabe bien lo que espera del trabajo'::TEXT, 2.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('45','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Deja trabajos largos', 'Exámenes retadores']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, '2a21de1d68e000ec214153e33026ac31a29fa68147f29ca99332daa68e3e7083'::TEXT, ARRAY[1219]::BIGINT[]),
    (357::BIGINT, 'El mejor profe de constru en cuanto al conocimiento que tiene, posiblemente sea el profe con el que más va a aprender, pero prepárese para un semestre de sufrimiento, los exámenes son diseñar puentes o edificios complejísimos, con el proyecto prepárese para no dormir. Es demasiado poco flexible'::TEXT, 2.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Clases largas', 'Exámenes retadores']::TEXT[], '2025-06-26T00:00:00+00:00'::TIMESTAMPTZ, '4a825c31e69c3a70d012f54a73d96717861e08f847e1da9c9716ecf44744dcfd'::TEXT, ARRAY[1219]::BIGINT[]),
    (357::BIGINT, 'Ninguno'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-02-18T00:00:00+00:00'::TIMESTAMPTZ, '7c4ee1f2f688d519c7fbdea3160ce17b3dcf1d01bb77164806f7e425489d9192'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'El mejor profesor que tiene la Escuela de Ingeniería en Construcción. Excelente persona y Ingeniero Estructural, del cual hay que sacarle mucho provecho, porque es un honor recibir clases con el. Recomendado 100%'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-27T00:00:00+00:00'::TIMESTAMPTZ, '2cd00e47078fe070f9e275d125fdc09cf6ebf47ff062278cfb6f5be9591bf95c'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Super carga. Sabe bastante y explica muy bien.. Los examenes, quices y tareas no son difíciles si va entendiendo la materia'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-27T00:00:00+00:00'::TIMESTAMPTZ, 'd538e8f0b9c48cb92cbad16b9829f90046c892c716f9596ab9c5f6dd6fb8ae63'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Demasiado crack este profe, es el mejor de la escuela, trabajos y exámenes difíciles pero si se le pone , le va bien. Vaya a consulta y preguntele lo que sea en los examenes!'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchos proyectos grupales', 'Tomaría su clase nuevamente']::TEXT[], '2018-11-21T00:00:00+00:00'::TIMESTAMPTZ, '10c27a38cdd9dcf073fc431b38b63187186a79f8c75f9ec2b27de14d40aa64ce'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Es un crack, explica muy bien, hay que agarrarle el ritmo porque siempre va muy rápido, pero uno de verdad aprende con él.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-14T00:00:00+00:00'::TIMESTAMPTZ, '2df137a841806676f9fd84d12a6de002cfefa990925f6b41f26b1c5293621db0'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Definitivamente un crack, este profe sabe demasiadooo acerca de la parte estructural, sabe transmitir el conocimiento, usted aprende muchísimo, el curso va a requerir de su compromiso y dedicación al 100% pero definitivamente vale la pena!'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-11-07T00:00:00+00:00'::TIMESTAMPTZ, '429e2bdfb8d7eec815b7a62d50798c3dfbae639a16a828c1d5bc061a998225bc'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Excelente profesor, las clases son entretenidas y en realidad él sabe transmitir el conocimiento a sus estudiantes. Recomendado 100%, aunque de todos modos no hay otra opción!'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo', 'Tomaría su clase nuevamente']::TEXT[], '2018-09-20T00:00:00+00:00'::TIMESTAMPTZ, '5263e70f9792fbe1d32d7d036cac7991eaee7ab73aedd4ebefa2180e055646fa'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Es un profesor del que se puede aprender mucho. La materia la da con mucha claridad, se hacen bastantes ejercicios y califica de forma justa.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Aspectos de calificación claros', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'ed806a20c4feaf827c8d54477ffe08576f03c396900387068879898a3662ac22'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Ninguno'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Inspirador', 'Tomaría su clase nuevamente']::TEXT[], '2018-06-21T00:00:00+00:00'::TIMESTAMPTZ, '3e04a161ce2516aba0d32be6e7ea8da1edda28e35b096f2597689ad58fd1cf60'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo', 'Clases excelentes']::TEXT[], '2018-06-17T00:00:00+00:00'::TIMESTAMPTZ, 'e5d2f6dfff5d1dad688565f48ad595a7d63905f8a7a80a0e10d50274cf0ea4e8'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2018-05-27T00:00:00+00:00'::TIMESTAMPTZ, '18a9fd5e0b0fc0a9c73b663f46d19ff304902bccbd69110e3939eb02f9bb232f'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Excelente Ingeniero'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-03-07T00:00:00+00:00'::TIMESTAMPTZ, '6b543e83490f069efa6b9141c5d0a6e7d4510f39995fa954289182d832972e9d'::TEXT, ARRAY[1242]::BIGINT[]),
    (357::BIGINT, 'Excelente profesor con buena pedagogía para enseñar. Tiene mucho conocimiento de la materia, pero lo más importante es que sabe transmitirlo a sus estudiantes. Abierto a consultas y ayudar a sus estudiantes en todo momento. Uno de los pocos especialistas de Estructuras de Constru.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2017-08-09T00:00:00+00:00'::TIMESTAMPTZ, 'daaaf635742f0d877b6b18dfbc8db1c7f624f6fbd5bccc923ee247da408aa586'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Ninguno'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-06-27T00:00:00+00:00'::TIMESTAMPTZ, '7896ab405af4686d82d61fb481d64bc022f89f7e97d472b464f1a62dd9c5799c'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Excelente profesor. Los exámenes son largos y tediosos, pero son ejemplos que se dan en la realidad, es un profe muy interesante y muy ameno, se lleva bien con los estudiantes y se interesa por que uno aprenda. El curso es realmente genial. Por profes como este, la Escuela está bien.'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Deja trabajos largos', 'Clases excelentes']::TEXT[], '2017-06-22T00:00:00+00:00'::TIMESTAMPTZ, 'dc2486e4656f36d2923105d54e865041b2c86e10944b90324764afe008ab7c41'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Excelente profesor, explica de la mejor manera, se aprende demasiado y el curso es bastante interesante, las evaluaciones son de acuerdo a lo visto en clase; sin embargo son un poco largas y pesadas y a la hora de calificar es un poco rudillo; a pesar de esto es uno de los mejores profesores.'::TEXT, 6.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('70','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2017-01-31T00:00:00+00:00'::TIMESTAMPTZ, 'adf395e599b889c9c5aa9f8d342ab640b742018a7991bb6f0976eb9a3c56c20f'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Es un excelente profesor e ingeniero, las evaluaciones son de lo visto en clase, sin embargo califica muy fuerte, explica muy bien, recomendado'::TEXT, 6.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'La participación importa', 'Tomaría su clase nuevamente']::TEXT[], '2016-11-12T00:00:00+00:00'::TIMESTAMPTZ, 'e021c9461453e76776241920e9334b7686bb7049f85e1ba92c171801099dcd1b'::TEXT, ARRAY[3517]::BIGINT[]),
    (357::BIGINT, 'Excelente Profesor, excelente metodología de enseñanza'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Brinda apoyo', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2016-06-22T00:00:00+00:00'::TIMESTAMPTZ, '3ae1160ffb978cfad5b902dddff97ff8222cc319eae1be5ab560483899f17b92'::TEXT, ARRAY[1182]::BIGINT[]),
    (357::BIGINT, 'Un excelente profesor. Gran ingeniero, a pesar de que nunca había dado estática se le comprendió toda la materia perfectamente.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('55','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Da crédito extra', 'Clases excelentes']::TEXT[], '2016-06-16T00:00:00+00:00'::TIMESTAMPTZ, 'b1dcca8ecb076d984be4418aaf22c8df6561eab6d9b0d3d4ee5ee838b0697cf5'::TEXT, ARRAY[1182]::BIGINT[])
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
