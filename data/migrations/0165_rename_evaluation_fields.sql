-- Rename course_evaluations columns to short, English-only names.
-- Only this table is affected: other tables keep academic_term_id because
-- live SQL functions still reference it in their text bodies.
-- Renaming a column here does not affect those functions.

ALTER TABLE public.course_evaluations RENAME COLUMN evaluation_type TO type;
ALTER TABLE public.course_evaluations RENAME COLUMN evaluation_number TO number;
ALTER TABLE public.course_evaluations RENAME COLUMN custom_name TO name;
ALTER TABLE public.course_evaluations RENAME COLUMN is_catedra TO coordinated;
ALTER TABLE public.course_evaluations RENAME COLUMN includes_answers TO answers_included;
ALTER TABLE public.course_evaluations RENAME COLUMN has_separate_answers TO answers_separate;
ALTER TABLE public.course_evaluations RENAME COLUMN answers_file_key TO answer_file_key;
ALTER TABLE public.course_evaluations RENAME COLUMN answers_file_size TO answer_file_size;
ALTER TABLE public.course_evaluations RENAME COLUMN answers_file_sha256 TO answer_file_sha256;
ALTER TABLE public.course_evaluations RENAME COLUMN moderation_note TO note;
ALTER TABLE public.course_evaluations RENAME COLUMN academic_term_id TO term_id;
