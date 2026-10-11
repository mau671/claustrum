import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

import type { HonoEnv } from "../../types";

import { withDb } from "../../lib/db";
import { requireAuth, requireRole } from "../../middleware/auth";

const app = new Hono<HonoEnv>();

// GET /users/me
app.get("/users/me", requireAuth, async (c) => {
  const user = c.get("user")!;

  return withDb(c, async (pool) => {
    const [onboardingResult, profileResult] = await Promise.all([
      pool.query(
        'SELECT onboarding_dismissed_at, onboarding_completed_at FROM public."user" WHERE id = $1',
        [user.id],
      ),
      pool.query("SELECT * FROM public.get_user_profile_with_context($1)", [user.id]),
    ]);

    const onboardingStatus = onboardingResult.rows[0] || null;
    const profile = profileResult.rows[0] || null;

    return c.json({
      ...user,
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role ?? "user",
      banned: user.banned ?? false,
      session: c.get("session") ?? null,
      user,
      onboardingStatus,
      profileContext: profile,
      ...(profile
        ? {
            userStudyPlanId: Number(profile.user_study_plan_id),
            studyPlanId: Number(profile.study_plan_id),
            campusId: Number(profile.campus_id),
            entryYear: Number(profile.entry_year),
            studyPlanName: profile.study_plan_name,
            campusName: profile.campus_name,
            universityId: profile.university_id ? Number(profile.university_id) : null,
            departmentId: profile.academic_unit_id ? Number(profile.academic_unit_id) : null,
            academicUnitId: profile.academic_unit_id ? Number(profile.academic_unit_id) : null,
            termId: profile.term_id ? Number(profile.term_id) : null,
            carnet: profile.carnet,
            // also snake_case
            user_study_plan_id: Number(profile.user_study_plan_id),
            study_plan_id: Number(profile.study_plan_id),
            campus_id: Number(profile.campus_id),
            entry_year: Number(profile.entry_year),
            study_plan_name: profile.study_plan_name,
            campus_name: profile.campus_name,
            academic_unit_id: profile.academic_unit_id ? Number(profile.academic_unit_id) : null,
            term_id: profile.term_id ? Number(profile.term_id) : null,
          }
        : {}),
    });
  });
});

// PATCH /users/me/studyplan
const updateStudyPlanBodySchema = z.object({
  studyPlanId: z.number().int().positive(),
  campusId: z.number().int().positive(),
  entryYear: z.number().int().positive().optional(),
  carnet: z.string().trim().optional(),
});

app.patch(
  "/users/me/studyplan",
  requireAuth,
  zValidator("json", updateStudyPlanBodySchema),
  async (c) => {
    const user = c.get("user")!;
    const data = c.req.valid("json");

    return withDb(c, async (pool) => {
      const client = await pool.connect();
      try {
        await client.query("BEGIN");

        if (data.carnet) {
          await client.query('UPDATE public."user" SET carnet = $1 WHERE id = $2', [
            data.carnet,
            user.id,
          ]);
        }

        const activePlanRes = await client.query(
          "SELECT id FROM public.user_study_plan WHERE user_id = $1 AND is_active = true",
          [user.id],
        );

        if (activePlanRes.rows.length > 0) {
          await client.query(
            `UPDATE public.user_study_plan
             SET study_plan_id = $1, campus_id = $2, entry_year = COALESCE($3, entry_year)
             WHERE id = $4`,
            [data.studyPlanId, data.campusId, data.entryYear ?? null, activePlanRes.rows[0].id],
          );
        } else {
          await client.query(
            `INSERT INTO public.user_study_plan (user_id, study_plan_id, campus_id, entry_year, is_active)
             VALUES ($1, $2, $3, $4, true)`,
            [user.id, data.studyPlanId, data.campusId, data.entryYear ?? new Date().getFullYear()],
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

// POST /onboarding/submit
const submitOnboardingSchema = z.object({
  campusId: z.number().int().positive(),
  academicUnitId: z.number().int().positive().optional(),
  studyPlanId: z.number().int().positive(),
  entryYear: z.number().int().positive().nullable().optional(),
  carnet: z.string().trim().nullable().optional(),
});

app.post(
  "/onboarding/submit",
  requireAuth,
  zValidator("json", submitOnboardingSchema),
  async (c) => {
    const user = c.get("user")!;
    const data = c.req.valid("json");

    return withDb(c, async (pool) => {
      const client = await pool.connect();
      try {
        await client.query("BEGIN");

        if (data.carnet) {
          await client.query('UPDATE public."user" SET carnet = $1 WHERE id = $2', [
            data.carnet,
            user.id,
          ]);
        }

        const activePlanRes = await client.query(
          "SELECT id FROM public.user_study_plan WHERE user_id = $1 AND is_active = true",
          [user.id],
        );

        if (activePlanRes.rows.length > 0) {
          await client.query(
            `UPDATE public.user_study_plan
             SET study_plan_id = $1, campus_id = $2, entry_year = COALESCE($3, entry_year)
             WHERE id = $4`,
            [data.studyPlanId, data.campusId, data.entryYear, activePlanRes.rows[0].id],
          );
        } else {
          await client.query(
            `INSERT INTO public.user_study_plan (user_id, study_plan_id, campus_id, entry_year, is_active)
             VALUES ($1, $2, $3, $4, true)`,
            [user.id, data.studyPlanId, data.campusId, data.entryYear || new Date().getFullYear()],
          );
        }

        await client.query(
          'UPDATE public."user" SET onboarding_completed_at = NOW() WHERE id = $1',
          [user.id],
        );

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

// POST /onboarding/dismiss
app.post("/onboarding/dismiss", requireAuth, async (c) => {
  const user = c.get("user")!;

  return withDb(c, async (pool) => {
    const updateResult = await pool.query(
      'UPDATE public."user" SET onboarding_dismissed_at = NOW() WHERE id = $1',
      [user.id],
    );

    if (updateResult.rowCount === 0) {
      return c.json({ error: "User profile not found" }, 404);
    }

    return c.json({ success: true });
  });
});

// GET /users (admin only)
const listUsersQuerySchema = z.object({
  limit: z.coerce.number().default(20),
  offset: z.coerce.number().default(0),
  search: z.string().optional(),
  role: z.enum(["admin", "moderator", "user"]).optional(),
  banned: z.enum(["true", "false"]).optional(),
});

app.get(
  "/users",
  requireAuth,
  requireRole("admin"),
  zValidator("query", listUsersQuerySchema),
  async (c) => {
    const { limit, offset, search, role, banned } = c.req.valid("query");
    const bannedBool = banned !== undefined ? banned === "true" : null;

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT id, name, email, "emailVerified", image, role, banned, "banReason", "banExpires", "createdAt", "updatedAt",
                COUNT(*) OVER()::bigint AS total_count
         FROM better_auth."user"
         WHERE ($1::text IS NULL OR name ILIKE '%' || $1 || '%' OR email ILIKE '%' || $1 || '%')
           AND ($2::text IS NULL OR role = $2)
           AND ($3::boolean IS NULL OR banned = $3)
         ORDER BY "createdAt" DESC
         LIMIT $4 OFFSET $5`,
        [search?.trim() || null, role ?? null, bannedBool, limit, offset],
      );

      const total = res.rows[0]?.total_count ? Number(res.rows[0].total_count) : 0;
      const users = res.rows.map((r) => ({
        id: r.id,
        name: r.name,
        email: r.email,
        emailVerified: r.emailVerified,
        image: r.image,
        role: r.role,
        banned: r.banned,
        banReason: r.banReason,
        banExpires: r.banExpires,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      }));

      return c.json({ users, total });
    });
  },
);

const userIdParamSchema = z.object({
  id: z.string(),
});

// GET /users/:id (admin only)
app.get(
  "/users/:id",
  requireAuth,
  requireRole("admin"),
  zValidator("param", userIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `SELECT id, name, email, "emailVerified", image, role, banned, "banReason", "banExpires", "createdAt", "updatedAt"
         FROM better_auth."user"
         WHERE id = $1`,
        [id],
      );

      if (res.rows.length === 0) {
        return c.json({ error: "User not found" }, 404);
      }

      const r = res.rows[0];
      return c.json({
        id: r.id,
        name: r.name,
        email: r.email,
        emailVerified: r.emailVerified,
        image: r.image,
        role: r.role,
        banned: r.banned,
        banReason: r.banReason,
        banExpires: r.banExpires,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      });
    });
  },
);

// PATCH /users/:id/role (admin only)
const updateRoleBodySchema = z.object({
  role: z.enum(["admin", "moderator", "user"]),
});

app.patch(
  "/users/:id/role",
  requireAuth,
  requireRole("admin"),
  zValidator("param", userIdParamSchema),
  zValidator("json", updateRoleBodySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { role } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const userRes = await pool.query('SELECT role FROM better_auth."user" WHERE id = $1', [id]);
      if (userRes.rows.length === 0) {
        return c.json({ error: "User not found" }, 404);
      }

      const currentRole = userRes.rows[0].role;
      if (currentRole === "admin" && role !== "admin") {
        const adminCountRes = await pool.query(
          "SELECT COUNT(*)::int AS count FROM better_auth.\"user\" WHERE role = 'admin' AND banned = false",
        );
        if (adminCountRes.rows[0].count <= 1) {
          return c.json({ error: "No se puede remover el último administrador activo" }, 400);
        }
      }

      await pool.query(
        'UPDATE better_auth."user" SET role = $1, "updatedAt" = NOW() WHERE id = $2',
        [role, id],
      );

      return c.json({ success: true });
    });
  },
);

// POST /users/:id/ban (admin only)
const banUserBodySchema = z.object({
  reason: z.string().optional(),
  expiresInSeconds: z.number().int().positive().optional(),
});

app.post(
  "/users/:id/ban",
  requireAuth,
  requireRole("admin"),
  zValidator("param", userIdParamSchema),
  zValidator("json", banUserBodySchema),
  async (c) => {
    const { id } = c.req.valid("param");
    const { reason, expiresInSeconds } = c.req.valid("json");

    return withDb(c, async (pool) => {
      const userRes = await pool.query('SELECT role FROM better_auth."user" WHERE id = $1', [id]);
      if (userRes.rows.length === 0) {
        return c.json({ error: "User not found" }, 404);
      }

      if (userRes.rows[0].role === "admin") {
        const adminCountRes = await pool.query(
          "SELECT COUNT(*)::int AS count FROM better_auth.\"user\" WHERE role = 'admin' AND banned = false",
        );
        if (adminCountRes.rows[0].count <= 1) {
          return c.json({ error: "No se puede suspender al único administrador activo" }, 400);
        }
      }

      const banExpires = expiresInSeconds ? new Date(Date.now() + expiresInSeconds * 1000) : null;

      await pool.query(
        `UPDATE better_auth."user"
         SET banned = true, "banReason" = $1, "banExpires" = $2, "updatedAt" = NOW()
         WHERE id = $3`,
        [reason ?? null, banExpires, id],
      );

      // Invalidate sessions for banned user
      await pool.query('DELETE FROM better_auth."session" WHERE "userId" = $1', [id]);

      return c.json({ success: true });
    });
  },
);

// DELETE /users/:id/ban (admin only - unban)
app.delete(
  "/users/:id/ban",
  requireAuth,
  requireRole("admin"),
  zValidator("param", userIdParamSchema),
  async (c) => {
    const { id } = c.req.valid("param");

    return withDb(c, async (pool) => {
      const res = await pool.query(
        `UPDATE better_auth."user"
         SET banned = false, "banReason" = null, "banExpires" = null, "updatedAt" = NOW()
         WHERE id = $1`,
        [id],
      );

      if (res.rowCount === 0) {
        return c.json({ error: "User not found" }, 404);
      }

      return c.json({ success: true });
    });
  },
);

// DELETE /users/:id (admin only)
app.delete(
  "/users/:id",
  requireAuth,
  requireRole("admin"),
  zValidator("param", userIdParamSchema),
  async (c) => {
    const currentUser = c.get("user")!;
    const { id } = c.req.valid("param");

    if (currentUser.id === id) {
      return withDb(c, async (pool) => {
        const adminCountRes = await pool.query(
          "SELECT COUNT(*)::int AS count FROM better_auth.\"user\" WHERE role = 'admin' AND banned = false",
        );
        if (adminCountRes.rows[0].count <= 1) {
          return c.json(
            { error: "No se puede eliminar a uno mismo si es el único administrador" },
            400,
          );
        }
        await pool.query('DELETE FROM better_auth."user" WHERE id = $1', [id]);
        return c.json({ success: true });
      });
    }

    return withDb(c, async (pool) => {
      const res = await pool.query('DELETE FROM better_auth."user" WHERE id = $1', [id]);
      if (res.rowCount === 0) {
        return c.json({ error: "User not found" }, 404);
      }
      return c.json({ success: true });
    });
  },
);

export default app;
