BEGIN;

ALTER PUBLICATION supabase_realtime ADD TABLE public.user_feedback;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

COMMIT;
