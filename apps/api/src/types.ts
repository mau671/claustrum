import type { AuthEnv } from "./auth";

export interface Env extends AuthEnv {
  HYPERDRIVE?: Hyperdrive;
  EVALUATIONS_BUCKET: R2Bucket;
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;
  SUPABASE_SECRET_KEY: string;
  TURNSTILE_SECRET_KEY: string;
  CORS_ORIGINS?: string;
}
