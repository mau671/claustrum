import { importJWK, jwtVerify, type JWK } from "jose";

import type { Env } from "../types";

import { getSupabaseAdmin } from "./supabase";

export async function verifyAuth(
  request: Request,
  env: Env,
): Promise<{ userId: string; token: string } | null> {
  const authHeader = request.headers.get("authorization");
  if (!authHeader?.startsWith("Bearer ")) return null;

  const token = authHeader.slice(7);
  if (!env.SUPABASE_JWT_PRIVATE_JWK) return null;

  try {
    const publicJwk = JSON.parse(env.SUPABASE_JWT_PRIVATE_JWK) as JWK & { d?: string };
    delete publicJwk.d;
    delete publicJwk.key_ops;
    const key = await importJWK(publicJwk, "ES256");
    const { payload } = await jwtVerify(token, key, {
      issuer: `${env.SUPABASE_URL}/auth/v1`,
      audience: "authenticated",
    });
    if (payload.role !== "authenticated" || typeof payload.sub !== "string") return null;
    return { userId: payload.sub, token };
  } catch {
    return null;
  }
}

export async function isAdmin(userId: string, env: Env): Promise<boolean> {
  const supabase = getSupabaseAdmin(env);
  const { data, error } = await supabase
    .from("user_role")
    .select("id")
    .eq("user_id", userId)
    .eq("role", "admin")
    .maybeSingle();

  if (error) return false;
  return !!data;
}

export async function verifyTurnstileToken(
  token: string,
  env: Env,
  remoteIp: string | null,
): Promise<boolean> {
  const response = await fetch("https://challenges.cloudflare.com/turnstile/v0/siteverify", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      secret: env.TURNSTILE_SECRET_KEY,
      response: token,
      ...(remoteIp ? { remoteip: remoteIp } : {}),
    }),
  });

  if (!response.ok) return false;

  const data = (await response.json()) as { success?: boolean };
  return data.success === true;
}
