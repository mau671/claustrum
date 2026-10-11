import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const reportsQuerySchema = z.object({
  status: z.enum(["pending", "resolved", "dismissed"]).default("pending"),
  limit: z.coerce.number().default(20),
  offset: z.coerce.number().default(0),
});

// GET /reports
app.get(
  "/reports",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("query", reportsQuerySchema),
  async (c) => {
    const { status, limit, offset } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `WITH filtered AS (
           SELECT r.*
           FROM public.professor_review_report r
           WHERE r.status = $1
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
         LIMIT $2 OFFSET $3`,
        [status, limit, offset],
      );

      const rows = res.rows.map((r) => ({
        report_id: Number(r.report_id),
        review_id: Number(r.review_id),
        reason: r.reason,
        description: r.description ?? null,
        status: r.status,
        created_at: r.created_at,
        professor_id: String(r.professor_id),
        professor_name: r.professor_name,
        course_code: r.course_code ?? "",
        course_name: r.course_name ?? "",
        comment: r.comment,
        total_count: Number(r.total_count ?? 0),
      }));

      return c.json(rows);
    });
  },
);

const reportIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /reports/:id
app.get(
  "/reports/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", reportIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `WITH review_courses AS (
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
         WHERE r.id = $1`,
        [id],
      );

      if (res.rows.length === 0) {
        return c.json({ error: "Report not found" }, 404);
      }

      const r = res.rows[0];
      return c.json({
        report_id: Number(r.report_id),
        review_id: Number(r.review_id),
        reason: r.reason,
        description: r.description ?? null,
        status: r.status,
        resolution_note: r.resolution_note ?? null,
        created_at: r.created_at,
        resolved_at: r.resolved_at ?? null,
        professor_id: String(r.professor_id),
        professor_name: r.professor_name,
        course_code: r.course_code ?? "",
        course_name: r.course_name ?? "",
        comment: r.comment,
      });
    });
  },
);

// PATCH /reports/:id
const moderateReportBodySchema = z.object({
  status: z.enum(["resolved", "dismissed"]),
  note: z.string().optional().nullable(),
  rejectReview: z.boolean().optional(),
});

app.patch(
  "/reports/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", reportIdParamSchema),
  zValidator("json", moderateReportBodySchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");
    const { status, note, rejectReview } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const client = await pool.connect();
      try {
        await client.query("BEGIN");

        const reportRes = await client.query(
          `UPDATE public.professor_review_report
           SET status = $1,
               resolution_note = $2,
               resolved_by = $3,
               resolved_at = NOW(),
               updated_at = NOW()
           WHERE id = $4
           RETURNING review_id`,
          [status, note?.trim() || null, user.id, id],
        );

        if (reportRes.rows.length === 0) {
          await client.query("ROLLBACK");
          return c.json({ error: "Report not found" }, 404);
        }

        const reviewId = reportRes.rows[0].review_id;

        if (status === "resolved" || rejectReview === true) {
          await client.query(
            `UPDATE public.professor_review
             SET status = 'rejected',
                 moderation_note = COALESCE($1, 'Rechazado automáticamente al resolver un reporte.'),
                 reviewed_by = $2,
                 reviewed_at = NOW(),
                 updated_at = NOW()
             WHERE id = $3 AND status != 'rejected'`,
            [note?.trim() || null, user.id, reviewId],
          );
        }

        await client.query("COMMIT");
        return c.json({ success: true });
      } catch (error) {
        await client.query("ROLLBACK").catch(() => {});
        throw error;
      } finally {
        client.release();
      }
    });
  },
);

export default app;
