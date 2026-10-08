export const REVIEW_TAG_OPTIONS = [
  "Tomaría su clase nuevamente",
  "Brinda apoyo",
  "Da buena retroalimentación",
  "Explica con claridad",
  "Clases excelentes",
  "Califica con rigor",
  "Muchas tareas",
  "Deja trabajos largos",
  "Exámenes retadores",
  "Muchos exámenes",
  "Pocos exámenes",
  "Asistencia obligatoria",
  "La participación importa",
  "Clases largas",
  "Requiere mucha lectura",
  "Aspectos de calificación claros",
  "Respetado por los estudiantes",
  "Inspirador",
  "Muy cómico",
  "Da crédito extra",
  "Muchos proyectos grupales",
  "Proyecto útil",
  "Clase fácil",
] as const;

export type ReviewTag = (typeof REVIEW_TAG_OPTIONS)[number];

export type ProfessorReviewStatus = "pending" | "approved" | "rejected";
export type ProfessorReviewStatusFilter = ProfessorReviewStatus | "all";

export type ProfessorReviewReportStatus = "pending" | "resolved" | "dismissed";

export const PROFESSOR_REVIEW_REPORT_REASONS = [
  "spam",
  "ofensivo",
  "acoso",
  "datos_personales",
  "falso_enganoso",
  "otro",
] as const;

export type ProfessorReviewReportReason = (typeof PROFESSOR_REVIEW_REPORT_REASONS)[number];

export type ProfessorReviewReaction = "like" | "dislike";

export type ProfessorReviewCourse = {
  id: number;
  code: string;
  name: string;
};

export type ProfessorReviewStatsRow = {
  professor_id: string;
  professor_name: string;
  approved_review_count: number;
  average_overall_score: number | null;
  average_ease_score: number | null;
  average_quality_score: number | null;
  average_clarity_score: number | null;
  courses_reviewed_count: number;
  last_approved_review_at: string | null;
  search_rank: number;
  academic_unit: string | null;
  total_count: number;
};

export type ProfessorReviewPublicRow = {
  review_id: number;
  professor_id: string;
  courses: ProfessorReviewCourse[];
  comment: string;
  ease_score: number | null;
  quality_score: number | null;
  clarity_score: number | null;
  fairness_score: number | null;
  attendance_required: boolean | null;
  grade_received: string | null;
  engagement_level: number | null;
  tags: string[];
  status: ProfessorReviewStatus;
  created_at: string;
  like_count: number;
  dislike_count: number;
  my_reaction: ProfessorReviewReaction | null;
  total_count: number;
};

export type ProfessorReviewModerationRow = {
  review_id: number;
  professor_id: number;
  professor_name: string;
  courses: ProfessorReviewCourse[];
  comment: string;
  ease_score: number;
  quality_score: number;
  clarity_score: number | null;
  fairness_score: number | null;
  attendance_required: boolean | null;
  grade_received: string | null;
  engagement_level: number | null;
  tags: string[];
  status: ProfessorReviewStatus;
  created_at: string;
  reviewed_at: string | null;
  moderation_note: string | null;
  total_count: number;
};

export type ProfessorReviewReportModerationRow = {
  report_id: number;
  review_id: number;
  reason: ProfessorReviewReportReason;
  description: string | null;
  status: ProfessorReviewReportStatus;
  created_at: string;
  professor_id: string;
  professor_name: string;
  course_code: string;
  course_name: string;
  comment: string;
  total_count: number;
};

export type ProfessorReviewTagCount = {
  tag: string;
  count: number;
};

export type ProfessorReviewCourseOption = {
  id: number;
  code: string;
  name: string;
};

export type ProfessorReviewTermOption = {
  id: number;
  academic_modality_id: number;
  year: number;
  period_number: number;
  external_key: string;
  display_name: string;
  starts_on: string | null;
  ends_on: string | null;
};

export type ProfessorReviewSummary = {
  professor_id: string;
  approved_review_count: number;
  average_overall_score: number | null;
  average_ease_score: number | null;
  average_quality_score: number | null;
  average_clarity_score: number | null;
  average_fairness_score: number | null;
  would_take_again_percentage: number | null;
  tag_counts: ProfessorReviewTagCount[];
};

export type SearchProfessorReviewStatsParams = {
  query: string;
  minAverageScore: number | null;
  minReviewCount: number;
  academicUnitId: number | null;
  onlyWithApprovedReviews: boolean;
  sortBy: string | null;
  sortDesc: boolean | null;
  limit: number;
  offset: number;
};

export type SubmitProfessorReviewPayload = {
  professorId: string;
  courseCodes: string[];
  academicTermId?: number | null;
  comment: string;
  easeScore: number;
  qualityScore: number;
  clarityScore: number;
  fairnessScore: number;
  attendanceRequired: boolean;
  gradeReceived?: string;
  engagementLevel: number;
  tags: ReviewTag[];
  turnstileToken: string;
};

export type SubmitProfessorReviewReportPayload = {
  reviewId: number;
  reason: ProfessorReviewReportReason;
  description?: string;
  turnstileToken: string;
};
