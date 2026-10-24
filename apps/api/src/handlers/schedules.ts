import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import { ClaustrumApi } from "../api/index";
import {
  CurrentUser,
  SaveScheduleBadRequest,
  SaveScheduleFailed,
  ScheduleNotFound,
  Unauthorized,
} from "../domain/Schedules";
import { Database } from "../services/Database";

export const schedulesHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "schedules",
  Effect.fn(function* (handlers) {
    const sql = yield* Database;

    return handlers.handleAll({
      courses: ({ query }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          const userId = Option.isSome(userOpt) && userOpt.value ? userOpt.value.id : null;
          const includeOtherCampuses = query.otherCampuses === "true";
          const showAllCourses = userId ? query.showAll !== "false" : true;

          const res = yield* sql
            .unsafe<{
              offering_id: string | number;
              course_id: string | number;
              course_code: string;
              course_name: string;
              credits: string | number;
              weekly_hours: string | number;
              course_type?: string | null;
              academic_unit_id: string | number;
              academic_unit_name: string;
              campus_id: string | number;
              academic_term_id: string | number;
              term_display_name: string;
              groups?: ReadonlyArray<unknown>;
              level_number?: string | number | null;
              level_label?: string | null;
              sort_order?: string | number | null;
            }>("SELECT * FROM public.get_schedule_courses($1, $2, $3, $4, $5, $6, $7)", [
              userId,
              query.termId,
              query.campusId,
              query.planId ?? null,
              query.careerId ?? null,
              includeOtherCampuses,
              showAllCourses,
            ])
            .pipe(Effect.orDie);

          return res.map((r) => ({
            offering_id: Number(r.offering_id),
            course_id: Number(r.course_id),
            course_code: r.course_code,
            course_name: r.course_name,
            credits: Number(r.credits),
            weekly_hours: Number(r.weekly_hours),
            course_type: r.course_type ?? null,
            academic_unit_id: Number(r.academic_unit_id),
            academic_unit_name: r.academic_unit_name,
            campus_id: Number(r.campus_id),
            academic_term_id: Number(r.academic_term_id),
            term_display_name: r.term_display_name,
            groups: (r.groups ?? []) as ReadonlyArray<unknown>,
            level_number:
              r.level_number !== null && r.level_number !== undefined
                ? Number(r.level_number)
                : null,
            level_label: r.level_label ?? null,
            sort_order:
              r.sort_order !== null && r.sort_order !== undefined ? Number(r.sort_order) : null,
          }));
        }),

      list: () =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (Option.isNone(userOpt) || !userOpt.value) {
            return yield* new Unauthorized({ error: "Unauthorized" });
          }
          const user = userOpt.value;

          const res = yield* sql
            .unsafe<{
              id: string | number;
              name: string;
              academic_term_id: string | number;
              created_at: string;
              updated_at: string;
            }>(
              `SELECT id, name, academic_term_id, created_at, updated_at
               FROM public.saved_schedule
               WHERE user_id = $1
               ORDER BY updated_at DESC`,
              [user.id],
            )
            .pipe(Effect.orDie);

          return res.map((r) => ({
            id: Number(r.id),
            name: r.name,
            academic_term_id: Number(r.academic_term_id),
            created_at: String(r.created_at),
            updated_at: String(r.updated_at),
          }));
        }),

      create: ({ payload }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (Option.isNone(userOpt) || !userOpt.value) {
            return yield* new Unauthorized({ error: "Unauthorized" });
          }
          const user = userOpt.value;

          const academicTermId = payload.academicTermId ?? payload.termId;
          if (!academicTermId) {
            return yield* new SaveScheduleBadRequest({
              error: "academicTermId or termId is required",
            });
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              name: string;
              academic_term_id: string | number;
              created_at: string;
              updated_at: string;
            }>("SELECT * FROM public.save_user_schedule($1, $2, $3, $4::jsonb)", [
              user.id,
              payload.name,
              academicTermId,
              JSON.stringify(payload.groupLookups),
            ])
            .pipe(Effect.orDie);

          if (res.length === 0) {
            return yield* new SaveScheduleFailed({ error: "Failed to save schedule" });
          }

          const row = res[0];
          return {
            id: Number(row.id),
            name: row.name,
            academic_term_id: Number(row.academic_term_id),
            created_at: String(row.created_at),
            updated_at: String(row.updated_at),
          };
        }),

      getById: ({ params }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (Option.isNone(userOpt) || !userOpt.value) {
            return yield* new Unauthorized({ error: "Unauthorized" });
          }
          const user = userOpt.value;

          const res = yield* sql
            .unsafe<{
              id: string | number;
              name: string;
              academic_term_id: string | number;
              created_at: string;
              updated_at: string;
            }>(
              `SELECT id, name, academic_term_id, created_at, updated_at
               FROM public.saved_schedule
               WHERE id = $1 AND user_id = $2`,
              [params.id, user.id],
            )
            .pipe(Effect.orDie);

          if (res.length === 0) {
            return yield* new ScheduleNotFound({ error: "Schedule not found" });
          }

          const row = res[0];
          return {
            id: Number(row.id),
            name: row.name,
            academic_term_id: Number(row.academic_term_id),
            created_at: String(row.created_at),
            updated_at: String(row.updated_at),
          };
        }),

      getItems: ({ params }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (Option.isNone(userOpt) || !userOpt.value) {
            return yield* new Unauthorized({ error: "Unauthorized" });
          }
          const user = userOpt.value;

          const scheduleRes = yield* sql
            .unsafe<{ id: string | number }>(
              "SELECT id FROM public.saved_schedule WHERE id = $1 AND user_id = $2",
              [params.id, user.id],
            )
            .pipe(Effect.orDie);

          if (scheduleRes.length === 0) {
            return yield* new ScheduleNotFound({ error: "Schedule not found" });
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              saved_schedule_id: string | number;
              course_offering_group_id: string | number;
              course_code: string;
              campus_id?: string | number | null;
              group_code: string;
            }>(
              `SELECT
                 ssi.id,
                 ssi.saved_schedule_id,
                 ssi.course_offering_group_id,
                 c.code AS course_code,
                 co.campus_id,
                 cog.group_code::text AS group_code
               FROM public.saved_schedule_item ssi
               JOIN public.course_offering_group cog ON cog.id = ssi.course_offering_group_id
               JOIN public.course_offering co ON co.id = cog.course_offering_id
               JOIN public.course c ON c.id = co.course_id
               WHERE ssi.saved_schedule_id = $1
               ORDER BY ssi.id ASC`,
              [params.id],
            )
            .pipe(Effect.orDie);

          return res.map((r) => ({
            id: Number(r.id),
            saved_schedule_id: Number(r.saved_schedule_id),
            course_offering_group_id: Number(r.course_offering_group_id),
            course_code: r.course_code,
            campus_id:
              r.campus_id !== null && r.campus_id !== undefined ? Number(r.campus_id) : null,
            group_code: r.group_code,
          }));
        }),

      delete: ({ params }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (Option.isNone(userOpt) || !userOpt.value) {
            return yield* new Unauthorized({ error: "Unauthorized" });
          }
          const user = userOpt.value;

          const res = yield* sql
            .unsafe<{ id: string | number }>(
              "DELETE FROM public.saved_schedule WHERE id = $1 AND user_id = $2 RETURNING id",
              [params.id, user.id],
            )
            .pipe(Effect.orDie);

          if (res.length === 0) {
            return yield* new ScheduleNotFound({ error: "Schedule not found" });
          }

          return { success: true };
        }),
    });
  }),
);
