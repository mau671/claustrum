import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as Option from "effect/Option";

import type { ReportDetail, ReportItem } from "../domain/Reports";

import { ClaustrumApi } from "../api/index";
import {
  checkAuth,
  checkRole,
  CurrentUser,
  InternalServerError,
  NotFoundError,
} from "../domain/Users";
import { toIsoString } from "../lib/date";
import { Database } from "../services/Database";

interface ReportDbRow {
  readonly report_id: number | string;
  readonly review_id: number | string;
  readonly reason: string;
  readonly description: string | null;
  readonly status: string;
  readonly created_at: unknown;
  readonly professor_id: number | string;
  readonly professor_name: string;
  readonly course_code: string | null;
  readonly course_name: string | null;
  readonly comment: string | null;
  readonly total_count: number | string;
}

interface ReportDetailDbRow {
  readonly report_id: number | string;
  readonly review_id: number | string;
  readonly reason: string;
  readonly description: string | null;
  readonly status: string;
  readonly resolution_note: string | null;
  readonly created_at: unknown;
  readonly resolved_at: unknown;
  readonly professor_id: number | string;
  readonly professor_name: string;
  readonly course_code: string | null;
  readonly course_name: string | null;
  readonly comment: string | null;
}

export const ReportsHandlers = HttpApiBuilder.group(ClaustrumApi, "reports", (handlers) =>
  Effect.gen(function* () {
    const sql = (yield* Database) as unknown as PgClient.PgClient;

    return handlers
      .handle("list", ({ query }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const status = query.status ?? "pending";
          const limit = query.limit ?? 20;
          const offset = query.offset ?? 0;

          const rows = yield* sql<ReportDbRow>`
            WITH filtered AS (
              SELECT r.*
              FROM public.professor_review_report r
              WHERE r.status = ${status}
            ),
            review_courses AS (
              SELECT
                prc.review_id,
                string_agg(c.code, ', ' ORDER BY c.code, c.name, c.id) AS course_code,
                string_agg(c.name, ', ' ORDER BY c.code, c.name, c.id) AS course_name
              FROM public.professor_review_course prc
              JOIN public.course c ON c.id = prc.course_id
              GROUP BY prc.review_id
            )
            SELECT
              r.id AS report_id,
              pr.id AS review_id,
              r.reason,
              r.description,
              r.status,
              r.created_at,
              p.id AS professor_id,
              p.full_name AS professor_name,
              rc.course_code,
              rc.course_name,
              pr.comment,
              COUNT(*) OVER ()::bigint AS total_count
            FROM filtered r
            JOIN public.professor_review pr ON pr.id = r.review_id
            JOIN public.professor p ON p.id = pr.professor_id
            LEFT JOIN review_courses rc ON rc.review_id = pr.id
            ORDER BY r.created_at DESC
            LIMIT ${limit} OFFSET ${offset}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: ReportItem[] = rows.map((r) => ({
            report_id: Number(r.report_id),
            review_id: Number(r.review_id),
            reason: r.reason,
            description: r.description ?? null,
            status: r.status,
            created_at: toIsoString(r.created_at) ?? "",
            professor_id: String(r.professor_id),
            professor_name: r.professor_name,
            course_code: r.course_code ?? "",
            course_name: r.course_name ?? "",
            comment: r.comment ?? null,
            total_count: Number(r.total_count ?? 0),
          }));

          return mapped;
        }),
      )
      .handle("getById", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const rows = yield* sql<ReportDetailDbRow>`
            WITH review_courses AS (
              SELECT
                prc.review_id,
                string_agg(c.code, ', ' ORDER BY c.code, c.name, c.id) AS course_code,
                string_agg(c.name, ', ' ORDER BY c.code, c.name, c.id) AS course_name
              FROM public.professor_review_course prc
              JOIN public.course c ON c.id = prc.course_id
              GROUP BY prc.review_id
            )
            SELECT
              r.id AS report_id,
              r.review_id,
              r.reason,
              r.description,
              r.status,
              r.resolution_note,
              r.created_at,
              r.resolved_at,
              p.id AS professor_id,
              p.full_name AS professor_name,
              rc.course_code,
              rc.course_name,
              pr.comment
            FROM public.professor_review_report r
            JOIN public.professor_review pr ON pr.id = r.review_id
            JOIN public.professor p ON p.id = pr.professor_id
            LEFT JOIN review_courses rc ON rc.review_id = pr.id
            WHERE r.id = ${params.id}
          `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({ error: "Report not found" });
          }

          const r = rows[0];
          const detail: ReportDetail = {
            report_id: Number(r.report_id),
            review_id: Number(r.review_id),
            reason: r.reason,
            description: r.description ?? null,
            status: r.status,
            resolution_note: r.resolution_note ?? null,
            created_at: toIsoString(r.created_at) ?? "",
            resolved_at: toIsoString(r.resolved_at),
            professor_id: String(r.professor_id),
            professor_name: r.professor_name,
            course_code: r.course_code ?? "",
            course_name: r.course_name ?? "",
            comment: r.comment ?? null,
          };

          return detail;
        }),
      )
      .handle("moderate", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const resolutionNote = payload.note?.trim() || null;

          yield* sql
            .withTransaction(
              Effect.gen(function* () {
                const reportRes = yield* sql<{ review_id: number | string }>`
                UPDATE public.professor_review_report
                SET status = ${payload.status},
                    resolution_note = ${resolutionNote},
                    resolved_by = ${user.id},
                    resolved_at = NOW(),
                    updated_at = NOW()
                WHERE id = ${params.id}
                RETURNING review_id
              `;

                if (reportRes.length === 0) {
                  return yield* Effect.fail(new NotFoundError({ error: "Report not found" }));
                }

                const reviewId = reportRes[0].review_id;

                if (payload.status === "resolved" || payload.rejectReview === true) {
                  yield* sql`
                  UPDATE public.professor_review
                  SET status = 'rejected',
                      moderation_note = COALESCE(${resolutionNote}, 'Rechazado automáticamente al resolver un reporte.'),
                      reviewed_by = ${user.id},
                      reviewed_at = NOW(),
                      updated_at = NOW()
                  WHERE id = ${reviewId} AND status != 'rejected'
                `;
                }
              }),
            )
            .pipe(
              Effect.mapError((e) => {
                if (e._tag === "NotFoundError") {
                  return e;
                }
                return new InternalServerError({
                  error: `Transaction failed: ${e.message}`,
                });
              }),
            );

          return { success: true };
        }),
      );
  }),
);
