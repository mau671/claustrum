import { Schema } from "effect";

export class StudyPlan extends Schema.Class<StudyPlan>("StudyPlan")({
  id: Schema.Number,
  academic_unit_id: Schema.Number,
  external_plan_id: Schema.Number,
  name: Schema.String,
  academic_degree: Schema.String,
  modality_name: Schema.optional(Schema.String),
}) {}

export class StudyPlansQuery extends Schema.Class<StudyPlansQuery>("StudyPlansQuery")({
  academicUnitId: Schema.optional(Schema.NumberFromString),
  campusId: Schema.optional(Schema.NumberFromString),
}) {}

export class StudyPlanIdParams extends Schema.Class<StudyPlanIdParams>("StudyPlanIdParams")({
  id: Schema.NumberFromString,
}) {}

export class StudyPlanCourse extends Schema.Class<StudyPlanCourse>("StudyPlanCourse")({
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
}) {}

export class CourseRelation extends Schema.Class<CourseRelation>("CourseRelation")({
  fromCourseId: Schema.Number,
  toCourseId: Schema.Number,
  relationType: Schema.String,
  from_course_id: Schema.Number,
  to_course_id: Schema.Number,
  relation_type: Schema.String,
}) {}

export class CoursePrerequisitesResponse extends Schema.Class<CoursePrerequisitesResponse>(
  "CoursePrerequisitesResponse",
)({
  prerequisites: Schema.Array(Schema.Number),
  corequisites: Schema.Array(Schema.Number),
}) {}

export class StudyPlanDetail extends Schema.Class<StudyPlanDetail>("StudyPlanDetail")({
  id: Schema.Number,
  academic_unit_id: Schema.Number,
  external_plan_id: Schema.Number,
  name: Schema.String,
  academic_degree: Schema.String,
  modality_name: Schema.optional(Schema.String),
  plan: StudyPlan,
  courses: Schema.Array(StudyPlanCourse),
  relations: Schema.Array(CourseRelation),
}) {}

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
