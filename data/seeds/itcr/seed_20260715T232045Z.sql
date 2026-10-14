-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=7a96f7af9e83bc6ec9c2ecc81676bbf0759758f71d0816c51fd79c6c4e420cf4
-- TEC-DATA-META generated_at_utc=2026-07-15T23:20:45.634463+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course AS t
SET
  name = nv.name::TEXT,
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW()
FROM (VALUES
  (1699, E'JUEGOS MATEMÁTICOS')
) AS nv (id, name)
WHERE t.id = nv.id::BIGINT;

-- table: professor
INSERT INTO public.professor
  (id, full_name)
VALUES
  (1332, E'TORRES QUIROS CINDY')
ON CONFLICT (full_name) DO NOTHING;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10868, 965, 1, 2, 101, 4, 12, E'CURSO COMUN'),
  (10869, 965, 1, 2, 102, 4, 12, E'CURSO COMUN'),
  (10870, 968, 1, 4, 101, 3, 4, E'CURSO COMUN'),
  (10871, 968, 1, 4, 102, 3, 4, E'CURSO COMUN'),
  (10872, 1590, 1, 23, 101, 16, 48, E'TRABAJO FINAL DE GRADUACION'),
  (10873, 155, 1, 14, 102, 3, 3, E'CURSO UNICO'),
  (10874, 4238, 3, 73, 113, 6, 29, E'CURSO UNICO'),
  (10875, 4199, 3, 72, 101, 3, 6, E'CURSO UNICO'),
  (10876, 4200, 3, 72, 102, 3, 6, E'CURSO UNICO'),
  (10877, 1699, 3, 29, 25, 0, 3, E'CURSO UNICO'),
  (10878, 3892, 3, 22, 53, 4, 16, E'CURSO UNICO'),
  (10879, 1205, 13, 4, 102, 3, 3, E'OPTATIVO UNICO'),
  (10880, 610, 13, 9, 101, 3, 9, E'CURSO COMUN'),
  (10881, 155, 13, 14, 102, 3, 3, E'CURSO UNICO'),
  (10882, 155, 19, 14, 101, 3, 3, E'CURSO UNICO'),
  (10883, 155, 19, 14, 102, 3, 3, E'CURSO UNICO')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17811, 10868, E'20', E'VIRTUAL', 38),
  (17812, 10869, E'20', E'VIRTUAL', 21),
  (17813, 10870, E'20', E'VIRTUAL', 24),
  (17814, 10871, E'20', E'VIRTUAL', 24),
  (17815, 10872, E'20', E'VIRTUAL', 10),
  (17816, 10873, E'20', E'VIRTUAL', 40),
  (17817, 10874, E'01', E'VIRTUAL', 25),
  (17818, 10875, E'01', E'SEMIPRESENCIAL', 15),
  (17819, 10876, E'01', E'REGULAR', 20),
  (17820, 10877, E'01', E'REGULAR', 32),
  (17821, 10878, E'01', E'TUTORIA', 5),
  (17822, 10879, E'60', E'SEMIPRESENCIAL', 40),
  (17823, 10880, E'60', E'VIRTUAL', 27),
  (17824, 10881, E'60', E'VIRTUAL', 40),
  (17825, 10882, E'50', E'VIRTUAL', 40),
  (17826, 10883, E'50', E'VIRTUAL', 40)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18626, 17811, 24),
  (18627, 17812, 24),
  (18628, 17813, 90),
  (18629, 17814, 90),
  (18630, 17815, 66),
  (18631, 17816, 476),
  (18632, 17817, 1117),
  (18633, 17818, 438),
  (18634, 17819, 1332),
  (18635, 17820, 518),
  (18636, 17821, 2),
  (13007, 12641, 246),
  (18637, 17822, 84),
  (18638, 17823, 258),
  (18639, 17824, 470),
  (18640, 17825, 476),
  (18641, 17826, 82)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24610, 17811, 1, '17:00:00', '20:50:00', NULL),
  (24611, 17812, 3, '17:00:00', '20:50:00', NULL),
  (24612, 17813, 4, '07:00:00', '10:50:00', NULL),
  (24613, 17814, 4, '07:00:00', '10:50:00', NULL),
  (24614, 17815, 3, '17:00:00', '18:50:00', NULL),
  (24615, 17816, 3, '13:00:00', '15:50:00', NULL),
  (24616, 17817, 6, '07:30:00', '11:20:00', NULL),
  (24617, 17818, 1, '17:00:00', '18:50:00', NULL),
  (24618, 17819, 2, '17:00:00', '21:50:00', NULL),
  (24619, 17820, 1, '15:00:00', '17:50:00', E'C1-08'),
  (24620, 17821, 6, '07:30:00', '12:20:00', NULL),
  (24621, 17822, 1, '08:30:00', '11:20:00', E'L-14'),
  (24622, 17823, 3, '13:00:00', '16:50:00', E'L-03'),
  (24623, 17824, 4, '07:30:00', '10:20:00', NULL),
  (24624, 17825, 1, '08:50:00', '11:30:00', NULL),
  (24625, 17826, 2, '07:55:00', '10:35:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();

COMMIT;
