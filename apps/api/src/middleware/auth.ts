import { createMiddleware } from "hono/factory";

import type { HonoEnv } from "../types";

import { getAuth, getDbPool } from "../lib/db";

export const optionalAuth = createMiddleware<HonoEnv>(async (c, next) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);

  try {
    const session = await auth.api.getSession({
      headers: c.req.raw.headers,
    });

    if (session?.user) {
      if (session.user.banned) {
        return c.json({ error: "Cuenta suspendida", reason: session.user.banReason }, 403);
      }
      c.set("user", session.user);
      c.set("session", session.session);
    }
  } catch (error) {
    console.error("Error evaluating optional session:", error);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }

  await next();
});

export const requireAuth = createMiddleware<HonoEnv>(async (c, next) => {
  const pool = getDbPool(c.env);
  const auth = getAuth(c.env, pool);

  try {
    const session = await auth.api.getSession({
      headers: c.req.raw.headers,
    });

    if (!session || !session.user) {
      return c.json({ error: "No autorizado" }, 401);
    }

    if (session.user.banned) {
      return c.json({ error: "Cuenta suspendida", reason: session.user.banReason }, 403);
    }

    c.set("user", session.user);
    c.set("session", session.session);
  } catch (error) {
    console.error("Error evaluating required session:", error);
    return c.json({ error: "Error de autenticación" }, 500);
  } finally {
    c.executionCtx.waitUntil(pool.end());
  }

  await next();
});

export function requireRole(allowedRoles: string | string[]) {
  const rolesList = Array.isArray(allowedRoles) ? allowedRoles : [allowedRoles];

  return createMiddleware<HonoEnv>(async (c, next) => {
    const user = c.get("user");
    if (!user) {
      return c.json({ error: "No autorizado" }, 401);
    }

    const userRole = user.role ?? "user";
    const userRoles = userRole.split(",").map((r) => r.trim());
    const hasPermission = userRoles.some((r) => rolesList.includes(r));

    if (!hasPermission) {
      return c.json({ error: "Acceso denegado: permisos insuficientes" }, 403);
    }

    await next();
  });
}
