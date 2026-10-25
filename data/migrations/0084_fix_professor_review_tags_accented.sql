BEGIN;

ALTER TABLE public.professor_review
DROP CONSTRAINT IF EXISTS professor_review_tags_allowed_check;

ALTER TABLE public.professor_review
ADD CONSTRAINT professor_review_tags_allowed_check
  CHECK (
    tags <@ ARRAY[
      'Da buena retroalimentación',
      'Tomaría su clase nuevamente',
      'Brinda apoyo',
      'Explica con claridad',
      'Exámenes retadores',
      'Proyecto útil'
    ]::TEXT[]
  );

COMMIT;
