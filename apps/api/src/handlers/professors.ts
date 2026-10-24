import type { SqlClient } from "effect/sql";

import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import { ClaustrumApi } from "../api/index";
import { ProfessorNotFound } from "../domain/Professors";
import { toIsoString } from "../lib/date";
import { Database } from "../services/Database";

interface RawProfessorSearchRow {
  professor_id: string;
  professor_name: string;
  approved_review_count: number | string;
  average_overall_score: number | string | null;
  average_ease_score: number | string | null;
  average_quality_score: number | string | null;
  average_clarity_score: number | string | null;
  courses_reviewed_count: number | string;
  last_approved_review_at: string | null;
  search_rank: number | string | null;
  academic_unit: string | null;
  total_count: number | string;
}

interface RawProfessorDetailRow {
  id: number | string;
  full_name: string;
}

interface RawProfessorSummaryRow {
  professor_id?: string;
  approved_review_count?: number | string | null;
  average_overall_score?: number | string | null;
  average_ease_score?: number | string | null;
  average_quality_score?: number | string | null;
  average_clarity_score?: number | string | null;
  average_fairness_score?: number | string | null;
  would_take_again_percentage?: number | string | null;
  tag_counts?: unknown;
}

interface RawProfessorCourseRow {
  id: number | string;
  code: string;
  name: string;
}

interface RawProfessorTermRow {
  id: number | string;
  academic_modality_id: number | string;
  year: number | string;
  period_number: number | string;
  external_key: string;
  display_name: string;
  starts_on: string | null;
  ends_on: string | null;
}

interface RawProfessorHistoryRow {
  term_id: number | string;
  year: number | string;
  period_number: number | string;
  term_display_name: string;
  modality_name: string | null;
  course_id: number | string;
  course_code: string;
  course_name: string;
  group_id: number | string;
  group_code: string | null;
}

export const ProfessorsApiHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "professors",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient.SqlClient;

    return handlers.handleAll({
      search: ({ query }) =>
        Effect.gen(function* () {
          const searchQuery = (query.query ?? query.search)?.trim() || null;
          const rows = yield* sql
            .unsafe<RawProfessorSearchRow>(
              `SELECT * FROM public.search_professor_review_stats(
               $1, $2, $3, $4, $5, $6, $7, $8, $9
             )`,
              [
                searchQuery,
                query.minAverageScore ?? null,
                query.minReviewCount ?? 0,
                query.academicUnitId ?? null,
                query.onlyWithApprovedReviews === "true" || query.onlyWithApprovedReviews === true,
                query.sortBy ?? "reviews",
                query.sortDesc === "true" ||
                  query.sortDesc === true ||
                  query.sortDesc === undefined,
                query.limit ?? 25,
                query.offset ?? 0,
              ],
            )
            .pipe(Effect.orDie);

          return rows.map((r) => ({
            professor_id: String(r.professor_id),
            professor_name: r.professor_name,
            approved_review_count: Number(r.approved_review_count),
            average_overall_score:
              r.average_overall_score !== null ? Number(r.average_overall_score) : null,
            average_ease_score: r.average_ease_score !== null ? Number(r.average_ease_score) : null,
            average_quality_score:
              r.average_quality_score !== null ? Number(r.average_quality_score) : null,
            average_clarity_score:
              r.average_clarity_score !== null ? Number(r.average_clarity_score) : null,
            courses_reviewed_count: Number(r.courses_reviewed_count),
            last_approved_review_at: toIsoString(r.last_approved_review_at),
            search_rank: r.search_rank !== null ? Number(r.search_rank) : null,
            academic_unit: r.academic_unit ?? null,
            total_count: Number(r.total_count),
          }));
        }),

      getById: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawProfessorDetailRow>(
              "SELECT id, full_name FROM public.professor WHERE id::text = $1",
              [params.id],
            )
            .pipe(Effect.orDie);

          if (rows.length === 0) {
            return yield* Effect.fail(new ProfessorNotFound({ error: "Professor not found" }));
          }

          const row = rows[0];
          return {
            id: Number(row.id),
            full_name: row.full_name,
          };
        }),

      getSummary: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawProfessorSummaryRow>(
              "SELECT * FROM public.get_professor_review_summary($1)",
              [params.id],
            )
            .pipe(Effect.orDie);

          if (rows.length === 0) {
            return {
              professor_id: params.id,
              approved_review_count: 0,
              average_overall_score: null,
              average_ease_score: null,
              average_quality_score: null,
              average_clarity_score: null,
              average_fairness_score: null,
              would_take_again_percentage: null,
              tag_counts: [],
            };
          }

          const r = rows[0];
          return {
            professor_id: r.professor_id ?? params.id,
            approved_review_count: Number(r.approved_review_count ?? 0),
            average_overall_score:
              r.average_overall_score !== null ? Number(r.average_overall_score) : null,
            average_ease_score: r.average_ease_score !== null ? Number(r.average_ease_score) : null,
            average_quality_score:
              r.average_quality_score !== null ? Number(r.average_quality_score) : null,
            average_clarity_score:
              r.average_clarity_score !== null ? Number(r.average_clarity_score) : null,
            average_fairness_score:
              r.average_fairness_score !== null ? Number(r.average_fairness_score) : null,
            would_take_again_percentage:
              r.would_take_again_percentage !== null ? Number(r.would_take_again_percentage) : null,
            tag_counts: r.tag_counts ?? [],
          };
        }),

      getCourses: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawProfessorCourseRow>(
              "SELECT * FROM public.get_professor_review_courses($1)",
              [params.id],
            )
            .pipe(Effect.orDie);

          return rows.map((r) => ({
            id: Number(r.id),
            code: r.code,
            name: r.name,
          }));
        }),

      getTerms: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawProfessorTermRow>("SELECT * FROM public.get_professor_offering_terms($1)", [
              params.id,
            ])
            .pipe(Effect.orDie);

          return rows.map((r) => ({
            id: Number(r.id),
            academic_modality_id: Number(r.academic_modality_id),
            year: Number(r.year),
            period_number: Number(r.period_number),
            external_key: r.external_key,
            display_name: r.display_name,
            starts_on: toIsoString(r.starts_on),
            ends_on: toIsoString(r.ends_on),
          }));
        }),

      getHistory: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawProfessorHistoryRow>(
              `SELECT
               at.id AS term_id,
               at.year,
               at.period_number,
               at.display_name AS term_display_name,
               am.name AS modality_name,
               c.id AS course_id,
               c.code AS course_code,
               c.name AS course_name,
               cog.id AS group_id,
               cog.group_code::text AS group_code
             FROM public.course_offering_group_professor cogp
             JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
             JOIN public.course_offering co ON co.id = cog.course_offering_id
             JOIN public.course c ON c.id = co.course_id
             JOIN public.academic_term at ON at.id = co.academic_term_id
             LEFT JOIN public.academic_modality am ON am.id = at.academic_modality_id
             WHERE cogp.professor_id::text = $1
               AND co.is_active = TRUE
               AND (cog.is_active IS NULL OR cog.is_active = TRUE)
             ORDER BY at.year DESC, at.period_number DESC, at.id DESC, c.code ASC, cog.group_code ASC`,
              [params.id],
            )
            .pipe(Effect.orDie);

          const termMap = new Map<
            number,
            {
              term_id: number;
              year: number;
              period_number: number;
              term_display_name: string;
              modality_name: string | null;
              courses: Map<
                number,
                {
                  id: number;
                  code: string;
                  name: string;
                  groups: string[];
                }
              >;
            }
          >();

          for (const r of rows) {
            const termId = Number(r.term_id);
            let termEntry = termMap.get(termId);
            if (!termEntry) {
              termEntry = {
                term_id: termId,
                year: Number(r.year),
                period_number: Number(r.period_number),
                term_display_name: r.term_display_name,
                modality_name: r.modality_name ?? null,
                courses: new Map(),
              };
              termMap.set(termId, termEntry);
            }

            const courseId = Number(r.course_id);
            let courseEntry = termEntry.courses.get(courseId);
            if (!courseEntry) {
              courseEntry = {
                id: courseId,
                code: r.course_code,
                name: r.course_name,
                groups: [],
              };
              termEntry.courses.set(courseId, courseEntry);
            }

            if (r.group_code && !courseEntry.groups.includes(r.group_code)) {
              courseEntry.groups.push(r.group_code);
            }
          }

          return Array.from(termMap.values()).map((term) => ({
            term_id: term.term_id,
            year: term.year,
            period_number: term.period_number,
            term_display_name: term.term_display_name,
            modality_name: term.modality_name,
            courses: Array.from(term.courses.values()),
          }));
        }),
    });
  }),
);
