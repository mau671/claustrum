import * as Context from "effect/Context";
import * as Effect from "effect/Effect";

import { ForbiddenError, UnauthorizedError } from "./Users";

export interface AuthUser {
  readonly id: string;
  readonly email: string;
  readonly name: string;
  readonly role?: string | null;
  readonly banned?: boolean;
  readonly banReason?: string | null;
  readonly banExpires?: Date | null;
  readonly emailVerified?: boolean;
  readonly image?: string | null;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export class CurrentUser extends Context.Service<CurrentUser, AuthUser | null>()(
  "claustrum/CurrentUser",
) {}

export const checkAuth = (
  user: AuthUser | null | undefined,
): Effect.Effect<AuthUser, UnauthorizedError | ForbiddenError> => {
  if (!user) {
    return Effect.fail(new UnauthorizedError({ error: "No autorizado" }));
  }
  if (user.banned) {
    return Effect.fail(
      new ForbiddenError({
        error: "Cuenta suspendida",
        reason: user.banReason ?? null,
      }),
    );
  }
  return Effect.succeed(user);
};

export const checkRole = (
  user: AuthUser,
  allowedRoles: readonly string[],
): Effect.Effect<AuthUser, ForbiddenError> => {
  const userRoles = (user.role ?? "user").split(",").map((r) => r.trim());

  const hasAccess = userRoles.some((r) => allowedRoles.includes(r));
  if (!hasAccess) {
    return Effect.fail(
      new ForbiddenError({
        error: "Acceso denegado: permisos insuficientes",
      }),
    );
  }

  return Effect.succeed(user);
};
