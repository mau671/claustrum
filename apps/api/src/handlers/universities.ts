import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import { ClaustrumApi } from "../api/index";
import { Database, type SqlClient } from "../services/Database";

export const universitiesHandlers = HttpApiBuilder.group(
  ClaustrumApi,
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

          return res.map((row) => ({
            id: Number(row.id),
            name: row.name,
            short_name: row.short_name,
          }));
        }),
    });
  }),
);
