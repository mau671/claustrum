import type { PgClient } from "@effect/sql-pg";

import * as Effect from "effect/Effect";
import { HttpApiBuilder } from "effect/http-api";
import * as HttpServerRequest from "effect/http/HttpServerRequest";
import * as HttpServerResponse from "effect/http/HttpServerResponse";
import * as Option from "effect/Option";

import type { Env } from "../types";

import { EvaluationsApi } from "../api/EvaluationsApi";
import {
  type EvaluationDetail,
  type EvaluationItem,
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
import { verifyTurnstileToken } from "../lib/security";
import { Database } from "../services/Database";
import { Storage, type StorageService } from "../services/Storage";

interface EvaluationDbRow {
  readonly id: number | string;
  readonly course_id: number | string;
  readonly course_code: string;
  readonly course_name: string;
  readonly academic_term_id: number | string | null;
  readonly professor_id: number | string | null;
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
  readonly created_at: unknown;
  readonly term_display_name: string | null;
  readonly professor_name: string | null;
  readonly moderation_note?: string | null;
}

interface EvaluationFileRow {
  readonly id: number | string;
  readonly status: string;
  readonly file_key: string;
  readonly answers_file_key?: string | null;
  readonly evaluation_type: string;
  readonly evaluation_number: number | string | null;
  readonly custom_name: string | null;
  readonly course_code: string;
}

function parseNullableNumber(value: unknown): number | null {
  if (typeof value !== "string" || value.trim() === "") return null;
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : Number.NaN;
}

export const EvaluationsHandlers = HttpApiBuilder.group(EvaluationsApi, "evaluations", (handlers) =>
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
                e.academic_term_id,
                e.professor_id,
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
                e.created_at,
                at.display_name AS term_display_name,
                p.full_name AS professor_name
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
              LEFT JOIN public.professor p ON p.id = e.professor_id
              WHERE e.course_id IN (SELECT course_id FROM target_courses)
                AND e.status = 'approved'
              ORDER BY e.evaluation_type, e.evaluation_number NULLS LAST
            `.pipe(
            Effect.mapError(
              (e) =>
                new InternalServerError({
                  error: `Database error: ${e.message}`,
                }),
            ),
          );

          const mapped: EvaluationItem[] = rows.map((r) => ({
            id: Number(r.id),
            course_id: Number(r.course_id),
            course_code: r.course_code,
            course_name: r.course_name,
            academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
            professor_id: r.professor_id !== null ? Number(r.professor_id) : null,
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
            created_at: r.created_at,
            term_display_name: r.term_display_name ?? null,
            professor_name: r.professor_name ?? null,
          }));

          return mapped;
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

          const rawCustomName = formData.get("customName");
          const customName = typeof rawCustomName === "string" ? rawCustomName : null;

          const validation = validateUploadPayload({
            courseId: parseNullableNumber(formData.get("courseId")),
            academicTermId: parseNullableNumber(formData.get("academicTermId")),
            professorId: parseNullableNumber(formData.get("professorId")),
            evaluationType: formData.get("evaluationType"),
            evaluationNumber: parseNullableNumber(formData.get("evaluationNumber")),
            customName,
            isCatedra: formData.get("isCatedra") === "true",
            includesAnswers: formData.get("includesAnswers") === "true",
            hasSeparateAnswers: formData.get("hasSeparateAnswers") === "true",
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

          if (payload.hasSeparateAnswers && !(answersFile instanceof File)) {
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

          if (payload.hasSeparateAnswers && answersFile instanceof File) {
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
                course_id, academic_term_id, professor_id, evaluation_type, evaluation_number,
                custom_name, is_catedra, includes_answers, has_separate_answers,
                file_key, file_size, file_sha256, answers_file_key, answers_file_size, answers_file_sha256,
                status
              ) VALUES (
                ${payload.courseId},
                ${payload.academicTermId},
                ${payload.professorId},
                ${payload.evaluationType},
                ${payload.evaluationNumber},
                ${payload.customName},
                ${payload.isCatedra},
                ${payload.includesAnswers},
                ${payload.hasSeparateAnswers},
                ${fileKey},
                ${evaluationFile.size},
                ${fileSha256},
                ${answersKey},
                ${answersFile instanceof File ? answersFile.size : null},
                ${answersFileSha256},
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
                e.created_at
              FROM public.course_evaluations e
              JOIN public.course c ON c.id = e.course_id
              LEFT JOIN public.academic_term at ON at.id = e.academic_term_id
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
            created_at: r.created_at,
          };

          return detail;
        }),
      )
      .handle("getFile", ({ params }) =>
        Effect.gen(function* () {
          const userOption = yield* Effect.serviceOption(CurrentUser);
          const user = Option.getOrNull(userOption);

          const rows = yield* sql<EvaluationFileRow>`
              SELECT e.id, e.status, e.file_key, e.evaluation_type, e.evaluation_number, e.custom_name, c.code AS course_code
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
            evaluation.evaluation_type,
            evaluation.evaluation_number !== null ? Number(evaluation.evaluation_number) : null,
            evaluation.custom_name,
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
              SELECT e.id, e.status, e.answers_file_key, e.evaluation_type, e.evaluation_number, e.custom_name, c.code AS course_code
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

          if (!evaluation.answers_file_key) {
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

          const object = yield* storage.get(evaluation.answers_file_key).pipe(
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
            evaluation.evaluation_type,
            evaluation.evaluation_number !== null ? Number(evaluation.evaluation_number) : null,
            evaluation.custom_name,
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
                  moderation_note = ${note},
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
            answers_file_key: string | null;
          }>`
              SELECT file_key, answers_file_key FROM public.course_evaluations WHERE id = ${params.id}
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

          const { file_key, answers_file_key } = rows[0];

          if (file_key) {
            yield* storage.delete(file_key).pipe(Effect.ignore);
          }
          if (answers_file_key) {
            yield* storage.delete(answers_file_key).pipe(Effect.ignore);
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
