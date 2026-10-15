import { Pool } from "pg";

import type { Env } from "../types";

import { createAuth } from "../auth";

let cachedConnStr = "";
let cachedPool: Pool | null = null;
let cachedAuth: ReturnType<typeof createAuth> | null = null;

export function getDbPool(env: Env): Pool {
  const connectionString = env.HYPERDRIVE ? env.HYPERDRIVE.connectionString : env.DATABASE_URL;

  if (cachedPool && cachedConnStr === connectionString) {
    return cachedPool;
  }

  cachedConnStr = connectionString;
  cachedPool = new Pool({
    connectionString,
    max: 5,
    connectionTimeoutMillis: 10000,
  });

  return cachedPool;
}

export function getAuth(env: Env, pool: Pool) {
  if (cachedAuth && cachedPool === pool) {
    return cachedAuth;
  }

  cachedAuth = createAuth(env, pool);
  return cachedAuth;
}
