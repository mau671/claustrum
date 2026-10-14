import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import type { FeedbackItem, FeedbackType } from "../domain/Feedback";
import type { Env } from "../types";

import { ClaustrumApi } from "../api/index";
import {
  BadRequestError,
  checkAuth,
  checkRole,
  CurrentUser,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
} from "../domain/Users";
import { verifyTurnstileToken } from "../lib/security";
import { Database } from "../services/Database";

interface FeedbackDbRow {
  readonly id: number | string;
  readonly type: FeedbackType;
  readonly content: string;
  readonly is_reviewed: boolean;
  readonly created_at: unknown;
  readonly user_id: string | null;
  readonly admin_notes: string | null;
}

export const FeedbackHandlers = HttpApiBuilder.group(ClaustrumApi, "feedback", (handlers) =>
  Effect.gen(function* () {
    const sql = (yield* Database) as unknown as PgClient.PgClient;

    return handlers
      .handle("list", ({ query }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const limit = query.limit ?? 20;
          const offset = query.offset ?? 0;

          const rows = yield* sql<FeedbackDbRow>`
              SELECT id, type, content, is_reviewed, created_at, user_id, admin_notes
              FROM public.user_feedback
              ORDER BY created_at DESC
              LIMIT ${limit} OFFSET ${offset}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: FeedbackItem[] = rows.map((r) => ({
            id: Number(r.id),
            type: r.type,
            content: r.content,
            is_reviewed: Boolean(r.is_reviewed),
            created_at: r.created_at,
            user_id: r.user_id ? String(r.user_id) : null,
            admin_notes: r.admin_notes ?? null,
          }));

          return mapped;
        }),
      )
      .handle("create", ({ payload, request }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = Option.getOrNull(userOption);

          if (user?.banned) {
            return yield* new ForbiddenError({
              error: "Cuenta suspendida",
              reason: user.banReason ?? null,
            });
          }

          const turnstileSecret = process.env.TURNSTILE_SECRET_KEY;
          if (!turnstileSecret) {
            return yield* new InternalServerError({
              error: "Missing Turnstile secret configuration",
            });
          }

          const rawHeaders = request.headers as Record<string, string | undefined>;
          const remoteIp = rawHeaders["cf-connecting-ip"] ?? rawHeaders["CF-Connecting-IP"] ?? null;

          const isHuman = yield* Effect.tryPromise({
            try: () =>
              verifyTurnstileToken(
                payload.turnstileToken,
                { TURNSTILE_SECRET_KEY: turnstileSecret } as unknown as Env,
                remoteIp,
              ),
            catch: (e) =>
              new BadRequestError({
                error: `Turnstile verification failed: ${e instanceof Error ? e.message : String(e)}`,
              }),
          });

          if (!isHuman) {
            return yield* new BadRequestError({
              error: "Fallo en la validación de seguridad (Turnstile). Inténtalo de nuevo.",
            });
          }

          const isAnonymous = payload.isAnonymous ?? true;
          const userId = !isAnonymous && user ? user.id : null;

          const res = yield* sql<{
            id: number | string;
            type: FeedbackType;
            content: string;
            created_at: unknown;
          }>`
              INSERT INTO public.user_feedback (type, content, user_id)
              VALUES (${payload.type}, ${payload.content}, ${userId})
              RETURNING id, type, content, created_at
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const inserted = res[0];
          return {
            success: true,
            feedback: {
              id: Number(inserted.id),
              type: inserted.type,
              content: inserted.content,
              created_at: inserted.created_at,
            },
          };
        }),
      )
      .handle("getById", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const rows = yield* sql<FeedbackDbRow>`
              SELECT id, type, content, is_reviewed, created_at, user_id, admin_notes
              FROM public.user_feedback
              WHERE id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({ error: "Feedback not found" });
          }

          const r = rows[0];
          return {
            id: Number(r.id),
            type: r.type,
            content: r.content,
            is_reviewed: Boolean(r.is_reviewed),
            created_at: r.created_at,
            user_id: r.user_id ? String(r.user_id) : null,
            admin_notes: r.admin_notes ?? null,
          };
        }),
      )
      .handle("update", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const isReviewed = payload.isReviewed !== undefined ? payload.isReviewed : null;
          const adminNotes = payload.adminNotes !== undefined ? payload.adminNotes : null;

          const rows = yield* sql<Record<string, unknown>>`
              UPDATE public.user_feedback
              SET is_reviewed = COALESCE(${isReviewed}, is_reviewed),
                  admin_notes = COALESCE(${adminNotes}, admin_notes),
                  updated_at = NOW()
              WHERE id = ${params.id}
              RETURNING *
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({ error: "Feedback not found" });
          }

          return {
            success: true,
            feedback: rows[0],
          };
        }),
      )
      .handle("reply", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const adminNotes = payload.notes?.trim() || null;

          yield* sql
            .withTransaction(
              Effect.gen(function* () {
                const updateRes = yield* sql<{ user_id: string | null }>`
                  UPDATE public.user_feedback
                  SET admin_notes = COALESCE(${adminNotes}, admin_notes),
                      is_reviewed = true,
                      updated_at = NOW()
                  WHERE id = ${params.id}
                  RETURNING user_id
                `;

                if (updateRes.length === 0) {
                  return yield* Effect.fail(new NotFoundError({ error: "Feedback not found" }));
                }

                const uid = updateRes[0].user_id;
                if (uid && payload.message.trim() !== "") {
                  yield* sql`
                    INSERT INTO public.notifications (user_id, title, message, link)
                    VALUES (${uid}, 'Respuesta a tu retroalimentación', ${payload.message.trim()}, NULL)
                  `;
                }

                return uid;
              }),
            )
            .pipe(
              Effect.mapError((e) => {
                if (e._tag === "NotFoundError") {
                  return e;
                }
                return new InternalServerError({
                  error: `Transaction failed: ${e.message}`,
                });
              }),
            );

          return { success: true };
        }),
      );
  }),
);
