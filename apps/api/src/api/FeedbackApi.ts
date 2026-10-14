import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";
import * as Schema from "effect/Schema";

import {
  CreateFeedbackPayload,
  CreateFeedbackResponse,
  FeedbackItem,
  ListFeedbackQuery,
  ReplyFeedbackPayload,
  UpdateFeedbackPayload,
  UpdateFeedbackResponse,
} from "../domain/Feedback";
import {
  BadRequestError,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  SuccessResponse,
  UnauthorizedError,
} from "../domain/Users";

export class FeedbackApiGroup extends HttpApiGroup.make("feedback")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: ListFeedbackQuery,
      success: Schema.Array(FeedbackItem),
      error: [UnauthorizedError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.post("create", "/", {
      payload: CreateFeedbackPayload,
      success: CreateFeedbackResponse,
      error: [BadRequestError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.get("getById", "/:id", {
      params: { id: Schema.NumberFromString },
      success: FeedbackItem,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.patch("update", "/:id", {
      params: { id: Schema.NumberFromString },
      payload: UpdateFeedbackPayload,
      success: UpdateFeedbackResponse,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.post("reply", "/:id/replies", {
      params: { id: Schema.NumberFromString },
      payload: ReplyFeedbackPayload,
      success: SuccessResponse,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
  )
  .prefix("/feedback") {}

export class FeedbackApi extends HttpApi.make("claustrum").add(FeedbackApiGroup) {}
