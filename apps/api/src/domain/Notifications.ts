import * as Schema from "effect/Schema";

import {
  BadRequestError,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  SuccessResponse,
  UnauthorizedError,
} from "./Users";

export {
  BadRequestError,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  SuccessResponse,
  UnauthorizedError,
};

export class NotificationItem extends Schema.Class<NotificationItem>("NotificationItem")({
  id: Schema.String,
  user_id: Schema.NullOr(Schema.String),
  title: Schema.String,
  message: Schema.String,
  link: Schema.NullOr(Schema.String),
  is_read: Schema.Boolean,
  created_at: Schema.Union([Schema.String, Schema.Date]),
}) {}

export class ListNotificationsQuery extends Schema.Class<ListNotificationsQuery>(
  "ListNotificationsQuery",
)({
  limit: Schema.optional(Schema.NumberFromString),
}) {}

export class NotificationIdParam extends Schema.Class<NotificationIdParam>("NotificationIdParam")({
  id: Schema.String,
}) {}
