import type { Env } from "../types";

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
