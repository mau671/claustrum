-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=47
-- TEC-DATA-META years=2020,2021,2022,2023,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:18:46.743215+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (47::BIGINT, 'Buena Profe, ojo a mi opinión, hay que estar atento y realizar todos los trabajos en clase (quices y prácticas) para pasar y además no faltar nunca. Los exámenes no son tan complicados nada más entender en clase y repasar.'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Clases excelentes', 'Muchos proyectos grupales']::TEXT[], '2026-06-25T00:00:00+00:00'::TIMESTAMPTZ, '30f5b29afc5a0cdf5cfcd7723d532c8da9b0dcb40ca741e978db469b729783d8'::TEXT, ARRAY[1206]::BIGINT[]),
    (47::BIGINT, 'De las mejores profes en el tec, llevaría todos los cursos con ella de ser posible'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Brinda apoyo']::TEXT[], '2026-05-16T00:00:00+00:00'::TIMESTAMPTZ, '34a0b27ba2351ee69e28b5070dc89e6f6e72d9c766438b71964a6528e7a8961a'::TEXT, ARRAY[1708]::BIGINT[]),
    (47::BIGINT, 'La mejor profesora para llevar conta 2'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Clases excelentes']::TEXT[], '2025-07-25T00:00:00+00:00'::TIMESTAMPTZ, '029b9e8f396b6e1a48fc426be4b81b25899bd4ff3b61582bd243c4290de9a9bb'::TEXT, ARRAY[2361]::BIGINT[]),
    (47::BIGINT, 'La mejor profe del tec, volvería a tomar su clase una y otra vez uwu'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muy cómico', 'Da buena retroalimentación', 'Tomaría su clase nuevamente']::TEXT[], '2023-01-11T00:00:00+00:00'::TIMESTAMPTZ, 'fda4ce93d781d9d0d8fd5016b4a38ce46b95b1cb4f23b4d49a61b6e89678667e'::TEXT, ARRAY[1707]::BIGINT[]),
    (47::BIGINT, 'Para metodologia la profesora es demasiado buena, se nota que ama la materia y es una excelente profesora en dicha materia, siempre y cuando pregunté lo que no se entienda de manera respetuosa. La recomiendo para metodología.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'La participación importa']::TEXT[], '2022-06-28T00:00:00+00:00'::TIMESTAMPTZ, '005dad212ac7b91bf9f34b84f75ad6fd0962f0ef502013deb3a76022210f3deb'::TEXT, ARRAY[2442]::BIGINT[]),
    (47::BIGINT, 'El segundo semestre del 2021, tuve un accidente de trànsito y le presentè los documentos a la profesora y me dijo que no eran vàlidos para ella, por lo que no me recibiò varias tareas luego me anulò un examen por que mi username de mi computadora era un apodo y no mi nombre ;v'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '4c46aec61209bcebc85e58481e81e1050d9c78cadbe8ee4044ac6ab7226c0f47'::TEXT, ARRAY[1206]::BIGINT[]),
    (47::BIGINT, 'Casi siempre deja dos trabajos por semana, el curso lo evalúa por consignas y son bastante largas las clases'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'La participación importa', 'Clases largas']::TEXT[], '2022-06-27T00:00:00+00:00'::TIMESTAMPTZ, '3eb802722068ef374d802e737116705c5b20191a82cdf2ad23c0be3d3483e00d'::TEXT, ARRAY[1206]::BIGINT[]),
    (47::BIGINT, 'La profesora comete demasiados errores a la hora de realizar un ejercicio de ejemplo, lo cual confunde demasiado. Durante todo el curso tuvo errores al calificar tanto tareas como examenes por lo que siempre había que estar pidiendole revisión.'::TEXT, 6.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, '94388300b1cb30d52e50fb6843f565902b6bad67099e57c8301f2a84bceb6a29'::TEXT, ARRAY[2361]::BIGINT[]),
    (47::BIGINT, 'La profe no explica para nada claro, comete muchos errores y además si tienes dudas las responde de manera repugnante en ciertas ocasiones. Su nivel de sarcasmo es insoportable, entre otras cosas que en definitiva me hacen no recomendarla.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Exámenes retadores']::TEXT[], '2022-06-09T00:00:00+00:00'::TIMESTAMPTZ, '5fb73fa76a1a0f3f18e6f05056eb9d648f83f374c9cb0906c163a7c0d3f08dcc'::TEXT, ARRAY[2361]::BIGINT[]),
    (47::BIGINT, 'Es buena profesora, sus clases y dinámicas son interactivas y sabe muy bien de lo que habla. Las evaluaciones son regulares, ni tan difíciles ni tan fáciles, pero si debe mantener la materia al día todas las semanas.'::TEXT, 6.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2021-07-15T00:00:00+00:00'::TIMESTAMPTZ, '29811d9620d326f72b3d8c747b96ac91afce0ae8a5f46d949c225b0fd34072fd'::TEXT, ARRAY[2361]::BIGINT[]),
    (47::BIGINT, 'La verdad puede ser un poco dura para calificar a veces, pero sus trabajos son sencillos y creativos, es un curso que requiere tiempo en especial si nunca se ha llevado nada del mundo de los negocios, si se esfuerzan pueden salir muy bien'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Da buena retroalimentación', 'Clases excelentes']::TEXT[], '2020-08-10T00:00:00+00:00'::TIMESTAMPTZ, '9f4efef31d0d910d140a159db3adc71ba657796f4c12105c4eff52eec30a2043'::TEXT, ARRAY[1206]::BIGINT[])
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
