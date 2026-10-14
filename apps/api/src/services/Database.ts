import { Context, Effect, Layer } from "effect";
import { Client, Pool, type PoolClient, type QueryResultRow } from "pg";

import type { Env } from "../types";

export interface SqlClient {
  <T extends QueryResultRow = any>(
    strings: TemplateStringsArray,
    ...values: unknown[]
  ): Effect.Effect<T[], Error>;
  unsafe<T extends QueryResultRow = any>(
    query: string,
    params?: ReadonlyArray<unknown>,
  ): Effect.Effect<T[], Error>;
  withTransaction<A, E, R>(effect: Effect.Effect<A, E, R>): Effect.Effect<A, E | Error, R>;
}

export class Database extends Context.Service<Database, SqlClient>()("claustrum/Database") {}

function parseTemplate(
  strings: TemplateStringsArray,
  values: readonly unknown[],
): { text: string; values: unknown[] } {
  let text = strings[0] ?? "";
  const params: unknown[] = [];
  for (let i = 0; i < values.length; i++) {
    params.push(values[i]);
    text += `$${i + 1}${strings[i + 1] ?? ""}`;
  }
  return { text, values: params };
}

export function createPgPool(connectionString: string): Pool {
  return new Pool({
    connectionString,
    max: 10,
    connectionTimeoutMillis: 10000,
  });
}

export function getDatabaseConnectionString(env: Env): string {
  if (env.HYPERDRIVE?.connectionString) {
    return env.HYPERDRIVE.connectionString;
  }
  return env.DATABASE_URL;
}

export type DbExecutor = Client | PoolClient | Pool;

export function makeSqlClient(executor: DbExecutor): SqlClient {
  const sqlFn = (<T extends QueryResultRow = any>(
    strings: TemplateStringsArray,
    ...values: unknown[]
  ): Effect.Effect<T[], Error> => {
    const { text, values: params } = parseTemplate(strings, values);
    return Effect.tryPromise({
      try: async () => {
        const res = await executor.query<T>(text, params);
        return res.rows;
      },
      catch: (err) => {
        console.error("SQL TEMPLATE ERROR:", err, "query:", text);
        return err instanceof Error ? err : new Error(String(err));
      },
    });
  }) as SqlClient;

  sqlFn.unsafe = <T extends QueryResultRow = any>(
    query: string,
    params?: ReadonlyArray<unknown>,
  ): Effect.Effect<T[], Error> =>
    Effect.tryPromise({
      try: async () => {
        const res = await executor.query<T>(query, params ? [...params] : undefined);
        return res.rows;
      },
      catch: (err) => {
        console.error("SQL UNSAFE ERROR:", err, "query:", query);
        return err instanceof Error ? err : new Error(String(err));
      },
    });

  sqlFn.withTransaction = <A, E, R>(
    effect: Effect.Effect<A, E, R>,
  ): Effect.Effect<A, E | Error, R> =>
    Effect.gen(function* () {
      yield* Effect.tryPromise({
        try: () => executor.query("BEGIN;"),
        catch: (err) => (err instanceof Error ? err : new Error(String(err))),
      });
      try {
        const result = yield* effect;
        yield* Effect.tryPromise({
          try: () => executor.query("COMMIT;"),
          catch: (err) => (err instanceof Error ? err : new Error(String(err))),
        });
        return result;
      } catch (err) {
        yield* Effect.tryPromise({
          try: () => executor.query("ROLLBACK;"),
          catch: (e) => (e instanceof Error ? e : new Error(String(e))),
        }).pipe(Effect.ignore);
        return yield* Effect.fail(err as E | Error);
      }
    });

  return sqlFn;
}

export const createDatabaseLayer = (executor: DbExecutor): Layer.Layer<Database> =>
  Layer.succeed(Database, makeSqlClient(executor));
