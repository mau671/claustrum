import * as Schema from "effect/Schema";

export const ReportStatus = Schema.Literals(["pending", "resolved", "dismissed"]);
export type ReportStatus = typeof ReportStatus.Type;

export const ListReportsQuery = Schema.Struct({
  status: Schema.optional(ReportStatus),
  limit: Schema.optional(Schema.NumberFromString),
  offset: Schema.optional(Schema.NumberFromString),
});
export type ListReportsQuery = typeof ListReportsQuery.Type;

export const ReportItem = Schema.Struct({
  report_id: Schema.Number,
  review_id: Schema.Number,
  reason: Schema.String,
  description: Schema.NullOr(Schema.String),
  status: Schema.String,
  created_at: Schema.String,
  professor_id: Schema.String,
  professor_name: Schema.String,
  course_code: Schema.String,
  course_name: Schema.String,
  comment: Schema.NullOr(Schema.String),
  total_count: Schema.Number,
});
export type ReportItem = typeof ReportItem.Type;

export const ReportDetail = Schema.Struct({
  report_id: Schema.Number,
  review_id: Schema.Number,
  reason: Schema.String,
  description: Schema.NullOr(Schema.String),
  status: Schema.String,
  resolution_note: Schema.NullOr(Schema.String),
  created_at: Schema.String,
  resolved_at: Schema.NullOr(Schema.String),
  professor_id: Schema.String,
  professor_name: Schema.String,
  course_code: Schema.String,
  course_name: Schema.String,
  comment: Schema.NullOr(Schema.String),
});
export type ReportDetail = typeof ReportDetail.Type;

export const ModerateReportPayload = Schema.Struct({
  status: Schema.Literals(["resolved", "dismissed"]),
  note: Schema.optional(Schema.NullOr(Schema.String)),
  rejectReview: Schema.optional(Schema.Boolean),
});
export type ModerateReportPayload = typeof ModerateReportPayload.Type;

export const ModerateReportResponse = Schema.Struct({
  success: Schema.Boolean,
});
export type ModerateReportResponse = typeof ModerateReportResponse.Type;
