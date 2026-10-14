import { Schema } from "effect";

export const CourseListItem = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
});
export type CourseListItem = typeof CourseListItem.Type;

export class CoursesQuery extends Schema.Class<CoursesQuery>("CoursesQuery")({
  ids: Schema.optional(Schema.String),
  search: Schema.optional(Schema.String),
}) {}

export class CourseIdParams extends Schema.Class<CourseIdParams>("CourseIdParams")({
  id: Schema.Number,
}) {}

export const CourseDetail = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  credits: Schema.NullOr(Schema.Number),
  weekly_hours: Schema.NullOr(Schema.Number),
  created_at: Schema.String,
  updated_at: Schema.String,
});
export type CourseDetail = typeof CourseDetail.Type;

export class CourseTermsQuery extends Schema.Class<CourseTermsQuery>("CourseTermsQuery")({
  campusId: Schema.optional(Schema.Number),
  academicUnitId: Schema.optional(Schema.Number),
  studyPlanId: Schema.optional(Schema.Number),
}) {}

export class CourseGroupsQuery extends Schema.Class<CourseGroupsQuery>("CourseGroupsQuery")({
  campusId: Schema.optional(Schema.Number),
  academicUnitId: Schema.optional(Schema.Number),
  academicTermId: Schema.optional(Schema.Number),
  studyPlanId: Schema.optional(Schema.Number),
}) {}

export const CourseGroup = Schema.Struct({
  academicTermId: Schema.Number,
  termDisplayName: Schema.String,
  termYear: Schema.Number,
  termPeriodNumber: Schema.Number,
  sourceCourseId: Schema.Number,
  sourceCourseCode: Schema.String,
  sourceCourseName: Schema.String,
  groupId: Schema.Number,
  groupCode: Schema.String,
  groupType: Schema.String,
  capacity: Schema.Number,
  campusId: Schema.NullOr(Schema.Number),
  campusName: Schema.NullOr(Schema.String),
  professors: Schema.Array(Schema.Unknown),
  meetings: Schema.Array(Schema.Unknown),
  academic_term_id: Schema.Number,
  term_display_name: Schema.String,
  term_year: Schema.Number,
  term_period_number: Schema.Number,
  source_course_id: Schema.Number,
  source_course_code: Schema.String,
  source_course_name: Schema.String,
  group_id: Schema.Number,
  group_code: Schema.String,
  group_type: Schema.String,
  campus_id: Schema.NullOr(Schema.Number),
  campus_name: Schema.NullOr(Schema.String),
});
export type CourseGroup = typeof CourseGroup.Type;

export class CourseProfessorsQuery extends Schema.Class<CourseProfessorsQuery>(
  "CourseProfessorsQuery",
)({
  campusId: Schema.optional(Schema.Number),
  academicUnitId: Schema.optional(Schema.Number),
  yearWindow: Schema.optional(Schema.Number),
  academicTermId: Schema.optional(Schema.Number),
}) {}

export const CourseRecentProfessor = Schema.Struct({
  professorId: Schema.Number,
  professorName: Schema.String,
  lastTaughtTermId: Schema.Number,
  lastTaughtTermName: Schema.String,
  lastTaughtYear: Schema.Number,
  lastTaughtPeriodNumber: Schema.Number,
  groupsInLastTermCount: Schema.Number,
  termsTaughtCount: Schema.Number,
  professor_id: Schema.Number,
  professor_name: Schema.String,
  last_taught_term_id: Schema.Number,
  last_taught_term_name: Schema.String,
  last_taught_year: Schema.Number,
  last_taught_period_number: Schema.Number,
  groups_in_last_term_count: Schema.Number,
  terms_taught_count: Schema.Number,
});
export type CourseRecentProfessor = typeof CourseRecentProfessor.Type;

export class CourseEquivalentsQuery extends Schema.Class<CourseEquivalentsQuery>(
  "CourseEquivalentsQuery",
)({
  studyPlanId: Schema.Number,
  limit: Schema.optional(Schema.Number),
  offset: Schema.optional(Schema.Number),
}) {}

export const CourseEquivalent = Schema.Struct({
  id: Schema.Number,
  code: Schema.String,
  name: Schema.String,
  credits: Schema.NullOr(Schema.Number),
  weeklyHours: Schema.NullOr(Schema.Number),
  relationKind: Schema.String,
  isPlaceholder: Schema.Boolean,
  hasOfferings: Schema.Boolean,
  totalEquivalents: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  course_credits: Schema.NullOr(Schema.Number),
  course_weekly_hours: Schema.NullOr(Schema.Number),
  relation_kind: Schema.String,
  is_placeholder: Schema.Boolean,
  has_offerings: Schema.Boolean,
  total_equivalents: Schema.Number,
});
export type CourseEquivalent = typeof CourseEquivalent.Type;

export class CourseNotFound extends Schema.TaggedError<CourseNotFound>()(
  "CourseNotFound",
  {
    error: Schema.String,
  },
  { httpApiStatus: 404 },
) {}
