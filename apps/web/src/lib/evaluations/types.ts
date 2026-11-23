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
  name: string | null,
  extraordinary = false,
  variant: number | null = null,
): string {
  if (type === "otro" && name) return name;
  const base = EVALUATION_TYPE_LABELS[type];
  const withNumber = number && number > 0 ? `${base} ${number}` : base;
  const modifiers = [
    extraordinary ? "Extraordinario" : null,
    variant !== null ? `V${variant}` : null,
  ].filter((modifier): modifier is string => modifier !== null);
  return modifiers.length > 0 ? `${withNumber} (${modifiers.join(", ")})` : withNumber;
}

export function formatEvaluationFileName(
  courseCode: string,
  type: EvaluationType,
  number: number | null,
  name: string | null,
  extraordinary = false,
  variant: number | null = null,
): string {
  const normalizedCourseCode = courseCode.trim();
  const normalizedName = name?.trim() ?? null;

  if (type === "otro" && normalizedName) {
    return `${normalizedCourseCode}-${normalizedName}.pdf`;
  }

  const typeUpper = type.toUpperCase();
  const base =
    number && number > 0
      ? `${normalizedCourseCode}-${typeUpper}-${number}`
      : `${normalizedCourseCode}-${typeUpper}`;
  const withExtraordinary = extraordinary ? `${base}-EXTRAORDINARIO` : base;
  return variant !== null ? `${withExtraordinary}-V${variant}.pdf` : `${withExtraordinary}.pdf`;
}

export type EvaluationCourseItem = {
  course_id: number;
  code: string;
  name: string;
  total_count: number;
};

export type EvaluationTermItem = {
  term_id: number | null;
  year: number | null;
  label: string;
  total_count: number;
};

export type EvaluationRow = {
  id: number;
  course_id: number;
  course_code: string;
  course_name: string;
  term_id: number | null;
  professor_id: number | null;
  type: EvaluationType;
  number: number | null;
  name: string | null;
  coordinated: boolean;
  answers_included: boolean;
  answers_separate: boolean;
  file_key: string;
  file_size: number;
  answer_file_key: string | null;
  status: EvaluationStatus;
  created_at: string;
  term_display_name: string | null;
  professor_name: string | null;
  extraordinary: boolean;
  variant: number | null;
};

export type EvaluationSearchRow = EvaluationRow & {
  total_count: number;
};

export type EvaluationModerationRow = {
  id: number;
  course_id: number;
  course_code: string;
  course_name: string;
  term_id: number | null;
  term_display_name: string | null;
  professor_id: number | null;
  professor_name: string | null;
  type: EvaluationType;
  number: number | null;
  name: string | null;
  coordinated: boolean;
  answers_included: boolean;
  answers_separate: boolean;
  file_key: string;
  file_size: number;
  answer_file_key: string | null;
  status: EvaluationStatus;
  note: string | null;
  created_at: string;
  total_count: number;
  extraordinary: boolean;
  variant: number | null;
};

export type UploadEvaluationPayload = {
  courseId: number;
  termId: number | null;
  professorId: number | null;
  type: EvaluationType;
  number: number | null;
  name: string | null;
  coordinated: boolean;
  answersIncluded: boolean;
  answersSeparate: boolean;
  extraordinary: boolean;
  variant: number | null;
  turnstileToken: string;
  evaluationFile: File;
  answersFile: File | null;
};
