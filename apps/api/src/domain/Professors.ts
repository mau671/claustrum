import { Schema } from "effect";

export const ProfessorSortBy = Schema.Literals([
  "reviews",
  "score",
  "ease",
  "quality",
  "clarity",
  "name",
  "date",
]);
export type ProfessorSortBy = typeof ProfessorSortBy.Type;

export class SearchProfessorsQuery extends Schema.Class<SearchProfessorsQuery>(
  "SearchProfessorsQuery",
)({
  query: Schema.optional(Schema.String),
  search: Schema.optional(Schema.String),
  minAverageScore: Schema.optional(Schema.NumberFromString),
  minReviewCount: Schema.optional(Schema.NumberFromString),
  academicUnitId: Schema.optional(Schema.NumberFromString),
  onlyWithApprovedReviews: Schema.optional(
    Schema.Union([Schema.Boolean, Schema.Literals(["true", "false"])]),
  ),
  sortBy: Schema.optional(ProfessorSortBy),
  sortDesc: Schema.optional(Schema.Union([Schema.Boolean, Schema.Literals(["true", "false"])])),
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
}) {}

export const ProfessorSearchResult = Schema.Struct({
  professor_id: Schema.String,
  professor_name: Schema.String,
  approved_review_count: Schema.Number,
  average_overall_score: Schema.NullOr(Schema.Number),
  average_ease_score: Schema.NullOr(Schema.Number),
  average_quality_score: Schema.NullOr(Schema.Number),
  average_clarity_score: Schema.NullOr(Schema.Number),
  courses_reviewed_count: Schema.Number,
  last_approved_review_at: Schema.NullOr(Schema.String),
  search_rank: Schema.NullOr(Schema.Number),
  academic_unit: Schema.NullOr(Schema.String),
  total_count: Schema.Number,
});
export type ProfessorSearchResult = typeof ProfessorSearchResult.Type;

export class ProfessorIdParam extends Schema.Class<ProfessorIdParam>("ProfessorIdParam")({
  id: Schema.String,
}) {}

export const ProfessorDetail = Schema.Struct({
  id: Schema.Number,
  full_name: Schema.String,
});
export type ProfessorDetail = typeof ProfessorDetail.Type;

export const ProfessorReviewSummary = Schema.Struct({
  professor_id: Schema.String,
  approved_review_count: Schema.Number,
  average_overall_score: Schema.NullOr(Schema.Number),
  average_ease_score: Schema.NullOr(Schema.Number),
  average_quality_score: Schema.NullOr(Schema.Number),
  average_clarity_score: Schema.NullOr(Schema.Number),
  average_fairness_score: Schema.NullOr(Schema.Number),
  would_take_again_percentage: Schema.NullOr(Schema.Number),
  tag_counts: Schema.Unknown,
});
export type ProfessorReviewSummary = typeof ProfessorReviewSummary.Type;

export const ProfessorCourse = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
});
export type ProfessorCourse = typeof ProfessorCourse.Type;

export const ProfessorTerm = Schema.Struct({
  id: Schema.Number,
  academic_modality_id: Schema.Number,
  year: Schema.Number,
  period_number: Schema.Number,
  external_key: Schema.String,
  display_name: Schema.String,
  starts_on: Schema.NullOr(Schema.String),
  ends_on: Schema.NullOr(Schema.String),
});
export type ProfessorTerm = typeof ProfessorTerm.Type;

export const ProfessorHistoryCourse = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  groups: Schema.Array(Schema.String),
});
export type ProfessorHistoryCourse = typeof ProfessorHistoryCourse.Type;

export const ProfessorHistoryTerm = Schema.Struct({
  term_id: Schema.Number,
  year: Schema.Number,
  period_number: Schema.Number,
  term_display_name: Schema.String,
  modality_name: Schema.NullOr(Schema.String),
  courses: Schema.Array(ProfessorHistoryCourse),
});
export type ProfessorHistoryTerm = typeof ProfessorHistoryTerm.Type;

export class ProfessorNotFound extends Schema.TaggedError<ProfessorNotFound>()(
  "ProfessorNotFound",
  { error: Schema.String },
  { httpApiStatus: 404 },
) {}
