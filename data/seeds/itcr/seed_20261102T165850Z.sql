-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=fde2c015fcd5d14fc46780f6bb9833cf2782adc669c9063f6055dfcd9d53fab5
-- TEC-DATA-META generated_at_utc=2026-11-02T16:58:50.225448+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: room
INSERT INTO public.room
  (campus_id, building, number)
VALUES
  (3, E'F4', 7)
ON CONFLICT (campus_id, building, number) DO UPDATE SET updated_at = NOW();

-- table: course_offering
INSERT INTO public.course_offering
  (id, course_id, campus_id, academic_unit_id, academic_term_id, credits_snapshot, weekly_hours_snapshot, course_type)
VALUES
  (11224, 699, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11225, 765, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11226, 799, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11227, 802, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11228, 821, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11229, 826, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11230, 852, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11231, 892, 1, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11232, 2587, 3, 34, 117, 3, 11, E'CURSO UNICO'),
  (11233, 2573, 3, 34, 117, 3, 11, E'CURSO UNICO'),
  (11234, 2575, 3, 34, 117, 3, 11, E'CURSO UNICO'),
  (11235, 2525, 3, 6, 117, 2, 8, E'CURSO UNICO'),
  (11236, 1272, 3, 12, 117, 3, 11, E'CURSO UNICO'),
  (11237, 583, 22, 7, 117, 0, 6, E'CURSO COMUN'),
  (11238, 659, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11239, 673, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11240, 810, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11241, 839, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11242, 846, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11243, 858, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION'),
  (11244, 919, 22, 17, 117, 0, 2, E'CENTROS DE FORMACION')
ON CONFLICT (course_id, campus_id, academic_unit_id, academic_term_id) DO UPDATE SET credits_snapshot = EXCLUDED.credits_snapshot, weekly_hours_snapshot = EXCLUDED.weekly_hours_snapshot, course_type = EXCLUDED.course_type, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE id = ANY(ARRAY[10953]::BIGINT[]) AND academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]);

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (18275, 11224, 20, E'VIRTUAL', 40),
  (18276, 11225, 20, E'VIRTUAL', 40),
  (18277, 11226, 20, E'VIRTUAL', 40),
  (18278, 11227, 20, E'VIRTUAL', 40),
  (18279, 11228, 20, E'VIRTUAL', 40),
  (18280, 11229, 20, E'VIRTUAL', 40),
  (18281, 11230, 20, E'VIRTUAL', 40),
  (18282, 11231, 20, E'VIRTUAL', 40),
  (18283, 11232, 1, E'VIRTUAL', 40),
  (18284, 11233, 1, E'VIRTUAL', 40),
  (18285, 11234, 1, E'VIRTUAL', 40),
  (18286, 11235, 1, E'REGULAR', 32),
  (18287, 11236, 1, E'SEMIPRESENCIAL', 30),
  (18288, 11237, 40, E'REGULAR', 24),
  (18289, 11238, 40, E'VIRTUAL', 40),
  (18290, 11239, 40, E'VIRTUAL', 40),
  (18291, 11240, 40, E'VIRTUAL', 40),
  (18292, 11241, 40, E'VIRTUAL', 40),
  (18293, 11242, 40, E'VIRTUAL', 40),
  (18294, 11243, 40, E'VIRTUAL', 40),
  (18295, 11244, 40, E'VIRTUAL', 40)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group g SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE g.id = ANY(ARRAY[17960]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering co WHERE co.id = g.course_offering_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (19203, 18275, 807),
  (19204, 18276, 147),
  (19205, 18277, 807),
  (19206, 18278, 148),
  (19207, 18279, 805),
  (19208, 18280, 1002),
  (19209, 18281, 911),
  (19210, 18282, 151),
  (19211, 18283, 676),
  (19212, 18284, 1016),
  (19213, 18285, 677),
  (19214, 17983, 190),
  (19215, 18286, 155),
  (19216, 18287, 407),
  (19217, 18288, 189),
  (19218, 18289, 807),
  (19219, 18290, 956),
  (19220, 18291, 162),
  (19221, 18292, 1052),
  (19222, 18293, 805),
  (19223, 18294, 166),
  (19224, 18295, 164)
ON CONFLICT (course_offering_group_id, professor_id) DO UPDATE SET is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[18853]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom, room_id)
VALUES
  (25532, 18275, 3, '09:00:00', '12:50:00', NULL, NULL),
  (25533, 18275, 4, '09:00:00', '12:50:00', NULL, NULL),
  (25534, 18275, 5, '09:00:00', '12:50:00', NULL, NULL),
  (25535, 18276, 3, '09:00:00', '11:50:00', NULL, NULL),
  (25536, 18276, 4, '09:00:00', '11:50:00', NULL, NULL),
  (25537, 18276, 5, '09:00:00', '11:50:00', NULL, NULL),
  (25538, 18276, 6, '09:00:00', '11:50:00', NULL, NULL),
  (25539, 18277, 3, '09:00:00', '12:50:00', NULL, NULL),
  (25540, 18277, 4, '09:00:00', '12:50:00', NULL, NULL),
  (25541, 18277, 5, '09:00:00', '12:50:00', NULL, NULL),
  (25542, 18278, 3, '17:00:00', '20:50:00', NULL, NULL),
  (25543, 18278, 4, '17:00:00', '20:50:00', NULL, NULL),
  (25544, 18278, 5, '17:00:00', '20:50:00', NULL, NULL),
  (25545, 18279, 3, '09:00:00', '12:50:00', NULL, NULL),
  (25546, 18279, 4, '09:00:00', '12:50:00', NULL, NULL),
  (25547, 18279, 5, '09:00:00', '12:50:00', NULL, NULL),
  (25548, 18279, 6, '09:00:00', '12:50:00', NULL, NULL),
  (25549, 18280, 3, '17:00:00', '20:50:00', NULL, NULL),
  (25550, 18280, 4, '17:00:00', '20:50:00', NULL, NULL),
  (25551, 18280, 5, '17:00:00', '20:50:00', NULL, NULL),
  (25552, 18281, 3, '18:00:00', '20:50:00', NULL, NULL),
  (25553, 18281, 4, '18:00:00', '20:50:00', NULL, NULL),
  (25554, 18281, 5, '18:00:00', '20:50:00', NULL, NULL),
  (25555, 18281, 6, '18:00:00', '20:50:00', NULL, NULL),
  (25556, 18282, 3, '09:00:00', '11:50:00', NULL, NULL),
  (25557, 18282, 4, '09:00:00', '11:50:00', NULL, NULL),
  (25558, 18282, 5, '09:00:00', '11:50:00', NULL, NULL),
  (25559, 18282, 6, '09:00:00', '11:50:00', NULL, NULL),
  (25560, 17954, 1, '18:00:00', '21:50:00', NULL, NULL),
  (25561, 17954, 3, '18:00:00', '21:50:00', NULL, NULL),
  (25562, 17954, 5, '18:00:00', '20:50:00', NULL, NULL),
  (25563, 18283, 1, '13:00:00', '16:50:00', NULL, NULL),
  (25564, 18283, 2, '13:00:00', '16:50:00', NULL, NULL),
  (25565, 18283, 3, '09:30:00', '12:20:00', NULL, NULL),
  (25566, 18284, 1, '15:00:00', '18:50:00', NULL, NULL),
  (25567, 18284, 2, '15:00:00', '18:50:00', NULL, NULL),
  (25568, 18284, 4, '17:00:00', '19:50:00', NULL, NULL),
  (25569, 18285, 3, '17:00:00', '20:50:00', NULL, NULL),
  (25570, 18285, 4, '17:00:00', '20:50:00', NULL, NULL),
  (25571, 18285, 5, '16:00:00', '18:50:00', NULL, NULL),
  (25572, 17972, 3, '08:30:00', '12:20:00', NULL, NULL),
  (25573, 17972, 4, '08:30:00', '11:20:00', NULL, NULL),
  (25574, 17977, 2, '07:30:00', '11:20:00', NULL, NULL),
  (25575, 17977, 3, '07:30:00', '11:20:00', NULL, NULL),
  (25576, 17977, 4, '07:30:00', '10:20:00', NULL, NULL),
  (25577, 17978, 2, '07:30:00', '11:20:00', NULL, NULL),
  (25578, 17978, 3, '07:30:00', '11:20:00', NULL, NULL),
  (25579, 17978, 5, '07:30:00', '10:20:00', NULL, NULL),
  (25580, 17995, 2, '08:30:00', '12:20:00', E'F9-007', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17995))),
  (25581, 17995, 4, '08:30:00', '12:20:00', E'F9-007', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17995))),
  (25582, 17996, 1, '08:30:00', '12:20:00', E'F9-007', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17996))),
  (25583, 17996, 3, '08:30:00', '12:20:00', E'F9-007', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17996))),
  (25584, 18286, 2, '07:30:00', '11:20:00', E'F9-006', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 6 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18286))),
  (25585, 18286, 4, '07:30:00', '11:20:00', E'F9-006', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 6 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18286))),
  (25586, 17999, 3, '13:00:00', '16:50:00', NULL, NULL),
  (25587, 18001, 2, '08:30:00', '11:20:00', NULL, NULL),
  (25588, 18001, 3, '08:30:00', '11:20:00', NULL, NULL),
  (25589, 18001, 5, '08:30:00', '10:20:00', NULL, NULL),
  (25590, 18004, 1, '08:30:00', '11:20:00', NULL, NULL),
  (25591, 18004, 2, '08:30:00', '11:20:00', NULL, NULL),
  (25592, 18007, 3, '08:30:00', '11:20:00', NULL, NULL),
  (25593, 18007, 4, '08:30:00', '11:20:00', NULL, NULL),
  (25594, 18007, 5, '08:30:00', '10:20:00', NULL, NULL),
  (25595, 18034, 4, '08:30:00', '11:20:00', E'F4-007', (SELECT r.id FROM public.room r WHERE r.building = 'F4' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18034))),
  (25596, 18287, 2, '07:30:00', '11:20:00', E'K1-110', (SELECT r.id FROM public.room r WHERE r.building = 'K1' AND r.number = 110 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18287))),
  (25597, 18287, 3, '07:30:00', '11:20:00', E'K1-110', (SELECT r.id FROM public.room r WHERE r.building = 'K1' AND r.number = 110 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18287))),
  (25598, 18287, 4, '07:30:00', '10:20:00', E'K1-110', (SELECT r.id FROM public.room r WHERE r.building = 'K1' AND r.number = 110 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18287))),
  (25599, 18173, 4, '07:30:00', '11:20:00', E'I3-007', (SELECT r.id FROM public.room r WHERE r.building = 'I3' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18173))),
  (25600, 18173, 5, '07:30:00', '11:20:00', E'I3-007', (SELECT r.id FROM public.room r WHERE r.building = 'I3' AND r.number = 7 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18173))),
  (25601, 18288, 3, '09:30:00', '12:20:00', NULL, NULL),
  (25602, 18288, 4, '09:30:00', '12:20:00', NULL, NULL),
  (25603, 18289, 3, '17:30:00', '21:05:00', NULL, NULL),
  (25604, 18289, 4, '17:30:00', '21:05:00', NULL, NULL),
  (25605, 18289, 5, '17:30:00', '21:05:00', NULL, NULL),
  (25606, 18290, 3, '18:20:00', '21:55:00', NULL, NULL),
  (25607, 18290, 4, '18:20:00', '21:55:00', NULL, NULL),
  (25608, 18290, 5, '18:20:00', '21:55:00', NULL, NULL),
  (25609, 18291, 3, '17:30:00', '20:15:00', NULL, NULL),
  (25610, 18291, 4, '17:30:00', '20:15:00', NULL, NULL),
  (25611, 18291, 5, '17:30:00', '20:15:00', NULL, NULL),
  (25612, 18291, 6, '17:30:00', '20:15:00', NULL, NULL),
  (25613, 18292, 3, '18:20:00', '21:05:00', NULL, NULL),
  (25614, 18292, 4, '18:20:00', '21:05:00', NULL, NULL),
  (25615, 18292, 5, '18:20:00', '21:05:00', NULL, NULL),
  (25616, 18292, 6, '18:20:00', '21:05:00', NULL, NULL),
  (25617, 18293, 3, '14:00:00', '16:50:00', NULL, NULL),
  (25618, 18293, 4, '14:00:00', '16:50:00', NULL, NULL),
  (25619, 18293, 5, '14:00:00', '16:50:00', NULL, NULL),
  (25620, 18293, 6, '14:00:00', '16:50:00', NULL, NULL),
  (25621, 18294, 3, '13:00:00', '16:50:00', NULL, NULL),
  (25622, 18294, 4, '13:00:00', '16:50:00', NULL, NULL),
  (25623, 18294, 5, '13:00:00', '16:50:00', NULL, NULL),
  (25624, 18294, 6, '13:00:00', '16:50:00', NULL, NULL),
  (25625, 18295, 3, '07:30:00', '11:20:00', NULL, NULL),
  (25626, 18295, 4, '07:30:00', '11:20:00', NULL, NULL),
  (25627, 18295, 5, '07:30:00', '11:20:00', NULL, NULL),
  (25628, 18265, 2, '17:30:00', '20:15:00', E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18265))),
  (25629, 18265, 3, '17:30:00', '20:15:00', E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18265))),
  (25630, 18265, 5, '17:30:00', '19:10:00', E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18265))),
  (25631, 18266, 2, '17:30:00', '20:15:00', E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18266))),
  (25632, 18266, 3, '17:30:00', '20:15:00', E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18266))),
  (25633, 18266, 5, '17:30:00', '19:10:00', E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18266))),
  (25634, 18268, 2, '17:30:00', '20:15:00', E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18268))),
  (25635, 18268, 3, '17:30:00', '20:15:00', E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18268))),
  (25636, 18268, 5, '17:30:00', '19:10:00', E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18268)))
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, room_id = EXCLUDED.room_id, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting AS t
SET
  classroom = nv.classroom::TEXT,
  room_id = nv.room_id::BIGINT,
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW()
FROM (VALUES
  (24932, E'F9-009', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 9 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17989))),
  (24933, E'F9-009', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 9 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17989))),
  (24934, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17990))),
  (24935, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17990))),
  (24936, E'F9-005', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 5 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17991))),
  (24937, E'F9-005', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 5 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17991))),
  (24938, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17992))),
  (24939, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17992))),
  (24940, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17993))),
  (24941, E'F9-004', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 4 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17993))),
  (24942, E'F9-008', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 8 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17994))),
  (24943, E'F9-008', (SELECT r.id FROM public.room r WHERE r.building = 'F9' AND r.number = 8 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 17994))),
  (25053, E'D3-009', (SELECT r.id FROM public.room r WHERE r.building = 'D3' AND r.number = 9 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18058))),
  (25054, E'D3-009', (SELECT r.id FROM public.room r WHERE r.building = 'D3' AND r.number = 9 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18058))),
  (25063, E'D3-013', (SELECT r.id FROM public.room r WHERE r.building = 'D3' AND r.number = 13 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18061))),
  (25064, E'D3-013', (SELECT r.id FROM public.room r WHERE r.building = 'D3' AND r.number = 13 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18061))),
  (16685, E'D3-003', (SELECT r.id FROM public.room r WHERE r.building = 'D3' AND r.number = 3 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 12122))),
  (25487, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18255))),
  (25488, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18255))),
  (25489, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18256))),
  (25490, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18256))),
  (25491, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18257))),
  (25492, E'J06-101', (SELECT r.id FROM public.room r WHERE r.building = 'J06' AND r.number = 101 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18257))),
  (25497, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18262))),
  (25498, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18262))),
  (25499, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18262))),
  (25500, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18263))),
  (25501, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18263))),
  (25502, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18263))),
  (25503, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18264))),
  (25504, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18264))),
  (25505, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18264))),
  (25508, E'J01-201', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 201 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18265))),
  (25511, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18266))),
  (25512, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18267))),
  (25513, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18267))),
  (25514, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18267))),
  (25517, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18268))),
  (25518, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18269))),
  (25519, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18269))),
  (25520, E'J01-202', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 202 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18269))),
  (25521, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18270))),
  (25522, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18270))),
  (25523, E'J01-203', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 203 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18270))),
  (25524, E'J01-401', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 401 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18271))),
  (25525, E'J01-401', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 401 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18271))),
  (25526, E'J01-401', (SELECT r.id FROM public.room r WHERE r.building = 'J01' AND r.number = 401 AND r.campus_id = (SELECT co.campus_id FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = 18271)))
) AS nv (id, classroom, room_id)
WHERE t.id = nv.id::BIGINT;
UPDATE public.course_offering_meeting m SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE m.id = ANY(ARRAY[24833, 24834, 24835, 24851, 24852, 24853, 24886, 24888, 24901, 24902, 24903, 24904, 24905, 24906, 24944, 24945, 24946, 24947, 24952, 24956, 24957, 24963, 24964, 24969, 24970, 25021, 25296, 25297, 25506, 25507, 25509, 25510, 25515, 25516]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = m.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

COMMIT;
