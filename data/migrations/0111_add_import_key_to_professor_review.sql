ALTER TABLE public.professor_review
ADD COLUMN import_key text;

CREATE INDEX idx_professor_review_import_key ON public.professor_review(professor_id, import_key) WHERE import_key IS NOT NULL;
