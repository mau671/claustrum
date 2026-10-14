import type { Session, User } from "better-auth";

import type { AuthEnv } from "./auth";

export interface Env extends AuthEnv {
  HYPERDRIVE?: Hyperdrive;
  EVALUATIONS_BUCKET: R2Bucket;
  TURNSTILE_SECRET_KEY: string;
  CORS_ORIGINS?: string;
}

export type AuthUser = User & {
  role?: string;
  banned?: boolean;
  banReason?: string | null;
  banExpires?: Date | null;
};

export type AppVariables = {
  user?: AuthUser;
  session?: Session;
};

export type HonoEnv = {
  Bindings: Env;
  Variables: AppVariables;
};
