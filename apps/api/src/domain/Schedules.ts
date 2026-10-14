import { Schema } from "effect";

export { CurrentUser } from "./Auth";

export class ScheduleCourseOffering extends Schema.Class<ScheduleCourseOffering>(
  "ScheduleCourseOffering",
)({
  offering_id: Schema.Number,
  course_id: Schema.Number,
  course_code: Schema.String,
  course_name: Schema.String,
  credits: Schema.Number,
  weekly_hours: Schema.Number,
  course_type: Schema.NullOr(Schema.String),
  academic_unit_id: Schema.Number,
  academic_unit_name: Schema.String,
  campus_id: Schema.Number,
  academic_term_id: Schema.Number,
  term_display_name: Schema.String,
  groups: Schema.Array(Schema.Unknown),
  level_number: Schema.NullOr(Schema.Number),
  level_label: Schema.NullOr(Schema.String),
  sort_order: Schema.NullOr(Schema.Number),
}) {}

export class ScheduleCoursesQuery extends Schema.Class<ScheduleCoursesQuery>(
  "ScheduleCoursesQuery",
)({
  termId: Schema.Number,
  campusId: Schema.Number,
  careerId: Schema.optional(Schema.Number),
  planId: Schema.optional(Schema.Number),
  otherCampuses: Schema.optional(Schema.Literals(["true", "false"])),
  showAll: Schema.optional(Schema.Literals(["true", "false"])),
}) {}

export class SavedSchedule extends Schema.Class<SavedSchedule>("SavedSchedule")({
  id: Schema.Number,
  name: Schema.String,
  academic_term_id: Schema.Number,
  created_at: Schema.String,
  updated_at: Schema.String,
}) {}

export class GroupLookup extends Schema.Class<GroupLookup>("GroupLookup")({
  courseCode: Schema.String,
  campusId: Schema.optional(Schema.NullOr(Schema.Number)),
  groupCode: Schema.String,
}) {}

export class SaveSchedulePayload extends Schema.Class<SaveSchedulePayload>("SaveSchedulePayload")({
  name: Schema.NonEmptyString,
  termId: Schema.optional(Schema.Number),
  academicTermId: Schema.optional(Schema.Number),
  groupLookups: Schema.Array(GroupLookup),
}) {}

export class ScheduleIdParams extends Schema.Class<ScheduleIdParams>("ScheduleIdParams")({
  id: Schema.Number,
}) {}

export class SavedScheduleItem extends Schema.Class<SavedScheduleItem>("SavedScheduleItem")({
  id: Schema.Number,
  saved_schedule_id: Schema.Number,
  course_offering_group_id: Schema.Number,
  course_code: Schema.String,
  campus_id: Schema.NullOr(Schema.Number),
  group_code: Schema.String,
}) {}

export class DeleteScheduleResponse extends Schema.Class<DeleteScheduleResponse>(
  "DeleteScheduleResponse",
)({
  success: Schema.Boolean,
}) {}

export class ScheduleNotFound extends Schema.TaggedError<ScheduleNotFound>()(
  "ScheduleNotFound",
  {
    error: Schema.String,
  },
  { httpApiStatus: 404 },
) {}

export class SaveScheduleBadRequest extends Schema.TaggedError<SaveScheduleBadRequest>()(
  "SaveScheduleBadRequest",
  {
    error: Schema.String,
  },
  { httpApiStatus: 400 },
) {}

export class SaveScheduleFailed extends Schema.TaggedError<SaveScheduleFailed>()(
  "SaveScheduleFailed",
  {
    error: Schema.String,
  },
  { httpApiStatus: 500 },
) {}

export class Unauthorized extends Schema.TaggedError<Unauthorized>()(
  "Unauthorized",
  {
    error: Schema.String,
  },
  { httpApiStatus: 401 },
) {}
