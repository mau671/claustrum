-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=c99d874e80ea24b7021dca010c12df90e2f145acf12a7d2c44416b059a2f4d1a
-- TEC-DATA-META generated_at_utc=2026-05-30T07:38:15.028329+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'DISEÑO DE EXPERIMENTOS COMPUTACIONALES', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1111;
UPDATE public.course SET name = E'RECUPERACIÓN DE INFORMACIÓN TEXTUAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1131;
UPDATE public.course SET name = E'INVASIONES BIOLÓGICAS: ECOLOGÍA, MANEJO Y CONTROL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2228;
UPDATE public.course SET name = E'INSECTOS EN BIOTECNOLOGÍA', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3315;
UPDATE public.course SET name = E'PRINCIPIOS DE COMPUTACIÓN CUÁNTICA', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 53;
UPDATE public.course SET name = E'LABORATORIO DE PROYECTOS X: DISEÑO ARQUITECTÓNICO', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4828;
UPDATE public.course SET name = E'LABORATORIO DE PROYECTOS X: DISEÑO URBANO', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4829;

COMMIT;
