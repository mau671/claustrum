import { createClient, type SupabaseClient } from "@supabase/supabase-js";

import { authClient } from "@/lib/auth/client";
import { getSupabasePublicEnv } from "@/lib/env/public";

let cached: SupabaseClient | null = null;
let cachedToken: string | null = null;
let cachedTokenExpiresAt = 0;
let tokenInFlight: Promise<string | null> | null = null;
let noSessionTokenRetryAt = 0;

const TOKEN_EXPIRY_LEEWAY_MS = 30_000;
const TOKEN_FALLBACK_TTL_MS = 60_000;
const NO_SESSION_TOKEN_BACKOFF_MS = 30_000;

function clearTokenCache() {
  cachedToken = null;
  cachedTokenExpiresAt = 0;
}

export function resetSupabaseAuthTokenState() {
  noSessionTokenRetryAt = 0;
  clearTokenCache();
}

function decodeBase64Url(input: string) {
  const normalized = input.replace(/-/g, "+").replace(/_/g, "/");
  const padded = normalized.padEnd(Math.ceil(normalized.length / 4) * 4, "=");
  return atob(padded);
}

function getJwtExpiryMs(token: string) {
  try {
    const payloadPart = token.split(".")[1];
    if (!payloadPart) return null;
    const payload = JSON.parse(decodeBase64Url(payloadPart)) as { exp?: number };
    if (typeof payload.exp !== "number") return null;
    return payload.exp * 1000;
  } catch {
    return null;
  }
}

function isCachedTokenValid() {
  if (!cachedToken) return false;
  return Date.now() < cachedTokenExpiresAt - TOKEN_EXPIRY_LEEWAY_MS;
}

async function fetchAndCacheToken() {
  const { data } = await authClient.token().catch(() => ({ data: null }));
  const nextToken = data?.token ?? null;

  if (!nextToken) {
    clearTokenCache();
    noSessionTokenRetryAt = Date.now() + NO_SESSION_TOKEN_BACKOFF_MS;
    return null;
  }

  cachedToken = nextToken;
  cachedTokenExpiresAt = getJwtExpiryMs(nextToken) ?? Date.now() + TOKEN_FALLBACK_TTL_MS;
  noSessionTokenRetryAt = 0;

  return cachedToken;
}

export function getSupabaseBrowserClient(): SupabaseClient {
  const { supabaseUrl, supabasePublishableKey } = getSupabasePublicEnv();

  // En SSR no podemos compartir caché ni promesas en vuelo entre peticiones (provoca leaks y cuelgues)
  const isServer = typeof window === "undefined";

  if (!isServer && cached) return cached;

  const client = createClient(supabaseUrl, supabasePublishableKey, {
    accessToken: async () => {
      if (isServer) {
        // En SSR simplemente buscamos el token sin caché para evitar cruce de contextos
        const { data } = await authClient.token().catch(() => ({ data: null }));
        return data?.token ?? null;
      }

      if (isCachedTokenValid()) {
        return cachedToken;
      }

      if (Date.now() < noSessionTokenRetryAt) {
        return null;
      }

      if (tokenInFlight) {
        return tokenInFlight;
      }

      tokenInFlight = fetchAndCacheToken().finally(() => {
        tokenInFlight = null;
      });

      return tokenInFlight;
    },
  });

  if (!isServer) {
    cached = client;
  }

  return client;
}
