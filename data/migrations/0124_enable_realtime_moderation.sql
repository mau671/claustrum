BEGIN;

-- Add tables to the supabase_realtime publication to enable WebSocket events
ALTER PUBLICATION supabase_realtime ADD TABLE public.professor_review;
ALTER PUBLICATION supabase_realtime ADD TABLE public.course_evaluations;
ALTER PUBLICATION supabase_realtime ADD TABLE public.professor_review_report;

COMMIT;
