-- ============================================================================
-- TEC-DATA DELTA SEED
-- ============================================================================
-- TEC-DATA-META environment_id=127.0.0.1|postgres
-- TEC-DATA-META scope=offering
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_A_1,2026_B_1,2026_B_2,2026_B_3,2026_B_4,2026_B_5,2026_B_6,2026_B_7,2026_C_1,2026_C_2,2026_C_3,2026_H_1,2026_H_2,2026_H_3,2026_H_4,2026_H_5,2026_H_6,2026_I_1,2026_I_2,2026_M_1,2026_M_10,2026_M_11,2026_M_12,2026_M_2,2026_M_3,2026_M_4,2026_M_5,2026_M_6,2026_M_7,2026_M_8,2026_M_9,2026_N_1,2026_S_1,2026_S_2,2026_T_1,2026_T_2,2026_T_3,2026_T_4,2026_V_1
-- TEC-DATA-META data_fingerprint=c3257ac2516e835431864d31d61ca2c004e4563280a2b566758b945de813df5a
-- TEC-DATA-META generated_at_utc=2026-07-27T10:42:20.504934+00:00

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- table: course_offering_group
INSERT INTO public.course_offering_group
  (id, course_offering_id, group_code, group_type, capacity)
VALUES
  (17854, 7642, E'52', E'REGULAR', 15)
ON CONFLICT (course_offering_id, group_code) DO UPDATE SET group_type = EXCLUDED.group_type, capacity = EXCLUDED.capacity, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_group AS t
SET
  capacity = nv.capacity::INTEGER,
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW()
FROM (VALUES
  (12095, 32),
  (12096, 60),
  (12097, 20),
  (12098, 20),
  (12099, 20),
  (12122, 59),
  (11979, 16),
  (12741, 20),
  (12742, 20),
  (12743, 20),
  (12744, 20),
  (12746, 35),
  (12749, 20),
  (12750, 20),
  (12753, 35),
  (12755, 35),
  (12764, 55)
) AS nv (id, capacity)
WHERE t.id = nv.id::BIGINT;

-- table: course_offering_group_professor
INSERT INTO public.course_offering_group_professor
  (id, course_offering_group_id, professor_id)
VALUES
  (18703, 5550, 109),
  (18704, 5231, 122),
  (13007, 12641, 246),
  (18705, 17854, 788),
  (18706, 17854, 794),
  (18707, 12406, 970)
ON CONFLICT (course_offering_group_id, professor_id) DO NOTHING;
UPDATE public.course_offering_group_professor gp SET is_active = FALSE, deactivated_at = NOW(), updated_at = NOW() WHERE gp.id = ANY(ARRAY[3261, 9184, 18402]::BIGINT[]) AND EXISTS (SELECT 1 FROM public.course_offering_group g JOIN public.course_offering co ON co.id = g.course_offering_id WHERE g.id = gp.course_offering_group_id AND co.academic_term_id = ANY(ARRAY[3, 6, 21, 22, 23, 24, 25, 26, 27, 40, 41, 42, 43, 44, 45, 52, 53, 54, 59, 60, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 101, 102, 111, 112, 113, 114, 117]::BIGINT[]));

-- table: course_offering_meeting
INSERT INTO public.course_offering_meeting
  (id, course_offering_group_id, weekday, starts_at, ends_at, classroom)
VALUES
  (24677, 17854, 2, '16:10:00', '18:50:00', NULL),
  (24678, 17854, 2, '07:00:00', '08:45:00', E'CAM-01')
ON CONFLICT (course_offering_group_id, weekday, starts_at, ends_at) DO UPDATE SET classroom = EXCLUDED.classroom, is_active = TRUE, deactivated_at = NULL, updated_at = NOW();
UPDATE public.course_offering_meeting AS t
SET
  classroom = nv.classroom::TEXT,
  is_active = TRUE,
  deactivated_at = NULL,
  updated_at = NOW()
FROM (VALUES
  (24380, E'A-08')
) AS nv (id, classroom)
WHERE t.id = nv.id::BIGINT;

COMMIT;
