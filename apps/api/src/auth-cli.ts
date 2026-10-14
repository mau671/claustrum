import { Pool } from "pg";

import { createAuth, type AuthEnv } from "./auth";

function getEnvValue(name: string, fallback?: string): string | undefined {
  const value = process.env[name];
  return value && value.trim() !== "" ? value : fallback;
}

function readCliEnv(): AuthEnv {
  return {
    DATABASE_URL: getEnvValue(
      "DATABASE_URL",
      "postgres://postgres:postgres@localhost:54322/postgres",
    )!,
    BETTER_AUTH_SECRET: getEnvValue(
      "BETTER_AUTH_SECRET",
      "development-better-auth-secret-change-me-32-chars",
    )!,
    BETTER_AUTH_URL: getEnvValue("BETTER_AUTH_URL", "http://localhost:8787")!,
    GOOGLE_CLIENT_ID: getEnvValue("GOOGLE_CLIENT_ID"),
    GOOGLE_CLIENT_SECRET: getEnvValue("GOOGLE_CLIENT_SECRET"),
    RESEND_API_KEY: getEnvValue("RESEND_API_KEY"),
    CORS_ORIGINS: getEnvValue("CORS_ORIGINS"),
  };
}

const env = readCliEnv();

const pool = new Pool({
  connectionString: env.DATABASE_URL,
  options: "-c search_path=better_auth,public",
});

export const auth = createAuth(env, pool);
