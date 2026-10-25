BEGIN;

ALTER TABLE public.course_evaluations
  ALTER COLUMN course_id TYPE BIGINT USING course_id::BIGINT,
  ALTER COLUMN academic_term_id TYPE BIGINT USING academic_term_id::BIGINT;

DO $$
DECLARE
  table_name TEXT;
  seq_name TEXT;
BEGIN
  CREATE TEMP TABLE tmp_tec_reindex_tables (table_name TEXT PRIMARY KEY) ON COMMIT DROP;
  INSERT INTO tmp_tec_reindex_tables (table_name)
  VALUES
    ('country'),
    ('university'),
    ('campus'),
    ('academic_unit'),
    ('academic_modality'),
    ('academic_term'),
    ('academic_unit_campus'),
    ('study_plan'),
    ('study_plan_campus'),
    ('study_plan_level'),
    ('course'),
    ('study_plan_level_course'),
    ('course_relation'),
    ('professor'),
    ('course_offering'),
    ('course_offering_group'),
    ('course_offering_group_professor'),
    ('course_offering_meeting');

  FOR table_name IN
    SELECT t.table_name
    FROM tmp_tec_reindex_tables t
  LOOP
    EXECUTE format('LOCK TABLE public.%I IN EXCLUSIVE MODE', table_name);
  END LOOP;

  FOR table_name IN
    SELECT t.table_name
    FROM tmp_tec_reindex_tables t
  LOOP
    EXECUTE format(
      'CREATE TEMP TABLE tmp_map_%I ON COMMIT DROP AS
         SELECT id AS old_id,
                ROW_NUMBER() OVER (ORDER BY id) AS new_id
         FROM public.%I',
      table_name,
      table_name
    );

    EXECUTE format(
      'UPDATE public.%I dst
       SET id = -dst.id
       FROM tmp_map_%I m
       WHERE dst.id = m.old_id
         AND m.old_id <> m.new_id',
      table_name,
      table_name
    );

    EXECUTE format(
      'UPDATE public.%I dst
       SET id = m.new_id
       FROM tmp_map_%I m
       WHERE dst.id = -m.old_id
         AND m.old_id <> m.new_id',
      table_name,
      table_name
    );

    seq_name := pg_get_serial_sequence(format('public.%I', table_name), 'id');
    IF seq_name IS NOT NULL THEN
      EXECUTE format(
        'SELECT setval(%L, COALESCE((SELECT MAX(id) FROM public.%I), 1), true)',
        seq_name,
        table_name
      );
    END IF;
  END LOOP;
END $$;

COMMIT;
