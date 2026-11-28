import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as HttpServerRequest from "effect/http/HttpServerRequest";
import * as HttpServerResponse from "effect/http/HttpServerResponse";
import * as Option from "effect/Option";

import type { Env } from "../types";

import { ClaustrumApi } from "../api/index";
import {
  type EvaluationCourseItem,
  type EvaluationDetail,
  type EvaluationItem,
  type EvaluationSearchRow,
  type EvaluationTermItem,
  formatFileName,
  validateUploadPayload,
} from "../domain/Evaluations";
import {
  BadRequestError,
  checkAuth,
  checkRole,
  CurrentUser,
  ForbiddenError,
  InternalServerError,
  NotFoundError,
  UnauthorizedError,
} from "../domain/Users";
import { toIsoString } from "../lib/date";
import { verifyTurnstileToken } from "../lib/security";
import { Database } from "../services/Database";
import { Storage, type StorageService } from "../services/Storage";

interface EvaluationDbRow {
  readonly id: number | string;
  readonly course_id: number | string;
  readonly course_code: string;
  readonly course_name: string;
  readonly term_id: number | string | null;
  readonly professor_id: number | string | null;
  readonly type: string;
  readonly number: number | string | null;
  readonly name: string | null;
  readonly coordinated: boolean;
  readonly answers_included: boolean;
  readonly answers_separate: boolean;
  readonly file_key: string;
  readonly file_size: number | string;
  readonly answer_file_key: string | null;
  readonly status: string;
  readonly created_at: unknown;
  readonly term_display_name: string | null;
  readonly professor_name: string | null;
  readonly note?: string | null;
  readonly extraordinary: boolean;
  readonly variant: number | string | null;
}

interface EvaluationSearchDbRow extends EvaluationDbRow {
  readonly total_count: number | string;
}

function mapEvaluationRow(r: EvaluationDbRow): EvaluationItem {
  return {
    id: Number(r.id),
    course_id: Number(r.course_id),
    course_code: r.course_code,
    course_name: r.course_name,
    term_id: r.term_id !== null ? Number(r.term_id) : null,
    professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
    type: r.type,
    number: r.number !== null ? Number(r.number) : null,
    name: r.name ?? null,
    coordinated: Boolean(r.coordinated),
    answers_included: Boolean(r.answers_included),
    answers_separate: Boolean(r.answers_separate),
    file_key: r.file_key,
    file_size: Number(r.file_size),
    answer_file_key: r.answer_file_key ?? null,
    status: r.status,
    created_at: toIsoString(r.created_at) ?? "",
    term_display_name: r.term_display_name ?? null,
    professor_name: r.professor_name ?? null,
    extraordinary: Boolean(r.extraordinary),
    variant: r.variant !== null ? Number(r.variant) : null,
  };
}

interface EvaluationFileRow {
  readonly id: number | string;
  readonly status: string;
  readonly file_key: string;
  readonly answer_file_key?: string | null;
  readonly type: string;
  readonly number: number | string | null;
  readonly name: string | null;
  readonly course_code: string;
  readonly extraordinary: boolean;
  readonly variant: number | string | null;
}

function parseNullableNumber(value: unknown): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : Number.NaN;
}

export const EvaluationsHandlers = HttpApiBuilder.group(ClaustrumApi, "evaluations", (handlers) =>
  Effect.gen(function* () {
    const sql = (yield* Database) as unknown as PgClient.PgClient;
    const storage = (yield* Storage) as unknown as StorageService;

    return handlers
      .handle("list", ({ query }) =>
        Effect.gen(function* () {
          const studyPlanId = query.studyPlanId ?? null;

          const rows = yield* sql<EvaluationDbRow>`
              WITH target_courses AS (
                SELECT ${query.courseId}::bigint AS course_id
                UNION
                SELECT rel.course_id
                FROM public.get_course_detail_related_courses(${studyPlanId}::bigint, ${query.courseId}::bigint) rel
                WHERE ${studyPlanId}::bigint IS NOT NULL
              )
              SELECT
                e.id,
                e.course_id,
                c.code AS course_code,
                c.name AS course_name,
                e.term_id,
                e.professor_id,
                e.type::TEXT,
                e.number,
                e.name,
                e.coordinated,
                e.answers_included,
                e.answers_separate,
                e.file_key,
                e.file_size,
                e.answer_file_key,
                e.status::TEXT,
                e.created_at,
                at.display_name AS term_display_name,
                p.full_name AS professor_name,
                e.extraordinary,
                e.variant
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.course_id IN (SELECT course_id FROM target_courses)
                AND e.status = 'approved'
              ORDER BY
                e.type,
                e.number NULLS LAST,
                at.year DESC NULLS LAST,
                at.period_number DESC NULLS LAST,
                e.created_at DESC
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          return rows.map(mapEvaluationRow);
        }),
      )
      .handle("search", ({ query }) =>
        Effect.gen(function* () {
          const term = query.q?.trim() ?? "";
          const pattern = term.length > 0 ? `%${term}%` : null;
          const type = query.type ?? null;
          const limit = Math.min(Math.max(query.limit ?? 25, 1), 50);
          const offset = Math.max(query.offset ?? 0, 0);

          const rows = yield* sql<EvaluationSearchDbRow>`
              SELECT
                e.id,
                e.course_id,
                c.code AS course_code,
                c.name AS course_name,
                e.term_id,
                e.professor_id,
                e.type::TEXT,
                e.number,
                e.name,
                e.coordinated,
                e.answers_included,
                e.answers_separate,
                e.file_key,
                e.file_size,
                e.answer_file_key,
                e.status::TEXT,
                e.created_at,
                at.display_name AS term_display_name,
                p.full_name AS professor_name,
                e.extraordinary,
                e.variant,
                COUNT(*) OVER () AS total_count
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.status = 'approved'
                AND (${pattern}::text IS NULL OR
                     c.code ILIKE ${pattern} OR
                     c.name ILIKE ${pattern} OR
                     p.full_name ILIKE ${pattern} OR
                     e.name ILIKE ${pattern})
                AND (${type}::text IS NULL OR e.type::TEXT = ${type}::text)
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

          const mapped: EvaluationSearchRow[] = rows.map((r) => ({
            ...mapEvaluationRow(r),
            total_count: Number(r.total_count),
          }));

          return mapped;
        }),
      )
      .handle("browseCourses", ({ query }) =>
        Effect.gen(function* () {
          const term = query.q?.trim() ?? "";
          const pattern = term.length > 0 ? `%${term}%` : null;
          const types =
            query.types
              ?.split(",")
              .map((value) => value.trim())
              .filter(Boolean) ?? [];

          const rows = yield* sql<{
            course_id: number | string;
            code: string;
            name: string;
            total_count: number | string;
          }>`
              SELECT e.course_id, c.code, c.name, COUNT(*)::bigint AS total_count
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.status = 'approved'
                AND (${pattern}::text IS NULL OR
                     c.code ILIKE ${pattern} OR
                     c.name ILIKE ${pattern} OR
                     p.full_name ILIKE ${pattern} OR
                     e.name ILIKE ${pattern})
                AND (${types.length}::int = 0 OR e.type::TEXT = ANY(${types}::text[]))
              GROUP BY e.course_id, c.code, c.name
              ORDER BY c.code
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: EvaluationCourseItem[] = rows.map((r) => ({
            course_id: Number(r.course_id),
            code: r.code,
            name: r.name,
            total_count: Number(r.total_count),
          }));
          return mapped;
        }),
      )
      .handle("browseTerms", ({ params, query }) =>
        Effect.gen(function* () {
          const term = query.q?.trim() ?? "";
          const pattern = term.length > 0 ? `%${term}%` : null;
          const types =
            query.types
              ?.split(",")
              .map((value) => value.trim())
              .filter(Boolean) ?? [];

          const rows = yield* sql<{
            term_id: number | string | null;
            year: number | string | null;
            label: string;
            total_count: number | string;
          }>`
              SELECT
                e.term_id,
                at.year,
                COALESCE(
                  NULLIF(regexp_replace(at.display_name, '^\\s*\\d{4}\\s*[-:]\\s*', ''), ''),
                  'Sin período'
                ) AS label,
                COUNT(*)::bigint AS total_count
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.status = 'approved'
                AND e.course_id = ${params.courseId}
                AND (${pattern}::text IS NULL OR
                     c.code ILIKE ${pattern} OR
                     c.name ILIKE ${pattern} OR
                     p.full_name ILIKE ${pattern} OR
                     e.name ILIKE ${pattern})
                AND (${types.length}::int = 0 OR e.type::TEXT = ANY(${types}::text[]))
              GROUP BY e.term_id, at.year, at.period_number, label
              ORDER BY at.year DESC NULLS LAST, at.period_number DESC NULLS LAST, e.term_id DESC NULLS LAST
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: EvaluationTermItem[] = rows.map((r) => ({
            term_id: r.term_id !== null ? Number(r.term_id) : null,
            year: r.year !== null ? Number(r.year) : null,
            label: r.label,
            total_count: Number(r.total_count),
          }));
          return mapped;
        }),
      )
      .handle("browseEvaluations", ({ params, query }) =>
        Effect.gen(function* () {
          const term = query.q?.trim() ?? "";
          const pattern = term.length > 0 ? `%${term}%` : null;
          const types =
            query.types
              ?.split(",")
              .map((value) => value.trim())
              .filter(Boolean) ?? [];
          const noTerm = params.termId === "none";
          const termId = noTerm ? null : Number(params.termId);

          const rows = yield* sql<EvaluationDbRow>`
              SELECT
                e.id,
                e.course_id,
                c.code AS course_code,
                c.name AS course_name,
                e.term_id,
                e.professor_id,
                e.type::TEXT,
                e.number,
                e.name,
                e.coordinated,
                e.answers_included,
                e.answers_separate,
                e.file_key,
                e.file_size,
                e.answer_file_key,
                e.status::TEXT,
                e.created_at,
                at.display_name AS term_display_name,
                p.full_name AS professor_name,
                e.extraordinary,
                e.variant
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.status = 'approved'
                AND e.course_id = ${params.courseId}
                AND (${noTerm} OR e.term_id = ${termId})
                AND (${pattern}::text IS NULL OR
                     c.code ILIKE ${pattern} OR
                     c.name ILIKE ${pattern} OR
                     p.full_name ILIKE ${pattern} OR
                     e.name ILIKE ${pattern})
                AND (${types.length}::int = 0 OR e.type::TEXT = ANY(${types}::text[]))
              ORDER BY e.type, e.number NULLS LAST, at.year DESC NULLS LAST, e.created_at DESC
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          return rows.map(mapEvaluationRow);
        }),
      )
      .handle("upload", ({ request }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          yield* checkAuth(Option.getOrNull(userOption));

          const webReq = yield* HttpServerRequest.toWeb(request).pipe(
            Effect.mapError(
              (e) =>
                new BadRequestError({
                  error: `Invalid request: ${e.message}`,
                }),
            ),
          );
          const formData = yield* Effect.tryPromise({
            try: () => webReq.formData(),
            catch: () => new BadRequestError({ error: "Invalid form data" }),
          });

          const evaluationFile = formData.get("evaluationFile");
          const answersFile = formData.get("answersFile");

          if (!(evaluationFile instanceof File) || evaluationFile.type !== "application/pdf") {
            return yield* new BadRequestError({
              error: "Se requiere un archivo PDF valido",
            });
          }

          if (evaluationFile.size > 10 * 1024 * 1024) {
            return yield* new BadRequestError({
              error: "El archivo excede el limite de 10 MB",
            });
          }

          const rawName = formData.get("name");
          const name = typeof rawName === "string" ? rawName : null;

          const validation = validateUploadPayload({
            courseId: parseNullableNumber(formData.get("courseId")),
            termId: parseNullableNumber(formData.get("termId")),
            professorId: parseNullableNumber(formData.get("professorId")),
            type: formData.get("type"),
            number: parseNullableNumber(formData.get("number")),
            name,
            coordinated: formData.get("coordinated") === "true",
            answersIncluded: formData.get("answersIncluded") === "true",
            answersSeparate: formData.get("answersSeparate") === "true",
            extraordinary: formData.get("extraordinary") === "true",
            variant: parseNullableNumber(formData.get("variant")),
            turnstileToken: formData.get("turnstileToken"),
          });

          if (!validation.valid) {
            return yield* new BadRequestError({
              error: validation.error,
            });
          }

          const payload = validation.data;

          const turnstileSecret = process.env.TURNSTILE_SECRET_KEY;
          if (!turnstileSecret) {
            return yield* new InternalServerError({
              error: "Turnstile no esta configurado en el servidor",
            });
          }

          const remoteIp =
            webReq.headers.get("CF-Connecting-IP") ||
            webReq.headers.get("cf-connecting-ip") ||
            null;

          const isHuman = yield* Effect.tryPromise({
            try: () =>
              verifyTurnstileToken(
                payload.turnstileToken,
                { TURNSTILE_SECRET_KEY: turnstileSecret } as unknown as Env,
                remoteIp,
              ),
            catch: (e) =>
              new BadRequestError({
                error: `Turnstile verification failed: ${e instanceof Error ? e.message : String(e)}`,
              }),
          });

          if (!isHuman) {
            return yield* new BadRequestError({
              error: "No se pudo verificar el captcha",
            });
          }

          if (payload.answersSeparate && !(answersFile instanceof File)) {
            return yield* new BadRequestError({
              error: "Debes adjuntar el archivo de respuestas",
            });
          }

          if (answersFile instanceof File) {
            if (answersFile.type !== "application/pdf") {
              return yield* new BadRequestError({
                error: "El archivo de respuestas debe ser PDF",
              });
            }
            if (answersFile.size > 10 * 1024 * 1024) {
              return yield* new BadRequestError({
                error: "El archivo de respuestas excede el limite de 10 MB",
              });
            }
          }

          const fileSha256Raw = formData.get("fileSha256");
          const fileSha256 = typeof fileSha256Raw === "string" ? fileSha256Raw : "";
          const answersFileSha256Raw = formData.get("answersFileSha256");
          const answersFileSha256 =
            typeof answersFileSha256Raw === "string" ? answersFileSha256Raw : null;

          const fileKey = `evaluations/${payload.courseId}/${crypto.randomUUID()}.pdf`;
          let answersKey: string | null = null;

          yield* storage
            .put(fileKey, evaluationFile.stream(), {
              contentType: "application/pdf",
            })
            .pipe(
              Effect.mapError(
                (e) =>
                  new InternalServerError({
                    error: `Storage upload error: ${e.message}`,
                  }),
              ),
            );

          if (payload.answersSeparate && answersFile instanceof File) {
            answersKey = `evaluations/${payload.courseId}/${crypto.randomUUID()}_answers.pdf`;
            yield* storage
              .put(answersKey, answersFile.stream(), {
                contentType: "application/pdf",
              })
              .pipe(
                Effect.mapError(
                  (e) =>
                    new InternalServerError({
                      error: `Storage upload error: ${e.message}`,
                    }),
                ),
              );
          }

          const insertResult = yield* sql`
              INSERT INTO public.course_evaluations (
                course_id, term_id, professor_id, type, number,
                name, coordinated, answers_included, answers_separate,
                file_key, file_size, file_sha256, answer_file_key, answer_file_size, answer_file_sha256,
                extraordinary, variant, status
              ) VALUES (
                ${payload.courseId},
                ${payload.termId},
                ${payload.professorId},
                ${payload.type},
                ${payload.number},
                ${payload.name},
                ${payload.coordinated},
                ${payload.answersIncluded},
                ${payload.answersSeparate},
                ${fileKey},
                ${evaluationFile.size},
                ${fileSha256},
                ${answersKey},
                ${answersFile instanceof File ? answersFile.size : null},
                ${answersFileSha256},
                ${payload.extraordinary},
                ${payload.variant},
                'pending'
              )
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database insertion error: ${e.message}`,
                }),
            ),
            Effect.tapError(() =>
              Effect.gen(function* () {
                yield* storage.delete(fileKey).pipe(Effect.ignore);
                if (answersKey) {
                  yield* storage.delete(answersKey).pipe(Effect.ignore);
                }
              }),
            ),
          );

          void insertResult;

          return {
            success: true,
            message: "Evaluacion subida correctamente",
          };
        }),
      )
      .handle("getById", ({ params }) =>
        Effect.gen(function* () {
          const rows = yield* sql<EvaluationDbRow>`
              SELECT
                e.id,
                e.course_id,
                c.code AS course_code,
                c.name AS course_name,
                e.term_id,
                at.display_name AS term_display_name,
                e.professor_id,
                p.full_name AS professor_name,
                e.type::TEXT,
                e.number,
                e.name,
                e.coordinated,
                e.answers_included,
                e.answers_separate,
                e.file_key,
                e.file_size,
                e.answer_file_key,
                e.status::TEXT,
                e.note,
                e.created_at,
                e.extraordinary,
                e.variant
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({
              error: "Evaluacion no encontrada",
            });
          }

          const r = rows[0];
          const detail: EvaluationDetail = {
            id: Number(r.id),
            course_id: Number(r.course_id),
            course_code: r.course_code,
            course_name: r.course_name,
            term_id: r.term_id !== null ? Number(r.term_id) : null,
            term_display_name: r.term_display_name ?? null,
            professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
            professor_name: r.professor_name ?? null,
            type: r.type,
            number: r.number !== null ? Number(r.number) : null,
            name: r.name ?? null,
            coordinated: Boolean(r.coordinated),
            answers_included: Boolean(r.answers_included),
            answers_separate: Boolean(r.answers_separate),
            file_key: r.file_key,
            file_size: Number(r.file_size),
            answer_file_key: r.answer_file_key ?? null,
            status: r.status,
            note: r.note ?? null,
            created_at: toIsoString(r.created_at) ?? "",
            extraordinary: Boolean(r.extraordinary),
            variant: r.variant !== null ? Number(r.variant) : null,
          };

          return detail;
        }),
      )
      .handle("getFile", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = Option.getOrNull(userOption);

          const rows = yield* sql<EvaluationFileRow>`
              SELECT e.id, e.status, e.file_key, e.type, e.number, e.name, c.code AS course_code,
                     e.extraordinary, e.variant
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              WHERE e.id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({
              error: "Evaluacion no encontrada",
            });
          }

          const evaluation = rows[0];

          if (evaluation.status !== "approved") {
            if (!user) {
              return yield* new UnauthorizedError({ error: "No autorizado" });
            }
            const userRole = user.role ?? "user";
            if (!["admin", "moderator"].includes(userRole)) {
              return yield* new ForbiddenError({ error: "Acceso denegado" });
            }
          }

          const object = yield* storage.get(evaluation.file_key).pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Storage error: ${e.message}`,
                }),
            ),
          );

          if (!object) {
            return yield* new NotFoundError({
              error: "Archivo no encontrado",
            });
          }

          const fileName = formatFileName(
            evaluation.course_code,
            evaluation.type,
            evaluation.number !== null ? Number(evaluation.number) : null,
            evaluation.name,
            Boolean(evaluation.extraordinary),
            evaluation.variant !== null ? Number(evaluation.variant) : null,
          );

          return HttpServerResponse.raw(object.body, {
            status: 200,
            headers: {
              "Content-Type": "application/pdf",
              "Content-Length": String(object.size),
              "Content-Disposition": `inline; filename="${fileName}"`,
              "Cache-Control": "private, max-age=3600",
            },
          });
        }),
      )
      .handle("getAnswers", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = Option.getOrNull(userOption);

          const rows = yield* sql<EvaluationFileRow>`
              SELECT e.id, e.status, e.answer_file_key, e.type, e.number, e.name, c.code AS course_code,
                     e.extraordinary, e.variant
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              WHERE e.id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({
              error: "Evaluacion no encontrada",
            });
          }

          const evaluation = rows[0];

          if (!evaluation.answer_file_key) {
            return yield* new NotFoundError({
              error: "Esta evaluación no tiene archivo de respuestas",
            });
          }

          if (evaluation.status !== "approved") {
            if (!user) {
              return yield* new UnauthorizedError({ error: "No autorizado" });
            }
            const userRole = user.role ?? "user";
            if (!["admin", "moderator"].includes(userRole)) {
              return yield* new ForbiddenError({ error: "Acceso denegado" });
            }
          }

          const object = yield* storage.get(evaluation.answer_file_key).pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Storage error: ${e.message}`,
                }),
            ),
          );

          if (!object) {
            return yield* new NotFoundError({
              error: "Archivo de respuestas no encontrado",
            });
          }

          const baseName = formatFileName(
            evaluation.course_code,
            evaluation.type,
            evaluation.number !== null ? Number(evaluation.number) : null,
            evaluation.name,
            Boolean(evaluation.extraordinary),
            evaluation.variant !== null ? Number(evaluation.variant) : null,
          );
          const fileName = baseName.replace(".pdf", "-respuestas.pdf");

          return HttpServerResponse.raw(object.body, {
            status: 200,
            headers: {
              "Content-Type": "application/pdf",
              "Content-Length": String(object.size),
              "Content-Disposition": `inline; filename="${fileName}"`,
              "Cache-Control": "private, max-age=3600",
            },
          });
        }),
      )
      .handle("moderate", ({ params, payload }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin", "moderator"]);

          const note = payload.note ?? null;

          const rows = yield* sql<{ id: number | string; status: string }>`
              UPDATE public.course_evaluations
              SET status = ${payload.status},
                  note = ${note},
                  moderated_by = ${user.id},
                  moderated_at = NOW(),
                  updated_at = NOW()
              WHERE id = ${params.id}
              RETURNING id, status
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({
              error: "Evaluacion no encontrada",
            });
          }

          return {
            success: true,
            evaluation: {
              id: Number(rows[0].id),
              status: String(rows[0].status),
            },
          };
        }),
      )
      .handle("deleteEvaluation", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = yield* checkAuth(Option.getOrNull(userOption));
          yield* checkRole(user, ["admin"]);

          const rows = yield* sql<{
            file_key: string | null;
            answer_file_key: string | null;
          }>`
              SELECT file_key, answer_file_key FROM public.course_evaluations WHERE id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          if (rows.length === 0) {
            return yield* new NotFoundError({
              error: "Evaluacion no encontrada",
            });
          }

          const { file_key, answer_file_key } = rows[0];

          if (file_key) {
            yield* storage.delete(file_key).pipe(Effect.ignore);
          }
          if (answer_file_key) {
            yield* storage.delete(answer_file_key).pipe(Effect.ignore);
          }

          yield* sql`
              DELETE FROM public.course_evaluations WHERE id = ${params.id}
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          return { success: true };
        }),
      );
  }),
);
