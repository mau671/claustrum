import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup, HttpApiSchema } from "effect/http-api";

import {
  DeleteScheduleResponse,
  SavedSchedule,
  SavedScheduleItem,
  SaveScheduleBadRequest,
  SaveScheduleFailed,
  SaveSchedulePayload,
  ScheduleCourseOffering,
  ScheduleCoursesQuery,
  ScheduleIdParams,
  ScheduleNotFound,
  Unauthorized,
} from "../domain/Schedules";

export class SchedulesApi extends HttpApiGroup.make("schedules")
  .add(
    HttpApiEndpoint.get("courses", "/courses", {
      query: ScheduleCoursesQuery,
      success: Schema.Array(ScheduleCourseOffering),
    }),
  )
  .add(
    HttpApiEndpoint.get("list", "/", {
      success: Schema.Array(SavedSchedule),
      error: Unauthorized,
    }),
  )
  .add(
    HttpApiEndpoint.post("create", "/", {
      payload: SaveSchedulePayload,
      success: SavedSchedule.pipe(HttpApiSchema.status(201)),
      error: [SaveScheduleBadRequest, SaveScheduleFailed, Unauthorized],
    }),
  )
  .add(
    HttpApiEndpoint.get("getById", "/:id", {
      params: ScheduleIdParams,
      success: SavedSchedule,
      error: [ScheduleNotFound, Unauthorized],
    }),
  )
  .add(
    HttpApiEndpoint.get("getItems", "/:id/items", {
      params: ScheduleIdParams,
      success: Schema.Array(SavedScheduleItem),
      error: [ScheduleNotFound, Unauthorized],
    }),
  )
  .add(
    HttpApiEndpoint.delete("delete", "/:id", {
      params: ScheduleIdParams,
      success: DeleteScheduleResponse,
      error: [ScheduleNotFound, Unauthorized],
    }),
  )
  .prefix("/schedules") {}

export class SchedulesApiGroup extends SchedulesApi {}
