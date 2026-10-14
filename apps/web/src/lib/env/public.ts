import { z } from "zod";

const publicEnvSchema = z.object({
  VITE_TURNSTILE_SITE_KEY: z.string().min(1).optional(),
  VITE_API_BASE_URL: z.string().url().optional(),
});

function formatZodError(prefix: string, error: z.ZodError): string {
  const details = error.issues
    .map((i) => {
      const p = i.path.length ? i.path.join(".") : "(root)";
      return `- ${p}: ${i.message}`;
    })
    .join("\n");
  return `${prefix}\n${details}`;
}

let cachedPublicEnv: z.infer<typeof publicEnvSchema> | null = null;

export function getPublicEnv(): z.infer<typeof publicEnvSchema> {
  if (cachedPublicEnv) return cachedPublicEnv;

  if (typeof import.meta === "undefined" || typeof import.meta.env === "undefined") {
    throw new Error("Environment variables not available in this runtime");
  }

  const parsed = publicEnvSchema.safeParse(import.meta.env);
  if (!parsed.success) {
    throw new Error(formatZodError("Invalid public environment variables:", parsed.error));
  }

  cachedPublicEnv = parsed.data;
  return parsed.data;
}

export function getTurnstileSiteKey(): string | null {
  try {
    const env = getPublicEnv();
    if (env.VITE_TURNSTILE_SITE_KEY) return env.VITE_TURNSTILE_SITE_KEY;
  } catch {
    // fallback if import.meta.env validation fails
  }
  if (typeof process !== "undefined" && process.env?.VITE_TURNSTILE_SITE_KEY) {
    return process.env.VITE_TURNSTILE_SITE_KEY;
  }
  return null;
}

export function getApiBaseUrl(): string | null {
  const env = getPublicEnv();
  return env.VITE_API_BASE_URL ?? null;
}
