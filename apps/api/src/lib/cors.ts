import type { Env } from "../types";

export const baseCorsHeaders = {
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
  "Access-Control-Expose-Headers": "Content-Disposition",
};

export function getAllowedOrigins(env: Env): string[] {
  return [
    env.BETTER_AUTH_URL,
    ...(env.CORS_ORIGINS?.split(",")
      .map((value) => value.trim())
      .filter(Boolean) ?? []),
  ];
}

export function getCorsHeaders(request: Request, env: Env): Record<string, string> {
  const origin = request.headers.get("origin");
  const allowedOrigins = getAllowedOrigins(env);
  const allowOrigin = origin && allowedOrigins.includes(origin) ? origin : env.BETTER_AUTH_URL;
  return {
    ...baseCorsHeaders,
    "Access-Control-Allow-Origin": allowOrigin,
    "Access-Control-Allow-Credentials": "true",
  };
}
