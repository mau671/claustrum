-- ============================================================================
-- REVIEWS DELTA SEED
-- ============================================================================
-- TEC-DATA-META scope=reviews
-- TEC-DATA-META professor_id=1216
-- TEC-DATA-META years=2014,2015,2018,2019,2020,2021,2022
-- TEC-DATA-META term_external_keys=
-- TEC-DATA-META generated_at_utc=2026-11-04T16:51:12.020330+00:00

BEGIN;
SET LOCAL search_path = public;

WITH review_input (
  professor_id, comment, ease_score, quality_score, clarity_score, fairness_score,
  attendance_required, grade_received, engagement_level, tags, created_at, import_key, course_ids
) AS (
  VALUES 
    (1216::BIGINT, 'No hace nada, todo se lo deja a los asistentes mientras ella está sentada con el celular. Cuesta mucho que conteste por whatsapp y por correo. Además de que pasó el semestre más preocupada por su trabajo en la asamblea, que por sus responsabilidades con sus alumnos.'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2022-06-18T00:00:00+00:00'::TIMESTAMPTZ, 'be8e313a5dab538f15a1c0cf0b539f6bea35a588ea764aa3a836925427a4a344'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'La profe no hace nada y siempre anda medio perdida, todo lo hacen los asistentes. Lo que importa es que el curso es sumamente facil de pasar:'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-11-30T00:00:00+00:00'::TIMESTAMPTZ, '900b24909000ccf2fa8fdfb474a45bacedb12e08b7843a7e19e62f23f1f11940'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Los asistentes organizan súper bien la clase y se hace una sesión de ejercicio por semana. Súper bien.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2021-11-09T00:00:00+00:00'::TIMESTAMPTZ, '8c4fc6eb4292b33c413696e72ec84324d01ea9d319a5b5fef62a1ede6dead4d9'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'La profe no hace nada, solo se aparece en las clases a saludar, tiene asistentes pero solo le llevan el registro en el tec digital, todo consiste en que un grupo de estudiantes da la clase y los demás deben activar la cámara y seguir las rutinas. El curso se pasa fácil pero da demasiada pereza'::TEXT, 8.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria']::TEXT[], '2021-07-18T00:00:00+00:00'::TIMESTAMPTZ, '0c396c5bbb98e1541e976b88b89ed778a6fcd8ddc57af62a6bf404a91f9044ad'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Un curso que se pasa con matricular nada mas, tampoco es que requiera mucho tiempo, es una deportiva; pero a diferencia de lo que se dice, aca usted no hace nada, puede tener su camara apagada mientras alguien hace su rutina y listo'::TEXT, 10.0::NUMERIC(3,1), 6.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2021-07-13T00:00:00+00:00'::TIMESTAMPTZ, 'eeeac5aeb215662cb6fb453fc09ef99c5472ec6a4cf72bae842f1c6cbd1bae1a'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Si quiere ponerse en forma no matricule con ella. Si solo quiere salir del paso es buena opción.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), FALSE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa']::TEXT[], '2021-07-11T00:00:00+00:00'::TIMESTAMPTZ, 'c26f1c972ccc5760c8a9d0b9b114edef459861bbbbb581b97d246d92e65d1008'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Hay que ir a clase y además mandar una comprobación de que hizo otro tipo de ejercicio durante la semana. Básicamente puso a los estudiantes a dar las clases o si no ponía a los asistentes a darla. No fue mi deportiva favorita.'::TEXT, 6.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria']::TEXT[], '2021-01-28T00:00:00+00:00'::TIMESTAMPTZ, 'ca7c358d7aa0f9288056f33239e6072b03f6f8bf060bdd7be3d3a8c1c60e9704'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Si cree que Acondicionamiento Físico es Acondicionamiento Físico estas equivocado y mas aun si lo lleva con ella. Clases vacilonas. Con ir se pasa el curso literal.'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('90','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2020-01-23T00:00:00+00:00'::TIMESTAMPTZ, 'c84cc6b6f5d72294e1ed7c1d45cec1d4f5f1b30e9ed7f6215c671c68d94ef01c'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Con ir basta.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-12-01T00:00:00+00:00'::TIMESTAMPTZ, '4d77764a5c3a3c0f16f73356d70cc1199bb312609e471e0a7fbe90487afa0379'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Simplemente, vaya a clases y con eso pasa'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Tomaría su clase nuevamente']::TEXT[], '2019-11-23T00:00:00+00:00'::TIMESTAMPTZ, '1cbf9c4d03571ea9d34c7271ae137399935b80b718ddd684c09139f49daad429'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Muy buena profe y excelente persona. Lo único fuera de lo común es que durante el semestre canceló varias clases, y en general el curso no era lo que esperaba.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Aspectos de calificación claros', 'Brinda apoyo']::TEXT[], '2019-11-10T00:00:00+00:00'::TIMESTAMPTZ, '24fc959635f3bd612d76462aaadd6e061ff882108b9d8c578b7449d8c9c0d9af'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Es una buena profe. Se pasa bien en las clases y es entretenido.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Clases excelentes', 'Tomaría su clase nuevamente']::TEXT[], '2019-06-25T00:00:00+00:00'::TIMESTAMPTZ, '0fef686fac467110cd700435ae803fa3bb3cfe90cde309d5727b97a841b75152'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Buena profe. No se hace mucho pero uno la pasa bien y se relaja.'::TEXT, 10.0::NUMERIC(3,1), 7.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Respetado por los estudiantes', 'Inspirador', 'Brinda apoyo']::TEXT[], '2019-02-03T00:00:00+00:00'::TIMESTAMPTZ, '54f13d5fd6446159b124c843a35f12ee80e64846c5ce69f7c7212b66b302c45c'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Di no, es una deportiva, se pasa con llegar'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2019-01-31T00:00:00+00:00'::TIMESTAMPTZ, '47f31fb7d03a747aedf156d3dbb6367d3fa4bd2398b33f665dbe5feb2a6b0df6'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'No es lo que me esperaba el curso , pero es excelente persona, sí es un poco vaga y se pasa de fijo'::TEXT, 10.0::NUMERIC(3,1), 9.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('85','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-26T00:00:00+00:00'::TIMESTAMPTZ, 'f6e63fe60ee8a48b63cc451c54d5305225342c4a2cc67202f1a7864ad77cab0e'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'El curso se pasa solo. Tiende a poner al asistente a dar las clases.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['Asistencia obligatoria', 'Brinda apoyo']::TEXT[], '2018-06-23T00:00:00+00:00'::TIMESTAMPTZ, 'e74c7edb8e28efc85da4775ab889f615afa98282e6890390ad3e290b07b84787'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2018-06-01T00:00:00+00:00'::TIMESTAMPTZ, 'a9c757b9de4c193366d7e8318b325304b502c76e33c1398b669da66f006d1fda'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'No era lo que esperaba de la clase, pero algunas son muy entretenidas, hace un ambiente muy muy tuanis, curso con ella es curso pasado con 100. Si es muy vaga y pone a los asistentes a dar la clase pero no molesta con las ausencias.'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-11-05T00:00:00+00:00'::TIMESTAMPTZ, '504f9d4f8fe177a0f325844a6c73646196176eafffceb1394f8bba71e76b4695'::TEXT, ARRAY[494]::BIGINT[]),
    (1216::BIGINT, 'Excelente persona'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-08-10T00:00:00+00:00'::TIMESTAMPTZ, '2a3012b5856a93e9d40d9e0d15aee9007927dfde581bea17203d22bd091c576a'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Es muy común que ayude a los alumnos .'::TEXT, 4.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), TRUE::BOOLEAN, NULLIF('95','')::SMALLINT, NULL::SMALLINT, ARRAY['La participación importa', 'Asistencia obligatoria', 'Respetado por los estudiantes']::TEXT[], '2015-08-09T00:00:00+00:00'::TIMESTAMPTZ, 'aef40c0383e5ef2abfa09708196412d7e3492c9bfdcd6a7660ffdaf47951e082'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'muy facil, pero lastimosamente un poco vaga,las clases son mjy repetitivas. Pero es una gran persona, muy amabke, si uno tiene otras cosas que hacer. Solo habla con ella, y ella lo deja irse...'::TEXT, 10.0::NUMERIC(3,1), 8.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2015-07-03T00:00:00+00:00'::TIMESTAMPTZ, 'bae00851345f53dc22b89d9b240d2b296ac082a7b4b702ea2543971ee95aae88'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'Ninguno'::TEXT, 10.0::NUMERIC(3,1), 3.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF(NULL,'')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-15T00:00:00+00:00'::TIMESTAMPTZ, '8bf9394ccd79060eafb47f9b0ffed4da71bd539bf0d54c531c89b509db755fd5'::TEXT, ARRAY[493]::BIGINT[]),
    (1216::BIGINT, 'No se hace mucho, excelente persona'::TEXT, 10.0::NUMERIC(3,1), 10.0::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::NUMERIC(3,1), NULL::BOOLEAN, NULLIF('100','')::SMALLINT, NULL::SMALLINT, ARRAY[]::TEXT[], '2014-11-14T00:00:00+00:00'::TIMESTAMPTZ, 'ecc56e3b12e08e4fa0722b8c3ea35d8dedd73b4eb2c56dd5485b164de683336b'::TEXT, ARRAY[494]::BIGINT[])
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
