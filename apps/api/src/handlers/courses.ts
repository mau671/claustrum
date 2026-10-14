import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import { ClaustrumApi } from "../api/index";
import { CourseNotFound } from "../domain/Courses";
import { Database } from "../services/Database";

export const coursesHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "courses",
  Effect.fn(function* (handlers) {
    const sql = yield* Database;

    return handlers.handleAll({
      list: ({ query }) =>
        Effect.gen(function* () {
          if (query.ids) {
            const parsedIds = query.ids
              .split(",")
              .map((s) => Number(s.trim()))
              .filter((n) => Number.isFinite(n) && n > 0);

            if (parsedIds.length === 0) {
              return [];
            }

            const res = yield* sql
              .unsafe<{
                id: string | number;
                code: string;
                name: string;
              }>(
                "SELECT id, code, name FROM public.course WHERE id = ANY($1::bigint[]) ORDER BY code ASC",
                [parsedIds],
              )
              .pipe(Effect.orDie);

            return res.map((row) => ({
              id: Number(row.id),
              code: row.code,
              name: row.name,
            }));
          }

          if (query.search && query.search.trim() !== "") {
            const term = `%${query.search.trim()}%`;
            const res = yield* sql
              .unsafe<{
                id: string | number;
                code: string;
                name: string;
              }>(
                "SELECT id, code, name FROM public.course WHERE code ILIKE $1 OR name ILIKE $1 ORDER BY code ASC LIMIT 50",
                [term],
              )
              .pipe(Effect.orDie);

            return res.map((row) => ({
              id: Number(row.id),
              code: row.code,
              name: row.name,
            }));
          }

          const res = yield* sql
            .unsafe<{
              id: string | number;
              code: string;
              name: string;
            }>("SELECT id, code, name FROM public.course ORDER BY code ASC LIMIT 50")
            .pipe(Effect.orDie);

          return res.map((row) => ({
            id: Number(row.id),
            code: row.code,
            name: row.name,
          }));
        }),

      getById: ({ params }) =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              id: string | number;
              code: string;
              name: string;
              credits?: string | number | null;
              weekly_hours?: string | number | null;
              created_at: string;
              updated_at: string;
            }>("SELECT * FROM public.course WHERE id = $1", [params.id])
            .pipe(Effect.orDie);

          if (res.length === 0) {
            return yield* new CourseNotFound({ error: "Course not found" });
          }

          const row = res[0];
          return {
            id: Number(row.id),
            code: row.code,
            name: row.name,
            credits: row.credits !== null && row.credits !== undefined ? Number(row.credits) : null,
            weekly_hours:
              row.weekly_hours !== null && row.weekly_hours !== undefined
                ? Number(row.weekly_hours)
                : null,
            created_at: String(row.created_at),
            updated_at: String(row.updated_at),
          };
        }),

      getTerms: ({ params, query }) =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              id: string | number;
              academic_modality_id: string | number;
              year: string | number;
              period_number: string | number;
              external_key: string;
              display_name: string;
              starts_on: string;
              ends_on: string;
            }>("SELECT * FROM public.get_course_offering_terms($1, $2, $3, $4)", [
              params.id,
              query.campusId ?? null,
              query.academicUnitId ?? null,
              query.studyPlanId ?? null,
            ])
            .pipe(Effect.orDie);

          return res.map((r) => ({
            id: Number(r.id),
            academic_modality_id: Number(r.academic_modality_id),
            year: Number(r.year),
            period_number: Number(r.period_number),
            external_key: r.external_key,
            display_name: r.display_name,
            starts_on: String(r.starts_on),
            ends_on: String(r.ends_on),
          }));
        }),

      getGroups: ({ params, query }) =>
        Effect.gen(function* () {
          const res = yield* sql
            .unsafe<{
              academic_term_id: string | number;
              term_display_name: string;
              term_year: string | number;
              term_period_number: string | number;
              source_course_id: string | number;
              source_course_code: string;
              source_course_name: string;
              group_id: string | number;
              group_code: string;
              group_type: string;
              capacity: string | number;
              campus_id?: string | number | null;
              campus_name?: string | null;
              professors?: ReadonlyArray<unknown>;
              meetings?: ReadonlyArray<unknown>;
            }>("SELECT * FROM public.get_course_latest_term_groups($1, $2, $3, $4, $5)", [
              params.id,
              query.campusId ?? null,
              query.academicUnitId ?? null,
              query.academicTermId ?? null,
              query.studyPlanId ?? null,
            ])
            .pipe(Effect.orDie);

          return res.map((r) => ({
            academicTermId: Number(r.academic_term_id),
            termDisplayName: r.term_display_name,
            termYear: Number(r.term_year),
            termPeriodNumber: Number(r.term_period_number),
            sourceCourseId: Number(r.source_course_id),
            sourceCourseCode: r.source_course_code,
            sourceCourseName: r.source_course_name,
            groupId: Number(r.group_id),
            groupCode: r.group_code,
            groupType: r.group_type,
            capacity: Number(r.capacity),
            campusId:
              r.campus_id !== null && r.campus_id !== undefined ? Number(r.campus_id) : null,
            campusName: r.campus_name ?? null,
            professors: (r.professors ?? []) as ReadonlyArray<unknown>,
            meetings: (r.meetings ?? []) as ReadonlyArray<unknown>,
            academic_term_id: Number(r.academic_term_id),
            term_display_name: r.term_display_name,
            term_year: Number(r.term_year),
            term_period_number: Number(r.term_period_number),
            source_course_id: Number(r.source_course_id),
            source_course_code: r.source_course_code,
            source_course_name: r.source_course_name,
            group_id: Number(r.group_id),
            group_code: r.group_code,
            group_type: r.group_type,
            campus_id:
              r.campus_id !== null && r.campus_id !== undefined ? Number(r.campus_id) : null,
            campus_name: r.campus_name ?? null,
          }));
        }),

      getProfessors: ({ params, query }) =>
        Effect.gen(function* () {
          const yearWindow = query.yearWindow ?? 2;
          const res = yield* sql
            .unsafe<{
              professor_id: string | number;
              professor_name: string;
              last_taught_term_id: string | number;
              last_taught_term_name: string;
              last_taught_year: string | number;
              last_taught_period_number: string | number;
              groups_in_last_term_count: string | number;
              terms_taught_count: string | number;
            }>("SELECT * FROM public.get_course_recent_professors($1, $2, $3, $4, $5)", [
              params.id,
              query.campusId ?? null,
              query.academicUnitId ?? null,
              yearWindow,
              query.academicTermId ?? null,
            ])
            .pipe(Effect.orDie);

          return res.map((r) => ({
            professorId: Number(r.professor_id),
            professorName: r.professor_name,
            lastTaughtTermId: Number(r.last_taught_term_id),
            lastTaughtTermName: r.last_taught_term_name,
            lastTaughtYear: Number(r.last_taught_year),
            lastTaughtPeriodNumber: Number(r.last_taught_period_number),
            groupsInLastTermCount: Number(r.groups_in_last_term_count),
            termsTaughtCount: Number(r.terms_taught_count),
            professor_id: Number(r.professor_id),
            professor_name: r.professor_name,
            last_taught_term_id: Number(r.last_taught_term_id),
            last_taught_term_name: r.last_taught_term_name,
            last_taught_year: Number(r.last_taught_year),
            last_taught_period_number: Number(r.last_taught_period_number),
            groups_in_last_term_count: Number(r.groups_in_last_term_count),
            terms_taught_count: Number(r.terms_taught_count),
          }));
        }),

      getEquivalents: ({ params, query }) =>
        Effect.gen(function* () {
          const limit = query.limit ?? 100;
          const offset = query.offset ?? 0;
          const res = yield* sql
            .unsafe<{
              course_id: string | number;
              course_code: string;
              course_name: string;
              course_credits?: string | number | null;
              course_weekly_hours?: string | number | null;
              relation_kind: string;
              is_placeholder?: boolean | null;
              has_offerings?: boolean | null;
              total_equivalents: string | number;
            }>("SELECT * FROM public.get_course_detail_related_courses($1, $2, $3, $4)", [
              query.studyPlanId,
              params.id,
              limit,
              offset,
            ])
            .pipe(Effect.orDie);

          return res.map((r) => ({
            id: Number(r.course_id),
            code: r.course_code,
            name: r.course_name,
            credits:
              r.course_credits !== null && r.course_credits !== undefined
                ? Number(r.course_credits)
                : null,
            weeklyHours:
              r.course_weekly_hours !== null && r.course_weekly_hours !== undefined
                ? Number(r.course_weekly_hours)
                : null,
            relationKind: r.relation_kind,
            isPlaceholder: Boolean(r.is_placeholder),
            hasOfferings: Boolean(r.has_offerings),
            totalEquivalents: Number(r.total_equivalents),
            course_id: Number(r.course_id),
            course_code: r.course_code,
            course_name: r.course_name,
            course_credits:
              r.course_credits !== null && r.course_credits !== undefined
                ? Number(r.course_credits)
                : null,
            course_weekly_hours:
              r.course_weekly_hours !== null && r.course_weekly_hours !== undefined
                ? Number(r.course_weekly_hours)
                : null,
            relation_kind: r.relation_kind,
            is_placeholder: Boolean(r.is_placeholder),
            has_offerings: Boolean(r.has_offerings),
            total_equivalents: Number(r.total_equivalents),
          }));
        }),
    });
  }),
);
