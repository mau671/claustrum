import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApi, HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import { NotificationsApiGroup } from "../api/NotificationsApi";
import { checkAuth, CurrentUser } from "../domain/Auth";
import { NotFoundError, type NotificationItem } from "../domain/Notifications";
import { Database } from "../services/Database";

interface NotificationDbRow {
  readonly id: string;
  readonly user_id: string | null;
  readonly title: string;
  readonly message: string;
  readonly link: string | null;
  readonly is_read: boolean;
  readonly created_at: unknown;
}

const notificationsApi = HttpApi.make("claustrum-notifications").add(NotificationsApiGroup);

export const notificationsHandlers = HttpApiBuilder.group(
  notificationsApi,
  "notifications",
  (handlers: any) =>
    Effect.gen(function* () {
      const sql = (yield* Database) as unknown as PgClient.PgClient;

      return handlers
        .handle("listNotifications", ({ query }: { query: { limit?: number } }) =>
          Effect.gen(function* () {
            const userOption = yield* Effect.serviceOption(CurrentUser);
            const user = Option.getOrNull(userOption);
            const limit = query.limit ?? 50;

            const rows = user?.id
              ? yield* sql.unsafe<NotificationDbRow>(
                  `SELECT id, user_id, title, message, link, is_read, created_at
                   FROM public.notifications
                   WHERE user_id = $1 OR user_id IS NULL
                   ORDER BY created_at DESC
                   LIMIT $2`,
                  [user.id, limit],
                )
              : yield* sql.unsafe<NotificationDbRow>(
                  `SELECT id, user_id, title, message, link, is_read, created_at
                   FROM public.notifications
                   WHERE user_id IS NULL
                   ORDER BY created_at DESC
                   LIMIT $1`,
                  [limit],
                );

            return rows.map((r): NotificationItem => ({
              id: r.id,
              user_id: r.user_id,
              title: r.title,
              message: r.message,
              link: r.link,
              is_read: Boolean(r.is_read),
              created_at: r.created_at as string | Date,
            }));
          }),
        )
        .handle("markAsRead", ({ params }: { params: { id: string } }) =>
          Effect.gen(function* () {
            const userOption = yield* Effect.serviceOption(CurrentUser);
            const user = yield* checkAuth(Option.getOrNull(userOption));

            const rows = yield* sql.unsafe<{ id: string }>(
              `UPDATE public.notifications
               SET is_read = true
               WHERE id = $1 AND user_id = $2
               RETURNING id`,
              [params.id, user.id],
            );

            if (rows.length === 0) {
              return yield* Effect.fail(new NotFoundError({ error: "Notification not found" }));
            }

            return { success: true };
          }),
        )
        .handle("markAllAsRead", () =>
          Effect.gen(function* () {
            const userOption = yield* Effect.serviceOption(CurrentUser);
            const user = yield* checkAuth(Option.getOrNull(userOption));

            yield* sql.unsafe(
              `UPDATE public.notifications
               SET is_read = true
               WHERE user_id = $1`,
              [user.id],
            );

            return { success: true };
          }),
        );
    }),
);
