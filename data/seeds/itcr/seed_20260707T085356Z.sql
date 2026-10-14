-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=f29b0b79e97989124a9fecda50fa972f1a72f136809cece4e9044deb06b01588
-- TEC-DATA-META generated_at_utc=2026-07-07T08:53:56.649982+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course AS t
SET
  name = nv.name::TEXT,
  created_at = nv.created_at::TIMESTAMPTZ,
  updated_at = nv.updated_at::TIMESTAMPTZ,
  is_active = TRUE,
  deactivated_at = NULL
FROM (VALUES
  (4931, E'INTRODUCCIÓN A LA COMPUTACIÓN HETEROGÉNEA', '2026-04-24T10:06:18.124049+00:00', '2026-05-24T17:54:42.680427+00:00')
) AS nv (id, name, created_at, updated_at)
WHERE t.id = nv.id::BIGINT;

-- table: professor
INSERT INTO public.professor
  (id, full_name)
VALUES
  (1327, E'APU SANCHEZ JIMMY GERARDO'),
  (1328, E'CHINCHILLA VARGAS ERICK GUSTAVO'),
  (1329, E'COTO CALDERON ROLEN JESUS'),
  (1330, E'GONZALEZ VEGA MICHAEL ALBERTO'),
  (1331, E'MARIN VARGAS FABIAN')
ON CONFLICT (full_name) DO NOTHING;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10863, 1206, 3, 2, 102, 3, 9, E'CURSO COMUN'),
  (10864, 3862, 3, 21, 25, 4, 32, E'ELECTIVA UNICA'),
  (10865, 3876, 3, 21, 25, 4, 32, E'ELECTIVA UNICA'),
  (10866, 1537, 3, 21, 25, 4, 32, E'CURSO UNICO'),
  (10867, 4931, 19, 12, 102, 4, 12, E'ELECTIVA UNICA')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[7312, 7918]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17806, 10863, E'01', E'REGULAR', 32),
  (17807, 10864, E'01', E'SEMIPRESENCIAL', 20),
  (17808, 10865, E'01', E'SEMIPRESENCIAL', 20),
  (17809, 10866, E'01', E'SEMIPRESENCIAL', 20),
  (17810, 10867, E'50', E'VIRTUAL', 30)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group AS t
SET
  capacity = nv.capacity::INTEGER,
  is_active = TRUE,
  deactivated_at = NULL
FROM (VALUES
  (11805, 23),
  (17718, 24),
  (17719, 21),
  (11809, 30),
  (7855, 30),
  (10518, 30),
  (3058, 30),
  (11087, 30),
  (2952, 28),
  (17728, 30),
  (3484, 30),
  (4556, 30),
  (6299, 30),
  (192, 30),
  (12815, 28),
  (12816, 28),
  (12817, 28),
  (12818, 28),
  (12819, 28),
  (12820, 28),
  (12821, 28),
  (12822, 24),
  (12823, 26),
  (12824, 26),
  (12825, 28),
  (12826, 22),
  (12827, 22),
  (12828, 22),
  (12829, 28),
  (12487, 31),
  (12491, 31),
  (12493, 31),
  (12495, 31),
  (17642, 31),
  (12510, 30),
  (12512, 30),
  (17645, 30),
  (17729, 31),
  (12227, 26),
  (12232, 27),
  (12235, 27),
  (12239, 25),
  (12247, 23),
  (11813, 24),
  (11814, 24),
  (11815, 23),
  (11816, 17),
  (11817, 23),
  (11818, 19),
  (11819, 22),
  (11820, 24),
  (11821, 23),
  (11822, 23),
  (11824, 23),
  (11827, 23),
  (11836, 22),
  (11838, 18),
  (12249, 24),
  (12250, 19),
  (12251, 18),
  (12252, 17),
  (12253, 19),
  (12255, 17),
  (12258, 17),
  (12259, 24),
  (12261, 22),
  (12263, 23),
  (12265, 23),
  (12266, 23),
  (12267, 23),
  (12268, 22),
  (12272, 24),
  (12273, 22),
  (12275, 23),
  (12276, 23),
  (12277, 24),
  (12278, 24),
  (11842, 31),
  (11844, 25),
  (11849, 31),
  (11853, 31),
  (11856, 31),
  (11860, 31),
  (11863, 31),
  (11866, 31),
  (11872, 31),
  (11883, 31),
  (11897, 30),
  (11902, 25),
  (11904, 31),
  (11907, 31),
  (11920, 31),
  (11922, 31),
  (12920, 18),
  (12922, 19),
  (12923, 19),
  (17722, 7),
  (12927, 5),
  (12928, 11),
  (12930, 13),
  (12931, 9),
  (12932, 12),
  (11936, 34),
  (11937, 10),
  (11938, 10),
  (11939, 10),
  (12083, 44),
  (11952, 52),
  (11956, 12),
  (11957, 12),
  (12084, 24),
  (11959, 26),
  (11960, 17),
  (11961, 17),
  (11962, 22),
  (12087, 26),
  (12088, 26),
  (12950, 30),
  (12951, 30),
  (12952, 30),
  (17787, 30),
  (12963, 20),
  (12964, 20),
  (12978, 25),
  (12985, 35),
  (12989, 15),
  (12990, 15),
  (3586, 42),
  (7206, 42),
  (7057, 42),
  (5077, 42),
  (9128, 38),
  (5398, 20),
  (2700, 20),
  (1329, 41),
  (2080, 42),
  (12103, 19),
  (12106, 16),
  (1824, 39),
  (9875, 39),
  (8935, 36),
  (2116, 67),
  (7496, 39),
  (5736, 39),
  (809, 69),
  (9816, 39),
  (2023, 26),
  (10305, 36),
  (4270, 39),
  (4173, 39),
  (12635, 29),
  (12640, 29),
  (12643, 29),
  (12654, 35),
  (12663, 9),
  (12664, 27),
  (12665, 9),
  (12668, 27),
  (12670, 29),
  (12672, 27),
  (12675, 29),
  (12678, 7),
  (12681, 22),
  (12685, 27),
  (12686, 28),
  (12689, 9),
  (12690, 24),
  (12692, 5),
  (12693, 2),
  (12694, 7),
  (12695, 5),
  (12696, 7),
  (12701, 0),
  (12703, 17),
  (12704, 19),
  (12705, 19),
  (12706, 18),
  (12707, 0),
  (12708, 1),
  (12710, 16),
  (12711, 15),
  (12712, 8),
  (13015, 21),
  (13016, 31),
  (13025, 23),
  (13028, 23),
  (13033, 35),
  (13036, 23),
  (13040, 36),
  (13041, 36),
  (13042, 36),
  (13043, 37),
  (13044, 25),
  (13045, 30),
  (13046, 35),
  (13048, 30),
  (13049, 28),
  (13050, 9),
  (13051, 15),
  (13052, 14),
  (13053, 13),
  (13054, 0),
  (13055, 0),
  (13056, 22),
  (13059, 0),
  (13060, 30),
  (13061, 29),
  (13062, 15),
  (13063, 30),
  (12369, 39),
  (12027, 15),
  (12034, 24),
  (12738, 24),
  (12386, 20),
  (13066, 20),
  (12145, 24),
  (12453, 19),
  (12456, 22),
  (12457, 24),
  (12459, 19),
  (12461, 23)
) AS nv (id, capacity)
WHERE t.id = nv.id::BIGINT;
UPDATE public.course_offering_group AS t
SET
  group_type = nv.group_type::group_type,
  is_active = TRUE,
  deactivated_at = NULL
FROM (VALUES
  (17753, E'VIRTUAL'),
  (12067, E'REGULAR'),
  (12970, E'REGULAR'),
  (12565, E'SEMIPRESENCIAL')
) AS nv (id, group_type)
WHERE t.id = nv.id::BIGINT;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[11928, 12274, 12660, 12661, 13125]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18593, 2952, 519),
  (18594, 12821, 46),
  (18595, 17806, 71),
  (18596, 12523, 71),
  (18597, 12276, 1331),
  (18598, 11931, 951),
  (18599, 12950, 1328),
  (18600, 12966, 1330),
  (18601, 12968, 1329),
  (18602, 12992, 400),
  (18603, 660, 481),
  (18604, 806, 525),
  (18605, 7705, 507),
  (18606, 8931, 520),
  (18607, 17807, 1327),
  (18608, 17808, 585),
  (18609, 17809, 1120),
  (18610, 12619, 91),
  (18611, 12620, 83),
  (18612, 11683, 1160),
  (18613, 6885, 230),
  (18614, 9715, 254),
  (18615, 5783, 227),
  (18616, 3783, 228),
  (18617, 8114, 256),
  (13007, 12641, 246),
  (18618, 12657, 243),
  (18619, 12659, 232),
  (18620, 13066, 262),
  (18621, 17800, 1069),
  (18622, 17740, 1069),
  (18623, 17810, 419),
  (18624, 5569, 869),
  (18625, 12166, 869)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[2369, 3185, 3424, 7024, 8104, 8706, 8836, 10432, 12254, 12379, 12490, 12543, 12598, 12601, 12631, 12639, 12646, 12897, 12988, 13024, 13025, 13193, 13343, 13369, 13449, 13525, 18338, 18384, 18391, 18549, 18565, 18583]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24582, 17806, 2, '13:00:00', '16:50:00', E'F1-04'),
  (24583, 12067, 1, '07:30:00', '11:20:00', E'G1-04'),
  (24584, 12069, 3, '07:30:00', '11:20:00', E'G1-04'),
  (24585, 12237, 5, '19:00:00', '20:50:00', E'B3-07'),
  (24586, 12935, 3, '15:00:00', '16:50:00', E'K1-07'),
  (24587, 12956, 2, '17:00:00', '18:50:00', E'K1-10'),
  (24588, 12956, 4, '17:00:00', '18:50:00', E'K1-10'),
  (24589, 12966, 5, '17:00:00', '18:50:00', E'K1-16'),
  (24590, 12968, 1, '17:00:00', '18:50:00', E'K1-07'),
  (24591, 12968, 3, '17:00:00', '18:50:00', E'K1-07'),
  (24592, 12973, 1, '07:30:00', '09:20:00', E'K1-18'),
  (24593, 12973, 3, '07:30:00', '09:20:00', E'K1-18'),
  (24594, 12992, 2, '13:00:00', '16:50:00', E'K1-11'),
  (24595, 17807, 3, '18:00:00', '21:50:00', NULL),
  (24596, 17807, 5, '18:00:00', '21:50:00', NULL),
  (24597, 17808, 3, '18:00:00', '21:50:00', NULL),
  (24598, 17808, 6, '07:30:00', '11:20:00', NULL),
  (24599, 17809, 4, '18:00:00', '21:50:00', NULL),
  (24600, 17809, 6, '07:30:00', '11:20:00', NULL),
  (24601, 12375, 3, '07:55:00', '10:35:00', E'E-06'),
  (24602, 13066, 4, '12:30:00', '16:05:00', E'LAB-03'),
  (24603, 17800, 1, '16:10:00', '17:55:00', E'C-02'),
  (24604, 539, 4, '08:50:00', '11:30:00', E'A-06'),
  (24605, 3249, 3, '12:30:00', '15:10:00', NULL),
  (24606, 17810, 5, '16:10:00', '19:45:00', NULL),
  (24607, 9422, 1, '07:00:00', '10:35:00', E'E-07'),
  (24608, 1747, 4, '12:30:00', '15:10:00', E'A-09'),
  (24609, 12468, 3, '17:30:00', '20:15:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting AS t
SET
  classroom = nv.classroom::TEXT,
  is_active = TRUE,
  deactivated_at = NULL
FROM (VALUES
  (17192, E'D3-11'),
  (17211, E'K2-05'),
  (17735, E'K1-07'),
  (17736, E'K1-07'),
  (17779, E'K1-16'),
  (24278, E'H4-01'),
  (17423, E'D10-01'),
  (17429, E'D10-21'),
  (17479, E'A-15'),
  (16148, E'A-05'),
  (17107, E'J01-03'),
  (17108, E'J01-03')
) AS nv (id, classroom)
WHERE t.id = nv.id::BIGINT;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[9314, 13692, 14115, 14539, 16446, 16447, 16622, 16624, 16877, 16921, 17040, 17156, 17381, 17382, 17734, 17764, 17778, 17782, 17790, 17791, 17821, 17822, 17899, 17976, 24500, 24569]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
