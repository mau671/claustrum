import { Hono } from "hono";

import type { Env } from "../types";

import { getAuth, getDbPool } from "../lib/db";

const authRoutes = new Hono<{ Bindings: Env }>();

authRoutes.get("/me", async (c) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);

  try {
    const session = await auth.api.getSession({
      headers: c.req.raw.headers,
    });

    if (!session || !session.user) {
      return c.json({ session: null, user: null, profileContext: null, onboardingStatus: null });
    }

    const userId = session.user.id;

    const cacheBuster = `/* bypass-cache-${Date.now()} */`;
    const [onboardingResult, profileResult] = await Promise.all([
      pool.query(
        `SELECT onboarding_dismissed_at, onboarding_completed_at ${cacheBuster} FROM public."user" WHERE id = $1`,
        [userId],
      ),
      pool.query(`SELECT * FROM public.get_user_profile_with_context($1) ${cacheBuster}`, [userId]),
    ]);

    const onboardingStatus = onboardingResult.rows[0] || null;
    const profileContext = profileResult.rows[0] || null;

    return c.json({
      session: session.session,
      user: session.user,
      onboardingStatus,
      profileContext,
    });
  } catch (error) {
    console.error("Error in /api/auth/me:", error);
    return c.json({ session: null, user: null, profileContext: null, onboardingStatus: null }, 500);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }
});

authRoutes.post("/onboarding/dismiss", async (c) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);

  try {
    const session = await auth.api.getSession({ headers: c.req.raw.headers });
    if (!session || !session.user) return c.json({ error: "Unauthorized" }, 401);

    const updateResult = await pool.query(
      'UPDATE public."user" SET onboarding_dismissed_at = NOW() WHERE id = $1',
      [session.user.id],
    );

    if (updateResult.rowCount === 0) {
      console.warn("No rows updated for user", session.user.id);
      return c.json({ error: "User profile not found" }, 404);
    }

    return c.json({ success: true });
  } catch (error) {
    console.error("Error in /onboarding/dismiss:", error);
    return c.json({ error: "Internal server error" }, 500);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }
});

import { z } from "zod";

const submitOnboardingSchema = z.object({
  campusId: z.number().int().positive(),
  academicUnitId: z.number().int().positive(),
  studyPlanId: z.number().int().positive(),
  entryYear: z.number().int().positive().nullable(),
  carnet: z.string().trim().nullable(),
});

authRoutes.post("/onboarding/submit", async (c) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);

  try {
    const session = await auth.api.getSession({ headers: c.req.raw.headers });
    if (!session || !session.user) return c.json({ error: "Unauthorized" }, 401);

    const body = await c.req.json();
    const parsed = submitOnboardingSchema.safeParse(body);
    if (!parsed.success) {
      return c.json({ error: "Invalid payload", details: parsed.error.issues }, 400);
    }
    const data = parsed.data;

    await pool.query("BEGIN");

    if (data.carnet) {
      await pool.query('UPDATE public."user" SET carnet = $1 WHERE id = $2', [
        data.carnet,
        session.user.id,
      ]);
    }

    const activePlanRes = await pool.query(
      "SELECT id FROM public.user_study_plan WHERE user_id = $1 AND is_active = true",
      [session.user.id],
    );

    if (activePlanRes.rows.length > 0) {
      await pool.query(
        `UPDATE public.user_study_plan
         SET study_plan_id = $1, campus_id = $2, entry_year = COALESCE($3, entry_year)
         WHERE id = $4`,
        [data.studyPlanId, data.campusId, data.entryYear, activePlanRes.rows[0].id],
      );
    } else {
      await pool.query(
        `INSERT INTO public.user_study_plan (user_id, study_plan_id, campus_id, entry_year)
         VALUES ($1, $2, $3, $4)`,
        [
          session.user.id,
          data.studyPlanId,
          data.campusId,
          data.entryYear || new Date().getFullYear(),
        ],
      );
    }

    await pool.query('UPDATE public."user" SET onboarding_completed_at = NOW() WHERE id = $1', [
      session.user.id,
    ]);

    await pool.query("COMMIT");

    return c.json({ success: true });
  } catch (error) {
    await pool.query("ROLLBACK").catch(() => {});
    console.error("Error in /onboarding/submit:", error);
    return c.json({ error: "Internal server error" }, 500);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }
});

authRoutes.on(["GET", "POST"], "/*", async (c) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);
  try {
    const response = await auth.handler(c.req.raw);
    if (!response) return c.notFound();
    return response;
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }
});

export default authRoutes;
