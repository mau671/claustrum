-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=dd4ea82be82aa9118c80e0d438d88fe32e29b91bad635cdf2dd91152d9ea30fb
-- TEC-DATA-META generated_at_utc=2026-06-11T00:07:16.417641+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'INTRODUCCIÓN AL DISEÑO PARA LA INNOVACIÓN SOCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1899;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10785, 493, 1, 7, 102, 0, 2, E'CURSO COMUN'),
  (10786, 585, 1, 7, 102, 0, 2, E'CURSO COMUN'),
  (10787, 1899, 3, 30, 102, 3, 9, E'ELECTIVA UNICA'),
  (10788, 2051, 3, 31, 102, 9, 0, E'TRABAJO FINAL DE GRADUACION'),
  (10789, 91, 13, 2, 102, 4, 4, E'CURSO COMUN'),
  (10790, 4528, 19, 79, 102, 3, 9, E'CURSO UNICO'),
  (10791, 968, 19, 4, 102, 3, 4, E'CURSO COMUN'),
  (10792, 1205, 19, 4, 102, 3, 3, E'OPTATIVO UNICO')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[863, 7277, 7278, 7316, 7549, 7793]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17718, 10785, E'20', E'REGULAR', 25),
  (17719, 10786, E'20', E'REGULAR', 25),
  (17720, 7297, E'01', E'SEMIPRESENCIAL', 25),
  (17721, 7315, E'02', E'REGULAR', 25),
  (17722, 10787, E'01', E'SEMIPRESENCIAL', 15),
  (17723, 10788, E'01', E'SEMIPRESENCIAL', 0),
  (17724, 10789, E'60', E'SEMIPRESENCIAL', 29),
  (17725, 10790, E'50', E'REGULAR', 30),
  (17726, 10791, E'50', E'REGULAR', 24),
  (17727, 10792, E'50', E'SEMIPRESENCIAL', 40)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12895;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12919;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12562;
UPDATE public.course_offering_group SET group_type = E'REGULAR', capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12696;
UPDATE public.course_offering_group SET capacity = 33, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13049;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17674;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17679;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17681;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17682;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17688;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17689;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[9819, 12167, 12168, 12279, 12571, 12926]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18345, 17718, 191),
  (18346, 17719, 191),
  (18347, 17720, 322),
  (18348, 17721, 187),
  (18349, 12923, 616),
  (18350, 17722, 627),
  (18351, 17723, 631),
  (18352, 17723, 632),
  (18353, 12561, 628),
  (18354, 12567, 636),
  (18355, 12568, 935),
  (18356, 12572, 640),
  (18357, 12626, 231),
  (18358, 17724, 1048),
  (18359, 17694, 281),
  (18360, 17725, 1123),
  (18361, 17726, 816),
  (18362, 17727, 83),
  (18363, 12413, 17),
  (18364, 12415, 67)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[5405, 12373, 12374, 12494, 12941, 13306, 13441, 18278]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24402, 17718, 3, '09:00:00', '10:50:00', NULL),
  (24403, 17719, 5, '09:00:00', '10:50:00', NULL),
  (24404, 17720, 3, '09:30:00', '11:20:00', E'B6-03'),
  (24405, 17720, 5, '09:30:00', '11:20:00', E'B6-03'),
  (24406, 17721, 5, '09:30:00', '11:20:00', NULL),
  (24407, 12894, 3, '07:30:00', '09:20:00', E'K6-01'),
  (24408, 12898, 5, '08:30:00', '11:20:00', NULL),
  (24409, 12923, 3, '13:00:00', '16:50:00', E'K6-01'),
  (24410, 17722, 2, '18:00:00', '21:50:00', E'K6-03'),
  (24411, 17723, 1, '07:30:00', '11:20:00', NULL),
  (24412, 12573, 2, '13:00:00', '16:50:00', E'H4-01'),
  (24413, 12696, 1, '08:30:00', '11:20:00', E'D3-11'),
  (24414, 12696, 2, '09:30:00', '11:20:00', E'D3-11'),
  (24415, 13023, 4, '07:30:00', '10:20:00', E'I3-08'),
  (24416, 13032, 4, '17:00:00', '20:50:00', E'I3-08'),
  (24417, 13043, 2, '07:30:00', '11:20:00', E'I3-01'),
  (24418, 17683, 5, '18:00:00', '21:50:00', E'L-07'),
  (24419, 17724, 2, '18:00:00', '21:50:00', E'L-01'),
  (24420, 17689, 3, '16:00:00', '17:50:00', E'L-01'),
  (24421, 12040, 2, '13:00:00', '15:50:00', NULL),
  (24422, 17725, 3, '15:15:00', '17:55:00', E'A-11'),
  (24423, 17726, 4, '16:10:00', '19:45:00', E'A-09'),
  (24424, 17727, 5, '08:50:00', '11:30:00', E'E-07'),
  (24425, 11100, 3, '16:10:00', '18:50:00', E'E-04')
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = E'UTN-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17526;
UPDATE public.course_offering_meeting SET classroom = E'UTN-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17552;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5220;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6738;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15951;
UPDATE public.course_offering_meeting SET classroom = E'UTN-20', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 8310;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2601;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 9112;
UPDATE public.course_offering_meeting SET classroom = E'UTN-19', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24203;
UPDATE public.course_offering_meeting SET classroom = E'UTN-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24204;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17595;
UPDATE public.course_offering_meeting SET classroom = E'B1-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17198;
UPDATE public.course_offering_meeting SET classroom = E'B2-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17610;
UPDATE public.course_offering_meeting SET classroom = E'B2-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17611;
UPDATE public.course_offering_meeting SET classroom = E'B6-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16886;
UPDATE public.course_offering_meeting SET classroom = E'B6-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16887;
UPDATE public.course_offering_meeting SET classroom = E'B6-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16890;
UPDATE public.course_offering_meeting SET classroom = E'B6-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16891;
UPDATE public.course_offering_meeting SET classroom = E'B6-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16893;
UPDATE public.course_offering_meeting SET classroom = E'B6-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16894;
UPDATE public.course_offering_meeting SET classroom = E'I3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17836;
UPDATE public.course_offering_meeting SET classroom = E'I3-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17867;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24315;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24316;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24317;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24318;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24319;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24320;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24321;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24322;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24323;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24325;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24326;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24327;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24328;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24329;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24330;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24331;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24332;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24334;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24336;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24337;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24338;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24339;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24341;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24343;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24344;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24345;
UPDATE public.course_offering_meeting SET classroom = E'L-13', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24346;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24347;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24348;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24349;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24350;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24351;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24353;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24354;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24355;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24356;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24357;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24358;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24359;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24360;
UPDATE public.course_offering_meeting SET classroom = E'L-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24361;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24362;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24363;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16583;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16104;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4309;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14970;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 7334;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3999;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6699;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2584;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3015;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14315;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24364;
UPDATE public.course_offering_meeting SET classroom = E'L-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24366;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24367;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24368;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24369;
UPDATE public.course_offering_meeting SET classroom = E'L-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24370;
UPDATE public.course_offering_meeting SET classroom = E'L-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24372;
UPDATE public.course_offering_meeting SET classroom = E'L-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16590;
UPDATE public.course_offering_meeting SET classroom = E'L-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16591;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16592;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16593;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16594;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[1312, 13801, 16586, 16743, 16744, 16926, 17290, 17292, 17418, 17686, 17694, 17722, 17855, 17875, 24262, 24297, 24324, 24333]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
