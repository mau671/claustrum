import { Effect } from "effect";
import { HttpApi, HttpApiBuilder } from "effect/http-api";

import type { Campus, CampusesQuery } from "../domain/Campuses";

import { CampusesApiGroup } from "../api/CampusesApi";
import { Database, type SqlClient } from "../services/Database";

const campusesApi = HttpApi.make("claustrum-campuses").add(CampusesApiGroup);

export const campusesHandlers = HttpApiBuilder.group(
  campusesApi,
  "campuses",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      list: ({ query }: { query: CampusesQuery }) =>
        Effect.gen(function* () {
          const includeAll = query.all === "true";

          if (!includeAll && query.universityId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                university_id: string | number;
                code: string;
                name: string;
              }>(
                "SELECT id, university_id, code, name FROM public.get_campuses_for_university($1) ORDER BY name ASC",
                [query.universityId],
              )
              .pipe(Effect.orDie);

            return res.map((row): Campus => ({
              id: Number(row.id),
              university_id: Number(row.university_id),
              code: row.code,
              name: row.name,
            }));
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              university_id: string | number;
              code: string;
              name: string;
            }>(
              `SELECT id, university_id, code, name
               FROM public.campus
               WHERE is_active = true
                 AND ($1::bigint IS NULL OR university_id = $1)
                 AND ($2::boolean IS TRUE OR code = ANY(ARRAY['AL', 'CA', 'LM', 'SC', 'SJ']::TEXT[]))
               ORDER BY name ASC`,
              [query.universityId ?? null, includeAll],
            )
            .pipe(Effect.orDie);

          return res.map((row): Campus => ({
            id: Number(row.id),
            university_id: Number(row.university_id),
            code: row.code,
            name: row.name,
          }));
        }),
    });
  }),
);
