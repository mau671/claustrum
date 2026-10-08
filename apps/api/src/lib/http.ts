import type { Env } from "../types";

import { getCorsHeaders } from "./cors";

export class HttpError extends Error {
  constructor(
    readonly status: number,
    message: string,
  ) {
    super(message);
    this.name = "HttpError";
  }
}

export function jsonResponse(status: number, data: unknown, request: Request, env: Env): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      ...getCorsHeaders(request, env),
      "Content-Type": "application/json",
    },
  });
}

export function ok(data: unknown, request: Request, env: Env): Response {
  return jsonResponse(200, data, request, env);
}

export function fail(status: number, message: string, request: Request, env: Env): Response {
  return jsonResponse(status, { error: message }, request, env);
}
