import { Pool } from "pg";

import type { Env } from "../types";

import { createAuth } from "../auth";

export function getDbPool(env: Env): Pool {
  const connectionString = env.HYPERDRIVE ? env.HYPERDRIVE.connectionString : env.DATABASE_URL;

  return new Pool({
    connectionString,
    max: 10,
    connectionTimeoutMillis: 10000,
    options: "-c search_path=better_auth,public",
  });
}

export function getAuth(env: Env, pool: Pool) {
  return createAuth(env, pool);
}
