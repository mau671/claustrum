-- 0023_add_rn_group_type.sql
-- Add RN as a valid value for group_type enum.

ALTER TYPE public.group_type ADD VALUE IF NOT EXISTS 'RN';
