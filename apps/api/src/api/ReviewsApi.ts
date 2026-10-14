import { Schema } from "effect";
import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  CreateReviewPayload,
  CreateReviewResponse,
  ListReviewsQuery,
  ModerateReviewPayload,
  ModerateReviewResponse,
  PublicReviewItem,
  ReviewBadRequest,
  ReviewDetail,
  ReviewForbidden,
  ReviewIdParam,
  ReviewInternalServerError,
  ReviewNotFound,
  ReviewReactionPayload,
  ReviewReactionResponse,
  ReviewReportPayload,
  ReviewReportResponse,
  ReviewUnauthorized,
  SuccessResponse,
} from "../domain/Reviews";

export class ReviewsApiGroup extends HttpApiGroup.make("reviews")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: ListReviewsQuery,
      success: Schema.Array(PublicReviewItem),
      error: ReviewForbidden,
    }),
    HttpApiEndpoint.post("create", "/", {
      payload: CreateReviewPayload,
      success: CreateReviewResponse,
      error: [ReviewBadRequest, ReviewUnauthorized, ReviewForbidden, ReviewInternalServerError],
    }),
    HttpApiEndpoint.get("getById", "/:id", {
      params: ReviewIdParam,
      success: ReviewDetail,
      error: ReviewNotFound,
    }),
    HttpApiEndpoint.patch("moderate", "/:id", {
      params: ReviewIdParam,
      payload: ModerateReviewPayload,
      success: ModerateReviewResponse,
      error: [ReviewBadRequest, ReviewUnauthorized, ReviewForbidden, ReviewNotFound],
    }),
    HttpApiEndpoint.delete("remove", "/:id", {
      params: ReviewIdParam,
      success: SuccessResponse,
      error: [ReviewUnauthorized, ReviewForbidden, ReviewNotFound],
    }),
    HttpApiEndpoint.post("react", "/:id/reactions", {
      params: ReviewIdParam,
      payload: ReviewReactionPayload,
      success: ReviewReactionResponse,
      error: [ReviewUnauthorized, ReviewForbidden, ReviewNotFound],
    }),
    HttpApiEndpoint.post("report", "/:id/reports", {
      params: ReviewIdParam,
      payload: ReviewReportPayload,
      success: ReviewReportResponse,
      error: [
        ReviewBadRequest,
        ReviewUnauthorized,
        ReviewForbidden,
        ReviewNotFound,
        ReviewInternalServerError,
      ],
    }),
  )
  .prefix("/reviews") {}

export class ReviewsApi extends HttpApi.make("ReviewsApi").add(ReviewsApiGroup) {}
