import { Schema } from "effect";

export class StudyPlanIdQuery extends Schema.Class<StudyPlanIdQuery>("StudyPlanIdQuery")({
  studyPlanId: Schema.NumberFromString,
}) {}

export const StudentCourseStatus = Schema.Struct({
  courseId: Schema.Number,
  status: Schema.String,
  grade: Schema.NullOr(Schema.Number),
  recordedAt: Schema.NullOr(Schema.String),
  originCourseId: Schema.NullOr(Schema.Number),
  originCourseCode: Schema.NullOr(Schema.String),
  originCourseName: Schema.NullOr(Schema.String),
  originStudyPlanId: Schema.NullOr(Schema.Number),
  originAttemptId: Schema.NullOr(Schema.Number),
  originAttemptNumber: Schema.NullOr(Schema.Number),
  originGrade: Schema.NullOr(Schema.Number),
  originRecordedAt: Schema.NullOr(Schema.String),
  originAcademicTermId: Schema.NullOr(Schema.Number),
  originAcademicTermName: Schema.NullOr(Schema.String),
  originType: Schema.NullOr(Schema.String),
  course_id: Schema.Number,
  recorded_at: Schema.NullOr(Schema.String),
  origin_course_id: Schema.NullOr(Schema.Number),
  origin_course_code: Schema.NullOr(Schema.String),
  origin_course_name: Schema.NullOr(Schema.String),
  origin_study_plan_id: Schema.NullOr(Schema.Number),
  origin_attempt_id: Schema.NullOr(Schema.Number),
  origin_attempt_number: Schema.NullOr(Schema.Number),
  origin_grade: Schema.NullOr(Schema.Number),
  origin_recorded_at: Schema.NullOr(Schema.String),
  origin_academic_term_id: Schema.NullOr(Schema.Number),
  origin_academic_term_name: Schema.NullOr(Schema.String),
  origin_type: Schema.NullOr(Schema.String),
});
export type StudentCourseStatus = typeof StudentCourseStatus.Type;

export class StudentAttemptsQuery extends Schema.Class<StudentAttemptsQuery>(
  "StudentAttemptsQuery",
)({
  studyPlanId: Schema.NumberFromString,
  courseId: Schema.optional(Schema.NumberFromString),
}) {}

export const StudentCourseAttempt = Schema.Struct({
  id: Schema.Number,
  courseId: Schema.Number,
  courseCode: Schema.NullOr(Schema.String),
  courseName: Schema.NullOr(Schema.String),
  attemptNumber: Schema.Number,
  status: Schema.String,
  grade: Schema.NullOr(Schema.Number),
  academicTermId: Schema.NullOr(Schema.Number),
  recordedAt: Schema.NullOr(Schema.String),
  equivalentCourseId: Schema.NullOr(Schema.Number),
  equivalentCourseCode: Schema.NullOr(Schema.String),
  equivalentCourseName: Schema.NullOr(Schema.String),
  course_id: Schema.Number,
  course_code: Schema.NullOr(Schema.String),
  course_name: Schema.NullOr(Schema.String),
  attempt_number: Schema.Number,
  academic_term_id: Schema.NullOr(Schema.Number),
  recorded_at: Schema.NullOr(Schema.String),
  equivalent_course_id: Schema.NullOr(Schema.Number),
  equivalent_course_code: Schema.NullOr(Schema.String),
  equivalent_course_name: Schema.NullOr(Schema.String),
});
export type StudentCourseAttempt = typeof StudentCourseAttempt.Type;

export class InsertAttemptPayload extends Schema.Class<InsertAttemptPayload>(
  "InsertAttemptPayload",
)({
  studyPlanId: Schema.Number.pipe(Schema.check(Schema.isInt())),
  courseId: Schema.Number.pipe(Schema.check(Schema.isInt())),
  status: Schema.String,
  grade: Schema.optional(
    Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 100 })))),
  ),
  termId: Schema.optional(Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt())))),
  academicTermId: Schema.optional(Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt())))),
  equivalentCourseId: Schema.optional(
    Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt()))),
  ),
}) {}

export const InsertAttemptResponse = Schema.Struct({
  success: Schema.Boolean,
  id: Schema.NullOr(Schema.Number),
});
export type InsertAttemptResponse = typeof InsertAttemptResponse.Type;

export class AttemptIdParam extends Schema.Class<AttemptIdParam>("AttemptIdParam")({
  id: Schema.NumberFromString,
}) {}

export class UpdateAttemptPayload extends Schema.Class<UpdateAttemptPayload>(
  "UpdateAttemptPayload",
)({
  status: Schema.optional(Schema.String),
  grade: Schema.optional(
    Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isBetween({ minimum: 0, maximum: 100 })))),
  ),
  termId: Schema.optional(Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt())))),
  academicTermId: Schema.optional(Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt())))),
  equivalentCourseId: Schema.optional(
    Schema.NullOr(Schema.Number.pipe(Schema.check(Schema.isInt()))),
  ),
}) {}

export const StudentSuccessResponse = Schema.Struct({
  success: Schema.Boolean,
});
export type StudentSuccessResponse = typeof StudentSuccessResponse.Type;

export class StudentUnauthorized extends Schema.TaggedError<StudentUnauthorized>()(
  "StudentUnauthorized",
  { error: Schema.String },
  { httpApiStatus: 401 },
) {}

export class StudentForbidden extends Schema.TaggedError<StudentForbidden>()(
  "StudentForbidden",
  { error: Schema.String, reason: Schema.optional(Schema.NullOr(Schema.String)) },
  { httpApiStatus: 403 },
) {}

export class StudentBadRequest extends Schema.TaggedError<StudentBadRequest>()(
  "StudentBadRequest",
  { error: Schema.String },
  { httpApiStatus: 400 },
) {}

export class StudentNotFound extends Schema.TaggedError<StudentNotFound>()(
  "StudentNotFound",
  { error: Schema.String },
  { httpApiStatus: 404 },
) {}

export class StudentInternalServerError extends Schema.TaggedError<StudentInternalServerError>()(
  "StudentInternalServerError",
  { error: Schema.String },
  { httpApiStatus: 500 },
) {}
