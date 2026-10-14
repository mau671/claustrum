import { Schema } from "effect";

export const StudyPlan = Schema.Struct({
  id: Schema.Number,
  academic_unit_id: Schema.Number,
  external_plan_id: Schema.Number,
  name: Schema.String,
  academic_degree: Schema.String,
  modality_name: Schema.optional(Schema.String),
});
export type StudyPlan = typeof StudyPlan.Type;

export class StudyPlansQuery extends Schema.Class<StudyPlansQuery>("StudyPlansQuery")({
  academicUnitId: Schema.optional(Schema.NumberFromString),
  campusId: Schema.optional(Schema.NumberFromString),
}) {}

export class StudyPlanIdParams extends Schema.Class<StudyPlanIdParams>("StudyPlanIdParams")({
  id: Schema.NumberFromString,
}) {}

export const StudyPlanCourse = Schema.Struct({
  courseId: Schema.Number,
  levelNumber: Schema.NullOr(Schema.Number),
  credits: Schema.Number,
  weeklyHours: Schema.Number,
  sortOrder: Schema.Number,
  courseCode: Schema.String,
  courseName: Schema.String,
  courseDefaultCredits: Schema.Number,
  courseDefaultWeeklyHours: Schema.Number,
  default_credits: Schema.Number,
  default_weekly_hours: Schema.Number,
  levelLabel: Schema.optional(Schema.String),
  course_id: Schema.Number,
  level_number: Schema.NullOr(Schema.Number),
  weekly_hours: Schema.Number,
  sort_order: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
});
export type StudyPlanCourse = typeof StudyPlanCourse.Type;

export const CourseRelation = Schema.Struct({
  fromCourseId: Schema.Number,
  toCourseId: Schema.Number,
  relationType: Schema.String,
  from_course_id: Schema.Number,
  to_course_id: Schema.Number,
  relation_type: Schema.String,
});
export type CourseRelation = typeof CourseRelation.Type;

export const CoursePrerequisitesResponse = Schema.Struct({
  prerequisites: Schema.Array(Schema.Number),
  corequisites: Schema.Array(Schema.Number),
});
export type CoursePrerequisitesResponse = typeof CoursePrerequisitesResponse.Type;

export const StudyPlanDetail = Schema.Struct({
  id: Schema.Number,
  academic_unit_id: Schema.Number,
  external_plan_id: Schema.Number,
  name: Schema.String,
  academic_degree: Schema.String,
  modality_name: Schema.optional(Schema.String),
  plan: StudyPlan,
  courses: Schema.Array(StudyPlanCourse),
  relations: Schema.Array(CourseRelation),
});
export type StudyPlanDetail = typeof StudyPlanDetail.Type;

export class StudyPlanRelationsQuery extends Schema.Class<StudyPlanRelationsQuery>(
  "StudyPlanRelationsQuery",
)({
  courseId: Schema.optional(Schema.NumberFromString),
}) {}

export class StudyPlanNotFound extends Schema.TaggedError<StudyPlanNotFound>()(
  "StudyPlanNotFound",
  {
    error: Schema.String,
  },
  { httpApiStatus: 404 },
) {}
