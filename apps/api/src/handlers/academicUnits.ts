import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import type { AcademicUnit, AcademicUnitsQuery } from "../domain/AcademicUnits";

import { ClaustrumApi } from "../api/index";
import { Database, type SqlClient } from "../services/Database";

export const academicUnitsHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "academicUnits",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      list: ({ query }: { query: AcademicUnitsQuery }) =>
        Effect.gen(function* () {
          if (query.withProfessors === "true") {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                code: string;
                name: string;
              }>(
                `SELECT au.id, au.code, au.name
                 FROM public.academic_unit au
                 WHERE EXISTS (
                   SELECT 1
                   FROM public.course_offering co
                   JOIN public.course_offering_group cog ON cog.course_offering_id = co.id
                   JOIN public.course_offering_group_professor cogp ON cogp.course_offering_group_id = cog.id
                   WHERE co.academic_unit_id = au.id
                 )
                 ORDER BY au.name ASC`,
              )
              .pipe(Effect.orDie);

            return res.map((row): AcademicUnit => ({
              id: Number(row.id),
              code: row.code,
              name: row.name,
            }));
          }

          if (query.campusId) {
            const res = yield* sql
              .unsafe<{
                id: string | number;
                code: string;
                name: string;
                university_id?: string | number | null;
              }>("SELECT * FROM public.get_academic_units_for_campus($1)", [query.campusId])
              .pipe(Effect.orDie);

            return res.map((row): AcademicUnit => ({
              id: Number(row.id),
              code: row.code,
              name: row.name,
              university_id: row.university_id ? Number(row.university_id) : undefined,
            }));
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              code: string;
              name: string;
              university_id: string | number;
            }>(
              "SELECT id, university_id, code, name FROM public.v_academic_units_with_plans ORDER BY name ASC",
            )
            .pipe(Effect.orDie);

          return res.map((row): AcademicUnit => ({
            id: Number(row.id),
            code: row.code,
            name: row.name,
            university_id: Number(row.university_id),
          }));
        }),
    });
  }),
);
