import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import type {
  ModerationCourseItem,
  ModerationEvaluationItem,
  ModerationReviewItem,
} from "../domain/Moderation";

import { ClaustrumApi } from "../api/index";
import { checkAuth, checkRole, CurrentUser, InternalServerError } from "../domain/Users";
import { toIsoString } from "../lib/date";
import { Database } from "../services/Database";

interface ModerationCountsSummaryRow {
  readonly pending_reviews: number | string;
  readonly pending_evaluations: number | string;
  readonly pending_reports: number | string;
  readonly pending_feedback: number | string;
}

interface ModerationReviewDbRow {
  readonly review_id: number | string;
  readonly professor_id: number | string;
  readonly professor_name: string;
  readonly courses: unknown;
  readonly comment: string | null;
  readonly ease_score: number | string;
  readonly quality_score: number | string;
  readonly clarity_score: number | string;
  readonly fairness_score: number | string;
  readonly attendance_required: boolean | null;
  readonly grade_received: string | null;
  readonly engagement_level: string | null;
  readonly tags: unknown;
  readonly status: string;
  readonly created_at: unknown;
  readonly reviewed_at: unknown;
  readonly moderation_note: string | null;
  readonly total_count: number | string;
}

interface ModerationEvaluationDbRow {
  readonly id: number | string;
  readonly course_id: number | string;
  readonly course_code: string;
  readonly course_name: string;
  readonly academic_term_id: number | string | null;
  readonly term_display_name: string | null;
  readonly professor_id: number | string | null;
  readonly professor_name: string | null;
  readonly evaluation_type: string;
  readonly evaluation_number: number | string | null;
  readonly custom_name: string | null;
  readonly is_catedra: boolean;
  readonly includes_answers: boolean;
  readonly has_separate_answers: boolean;
  readonly file_key: string;
  readonly file_size: number | string;
  readonly answers_file_key: string | null;
  readonly status: string;
  readonly moderation_note: string | null;
  readonly created_at: unknown;
  readonly total_count: number | string;
}

export const ModerationHandlers = HttpApiBuilder.group(ClaustrumApi, "moderation", (handlers) =>
  Effect.gen(function* () {
    const sql = (yield* Database) as unknown as PgClient.PgClient;

    return handlers
      .handle("counts", () =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const rows = yield* sql<ModerationCountsSummaryRow>`
            SELECT
              (SELECT COUNT(*)::bigint FROM public.professor_review WHERE status = 'pending') AS pending_reviews,
              (SELECT COUNT(*)::bigint FROM public.course_evaluations WHERE status = 'pending') AS pending_evaluations,
              (SELECT COUNT(*)::bigint FROM public.professor_review_report WHERE status = 'pending') AS pending_reports,
              (SELECT COUNT(*)::bigint FROM public.user_feedback WHERE is_reviewed = false) AS pending_feedback
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const row = rows[0];
          const pendingReviews = Number(row?.pending_reviews ?? 0);
          const pendingEvaluations = Number(row?.pending_evaluations ?? 0);
          const pendingReports = Number(row?.pending_reports ?? 0);
          const pendingFeedback = Number(row?.pending_feedback ?? 0);

          return {
            pendingReviews,
            pendingEvaluations,
            pendingReports,
            pendingFeedback,
            feedback: pendingFeedback,
            total_count: pendingFeedback,
            data: {
              pendingReviews,
              pendingEvaluations,
              pendingReports,
              pendingFeedback,
            },
          };
        }),
      )
      .handle("reviews", ({ query }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const statusFilter = query.status && query.status !== "all" ? query.status : null;

          const limit = query.limit ?? 50;
          const offset = query.offset ?? 0;

          const rows = yield* sql<ModerationReviewDbRow>`
              WITH review_courses AS (
                SELECT
                  prc.review_id,
                  jsonb_agg(
                    jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
                    ORDER BY c.code, c.name, c.id
                  ) AS courses
                FROM public.professor_review_course prc
                JOIN public.course c ON c.id = prc.course_id
                GROUP BY prc.review_id
              )
              SELECT
                pr.id AS review_id,
                pr.professor_id,
                p.full_name AS professor_name,
                COALESCE(rc.courses, '[]'::jsonb) AS courses,
                pr.comment,
                pr.ease_score,
                pr.quality_score,
                pr.clarity_score,
                pr.fairness_score,
                pr.attendance_required,
                pr.grade_received,
                pr.engagement_level,
                pr.tags,
                pr.status,
                pr.created_at,
                pr.reviewed_at,
                pr.moderation_note,
                COUNT(*) OVER ()::BIGINT AS total_count
              FROM public.professor_review pr
              JOIN public.professor p ON p.id = pr.professor_id
              LEFT JOIN review_courses rc ON rc.review_id = pr.id
              WHERE (${statusFilter}::text IS NULL OR pr.status::text = ${statusFilter})
              ORDER BY pr.created_at DESC, pr.id DESC
              LIMIT ${limit} OFFSET ${offset}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: ModerationReviewItem[] = rows.map((r) => {
            const rawCourses = Array.isArray(r.courses) ? r.courses : [];
            const courses: ModerationCourseItem[] = rawCourses.map((c: unknown) => {
              const item = c as Record<string, unknown>;
              return {
                id: Number(item.id),
                code: typeof item.code === "string" ? item.code : "",
                name: typeof item.name === "string" ? item.name : "",
              };
            });

            const rawTags = Array.isArray(r.tags) ? r.tags : [];
            const tags = rawTags.map(String);

            return {
              review_id: Number(r.review_id),
              professor_id: Number(r.professor_id),
              professor_name: r.professor_name,
              courses,
              comment: r.comment ?? null,
              ease_score: Number(r.ease_score),
              quality_score: Number(r.quality_score),
              clarity_score: Number(r.clarity_score),
              fairness_score: Number(r.fairness_score),
              attendance_required:
                r.attendance_required !== null ? Boolean(r.attendance_required) : null,
              grade_received: r.grade_received ?? null,
              engagement_level:
                r.engagement_level !== null && r.engagement_level !== undefined
                  ? Number(r.engagement_level)
                  : null,
              tags,
              status: r.status,
              created_at: toIsoString(r.created_at) ?? "",
              reviewed_at: toIsoString(r.reviewed_at),
              moderation_note: r.moderation_note ?? null,
              total_count: Number(r.total_count ?? 0),
            };
          });

          return mapped;
        }),
      )
      .handle("evaluations", ({ query }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const status = query.status ?? "pending";
          const limit = query.limit ?? 50;
          const offset = query.offset ?? 0;

          const rows = yield* sql<ModerationEvaluationDbRow>`
              SELECT
                e.id,
                e.course_id,
                c.code AS course_code,
                c.name AS course_name,
                e.academic_term_id,
                at.display_name AS term_display_name,
                e.professor_id,
                p.full_name AS professor_name,
                e.evaluation_type::TEXT,
                e.evaluation_number,
                e.custom_name,
                e.is_catedra,
                e.includes_answers,
                e.has_separate_answers,
                e.file_key,
                e.file_size,
                e.answers_file_key,
                e.status::TEXT,
                e.moderation_note,
                e.created_at,
                COUNT(*) OVER ()::BIGINT AS total_count
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.status = ${status}
              ORDER BY e.created_at DESC, e.id DESC
              LIMIT ${limit} OFFSET ${offset}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: ModerationEvaluationItem[] = rows.map((r) => ({
            id: Number(r.id),
            course_id: Number(r.course_id),
            course_code: r.course_code,
            course_name: r.course_name,
            academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
            term_display_name: r.term_display_name ?? null,
            professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
            professor_name: r.professor_name ?? null,
            evaluation_type: r.evaluation_type,
            evaluation_number: r.evaluation_number !== null ? Number(r.evaluation_number) : null,
            custom_name: r.custom_name ?? null,
            is_catedra: Boolean(r.is_catedra),
            includes_answers: Boolean(r.includes_answers),
            has_separate_answers: Boolean(r.has_separate_answers),
            file_key: r.file_key,
            file_size: Number(r.file_size),
            answers_file_key: r.answers_file_key ?? null,
            status: r.status,
            moderation_note: r.moderation_note ?? null,
            created_at: toIsoString(r.created_at) ?? "",
            total_count: Number(r.total_count ?? 0),
          }));

          return mapped;
        }),
      );
  }),
);
