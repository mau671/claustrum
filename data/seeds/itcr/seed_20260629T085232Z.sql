-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=3ba3b3ef5b1f6b59c79ba9daf8db1740ed19ea7ae98d52a71d81e90bf2328da3
-- TEC-DATA-META generated_at_utc=2026-06-29T08:52:32.309733+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course
UPDATE public.course SET name = E'GESTIÓN ESTRATÉGICA DE RECURSOS NATURALES', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 4166;

-- table: professor
INSERT INTO public.professor
  (id, full_name)
VALUES
  (1317, E'CALDERON HERNANDEZ ANA GABRIELA'),
  (1318, E'CALVO OBANDO ANA JULIETA'),
  (1319, E'CORDOBA MENESES ALEJANDRO'),
  (1320, E'HERRERO CHAVARRIA FELIPE'),
  (1321, E'MORALES PIÑERO JUAN CARLOS'),
  (1322, E'PINNOCK CHACON MAC'),
  (1323, E'RETANA CORRALES LUIS FELIPE'),
  (1324, E'ROJAS SANTAMARIA ROY FERNANDO'),
  (1325, E'SANCHEZ MASIS ALLAN ROBERTO'),
  (1326, E'VALVERDE GARDELA HERBERTH')
ON CONFLICT (full_name) DO NOTHING;

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (10828, 1514, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10829, 1515, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10830, 1516, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10831, 1527, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10832, 1528, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10833, 1530, 3, 18, 25, 7, 56, E'CURSO UNICO'),
  (10834, 1531, 3, 18, 25, 7, 56, E'TRABAJO FINAL DE GRADUACION'),
  (10835, 1525, 3, 18, 25, 7, 56, E'CURSO UNICO'),
  (10836, 1519, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10837, 212, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10838, 215, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10839, 213, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10840, 214, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10841, 233, 3, 18, 25, 4, 32, E'CURSO UNICO'),
  (10842, 541, 3, 6, 102, 2, 3, E'CURSO UNICO'),
  (10843, 462, 3, 19, 25, 4, 12, E'CURSO UNICO'),
  (10844, 468, 3, 19, 25, 4, 12, E'CURSO UNICO'),
  (10845, 488, 3, 19, 25, 2, 6, E'CURSO UNICO'),
  (10846, 489, 3, 19, 25, 2, 6, E'CURSO UNICO'),
  (10847, 3651, 3, 60, 25, 4, 32, E'CURSO COMUN'),
  (10848, 3674, 3, 60, 25, 4, 32, E'CURSO UNICO'),
  (10849, 3659, 3, 60, 25, 4, 33, E'CURSO UNICO'),
  (10850, 4156, 3, 70, 113, 4, 4, E'CURSO UNICO'),
  (10851, 4161, 3, 70, 113, 4, 4, E'CURSO UNICO'),
  (10852, 4166, 3, 70, 113, 4, 4, E'CURSO UNICO'),
  (10853, 4162, 3, 70, 113, 4, 4, E'CURSO UNICO'),
  (10854, 4194, 3, 70, 113, 6, 4, E'CURSO UNICO'),
  (10855, 2472, 13, 2, 102, 3, 9, E'ELECTIVA UNICA'),
  (10856, 305, 19, 47, 25, 3, 18, E'CURSO UNICO'),
  (10857, 500, 19, 83, 102, 0, 2, E'CURSO COMUN'),
  (10858, 3463, 22, 47, 102, 3, 9, E'CURSO UNICO'),
  (10859, 4869, 22, 88, 113, 4, 18, E'CURSO UNICO'),
  (10860, 317, 22, 88, 113, 4, 18, E'ELECTIVA UNICA'),
  (10861, 320, 22, 88, 113, 4, 18, E'CURSO UNICO'),
  (10862, 324, 22, 88, 113, 4, 18, E'CURSO UNICO')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10709;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10710;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10711;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10712;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10713;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10714;
UPDATE public.course_offering SET weekly_hours_snapshot = 56, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10715;
UPDATE public.course_offering SET weekly_hours_snapshot = 56, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10716;
UPDATE public.course_offering SET weekly_hours_snapshot = 56, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10717;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10718;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10719;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10720;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10721;
UPDATE public.course_offering SET weekly_hours_snapshot = 12, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10725;
UPDATE public.course_offering SET weekly_hours_snapshot = 12, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10726;
UPDATE public.course_offering SET weekly_hours_snapshot = 12, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10727;
UPDATE public.course_offering SET weekly_hours_snapshot = 24, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10728;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10729;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10730;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10731;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10732;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10733;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10734;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10793;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10794;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10795;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10796;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10797;
UPDATE public.course_offering SET weekly_hours_snapshot = 46, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10798;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10816;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10817;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10818;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10819;
UPDATE public.course_offering SET weekly_hours_snapshot = 30, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10820;
UPDATE public.course_offering SET weekly_hours_snapshot = 8, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10821;
UPDATE public.course_offering SET weekly_hours_snapshot = 8, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10822;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10735;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10736;
UPDATE public.course_offering SET weekly_hours_snapshot = 40, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10737;
UPDATE public.course_offering SET weekly_hours_snapshot = 40, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10738;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10739;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10740;
UPDATE public.course_offering SET weekly_hours_snapshot = 32, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10741;
UPDATE public.course_offering SET weekly_hours_snapshot = 9, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10824;
UPDATE public.course_offering SET weekly_hours_snapshot = 24, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10825;
UPDATE public.course_offering SET weekly_hours_snapshot = 20, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10826;
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[7142, 7414, 7532, 10753, 10802]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17768, 10828, E'01', E'VIRTUAL', 30),
  (17769, 10829, E'01', E'VIRTUAL', 30),
  (17770, 10830, E'01', E'VIRTUAL', 30),
  (17771, 10831, E'01', E'VIRTUAL', 25),
  (17772, 10832, E'01', E'VIRTUAL', 25),
  (17773, 10833, E'01', E'VIRTUAL', 15),
  (17774, 10834, E'01', E'VIRTUAL', 15),
  (17775, 10835, E'01', E'VIRTUAL', 10),
  (17776, 10836, E'01', E'VIRTUAL', 10),
  (17777, 10837, E'01', E'VIRTUAL', 10),
  (17778, 10838, E'01', E'VIRTUAL', 30),
  (17779, 10839, E'01', E'VIRTUAL', 30),
  (17780, 10840, E'01', E'VIRTUAL', 30),
  (17781, 10841, E'01', E'VIRTUAL', 10),
  (17782, 10842, E'01', E'REGULAR', 32),
  (17783, 10843, E'01', E'VIRTUAL', 30),
  (17784, 10844, E'01', E'VIRTUAL', 25),
  (17785, 10845, E'01', E'VIRTUAL', 20),
  (17786, 10846, E'01', E'VIRTUAL', 20),
  (17787, 7805, E'04', E'REGULAR', 37),
  (17788, 7806, E'04', E'REGULAR', 27),
  (17789, 7560, E'02', E'REGULAR', 12),
  (17790, 10847, E'01', E'VIRTUAL', 30),
  (17791, 10848, E'01', E'VIRTUAL', 30),
  (17792, 10849, E'01', E'VIRTUAL', 30),
  (17793, 10850, E'01', E'SEMIPRESENCIAL', 15),
  (17794, 10851, E'01', E'SEMIPRESENCIAL', 15),
  (17795, 10852, E'01', E'SEMIPRESENCIAL', 15),
  (17796, 10853, E'01', E'SEMIPRESENCIAL', 15),
  (17797, 10854, E'01', E'SEMIPRESENCIAL', 15),
  (17798, 10855, E'60', E'SEMIPRESENCIAL', 32),
  (17799, 10856, E'50', E'VIRTUAL', 40),
  (17800, 10857, E'50', E'REGULAR', 16),
  (17801, 10858, E'40', E'VIRTUAL', 35),
  (17802, 10859, E'40', E'VIRTUAL', 30),
  (17803, 10860, E'40', E'VIRTUAL', 30),
  (17804, 10861, E'40', E'VIRTUAL', 30),
  (17805, 10862, E'40', E'VIRTUAL', 30)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group SET group_type = E'SEMIPRESENCIAL', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12853;
UPDATE public.course_offering_group SET capacity = 27, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11841;
UPDATE public.course_offering_group SET capacity = 25, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 11876;
UPDATE public.course_offering_group SET capacity = 27, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 2607;
UPDATE public.course_offering_group SET group_type = E'TUTORIA', capacity = 5, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 5256;
UPDATE public.course_offering_group SET group_type = E'TUTORIA', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 10130;
UPDATE public.course_offering_group SET capacity = 7, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12362;
UPDATE public.course_offering_group SET capacity = 31, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12364;
UPDATE public.course_offering_group SET capacity = 11, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12367;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12578;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12579;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12580;
UPDATE public.course_offering_group SET capacity = 12, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12591;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12618;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12619;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12620;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12621;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12622;
UPDATE public.course_offering_group SET capacity = 10, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 12623;
UPDATE public.course_offering_group SET capacity = 29, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 17675;
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[11887, 12393, 12552, 12624, 12625, 17685, 17739]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18523, 10598, 527),
  (18524, 17768, 1317),
  (18525, 17769, 898),
  (18526, 17770, 1000),
  (18527, 17771, 59),
  (18528, 17772, 560),
  (18529, 17773, 561),
  (18530, 17774, 560),
  (18531, 17775, 562),
  (18532, 17776, 910),
  (18533, 17777, 565),
  (18534, 17778, 50),
  (18535, 17779, 1137),
  (18536, 17780, 1108),
  (18537, 17781, 1000),
  (18538, 2761, 185),
  (18539, 17782, 154),
  (18540, 17783, 1321),
  (18541, 17784, 562),
  (18542, 17785, 70),
  (18543, 17786, 70),
  (18544, 7761, 1180),
  (18545, 2091, 710),
  (18546, 6506, 710),
  (18547, 5610, 712),
  (18548, 8072, 1180),
  (18549, 12950, 1319),
  (18550, 12952, 1326),
  (18551, 17787, 1320),
  (18552, 17788, 1322),
  (18553, 12956, 1322),
  (18554, 12964, 1323),
  (18555, 12973, 1325),
  (18556, 11803, 92),
  (18557, 12578, 83),
  (18558, 12583, 88),
  (18559, 17789, 84),
  (18560, 12598, 106),
  (18561, 12605, 103),
  (18562, 12611, 104),
  (18563, 12615, 105),
  (18564, 12616, 83),
  (18565, 12620, 91),
  (18566, 12623, 1074),
  (18567, 17790, 337),
  (18568, 17791, 1047),
  (18569, 17792, 256),
  (13007, 12641, 246),
  (18570, 17793, 641),
  (18571, 17794, 653),
  (18572, 17795, 654),
  (18573, 17796, 1318),
  (18574, 17797, 781),
  (18575, 6968, 450),
  (18576, 9686, 548),
  (18577, 11037, 535),
  (18578, 9670, 554),
  (18579, 7654, 551),
  (18580, 7658, 546),
  (18581, 17798, 35),
  (18582, 17799, 51),
  (18583, 17800, 845),
  (18584, 4494, 1324),
  (18585, 6544, 1324),
  (18586, 9593, 1324),
  (18587, 4958, 51),
  (18588, 17801, 16),
  (18589, 17802, 337),
  (18590, 17803, 340),
  (18591, 17804, 1092),
  (18592, 17805, 958)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[564, 688, 1287, 1395, 3395, 3435, 3448, 3450, 3819, 3989, 4409, 4918, 5628, 6417, 8044, 8099, 8111, 8445, 8622, 9587, 9656, 9868, 10115, 10230, 10830, 11149, 12766, 12946, 12951, 12967, 12974, 12980, 12984, 12985, 12989, 12992, 12993, 18268, 18390, 18450]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24507, 17768, 2, '17:00:00', '20:50:00', NULL),
  (24508, 17768, 4, '17:00:00', '20:50:00', NULL),
  (24509, 17769, 1, '17:00:00', '20:50:00', NULL),
  (24510, 17769, 3, '17:00:00', '20:50:00', NULL),
  (24511, 17770, 1, '17:00:00', '20:50:00', NULL),
  (24512, 17770, 3, '17:00:00', '20:50:00', NULL),
  (24513, 17771, 1, '17:00:00', '20:50:00', NULL),
  (24514, 17771, 3, '17:00:00', '20:50:00', NULL),
  (24515, 17772, 1, '17:00:00', '20:50:00', NULL),
  (24516, 17772, 3, '17:00:00', '20:50:00', NULL),
  (24517, 17773, 1, '17:00:00', '20:50:00', NULL),
  (24518, 17773, 3, '17:00:00', '20:50:00', NULL),
  (24519, 17774, 3, '17:00:00', '20:50:00', NULL),
  (24520, 17774, 5, '17:00:00', '20:50:00', NULL),
  (24521, 17775, 1, '17:00:00', '20:50:00', NULL),
  (24522, 17775, 3, '17:00:00', '20:50:00', NULL),
  (24523, 17776, 2, '17:00:00', '20:50:00', NULL),
  (24524, 17776, 4, '17:00:00', '20:50:00', NULL),
  (24525, 17777, 1, '17:00:00', '20:50:00', NULL),
  (24526, 17777, 3, '17:00:00', '20:50:00', NULL),
  (24527, 17778, 1, '17:00:00', '20:50:00', NULL),
  (24528, 17778, 3, '17:00:00', '20:50:00', NULL),
  (24529, 17779, 1, '17:00:00', '20:50:00', NULL),
  (24530, 17779, 3, '17:00:00', '20:50:00', NULL),
  (24531, 17780, 2, '17:00:00', '20:50:00', NULL),
  (24532, 17780, 4, '17:00:00', '20:50:00', NULL),
  (24533, 17781, 2, '17:00:00', '20:50:00', NULL),
  (24534, 17781, 4, '17:00:00', '20:50:00', NULL),
  (24535, 12853, 4, '13:00:00', '16:50:00', E'D3-13'),
  (24536, 17782, 1, '18:00:00', '20:50:00', E'F9-07'),
  (24537, 17783, 1, '17:00:00', '20:50:00', NULL),
  (24538, 17783, 3, '17:00:00', '20:50:00', NULL),
  (24539, 17784, 2, '17:00:00', '20:50:00', NULL),
  (24540, 17784, 4, '17:00:00', '20:50:00', NULL),
  (24541, 17785, 2, '17:00:00', '19:50:00', NULL),
  (24542, 17786, 4, '17:00:00', '19:50:00', NULL),
  (24543, 12950, 3, '17:00:00', '18:50:00', E'K1-11'),
  (24544, 12950, 5, '17:00:00', '18:50:00', E'K1-11'),
  (24545, 17787, 2, '17:00:00', '18:50:00', E'K1-18'),
  (24546, 17787, 4, '17:00:00', '18:50:00', E'K1-18'),
  (24547, 17788, 3, '17:00:00', '18:50:00', E'K1-10'),
  (24548, 17788, 5, '09:30:00', '11:20:00', E'K1-10'),
  (24549, 12964, 6, '07:30:00', '11:20:00', E'K1-10'),
  (24550, 12577, 3, '07:30:00', '11:20:00', E'I4-01'),
  (24551, 17789, 5, '07:30:00', '11:20:00', E'I1-02'),
  (24552, 12605, 5, '17:00:00', '20:50:00', E'I4-01'),
  (24553, 12614, 1, '07:30:00', '11:20:00', E'I1-02'),
  (24554, 17790, 2, '17:00:00', '20:50:00', NULL),
  (24555, 17790, 4, '17:00:00', '20:50:00', NULL),
  (24556, 17791, 1, '17:00:00', '20:50:00', NULL),
  (24557, 17791, 3, '17:00:00', '20:50:00', NULL),
  (24558, 17792, 1, '17:00:00', '20:50:00', NULL),
  (24559, 17792, 3, '17:00:00', '20:50:00', NULL),
  (24560, 17793, 5, '17:00:00', '20:50:00', E'L3-06'),
  (24561, 17794, 6, '07:30:00', '11:20:00', E'L3-01'),
  (24562, 17795, 6, '13:00:00', '16:50:00', E'L3-02'),
  (24563, 17796, 6, '13:00:00', '16:50:00', E'L3-06'),
  (24564, 17797, 6, '07:30:00', '11:20:00', E'L3-02'),
  (24565, 17675, 4, '18:00:00', '21:50:00', E'L-01'),
  (24566, 17798, 4, '18:00:00', '21:50:00', E'L-07'),
  (24567, 17799, 2, '17:05:00', '21:35:00', NULL),
  (24568, 17799, 4, '17:05:00', '21:35:00', NULL),
  (24569, 17800, 4, '16:10:00', '17:55:00', E'C-02'),
  (24570, 17801, 1, '18:20:00', '21:05:00', NULL),
  (24571, 755, 3, '09:30:00', '11:20:00', E'J06-01'),
  (24572, 755, 5, '09:30:00', '11:20:00', E'J06-01'),
  (24573, 7012, 1, '07:30:00', '09:20:00', NULL),
  (24574, 17802, 3, '17:00:00', '18:50:00', NULL),
  (24575, 17802, 5, '17:00:00', '18:50:00', NULL),
  (24576, 17803, 2, '17:00:00', '18:50:00', NULL),
  (24577, 17803, 4, '17:00:00', '18:50:00', NULL),
  (24578, 17804, 2, '17:00:00', '18:50:00', NULL),
  (24579, 17804, 4, '17:00:00', '18:50:00', NULL),
  (24580, 17805, 3, '17:00:00', '18:50:00', NULL),
  (24581, 17805, 5, '17:00:00', '18:50:00', NULL)
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting SET classroom = NULL, is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 24253;
UPDATE public.course_offering_meeting SET classroom = E'F9-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16348;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16350;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16639;
UPDATE public.course_offering_meeting SET classroom = E'F5-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16428;
UPDATE public.course_offering_meeting SET classroom = E'F5-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16430;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16431;
UPDATE public.course_offering_meeting SET classroom = E'F9-06', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16433;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16435;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16436;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16437;
UPDATE public.course_offering_meeting SET classroom = E'F5-04', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16438;
UPDATE public.course_offering_meeting SET classroom = E'F9-09', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 16439;
UPDATE public.course_offering_meeting SET classroom = E'J06-03', is_active = TRUE, deactivated_at = NULL, updated_at = NOW() WHERE id = 862;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[552, 16394, 17058, 17267, 17268, 17296, 17325, 17334, 17344, 17345, 17636, 17752, 17753, 17775, 24316, 24326, 24449]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
