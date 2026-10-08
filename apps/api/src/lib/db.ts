import { Pool } from "pg";

import type { Env } from "../types";

import { createAuth } from "../auth";

export function getDbPool(env: Env): Pool {
  const connectionString = env.HYPERDRIVE ? env.HYPERDRIVE.connectionString : env.DATABASE_URL;

  // We set search_path to better_auth so Better Auth can find its tables.
  // NOTE: This is a privileged connection (bypasses RLS).
  // Any queries against the public schema must manually enforce authorization (e.g. strict WHERE clauses).
  return new Pool({
    connectionString,
    max: 10,
    connectionTimeoutMillis: 10000,
    options: "-c search_path=better_auth,public",
  });
}

export function getAuth(env: Env, pool: Pool): ReturnType<typeof createAuth> {
  return createAuth(env, pool);
}
