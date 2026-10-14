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
      const pool = getDbPool(env);
      const auth = getAuth(env, pool);
      let sessionUser: AuthUser | null = null;

      try {
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
      } catch (e) {
        console.warn("Auth error in notifications stream:", e);
      } finally {
        ctx.waitUntil(pool.end());
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

      ctx.waitUntil(
        (async () => {
          try {
            await writer.write(
              encoder.encode(
                `event: connected\ndata: ${JSON.stringify({ userId: sessionUser.id, timestamp: Date.now() })}\n\n`,
              ),
            );

            // Periodic heartbeat every 30s to keep connection alive
            for (let i = 0; i < 20; i++) {
              await new Promise((resolve) => setTimeout(resolve, 30000));
              await writer.write(
                encoder.encode(
                  `event: ping\ndata: ${JSON.stringify({ timestamp: Date.now() })}\n\n`,
                ),
              );
            }
          } catch {
            // Client closed connection
          } finally {
            try {
              await writer.close();
            } catch {
              // Ignore
            }
          }
        })(),
      );

      return new Response(readable, {
        headers: {
          ...corsHeaders,
          "Content-Type": "text/event-stream",
          "Cache-Control": "no-cache, no-transform",
          Connection: "keep-alive",
        },
      });
    }

    // Effect HttpApi endpoints (/api/v1/*, /docs, /openapi.json)
    if (
      url.pathname.startsWith("/api/v1") ||
      url.pathname.startsWith("/docs") ||
      url.pathname === "/openapi.json"
    ) {
      const client = new Client({
        connectionString: env.HYPERDRIVE ? env.HYPERDRIVE.connectionString : env.DATABASE_URL,
      });
      await client.connect();

      const pool = getDbPool(env);
      let sessionUser: AuthUser | null = null;

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

      const databaseLayer = createDatabaseLayer(client);
      const storageLayer = Layer.succeed(Storage, makeStorageService(env.EVALUATIONS_BUCKET));
      const envLayer = Layer.succeed(ApiEnv, env);

      const userLayer = Layer.succeed(CurrentUser, sessionUser);

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

      const platformLayer = HttpPlatform.layer.pipe(
        Layer.provide([Etag.layer, FileSystem.layerNoop({})]),
      );

      const apiLayer = HttpApiBuilder.layer(ClaustrumApi, {
        openapiPath: "/openapi.json",
      }).pipe(
        Layer.provide(handlersLayer),
        Layer.provide(HttpApiSwagger.layer(ClaustrumApi, { path: "/docs" })),
        Layer.provide(databaseLayer),
        Layer.provide(storageLayer),
        Layer.provide(envLayer),
        Layer.provide(userLayer),
        Layer.provide(platformLayer),
        Layer.provide(Etag.layer),
      );

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
        const bodyText = await response.text();
        const responseHeaders = new Headers(response.headers);
        for (const [key, value] of Object.entries(corsHeaders)) {
          responseHeaders.set(key, value);
        }
        return new Response(
          bodyText ||
            (response.status >= 400
              ? JSON.stringify({ error: `HTTP ${response.status}`, status: response.status })
              : null),
          {
            status: response.status,
            statusText: response.statusText,
            headers: responseHeaders,
          },
        );
      } catch (error) {
        console.error("Effect HttpApi error:", error);
        const message = error instanceof Error ? error.message : String(error);
        const stack = error instanceof Error ? error.stack : undefined;
        return Response.json(
          { error: "Internal server error", message, stack },
          { status: 500, headers: corsHeaders },
        );
      } finally {
        ctx.waitUntil(Promise.all([client.end(), pool.end()]));
      }
    }

    return Response.json({ error: "Not found" }, { status: 404, headers: corsHeaders });
  },
};
