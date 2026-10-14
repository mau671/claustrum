import { Effect, Layer } from "effect";
import { Etag, HttpEffect, HttpPlatform, HttpRouter } from "effect/http";
import { HttpApiBuilder, HttpApiSwagger } from "effect/http-api";

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
import { createDatabaseLayer, getDatabaseConnectionString } from "./services/Database";
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

    // Effect HttpApi endpoints (/api/v1/*, /docs, /openapi.json)
    if (
      url.pathname.startsWith("/api/v1") ||
      url.pathname.startsWith("/docs") ||
      url.pathname === "/openapi.json"
    ) {
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
            role: session.user.role ?? null,
            banned: session.user.banned ?? false,
            banReason: session.user.banReason ?? null,
          };
        }
      } catch (e) {
        console.warn("Failed to retrieve user session:", e);
      }

      const connectionString = getDatabaseConnectionString(env);
      const databaseLayer = createDatabaseLayer(connectionString);
      const storageLayer = Layer.succeed(Storage, makeStorageService(env.EVALUATIONS_BUCKET));
      const envLayer = Layer.succeed(ApiEnv, env);

      const userLayer = sessionUser ? Layer.succeed(CurrentUser, sessionUser) : Layer.empty;

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

      const apiLayer = HttpApiBuilder.layer(ClaustrumApi).pipe(
        Layer.provide(handlersLayer),
        Layer.provide(HttpApiSwagger.layer(ClaustrumApi, { path: "/docs" })),
        Layer.provide(databaseLayer),
        Layer.provide(storageLayer),
        Layer.provide(envLayer),
        Layer.provide(userLayer),
        Layer.provide([HttpPlatform.layer, Etag.layer]),
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
        const responseHeaders = new Headers(response.headers);
        for (const [key, value] of Object.entries(corsHeaders)) {
          responseHeaders.set(key, value);
        }
        return new Response(response.body, {
          status: response.status,
          statusText: response.statusText,
          headers: responseHeaders,
        });
      } catch (error) {
        console.error("Effect HttpApi error:", error);
        return Response.json(
          { error: "Internal server error" },
          { status: 500, headers: corsHeaders },
        );
      } finally {
        ctx.waitUntil(pool.end());
      }
    }

    return Response.json({ error: "Not found" }, { status: 404, headers: corsHeaders });
  },
};
