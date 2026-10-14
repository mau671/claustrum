-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=16fc6ee84f847ea9db997f8c3226d882e228428f66aaf98af95bc56d3a94bc60
-- TEC-DATA-META generated_at_utc=2026-06-15T09:31:18.408099+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'DANZA MODERNA', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 507;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10793, 403, 3, 25, 24, 6, NULL, E'CURSO UNICO'),
  (10794, 405, 3, 25, 24, 6, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10795, 393, 3, 25, 24, 6, NULL, E'CURSO UNICO'),
  (10796, 395, 3, 25, 24, 6, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10797, 378, 3, 25, 24, 6, NULL, E'CURSO UNICO'),
  (10798, 382, 3, 25, 24, 6, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10799, 4125, 3, 67, 102, 3, 9, E'CURSO UNICO'),
  (10800, 498, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10801, 504, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10802, 507, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10803, 508, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10804, 574, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10805, 492, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10806, 493, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10807, 494, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10808, 584, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10809, 585, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10810, 586, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10811, 587, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10812, 512, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10813, 513, 19, 83, 102, 0, 3, E'CURSO COMUN'),
  (10814, 1356, 19, 12, 102, 2, 6, E'ELECTIVA UNICA')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[7393, 7439, 7919]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17728, 2031, E'90', E'REGULAR', 35),
  (17729, 7504, E'03', E'REGULAR', 32),
  (17730, 10793, E'01', E'VIRTUAL', 45),
  (17731, 10794, E'01', E'VIRTUAL', 47),
  (17732, 10795, E'01', E'VIRTUAL', 34),
  (17733, 10796, E'01', E'VIRTUAL', 35),
  (17734, 10797, E'01', E'VIRTUAL', 44),
  (17735, 10798, E'01', E'VIRTUAL', 37),
  (17736, 10799, E'01', E'SEMIPRESENCIAL', 32),
  (17737, 10800, E'50', E'REGULAR', 16),
  (17738, 10801, E'50', E'REGULAR', 16),
  (17739, 10802, E'50', E'REGULAR', 16),
  (17740, 10803, E'50', E'REGULAR', 16),
  (17741, 10804, E'50', E'REGULAR', 16),
  (17742, 10805, E'50', E'REGULAR', 16),
  (17743, 10805, E'51', E'REGULAR', 16),
  (17744, 10806, E'50', E'REGULAR', 16),
  (17745, 10807, E'50', E'REGULAR', 16),
  (17746, 10808, E'50', E'REGULAR', 16),
  (17747, 10809, E'50', E'REGULAR', 20),
  (17748, 10810, E'50', E'REGULAR', 16),
  (17749, 10811, E'50', E'REGULAR', 16),
  (17750, 10812, E'50', E'REGULAR', 16),
  (17751, 10813, E'50', E'REGULAR', 16),
  (17752, 10814, E'50', E'SEMIPRESENCIAL', 20)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET capacity = 28, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17630;
UPDATE public.course_offering_group SET capacity = 26, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17631;
UPDATE public.course_offering_group SET capacity = 36, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12822;
UPDATE public.course_offering_group SET capacity = 35, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12503;
UPDATE public.course_offering_group SET capacity = 35, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12504;
UPDATE public.course_offering_group SET group_type = E'VIRTUAL', capacity = 25, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12511;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12883;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12303;
UPDATE public.course_offering_group SET capacity = 22, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17649;
UPDATE public.course_offering_group SET capacity = 34, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17654;
UPDATE public.course_offering_group SET capacity = 34, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17656;
UPDATE public.course_offering_group SET capacity = 33, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17657;
UPDATE public.course_offering_group SET capacity = 33, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17658;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1824;
UPDATE public.course_offering_group SET capacity = 38, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17663;
UPDATE public.course_offering_group SET capacity = 44, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17665;
UPDATE public.course_offering_group SET group_type = E'REGULAR', capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12414;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12765;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[1031, 4124, 12372, 12424, 12426, 13126]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18365, 3058, 512),
  (18366, 17728, 493),
  (18367, 12482, 47),
  (18368, 12484, 1077),
  (18369, 12511, 24),
  (18370, 17729, 9),
  (18371, 17730, 31),
  (18372, 17731, 573),
  (18373, 17732, 31),
  (18374, 17733, 573),
  (18375, 17734, 31),
  (18376, 17735, 573),
  (18377, 17736, 197),
  (18378, 12365, 200),
  (18379, 10929, 478),
  (18380, 9989, 477),
  (18381, 6409, 487),
  (18382, 66, 489),
  (18383, 4616, 488),
  (18384, 660, 525),
  (18385, 10214, 513),
  (18386, 1824, 507),
  (18387, 7724, 524),
  (18388, 17737, 844),
  (18389, 17738, 844),
  (18390, 17739, 845),
  (18391, 17740, 845),
  (18392, 17741, 846),
  (18393, 17742, 846),
  (18394, 17743, 847),
  (18395, 17745, 847),
  (18396, 17747, 846),
  (18397, 17749, 847),
  (18398, 17750, 849),
  (18399, 17751, 849),
  (18400, 13110, 420),
  (18401, 17752, 425),
  (18402, 12406, 49),
  (18403, 12413, 1151),
  (18404, 12414, 19)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[12377, 12380, 12603, 12609, 12621, 12625, 12629, 12630, 12642, 12647, 12649, 12743, 12745, 12793, 12795, 12856, 12858, 12885, 13510, 13526, 18363]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24426, 17728, 3, '09:00:00', '10:50:00', E'UTN-01'),
  (24427, 17728, 5, '09:00:00', '10:50:00', E'UTN-01'),
  (24428, 17729, 2, '07:30:00', '11:20:00', E'D1-01'),
  (24429, 12872, 3, '13:00:00', '15:50:00', E'G17-01'),
  (24430, 17730, 1, '17:00:00', '20:50:00', NULL),
  (24431, 17730, 3, '17:00:00', '20:50:00', NULL),
  (24432, 17731, 2, '17:00:00', '20:50:00', NULL),
  (24433, 17731, 4, '17:00:00', '20:50:00', NULL),
  (24434, 17732, 1, '17:00:00', '20:50:00', NULL),
  (24435, 17732, 3, '17:00:00', '20:50:00', NULL),
  (24436, 17733, 2, '17:00:00', '20:50:00', NULL),
  (24437, 17733, 4, '17:00:00', '20:50:00', NULL),
  (24438, 17734, 1, '17:00:00', '20:50:00', NULL),
  (24439, 17734, 3, '17:00:00', '20:50:00', NULL),
  (24440, 17735, 2, '17:00:00', '20:50:00', NULL),
  (24441, 17735, 4, '17:00:00', '20:50:00', NULL),
  (24442, 17736, 2, '07:30:00', '09:20:00', E'C1-09'),
  (24443, 17736, 4, '07:30:00', '09:20:00', E'C1-09'),
  (24444, 13009, 4, '13:00:00', '16:50:00', E'I3-07'),
  (24445, 13033, 3, '07:30:00', '11:20:00', E'I3-08'),
  (24446, 12722, 5, '13:00:00', '16:50:00', E'K2-05'),
  (24324, 17683, 5, '18:00:00', '20:50:00', E'L-07'),
  (24447, 17737, 3, '14:20:00', '16:05:00', E'T-01'),
  (24448, 17738, 4, '09:45:00', '11:30:00', E'T-01'),
  (24449, 17739, 4, '07:00:00', '08:45:00', E'C-02'),
  (24450, 17740, 3, '16:10:00', '17:55:00', E'C-02'),
  (24451, 17741, 3, '09:45:00', '11:30:00', E'GNS-01'),
  (24452, 17742, 2, '07:00:00', '08:45:00', E'PSC-01'),
  (24453, 17743, 4, '07:00:00', '08:45:00', E'PSC-01'),
  (24454, 17744, 3, '07:00:00', '08:45:00', E'GNS-01'),
  (24455, 17745, 3, '12:30:00', '14:15:00', E'GNS-01'),
  (24456, 17746, 2, '12:30:00', '14:15:00', E'GNS-01'),
  (24457, 17747, 3, '16:10:00', '17:55:00', E'GNS-01'),
  (24458, 17748, 1, '09:45:00', '11:30:00', E'GNS-01'),
  (24459, 17749, 4, '12:30:00', '14:15:00', E'GNS-01'),
  (24460, 17750, 3, '09:45:00', '11:30:00', E'C-01'),
  (24461, 17751, 2, '12:30:00', '14:15:00', E'T-01'),
  (24462, 17752, 3, '16:10:00', '19:45:00', E'E-08'),
  (24463, 12466, 2, '17:30:00', '20:15:00', NULL),
  (24464, 12473, 5, '17:30:00', '20:15:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = E'LAT-16', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17537;
UPDATE public.course_offering_meeting SET classroom = E'LAT-16', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17542;
UPDATE public.course_offering_meeting SET classroom = E'LAT-16', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17546;
UPDATE public.course_offering_meeting SET classroom = E'LAT-16', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17555;
UPDATE public.course_offering_meeting SET classroom = E'B1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17591;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17600;
UPDATE public.course_offering_meeting SET classroom = E'B1-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24236;
UPDATE public.course_offering_meeting SET classroom = E'D1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17191;
UPDATE public.course_offering_meeting SET classroom = E'D1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17192;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17199;
UPDATE public.course_offering_meeting SET classroom = E'D3-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16957;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16964;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16965;
UPDATE public.course_offering_meeting SET classroom = E'D3-15', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11885;
UPDATE public.course_offering_meeting SET classroom = E'D3-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10977;
UPDATE public.course_offering_meeting SET classroom = E'D3-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 539;
UPDATE public.course_offering_meeting SET classroom = E'D3-15', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14350;
UPDATE public.course_offering_meeting SET classroom = E'D3-15', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6287;
UPDATE public.course_offering_meeting SET classroom = E'D3-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1740;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11970;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14578;
UPDATE public.course_offering_meeting SET classroom = E'H4-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17281;
UPDATE public.course_offering_meeting SET classroom = E'H4-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17282;
UPDATE public.course_offering_meeting SET classroom = E'H4-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17291;
UPDATE public.course_offering_meeting SET classroom = E'F5-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17021;
UPDATE public.course_offering_meeting SET classroom = E'F5-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17022;
UPDATE public.course_offering_meeting SET classroom = E'C1-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17023;
UPDATE public.course_offering_meeting SET classroom = E'C1-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17024;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17330;
UPDATE public.course_offering_meeting SET classroom = E'I1-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17332;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16560;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16561;
UPDATE public.course_offering_meeting SET classroom = E'G18-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17033;
UPDATE public.course_offering_meeting SET classroom = E'G18-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17034;
UPDATE public.course_offering_meeting SET classroom = E'K2-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17450;
UPDATE public.course_offering_meeting SET classroom = E'J01-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17507;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[911, 4010, 5619, 16243, 17037, 17089, 17091, 17154, 17445, 17657, 17841, 17865, 17977, 24295, 24298, 24396, 24418]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
