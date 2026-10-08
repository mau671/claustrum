import { createClient } from "@supabase/supabase-js";

import { authClient } from "@/lib/auth/client";
import { getSupabasePublicEnv } from "@/lib/env/public";

export async function getSupabaseServerClient(headers: Headers, customFetchImpl?: any) {
  const { supabaseUrl, supabasePublishableKey } = getSupabasePublicEnv();

  const fetchHeaders: Record<string, string> = {};
  const cookie =
    typeof headers.get === "function"
      ? (headers as Headers).get("cookie")
      : (headers as any).cookie;
  const authorization =
    typeof headers.get === "function"
      ? (headers as Headers).get("authorization")
      : (headers as any).authorization;

  if (cookie) fetchHeaders.cookie = cookie;
  if (authorization) fetchHeaders.authorization = authorization;

  const res = await authClient
    .token({
      fetchOptions: {
        headers: fetchHeaders,
        customFetchImpl,
      },
    })
    .catch((err) => ({ data: null, error: err }));

  if (res.error) {
    throw new Error(
      "Failed to get auth token for Supabase: " + (res.error.message || JSON.stringify(res.error)),
    );
  }

  const token = res.data?.token ?? null;

  return createClient(supabaseUrl, supabasePublishableKey, {
    global: {
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    },
    auth: {
      persistSession: false,
    },
  });
}
