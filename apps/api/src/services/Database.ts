import { PgClient } from "@effect/sql-pg";
import * as Context from "effect/Context";
import * as Layer from "effect/Layer";
import * as Redacted from "effect/Redacted";
import { Pool } from "pg";

import type { Env } from "../types";

export class Database extends Context.Service<Database, PgClient.PgClient>()(
  "claustrum/Database",
) {}

export type SqlClient = PgClient.PgClient;

export function createPgPool(connectionString: string): Pool {
  return new Pool({
    connectionString,
    max: 10,
    connectionTimeoutMillis: 10000,
    options: "-c search_path=better_auth,public",
  });
}

export function getDatabaseConnectionString(env: Env): string {
  if (env.HYPERDRIVE?.connectionString) {
    return env.HYPERDRIVE.connectionString;
  }
  return env.DATABASE_URL;
}

export const createDatabaseLayer = (connectionString: string) =>
  Layer.effect(Database, PgClient.PgClient).pipe(
    Layer.provide(
      PgClient.layer({
        url: Redacted.make(connectionString),
      }),
    ),
  );
