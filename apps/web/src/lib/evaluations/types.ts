export type EvaluationType =
  | "parcial"
  | "quiz"
  | "final"
  | "reposicion"
  | "tarea"
  | "proyecto"
  | "otro";

export type EvaluationStatus = "pending" | "approved" | "rejected";

export const EVALUATION_TYPE_LABELS: Record<EvaluationType, string> = {
  parcial: "Parcial",
  quiz: "Quiz",
  final: "Final",
  reposicion: "Reposición",
  tarea: "Tarea",
  proyecto: "Proyecto",
  otro: "Otro",
};

export const EVALUATION_TYPES_WITH_NUMBER: EvaluationType[] = [
  "parcial",
  "quiz",
  "reposicion",
  "tarea",
  "proyecto",
];

export function formatEvaluationTypeLabel(
  type: EvaluationType,
  number: number | null,
  customName: string | null,
): string {
  if (type === "otro" && customName) {
    return customName;
  }
  const base = EVALUATION_TYPE_LABELS[type];
  if (number && number > 0) {
    return `${base} ${number}`;
  }
  return base;
}

export function formatEvaluationFileName(
  courseCode: string,
  type: EvaluationType,
  number: number | null,
  customName: string | null,
): string {
  const normalizedCourseCode = courseCode.trim();
  const normalizedCustomName = customName?.trim() ?? null;

  if (type === "otro" && normalizedCustomName) {
    return `${normalizedCourseCode}-${normalizedCustomName}.pdf`;
  }

  const typeUpper = type.toUpperCase();
  if (number && number > 0) {
    return `${normalizedCourseCode}-${typeUpper}-${number}.pdf`;
  }

  return `${normalizedCourseCode}-${typeUpper}.pdf`;
}

export type EvaluationRow = {
  id: number;
  course_id: number;
  course_code: string;
  course_name: string;
  academic_term_id: number | null;
  professor_id: number | null;
  evaluation_type: EvaluationType;
  evaluation_number: number | null;
  custom_name: string | null;
  is_catedra: boolean;
  includes_answers: boolean;
  has_separate_answers: boolean;
  file_key: string;
  file_size: number;
  answers_file_key: string | null;
  status: EvaluationStatus;
  created_at: string;
  term_display_name: string | null;
  professor_name: string | null;
};

export type EvaluationModerationRow = {
  id: number;
  course_id: number;
  course_code: string;
  course_name: string;
  academic_term_id: number | null;
  term_display_name: string | null;
  professor_id: number | null;
  professor_name: string | null;
  evaluation_type: EvaluationType;
  evaluation_number: number | null;
  custom_name: string | null;
  is_catedra: boolean;
  includes_answers: boolean;
  has_separate_answers: boolean;
  file_key: string;
  file_size: number;
  answers_file_key: string | null;
  status: EvaluationStatus;
  moderation_note: string | null;
  created_at: string;
  total_count: number;
};

export type UploadEvaluationPayload = {
  courseId: number;
  academicTermId: number | null;
  professorId: number | null;
  evaluationType: EvaluationType;
  evaluationNumber: number | null;
  customName: string | null;
  isCatedra: boolean;
  includesAnswers: boolean;
  hasSeparateAnswers: boolean;
  turnstileToken: string;
  evaluationFile: File;
  answersFile: File | null;
};
