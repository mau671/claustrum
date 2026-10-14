-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=f3c2c09b3d1dbe813d67dd39de62cdd4f34299a9dc13650aee09f0ddee46e6f5
-- TEC-DATA-META generated_at_utc=2026-06-22T09:25:21.595028+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'INGENIERÍA DE TRANSITO Y SEGURIDAD VIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4023;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10815, 3229, 3, 41, 102, 3, 9, E'ELECTIVA UNICA'),
  (10816, 352, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10817, 358, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10818, 360, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10819, 365, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10820, 370, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10821, 397, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10822, 374, 3, 25, 25, 4, NULL, E'CURSO UNICO'),
  (10823, 3408, 3, 45, 102, 4, 9, E'ELECTIVA UNICA'),
  (10824, 4023, 3, 64, 113, 3, NULL, E'ELECTIVA UNICA'),
  (10825, 4024, 3, 64, 113, 5, NULL, E'CURSO UNICO'),
  (10826, 4039, 3, 64, 113, 4, NULL, E'CURSO UNICO'),
  (10827, 1249, 13, 10, 102, 3, 4, E'CURSO COMUN')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[7836]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17753, 10815, E'01', E'REGULAR', 15),
  (17754, 10816, E'01', E'VIRTUAL', 32),
  (17755, 10817, E'01', E'VIRTUAL', 32),
  (17756, 10818, E'01', E'VIRTUAL', 32),
  (17757, 10819, E'01', E'VIRTUAL', 32),
  (17758, 10820, E'01', E'VIRTUAL', 32),
  (17759, 10821, E'01', E'VIRTUAL', 32),
  (17760, 10822, E'01', E'VIRTUAL', 32),
  (17761, 10823, E'01', E'SEMIPRESENCIAL', 10),
  (17762, 10824, E'01', E'VIRTUAL', 16),
  (17763, 10825, E'01', E'VIRTUAL', 16),
  (17764, 10826, E'01', E'VIRTUAL', 16),
  (17765, 7585, E'06', E'REGULAR', 23),
  (17766, 10827, E'60', E'REGULAR', 24),
  (17767, 10756, E'61', E'REGULAR', 24)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12891;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12892;
UPDATE public.course_offering_group SET capacity = 25, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12896;
UPDATE public.course_offering_group SET capacity = 20, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12905;
UPDATE public.course_offering_group SET group_type = E'VIRTUAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17722;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12951;
UPDATE public.course_offering_group SET capacity = 17, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12104;
UPDATE public.course_offering_group SET capacity = 17, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12105;
UPDATE public.course_offering_group SET capacity = 17, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12106;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12696;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12712;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', capacity = 35, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12713;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12722;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12731;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12732;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[12683, 12925, 12998]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18405, 11807, 151),
  (18406, 11808, 138),
  (18407, 11809, 154),
  (18408, 11810, 151),
  (18409, 17753, 720),
  (18410, 11839, 157),
  (18411, 11840, 154),
  (18412, 11841, 140),
  (18413, 11842, 141),
  (18414, 11843, 160),
  (18415, 11844, 139),
  (18416, 11845, 142),
  (18417, 11846, 140),
  (18418, 11847, 157),
  (18419, 11848, 142),
  (18420, 11850, 145),
  (18421, 11851, 148),
  (18422, 11852, 152),
  (18423, 11853, 144),
  (18424, 11854, 143),
  (18425, 11855, 144),
  (18426, 11857, 144),
  (18427, 11858, 153),
  (18428, 11859, 152),
  (18429, 11860, 144),
  (18430, 11861, 146),
  (18431, 11862, 144),
  (18432, 11863, 146),
  (18433, 11864, 144),
  (18434, 11865, 148),
  (18435, 11866, 146),
  (18436, 11867, 147),
  (18437, 11869, 147),
  (18438, 11870, 146),
  (18439, 11871, 153),
  (18440, 11872, 145),
  (18441, 11873, 143),
  (18442, 11874, 146),
  (18443, 11875, 145),
  (18444, 11876, 149),
  (18445, 11879, 153),
  (18446, 11880, 152),
  (18447, 11881, 146),
  (18448, 11885, 145),
  (18449, 11886, 155),
  (18450, 11887, 154),
  (18451, 11888, 165),
  (18452, 11889, 142),
  (18453, 11890, 156),
  (18454, 11891, 158),
  (18455, 11892, 162),
  (18456, 11893, 138),
  (18457, 11894, 161),
  (18458, 11895, 160),
  (18459, 11896, 142),
  (18460, 11897, 160),
  (18461, 11898, 162),
  (18462, 11899, 159),
  (18463, 11900, 156),
  (18464, 11901, 157),
  (18465, 11902, 142),
  (18466, 11903, 160),
  (18467, 11904, 159),
  (18468, 11905, 159),
  (18469, 11906, 140),
  (18470, 11907, 140),
  (18471, 11908, 159),
  (18472, 11909, 163),
  (18473, 11910, 157),
  (18474, 11911, 157),
  (18475, 11912, 158),
  (18476, 11913, 162),
  (18477, 11915, 151),
  (18478, 11917, 153),
  (18479, 11919, 141),
  (18480, 11920, 163),
  (18481, 11921, 163),
  (18482, 11922, 164),
  (18483, 11923, 139),
  (18484, 11924, 139),
  (18485, 11925, 139),
  (18486, 17754, 10),
  (18487, 17755, 1035),
  (18488, 17756, 345),
  (18489, 17757, 592),
  (18490, 17758, 572),
  (18491, 17759, 923),
  (18492, 17760, 596),
  (18493, 17761, 720),
  (18494, 12098, 79),
  (18495, 12099, 741),
  (18496, 17762, 1207),
  (18497, 17763, 900),
  (18498, 17764, 900),
  (18499, 17765, 228),
  (18500, 12634, 235),
  (13007, 12641, 246),
  (18501, 17766, 278),
  (18502, 17767, 264),
  (18503, 12036, 166),
  (18504, 12037, 166),
  (18505, 12038, 166),
  (18506, 12039, 165),
  (18507, 12040, 165),
  (18508, 12041, 165),
  (18509, 17706, 464),
  (18510, 17711, 465),
  (18511, 17712, 35),
  (18512, 9656, 432),
  (18513, 1555, 429),
  (18514, 12048, 141),
  (18515, 12049, 150),
  (18516, 12052, 150),
  (18517, 12053, 150),
  (18518, 12054, 150),
  (18519, 12055, 150),
  (18520, 12056, 158),
  (18521, 12057, 141),
  (18522, 12058, 161)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[4251, 6105, 12338, 12339, 13046, 13304, 13305, 13313, 13378, 18239]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24465, 17753, 1, '09:30:00', '12:20:00', NULL),
  (24466, 11825, 5, '09:30:00', '11:20:00', E'B5-03'),
  (24467, 11917, 2, '13:00:00', '15:50:00', E'F5-04'),
  (24468, 8459, 4, '13:00:00', '15:50:00', E'B2-03'),
  (24469, 12908, 2, '08:30:00', '11:20:00', E'K6-05'),
  (24470, 12919, 4, '07:30:00', '10:20:00', E'K6-04'),
  (24471, 12920, 2, '13:00:00', '15:50:00', E'K6-04'),
  (24472, 12922, 4, '13:00:00', '16:50:00', E'K6-03'),
  (24473, 12930, 3, '18:00:00', '19:50:00', NULL),
  (24474, 12931, 5, '18:00:00', '19:50:00', NULL),
  (24475, 12932, 3, '18:00:00', '21:50:00', NULL),
  (24476, 17754, 1, '17:00:00', '20:50:00', NULL),
  (24477, 17754, 3, '17:00:00', '20:50:00', NULL),
  (24478, 17755, 2, '17:00:00', '20:50:00', NULL),
  (24479, 17755, 4, '17:00:00', '20:50:00', NULL),
  (24480, 17756, 1, '17:00:00', '20:50:00', NULL),
  (24481, 17756, 3, '17:00:00', '20:50:00', NULL),
  (24482, 17757, 2, '17:00:00', '20:50:00', NULL),
  (24483, 17757, 4, '17:00:00', '20:50:00', NULL),
  (24484, 17758, 1, '17:00:00', '20:50:00', NULL),
  (24485, 17758, 3, '17:00:00', '20:50:00', NULL),
  (24486, 17759, 2, '17:00:00', '20:50:00', NULL),
  (24487, 17759, 4, '17:00:00', '20:50:00', NULL),
  (24488, 17760, 2, '17:00:00', '20:50:00', NULL),
  (24489, 17760, 4, '17:00:00', '20:50:00', NULL),
  (24490, 17761, 5, '18:00:00', '20:50:00', E'F5-05'),
  (24491, 17762, 2, '17:00:00', '20:50:00', NULL),
  (24492, 17763, 1, '17:00:00', '20:50:00', NULL),
  (24493, 17764, 1, '17:00:00', '20:50:00', NULL),
  (24494, 17765, 3, '13:00:00', '16:50:00', E'D10-23'),
  (24495, 12634, 5, '07:30:00', '11:20:00', E'D10-24'),
  (24496, 17766, 3, '09:30:00', '11:20:00', E'L-05'),
  (24497, 17766, 5, '09:30:00', '11:20:00', E'L-05'),
  (24498, 17767, 2, '09:30:00', '11:20:00', E'L-05'),
  (24499, 17767, 4, '09:30:00', '11:20:00', E'L-05'),
  (24500, 539, 4, '09:45:00', '11:30:00', E'A-05'),
  (24501, 7216, 2, '16:10:00', '17:55:00', E'E-06'),
  (24502, 7216, 3, '16:10:00', '17:55:00', E'A-05'),
  (24503, 5038, 4, '07:00:00', '09:40:00', E'A-05'),
  (24504, 3562, 2, '08:50:00', '11:30:00', E'E-06'),
  (24505, 13108, 5, '07:55:00', '09:40:00', E'E-09'),
  (24506, 6840, 5, '12:30:00', '16:05:00', E'LP-01')
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16637;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16638;
UPDATE public.course_offering_meeting SET classroom = E'K6-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17687;
UPDATE public.course_offering_meeting SET classroom = E'K6-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17688;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24410;
UPDATE public.course_offering_meeting SET classroom = E'D10-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17436;
UPDATE public.course_offering_meeting SET classroom = E'L-11', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24353;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24354;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24362;
UPDATE public.course_offering_meeting SET classroom = E'L-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24363;
UPDATE public.course_offering_meeting SET classroom = E'L-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24421;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[1472, 3531, 4012, 10255, 12380, 15534, 16332, 16429, 16598, 17354, 17405, 17707, 17718, 17719, 17721, 17724, 17729, 17730, 17731, 17830, 17949]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
