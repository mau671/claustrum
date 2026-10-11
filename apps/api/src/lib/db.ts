import type { Context } from "hono";

import { Pool, type PoolClient } from "pg";

import type { Env, HonoEnv } from "../types";

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

export async function withDb<T>(
  c: Context<HonoEnv>,
  callback: (pool: Pool) => Promise<T>,
): Promise<T> {
  const pool = getDbPool(c.env);
  try {
    return await callback(pool);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }
}

export async function withUserDb<T>(
  c: Context<HonoEnv>,
  userId: string,
  callback: (client: PoolClient) => Promise<T>,
): Promise<T> {
  const pool = getDbPool(c.env);
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query("SELECT set_config('request.jwt.claims', $1, true)", [
      JSON.stringify({ sub: userId }),
    ]);
    const result = await callback(client);
    await client.query("COMMIT");
    return result;
  } catch (error) {
    await client.query("ROLLBACK").catch(() => {});
    throw error;
  } finally {
    client.release();
    c.executionCtx.waitUntil(pool.end());
  }
}
