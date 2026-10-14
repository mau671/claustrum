import { Effect, Schema } from "effect";
import * as Context from "effect/Context";

import type { Env } from "../types";

export { CurrentUser } from "./Auth";
export class ApiEnv extends Context.Service<ApiEnv, Env>()("claustrum/ApiEnv") {}

export const REVIEW_TAGS = [
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

export const ReviewTag = Schema.Literals([...REVIEW_TAGS]);
export type ReviewTag = typeof ReviewTag.Type;

export const PROFESSOR_REVIEW_REPORT_REASONS = [
  "spam",
  "ofensivo",
  "acoso",
  "datos_personales",
  "falso_enganoso",
  "otro",
] as const;

export const ReviewReportReason = Schema.Literals([...PROFESSOR_REVIEW_REPORT_REASONS]);
export type ReviewReportReason = typeof ReviewReportReason.Type;

export const CourseCode = Schema.String.pipe(Schema.check(Schema.isPattern(/^[A-Z]{2,4}\d{3,4}$/)));

export class ListReviewsQuery extends Schema.Class<ListReviewsQuery>("ListReviewsQuery")({
  professorId: Schema.String,
  limit: Schema.NumberFromString.pipe(
    Schema.optional,
    Schema.withDecodingDefaultType(Effect.succeed(20)),
  ),
  offset: Schema.NumberFromString.pipe(
    Schema.optional,
    Schema.withDecodingDefaultType(Effect.succeed(0)),
  ),
}) {}

export class ReviewIdParam extends Schema.Class<ReviewIdParam>("ReviewIdParam")({
  id: Schema.NumberFromString,
}) {}

export class PublicReviewItem extends Schema.Class<PublicReviewItem>("PublicReviewItem")({
  review_id: Schema.Number,
  professor_id: Schema.String,
  courses: Schema.Unknown,
  comment: Schema.String,
  ease_score: Schema.Number,
  quality_score: Schema.Number,
  clarity_score: Schema.Number,
  fairness_score: Schema.Number,
  attendance_required: Schema.Boolean,
  grade_received: Schema.NullOr(Schema.String),
  engagement_level: Schema.Number,
  tags: Schema.Array(Schema.String),
  status: Schema.String,
  created_at: Schema.Unknown,
  like_count: Schema.Number,
  dislike_count: Schema.Number,
  my_reaction: Schema.NullOr(Schema.String),
  total_count: Schema.Number,
}) {}

export class CreateReviewPayload extends Schema.Class<CreateReviewPayload>("CreateReviewPayload")({
  professorId: Schema.NonEmptyString,
  courseCodes: Schema.Array(CourseCode),
  academicTermId: Schema.optional(Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt())))),
  comment: Schema.String.pipe(Schema.check(Schema.isBetweenLength(5, 1000))),
  easeScore: Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 10 }))),
  qualityScore: Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 10 }))),
  clarityScore: Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 10 }))),
  fairnessScore: Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 10 }))),
  attendanceRequired: Schema.Boolean,
  gradeReceived: Schema.optional(
    Schema.NullOr(Schema.String.pipe(Schema.check(Schema.isMaxLength(32)))),
  ),
  engagementLevel: Schema.Number.pipe(
    Schema.check(Schema.isInt()),
    Schema.check(Schema.isBetween({ minimum: 1, maximum: 5 })),
  ),
  tags: Schema.Array(ReviewTag),
  turnstileToken: Schema.NonEmptyString,
}) {}

export class CreatedReviewSummary extends Schema.Class<CreatedReviewSummary>(
  "CreatedReviewSummary",
)({
  id: Schema.Number,
  status: Schema.String,
  created_at: Schema.Unknown,
}) {}

export class CreateReviewResponse extends Schema.Class<CreateReviewResponse>(
  "CreateReviewResponse",
)({
  success: Schema.Boolean,
  review: CreatedReviewSummary,
}) {}

export class ReviewDetail extends Schema.Class<ReviewDetail>("ReviewDetail")({
  review_id: Schema.Number,
  professor_id: Schema.String,
  professor_name: Schema.String,
  courses: Schema.Unknown,
  comment: Schema.String,
  ease_score: Schema.Number,
  quality_score: Schema.Number,
  clarity_score: Schema.Number,
  fairness_score: Schema.Number,
  attendance_required: Schema.Boolean,
  grade_received: Schema.NullOr(Schema.String),
  engagement_level: Schema.Number,
  tags: Schema.Array(Schema.String),
  status: Schema.String,
  created_at: Schema.Unknown,
  reviewed_at: Schema.NullOr(Schema.Unknown),
  moderation_note: Schema.NullOr(Schema.String),
}) {}

export class ModerateReviewPayload extends Schema.Class<ModerateReviewPayload>(
  "ModerateReviewPayload",
)({
  status: Schema.Literals(["approved", "rejected"]),
  reason: Schema.optional(Schema.NullOr(Schema.String)),
}) {}

export class ModeratedReviewSummary extends Schema.Class<ModeratedReviewSummary>(
  "ModeratedReviewSummary",
)({
  id: Schema.Number,
  status: Schema.String,
}) {}

export class ModerateReviewResponse extends Schema.Class<ModerateReviewResponse>(
  "ModerateReviewResponse",
)({
  success: Schema.Boolean,
  review: ModeratedReviewSummary,
}) {}

export class SuccessResponse extends Schema.Class<SuccessResponse>("SuccessResponse")({
  success: Schema.Boolean,
}) {}

export class ReviewReactionPayload extends Schema.Class<ReviewReactionPayload>(
  "ReviewReactionPayload",
)({
  reaction: Schema.NullOr(Schema.Literals(["like", "dislike"])),
}) {}

export class ReviewReactionResponse extends Schema.Class<ReviewReactionResponse>(
  "ReviewReactionResponse",
)({
  success: Schema.Boolean,
  reaction: Schema.NullOr(Schema.Literals(["like", "dislike"])),
  likeCount: Schema.Number,
  dislikeCount: Schema.Number,
}) {}

export class ReviewReportPayload extends Schema.Class<ReviewReportPayload>("ReviewReportPayload")({
  reason: ReviewReportReason,
  description: Schema.optional(
    Schema.NullOr(Schema.String.pipe(Schema.check(Schema.isMaxLength(1000)))),
  ),
  turnstileToken: Schema.NonEmptyString,
}) {}

export class CreatedReportSummary extends Schema.Class<CreatedReportSummary>(
  "CreatedReportSummary",
)({
  id: Schema.Number,
  review_id: Schema.Number,
  status: Schema.String,
  created_at: Schema.Unknown,
}) {}

export class ReviewReportResponse extends Schema.Class<ReviewReportResponse>(
  "ReviewReportResponse",
)({
  success: Schema.Boolean,
  report: CreatedReportSummary,
}) {}

export class ReviewNotFound extends Schema.TaggedError<ReviewNotFound>()(
  "ReviewNotFound",
  { error: Schema.String },
  { httpApiStatus: 404 },
) {}

export class ReviewBadRequest extends Schema.TaggedError<ReviewBadRequest>()(
  "ReviewBadRequest",
  { error: Schema.String },
  { httpApiStatus: 400 },
) {}

export class ReviewUnauthorized extends Schema.TaggedError<ReviewUnauthorized>()(
  "ReviewUnauthorized",
  { error: Schema.String },
  { httpApiStatus: 401 },
) {}

export class ReviewForbidden extends Schema.TaggedError<ReviewForbidden>()(
  "ReviewForbidden",
  { error: Schema.String, reason: Schema.optional(Schema.NullOr(Schema.String)) },
  { httpApiStatus: 403 },
) {}

export class ReviewInternalServerError extends Schema.TaggedError<ReviewInternalServerError>()(
  "ReviewInternalServerError",
  { error: Schema.String },
  { httpApiStatus: 500 },
) {}
