import { Effect } from "effect";
import { HttpApi, HttpApiBuilder } from "effect/http-api";

import type { University } from "../domain/Universities";

import { UniversitiesApiGroup } from "../api/UniversitiesApi";
import { Database, type SqlClient } from "../services/Database";

const universitiesApi = HttpApi.make("claustrum-universities").add(UniversitiesApiGroup);

export const universitiesHandlers = HttpApiBuilder.group(
  universitiesApi,
  "universities",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      list: () =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              id: string | number;
              name: string;
              short_name: string;
            }>("SELECT id, name, short_name FROM public.university ORDER BY name ASC")
            .pipe(Effect.orDie);

          return res.map((row): University => ({
            id: Number(row.id),
            name: row.name,
            short_name: row.short_name,
          }));
        }),
    });
  }),
);
