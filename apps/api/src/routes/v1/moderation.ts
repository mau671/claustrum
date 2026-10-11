import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

// GET /moderation/counts (admin & moderator)
app.get("/moderation/counts", requireAuth, requireRole(["admin", "moderator"]), async (c) => {
  return withDb(c, async (pool) => {
    const [reviewsRes, evalsRes, reportsRes, feedbackRes] = await Promise.all([
      pool.query(
        "SELECT COUNT(*)::bigint AS count FROM public.professor_review WHERE status = 'pending'",
      ),
      pool.query(
        "SELECT COUNT(*)::bigint AS count FROM public.course_evaluations WHERE status = 'pending'",
      ),
      pool.query(
        "SELECT COUNT(*)::bigint AS count FROM public.professor_review_report WHERE status = 'pending'",
      ),
      pool.query(
        "SELECT COUNT(*)::bigint AS count FROM public.user_feedback WHERE is_reviewed = false",
      ),
    ]);

    const pendingReviews = Number(reviewsRes.rows[0]?.count ?? 0);
    const pendingEvaluations = Number(evalsRes.rows[0]?.count ?? 0);
    const pendingReports = Number(reportsRes.rows[0]?.count ?? 0);
    const pendingFeedback = Number(feedbackRes.rows[0]?.count ?? 0);

    return c.json({
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
    });
  });
});

// GET /moderation/reviews (admin & moderator)
const moderationReviewsQuerySchema = z.object({
  status: z.enum(["pending", "approved", "rejected", "all"]).optional(),
  limit: z.coerce.number().default(50),
  offset: z.coerce.number().default(0),
});

app.get(
  "/moderation/reviews",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("query", moderationReviewsQuerySchema),
  async (c) => {
    const { status, limit, offset } = c.req.valid("query");
    const statusFilter = status && status !== "all" ? status : null;

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `WITH review_courses AS (
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
         WHERE ($1::text IS NULL OR pr.status::text = $1)
         ORDER BY
           CASE WHEN $1 = 'pending' THEN pr.created_at END ASC,
           pr.created_at DESC
         LIMIT $2 OFFSET $3`,
        [statusFilter, limit, offset],
      );

      const rows = res.rows.map((r) => ({
        review_id: Number(r.review_id),
        professor_id: Number(r.professor_id),
        professor_name: r.professor_name,
        courses: r.courses ?? [],
        comment: r.comment,
        ease_score: Number(r.ease_score),
        quality_score: Number(r.quality_score),
        clarity_score: Number(r.clarity_score),
        fairness_score: Number(r.fairness_score),
        attendance_required: r.attendance_required,
        grade_received: r.grade_received,
        engagement_level: r.engagement_level,
        tags: r.tags ?? [],
        status: r.status,
        created_at: r.created_at,
        reviewed_at: r.reviewed_at,
        moderation_note: r.moderation_note,
        total_count: Number(r.total_count ?? 0),
      }));

      return c.json(rows);
    });
  },
);

// GET /moderation/evaluations (admin & moderator)
const moderationEvaluationsQuerySchema = z.object({
  status: z.enum(["pending", "approved", "rejected"]).default("pending"),
  limit: z.coerce.number().default(50),
  offset: z.coerce.number().default(0),
});

app.get(
  "/moderation/evaluations",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("query", moderationEvaluationsQuerySchema),
  async (c) => {
    const { status, limit, offset } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT
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
         WHERE e.status = $1
         ORDER BY
           CASE WHEN $1 = 'pending' THEN e.created_at END ASC,
           e.created_at DESC
         LIMIT $2 OFFSET $3`,
        [status, limit, offset],
      );

      const rows = res.rows.map((r) => ({
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
        total_count: Number(r.total_count ?? 0),
      }));

      return c.json(rows);
    });
  },
);

export default app;
