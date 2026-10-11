import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { verifyTurnstileToken } from "../../lib/security";
import { optionalAuth, requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const feedbackSchema = z.object({
  type: z.enum(["bug", "feature", "other"]),
  content: z.string().trim().min(5).max(2000),
  turnstileToken: z.string().min(1),
  isAnonymous: z.boolean().default(true),
});

const listFeedbackQuerySchema = z.object({
  limit: z.coerce.number().default(20),
  offset: z.coerce.number().default(0),
});

// GET /feedback (admin & moderator)
app.get(
  "/feedback",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("query", listFeedbackQuerySchema),
  async (c) => {
    const { limit, offset } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT id, type, content, is_reviewed, created_at, user_id, admin_notes
         FROM public.user_feedback
         ORDER BY created_at DESC
         LIMIT $1 OFFSET $2`,
        [limit, offset],
      );

      const rows = res.rows.map((r) => ({
        id: Number(r.id),
        type: r.type,
        content: r.content,
        is_reviewed: Boolean(r.is_reviewed),
        created_at: r.created_at,
        user_id: r.user_id ? String(r.user_id) : null,
        admin_notes: r.admin_notes ?? null,
      }));

      return c.json(rows);
    });
  },
);

// POST /feedback
app.post("/feedback", optionalAuth, zValidator("json", feedbackSchema), async (c) => {
  const { type, content, turnstileToken, isAnonymous } = c.req.valid("json");
  const user = c.get("user");

  if (!c.env.TURNSTILE_SECRET_KEY) {
    return c.json({ error: "Missing Turnstile secret configuration" }, 500);
  }

  const isHuman = await verifyTurnstileToken(
    turnstileToken,
    c.env,
    c.req.header("cf-connecting-ip") ?? null,
  );
  if (!isHuman) {
    return c.json(
      { error: "Fallo en la validación de seguridad (Turnstile). Inténtalo de nuevo." },
      400,
    );
  }

  const userId = !isAnonymous && user ? user.id : null;

  return withDb(c, async (pool) => {
    const res = await pool.query(
      `INSERT INTO public.user_feedback (type, content, user_id)
       VALUES ($1, $2, $3)
       RETURNING id, type, content, created_at`,
      [type, content, userId],
    );

    return c.json({ success: true, feedback: res.rows[0] }, 201);
  });
});

const feedbackIdParamSchema = z.object({
  id: z.coerce.number(),
});

// GET /feedback/:id (admin & moderator)
app.get(
  "/feedback/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", feedbackIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT id, type, content, is_reviewed, created_at, user_id, admin_notes
         FROM public.user_feedback
         WHERE id = $1`,
        [id],
      );

      if (res.rows.length === 0) {
        return c.json({ error: "Feedback not found" }, 404);
      }

      const r = res.rows[0];
      return c.json({
        id: Number(r.id),
        type: r.type,
        content: r.content,
        is_reviewed: Boolean(r.is_reviewed),
        created_at: r.created_at,
        user_id: r.user_id ? String(r.user_id) : null,
        admin_notes: r.admin_notes ?? null,
      });
    });
  },
);

// PATCH /feedback/:id (admin & moderator)
const updateFeedbackSchema = z.object({
  isReviewed: z.boolean().optional(),
  adminNotes: z.string().optional().nullable(),
});

app.patch(
  "/feedback/:id",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", feedbackIdParamSchema),
  zValidator("json", updateFeedbackSchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { isReviewed, adminNotes } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `UPDATE public.user_feedback
         SET is_reviewed = COALESCE($1, is_reviewed),
             admin_notes = COALESCE($2, admin_notes),
             updated_at = NOW()
         WHERE id = $3
         RETURNING *`,
        [isReviewed ?? null, adminNotes ?? null, id],
      );

      if (res.rowCount === 0) {
        return c.json({ error: "Feedback not found" }, 404);
      }

      return c.json({ success: true, feedback: res.rows[0] });
    });
  },
);

// POST /feedback/:id/replies (admin & moderator)
const replyFeedbackSchema = z.object({
  message: z.string().min(1),
  notes: z.string().optional(),
});

app.post(
  "/feedback/:id/replies",
  requireAuth,
  requireRole(["admin", "moderator"]),
  zValidator("param", feedbackIdParamSchema),
  zValidator("json", replyFeedbackSchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { message, notes } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const client = await pool.connect();
      try {
        await client.query("BEGIN");

        const updateRes = await client.query(
          `UPDATE public.user_feedback
           SET admin_notes = COALESCE($1, admin_notes),
               is_reviewed = true,
               updated_at = NOW()
           WHERE id = $2
           RETURNING user_id`,
          [notes?.trim() || null, id],
        );

        if (updateRes.rows.length === 0) {
          await client.query("ROLLBACK");
          return c.json({ error: "Feedback not found" }, 404);
        }

        const targetUserId = updateRes.rows[0].user_id;
        if (targetUserId && message.trim() !== "") {
          await client.query(
            `INSERT INTO public.notifications (user_id, title, message, link)
             VALUES ($1, 'Respuesta a tu retroalimentación', $2, NULL)`,
            [targetUserId, message.trim()],
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
