BEGIN;

ALTER TABLE public.schedule_equivalence_placeholder_course
  DROP CONSTRAINT IF EXISTS schedule_equivalence_placeholder_course_study_plan_id_fkey;

ALTER TABLE public.schedule_equivalence_placeholder_course
  ADD CONSTRAINT schedule_equivalence_placeholder_course_study_plan_id_fkey
  FOREIGN KEY (study_plan_id)
  REFERENCES public.study_plan(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE public.course_evaluations
  DROP CONSTRAINT IF EXISTS course_evaluations_course_id_fkey,
  DROP CONSTRAINT IF EXISTS course_evaluations_professor_id_fkey,
  DROP CONSTRAINT IF EXISTS course_evaluations_academic_term_id_fkey;

ALTER TABLE public.course_evaluations
  ADD CONSTRAINT course_evaluations_course_id_fkey
  FOREIGN KEY (course_id)
  REFERENCES public.course(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT course_evaluations_professor_id_fkey
  FOREIGN KEY (professor_id)
  REFERENCES public.professor(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT course_evaluations_academic_term_id_fkey
  FOREIGN KEY (academic_term_id)
  REFERENCES public.academic_term(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

COMMIT;
