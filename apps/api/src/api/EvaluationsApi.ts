import { HttpApi, HttpApiEndpoint, HttpApiGroup, HttpApiSchema } from "effect/http-api";
import * as Schema from "effect/Schema";

import {
  EvaluationDetail,
  EvaluationItem,
  GetEvaluationsQuery,
  ModerateEvaluationPayload,
  ModerateEvaluationResponse,
  UploadEvaluationResponse,
} from "../domain/Evaluations";
import {
  BadRequestError,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  SuccessResponse,
  UnauthorizedError,
} from "../domain/Users";

export class EvaluationsApiGroup extends HttpApiGroup.make("evaluations")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: GetEvaluationsQuery,
      success: Schema.Array(EvaluationItem),
      error: [BadRequestError, InternalServerError],
    }),
    HttpApiEndpoint.post("upload", "/", {
      success: UploadEvaluationResponse,
      error: [BadRequestError, UnauthorizedError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.get("getById", "/:id", {
      params: { id: Schema.NumberFromString },
      success: EvaluationDetail,
      error: [NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.get("getFile", "/:id/file", {
      params: { id: Schema.NumberFromString },
      success: HttpApiSchema.StreamUint8Array({ contentType: "application/pdf" }),
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.get("getAnswers", "/:id/answers", {
      params: { id: Schema.NumberFromString },
      success: HttpApiSchema.StreamUint8Array({ contentType: "application/pdf" }),
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.patch("moderate", "/:id", {
      params: { id: Schema.NumberFromString },
      payload: ModerateEvaluationPayload,
      success: ModerateEvaluationResponse,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.delete("deleteEvaluation", "/:id", {
      params: { id: Schema.NumberFromString },
      success: SuccessResponse,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
  )
  .prefix("/evaluations") {}

export class EvaluationsApi extends HttpApi.make("claustrum").add(EvaluationsApiGroup) {}
