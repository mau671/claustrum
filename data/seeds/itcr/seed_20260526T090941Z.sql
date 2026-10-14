-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=8374b21bff2f39b21c7e13dcadd3c32a00747b72eb945c28b0f15dac523d50ff
-- TEC-DATA-META generated_at_utc=2026-05-26T09:09:41.741622+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (7206, 1357, 1, 5, 102, 3, 4, E'CURSO UNICO'),
  (7207, 268, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7208, 2605, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7209, 2620, 3, 36, 102, 3, 6, E'CURSO UNICO'),
  (7210, 2598, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7211, 2607, 3, 36, 102, 3, 7, E'CURSO UNICO'),
  (7212, 2608, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7213, 2621, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7214, 2637, 3, 36, 102, 3, 4, E'CURSO UNICO'),
  (7215, 2622, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7216, 2623, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7217, 2612, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7218, 2628, 3, 36, 102, 3, 4, E'CURSO UNICO'),
  (7219, 2638, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7220, 2639, 3, 36, 102, 2, 5, E'CURSO UNICO'),
  (7221, 2640, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7222, 2625, 3, 36, 102, 3, 9, E'CURSO UNICO'),
  (7223, 2729, 3, 36, 102, 3, 9, E'ELECTIVA UNICA'),
  (7224, 3061, 3, 38, 102, 3, 3, E'CURSO UNICO'),
  (7225, 3077, 3, 38, 102, 2, 4, E'CURSO UNICO'),
  (7226, 3007, 3, 38, 102, 4, 4, E'ELECTIVA UNICA'),
  (7227, 3075, 3, 38, 102, 4, 4, E'ELECTIVA UNICA'),
  (7228, 3078, 3, 38, 102, 4, 4, E'CURSO UNICO'),
  (7229, 3079, 3, 38, 102, 4, 4, E'CURSO UNICO'),
  (7230, 3082, 3, 38, 102, 4, 4, E'ELECTIVA UNICA'),
  (7231, 3085, 3, 38, 102, 4, 4, E'ELECTIVA UNICA'),
  (7232, 3135, 3, 39, 102, 2, 3, E'CURSO UNICO'),
  (7233, 3269, 3, 42, 102, 2, 3, E'CURSO UNICO'),
  (7234, 3260, 3, 42, 102, 3, 9, E'CURSO UNICO'),
  (7235, 3261, 3, 42, 102, 3, 4, E'CURSO UNICO'),
  (7236, 3262, 3, 42, 102, 1, 3, E'CURSO UNICO'),
  (7237, 3295, 3, 42, 102, 3, 3, E'ELECTIVA UNICA'),
  (7238, 3282, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7239, 3270, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7240, 3271, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7241, 3272, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7242, 3273, 3, 42, 102, 2, 3, E'LABORATORIO UNICO'),
  (7243, 3274, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7244, 3275, 3, 42, 102, 1, 3, E'LABORATORIO COMUN'),
  (7245, 3283, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7246, 3284, 3, 42, 102, 2, 4, E'LABORATORIO UNICO'),
  (7247, 3285, 3, 42, 102, 3, 3, E'CURSO UNICO'),
  (7248, 3286, 3, 42, 102, 2, 4, E'LABORATORIO UNICO'),
  (7249, 3305, 3, 42, 102, 3, 3, E'ELECTIVA COMUN'),
  (7250, 3306, 3, 42, 102, 3, 9, E'ELECTIVA UNICA'),
  (7251, 3310, 3, 42, 102, 3, 3, E'ELECTIVA UNICA'),
  (7252, 3311, 3, 42, 102, 3, 3, E'ELECTIVA UNICA'),
  (7253, 4755, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7254, 4776, 22, 87, 102, 2, 4, E'CURSO UNICO'),
  (7255, 4757, 22, 87, 102, 5, 15, E'CURSO UNICO'),
  (7256, 4759, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7257, 4761, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7258, 4773, 22, 87, 102, 6, 18, E'CURSO UNICO'),
  (7259, 4774, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7260, 4777, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7261, 4780, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7262, 4790, 22, 87, 102, 6, 18, E'CURSO UNICO'),
  (7263, 4793, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7264, 4791, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7265, 4796, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7266, 4809, 22, 87, 102, 6, 18, E'CURSO UNICO'),
  (7267, 4811, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7268, 4781, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7269, 4782, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7270, 4831, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (7271, 4798, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7272, 4813, 22, 87, 102, 2, 6, E'CURSO UNICO'),
  (7273, 4815, 22, 87, 102, 4, 12, E'TRABAJO FINAL DE GRADUACION'),
  (7274, 4828, 22, 87, 102, 6, 18, E'ELECTIVA UNICA'),
  (7275, 4829, 22, 87, 102, 6, 18, E'ELECTIVA UNICA'),
  (7276, 4838, 22, 87, 102, 2, 4, E'TRABAJO FINAL DE GRADUACION')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[1199]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (12060, 7206, E'20', E'VIRTUAL', 40),
  (12061, 7207, E'01', E'REGULAR', 20),
  (12062, 7208, E'01', E'REGULAR', 8),
  (12063, 7208, E'02', E'REGULAR', 8),
  (12064, 7209, E'01', E'REGULAR', 15),
  (12065, 7210, E'01', E'REGULAR', 15),
  (12066, 7210, E'02', E'REGULAR', 15),
  (12067, 7211, E'01', E'SEMIPRESENCIAL', 16),
  (12068, 7212, E'01', E'LABORATORIO', 8),
  (12069, 7212, E'02', E'LABORATORIO', 8),
  (12070, 7213, E'01', E'REGULAR', 15),
  (12071, 7214, E'01', E'REGULAR', 15),
  (12072, 7215, E'01', E'REGULAR', 15),
  (12073, 7216, E'01', E'REGULAR', 20),
  (12074, 7217, E'01', E'REGULAR', 15),
  (12075, 7218, E'01', E'REGULAR', 20),
  (12076, 7219, E'01', E'REGULAR', 15),
  (12077, 7220, E'01', E'REGULAR', 15),
  (12078, 7221, E'01', E'REGULAR', 20),
  (12079, 7222, E'01', E'REGULAR', 12),
  (12080, 7222, E'02', E'REGULAR', 12),
  (12081, 7223, E'01', E'REGULAR', 15),
  (12082, 7147, E'01', E'REGULAR', 32),
  (12083, 7224, E'01', E'SEMIPRESENCIAL', 45),
  (12084, 7225, E'01', E'SEMIPRESENCIAL', 30),
  (12085, 7226, E'01', E'SEMIPRESENCIAL', 18),
  (12086, 7227, E'01', E'SEMIPRESENCIAL', 18),
  (12087, 7228, E'01', E'SEMIPRESENCIAL', 30),
  (12088, 7229, E'01', E'SEMIPRESENCIAL', 30),
  (12089, 7230, E'01', E'SEMIPRESENCIAL', 18),
  (12090, 7231, E'01', E'SEMIPRESENCIAL', 18),
  (12091, 7232, E'01', E'VIRTUAL', 10),
  (12092, 7233, E'01', E'SEMIPRESENCIAL', 25),
  (12093, 7233, E'02', E'SEMIPRESENCIAL', 25),
  (12094, 7234, E'01', E'SEMIPRESENCIAL', 25),
  (12095, 7234, E'02', E'SEMIPRESENCIAL', 25),
  (12096, 7235, E'01', E'VIRTUAL', 50),
  (12097, 7236, E'01', E'LABORATORIO', 17),
  (12098, 7236, E'02', E'LABORATORIO', 17),
  (12099, 7236, E'03', E'LABORATORIO', 17),
  (12100, 7237, E'01', E'SEMIPRESENCIAL', 25),
  (12101, 7238, E'01', E'SEMIPRESENCIAL', 20),
  (12102, 7238, E'02', E'SEMIPRESENCIAL', 20),
  (12103, 7238, E'03', E'SEMIPRESENCIAL', 20),
  (12104, 7239, E'01', E'REGULAR', 18),
  (12105, 7239, E'02', E'REGULAR', 18),
  (12106, 7239, E'03', E'REGULAR', 15),
  (12107, 7240, E'01', E'SEMIPRESENCIAL', 50),
  (12108, 7241, E'01', E'REGULAR', 52),
  (12109, 7242, E'01', E'LABORATORIO', 18),
  (12110, 7242, E'02', E'LABORATORIO', 18),
  (12111, 7242, E'03', E'LABORATORIO', 17),
  (12112, 7243, E'01', E'SEMIPRESENCIAL', 50),
  (12113, 7244, E'01', E'LABORATORIO', 17),
  (12114, 7244, E'02', E'LABORATORIO', 17),
  (12115, 7244, E'03', E'LABORATORIO', 17),
  (12116, 7245, E'01', E'SEMIPRESENCIAL', 60),
  (12117, 7246, E'01', E'LABORATORIO', 12),
  (12118, 7246, E'02', E'LABORATORIO', 12),
  (12119, 7246, E'03', E'LABORATORIO', 12),
  (12120, 7246, E'04', E'LABORATORIO', 12),
  (12121, 7246, E'05', E'LABORATORIO', 12),
  (12122, 7247, E'01', E'SEMIPRESENCIAL', 56),
  (12123, 7248, E'01', E'LABORATORIO', 12),
  (12124, 7248, E'02', E'LABORATORIO', 11),
  (12125, 7248, E'03', E'LABORATORIO', 11),
  (12126, 7248, E'04', E'LABORATORIO', 11),
  (12127, 7248, E'05', E'LABORATORIO', 11),
  (12128, 7249, E'01', E'SEMIPRESENCIAL', 20),
  (12129, 7250, E'01', E'SEMIPRESENCIAL', 20),
  (12130, 7251, E'01', E'SEMIPRESENCIAL', 18),
  (12131, 7252, E'01', E'REGULAR', 20),
  (12132, 7253, E'40', E'REGULAR', 25),
  (12133, 7253, E'41', E'REGULAR', 25),
  (12134, 7254, E'41', E'REGULAR', 20),
  (12135, 7255, E'40', E'REGULAR', 30),
  (12136, 7255, E'41', E'REGULAR', 30),
  (12137, 7256, E'40', E'REGULAR', 25),
  (12138, 7256, E'41', E'REGULAR', 25),
  (12139, 7257, E'40', E'REGULAR', 25),
  (12140, 7257, E'41', E'ENSEÑANZA REMOTA', 25),
  (12141, 7258, E'40', E'REGULAR', 30),
  (12142, 7259, E'40', E'VIRTUAL', 20),
  (12143, 7260, E'40', E'REGULAR', 35),
  (12144, 7261, E'40', E'REGULAR', 32),
  (12145, 7262, E'40', E'REGULAR', 25),
  (12146, 7262, E'41', E'REGULAR', 30),
  (12147, 7263, E'40', E'REGULAR', 22),
  (12148, 7263, E'41', E'REGULAR', 22),
  (12149, 7264, E'40', E'REGULAR', 25),
  (12150, 7264, E'41', E'REGULAR', 25),
  (12151, 7265, E'40', E'REGULAR', 22),
  (12152, 7265, E'41', E'REGULAR', 22),
  (12153, 7266, E'40', E'REGULAR', 25),
  (12154, 7267, E'40', E'REGULAR', 32),
  (12155, 7268, E'40', E'REGULAR', 20),
  (12156, 7268, E'41', E'REGULAR', 20),
  (12157, 7269, E'40', E'REGULAR', 20),
  (12158, 7269, E'41', E'REGULAR', 20),
  (12159, 7270, E'40', E'SEMIPRESENCIAL', 32),
  (12160, 7271, E'40', E'REGULAR', 22),
  (12161, 7271, E'41', E'REGULAR', 22),
  (12162, 7272, E'40', E'REGULAR', 25),
  (12163, 7273, E'40', E'VIRTUAL', 25),
  (12164, 7274, E'40', E'SEMIPRESENCIAL', 25),
  (12165, 7275, E'40', E'SEMIPRESENCIAL', 25),
  (12166, 7276, E'40', E'VIRTUAL', 25)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET group_type = E'REGULAR', capacity = 25, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11830;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11873;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6053;
UPDATE public.course_offering_group SET capacity = 20, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11929;
UPDATE public.course_offering_group SET group_type = E'LABORATORIO', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11947;
UPDATE public.course_offering_group SET capacity = 40, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5584;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12002;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12050;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[878, 1268, 1871, 5561, 6087, 8901, 9196, 11914]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (12298, 12060, 134),
  (12299, 12060, 123),
  (12300, 12061, 680),
  (12301, 12062, 679),
  (12302, 12063, 679),
  (12303, 12064, 679),
  (12304, 12065, 683),
  (12305, 12066, 688),
  (12306, 12067, 685),
  (12307, 12068, 689),
  (12308, 12069, 689),
  (12309, 12070, 682),
  (12310, 12071, 686),
  (12311, 12072, 436),
  (12312, 12073, 690),
  (12313, 12074, 1193),
  (12314, 12075, 683),
  (12315, 12076, 688),
  (12316, 12077, 684),
  (12317, 12078, 690),
  (12318, 12079, 57),
  (12319, 12080, 1099),
  (12320, 12081, 681),
  (12321, 12083, 212),
  (12322, 12084, 709),
  (12323, 12085, 712),
  (12324, 12086, 716),
  (12325, 12087, 716),
  (12326, 12088, 246),
  (12327, 12089, 712),
  (12328, 12090, 716),
  (12329, 12091, 136),
  (12330, 12092, 745),
  (12331, 12092, 735),
  (12332, 12093, 745),
  (12333, 12093, 735),
  (12334, 12094, 731),
  (12335, 12095, 731),
  (12336, 12096, 746),
  (12337, 12097, 741),
  (12338, 12098, 741),
  (12339, 12099, 79),
  (12340, 12100, 73),
  (12341, 12101, 742),
  (12342, 12103, 743),
  (12343, 12104, 80),
  (12344, 12105, 80),
  (12345, 12106, 805),
  (12346, 12107, 734),
  (12347, 12108, 737),
  (12348, 12109, 737),
  (12349, 12110, 740),
  (12350, 12111, 76),
  (12351, 12112, 728),
  (12352, 12113, 728),
  (12353, 12114, 538),
  (12354, 12115, 730),
  (12355, 12116, 73),
  (12356, 12117, 78),
  (12357, 12118, 74),
  (12358, 12119, 74),
  (12359, 12120, 78),
  (12360, 12121, 73),
  (12361, 12122, 1128),
  (12362, 12122, 75),
  (12363, 12122, 732),
  (12364, 12123, 738),
  (12365, 12124, 738),
  (12366, 12125, 874),
  (12367, 12126, 727),
  (12368, 12127, 736),
  (12369, 12128, 75),
  (12370, 12129, 729),
  (12371, 12130, 739),
  (12372, 12131, 736)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[6089]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (16615, 12060, 3, '13:00:00', '16:50:00', NULL),
  (16616, 12061, 2, '07:30:00', '11:20:00', E'G1-03'),
  (16617, 12062, 5, '07:30:00', '11:20:00', E'H6-01'),
  (16618, 12063, 5, '13:00:00', '16:50:00', E'H6-01'),
  (16619, 12064, 4, '13:00:00', '16:50:00', E'G1-04'),
  (16620, 12065, 2, '07:30:00', '11:20:00', E'G1-01'),
  (16621, 12066, 1, '07:30:00', '11:20:00', E'H6-01'),
  (16622, 12067, 3, '07:30:00', '11:20:00', E'G1-04'),
  (16623, 12068, 4, '07:30:00', '11:20:00', E'G1-01'),
  (16624, 12069, 4, '13:00:00', '16:50:00', E'G1-01'),
  (16625, 12070, 3, '07:30:00', '11:20:00', E'H6-01'),
  (16626, 12071, 1, '07:30:00', '11:20:00', E'G1-03'),
  (16627, 12072, 5, '07:30:00', '11:20:00', E'G1-03'),
  (16628, 12073, 1, '07:30:00', '12:20:00', NULL),
  (16629, 12074, 2, '07:30:00', '11:20:00', NULL),
  (16630, 12075, 4, '07:30:00', '11:20:00', E'G1-04'),
  (16631, 12076, 3, '07:30:00', '12:20:00', E'G1-01'),
  (16632, 12077, 2, '07:30:00', '10:20:00', NULL),
  (16633, 12078, 4, '07:30:00', '12:20:00', E'H6-01'),
  (16634, 12079, 2, '13:00:00', '16:50:00', E'G1-03'),
  (16635, 12080, 3, '17:00:00', '20:50:00', E'G1-03'),
  (16636, 12081, 3, '13:00:00', '16:50:00', E'G1-01'),
  (16637, 12082, 2, '07:30:00', '09:20:00', NULL),
  (16638, 12082, 4, '07:30:00', '09:20:00', NULL),
  (16639, 11915, 1, '09:30:00', '12:20:00', NULL),
  (16640, 9935, 3, '18:00:00', '19:50:00', NULL),
  (16641, 12083, 3, '07:30:00', '10:20:00', E'D3-03'),
  (16642, 12084, 2, '17:00:00', '20:50:00', E'F3-04'),
  (16643, 11960, 2, '08:30:00', '12:20:00', E'F4-03'),
  (16644, 12085, 4, '07:30:00', '11:20:00', E'F3-05'),
  (16645, 12086, 3, '13:00:00', '16:50:00', E'F3-04'),
  (16646, 12087, 2, '13:00:00', '16:50:00', E'F3-04'),
  (16647, 12088, 3, '17:00:00', '20:50:00', E'F4-06'),
  (16648, 12089, 2, '07:30:00', '11:20:00', E'F3-05'),
  (16649, 12090, 3, '07:30:00', '11:20:00', E'F3-05'),
  (16650, 12091, 3, '09:30:00', '12:20:00', NULL),
  (16651, 3461, 5, '13:00:00', '16:50:00', E'B2-06'),
  (16652, 12092, 2, '17:00:00', '19:50:00', E'F4-11'),
  (16653, 12093, 3, '17:00:00', '19:50:00', E'F5-05'),
  (16654, 12094, 2, '08:30:00', '10:20:00', E'F4-09'),
  (16655, 12094, 4, '08:30:00', '10:20:00', E'F4-09'),
  (16656, 12095, 2, '13:00:00', '14:50:00', E'F4-10'),
  (16657, 12095, 3, '13:00:00', '14:50:00', E'F4-10'),
  (16658, 12096, 2, '17:00:00', '18:50:00', NULL),
  (16659, 12096, 3, '17:00:00', '18:50:00', NULL),
  (16660, 12097, 4, '08:30:00', '11:20:00', E'B4-01'),
  (16661, 12098, 4, '13:00:00', '15:50:00', E'B4-01'),
  (16662, 12099, 4, '16:00:00', '18:50:00', E'B4-01'),
  (16663, 12100, 3, '13:00:00', '15:50:00', E'F4-09'),
  (16664, 12101, 3, '08:30:00', '11:20:00', E'F4-11'),
  (16665, 12102, 3, '13:00:00', '15:50:00', E'F4-11'),
  (16666, 12103, 3, '16:00:00', '18:50:00', E'F4-11'),
  (16667, 12104, 3, '08:30:00', '11:20:00', E'F4-10'),
  (16668, 12105, 3, '13:00:00', '15:50:00', E'F5-07'),
  (16669, 12106, 4, '16:00:00', '18:50:00', E'F4-11'),
  (16670, 12107, 2, '13:00:00', '15:50:00', E'F5-09'),
  (16671, 12108, 1, '08:30:00', '11:20:00', E'F5-09'),
  (16672, 12109, 4, '08:30:00', '11:20:00', E'B4-02'),
  (16673, 12110, 4, '13:00:00', '15:50:00', E'B4-02'),
  (16674, 12111, 5, '08:30:00', '11:20:00', E'B4-02'),
  (16675, 12112, 2, '08:30:00', '11:20:00', E'F1-03'),
  (16676, 12113, 4, '08:30:00', '11:20:00', E'G7-04'),
  (16677, 12114, 4, '13:00:00', '15:50:00', E'G7-04'),
  (16678, 12115, 4, '16:00:00', '18:50:00', E'G7-04'),
  (16679, 12116, 2, '08:30:00', '11:20:00', E'D3-15'),
  (16680, 12117, 4, '07:30:00', '11:20:00', E'G7-01'),
  (16681, 12118, 4, '13:00:00', '16:50:00', E'G7-01'),
  (16682, 12119, 4, '17:00:00', '20:50:00', E'G7-01'),
  (16683, 12120, 5, '07:30:00', '11:20:00', E'G7-01'),
  (16684, 12121, 5, '13:00:00', '16:50:00', E'G7-01'),
  (16685, 12122, 1, '08:30:00', '11:20:00', E'D3-15'),
  (16686, 12123, 4, '07:30:00', '11:20:00', E'G7-02'),
  (16687, 12124, 4, '13:00:00', '16:50:00', E'G7-02'),
  (16688, 12125, 4, '17:00:00', '20:50:00', E'G7-02'),
  (16689, 12126, 5, '07:30:00', '11:20:00', E'G7-02'),
  (16690, 12127, 5, '13:00:00', '16:50:00', E'G7-02'),
  (16691, 12128, 2, '13:00:00', '15:50:00', E'F5-05'),
  (16692, 12129, 3, '08:30:00', '11:20:00', E'F5-05'),
  (16693, 12130, 3, '13:00:00', '15:50:00', E'F5-05'),
  (16694, 12131, 4, '17:00:00', '19:50:00', E'F5-05'),
  (16695, 7804, 5, '18:00:00', '21:50:00', NULL),
  (16696, 12132, 4, '13:00:00', '15:50:00', E'J01-03'),
  (16697, 12133, 5, '13:00:00', '15:50:00', E'J01-03'),
  (16698, 12134, 5, '13:00:00', '15:50:00', NULL),
  (16699, 12135, 1, '07:30:00', '11:20:00', E'J01-01'),
  (16700, 12135, 4, '07:30:00', '11:20:00', E'J01-01'),
  (16701, 12136, 2, '13:00:00', '16:50:00', E'J01-01'),
  (16702, 12136, 4, '13:00:00', '16:50:00', E'J01-01'),
  (16703, 12137, 3, '07:30:00', '09:20:00', E'J01-03'),
  (16704, 12138, 4, '09:30:00', '11:20:00', E'J01-03'),
  (16705, 12139, 5, '13:00:00', '16:50:00', E'J01-01'),
  (16706, 12140, 2, '07:30:00', '11:20:00', E'J01-01'),
  (16707, 12141, 1, '07:30:00', '11:20:00', E'J02-03'),
  (16708, 12141, 4, '07:30:00', '11:20:00', E'J02-03'),
  (16709, 12142, 3, '13:00:00', '15:50:00', NULL),
  (16710, 12143, 4, '13:00:00', '15:50:00', E'J01-04'),
  (16711, 12144, 3, '08:30:00', '11:20:00', E'J02-03'),
  (16712, 12145, 2, '07:30:00', '11:20:00', E'J02-03'),
  (16713, 12145, 5, '07:30:00', '11:20:00', E'J02-03'),
  (16714, 12146, 2, '13:00:00', '16:50:00', E'J02-03'),
  (16715, 12146, 5, '13:00:00', '16:50:00', E'J02-03'),
  (16716, 12147, 3, '13:00:00', '14:50:00', E'J01-01'),
  (16717, 12148, 3, '09:30:00', '11:20:00', E'J01-01'),
  (16718, 12149, 2, '13:00:00', '15:50:00', E'J01-01'),
  (16719, 12150, 5, '08:30:00', '11:20:00', E'J01-01'),
  (16720, 12151, 4, '08:30:00', '11:20:00', E'J01-02'),
  (16721, 12152, 4, '13:00:00', '15:50:00', E'J01-02'),
  (16722, 12153, 1, '07:30:00', '11:20:00', E'J01-02'),
  (16723, 12153, 4, '07:30:00', '11:20:00', E'J01-02'),
  (16724, 12154, 2, '13:00:00', '15:50:00', E'J01-02'),
  (16725, 12155, 2, '09:30:00', '11:20:00', E'J01-03'),
  (16726, 12156, 2, '13:00:00', '14:50:00', E'J01-03'),
  (16727, 12157, 5, '13:00:00', '15:50:00', E'J01-04'),
  (16728, 12158, 2, '08:30:00', '11:20:00', E'J01-04'),
  (16729, 12159, 3, '13:00:00', '16:50:00', E'J02-03'),
  (16730, 12160, 4, '13:00:00', '15:50:00', E'J06-05'),
  (16731, 12161, 4, '08:30:00', '11:20:00', E'J06-05'),
  (16732, 12162, 2, '16:50:00', '18:20:00', E'J01-02'),
  (16733, 12163, 5, '07:30:00', '11:20:00', NULL),
  (16734, 12164, 1, '07:30:00', '11:20:00', E'J01-01'),
  (16735, 12164, 4, '07:30:00', '11:20:00', E'J01-01'),
  (16736, 12165, 1, '07:30:00', '11:20:00', E'J01-04'),
  (16737, 12165, 4, '07:30:00', '11:20:00', E'J01-04'),
  (16738, 12166, 1, '07:30:00', '11:20:00', NULL),
  (16739, 12053, 5, '08:30:00', '11:20:00', E'J06-01'),
  (16740, 5636, 5, '09:30:00', '11:20:00', E'J06-02'),
  (16741, 1923, 4, '17:30:00', '20:15:00', E'J06-01'),
  (16742, 5520, 3, '17:30:00', '20:15:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5853;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 7907;
UPDATE public.course_offering_meeting SET classroom = E'D3-13', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10866;
UPDATE public.course_offering_meeting SET classroom = E'G18-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10406;
UPDATE public.course_offering_meeting SET classroom = E'G18-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15169;
UPDATE public.course_offering_meeting SET classroom = E'F4-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6973;
UPDATE public.course_offering_meeting SET classroom = E'F4-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 9552;
UPDATE public.course_offering_meeting SET classroom = E'F4-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 8665;
UPDATE public.course_offering_meeting SET classroom = E'F4-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6985;
UPDATE public.course_offering_meeting SET classroom = E'F5-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16441;
UPDATE public.course_offering_meeting SET classroom = E'F5-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 9945;
UPDATE public.course_offering_meeting SET classroom = E'F5-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 8014;
UPDATE public.course_offering_meeting SET classroom = E'F5-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6638;
UPDATE public.course_offering_meeting SET classroom = E'F5-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3642;
UPDATE public.course_offering_meeting SET classroom = E'F5-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11890;
UPDATE public.course_offering_meeting SET classroom = E'D10-35', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15679;
UPDATE public.course_offering_meeting SET classroom = E'D10-35', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6668;
UPDATE public.course_offering_meeting SET classroom = E'D10-35', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 7704;
UPDATE public.course_offering_meeting SET classroom = E'F5-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6169;
UPDATE public.course_offering_meeting SET classroom = E'D10-37', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13117;
UPDATE public.course_offering_meeting SET classroom = E'D10-37', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4330;
UPDATE public.course_offering_meeting SET classroom = E'D10-37', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6231;
UPDATE public.course_offering_meeting SET classroom = E'D10-37', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11903;
UPDATE public.course_offering_meeting SET classroom = E'D3-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4507;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13899;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3442;
UPDATE public.course_offering_meeting SET classroom = E'D3-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4954;
UPDATE public.course_offering_meeting SET classroom = E'D3-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3856;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10543;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10376;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6874;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5990;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11818;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13677;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 8722;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15030;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11919;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 338;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1884;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5680;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10970;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15729;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4926;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1589;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1850;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 7701;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2884;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 136;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1782;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14425;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4199;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6746;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11382;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13332;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 8124;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2150;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4169;
UPDATE public.course_offering_meeting SET classroom = E'C1-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10861;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4010;
UPDATE public.course_offering_meeting SET classroom = E'D3-12', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 911;
UPDATE public.course_offering_meeting SET classroom = E'D3-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 6402;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16601;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16602;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16603;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16604;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16605;
UPDATE public.course_offering_meeting SET classroom = E'J06-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16607;
UPDATE public.course_offering_meeting SET classroom = E'J06-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16608;
UPDATE public.course_offering_meeting SET classroom = E'J06-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16609;
UPDATE public.course_offering_meeting SET classroom = E'J06-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16610;
UPDATE public.course_offering_meeting SET classroom = E'J06-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16611;
UPDATE public.course_offering_meeting SET classroom = E'J06-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1992;
UPDATE public.course_offering_meeting SET classroom = E'J06-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 188;
UPDATE public.course_offering_meeting SET classroom = E'J06-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 15789;
UPDATE public.course_offering_meeting SET classroom = E'J06-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 3131;
UPDATE public.course_offering_meeting SET classroom = E'J06-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 14270;
UPDATE public.course_offering_meeting SET classroom = E'J06-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 93;
UPDATE public.course_offering_meeting SET classroom = E'J06-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5305;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[25, 913, 6481, 6922, 7395, 7499, 7512, 9492, 9934, 10703, 11292, 11322, 11611, 12171, 13029, 13581, 14229, 16425, 16426, 16427, 16440, 16484, 16606]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
