-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=422d0c59c8e56ecefc25a3e3472a615e359bc3e80542dd349306103309364acb
-- TEC-DATA-META generated_at_utc=2026-06-07T22:11:04.290342+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'COMERCIO ELECTRÓNICO', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 1134;

-- table: professor
INSERT INTO public.professor
  (id, full_name)
VALUES
  (1313, E'CAMACHO AGUILAR RAFAEL'),
  (1314, E'CASTRO ROLDAN MARVIN'),
  (1315, E'FLETES GALAN WILBERTH'),
  (1316, E'SANCHEZ GOMEZ MARIA MILAGRO')
ON CONFLICT (full_name) DO NOTHING;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10703, 1578, 1, 23, 102, 4, 12, E'CURSO UNICO'),
  (10704, 1579, 1, 23, 102, 4, 12, E'CURSO UNICO'),
  (10705, 1580, 1, 23, 102, 4, 12, E'CURSO UNICO'),
  (10706, 1581, 1, 23, 102, 4, 12, E'CURSO UNICO'),
  (10707, 1312, 1, 13, 102, 3, 4, E'CURSO UNICO'),
  (10708, 1298, 1, 13, 102, 3, 4, E'CURSO UNICO'),
  (10709, 1514, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10710, 1516, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10711, 1517, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10712, 1518, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10713, 1527, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10714, 1529, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10715, 1530, 3, 18, 24, 7, NULL, E'CURSO UNICO'),
  (10716, 1531, 3, 18, 24, 7, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10717, 1523, 3, 18, 24, 7, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10718, 252, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10719, 215, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10720, 213, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10721, 234, 3, 18, 24, 4, NULL, E'CURSO UNICO'),
  (10722, 2403, 3, 2, 102, 4, 4, E'CURSO COMUN'),
  (10723, 1044, 3, 34, 102, 4, 4, E'CURSO UNICO'),
  (10724, 3001, 3, 37, 102, 12, 36, E'TRABAJO FINAL DE GRADUACION'),
  (10725, 463, 3, 19, 24, 4, NULL, E'CURSO UNICO'),
  (10726, 467, 3, 19, 24, 4, NULL, E'CURSO UNICO'),
  (10727, 472, 3, 19, 24, 4, NULL, E'CURSO UNICO'),
  (10728, 486, 3, 19, 24, 8, NULL, E'TRABAJO FINAL DE GRADUACION'),
  (10729, 356, 3, 25, 24, 4, NULL, E'CURSO UNICO'),
  (10730, 358, 3, 25, 24, 4, NULL, E'CURSO UNICO'),
  (10731, 362, 3, 25, 24, 4, NULL, E'CURSO UNICO'),
  (10732, 368, 3, 25, 24, 4, NULL, E'CURSO UNICO'),
  (10733, 401, 3, 25, 24, 4, NULL, E'ELECTIVA UNICA'),
  (10734, 376, 3, 25, 24, 4, NULL, E'ELECTIVA UNICA'),
  (10735, 3884, 3, 21, 24, 4, NULL, E'CURSO UNICO'),
  (10736, 3860, 3, 21, 24, 4, NULL, E'CURSO UNICO'),
  (10737, 1564, 3, 21, 24, 5, NULL, E'CURSO UNICO'),
  (10738, 1573, 3, 21, 24, 5, NULL, E'CURSO UNICO'),
  (10739, 3649, 3, 60, 24, 4, NULL, E'CURSO COMUN'),
  (10740, 3672, 3, 60, 24, 4, NULL, E'CURSO UNICO'),
  (10741, 3661, 3, 60, 24, 4, NULL, E'CURSO UNICO'),
  (10742, 1707, 13, 2, 102, 4, 4, E'CURSO UNICO'),
  (10743, 2366, 13, 2, 102, 4, 4, E'CURSO COMUN'),
  (10744, 2394, 13, 2, 102, 3, 4, E'CURSO COMUN'),
  (10745, 2412, 13, 2, 102, 3, 4, E'CURSO COMUN'),
  (10746, 1892, 13, 2, 102, 3, 4, E'CURSO COMUN'),
  (10747, 1782, 13, 2, 102, 3, 4, E'CURSO COMUN'),
  (10748, 2450, 13, 2, 102, 3, 9, E'CURSO UNICO'),
  (10749, 2453, 13, 2, 102, 3, 9, E'CURSO UNICO'),
  (10750, 2442, 13, 2, 102, 3, 4, E'CURSO UNICO'),
  (10751, 2414, 13, 2, 102, 2, 3, E'CURSO UNICO'),
  (10752, 2419, 13, 2, 102, 4, 4, E'CURSO UNICO'),
  (10753, 2470, 13, 2, 102, 3, 9, E'ELECTIVA UNICA'),
  (10754, 1017, 13, 10, 102, 3, 9, E'CURSO UNICO'),
  (10755, 1020, 13, 10, 102, 3, 4, E'CURSO UNICO'),
  (10756, 1022, 13, 10, 102, 3, 4, E'CURSO UNICO'),
  (10757, 1029, 13, 10, 102, 4, 12, E'CURSO UNICO'),
  (10758, 1030, 13, 10, 102, 3, 9, E'CURSO UNICO'),
  (10759, 1035, 13, 10, 102, 4, 12, E'CURSO UNICO'),
  (10760, 1032, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10761, 1037, 13, 10, 102, 4, 9, E'CURSO UNICO'),
  (10762, 1043, 13, 10, 102, 3, 9, E'CURSO UNICO'),
  (10763, 1045, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10764, 1052, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10765, 1054, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10766, 1039, 13, 10, 102, 4, 12, E'CURSO UNICO'),
  (10767, 1151, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10768, 1154, 13, 10, 102, 4, 4, E'CURSO UNICO'),
  (10769, 1047, 13, 10, 102, 4, 12, E'CURSO UNICO'),
  (10770, 1056, 13, 10, 102, 3, 9, E'CURSO UNICO'),
  (10771, 1156, 13, 10, 102, 2, 7, E'CURSO UNICO'),
  (10772, 1134, 13, 10, 102, 3, 9, E'ELECTIVA UNICA'),
  (10773, 1158, 13, 10, 102, 3, 9, E'ELECTIVA UNICA'),
  (10774, 1727, 13, 13, 102, 3, 4, E'CURSO UNICO'),
  (10775, 1728, 13, 13, 102, 3, 4, E'CURSO UNICO'),
  (10776, 1745, 13, 13, 102, 3, 3, E'CURSO UNICO'),
  (10777, 1749, 13, 13, 102, 3, 3, E'CURSO UNICO'),
  (10778, 1719, 13, 13, 102, 3, 3, E'CURSO UNICO'),
  (10779, 1722, 13, 13, 102, 3, 3, E'CURSO UNICO'),
  (10780, 1751, 13, 13, 102, 3, 4, E'CURSO UNICO'),
  (10781, 1746, 13, 13, 102, 3, 4, E'CURSO UNICO'),
  (10782, 1760, 13, 13, 102, 3, 4, E'CURSO UNICO'),
  (10783, 4833, 22, 87, 102, 3, 9, E'CURSO UNICO'),
  (10784, 1162, 22, 10, 102, 4, 4, E'CURSO UNICO')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[4529, 7254, 7498]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17621, 10703, E'20', E'VIRTUAL', 23),
  (17622, 10704, E'20', E'VIRTUAL', 21),
  (17623, 10705, E'20', E'VIRTUAL', 24),
  (17624, 10706, E'20', E'VIRTUAL', 22),
  (17625, 10707, E'90', E'REGULAR', 35),
  (17626, 10708, E'90', E'REGULAR', 35),
  (17627, 10709, E'01', E'VIRTUAL', 25),
  (17628, 10709, E'02', E'VIRTUAL', 25),
  (17629, 10710, E'01', E'VIRTUAL', 25),
  (17630, 10711, E'01', E'VIRTUAL', 25),
  (17631, 10712, E'01', E'VIRTUAL', 25),
  (17632, 10713, E'01', E'VIRTUAL', 25),
  (17633, 10714, E'01', E'VIRTUAL', 25),
  (17634, 10715, E'01', E'VIRTUAL', 15),
  (17635, 10716, E'01', E'VIRTUAL', 35),
  (17636, 10716, E'02', E'VIRTUAL', 35),
  (17637, 10717, E'01', E'VIRTUAL', 25),
  (17638, 10718, E'01', E'VIRTUAL', 25),
  (17639, 10719, E'01', E'VIRTUAL', 25),
  (17640, 10720, E'01', E'VIRTUAL', 25),
  (17641, 10721, E'01', E'VIRTUAL', 25),
  (17642, 10722, E'01', E'REGULAR', 32),
  (17643, 10722, E'02', E'REGULAR', 32),
  (17644, 10722, E'03', E'REGULAR', 32),
  (17645, 7504, E'02', E'REGULAR', 32),
  (17646, 10723, E'01', E'SEMIPRESENCIAL', 40),
  (17647, 10723, E'02', E'SEMIPRESENCIAL', 40),
  (17648, 10724, E'01', E'SEMIPRESENCIAL', 24),
  (17649, 10725, E'01', E'VIRTUAL', 20),
  (17650, 10726, E'01', E'VIRTUAL', 20),
  (17651, 10727, E'01', E'VIRTUAL', 20),
  (17652, 10728, E'01', E'VIRTUAL', 20),
  (17653, 10729, E'01', E'VIRTUAL', 32),
  (17654, 10730, E'01', E'VIRTUAL', 32),
  (17655, 10731, E'01', E'VIRTUAL', 32),
  (17656, 10732, E'01', E'VIRTUAL', 32),
  (17657, 10733, E'01', E'VIRTUAL', 32),
  (17658, 10734, E'01', E'VIRTUAL', 32),
  (17659, 10735, E'01', E'SEMIPRESENCIAL', 30),
  (17660, 10736, E'01', E'SEMIPRESENCIAL', 10),
  (17661, 10737, E'01', E'SEMIPRESENCIAL', 10),
  (17662, 10738, E'01', E'SEMIPRESENCIAL', 30),
  (17663, 10739, E'01', E'VIRTUAL', 30),
  (17664, 10740, E'01', E'VIRTUAL', 30),
  (17665, 10741, E'01', E'VIRTUAL', 30),
  (17666, 7177, E'04', E'REGULAR', 18),
  (17667, 7177, E'07', E'REGULAR', 18),
  (17668, 7177, E'22', E'REGULAR', 18),
  (17669, 7177, E'29', E'REGULAR', 18),
  (17670, 7178, E'02', E'SEMIPRESENCIAL', 40),
  (17671, 7179, E'04', E'SEMIPRESENCIAL', 40),
  (17672, 7179, E'09', E'SEMIPRESENCIAL', 60),
  (17673, 7179, E'11', E'SEMIPRESENCIAL', 40),
  (17674, 10742, E'60', E'SEMIPRESENCIAL', 32),
  (17675, 10743, E'60', E'SEMIPRESENCIAL', 32),
  (17676, 10744, E'60', E'SEMIPRESENCIAL', 32),
  (17677, 10745, E'60', E'SEMIPRESENCIAL', 32),
  (17678, 10746, E'60', E'SEMIPRESENCIAL', 32),
  (17679, 10747, E'60', E'SEMIPRESENCIAL', 32),
  (17680, 10748, E'60', E'SEMIPRESENCIAL', 32),
  (17681, 10749, E'60', E'SEMIPRESENCIAL', 32),
  (17682, 10750, E'60', E'SEMIPRESENCIAL', 32),
  (17683, 10751, E'60', E'SEMIPRESENCIAL', 32),
  (17684, 10752, E'60', E'SEMIPRESENCIAL', 32),
  (17685, 10753, E'60', E'SEMIPRESENCIAL', 32),
  (17686, 10754, E'60', E'REGULAR', 32),
  (17687, 10755, E'60', E'REGULAR', 30),
  (17688, 10756, E'60', E'REGULAR', 30),
  (17689, 10757, E'60', E'SEMIPRESENCIAL', 30),
  (17690, 10758, E'60', E'VIRTUAL', 24),
  (17691, 10759, E'60', E'REGULAR', 30),
  (17692, 10760, E'60', E'SEMIPRESENCIAL', 30),
  (17693, 10761, E'60', E'VIRTUAL', 24),
  (17694, 10762, E'60', E'SEMIPRESENCIAL', 24),
  (17695, 10763, E'60', E'SEMIPRESENCIAL', 29),
  (17696, 10764, E'60', E'REGULAR', 29),
  (17697, 10765, E'60', E'SEMIPRESENCIAL', 29),
  (17698, 10766, E'60', E'REGULAR', 29),
  (17699, 10767, E'60', E'SEMIPRESENCIAL', 30),
  (17700, 10768, E'60', E'SEMIPRESENCIAL', 30),
  (17701, 10769, E'60', E'REGULAR', 30),
  (17702, 10770, E'60', E'SEMIPRESENCIAL', 30),
  (17703, 10771, E'60', E'SEMIPRESENCIAL', 30),
  (17704, 10772, E'60', E'REGULAR', 30),
  (17705, 10773, E'60', E'SEMIPRESENCIAL', 30),
  (17706, 10774, E'60', E'REGULAR', 18),
  (17707, 10775, E'60', E'VIRTUAL', 23),
  (17708, 10776, E'60', E'REGULAR', 20),
  (17709, 10777, E'60', E'REGULAR', 21),
  (17710, 10778, E'60', E'REGULAR', 24),
  (17711, 10779, E'60', E'REGULAR', 18),
  (17712, 10780, E'60', E'REGULAR', 20),
  (17713, 10781, E'60', E'VIRTUAL', 23),
  (17714, 10782, E'60', E'REGULAR', 20),
  (17715, 7875, E'51', E'REGULAR', 20),
  (17716, 10783, E'40', E'SEMIPRESENCIAL', 30),
  (17717, 10784, E'40', E'SEMIPRESENCIAL', 25)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12817;
UPDATE public.course_offering_group SET capacity = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12509;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12830;
UPDATE public.course_offering_group SET capacity = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12176;
UPDATE public.course_offering_group SET capacity = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12537;
UPDATE public.course_offering_group SET capacity = 2, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12350;
UPDATE public.course_offering_group SET capacity = 25, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12684;
UPDATE public.course_offering_group SET capacity = 40, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12009;
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12025;
UPDATE public.course_offering_group SET group_type = E'REGULAR', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12750;
UPDATE public.course_offering_group SET capacity = 40, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12754;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 13119;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[11082, 11995, 11999, 12005, 12008, 12011, 12014, 12019, 12134, 12499, 12500, 12501, 12516]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18184, 17621, 886),
  (18185, 17622, 52),
  (18186, 17623, 1313),
  (18187, 17624, 1022),
  (18188, 17625, 444),
  (18189, 17626, 11),
  (18190, 17627, 557),
  (18191, 17628, 1088),
  (18192, 17629, 1000),
  (18193, 17630, 563),
  (18194, 17631, 558),
  (18195, 17632, 1171),
  (18196, 17633, 559),
  (18197, 17634, 560),
  (18198, 17635, 561),
  (18199, 17636, 560),
  (18200, 17637, 1212),
  (18201, 17638, 984),
  (18202, 17639, 10),
  (18203, 17640, 568),
  (18204, 17641, 570),
  (18205, 12816, 48),
  (18206, 17642, 59),
  (18207, 17643, 59),
  (18208, 17644, 1114),
  (18209, 17645, 60),
  (18210, 12830, 664),
  (18211, 17646, 675),
  (18212, 17647, 675),
  (18213, 12876, 547),
  (18214, 12169, 1314),
  (18215, 12170, 1314),
  (18216, 12191, 294),
  (18217, 12546, 697),
  (18218, 17648, 574),
  (18219, 17649, 1182),
  (18220, 17650, 910),
  (18221, 17651, 572),
  (18222, 17652, 1126),
  (18223, 12937, 1133),
  (18224, 17653, 590),
  (18225, 17654, 345),
  (18226, 17655, 596),
  (18227, 17656, 595),
  (18228, 17657, 594),
  (18229, 17658, 1316),
  (18230, 17659, 877),
  (18231, 17660, 877),
  (18232, 17661, 877),
  (18233, 17661, 991),
  (18234, 17662, 877),
  (18235, 17662, 991),
  (18236, 17663, 257),
  (18237, 17664, 248),
  (18238, 17665, 252),
  (18239, 12641, 248),
  (18240, 11969, 535),
  (18241, 17666, 542),
  (18242, 11982, 535),
  (18243, 17667, 555),
  (18244, 11983, 542),
  (18245, 11984, 535),
  (18246, 17668, 540),
  (18247, 17669, 364),
  (18248, 17670, 533),
  (18249, 17671, 96),
  (18250, 17672, 552),
  (18251, 17673, 548),
  (18252, 12033, 531),
  (18253, 12719, 467),
  (18254, 12720, 468),
  (18255, 12728, 471),
  (18256, 12730, 476),
  (18257, 17674, 34),
  (18258, 17675, 38),
  (18259, 17676, 32),
  (18260, 17677, 33),
  (18261, 17678, 36),
  (18262, 17679, 1315),
  (18263, 17680, 1029),
  (18264, 17681, 35),
  (18265, 17682, 35),
  (18266, 17683, 38),
  (18267, 17684, 33),
  (18268, 17685, 35),
  (18269, 17686, 279),
  (18270, 17687, 294),
  (18271, 17687, 264),
  (18272, 17688, 280),
  (18273, 17689, 282),
  (18274, 17690, 283),
  (18275, 17691, 284),
  (18276, 17692, 282),
  (18277, 17693, 285),
  (18278, 17694, 288),
  (18279, 17695, 286),
  (18280, 17696, 287),
  (18281, 17697, 286),
  (18282, 17698, 288),
  (18283, 17699, 280),
  (18284, 17700, 281),
  (18285, 17701, 288),
  (18286, 17702, 282),
  (18287, 17703, 342),
  (18288, 17704, 284),
  (18289, 17705, 281),
  (18290, 17707, 462),
  (18291, 17708, 39),
  (18292, 17709, 465),
  (18293, 17710, 442),
  (18294, 17713, 462),
  (18295, 17714, 464),
  (18296, 17715, 264),
  (18297, 12132, 869),
  (18298, 12133, 864),
  (18299, 12135, 852),
  (18300, 12135, 853),
  (18301, 12136, 852),
  (18302, 12136, 854),
  (18303, 12137, 771),
  (18304, 12138, 872),
  (18305, 12139, 858),
  (18306, 12140, 855),
  (18307, 12141, 858),
  (18308, 12141, 851),
  (18309, 12142, 861),
  (18310, 12427, 861),
  (18311, 12143, 859),
  (18312, 12144, 860),
  (18313, 12145, 860),
  (18314, 12145, 784),
  (18315, 12146, 860),
  (18316, 12146, 784),
  (18317, 12147, 856),
  (18318, 12148, 856),
  (18319, 12149, 855),
  (18320, 12150, 855),
  (18321, 12151, 867),
  (18322, 12152, 867),
  (18323, 12153, 865),
  (18324, 12153, 866),
  (18325, 12154, 345),
  (18326, 12155, 869),
  (18327, 12156, 869),
  (18328, 12157, 862),
  (18329, 12158, 862),
  (18330, 12159, 870),
  (18331, 17716, 857),
  (18332, 12160, 863),
  (18333, 12161, 863),
  (18334, 12162, 850),
  (18335, 12163, 857),
  (18336, 12164, 871),
  (18337, 12165, 870),
  (18338, 12166, 857),
  (18339, 12430, 294),
  (18340, 12430, 264),
  (18341, 12436, 296),
  (18342, 17717, 298),
  (18343, 12451, 296),
  (18344, 12477, 575)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[6358, 12682, 12693, 12694, 12851, 12873, 12874, 12875, 12890, 12920, 13007, 13188, 13249, 13317]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24195, 12774, 3, '15:00:00', '16:50:00', E'UTN-03'),
  (24196, 12774, 5, '15:00:00', '16:50:00', E'UTN-03'),
  (24197, 12786, 3, '13:00:00', '14:50:00', E'UTN-03'),
  (24198, 12786, 5, '13:00:00', '14:50:00', E'UTN-03'),
  (24199, 17621, 3, '17:00:00', '20:50:00', NULL),
  (24200, 17622, 1, '17:00:00', '20:50:00', NULL),
  (24201, 17623, 4, '17:00:00', '20:50:00', NULL),
  (24202, 17624, 2, '17:00:00', '20:50:00', NULL),
  (24203, 17625, 3, '13:00:00', '16:50:00', NULL),
  (24204, 17626, 3, '07:00:00', '10:50:00', NULL),
  (24205, 17627, 1, '17:00:00', '20:50:00', NULL),
  (24206, 17627, 3, '17:00:00', '20:50:00', NULL),
  (24207, 17628, 1, '17:00:00', '20:50:00', NULL),
  (24208, 17628, 3, '17:00:00', '20:50:00', NULL),
  (24209, 17629, 2, '17:00:00', '20:50:00', NULL),
  (24210, 17629, 4, '17:00:00', '20:50:00', NULL),
  (24211, 17630, 1, '17:00:00', '20:50:00', NULL),
  (24212, 17630, 3, '17:00:00', '20:50:00', NULL),
  (24213, 17631, 1, '17:00:00', '20:50:00', NULL),
  (24214, 17631, 3, '17:00:00', '20:50:00', NULL),
  (24215, 17632, 1, '17:00:00', '20:50:00', NULL),
  (24216, 17632, 3, '17:00:00', '20:50:00', NULL),
  (24217, 17633, 1, '17:00:00', '20:50:00', NULL),
  (24218, 17633, 3, '17:00:00', '20:50:00', NULL),
  (24219, 17634, 3, '17:00:00', '20:50:00', NULL),
  (24220, 17634, 5, '17:00:00', '20:50:00', NULL),
  (24221, 17635, 2, '17:00:00', '20:50:00', NULL),
  (24222, 17635, 4, '17:00:00', '20:50:00', NULL),
  (24223, 17636, 2, '17:00:00', '20:50:00', NULL),
  (24224, 17636, 4, '17:00:00', '20:50:00', NULL),
  (24225, 17637, 2, '17:00:00', '20:50:00', NULL),
  (24226, 17637, 4, '17:00:00', '20:50:00', NULL),
  (24227, 17638, 2, '17:00:00', '20:50:00', NULL),
  (24228, 17638, 4, '17:00:00', '20:50:00', NULL),
  (24229, 17639, 2, '17:00:00', '20:50:00', NULL),
  (24230, 17639, 4, '17:00:00', '20:50:00', NULL),
  (24231, 17640, 1, '17:00:00', '20:50:00', NULL),
  (24232, 17640, 3, '17:00:00', '20:50:00', NULL),
  (24233, 17641, 1, '17:00:00', '20:50:00', NULL),
  (24234, 17641, 3, '17:00:00', '20:50:00', NULL),
  (24235, 12826, 3, '18:00:00', '20:50:00', E'D1-01'),
  (24236, 17642, 4, '07:30:00', '11:20:00', E'D1-01'),
  (24237, 17643, 5, '07:30:00', '11:20:00', E'B1-07'),
  (24238, 17644, 4, '18:00:00', '21:50:00', E'B1-07'),
  (24239, 17645, 2, '07:30:00', '11:20:00', E'B1-02'),
  (24240, 17646, 3, '08:30:00', '12:20:00', E'D3-11'),
  (24241, 17647, 5, '08:30:00', '12:20:00', E'D3-11'),
  (24242, 12855, 2, '17:00:00', '20:50:00', E'I6-02'),
  (24243, 12061, 2, '13:00:00', '16:50:00', E'G1-01'),
  (24244, 12064, 4, '13:00:00', '18:50:00', E'G1-04'),
  (24245, 12177, 2, '19:00:00', '20:50:00', E'B3-10'),
  (24246, 12177, 4, '19:00:00', '20:50:00', E'B3-10'),
  (24247, 12232, 2, '15:00:00', '16:50:00', E'B3-08'),
  (24248, 12232, 4, '15:00:00', '16:50:00', E'B3-08'),
  (24249, 12532, 3, '09:30:00', '11:20:00', E'F5-08'),
  (24250, 12532, 5, '09:30:00', '11:20:00', E'F5-08'),
  (24251, 12535, 2, '19:00:00', '20:50:00', E'F2-09'),
  (24252, 12535, 4, '19:00:00', '20:50:00', E'F2-09'),
  (24253, 17648, 4, '18:00:00', '20:50:00', E'F5-08'),
  (24254, 17649, 1, '17:00:00', '20:50:00', NULL),
  (24255, 17649, 3, '17:00:00', '20:50:00', NULL),
  (24256, 17650, 2, '17:00:00', '20:50:00', NULL),
  (24257, 17650, 4, '17:00:00', '20:50:00', NULL),
  (24258, 17651, 2, '17:00:00', '20:50:00', NULL),
  (24259, 17651, 4, '17:00:00', '20:50:00', NULL),
  (24260, 17652, 1, '17:00:00', '20:50:00', NULL),
  (24261, 17652, 3, '17:00:00', '20:50:00', NULL),
  (24262, 12926, 2, '18:00:00', '21:50:00', E'K6-03'),
  (24263, 12928, 4, '18:00:00', '19:50:00', E'K6-03'),
  (24264, 11960, 2, '07:30:00', '11:20:00', E'F4-03'),
  (24265, 17653, 2, '17:00:00', '20:50:00', NULL),
  (24266, 17653, 4, '17:00:00', '20:50:00', NULL),
  (24267, 17654, 1, '17:00:00', '20:50:00', NULL),
  (24268, 17654, 3, '17:00:00', '20:50:00', NULL),
  (24269, 17655, 2, '17:00:00', '20:50:00', NULL),
  (24270, 17655, 4, '17:00:00', '20:50:00', NULL),
  (24271, 17656, 1, '17:00:00', '20:50:00', NULL),
  (24272, 17656, 3, '17:00:00', '20:50:00', NULL),
  (24273, 17657, 2, '17:00:00', '20:50:00', NULL),
  (24274, 17657, 4, '17:00:00', '20:50:00', NULL),
  (24275, 17658, 2, '17:00:00', '20:50:00', NULL),
  (24276, 17658, 4, '17:00:00', '20:50:00', NULL),
  (24277, 12557, 1, '07:30:00', '12:20:00', E'H4-01'),
  (24278, 12565, 4, '17:00:00', '19:50:00', NULL),
  (24279, 12570, 5, '07:30:00', '10:20:00', E'H4-01'),
  (24280, 17659, 3, '17:00:00', '20:50:00', NULL),
  (24281, 17659, 6, '08:30:00', '12:20:00', NULL),
  (24282, 17660, 3, '17:00:00', '20:50:00', NULL),
  (24283, 17660, 6, '08:30:00', '12:20:00', NULL),
  (24284, 17661, 4, '17:00:00', '21:50:00', NULL),
  (24285, 17661, 6, '07:30:00', '12:20:00', NULL),
  (24286, 17662, 4, '18:00:00', '21:50:00', NULL),
  (24287, 17662, 6, '08:30:00', '12:20:00', NULL),
  (24288, 17663, 2, '17:00:00', '20:50:00', NULL),
  (24289, 17663, 4, '17:00:00', '20:50:00', NULL),
  (24290, 17664, 1, '17:00:00', '20:50:00', NULL),
  (24291, 17664, 3, '17:00:00', '20:50:00', NULL),
  (24292, 17665, 1, '17:00:00', '20:50:00', NULL),
  (24293, 17665, 3, '17:00:00', '20:50:00', NULL),
  (24294, 13003, 2, '13:00:00', '16:50:00', E'I3-01'),
  (24295, 13009, 4, '16:00:00', '16:50:00', NULL),
  (24296, 13026, 5, '13:00:00', '16:50:00', E'I3-01'),
  (24297, 13032, 3, '17:00:00', '20:50:00', E'I3-08'),
  (24298, 13033, 3, '10:30:00', '11:20:00', NULL),
  (24299, 13044, 3, '07:30:00', '11:20:00', E'I3-01'),
  (24300, 13055, 5, '13:00:00', '15:50:00', E'I3-04'),
  (24301, 13057, 2, '17:00:00', '20:50:00', E'I3-08'),
  (24302, 17666, 2, '09:30:00', '11:20:00', E'K5-02'),
  (24303, 17667, 2, '13:00:00', '14:50:00', E'K5-02'),
  (24304, 17668, 4, '07:30:00', '09:20:00', E'K5-02'),
  (24305, 17669, 4, '15:00:00', '16:50:00', E'K5-02'),
  (24306, 17670, 2, '07:30:00', '09:20:00', E'D3-05'),
  (24307, 17670, 4, '07:30:00', '09:20:00', E'D3-05'),
  (24308, 17671, 2, '09:30:00', '11:20:00', E'G18-03'),
  (24309, 17671, 4, '09:30:00', '11:20:00', E'G18-03'),
  (24310, 17672, 3, '09:30:00', '11:20:00', E'D3-02'),
  (24311, 17672, 5, '09:30:00', '11:20:00', E'D3-02'),
  (24312, 17673, 3, '13:00:00', '14:50:00', E'D3-13'),
  (24313, 17673, 5, '13:00:00', '14:50:00', E'D3-13'),
  (24314, 12728, 2, '07:30:00', '10:20:00', E'K2-02'),
  (24315, 17674, 1, '18:00:00', '21:50:00', NULL),
  (24316, 17675, 3, '18:00:00', '21:50:00', NULL),
  (24317, 17676, 1, '18:00:00', '21:50:00', NULL),
  (24318, 17677, 2, '18:00:00', '21:50:00', NULL),
  (24319, 17678, 3, '18:00:00', '21:50:00', NULL),
  (24320, 17679, 5, '18:00:00', '21:50:00', NULL),
  (24321, 17680, 4, '18:00:00', '21:50:00', NULL),
  (24322, 17681, 3, '18:00:00', '21:50:00', NULL),
  (24323, 17682, 5, '18:00:00', '21:50:00', NULL),
  (24324, 17683, 5, '18:00:00', '20:50:00', NULL),
  (24325, 17684, 1, '18:00:00', '21:50:00', NULL),
  (24326, 17685, 4, '18:00:00', '21:50:00', NULL),
  (24327, 17686, 2, '13:00:00', '14:50:00', NULL),
  (24328, 17686, 4, '13:00:00', '14:50:00', NULL),
  (24329, 17687, 2, '07:30:00', '09:20:00', NULL),
  (24330, 17687, 4, '07:30:00', '09:20:00', NULL),
  (24331, 17688, 3, '16:00:00', '17:50:00', NULL),
  (24332, 17688, 5, '13:00:00', '14:50:00', NULL),
  (24333, 17689, 3, '15:00:00', '16:50:00', NULL),
  (24334, 17689, 5, '15:00:00', '16:50:00', NULL),
  (24335, 17690, 6, '08:30:00', '12:20:00', NULL),
  (24336, 17691, 1, '16:00:00', '17:50:00', NULL),
  (24337, 17691, 3, '16:00:00', '17:50:00', NULL),
  (24338, 17692, 2, '13:00:00', '14:50:00', NULL),
  (24339, 17692, 4, '13:00:00', '14:50:00', NULL),
  (24340, 17693, 6, '08:30:00', '12:20:00', NULL),
  (24341, 17694, 3, '13:00:00', '14:50:00', NULL),
  (24342, 17694, 5, '13:00:00', '14:50:00', NULL),
  (24343, 17695, 2, '13:00:00', '14:50:00', NULL),
  (24344, 17695, 4, '13:00:00', '14:50:00', NULL),
  (24345, 17696, 1, '17:00:00', '18:50:00', NULL),
  (24346, 17696, 3, '17:00:00', '18:50:00', NULL),
  (24347, 17697, 2, '09:30:00', '11:20:00', NULL),
  (24348, 17697, 4, '09:30:00', '11:20:00', NULL),
  (24349, 17698, 2, '07:30:00', '09:20:00', NULL),
  (24350, 17698, 4, '07:30:00', '09:20:00', NULL),
  (24351, 17699, 3, '09:30:00', '11:20:00', NULL),
  (24352, 17699, 5, '09:30:00', '11:20:00', NULL),
  (24353, 17700, 2, '10:30:00', '12:20:00', NULL),
  (24354, 17700, 4, '09:30:00', '11:20:00', NULL),
  (24355, 17701, 2, '16:00:00', '17:50:00', NULL),
  (24356, 17701, 4, '16:00:00', '17:50:00', NULL),
  (24357, 17702, 3, '13:00:00', '14:50:00', NULL),
  (24358, 17702, 5, '13:00:00', '14:50:00', NULL),
  (24359, 17703, 5, '15:00:00', '18:50:00', NULL),
  (24360, 17704, 1, '18:00:00', '19:50:00', NULL),
  (24361, 17704, 3, '18:00:00', '19:50:00', NULL),
  (24362, 17705, 2, '13:00:00', '14:50:00', NULL),
  (24363, 17705, 4, '13:00:00', '14:50:00', NULL),
  (24364, 17706, 5, '07:30:00', '11:20:00', NULL),
  (24365, 17707, 3, '13:00:00', '16:50:00', NULL),
  (24366, 17708, 5, '13:00:00', '15:50:00', NULL),
  (24367, 17709, 2, '08:30:00', '11:20:00', NULL),
  (24368, 17710, 5, '13:00:00', '15:50:00', NULL),
  (24369, 17711, 4, '13:00:00', '15:50:00', NULL),
  (24370, 17712, 3, '13:00:00', '16:50:00', NULL),
  (24371, 17713, 4, '07:30:00', '11:20:00', NULL),
  (24372, 17714, 3, '07:30:00', '11:20:00', NULL),
  (24373, 12739, 2, '16:10:00', '18:50:00', E'A-15'),
  (24374, 12740, 2, '16:10:00', '18:50:00', NULL),
  (24375, 12743, 4, '09:45:00', '11:30:00', NULL),
  (24376, 12743, 4, '07:00:00', '09:40:00', E'A-15'),
  (24377, 12744, 4, '07:00:00', '09:40:00', NULL),
  (24378, 12744, 4, '12:30:00', '14:15:00', E'CAM-01'),
  (24379, 12745, 6, '07:55:00', '10:35:00', E'LAG-01'),
  (24380, 12746, 1, '14:20:00', '18:50:00', E'A-02'),
  (24381, 13065, 3, '09:45:00', '11:30:00', E'LAB-03'),
  (24382, 13065, 5, '09:45:00', '11:30:00', E'LAB-03'),
  (24383, 17715, 2, '09:45:00', '11:30:00', E'LAB-03'),
  (24384, 17715, 4, '09:45:00', '11:30:00', E'LAB-03'),
  (24385, 13099, 4, '17:05:00', '20:40:00', E'LAB-01'),
  (24386, 13120, 5, '09:45:00', '11:30:00', E'E-05'),
  (24387, 12422, 1, '17:30:00', '20:15:00', E'J06-05'),
  (24388, 17716, 3, '08:30:00', '11:20:00', E'J01-04'),
  (24389, 17717, 2, '09:30:00', '11:20:00', E'J06-01'),
  (24390, 17717, 4, '09:30:00', '11:20:00', E'J06-01'),
  (24391, 12058, 2, '17:30:00', '21:05:00', E'J06-02'),
  (16740, 5636, 5, '09:30:00', '11:20:00', NULL),
  (24392, 12464, 1, '17:30:00', '20:15:00', NULL),
  (24393, 12465, 6, '07:30:00', '13:50:00', NULL),
  (24394, 12470, 4, '17:30:00', '20:15:00', NULL),
  (24395, 12472, 1, '17:30:00', '20:15:00', NULL),
  (24396, 12473, 3, '17:30:00', '20:15:00', NULL),
  (24397, 12474, 3, '17:30:00', '20:15:00', NULL),
  (24398, 12476, 4, '17:30:00', '20:15:00', NULL),
  (24399, 12477, 3, '17:30:00', '20:15:00', NULL),
  (24400, 12478, 2, '17:30:00', '20:15:00', NULL),
  (24401, 12479, 2, '17:30:00', '20:15:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17591;
UPDATE public.course_offering_meeting SET classroom = E'B1-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17593;
UPDATE public.course_offering_meeting SET classroom = E'D3-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17594;
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17600;
UPDATE public.course_offering_meeting SET classroom = E'D1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17601;
UPDATE public.course_offering_meeting SET classroom = E'D1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17193;
UPDATE public.course_offering_meeting SET classroom = E'D1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17197;
UPDATE public.course_offering_meeting SET classroom = E'D3-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17614;
UPDATE public.course_offering_meeting SET classroom = E'D3-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17615;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17618;
UPDATE public.course_offering_meeting SET classroom = E'D3-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17619;
UPDATE public.course_offering_meeting SET classroom = E'D3-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17620;
UPDATE public.course_offering_meeting SET classroom = E'F5-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17621;
UPDATE public.course_offering_meeting SET classroom = E'D3-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17622;
UPDATE public.course_offering_meeting SET classroom = E'D3-02', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17623;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17625;
UPDATE public.course_offering_meeting SET classroom = E'D3-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17628;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17629;
UPDATE public.course_offering_meeting SET classroom = E'D3-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17630;
UPDATE public.course_offering_meeting SET classroom = E'F5-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17631;
UPDATE public.course_offering_meeting SET classroom = E'D3-14', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17632;
UPDATE public.course_offering_meeting SET classroom = E'D3-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17633;
UPDATE public.course_offering_meeting SET classroom = E'D3-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17634;
UPDATE public.course_offering_meeting SET classroom = E'D3-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17635;
UPDATE public.course_offering_meeting SET classroom = E'D3-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17643;
UPDATE public.course_offering_meeting SET classroom = E'D10-35', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17644;
UPDATE public.course_offering_meeting SET classroom = E'D3-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17646;
UPDATE public.course_offering_meeting SET classroom = E'G1-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16620;
UPDATE public.course_offering_meeting SET classroom = E'G1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16621;
UPDATE public.course_offering_meeting SET classroom = E'H6-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16628;
UPDATE public.course_offering_meeting SET classroom = E'G1-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16629;
UPDATE public.course_offering_meeting SET classroom = E'G1-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16632;
UPDATE public.course_offering_meeting SET classroom = E'F4-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17239;
UPDATE public.course_offering_meeting SET classroom = E'F4-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17240;
UPDATE public.course_offering_meeting SET classroom = E'F2-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17243;
UPDATE public.course_offering_meeting SET classroom = E'F2-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17244;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16346;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16347;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16348;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16349;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16351;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16352;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16353;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16354;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16355;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16356;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16357;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16358;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16359;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16360;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16361;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16362;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16363;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16364;
UPDATE public.course_offering_meeting SET classroom = E'F5-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16365;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16366;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16367;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16368;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16369;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16370;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16371;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16372;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16373;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16374;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16375;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16376;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16377;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16378;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16379;
UPDATE public.course_offering_meeting SET classroom = E'F5-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16380;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16381;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16382;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16383;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16384;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16385;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16386;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16387;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16388;
UPDATE public.course_offering_meeting SET classroom = E'F9-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16389;
UPDATE public.course_offering_meeting SET classroom = E'F9-05', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16390;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16391;
UPDATE public.course_offering_meeting SET classroom = E'F5-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16392;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16394;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16395;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16396;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16397;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16398;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16399;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16400;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16401;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16402;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16403;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16404;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16405;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16406;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16407;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16408;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16409;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16410;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16411;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16412;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16413;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16414;
UPDATE public.course_offering_meeting SET classroom = E'F9-07', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16415;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16416;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16417;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16418;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16419;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16420;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16421;
UPDATE public.course_offering_meeting SET classroom = E'F9-08', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16422;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16423;
UPDATE public.course_offering_meeting SET classroom = E'K1-18', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17808;
UPDATE public.course_offering_meeting SET classroom = E'K1-18', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17809;
UPDATE public.course_offering_meeting SET classroom = E'K1-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17823;
UPDATE public.course_offering_meeting SET classroom = E'K1-10', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17824;
UPDATE public.course_offering_meeting SET classroom = E'A-17', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17490;
UPDATE public.course_offering_meeting SET classroom = E'LAG-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17491;
UPDATE public.course_offering_meeting SET classroom = E'MVL-01', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17904;
UPDATE public.course_offering_meeting SET classroom = E'E-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17967;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[817, 11611, 16519, 16523, 16529, 16534, 16535, 16540, 16541, 16546, 16547, 16556, 16557, 16611, 16616, 16619, 16643, 16698, 16761, 16762, 16866, 16867, 17087, 17152, 17153, 17158, 17160, 17161, 17162, 17164, 17165, 17166, 17167, 17187, 17188, 17189, 17204, 17229, 17230, 17235, 17236, 17275, 17283, 17289, 17451, 17452, 17463, 17465, 17471, 17472, 17473, 17474, 17475, 17476, 17477, 17524, 17525, 17543, 17544, 17599, 17638, 17725, 17727, 17835, 17858, 17864, 17876, 17887, 17889, 17897, 17898, 17933, 17969]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
