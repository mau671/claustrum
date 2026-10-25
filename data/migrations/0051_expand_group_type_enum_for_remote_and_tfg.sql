-- 0051_expand_group_type_enum_for_remote_and_tfg.sql
-- Adds new group_type values used by TEC schedule sources.

BEGIN;

ALTER TYPE public.group_type ADD VALUE IF NOT EXISTS 'ENSEÑANZA REMOTA';
ALTER TYPE public.group_type ADD VALUE IF NOT EXISTS 'TRABAJO FINAL DE GRADUACIÓN';

COMMIT;
