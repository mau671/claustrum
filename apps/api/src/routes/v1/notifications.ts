import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { streamSSE } from "hono/streaming";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { optionalAuth, requireAuth } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

const listNotificationsQuerySchema = z.object({
  limit: z.coerce.number().default(50),
});

// GET /notifications
app.get(
  "/notifications",
  optionalAuth,
  zValidator("query", listNotificationsQuerySchema),
  async (c) => {
    const user = c.get("user");
    const { limit } = c.req.valid("query");

    return withDb(c, async (pool) => {
      const res = user?.id
        ? await pool.query(
            `SELECT id, user_id, title, message, link, is_read, created_at
             FROM public.notifications
             WHERE user_id = $1 OR user_id IS NULL
             ORDER BY created_at DESC
             LIMIT $2`,
            [user.id, limit],
          )
        : await pool.query(
            `SELECT id, user_id, title, message, link, is_read, created_at
             FROM public.notifications
             WHERE user_id IS NULL
             ORDER BY created_at DESC
             LIMIT $1`,
            [limit],
          );

      const rows = res.rows.map((r) => ({
        id: r.id,
        user_id: r.user_id,
        title: r.title,
        message: r.message,
        link: r.link ?? null,
        is_read: Boolean(r.is_read),
        created_at: r.created_at,
      }));

      return c.json(rows);
    });
  },
);

const notificationIdParamSchema = z.object({
  id: z.string(),
});

// PATCH /notifications/:id
app.patch(
  "/notifications/:id",
  requireAuth,
  zValidator("param", notificationIdParamSchema),
  async (c) => {
    const user = c.get("user")!;
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `UPDATE public.notifications
         SET is_read = true
         WHERE id = $1 AND user_id = $2
         RETURNING id`,
        [id, user.id],
      );

      if (res.rowCount === 0) {
        return c.json({ error: "Notification not found" }, 404);
      }

      return c.json({ success: true });
    });
  },
);

// POST /notifications/read
app.post("/notifications/read", requireAuth, async (c) => {
  const user = c.get("user")!;

  return withDb(c, async (pool) => {
    await pool.query(
      `UPDATE public.notifications
       SET is_read = true
       WHERE user_id = $1`,
      [user.id],
    );

    return c.json({ success: true });
  });
});

// GET /notifications/stream
app.get("/notifications/stream", requireAuth, async (c) => {
  const user = c.get("user")!;

  return streamSSE(c, async (stream) => {
    await stream.writeSSE({
      event: "connected",
      data: JSON.stringify({ userId: user.id, timestamp: Date.now() }),
    });

    while (!stream.aborted) {
      await stream.sleep(30000);
      if (stream.aborted) break;
      await stream.writeSSE({
        event: "ping",
        data: JSON.stringify({ timestamp: Date.now() }),
      });
    }
  });
});

export default app;
