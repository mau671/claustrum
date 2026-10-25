-- 0058_add_taller_group_type_enum.sql

BEGIN;

ALTER TYPE public.group_type ADD VALUE IF NOT EXISTS 'TALLER';

COMMIT;
