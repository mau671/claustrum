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

export const SearchEvaluationsQuery = Schema.Struct({
  q: Schema.optional(Schema.String),
  type: Schema.optional(EvaluationType),
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
});
export type SearchEvaluationsQuery = typeof SearchEvaluationsQuery.Type;

export const BrowseEvaluationsQuery = Schema.Struct({
  q: Schema.optional(Schema.String),
  /** Comma-separated evaluation types. */
  types: Schema.optional(Schema.String),
});
export type BrowseEvaluationsQuery = typeof BrowseEvaluationsQuery.Type;

export const EvaluationCourseItem = Schema.Struct({
  course_id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  total_count: Schema.Number,
});
export type EvaluationCourseItem = typeof EvaluationCourseItem.Type;

export const EvaluationTermItem = Schema.Struct({
  term_id: Schema.NullOr(Schema.Number),
  label: Schema.String,
  total_count: Schema.Number,
});
export type EvaluationTermItem = typeof EvaluationTermItem.Type;

export const EvaluationItem = Schema.Struct({
  id: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  term_id: Schema.NullOr(Schema.Number),
  professor_id: Schema.NullOr(Schema.Number),
  type: Schema.String,
  number: Schema.NullOr(Schema.Number),
  name: Schema.NullOr(Schema.String),
  coordinated: Schema.Boolean,
  answers_included: Schema.Boolean,
  answers_separate: Schema.Boolean,
  file_key: Schema.String,
  file_size: Schema.Number,
  answer_file_key: Schema.NullOr(Schema.String),
  status: Schema.String,
  created_at: Schema.String,
  term_display_name: Schema.NullOr(Schema.String),
  professor_name: Schema.NullOr(Schema.String),
  extraordinary: Schema.Boolean,
  variant: Schema.NullOr(Schema.Number),
});
export type EvaluationItem = typeof EvaluationItem.Type;

export const EvaluationSearchRow = Schema.Struct({
  ...EvaluationItem.fields,
  total_count: Schema.Number,
});
export type EvaluationSearchRow = typeof EvaluationSearchRow.Type;

export const EvaluationDetail = Schema.Struct({
  id: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  term_id: Schema.NullOr(Schema.Number),
  term_display_name: Schema.NullOr(Schema.String),
  professor_id: Schema.NullOr(Schema.Number),
  professor_name: Schema.NullOr(Schema.String),
  type: Schema.String,
  number: Schema.NullOr(Schema.Number),
  name: Schema.NullOr(Schema.String),
  coordinated: Schema.Boolean,
  answers_included: Schema.Boolean,
  answers_separate: Schema.Boolean,
  file_key: Schema.String,
  file_size: Schema.Number,
  answer_file_key: Schema.NullOr(Schema.String),
  status: Schema.String,
  note: Schema.NullOr(Schema.String),
  created_at: Schema.String,
  extraordinary: Schema.Boolean,
  variant: Schema.NullOr(Schema.Number),
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
  type: string | null,
  number: number | null,
  name: string | null,
  extraordinary: boolean,
  variant: number | null,
): string {
  if (type === "otro" && name && name.trim() !== "") {
    return `${courseCode ?? "evaluacion"}-${name.trim()}.pdf`;
  }

  if (!type) return `${courseCode ?? "evaluacion"}.pdf`;

  const base = `${courseCode ?? "evaluacion"}-${type.toUpperCase()}`;
  const withNumber = number && number > 0 ? `${base}-${number}` : base;
  const withExtraordinary = extraordinary ? `${withNumber}-EXTRAORDINARIO` : withNumber;
  const withVariant = variant !== null ? `${withExtraordinary}-V${variant}` : withExtraordinary;
  return `${withVariant}.pdf`;
}

export interface EvaluationUploadPayload {
  readonly courseId: number;
  readonly termId: number | null;
  readonly professorId: number | null;
  readonly type: EvaluationType;
  readonly number: number | null;
  readonly name: string | null;
  readonly coordinated: boolean;
  readonly answersIncluded: boolean;
  readonly answersSeparate: boolean;
  readonly extraordinary: boolean;
  readonly variant: number | null;
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

  const termId =
    payload.termId === null || payload.termId === undefined || payload.termId === ""
      ? null
      : Number(payload.termId);
  if (termId !== null && (!Number.isInteger(termId) || termId <= 0)) {
    return { valid: false, error: "termId invalido" };
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
  const type = payload.type as EvaluationType;
  if (!validTypes.includes(type)) {
    return { valid: false, error: "type invalido" };
  }

  const number =
    payload.number === null || payload.number === undefined || payload.number === ""
      ? null
      : Number(payload.number);

  const name =
    typeof payload.name === "string" && payload.name.trim() !== ""
      ? payload.name.trim().slice(0, 128)
      : null;

  const requiresNumber = ["parcial", "quiz", "reposicion", "tarea", "proyecto"];
  if (type === "otro") {
    if (!name) {
      return { valid: false, error: "name es requerido cuando type es 'otro'" };
    }
  } else if (name !== null) {
    return { valid: false, error: "name solo se permite cuando type es 'otro'" };
  }

  if (requiresNumber.includes(type) && (number === null || number <= 0)) {
    return { valid: false, error: "number es requerido para este tipo de evaluacion" };
  }

  if (!requiresNumber.includes(type) && number !== null) {
    return { valid: false, error: "number no aplica para este tipo de evaluacion" };
  }

  const extraordinary = payload.extraordinary === true || payload.extraordinary === "true";
  const variant =
    payload.variant === null || payload.variant === undefined || payload.variant === ""
      ? null
      : Number(payload.variant);
  if (variant !== null && (!Number.isInteger(variant) || variant < 1 || variant > 99)) {
    return { valid: false, error: "variant debe estar entre 1 y 99" };
  }
  if (variant !== null && number === null) {
    return { valid: false, error: "variant requiere un number" };
  }

  const coordinated = payload.coordinated === true || payload.coordinated === "true";
  const answersIncluded = payload.answersIncluded === true || payload.answersIncluded === "true";
  const answersSeparate = payload.answersSeparate === true || payload.answersSeparate === "true";

  const turnstileToken =
    typeof payload.turnstileToken === "string" ? payload.turnstileToken.trim() : "";
  if (!turnstileToken) {
    return { valid: false, error: "turnstileToken es requerido" };
  }

  return {
    valid: true,
    data: {
      courseId,
      termId,
      professorId,
      type,
      number,
      name,
      coordinated,
      answersIncluded,
      answersSeparate,
      extraordinary,
      variant,
      turnstileToken,
    },
  };
}
