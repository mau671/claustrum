import * as Schema from "effect/Schema";

export const EvaluationType = Schema.Literals([
  "parcial",
  "quiz",
  "final",
  "reposicion",
  "tarea",
  "proyecto",
  "otro",
]);
export type EvaluationType = typeof EvaluationType.Type;

export const EvaluationStatus = Schema.Literals(["pending", "approved", "rejected"]);
export type EvaluationStatus = typeof EvaluationStatus.Type;

export const GetEvaluationsQuery = Schema.Struct({
  courseId: Schema.NumberFromString,
  studyPlanId: Schema.optional(Schema.NumberFromString),
});
export type GetEvaluationsQuery = typeof GetEvaluationsQuery.Type;

export const EvaluationItem = Schema.Struct({
  id: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  academic_term_id: Schema.NullOr(Schema.Number),
  professor_id: Schema.NullOr(Schema.Number),
  evaluation_type: Schema.String,
  evaluation_number: Schema.NullOr(Schema.Number),
  custom_name: Schema.NullOr(Schema.String),
  is_catedra: Schema.Boolean,
  includes_answers: Schema.Boolean,
  has_separate_answers: Schema.Boolean,
  file_key: Schema.String,
  file_size: Schema.Number,
  answers_file_key: Schema.NullOr(Schema.String),
  status: Schema.String,
  created_at: Schema.Unknown,
  term_display_name: Schema.NullOr(Schema.String),
  professor_name: Schema.NullOr(Schema.String),
});
export type EvaluationItem = typeof EvaluationItem.Type;

export const EvaluationDetail = Schema.Struct({
  id: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  academic_term_id: Schema.NullOr(Schema.Number),
  term_display_name: Schema.NullOr(Schema.String),
  professor_id: Schema.NullOr(Schema.Number),
  professor_name: Schema.NullOr(Schema.String),
  evaluation_type: Schema.String,
  evaluation_number: Schema.NullOr(Schema.Number),
  custom_name: Schema.NullOr(Schema.String),
  is_catedra: Schema.Boolean,
  includes_answers: Schema.Boolean,
  has_separate_answers: Schema.Boolean,
  file_key: Schema.String,
  file_size: Schema.Number,
  answers_file_key: Schema.NullOr(Schema.String),
  status: Schema.String,
  moderation_note: Schema.NullOr(Schema.String),
  created_at: Schema.Unknown,
});
export type EvaluationDetail = typeof EvaluationDetail.Type;

export const ModerateEvaluationPayload = Schema.Struct({
  status: Schema.Literals(["approved", "rejected"]),
  note: Schema.optional(Schema.NullOr(Schema.String)),
});
export type ModerateEvaluationPayload = typeof ModerateEvaluationPayload.Type;

export const ModerateEvaluationResponse = Schema.Struct({
  success: Schema.Boolean,
  evaluation: Schema.Struct({
    id: Schema.Number,
    status: Schema.String,
  }),
});
export type ModerateEvaluationResponse = typeof ModerateEvaluationResponse.Type;

export const UploadEvaluationResponse = Schema.Struct({
  success: Schema.Boolean,
  message: Schema.String,
});
export type UploadEvaluationResponse = typeof UploadEvaluationResponse.Type;

export function formatFileName(
  courseCode: string | null,
  evaluationType: string | null,
  evaluationNumber: number | null,
  customName: string | null,
): string {
  if (evaluationType === "otro" && customName && customName.trim() !== "") {
    return `${courseCode ?? "evaluacion"}-${customName.trim()}.pdf`;
  }

  if (!evaluationType) return `${courseCode ?? "evaluacion"}.pdf`;

  const base = `${courseCode ?? "evaluacion"}-${evaluationType.toUpperCase()}`;
  if (evaluationNumber && evaluationNumber > 0) {
    return `${base}-${evaluationNumber}.pdf`;
  }
  return `${base}.pdf`;
}

export interface EvaluationUploadPayload {
  readonly courseId: number;
  readonly academicTermId: number | null;
  readonly professorId: number | null;
  readonly evaluationType: EvaluationType;
  readonly evaluationNumber: number | null;
  readonly customName: string | null;
  readonly isCatedra: boolean;
  readonly includesAnswers: boolean;
  readonly hasSeparateAnswers: boolean;
  readonly turnstileToken: string;
}

export function validateUploadPayload(
  payload: Record<string, unknown>,
):
  | { readonly valid: true; readonly data: EvaluationUploadPayload }
  | { readonly valid: false; readonly error: string } {
  const courseId = Number(payload.courseId);
  if (!Number.isInteger(courseId) || courseId <= 0) {
    return { valid: false, error: "courseId debe ser un entero positivo" };
  }

  const academicTermId =
    payload.academicTermId === null ||
    payload.academicTermId === undefined ||
    payload.academicTermId === ""
      ? null
      : Number(payload.academicTermId);
  if (academicTermId !== null && (!Number.isInteger(academicTermId) || academicTermId <= 0)) {
    return { valid: false, error: "academicTermId invalido" };
  }

  const professorId =
    payload.professorId === null || payload.professorId === undefined || payload.professorId === ""
      ? null
      : Number(payload.professorId);
  if (professorId !== null && (!Number.isInteger(professorId) || professorId <= 0)) {
    return { valid: false, error: "professorId invalido" };
  }

  const validTypes = [
    "parcial",
    "quiz",
    "final",
    "reposicion",
    "tarea",
    "proyecto",
    "otro",
  ] as const;
  const evaluationType = payload.evaluationType as EvaluationType;
  if (!validTypes.includes(evaluationType)) {
    return { valid: false, error: "evaluationType invalido" };
  }

  const evaluationNumber =
    payload.evaluationNumber === null ||
    payload.evaluationNumber === undefined ||
    payload.evaluationNumber === ""
      ? null
      : Number(payload.evaluationNumber);

  const customName =
    typeof payload.customName === "string" && payload.customName.trim() !== ""
      ? payload.customName.trim().slice(0, 128)
      : null;

  const requiresNumber = ["parcial", "quiz", "reposicion", "tarea", "proyecto"];
  if (evaluationType === "otro") {
    if (!customName) {
      return { valid: false, error: "customName es requerido cuando evaluationType es 'otro'" };
    }
  } else if (customName !== null) {
    return { valid: false, error: "customName solo se permite cuando evaluationType es 'otro'" };
  }

  if (
    requiresNumber.includes(evaluationType) &&
    (evaluationNumber === null || evaluationNumber <= 0)
  ) {
    return { valid: false, error: "evaluationNumber es requerido para este tipo de evaluacion" };
  }

  if (!requiresNumber.includes(evaluationType) && evaluationNumber !== null) {
    return { valid: false, error: "evaluationNumber no aplica para este tipo de evaluacion" };
  }

  const isCatedra = payload.isCatedra === true || payload.isCatedra === "true";
  const includesAnswers = payload.includesAnswers === true || payload.includesAnswers === "true";
  const hasSeparateAnswers =
    payload.hasSeparateAnswers === true || payload.hasSeparateAnswers === "true";

  const turnstileToken =
    typeof payload.turnstileToken === "string" ? payload.turnstileToken.trim() : "";
  if (!turnstileToken) {
    return { valid: false, error: "turnstileToken es requerido" };
  }

  return {
    valid: true,
    data: {
      courseId,
      academicTermId,
      professorId,
      evaluationType,
      evaluationNumber,
      customName,
      isCatedra,
      includesAnswers,
      hasSeparateAnswers,
      turnstileToken,
    },
  };
}
