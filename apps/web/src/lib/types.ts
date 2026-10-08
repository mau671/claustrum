export interface CatalogUniversity {
  id: number;
  name: string;
  short_name: string;
}

export interface CatalogCampus {
  id: number;
  university_id: number;
  code: string;
  name: string;
}

export interface CatalogCareerProgram {
  id: number;
  code: string;
  name: string;
}

export interface CatalogStudyPlan {
  id: number;
  academic_unit_id: number;
  external_plan_id: number;
  name: string;
  academic_degree: string | null;
  modality_name?: string;
}

export interface StudyPlanCourse {
  courseId: number;
  levelNumber: number | null;
  credits: number;
  weeklyHours: number;
  sortOrder: number;
  courseCode: string;
  courseName: string;
  courseDefaultCredits: number;
  courseDefaultWeeklyHours: number;
}

export interface StudyPlanCoursesResponse {
  courses: StudyPlanCourse[];
}

export interface CoursePrerequisitesResponse {
  prerequisites: number[];
  corequisites: number[];
}

export interface StudyPeriod {
  levelNumber: number | null;
  levelLabel?: string;
  courses: StudyPlanCourse[];
}

export interface Course {
  id: string;
  code: string;
  name: string;
  credits: number;
  hours: number;
  semester: number;
  status: CourseStatus;
  prerequisites: string[];
  corequisites: string[];
  equivalents?: string[];
  statusOriginType?: CourseStatusOriginType | null;
  statusOriginCourseId?: number | null;
  statusOriginCourseCode?: string | null;
  statusOriginCourseName?: string | null;
  statusOriginStudyPlanId?: number | null;
  statusOriginAttemptId?: number | null;
  statusOriginAttemptNumber?: number | null;
  statusOriginGrade?: number | null;
  statusOriginRecordedAt?: string | null;
  statusOriginAcademicTermId?: number | null;
  statusOriginAcademicTermName?: string | null;
  isAvailable?: boolean;
}

export type CourseStatus = "approved" | "failed" | "not_taken" | "withdrawn" | "in_progress";

export type CourseStatusOriginType =
  | "direct"
  | "same_course_global"
  | "equivalent"
  | "direct_plan_status";

export interface CourseEffectiveStatus {
  status: CourseStatus;
  grade: number | null;
  recordedAt: string | null;
  originCourseId: number | null;
  originCourseCode: string | null;
  originCourseName: string | null;
  originStudyPlanId: number | null;
  originAttemptId: number | null;
  originAttemptNumber: number | null;
  originGrade: number | null;
  originRecordedAt: string | null;
  originAcademicTermId: number | null;
  originAcademicTermName: string | null;
  originType: CourseStatusOriginType | null;
}

export type StudentCourseStatusMap = Map<number, CourseEffectiveStatus>;

export interface StudyPlanDetail {
  plan: CatalogStudyPlan;
  periods: StudyPeriod[];
  courseRelations: Map<
    number,
    {
      prerequisites: number[];
      corequisites: number[];
      equivalents?: number[];
    }
  >;
}

export interface UserStudyPlanContext {
  userStudyPlanId: number;
  studyPlanId: number;
  campusId: number;
  entryYear: number;
  studyPlanName: string;
  campusName: string;
  universityId: number | null;
  departmentId: number | null;
  academicUnitId: number | null;
  termId: number | null;
}

export interface UserProfileContextRow {
  user_id: string;
  carnet: string | null;
  university_id: number | null;
  university_name: string | null;
  campus_id: number | null;
  campus_name: string | null;
  academic_unit_id: number | null;
  academic_unit_name: string | null;
  study_plan_id: number | null;
  study_plan_name: string | null;
  entry_year: number | null;
  term_id: number | null;
}

export interface DashboardStats {
  totalCourses: number;
  completedCourses: number;
  inProgressCourses: number;
  failedCourses: number;
  withdrawnCourses: number;
  notTakenCourses: number;
  totalCredits: number;
  completedCredits: number;
  currentSemester: number;
  progressPercentage: number;
  weightedAverage: number;
}

export interface CourseAttempt {
  id: number;
  courseId: number;
  courseCode: string | null;
  courseName: string | null;
  attemptNumber: number;
  status: Exclude<CourseStatus, "not_taken">;
  grade: number | null;
  academicTermId: number | null;
  recordedAt: string;
  equivalentCourseId?: number | null;
  equivalentCourseCode?: string | null;
  equivalentCourseName?: string | null;
}

export interface CourseRecentProfessor {
  professorId: number;
  professorName: string;
  lastTaughtTermId: number;
  lastTaughtTermName: string;
  lastTaughtYear: number;
  lastTaughtPeriodNumber: number;
  groupsInLastTermCount: number;
  termsTaughtCount: number;
}

export interface CourseDetailRelatedCourse {
  id: number;
  code: string;
  name: string;
  credits: number | null;
  weeklyHours: number | null;
  relationKind: "base" | "equivalent";
  isPlaceholder: boolean;
  hasOfferings: boolean;
  totalEquivalents: number;
}

export interface CourseLatestTermGroup {
  academicTermId: number;
  termDisplayName: string;
  termYear: number;
  termPeriodNumber: number;
  sourceCourseId: number;
  sourceCourseCode: string;
  sourceCourseName: string;
  groupId: number;
  groupCode: string;
  groupType: string;
  capacity: number;
  campusId: number | null;
  campusName: string | null;
  professors: Array<{ id: number; name: string }>;
  meetings: ScheduleSession[];
}

export interface SemesterProgress {
  levelNumber: number;
  levelLabel: string;
  totalCourses: number;
  completedCourses: number;
  credits: number;
  completedCredits: number;
  status: "completed" | "in_progress" | "pending";
}

export interface NextCourse {
  id: string;
  code: string;
  name: string;
  credits: number;
  levelLabel: string;
  prerequisites: string[];
}

export interface AcademicTerm {
  id: number;
  academic_modality_id: number;
  year: number;
  period_number: number;
  external_key: string;
  display_name: string;
  starts_on: string | null;
  ends_on: string | null;
}

export interface ScheduleSession {
  weekday: number;
  starts_at: string;
  ends_at: string;
  classroom: string | null;
}

export interface ScheduleGroup {
  group_id: number;
  group_code: string;
  group_type: string;
  capacity: number;
  enrolled_count: number;
  professors: Array<{ id: number; name: string }> | null;
  meetings: ScheduleSession[] | null;
  campus_id?: number | null;
}

export interface ScheduleCourse {
  offering_id: number;
  course_id: number;
  course_code: string;
  course_name: string;
  credits: number;
  weekly_hours: number;
  course_type: string | null;
  academic_unit_id: number;
  academic_unit_name: string;
  campus_id: number;
  academic_term_id: number;
  term_display_name: string;
  groups: ScheduleGroup[] | null;
  level_number: number | null;
  level_label?: string | null;
  sort_order?: number | null;
}

export interface CalendarEvent {
  id: string;
  title: string;
  courseName: string;
  courseCode: string;
  groupCode: string;
  groupId: string;
  groupType: string | null;
  professors: Array<{ id: number; name: string }> | null;
  classroom: string | null;
  campusName: string | null;
  color: string;
  start: Date;
  end: Date;
  courseId: string;
  group: number;
  credits: number;
}
