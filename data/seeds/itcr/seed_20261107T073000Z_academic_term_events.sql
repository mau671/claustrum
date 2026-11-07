-- ============================================================================
-- TEC-DATA ACADEMIC TERM EVENTS SEED 2026
-- ============================================================================
-- TEC-DATA-META scope=catalog
-- TEC-DATA-META years=2026
-- TEC-DATA-META term_external_keys=2026_S_1,2026_S_2,2026_V_1,2026_C_1,2026_C_2,2026_C_3,2026_T_1,2026_T_2,2026_T_3,2026_T_4
-- TEC-DATA-META generated_at_utc=2026-11-07T07:30:00Z
-- ============================================================================

BEGIN;
SET LOCAL TIME ZONE 'UTC';

-- Idempotency: clean previous events for these terms if re-seeded
DELETE FROM public.academic_term_event
WHERE academic_term_id IN (
  SELECT id FROM public.academic_term
  WHERE external_key IN (
    '2026_S_1', '2026_S_2', '2026_V_1',
    '2026_C_1', '2026_C_2', '2026_C_3',
    '2026_T_1', '2026_T_2', '2026_T_3', '2026_T_4'
  )
);

INSERT INTO public.academic_term_event (
  academic_term_id,
  type,
  name,
  starts_on,
  ends_on
)
VALUES
  -- ============================================================================
  -- 2026_S_1 (I Semestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'enrollment_new_students', 'Matrícula ordinaria de estudiantes nuevos', '2026-01-29', '2026-01-29'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'special_registration', 'Empadronamiento extraordinario', '2026-01-30', '2026-01-30'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'enrollment_extraordinary_new', 'Matrícula extraordinaria de estudiantes primer ingreso', '2026-02-05', '2026-02-05'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'quota_reservation_results', 'Entrega de resultados de reservas de cupos de estudiantes próximos a graduarse al DAR', '2025-12-15', '2025-12-15'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes regulares', '2026-02-09', '2026-02-10'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'enrollment_extraordinary', 'Matrícula extraordinaria TODOS los estudiantes', '2026-02-12', '2026-02-12'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-02-16', '2026-02-27'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'classes', 'Periodo lectivo', '2026-02-16', '2026-06-13'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'finals_preparation', 'Preparación para evaluaciones y actividades finales', '2026-06-15', '2026-06-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'final_exams', 'Evaluaciones y actividades finales', '2026-06-22', '2026-07-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-06-12', '2026-06-12'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'grade_submission', 'Entrega de actas', '2026-06-15', '2026-07-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'grade_appeals', 'Período ordinario solicitud revisión de calificaciones finales', '2026-07-03', '2026-07-21'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'course_drop_ordinary', 'Retiro de materias', '2026-02-16', '2026-03-27'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'course_drop_special', 'Retiros especiales: Último día para entregar solicitudes al DAR', '2026-06-05', '2026-06-05'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'proficiency_exams_request', 'Exámenes por suficiencia: Recepción de solicitudes (Período 1)', '2026-02-16', '2026-02-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'credit_transfer_request', 'Reconocimiento de materias: Recepción de solicitudes', '2026-02-23', '2026-02-27'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'major_change_request', 'Cambios de carrera: Recepción de Solicitudes al DAR', '2026-05-25', '2026-05-29'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_1'), 'major_change_results', 'Cambios de carrera: Entrega de resultados', '2026-07-03', '2026-07-03'),

  -- ============================================================================
  -- 2026_S_2 (II Semestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'schedule_publication', 'Publicación guía de horarios', '2026-06-22', '2026-06-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'appointments_preliminary', 'Publicación preliminar de citas de matrícula', '2026-06-22', '2026-06-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'appointments_appeals', 'Apelaciones al padrón preliminar de Citas de matrícula', '2026-06-22', '2026-06-26'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'appointments_final', 'Publicación definitiva citas de matrícula', '2026-06-29', '2026-06-29'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'quota_reservation_request', 'Periodo para que el estudiante pronto a graduarse solicite reservas de cupo a las Escuelas', '2026-06-22', '2026-06-26'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'quota_reservation_results', 'Último día entrega resultados reservas de cupos al DAR', '2026-06-22', '2026-06-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes regulares', '2026-07-21', '2026-07-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'enrollment_extraordinary', 'Matrícula extraordinaria TODOS los estudiantes', '2026-07-24', '2026-07-24'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-08-03', '2026-08-14'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'classes', 'Periodo lectivo', '2026-08-03', '2026-11-21'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'finals_preparation', 'Preparación para evaluaciones y actividades finales', '2026-11-23', '2026-11-28'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'final_exams', 'Evaluaciones y actividades finales', '2026-11-30', '2026-12-10'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-11-20', '2026-11-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'grade_submission', 'Entrega de actas', '2026-11-23', '2026-12-10'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'grade_appeals', 'Período ordinario solicitud revisión de calificaciones finales', '2026-12-11', '2026-12-15'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'course_drop_ordinary', 'Retiro de materias', '2026-08-03', '2026-09-11'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'course_drop_special', 'Retiros especiales: Último día para entregar solicitudes al DAR', '2026-11-13', '2026-11-13'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'proficiency_exams_request', 'Exámenes por suficiencia: Recepción de solicitudes (Período 1)', '2026-08-03', '2026-08-07'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'credit_transfer_request', 'Reconocimiento de materias: Recepción de solicitudes', '2026-08-10', '2026-08-14'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'major_change_request', 'Cambios de carrera: Recepción de Solicitudes al DAR', '2026-11-02', '2026-11-06'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_S_2'), 'major_change_results', 'Cambios de carrera: Entrega de resultados', '2026-12-15', '2026-12-15'),

  -- ============================================================================
  -- 2026_V_1 (Verano 2026-2027)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'schedule_publication', 'Publicación guía de horarios', '2026-11-02', '2026-11-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'appointments_preliminary', 'Publicación preliminar de citas de matrícula', '2026-11-02', '2026-11-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'appointments_appeals', 'Apelaciones al padrón preliminar de Citas de matrícula', '2026-11-02', '2026-11-06'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'appointments_final', 'Publicación definitiva citas de matrícula', '2026-11-13', '2026-11-13'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'quota_reservation_request', 'Periodo para solicitar reservas de cupo a las Escuelas', '2026-11-02', '2026-11-06'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'quota_reservation_results', 'Último día entrega resultados reservas de cupos al DAR', '2026-11-26', '2026-11-26'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes regulares', '2026-12-14', '2026-12-14'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-12-15', '2026-12-17'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'classes', 'Periodo lectivo', '2026-12-15', '2027-01-30'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'final_exams', 'Evaluaciones y actividades finales', '2027-02-01', '2027-02-04'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2027-01-29', '2027-01-29'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'grade_submission', 'Entrega de actas', '2027-02-01', '2027-02-04'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_V_1'), 'grade_appeals', 'Período ordinario solicitud revisión de calificaciones finales', '2027-02-05', '2027-02-09'),

  -- ============================================================================
  -- 2026_C_1 (I Cuatrimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'appointments_preliminary', 'Publicación preliminar de citas de matrícula', '2025-12-03', '2025-12-03'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-01-21', '2026-01-21'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-01-23', '2026-01-23'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-01-26', '2026-02-06'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'classes', 'Período Lectivo', '2026-01-26', '2026-04-24'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'final_exams', 'Evaluaciones y actividades finales', '2026-04-27', '2026-05-04'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-04-24', '2026-04-24'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_1'), 'grade_submission', 'Entrega de actas', '2026-04-27', '2026-05-04'),

  -- ============================================================================
  -- 2026_C_2 (II Cuatrimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'appointments_preliminary', 'Publicación preliminar de citas de matrícula', '2026-04-22', '2026-04-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-05-07', '2026-05-07'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-05-08', '2026-05-08'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-05-11', '2026-05-22'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'classes', 'Período Lectivo', '2026-05-11', '2026-08-14'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'final_exams', 'Evaluaciones y actividades finales', '2026-08-17', '2026-08-21'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-08-14', '2026-08-14'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_2'), 'grade_submission', 'Entrega de actas', '2026-08-17', '2026-08-21'),

  -- ============================================================================
  -- 2026_C_3 (III Cuatrimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'appointments_preliminary', 'Publicación preliminar de citas de matrícula', '2026-08-12', '2026-08-12'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-08-27', '2026-08-27'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-08-28', '2026-08-28'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-08-31', '2026-09-11'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'classes', 'Período Lectivo', '2026-08-31', '2026-11-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'final_exams', 'Evaluaciones y actividades finales', '2026-11-23', '2026-11-27'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-11-20', '2026-11-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_C_3'), 'grade_submission', 'Entrega de actas', '2026-11-23', '2026-11-27'),

  -- ============================================================================
  -- 2026_T_1 (I Trimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-01-21', '2026-01-21'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-01-23', '2026-01-23'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-01-26', '2026-01-30'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'classes', 'Período Lectivo', '2026-01-26', '2026-04-10'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'final_exams', 'Evaluación y actividades finales', '2026-04-13', '2026-04-15'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-04-10', '2026-04-10'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_1'), 'grade_submission', 'Entrega de actas', '2026-04-13', '2026-04-15'),

  -- ============================================================================
  -- 2026_T_2 (II Trimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-04-17', '2026-04-17'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-04-20', '2026-04-20'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-04-20', '2026-04-24'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'classes', 'Período Lectivo', '2026-04-20', '2026-06-26'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'final_exams', 'Evaluación y actividades finales', '2026-06-29', '2026-07-01'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-06-26', '2026-06-26'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_2'), 'grade_submission', 'Entrega de actas', '2026-06-29', '2026-07-01'),

  -- ============================================================================
  -- 2026_T_3 (III Trimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-07-02', '2026-07-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-07-03', '2026-07-03'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-07-20', '2026-07-24'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'classes', 'Período Lectivo', '2026-07-20', '2026-09-25'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'final_exams', 'Evaluación y actividades finales', '2026-09-28', '2026-09-30'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-09-25', '2026-09-25'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_3'), 'grade_submission', 'Entrega de actas', '2026-09-28', '2026-09-30'),

  -- ============================================================================
  -- 2026_T_4 (IV Trimestre 2026)
  -- ============================================================================
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'enrollment_regular', 'Matrícula ordinaria de estudiantes nuevos y regulares', '2026-10-02', '2026-10-02'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'enrollment_extraordinary', 'Matrícula extraordinaria de estudiantes regulares', '2026-10-05', '2026-10-05'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'inclusions', 'Apelaciones e Inclusiones de matrícula', '2026-10-05', '2026-10-09'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'classes', 'Período Lectivo', '2026-10-05', '2026-12-11'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'final_exams', 'Evaluación y actividades finales', '2026-12-14', '2026-12-16'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'grade_publication', 'Publicación de actas de calificaciones para registro de notas', '2026-12-11', '2026-12-11'),
  ((SELECT id FROM public.academic_term WHERE external_key = '2026_T_4'), 'grade_submission', 'Entrega de actas', '2026-12-14', '2026-12-16');

COMMIT;
