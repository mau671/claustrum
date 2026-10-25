BEGIN;

DROP TRIGGER IF EXISTS ensure_professor_review_course_relation_matches_professor_trigger
  ON public.professor_review_course;

DROP FUNCTION IF EXISTS public.ensure_professor_review_course_relation_matches_professor();

COMMIT;
