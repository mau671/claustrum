-- Revert the database-level search_path change from 0078.
-- The search_path should be set at the connection/application level instead.

ALTER DATABASE postgres RESET search_path;
