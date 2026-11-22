-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=125
-- TEC-DATA-META years=2023,2024,2025,2026
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:39:36.321027+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (125::BIGINT, 'Háganse un favor y no matriculen con este real hp, es de esos profes que cree que su materia importa'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Asistencia obligatoria']::TEXT[], '2026-10-20T00:00:00+00:00'::TIMESTAMPTZ, 'def6b0acea2b2d9ac6155ff97aaf6a415ab979faad4b646d117aff464be6576d'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Un profe que cree que esta dando el curso para la carrera de filosofia y no un seminario. Demasiada carga academica, es un dolor pide todo lo que le da la gana y mas, califica durisimo, si lleva bloque completo o tiene vida en general ni lo piense.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'Requiere mucha lectura']::TEXT[], '2026-10-16T00:00:00+00:00'::TIMESTAMPTZ, '36939d79c7c39bc389d627b878a76cae041beb64c1ff768311f992d75d7a83cc'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'La premisa del curso es interesante, el profesor lo arruina. No explica la materia, solo deja lecturas. Dice que se puede trabajar individual, pero de esa manera se hace pesado, en especial para un curso de 2 créditos. NECESARIO tener un buen equipo si quiere pasar.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('75','')::SMALLINT, NULL::SMALLINT, ARRAY['Deja trabajos largos', 'Muchos proyectos grupales']::TEXT[], '2026-07-21T00:00:00+00:00'::TIMESTAMPTZ, 'eb5c4800cf362bfc37e27c19bd4406ca9c0b707bd11f3894e0a5c39b0436b09c'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Si pueden matricular con otro profesor, háganlo, y lean todos los demás comentarios; por algo están. Hace demasiado complicado el curso, no califica nada ni da retroalimentación, cuesta demasiado contactarlo y hace las clases muy pesadas. Califica muy duro.'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Asistencia obligatoria', 'Deja trabajos largos']::TEXT[], '2026-05-15T00:00:00+00:00'::TIMESTAMPTZ, 'd84f2fe845bc594b21fc4163175f13c2cb2a33b209be00691b35831c1493ebc7'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Muy buen profe, se aprende bastante con él. Si da bastante retroalimentación, los trabajos son medio pesados pero valen la pena. No es un profesor que imponga su ideología como dicen acá, mas bien genera un ambiente sano de debate y discusión sobre temas de interés. Matriculen sin miedo con él'::TEXT, 4.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2025-11-15T00:00:00+00:00'::TIMESTAMPTZ, 'd980938bad8745ecc1629ad64ac15ad847ac53238160b4c2517f04a2a256bdaa'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Si usted quiere que el curso se le dificulte, matricule con él. Es un profesor malo, no explica nada en sus clases, básicamente el curso lo da el estudiante, lejos de enseñar más bien hace que el curso esté cargado, no deja instrucciones claras y a la hora de responder dudas lo hace de manera odiosa'::TEXT, 2.0::NUMERIC(3,1), 2.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2025-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'd24db6f907fcd145bc0898f67a092c27ed7c60414a48de75dbb3f3f98ad5d3e6'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Este ha sido uno de los peores cursos que he llevado. El profesor no enseña, adoctrina. Impone su ideología marxista sin espacio para el debate y pretende “reformar” el pensamiento del estudiante. No explica bien temas clave, no entrega notas durante el curso, no enseña,manipula. A tomar en cuenta.'::TEXT, 4.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'Clases largas']::TEXT[], '2025-07-23T00:00:00+00:00'::TIMESTAMPTZ, '3df3d7b4cde66972897e6964c571b24af038ee1f6c9969d2e500e0ddfafa3dff'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Deja trabajos cada semana y para realizarlos son textos sumamente largos. A la hora de calificar es muy duro y deja todo hasta el final; aparte es muy dificil contactarse con el. Si esta considerando llevar un curso con el descartelo de una.'::TEXT, 4.0::NUMERIC(3,1), 5.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2024-06-24T00:00:00+00:00'::TIMESTAMPTZ, 'a8a60af1b5660c0c50087dec9ebe157283f5a5c65c946bda29ff886db4e12fef'::TEXT, ARRAY[980]::BIGINT[]),
    (125::BIGINT, 'Como persona es buena nota como profe deja que desear. El profe califica como si fuera un curso de la carrera de filosofia, califica hasta el puro final y despues es un dolor para que conteste correos, creo que hay mejores opciones para el curso pero si esta es la ultima opcion no esta tan mal'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Clases largas']::TEXT[], '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ, '05d83411651884d2fc4fe0728c24d1895fedc5703020a9ca78d200807a9db83c'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Es un experto en la materia, pero hace el curso demasiado pesado para lo que vale. Trabajos cada semana que dependen de lecturas muy largas, si tiene la oportunidad no matricule con él.'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('80','')::SMALLINT, NULL::SMALLINT, ARRAY['Muchas tareas', 'Requiere mucha lectura', 'Deja trabajos largos']::TEXT[], '2024-06-21T00:00:00+00:00'::TIMESTAMPTZ, 'd7e5fce0fd125aded3c89898317ceb469e5c08bc923c64977f6b9047f7d5f458'::TEXT, ARRAY[980]::BIGINT[]),
    (125::BIGINT, 'Rubricas para nada claras, da el 90% de las notas del curso hasta el ultimo día y suelta todo sin retroalimentación, no responde correos. Consígase un buen grupo desde el inicio, hacer los bretes solos no es una opción viable aquí.'::TEXT, 4.0::NUMERIC(3,1), 4.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY['Requiere mucha lectura', 'La participación importa']::TEXT[], '2023-11-30T00:00:00+00:00'::TIMESTAMPTZ, '452a429a46264ccaddc81073b65f7b30223cb9624a62ca0276387c6d7cc7bc8b'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Como persona muy chiva pero como profe, lo vuelve un curso pesado y es tedioso que califique como si fuéramos estudiantes de lic para filosofía. Es exigente, hay otros profes mejores para matricular que comparten mucho conocimiento y no te dificultan el curso, igual cae bien, una persona interesant'::TEXT, 4.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2023-11-14T00:00:00+00:00'::TIMESTAMPTZ, '0acb375ced86e1311c6df1905af834856fbd8222f412395f6f52d68802d503bb'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Lo hace ir a uno a clases por 1 hora de 3 solo para terminar diciendo algo que pudo haber dicho por correo. No contesta correos. Califica súper duro. Si en la monografía no pones bien las referencias te puede poner 0.'::TEXT, 6.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY['Califica con rigor', 'Muchas tareas', 'La participación importa']::TEXT[], '2023-11-14T00:00:00+00:00'::TIMESTAMPTZ, '5bf629b4202ff476a62b7a241dcac461c9846e4a3dcf6e567959c487ea57666b'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Profe bastante bueno, que es flexible con sus estudiantes y bastante amigable. Sabe muchísimo y sabe extender esa información muchísimo, le disgusta que las clases sean solo materia y le gusta que los estudiantes propongan clases. Un poquito atrasado con dar notas, pero no tardío.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Da buena retroalimentación', 'Requiere mucha lectura', 'La participación importa']::TEXT[], '2023-06-26T00:00:00+00:00'::TIMESTAMPTZ, '093015c17b5cd2fe030a9094ab2e74c25734638343073db68c22e7c9f96ca1fb'::TEXT, ARRAY[981]::BIGINT[]),
    (125::BIGINT, 'Excelente profe de seminario, tiene muchísimo conocimiento y es muy flexible con los trabajos. Le gusta que los estudiantes participen y que estén atentos a la clase y es abierto a que los estudiantes propongan las clases y no solamente que sea decisión de él.'::TEXT, 8.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Da crédito extra', 'Tomaría su clase nuevamente']::TEXT[], '2023-05-28T00:00:00+00:00'::TIMESTAMPTZ, '11b9739d2b30dba666c83463f4d2b4c6dd2e714b0612a0f92cc6449377784699'::TEXT, ARRAY[981]::BIGINT[])
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
