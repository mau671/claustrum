import { Effect, FileSystem, Layer } from "effect";
import { Etag, HttpEffect, HttpPlatform, HttpRouter } from "effect/http";
import { HttpApiBuilder, HttpApiSwagger } from "effect/http-api";
import { Client } from "pg";

import type { Env } from "./types";

import { ClaustrumApi } from "./api/index";
import { CurrentUser, type AuthUser } from "./domain/Auth";
import { ApiEnv } from "./domain/Reviews";
import { academicUnitsHandlers } from "./handlers/academicUnits";
import { campusesHandlers } from "./handlers/campuses";
import { coursesHandlers } from "./handlers/courses";
import { EvaluationsHandlers } from "./handlers/evaluations";
import { FeedbackHandlers } from "./handlers/feedback";
import { ModerationHandlers } from "./handlers/moderation";
import { notificationsHandlers } from "./handlers/notifications";
import { ProfessorsApiHandlers } from "./handlers/professors";
import { ReportsHandlers } from "./handlers/reports";
import { ReviewsApiHandlers } from "./handlers/reviews";
import { schedulesHandlers } from "./handlers/schedules";
import { StudentsApiHandlers } from "./handlers/students";
import { studyPlansHandlers } from "./handlers/studyPlans";
import { termsHandlers } from "./handlers/terms";
import { universitiesHandlers } from "./handlers/universities";
import { UsersHandlers } from "./handlers/users";
import { getCorsHeaders } from "./lib/cors";
import { getAuth, getDbPool } from "./lib/db";
import { createDatabaseLayer } from "./services/Database";
import { makeStorageService, Storage } from "./services/Storage";

const platformLayer = HttpPlatform.layer.pipe(
  Layer.provide([Etag.layer, FileSystem.layerNoop({})]),
);

const handlersLayer = Layer.mergeAll(
  universitiesHandlers,
  campusesHandlers,
  academicUnitsHandlers,
  studyPlansHandlers,
  termsHandlers,
  coursesHandlers,
  schedulesHandlers,
  ProfessorsApiHandlers,
  ReviewsApiHandlers,
  StudentsApiHandlers,
  EvaluationsHandlers,
  ModerationHandlers,
  FeedbackHandlers,
  ReportsHandlers,
  UsersHandlers,
  notificationsHandlers,
);

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const corsHeaders = getCorsHeaders(request, env);

    if (request.method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: corsHeaders,
      });
    }

    const url = new URL(request.url);

    // Better Auth endpoints
    if (url.pathname.startsWith("/api/auth")) {
      const pool = getDbPool(env);
      const auth = getAuth(env, pool);

      try {
        if (url.pathname === "/api/auth/me" && request.method === "GET") {
          const session = await auth.api.getSession({
            headers: request.headers,
          });

          if (!session || !session.user) {
            return Response.json(
              { session: null, user: null, profileContext: null, onboardingStatus: null },
              { headers: corsHeaders },
            );
          }

          const userId = session.user.id;
          const cacheBuster = `/* bypass-cache-${Date.now()} */`;
          const [onboardingResult, profileResult] = await Promise.all([
            pool.query(
              `SELECT onboarding_dismissed_at, onboarding_completed_at ${cacheBuster} FROM public."user" WHERE id = $1`,
              [userId],
            ),
            pool.query(`SELECT * FROM public.get_user_profile_with_context($1) ${cacheBuster}`, [
              userId,
            ]),
          ]);

          return Response.json(
            {
              session: session.session,
              user: session.user,
              onboardingStatus: onboardingResult.rows[0] || null,
              profileContext: profileResult.rows[0] || null,
            },
            { headers: corsHeaders },
          );
        }

        const authResponse = await auth.handler(request);
        if (authResponse) {
          const responseHeaders = new Headers(authResponse.headers);
          for (const [key, value] of Object.entries(corsHeaders)) {
            responseHeaders.set(key, value);
          }
          return new Response(authResponse.body, {
            status: authResponse.status,
            statusText: authResponse.statusText,
            headers: responseHeaders,
          });
        }
      } finally {
        ctx.waitUntil(pool.end());
      }
    }

    // Server-Sent Events stream for real-time notifications
    if (url.pathname === "/api/v1/notifications/stream") {
      let pool: ReturnType<typeof getDbPool> | null = null;
      let sessionUser: AuthUser | null = null;

      try {
        const cookieHeader = request.headers.get("cookie") ?? "";
        const hasAuth =
          cookieHeader.includes("session_token") || request.headers.has("authorization");
        if (hasAuth) {
          pool = getDbPool(env);
          const auth = getAuth(env, pool);
          const session = await auth.api.getSession({
            headers: request.headers,
          });
          if (session?.user) {
            sessionUser = {
              id: session.user.id,
              email: session.user.email,
              name: session.user.name,
            };
          }
        }
      } catch (e) {
        console.warn("Auth error in notifications stream:", e);
      } finally {
        if (pool) ctx.waitUntil(pool.end());
      }

      if (!sessionUser) {
        return new Response("Unauthorized", {
          status: 401,
          headers: corsHeaders,
        });
      }

      const { readable, writable } = new TransformStream();
      const writer = writable.getWriter();
      const encoder = new TextEncoder();

      let intervalId: ReturnType<typeof setInterval> | null = null;
      let isClosed = false;

      const cleanup = () => {
        if (isClosed) return;
        isClosed = true;
        if (intervalId) {
          clearInterval(intervalId);
          intervalId = null;
        }
        try {
          void writer.close();
        } catch {
          // ignore already closed
        }
      };

      request.signal.addEventListener("abort", cleanup);

      (async () => {
        try {
          await writer.write(
            encoder.encode(
              `event: connected\ndata: ${JSON.stringify({ userId: sessionUser.id, timestamp: Date.now() })}\n\n`,
            ),
          );

          intervalId = setInterval(async () => {
            if (isClosed) return;
            try {
              await writer.write(encoder.encode(": keepalive\n\n"));
            } catch {
              cleanup();
            }
          }, 25000);
        } catch {
          cleanup();
        }
      })();

      return new Response(readable, {
        headers: {
          ...corsHeaders,
          "Content-Type": "text/event-stream",
          "Cache-Control": "no-cache, no-transform",
          Connection: "keep-alive",
        },
      });
    }

    // Effect HttpApi endpoints (/api/v1/*)
    if (url.pathname.startsWith("/api/v1")) {
      const client = new Client({
        connectionString: env.HYPERDRIVE ? env.HYPERDRIVE.connectionString : env.DATABASE_URL,
      });
      await client.connect();

      let sessionUser: AuthUser | null = null;
      let pool: ReturnType<typeof getDbPool> | null = null;

      const cookieHeader = request.headers.get("cookie") ?? "";
      const hasAuth =
        cookieHeader.includes("session_token") || request.headers.has("authorization");

      if (hasAuth) {
        pool = getDbPool(env);
        try {
          const auth = getAuth(env, pool);
          const session = await auth.api.getSession({
            headers: request.headers,
          });
          if (session?.user) {
            sessionUser = {
              id: session.user.id,
              email: session.user.email,
              name: session.user.name,
              role: session.user.role ?? null,
              banned: session.user.banned ?? false,
              banReason: session.user.banReason ?? null,
            };
          }
        } catch (e) {
          console.warn("Failed to retrieve user session:", e);
        }
      }

      const databaseLayer = createDatabaseLayer(client);
      const storageLayer = Layer.succeed(Storage, makeStorageService(env.EVALUATIONS_BUCKET));
      const envLayer = Layer.succeed(ApiEnv, env);

      const userLayer = Layer.succeed(CurrentUser, sessionUser);

      const isDocs = url.pathname.startsWith("/api/v1/docs");
      const isOpenApi = url.pathname === "/api/v1/openapi.json";

      const baseApiLayer = HttpApiBuilder.layer(ClaustrumApi, {
        openapiPath: isOpenApi || isDocs ? "/api/v1/openapi.json" : undefined,
      }).pipe(
        Layer.provide(handlersLayer),
        Layer.provide(databaseLayer),
        Layer.provide(storageLayer),
        Layer.provide(envLayer),
        Layer.provide(userLayer),
        Layer.provide(platformLayer),
        Layer.provide(Etag.layer),
      );

      const apiLayer = isDocs
        ? baseApiLayer.pipe(
            Layer.provide(HttpApiSwagger.layer(ClaustrumApi, { path: "/api/v1/docs" })),
          )
        : baseApiLayer;

      const program = Effect.gen(function* () {
        const httpEffect = yield* HttpRouter.toHttpEffect(apiLayer);
        const webHandler = HttpEffect.toWebHandler(httpEffect);
        return yield* Effect.tryPromise({
          try: () => webHandler(request),
          catch: (err) => (err instanceof Error ? err : new Error(String(err))),
        });
      }).pipe(Effect.scoped);

      try {
        const response = await Effect.runPromise(program as Effect.Effect<Response, Error>);
        const responseHeaders = new Headers(response.headers);
        for (const [key, value] of Object.entries(corsHeaders)) {
          responseHeaders.set(key, value);
        }

        if (
          request.method === "GET" &&
          response.status === 200 &&
          !responseHeaders.has("Cache-Control")
        ) {
          const path = url.pathname;
          if (
            path.includes("/studyplans") ||
            path.includes("/universities") ||
            path.includes("/campuses") ||
            path.includes("/academicunits") ||
            path.includes("/terms")
          ) {
            responseHeaders.set(
              "Cache-Control",
              "public, max-age=300, stale-while-revalidate=86400",
            );
          } else if (path.includes("/schedules/courses")) {
            responseHeaders.set(
              "Cache-Control",
              "public, max-age=120, stale-while-revalidate=3600",
            );
          } else if (
            path.includes("/students/me") ||
            path.includes("/users/me") ||
            path.includes("/schedules") ||
            path.includes("/notifications")
          ) {
            responseHeaders.set("Cache-Control", "private, no-cache, no-store, must-revalidate");
          }
        }
        // Stream the body through untouched: decoding it as text would corrupt
        // binary responses (e.g. evaluation PDFs served from R2).
        const hasBody =
          response.body !== null && response.status !== 204 && response.status !== 304;
        const fallbackBody =
          response.status >= 400
            ? JSON.stringify({ error: `HTTP ${response.status}`, status: response.status })
            : null;
        return new Response(hasBody ? response.body : fallbackBody, {
          status: response.status,
          statusText: response.statusText,
          headers: responseHeaders,
        });
      } catch (error) {
        console.error("Effect HttpApi error:", error);
        const message = error instanceof Error ? error.message : String(error);
        const stack = error instanceof Error ? error.stack : undefined;
        return Response.json(
          { error: "Internal server error", message, stack },
          { status: 500, headers: corsHeaders },
        );
      } finally {
        ctx.waitUntil(Promise.all([client.end(), pool ? pool.end() : Promise.resolve()]));
      }
    }

    return Response.json({ error: "Not found" }, { status: 404, headers: corsHeaders });
  },
};
