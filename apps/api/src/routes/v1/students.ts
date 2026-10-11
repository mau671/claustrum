import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb, withUserDb } from "../../lib/db";
import { requireAuth } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const studyPlanIdQuerySchema = z.object({
  studyPlanId: z.coerce.number(),
});

// GET /students/me/statuses
app.get(
  "/students/me/statuses",
  requireAuth,
  zValidator("query", studyPlanIdQuerySchema),
  async (c) => {
    const user = c.get("user")!;
    const { studyPlanId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        "SELECT * FROM public.get_user_course_effective_status_details($1, $2)",
        [user.id, studyPlanId],
      );

      const statuses = res.rows.map((r) => ({
        courseId: Number(r.course_id),
        status: typeof r.status === "string" ? r.status.toLowerCase() : r.status,
        grade: r.grade !== null ? Number(r.grade) : null,
        recordedAt: r.recorded_at,
        originCourseId: r.origin_course_id !== null ? Number(r.origin_course_id) : null,
        originCourseCode: r.origin_course_code ?? null,
        originCourseName: r.origin_course_name ?? null,
        originStudyPlanId: r.origin_study_plan_id !== null ? Number(r.origin_study_plan_id) : null,
        originAttemptId: r.origin_attempt_id !== null ? Number(r.origin_attempt_id) : null,
        originAttemptNumber:
          r.origin_attempt_number !== null ? Number(r.origin_attempt_number) : null,
        originGrade: r.origin_grade !== null ? Number(r.origin_grade) : null,
        originRecordedAt: r.origin_recorded_at ?? null,
        originAcademicTermId:
          r.origin_academic_term_id !== null ? Number(r.origin_academic_term_id) : null,
        originAcademicTermName: r.origin_academic_term_name ?? null,
        originType: r.origin_type ?? null,
        // also keep snake_case
        course_id: Number(r.course_id),
        recorded_at: r.recorded_at,
        origin_course_id: r.origin_course_id !== null ? Number(r.origin_course_id) : null,
        origin_course_code: r.origin_course_code ?? null,
        origin_course_name: r.origin_course_name ?? null,
        origin_study_plan_id:
          r.origin_study_plan_id !== null ? Number(r.origin_study_plan_id) : null,
        origin_attempt_id: r.origin_attempt_id !== null ? Number(r.origin_attempt_id) : null,
        origin_attempt_number:
          r.origin_attempt_number !== null ? Number(r.origin_attempt_number) : null,
        origin_grade: r.origin_grade !== null ? Number(r.origin_grade) : null,
        origin_recorded_at: r.origin_recorded_at ?? null,
        origin_academic_term_id:
          r.origin_academic_term_id !== null ? Number(r.origin_academic_term_id) : null,
        origin_academic_term_name: r.origin_academic_term_name ?? null,
        origin_type: r.origin_type ?? null,
      }));

      return c.json(statuses);
    });
  },
);

// GET /students/me/stats
app.get(
  "/students/me/stats",
  requireAuth,
  zValidator("query", studyPlanIdQuerySchema),
  async (c) => {
    const user = c.get("user")!;
    const { studyPlanId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query("SELECT public.get_user_dashboard_stats($1, $2) AS stats", [
        user.id,
        studyPlanId,
      ]);

      const stats = res.rows[0]?.stats ?? null;
      return c.json(stats);
    });
  },
);

// GET /students/me/attempts
const attemptsQuerySchema = z.object({
  studyPlanId: z.coerce.number(),
  courseId: z.coerce.number().optional(),
});

app.get(
  "/students/me/attempts",
  requireAuth,
  zValidator("query", attemptsQuerySchema),
  async (c) => {
    const user = c.get("user")!;
    const { studyPlanId, courseId } = c.req.valid("query");

    return withDb(c, async (pool) => {
      if (courseId) {
        const res = await pool.query(
          "SELECT * FROM public.get_student_course_attempts($1, $2, $3)",
          [user.id, studyPlanId, courseId],
        );
        const attempts = res.rows.map((r) => ({
          id: Number(r.id),
          courseId: Number(r.course_id),
          courseCode: r.course_code ?? null,
          courseName: r.course_name ?? null,
          attemptNumber: Number(r.attempt_number),
          status: typeof r.status === "string" ? r.status.toLowerCase() : r.status,
          grade: r.grade !== null ? Number(r.grade) : null,
          academicTermId: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
          recordedAt: r.recorded_at,
          equivalentCourseId:
            r.equivalent_course_id !== null ? Number(r.equivalent_course_id) : null,
          equivalentCourseCode: r.equivalent_course_code ?? null,
          equivalentCourseName: r.equivalent_course_name ?? null,
          // also keep snake_case
          course_id: Number(r.course_id),
          course_code: r.course_code ?? null,
          course_name: r.course_name ?? null,
          attempt_number: Number(r.attempt_number),
          academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
          recorded_at: r.recorded_at,
          equivalent_course_id:
            r.equivalent_course_id !== null ? Number(r.equivalent_course_id) : null,
          equivalent_course_code: r.equivalent_course_code ?? null,
          equivalent_course_name: r.equivalent_course_name ?? null,
        }));
        return c.json(attempts);
      }

      const res = await pool.query(
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
        [user.id, studyPlanId],
      );

      const attempts = res.rows.map((r) => ({
        id: Number(r.id),
        courseId: Number(r.course_id),
        courseCode: r.course_code ?? null,
        courseName: r.course_name ?? null,
        attemptNumber: Number(r.attempt_number),
        status: typeof r.status === "string" ? r.status.toLowerCase() : r.status,
        grade: r.grade !== null ? Number(r.grade) : null,
        academicTermId: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
        recordedAt: r.recorded_at,
        equivalentCourseId: r.equivalent_course_id !== null ? Number(r.equivalent_course_id) : null,
        equivalentCourseCode: r.equivalent_course_code ?? null,
        equivalentCourseName: r.equivalent_course_name ?? null,
        // also keep snake_case
        course_id: Number(r.course_id),
        course_code: r.course_code ?? null,
        course_name: r.course_name ?? null,
        attempt_number: Number(r.attempt_number),
        academic_term_id: r.academic_term_id !== null ? Number(r.academic_term_id) : null,
        recorded_at: r.recorded_at,
        equivalent_course_id:
          r.equivalent_course_id !== null ? Number(r.equivalent_course_id) : null,
        equivalent_course_code: r.equivalent_course_code ?? null,
        equivalent_course_name: r.equivalent_course_name ?? null,
      }));

      return c.json(attempts);
    });
  },
);

// POST /students/me/attempts
const insertAttemptBodySchema = z.object({
  studyPlanId: z.number().int().positive(),
  courseId: z.number().int().positive(),
  status: z.string(),
  grade: z.number().min(0).max(100).nullable().optional(),
  termId: z.number().int().positive().nullable().optional(),
  academicTermId: z.number().int().positive().nullable().optional(),
  equivalentCourseId: z.number().int().positive().nullable().optional(),
});

app.post(
  "/students/me/attempts",
  requireAuth,
  zValidator("json", insertAttemptBodySchema),
  async (c) => {
    const user = c.get("user")!;
    const data = c.req.valid("json");
    const termId = data.academicTermId ?? data.termId ?? null;

    return withUserDb(c, user.id, async (client) => {
      const res = await client.query(
        "SELECT public.insert_student_course_attempt($1, $2, $3, $4, $5, $6, $7) AS attempt_id",
        [
          user.id,
          data.studyPlanId,
          data.courseId,
          data.status.toUpperCase(),
          data.grade ?? null,
          termId,
          data.equivalentCourseId ?? null,
        ],
      );

      const insertedId = res.rows[0]?.attempt_id ? Number(res.rows[0].attempt_id) : null;
      return c.json({ success: true, id: insertedId }, 201);
    });
  },
);

const attemptIdParamSchema = z.object({
  id: z.coerce.number(),
});

// PATCH /students/me/attempts/:id
const updateAttemptBodySchema = z.object({
  status: z.string().optional(),
  grade: z.number().min(0).max(100).nullable().optional(),
  termId: z.number().int().positive().nullable().optional(),
  academicTermId: z.number().int().positive().nullable().optional(),
  equivalentCourseId: z.number().int().positive().nullable().optional(),
});

app.patch(
  "/students/me/attempts/:id",
  requireAuth,
  zValidator("param", attemptIdParamSchema),
  zValidator("json", updateAttemptBodySchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");
    const data = c.req.valid("json");
    const termId = data.academicTermId ?? data.termId ?? null;

    return withUserDb(c, user.id, async (client) => {
      await client.query("SELECT public.update_student_course_attempt($1, $2, $3, $4, $5)", [
        id,
        termId,
        data.grade ?? null,
        data.status ? data.status.toUpperCase() : null,
        data.equivalentCourseId ?? null,
      ]);

      return c.json({ success: true });
    });
  },
);

// DELETE /students/me/attempts/:id
app.delete(
  "/students/me/attempts/:id",
  requireAuth,
  zValidator("param", attemptIdParamSchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");

    return withUserDb(c, user.id, async (client) => {
      await client.query("SELECT public.delete_student_course_attempt($1)", [id]);
      return c.json({ success: true });
    });
  },
);

export default app;
