import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";
import * as Schema from "effect/Schema";

import {
  ModerationCountsResponse,
  ModerationEvaluationItem,
  ModerationEvaluationsQuery,
  ModerationReviewItem,
  ModerationReviewsQuery,
} from "../domain/Moderation";
import { ForbiddenError, InternalServerError, UnauthorizedError } from "../domain/Users";

export class ModerationApiGroup extends HttpApiGroup.make("moderation")
  .add(
    HttpApiEndpoint.get("counts", "/counts", {
      success: ModerationCountsResponse,
      error: [UnauthorizedError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.get("reviews", "/reviews", {
      query: ModerationReviewsQuery,
      success: Schema.Array(ModerationReviewItem),
      error: [UnauthorizedError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.get("evaluations", "/evaluations", {
      query: ModerationEvaluationsQuery,
      success: Schema.Array(ModerationEvaluationItem),
      error: [UnauthorizedError, ForbiddenError, InternalServerError],
    }),
  )
  .prefix("/moderation") {}

export class ModerationApi extends HttpApi.make("claustrum").add(ModerationApiGroup) {}
