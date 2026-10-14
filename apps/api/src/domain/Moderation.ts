import * as Schema from "effect/Schema";

export const ModerationCountsData = Schema.Struct({
  pendingReviews: Schema.Number,
  pendingEvaluations: Schema.Number,
  pendingReports: Schema.Number,
  pendingFeedback: Schema.Number,
});
export type ModerationCountsData = typeof ModerationCountsData.Type;

export const ModerationCountsResponse = Schema.Struct({
  pendingReviews: Schema.Number,
  pendingEvaluations: Schema.Number,
  pendingReports: Schema.Number,
  pendingFeedback: Schema.Number,
  feedback: Schema.Number,
  total_count: Schema.Number,
  data: ModerationCountsData,
});
export type ModerationCountsResponse = typeof ModerationCountsResponse.Type;

export const ModerationReviewsQuery = Schema.Struct({
  status: Schema.optional(Schema.Literals(["pending", "approved", "rejected", "all"])),
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
});
export type ModerationReviewsQuery = typeof ModerationReviewsQuery.Type;

export const ModerationCourseItem = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
});
export type ModerationCourseItem = typeof ModerationCourseItem.Type;

export const ModerationReviewItem = Schema.Struct({
  review_id: Schema.Number,
  professor_id: Schema.Number,
  professor_name: Schema.String,
  courses: Schema.Array(ModerationCourseItem),
  comment: Schema.NullOr(Schema.String),
  ease_score: Schema.Number,
  quality_score: Schema.Number,
  clarity_score: Schema.Number,
  fairness_score: Schema.Number,
  attendance_required: Schema.NullOr(Schema.Boolean),
  grade_received: Schema.NullOr(Schema.String),
  engagement_level: Schema.NullOr(Schema.Number),
  tags: Schema.Array(Schema.String),
  status: Schema.String,
  created_at: Schema.String,
  reviewed_at: Schema.NullOr(Schema.String),
  moderation_note: Schema.NullOr(Schema.String),
  total_count: Schema.Number,
});
export type ModerationReviewItem = typeof ModerationReviewItem.Type;

export const ModerationEvaluationsQuery = Schema.Struct({
  status: Schema.optional(Schema.Literals(["pending", "approved", "rejected"])),
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
});
export type ModerationEvaluationsQuery = typeof ModerationEvaluationsQuery.Type;

export const ModerationEvaluationItem = Schema.Struct({
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
  created_at: Schema.String,
  total_count: Schema.Number,
});
export type ModerationEvaluationItem = typeof ModerationEvaluationItem.Type;
