import { Hono } from "hono";
import { cors } from "hono/cors";

import type { Env } from "./types";

import { getAllowedOrigins } from "./lib/cors";
import { fail, HttpError } from "./lib/http";
import authRoutes from "./routes/auth";
import evaluationsRoutes from "./routes/evaluations";
import feedbackRoutes from "./routes/feedback";
import professorReviewsRoutes from "./routes/professor-reviews";

const app = new Hono<{ Bindings: Env }>();

app.use(
  "/api/*",
  cors({
    origin: (origin, c) => {
      const allowedOrigins = getAllowedOrigins(c.env);
      if (origin && allowedOrigins.includes(origin)) return origin;
      return c.env.BETTER_AUTH_URL;
    },
    allowHeaders: ["Authorization", "X-Client-Info", "Apikey", "Content-Type"],
    allowMethods: ["POST", "GET", "OPTIONS"],
    exposeHeaders: ["Content-Disposition", "Content-Length", "set-auth-jwt"],
    credentials: true,
  }),
);

app.route("/api/auth", authRoutes);
app.route("/api", evaluationsRoutes);
app.route("/api", professorReviewsRoutes);
app.route("/api/feedback", feedbackRoutes);

app.notFound((c) => fail(404, "Not found", c.req.raw, c.env));

app.onError((error, c) => {
  if (error instanceof HttpError) {
    return fail(error.status, error.message, c.req.raw, c.env);
  }

  console.error(
    JSON.stringify({
      message: "Unhandled Worker error",
      path: c.req.path,
      method: c.req.method,
      error: error instanceof Error ? error.message : String(error),
    }),
  );

  return fail(500, "Internal server error", c.req.raw, c.env);
});

export default app;
