import { HttpApi, HttpApiEndpoint, HttpApiGroup } from "effect/http-api";
import * as Schema from "effect/Schema";

import {
  ListReportsQuery,
  ModerateReportPayload,
  ModerateReportResponse,
  ReportDetail,
  ReportItem,
} from "../domain/Reports";
import {
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  UnauthorizedError,
} from "../domain/Users";

export class ReportsApiGroup extends HttpApiGroup.make("reports")
  .add(
    HttpApiEndpoint.get("list", "/", {
      query: ListReportsQuery,
      success: Schema.Array(ReportItem),
      error: [UnauthorizedError, ForbiddenError, InternalServerError],
    }),
    HttpApiEndpoint.get("getById", "/:id", {
      params: { id: Schema.NumberFromString },
      success: ReportDetail,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
    HttpApiEndpoint.patch("moderate", "/:id", {
      params: { id: Schema.NumberFromString },
      payload: ModerateReportPayload,
      success: ModerateReportResponse,
      error: [UnauthorizedError, ForbiddenError, NotFoundError, InternalServerError],
    }),
  )
  .prefix("/reports") {}

export class ReportsApi extends HttpApi.make("claustrum").add(ReportsApiGroup) {}
