import { Effect } from "effect";
import { HttpServerRequest } from "effect/http";
import { HttpApiBuilder } from "effect/http-api";

import type { SqlClient } from "../services/Database";

import { ClaustrumApi } from "../api/index";
import { CurrentUser } from "../domain/Auth";
import {
  ApiEnv,
  type CreateReviewResponse,
  type ListReviewsQuery,
  type ModerateReviewResponse,
  type PublicReviewItem,
  type ReviewDetail,
  type ReviewReactionResponse,
  type ReviewReportResponse,
  ReviewBadRequest,
  ReviewForbidden,
  ReviewInternalServerError,
  ReviewNotFound,
  ReviewUnauthorized,
  type SuccessResponse,
} from "../domain/Reviews";
import { toIsoString } from "../lib/date";
import { verifyTurnstileToken } from "../lib/security";
import { Database } from "../services/Database";

function isRealProfessorName(fullName: string): boolean {
  const name = fullName.trim();
  if (name.length < 2) return false;
  if (/^(\?|\.|\s)+$/.test(name)) return false;
  if (/profesor|profesora|docente|por designar|sin asignar|staff/i.test(name)) return false;
  return true;
}

interface RawReviewRow {
  review_id: number | string;
  professor_id: string;
  courses: unknown;
  comment: string;
  ease_score: number | string;
  quality_score: number | string;
  clarity_score: number | string;
  fairness_score: number | string;
  attendance_required: boolean;
  grade_received: string | null;
  engagement_level: number;
  tags: string[] | null;
  status: string;
  created_at: unknown;
  like_count: number | string | null;
  dislike_count: number | string | null;
  my_reaction: "like" | "dislike" | null;
  total_count: number | string | null;
}

interface RawReviewDetailRow extends RawReviewRow {
  professor_name: string;
  reviewed_at: unknown | null;
  moderation_note: string | null;
}

export const ReviewsApiHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "reviews",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    return handlers.handleAll({
      list: ({ query }: { query: ListReviewsQuery }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          const user = userOpt._tag === "Some" ? userOpt.value : undefined;

          if (user?.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          const rows = yield* sql
            .unsafe<RawReviewRow>(
              "SELECT * FROM public.get_professor_reviews_public($1, $2, $3, $4)",
              [query.professorId, query.limit, query.offset, user?.id ?? null],
            )
            .pipe(Effect.orDie);

          return (rows as readonly RawReviewRow[]).map((r: RawReviewRow): PublicReviewItem => ({
            review_id: Number(r.review_id),
            professor_id: r.professor_id,
            courses: r.courses ?? [],
            comment: r.comment,
            ease_score:
              r.ease_score !== null && r.ease_score !== undefined ? Number(r.ease_score) : null,
            quality_score:
              r.quality_score !== null && r.quality_score !== undefined
                ? Number(r.quality_score)
                : null,
            clarity_score:
              r.clarity_score !== null && r.clarity_score !== undefined
                ? Number(r.clarity_score)
                : null,
            fairness_score:
              r.fairness_score !== null && r.fairness_score !== undefined
                ? Number(r.fairness_score)
                : null,
            attendance_required:
              r.attendance_required !== null && r.attendance_required !== undefined
                ? Boolean(r.attendance_required)
                : null,
            grade_received: r.grade_received,
            engagement_level:
              r.engagement_level !== null && r.engagement_level !== undefined
                ? Number(r.engagement_level)
                : null,
            tags: r.tags ?? [],
            status: r.status,
            created_at: toIsoString(r.created_at) ?? "",
            like_count: Number(r.like_count ?? 0),
            dislike_count: Number(r.dislike_count ?? 0),
            my_reaction: r.my_reaction ?? null,
            total_count: Number(r.total_count ?? 0),
          }));
        }),

      create: ({ payload }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (userOpt._tag === "None" || !userOpt.value) {
            return yield* Effect.fail(new ReviewUnauthorized({ error: "No autorizado" }));
          }
          const user = userOpt.value;
          if (user.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          const envOpt = yield* Effect.serviceOption(ApiEnv);
          if (envOpt._tag === "None" || !envOpt.value.TURNSTILE_SECRET_KEY) {
            return yield* Effect.fail(
              new ReviewInternalServerError({
                error: "Missing Turnstile secret configuration",
              }),
            );
          }

          const reqOpt = yield* Effect.serviceOption(HttpServerRequest.HttpServerRequest);
          const remoteIp =
            reqOpt._tag === "Some" ? (reqOpt.value.headers["cf-connecting-ip"] ?? null) : null;

          const isHuman = yield* Effect.tryPromise({
            try: () => verifyTurnstileToken(payload.turnstileToken, envOpt.value, remoteIp),
            catch: () => new ReviewBadRequest({ error: "Invalid anti-spam token" }),
          });

          if (!isHuman) {
            return yield* Effect.fail(new ReviewBadRequest({ error: "Invalid anti-spam token" }));
          }

          return yield* sql
            .withTransaction(
              Effect.gen(function* () {
                const courses = yield* sql.unsafe<{ id: number; code: string }>(
                  "SELECT id, code FROM public.course WHERE code = ANY($1::text[])",
                  [payload.courseCodes],
                );
                if (courses.length !== payload.courseCodes.length) {
                  return yield* Effect.fail(
                    new ReviewBadRequest({
                      error: "One or more course codes do not exist",
                    }),
                  );
                }

                const profRows = yield* sql.unsafe<{ id: string; full_name: string }>(
                  "SELECT id, full_name FROM public.professor WHERE id::text = $1",
                  [payload.professorId],
                );
                if (profRows.length === 0) {
                  return yield* Effect.fail(
                    new ReviewBadRequest({ error: "Professor does not exist" }),
                  );
                }

                const professor = profRows[0];
                if (!isRealProfessorName(professor.full_name)) {
                  return yield* Effect.fail(
                    new ReviewBadRequest({
                      error: "Professor is not eligible for reviews",
                    }),
                  );
                }

                if (payload.academicTermId) {
                  const termCheckRows = yield* sql.unsafe<{ "?column?": number }>(
                    `SELECT 1
                     FROM public.course_offering_group_professor cogp
                     JOIN public.course_offering_group cog ON cog.id = cogp.course_offering_group_id
                     JOIN public.course_offering co ON co.id = cog.course_offering_id
                     WHERE cogp.professor_id::text = $1
                       AND co.academic_term_id = $2
                     LIMIT 1`,
                    [payload.professorId, payload.academicTermId],
                  );
                  if (termCheckRows.length === 0) {
                    return yield* Effect.fail(
                      new ReviewBadRequest({
                        error: "Professor has no offering records for that academic term",
                      }),
                    );
                  }
                }

                const insertRes = yield* sql.unsafe<{
                  id: number | string;
                  status: string;
                  created_at: unknown;
                }>(
                  `INSERT INTO public.professor_review (
                     professor_id, academic_term_id, comment, ease_score, quality_score,
                     clarity_score, fairness_score, attendance_required, grade_received,
                     engagement_level, tags, status
                   ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 'pending')
                   RETURNING id, status, created_at`,
                  [
                    payload.professorId,
                    payload.academicTermId ?? null,
                    payload.comment,
                    payload.easeScore,
                    payload.qualityScore,
                    payload.clarityScore,
                    payload.fairnessScore,
                    payload.attendanceRequired,
                    payload.gradeReceived ?? null,
                    payload.engagementLevel,
                    payload.tags,
                  ],
                );

                const insertedReview = insertRes[0];

                for (const course of courses) {
                  yield* sql.unsafe(
                    "INSERT INTO public.professor_review_course (review_id, course_id) VALUES ($1, $2)",
                    [insertedReview.id, course.id],
                  );
                }

                return {
                  success: true,
                  review: {
                    id: Number(insertedReview.id),
                    status: insertedReview.status,
                    created_at: toIsoString(insertedReview.created_at) ?? "",
                  },
                } satisfies CreateReviewResponse;
              }),
            )
            .pipe(Effect.orDie);
        }),

      getById: ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql
            .unsafe<RawReviewDetailRow>(
              `WITH review_courses AS (
                 SELECT
                   prc.review_id,
                   jsonb_agg(
                     jsonb_build_object('id', c.id, 'code', c.code, 'name', c.name)
                     ORDER BY c.code, c.name, c.id
                   ) AS courses
                 FROM public.professor_review_course prc
                 JOIN public.course c ON c.id = prc.course_id
                 WHERE prc.review_id = $1
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
                 pr.moderation_note
               FROM public.professor_review pr
               JOIN public.professor p ON p.id = pr.professor_id
               LEFT JOIN review_courses rc ON rc.review_id = pr.id
               WHERE pr.id = $1`,
              [params.id],
            )
            .pipe(Effect.orDie);

          if (rows.length === 0) {
            return yield* Effect.fail(new ReviewNotFound({ error: "Review not found" }));
          }

          const r = rows[0];
          return {
            review_id: Number(r.review_id),
            professor_id: r.professor_id,
            professor_name: r.professor_name,
            courses: r.courses ?? [],
            comment: r.comment,
            ease_score:
              r.ease_score !== null && r.ease_score !== undefined ? Number(r.ease_score) : null,
            quality_score:
              r.quality_score !== null && r.quality_score !== undefined
                ? Number(r.quality_score)
                : null,
            clarity_score:
              r.clarity_score !== null && r.clarity_score !== undefined
                ? Number(r.clarity_score)
                : null,
            fairness_score:
              r.fairness_score !== null && r.fairness_score !== undefined
                ? Number(r.fairness_score)
                : null,
            attendance_required:
              r.attendance_required !== null && r.attendance_required !== undefined
                ? Boolean(r.attendance_required)
                : null,
            grade_received: r.grade_received ?? null,
            engagement_level:
              r.engagement_level !== null && r.engagement_level !== undefined
                ? Number(r.engagement_level)
                : null,
            tags: r.tags ?? [],
            status: r.status,
            created_at: toIsoString(r.created_at) ?? "",
            reviewed_at: toIsoString(r.reviewed_at),
            moderation_note: r.moderation_note ?? null,
          } satisfies ReviewDetail;
        }),

      moderate: ({ params, payload }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (userOpt._tag === "None" || !userOpt.value) {
            return yield* Effect.fail(new ReviewUnauthorized({ error: "No autorizado" }));
          }
          const user = userOpt.value;
          if (user.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          const userRole = user.role ?? "user";
          const userRoles = userRole.split(",").map((r) => r.trim());
          const hasPermission = userRoles.some((r) => ["admin", "moderator"].includes(r));
          if (!hasPermission) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Acceso denegado: permisos insuficientes",
              }),
            );
          }

          const rows = yield* sql
            .unsafe<{ id: number | string; status: string }>(
              `UPDATE public.professor_review
               SET status = $1,
                   moderation_note = $2,
                   reviewed_by = $3,
                   reviewed_at = NOW()
               WHERE id = $4
               RETURNING id, status`,
              [payload.status, payload.reason ?? null, user.id, params.id],
            )
            .pipe(Effect.orDie);

          if (rows.length === 0) {
            return yield* Effect.fail(new ReviewNotFound({ error: "Review not found" }));
          }

          return {
            success: true,
            review: {
              id: Number(rows[0].id),
              status: rows[0].status,
            },
          } satisfies ModerateReviewResponse;
        }),

      remove: ({ params }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (userOpt._tag === "None" || !userOpt.value) {
            return yield* Effect.fail(new ReviewUnauthorized({ error: "No autorizado" }));
          }
          const user = userOpt.value;
          if (user.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          if (user.role !== "admin") {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "No autorizado para eliminar esta reseña",
              }),
            );
          }

          const rows = yield* sql
            .unsafe<{ id: number | string }>(
              "DELETE FROM public.professor_review WHERE id = $1 RETURNING id",
              [params.id],
            )
            .pipe(Effect.orDie);

          if (rows.length === 0) {
            return yield* Effect.fail(new ReviewNotFound({ error: "Review not found" }));
          }

          return { success: true } satisfies SuccessResponse;
        }),

      react: ({ params, payload }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (userOpt._tag === "None" || !userOpt.value) {
            return yield* Effect.fail(new ReviewUnauthorized({ error: "No autorizado" }));
          }
          const user = userOpt.value;
          if (user.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          return yield* sql
            .withTransaction(
              Effect.gen(function* () {
                const reviewRows = yield* sql.unsafe<{ id: number | string }>(
                  "SELECT id FROM public.professor_review WHERE id = $1 AND status = 'approved'",
                  [params.id],
                );

                if (reviewRows.length === 0) {
                  return yield* Effect.fail(new ReviewNotFound({ error: "Review not found" }));
                }

                if (payload.reaction === null) {
                  yield* sql.unsafe(
                    "DELETE FROM public.professor_review_reaction WHERE review_id = $1 AND user_id = $2",
                    [params.id, user.id],
                  );
                } else {
                  yield* sql.unsafe(
                    `INSERT INTO public.professor_review_reaction (review_id, user_id, reaction)
                     VALUES ($1, $2, $3)
                     ON CONFLICT (review_id, user_id)
                     DO UPDATE SET reaction = EXCLUDED.reaction`,
                    [params.id, user.id, payload.reaction],
                  );
                }

                const countsRows = yield* sql.unsafe<{
                  like_count: number | string;
                  dislike_count: number | string;
                }>(
                  `SELECT
                     COUNT(*) FILTER (WHERE reaction = 'like')::bigint AS like_count,
                     COUNT(*) FILTER (WHERE reaction = 'dislike')::bigint AS dislike_count
                   FROM public.professor_review_reaction
                   WHERE review_id = $1`,
                  [params.id],
                );

                const likeCount = Number(countsRows[0]?.like_count ?? 0);
                const dislikeCount = Number(countsRows[0]?.dislike_count ?? 0);

                return {
                  success: true,
                  reaction: payload.reaction,
                  likeCount,
                  dislikeCount,
                } satisfies ReviewReactionResponse;
              }),
            )
            .pipe(Effect.orDie);
        }),

      report: ({ params, payload }) =>
        Effect.gen(function* () {
          const userOpt = yield* Effect.serviceOption(CurrentUser);
          if (userOpt._tag === "None" || !userOpt.value) {
            return yield* Effect.fail(new ReviewUnauthorized({ error: "No autorizado" }));
          }
          const user = userOpt.value;
          if (user.banned) {
            return yield* Effect.fail(
              new ReviewForbidden({
                error: "Cuenta suspendida",
                reason: user.banReason ?? null,
              }),
            );
          }

          if (
            (payload.reason as string) === "otro" &&
            (!payload.description || payload.description.trim().length === 0)
          ) {
            return yield* Effect.fail(
              new ReviewBadRequest({
                error: "Description is required when reason is 'otro'",
              }),
            );
          }

          const envOpt = yield* Effect.serviceOption(ApiEnv);
          if (envOpt._tag === "None" || !envOpt.value.TURNSTILE_SECRET_KEY) {
            return yield* Effect.fail(
              new ReviewInternalServerError({
                error: "Missing Turnstile secret configuration",
              }),
            );
          }

          const reqOpt = yield* Effect.serviceOption(HttpServerRequest.HttpServerRequest);
          const remoteIp =
            reqOpt._tag === "Some" ? (reqOpt.value.headers["cf-connecting-ip"] ?? null) : null;

          const isHuman = yield* Effect.tryPromise({
            try: () => verifyTurnstileToken(payload.turnstileToken, envOpt.value, remoteIp),
            catch: () => new ReviewBadRequest({ error: "Invalid anti-spam token" }),
          });

          if (!isHuman) {
            return yield* Effect.fail(new ReviewBadRequest({ error: "Invalid anti-spam token" }));
          }

          const reviewRows = yield* sql
            .unsafe<{ id: number | string }>(
              "SELECT id FROM public.professor_review WHERE id = $1 AND status = 'approved'",
              [params.id],
            )
            .pipe(Effect.orDie);

          if (reviewRows.length === 0) {
            return yield* Effect.fail(new ReviewNotFound({ error: "Review not found" }));
          }

          const rows = yield* sql
            .unsafe<{
              id: number | string;
              review_id: number | string;
              status: string;
              created_at: unknown;
            }>(
              `INSERT INTO public.professor_review_report (
                 review_id, user_id, reason, description, status
               ) VALUES ($1, $2, $3, $4, 'pending')
               RETURNING id, review_id, status, created_at`,
              [params.id, user.id, payload.reason, payload.description ?? null],
            )
            .pipe(Effect.orDie);

          const createdReport = rows[0];
          return {
            success: true,
            report: {
              id: Number(createdReport.id),
              review_id: Number(createdReport.review_id),
              status: createdReport.status,
              created_at: toIsoString(createdReport.created_at) ?? "",
            },
          } satisfies ReviewReportResponse;
        }),
    });
  }),
);

export const reviewsHandlers = ReviewsApiHandlers;
