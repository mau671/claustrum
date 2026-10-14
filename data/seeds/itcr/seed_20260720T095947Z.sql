-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=b8cce65911a2222b9f880086fe99f813d57f4f646560169a48f3a75d8dc950e6
-- TEC-DATA-META generated_at_utc=2026-07-20T09:59:47.564795+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (13007, 12641, 246)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;

COMMIT;
