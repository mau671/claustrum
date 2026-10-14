import { Schema } from "effect";
import { HttpApiEndpoint, HttpApiGroup } from "effect/http-api";

import {
  ListNotificationsQuery,
  NotFoundError,
  NotificationIdParam,
  NotificationItem,
  SuccessResponse,
  UnauthorizedError,
} from "../domain/Notifications";

export class NotificationsApiGroup extends HttpApiGroup.make("notifications")
  .add(
    HttpApiEndpoint.get("listNotifications", "/notifications", {
      query: ListNotificationsQuery,
      success: Schema.Array(NotificationItem),
    }),
  )
  .add(
    HttpApiEndpoint.patch("markAsRead", "/notifications/:id", {
      params: NotificationIdParam,
      success: SuccessResponse,
      error: [UnauthorizedError, NotFoundError],
    }),
  )
  .add(
    HttpApiEndpoint.post("markAllAsRead", "/notifications/read", {
      success: SuccessResponse,
      error: UnauthorizedError,
    }),
  ) {}
