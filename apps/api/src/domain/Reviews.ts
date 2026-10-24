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

export const PublicReviewItem = Schema.Struct({
  review_id: Schema.Number,
  professor_id: Schema.String,
  courses: Schema.Unknown,
  comment: Schema.String,
  ease_score: Schema.NullOr(Schema.Number),
  quality_score: Schema.NullOr(Schema.Number),
  clarity_score: Schema.NullOr(Schema.Number),
  fairness_score: Schema.NullOr(Schema.Number),
  attendance_required: Schema.NullOr(Schema.Boolean),
  grade_received: Schema.NullOr(Schema.String),
  engagement_level: Schema.NullOr(Schema.Number),
  tags: Schema.Array(Schema.String),
  status: Schema.String,
  created_at: Schema.String,
  like_count: Schema.Number,
  dislike_count: Schema.Number,
  my_reaction: Schema.NullOr(Schema.String),
  total_count: Schema.Number,
});
export type PublicReviewItem = typeof PublicReviewItem.Type;

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
    Schema.NullOr(
      Schema.Union([
        Schema.String.pipe(Schema.check(Schema.isPattern(/^$|^\d{1,3}$/))),
        Schema.Number.pipe(
          Schema.check(Schema.isInt()),
          Schema.check(Schema.isBetween({ minimum: 0, maximum: 100 })),
        ),
      ]),
    ),
  ),
  engagementLevel: Schema.Number.pipe(
    Schema.check(Schema.isInt()),
    Schema.check(Schema.isBetween({ minimum: 1, maximum: 5 })),
  ),
  tags: Schema.Array(ReviewTag),
  turnstileToken: Schema.NonEmptyString,
}) {}

export const CreatedReviewSummary = Schema.Struct({
  id: Schema.Number,
  status: Schema.String,
  created_at: Schema.String,
});
export type CreatedReviewSummary = typeof CreatedReviewSummary.Type;

export const CreateReviewResponse = Schema.Struct({
  success: Schema.Boolean,
  review: CreatedReviewSummary,
});
export type CreateReviewResponse = typeof CreateReviewResponse.Type;

export const ReviewDetail = Schema.Struct({
  review_id: Schema.Number,
  professor_id: Schema.String,
  professor_name: Schema.String,
  courses: Schema.Unknown,
  comment: Schema.String,
  ease_score: Schema.NullOr(Schema.Number),
  quality_score: Schema.NullOr(Schema.Number),
  clarity_score: Schema.NullOr(Schema.Number),
  fairness_score: Schema.NullOr(Schema.Number),
  attendance_required: Schema.NullOr(Schema.Boolean),
  grade_received: Schema.NullOr(Schema.String),
  engagement_level: Schema.NullOr(Schema.Number),
  tags: Schema.Array(Schema.String),
  status: Schema.String,
  created_at: Schema.String,
  reviewed_at: Schema.NullOr(Schema.String),
  moderation_note: Schema.NullOr(Schema.String),
});
export type ReviewDetail = typeof ReviewDetail.Type;

export class ModerateReviewPayload extends Schema.Class<ModerateReviewPayload>(
  "ModerateReviewPayload",
)({
  status: Schema.Literals(["approved", "rejected"]),
  reason: Schema.optional(Schema.NullOr(Schema.String)),
}) {}

export const ModeratedReviewSummary = Schema.Struct({
  id: Schema.Number,
  status: Schema.String,
});
export type ModeratedReviewSummary = typeof ModeratedReviewSummary.Type;

export const ModerateReviewResponse = Schema.Struct({
  success: Schema.Boolean,
  review: ModeratedReviewSummary,
});
export type ModerateReviewResponse = typeof ModerateReviewResponse.Type;

export const SuccessResponse = Schema.Struct({
  success: Schema.Boolean,
});
export type SuccessResponse = typeof SuccessResponse.Type;

export class ReviewReactionPayload extends Schema.Class<ReviewReactionPayload>(
  "ReviewReactionPayload",
)({
  reaction: Schema.NullOr(Schema.Literals(["like", "dislike"])),
}) {}

export const ReviewReactionResponse = Schema.Struct({
  success: Schema.Boolean,
  reaction: Schema.NullOr(Schema.Literals(["like", "dislike"])),
  likeCount: Schema.Number,
  dislikeCount: Schema.Number,
});
export type ReviewReactionResponse = typeof ReviewReactionResponse.Type;

export class ReviewReportPayload extends Schema.Class<ReviewReportPayload>("ReviewReportPayload")({
  reason: ReviewReportReason,
  description: Schema.optional(
    Schema.NullOr(Schema.String.pipe(Schema.check(Schema.isMaxLength(1000)))),
  ),
  turnstileToken: Schema.NonEmptyString,
}) {}

export const CreatedReportSummary = Schema.Struct({
  id: Schema.Number,
  review_id: Schema.Number,
  status: Schema.String,
  created_at: Schema.String,
});
export type CreatedReportSummary = typeof CreatedReportSummary.Type;

export const ReviewReportResponse = Schema.Struct({
  success: Schema.Boolean,
  report: CreatedReportSummary,
});
export type ReviewReportResponse = typeof ReviewReportResponse.Type;

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
