import { Effect } from "effect";
import { HttpApiBuilder } from "effect/http-api";

import type { SqlClient } from "../services/Database";

import { ClaustrumApi } from "../api/index";
import { CurrentUser } from "../domain/Auth";
import {
  type InsertAttemptPayload,
  type InsertAttemptResponse,
  type StudentAttemptsQuery,
  type StudentCourseAttempt,
  type StudentCourseStatus,
  StudentForbidden,
  type StudentSuccessResponse,
  StudentUnauthorized,
  type StudyPlanIdQuery,
  type UpdateAttemptPayload,
} from "../domain/Students";
import { toIsoString } from "../lib/date";
import { Database } from "../services/Database";

interface RawCourseStatusRow {
  course_id: number | string;
  status: string;
  grade?: number | string | null;
  recorded_at?: unknown | null;
  origin_course_id?: number | string | null;
  origin_course_code?: string | null;
  origin_course_name?: string | null;
  origin_study_plan_id?: number | string | null;
  origin_attempt_id?: number | string | null;
  origin_attempt_number?: number | string | null;
  origin_grade?: number | string | null;
  origin_recorded_at?: unknown | null;
  origin_academic_term_id?: number | string | null;
  origin_academic_term_name?: string | null;
  origin_type?: string | null;
}

interface RawAttemptRow {
  id: number | string;
  course_id: number | string;
  course_code?: string | null;
  course_name?: string | null;
  attempt_number: number | string;
  status: string;
  grade?: number | string | null;
  academic_term_id?: number | string | null;
  recorded_at?: unknown | null;
  equivalent_course_id?: number | string | null;
  equivalent_course_code?: string | null;
  equivalent_course_name?: string | null;
}

interface RawInsertAttemptRow {
  attempt_id: number | string | null;
}

export const StudentsApiHandlers = HttpApiBuilder.group(
  ClaustrumApi,
  "students",
  Effect.fn(function* (handlers) {
    const db = yield* Database;
    const sql = db as unknown as SqlClient;

    const requireUser = Effect.gen(function* () {
      const userOpt = yield* Effect.serviceOption(CurrentUser);
      if (userOpt._tag === "None" || !userOpt.value) {
        return yield* Effect.fail(new StudentUnauthorized({ error: "No autorizado" }));
      }
      const user = userOpt.value;
      if (user.banned) {
        return yield* Effect.fail(
          new StudentForbidden({
            error: "Cuenta suspendida",
            reason: user.banReason ?? null,
          }),
        );
      }
      return user;
    });

    return handlers.handleAll({
      statuses: ({ query }: { query: StudyPlanIdQuery }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;

          const rows = yield* sql
            .unsafe<RawCourseStatusRow>(
              "SELECT * FROM public.get_user_course_effective_status_details($1, $2)",
              [user.id, query.studyPlanId],
            )
            .pipe(Effect.orDie);

          return (rows as readonly RawCourseStatusRow[]).map(
            (r: RawCourseStatusRow): StudentCourseStatus => {
              const grade = r.grade !== null && r.grade !== undefined ? Number(r.grade) : null;
              const originCourseId =
                r.origin_course_id !== null && r.origin_course_id !== undefined
                  ? Number(r.origin_course_id)
                  : null;
              const originStudyPlanId =
                r.origin_study_plan_id !== null && r.origin_study_plan_id !== undefined
                  ? Number(r.origin_study_plan_id)
                  : null;
              const originAttemptId =
                r.origin_attempt_id !== null && r.origin_attempt_id !== undefined
                  ? Number(r.origin_attempt_id)
                  : null;
              const originAttemptNumber =
                r.origin_attempt_number !== null && r.origin_attempt_number !== undefined
                  ? Number(r.origin_attempt_number)
                  : null;
              const originGrade =
                r.origin_grade !== null && r.origin_grade !== undefined
                  ? Number(r.origin_grade)
                  : null;
              const originAcademicTermId =
                r.origin_academic_term_id !== null && r.origin_academic_term_id !== undefined
                  ? Number(r.origin_academic_term_id)
                  : null;

              return {
                courseId: Number(r.course_id),
                status: typeof r.status === "string" ? r.status.toLowerCase() : String(r.status),
                grade,
                recordedAt: toIsoString(r.recorded_at),
                originCourseId,
                originCourseCode: r.origin_course_code ?? null,
                originCourseName: r.origin_course_name ?? null,
                originStudyPlanId,
                originAttemptId,
                originAttemptNumber,
                originGrade,
                originRecordedAt: toIsoString(r.origin_recorded_at),
                originAcademicTermId,
                originAcademicTermName: r.origin_academic_term_name ?? null,
                originType: r.origin_type ?? null,
                course_id: Number(r.course_id),
                recorded_at: toIsoString(r.recorded_at),
                origin_course_id: originCourseId,
                origin_course_code: r.origin_course_code ?? null,
                origin_course_name: r.origin_course_name ?? null,
                origin_study_plan_id: originStudyPlanId,
                origin_attempt_id: originAttemptId,
                origin_attempt_number: originAttemptNumber,
                origin_grade: originGrade,
                origin_recorded_at: toIsoString(r.origin_recorded_at),
                origin_academic_term_id: originAcademicTermId,
                origin_academic_term_name: r.origin_academic_term_name ?? null,
                origin_type: r.origin_type ?? null,
              };
            },
          );
        }),

      stats: ({ query }: { query: StudyPlanIdQuery }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;

          const rows = yield* sql
            .unsafe<{ stats?: unknown }>(
              "SELECT public.get_user_dashboard_stats($1, $2) AS stats",
              [user.id, query.studyPlanId],
            )
            .pipe(Effect.orDie);

          return rows[0]?.stats ?? null;
        }),

      attempts: ({ query }: { query: StudentAttemptsQuery }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;

          let rows: ReadonlyArray<RawAttemptRow>;
          if (query.courseId !== undefined) {
            rows = yield* sql
              .unsafe<RawAttemptRow>(
                "SELECT * FROM public.get_student_course_attempts($1, $2, $3)",
                [user.id, query.studyPlanId, query.courseId],
              )
              .pipe(Effect.orDie);
          } else {
            rows = yield* sql
              .unsafe<RawAttemptRow>(
                `SELECT
                   scr.id,
                   scr.course_id,
                   c.code AS course_code,
                   c.name AS course_name,
                   scr.attempt_number,
                   LOWER(scr.status::TEXT) AS status,
                   scr.grade,
                   scr.academic_term_id,
                   scr.recorded_at,
                   scr.equivalent_course_id,
                   ec.code AS equivalent_course_code,
                   ec.name AS equivalent_course_name
                 FROM public.student_course_record scr
                 JOIN public.course c ON c.id = scr.course_id
                 LEFT JOIN public.course ec ON ec.id = scr.equivalent_course_id
                 WHERE scr.user_id = $1
                   AND scr.study_plan_id = $2
                 ORDER BY scr.recorded_at DESC NULLS LAST, scr.id DESC`,
                [user.id, query.studyPlanId],
              )
              .pipe(Effect.orDie);
          }

          return (rows as readonly RawAttemptRow[]).map(
            (r: RawAttemptRow): StudentCourseAttempt => {
              const grade = r.grade !== null && r.grade !== undefined ? Number(r.grade) : null;
              const academicTermId =
                r.academic_term_id !== null && r.academic_term_id !== undefined
                  ? Number(r.academic_term_id)
                  : null;
              const equivalentCourseId =
                r.equivalent_course_id !== null && r.equivalent_course_id !== undefined
                  ? Number(r.equivalent_course_id)
                  : null;

              return {
                id: Number(r.id),
                courseId: Number(r.course_id),
                courseCode: r.course_code ?? null,
                courseName: r.course_name ?? null,
                attemptNumber: Number(r.attempt_number),
                status: typeof r.status === "string" ? r.status.toLowerCase() : String(r.status),
                grade,
                academicTermId,
                recordedAt: toIsoString(r.recorded_at),
                equivalentCourseId,
                equivalentCourseCode: r.equivalent_course_code ?? null,
                equivalentCourseName: r.equivalent_course_name ?? null,
                course_id: Number(r.course_id),
                course_code: r.course_code ?? null,
                course_name: r.course_name ?? null,
                attempt_number: Number(r.attempt_number),
                academic_term_id: academicTermId,
                recorded_at: toIsoString(r.recorded_at),
                equivalent_course_id: equivalentCourseId,
                equivalent_course_code: r.equivalent_course_code ?? null,
                equivalent_course_name: r.equivalent_course_name ?? null,
              };
            },
          );
        }),

      createAttempt: ({ payload }: { payload: InsertAttemptPayload }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;
          const termId = payload.academicTermId ?? payload.termId ?? null;

          const rows = yield* sql
            .unsafe<RawInsertAttemptRow>(
              "SELECT public.insert_student_course_attempt($1, $2, $3, $4, $5, $6, $7) AS attempt_id",
              [
                user.id,
                payload.studyPlanId,
                payload.courseId,
                payload.status.toUpperCase(),
                payload.grade ?? null,
                termId,
                payload.equivalentCourseId ?? null,
              ],
            )
            .pipe(Effect.orDie);

          const insertedId =
            rows[0]?.attempt_id !== null && rows[0]?.attempt_id !== undefined
              ? Number(rows[0].attempt_id)
              : null;

          return {
            success: true,
            id: insertedId,
          } satisfies InsertAttemptResponse;
        }),

      updateAttempt: ({
        params,
        payload,
      }: {
        params: { id: number };
        payload: UpdateAttemptPayload;
      }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;
          const termId = payload.academicTermId ?? payload.termId ?? null;

          yield* sql
            .unsafe("SELECT public.update_student_course_attempt($1, $2, $3, $4, $5, $6)", [
              user.id,
              params.id,
              termId,
              payload.grade ?? null,
              payload.status ? payload.status.toUpperCase() : null,
              payload.equivalentCourseId ?? null,
            ])
            .pipe(Effect.orDie);

          return { success: true } satisfies StudentSuccessResponse;
        }),

      deleteAttempt: ({ params }: { params: { id: number } }) =>
        Effect.gen(function* () {
          const user = yield* requireUser;

          yield* sql
            .unsafe("SELECT public.delete_student_course_attempt($1, $2)", [user.id, params.id])
            .pipe(Effect.orDie);

          return { success: true } satisfies StudentSuccessResponse;
        }),
    });
  }),
);

export const studentsHandlers = StudentsApiHandlers;
