import { Schema } from "effect";
import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  AttemptIdParam,
  InsertAttemptPayload,
  InsertAttemptResponse,
  StudentAttemptsQuery,
  StudentBadRequest,
  StudentCourseAttempt,
  StudentCourseStatus,
  StudentForbidden,
  StudentInternalServerError,
  StudentSuccessResponse,
  StudentUnauthorized,
  StudyPlanIdQuery,
  UpdateAttemptPayload,
} from "../domain/Students";

export class StudentsApiGroup extends HttpApiGroup.make("students")
  .add(
    HttpApiEndpoint.get("statuses", "/me/statuses", {
      query: StudyPlanIdQuery,
      success: Schema.Array(StudentCourseStatus),
      error: [StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
    HttpApiEndpoint.get("stats", "/me/stats", {
      query: StudyPlanIdQuery,
      success: Schema.NullOr(Schema.Unknown),
      error: [StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
    HttpApiEndpoint.get("attempts", "/me/attempts", {
      query: StudentAttemptsQuery,
      success: Schema.Array(StudentCourseAttempt),
      error: [StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
    HttpApiEndpoint.post("createAttempt", "/me/attempts", {
      payload: InsertAttemptPayload,
      success: InsertAttemptResponse,
      error: [StudentBadRequest, StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
    HttpApiEndpoint.patch("updateAttempt", "/me/attempts/:id", {
      params: AttemptIdParam,
      payload: UpdateAttemptPayload,
      success: StudentSuccessResponse,
      error: [StudentBadRequest, StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
    HttpApiEndpoint.delete("deleteAttempt", "/me/attempts/:id", {
      params: AttemptIdParam,
      success: StudentSuccessResponse,
      error: [StudentUnauthorized, StudentForbidden, StudentInternalServerError],
    }),
  )
  .prefix("/students") {}

export class StudentsApi extends HttpApi.make("StudentsApi").add(StudentsApiGroup) {}
