-- Better Auth tables live in the better_auth schema but Better Auth generates
-- unqualified table references ("user", "session", etc.). Setting the default
-- search_path at the database level ensures every connection resolves those
-- names to better_auth."user" etc. without any application-level config.
--
-- The connection (Pool options, URL params, SET commands) fails to propagate
-- search_path through Hyperdrive's proxy. This is the only reliable fix.

ALTER DATABASE postgres SET search_path TO better_auth, public;
