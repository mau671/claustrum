import { createClient } from "@supabase/supabase-js";

import type { Env } from "../types";

export function getSupabaseAdmin(env: Env) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_SECRET_KEY);
}

export function getSupabaseClient(env: Env, jwt?: string) {
  const options = jwt
    ? {
        global: {
          headers: {
            Authorization: `Bearer ${jwt}`,
          },
        },
      }
    : undefined;
  return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, options);
}
