import bcrypt from "bcryptjs";
import { betterAuth } from "better-auth";
import { magicLink, twoFactor, jwt, openAPI, lastLoginMethod } from "better-auth/plugins";
import { importJWK, SignJWT, type JWK, type JWTPayload } from "jose";
import { Pool } from "pg";
import { Resend } from "resend";

import { renderAuthEmailTemplate } from "./email-templates";

export interface AuthEnv {
  DATABASE_URL: string;
  BETTER_AUTH_SECRET: string;
  BETTER_AUTH_URL: string;
  SUPABASE_URL: string;
  SUPABASE_JWT_PRIVATE_JWK?: string;
  SUPABASE_JWT_KEY_ID?: string;
  GOOGLE_CLIENT_ID?: string;
  GOOGLE_CLIENT_SECRET?: string;
  RESEND_API_KEY?: string;
  CORS_ORIGINS?: string;
}

type AuthEmailType = "email-verification" | "magic-link" | "reset-password";

async function sendAuthEmail(
  env: AuthEnv,
  payload: { to: string; subject: string; url: string; type: AuthEmailType },
): Promise<void> {
  if (!env.RESEND_API_KEY) {
    throw new Error("RESEND_API_KEY is required to send auth emails");
  }

  const resend = new Resend(env.RESEND_API_KEY);
  const html = renderAuthEmailTemplate({ type: payload.type, email: payload.to, url: payload.url });
  const { error } = await resend.emails.send({
    from: "Claustrum <noreply@maugp.com>",
    to: [payload.to],
    subject: payload.subject,
    html,
    text: `Haz clic en el siguiente enlace para continuar: ${payload.url}`,
    tags: [{ name: "type", value: payload.type }],
  });

  if (error) {
    throw new Error(error.message);
  }
}

async function signSupabaseJwt(env: AuthEnv, payload: JWTPayload): Promise<string> {
  if (!env.SUPABASE_JWT_PRIVATE_JWK) {
    throw new Error("SUPABASE_JWT_PRIVATE_JWK is required to issue Supabase RLS tokens");
  }

  const jwk = JSON.parse(env.SUPABASE_JWT_PRIVATE_JWK) as JWK & { kid?: string };
  const { key_ops: _key_ops, ...importable } = jwk;
  const key = await importJWK({ ...importable, key_ops: ["sign"] }, "ES256");
  const kid = env.SUPABASE_JWT_KEY_ID ?? jwk.kid;
  if (!kid) {
    throw new Error("SUPABASE_JWT_KEY_ID or kid in SUPABASE_JWT_PRIVATE_JWK is required");
  }

  return await new SignJWT({ ...payload, role: "authenticated" })
    .setProtectedHeader({ alg: "ES256", kid, typ: "JWT" })
    .setIssuedAt()
    .setExpirationTime("15m")
    .sign(key);
}

function getSocialProviders(env: AuthEnv) {
  if (!env.GOOGLE_CLIENT_ID || !env.GOOGLE_CLIENT_SECRET) return {};
  return {
    google: {
      clientId: env.GOOGLE_CLIENT_ID,
      clientSecret: env.GOOGLE_CLIENT_SECRET,
      prompt: "select_account",
    },
  };
}

function getTrustedOrigins(env: AuthEnv): string[] {
  return [
    env.BETTER_AUTH_URL,
    ...(env.CORS_ORIGINS?.split(",")
      .map((value) => value.trim())
      .filter(Boolean) ?? []),
  ];
}

export function createAuth(env: AuthEnv, pool: Pool): ReturnType<typeof betterAuth> {
  return betterAuth({
    appName: "Claustrum",
    baseURL: env.BETTER_AUTH_URL,
    secret: env.BETTER_AUTH_SECRET,
    database: pool,
    trustedOrigins: getTrustedOrigins(env),
    emailAndPassword: {
      enabled: true,
      requireEmailVerification: true,
      password: {
        hash: async (password) => await bcrypt.hash(password, 10),
        verify: async ({ hash, password }) => await bcrypt.compare(password, hash),
      },
      sendResetPassword: async ({ user, url }) => {
        await sendAuthEmail(env, {
          to: user.email,
          subject: "Restablece tu contraseña en Claustrum",
          url,
          type: "reset-password",
        });
      },
    },
    emailVerification: {
      sendOnSignUp: true,
      autoSignInAfterVerification: true,
      sendVerificationEmail: async ({ user, url }) => {
        await sendAuthEmail(env, {
          to: user.email,
          subject: "Confirma tu correo para activar tu cuenta en Claustrum",
          url,
          type: "email-verification",
        });
      },
    },
    socialProviders: getSocialProviders(env),
    user: {
      additionalFields: {
        userMetadata: { type: "json", required: false, input: false },
        appMetadata: { type: "json", required: false, input: false },
        invitedAt: { type: "date", required: false, input: false },
        lastSignInAt: { type: "date", required: false, input: false },
      },
    },
    advanced: {
      useSecureCookies: env.BETTER_AUTH_URL.startsWith("https://"),
      ipAddress: {
        ipAddressHeaders: ["cf-connecting-ip", "x-real-ip", "x-forwarded-for"],
      },
      database: {
        generateId: "uuid",
      },
    },
    plugins: [
      openAPI(),
      lastLoginMethod(),
      magicLink({
        sendMagicLink: async ({ email, url }) => {
          await sendAuthEmail(env, {
            to: email,
            subject: "Tu enlace para iniciar sesión en Claustrum",
            url,
            type: "magic-link",
          });
        },
      }),
      twoFactor({
        issuer: "Claustrum",
        allowPasswordless: true,
      }),
      jwt({
        jwks: {
          remoteUrl: `${env.SUPABASE_URL}/auth/v1/.well-known/jwks.json`,
          keyPairConfig: {
            alg: "ES256",
          },
        },
        jwt: {
          audience: "authenticated",
          issuer: `${env.SUPABASE_URL}/auth/v1`,
          expirationTime: "15m",
          getSubject: (session) => session.user.id,
          definePayload: ({ user }) => ({
            email: user.email,
            role: "authenticated",
          }),
          sign: async (payload) => await signSupabaseJwt(env, payload),
        },
      }),
    ],
  });
}
