import bcrypt from "bcryptjs";
import { betterAuth } from "better-auth";
import { APIError, createAuthMiddleware } from "better-auth/api";
import { magicLink, twoFactor, openAPI, lastLoginMethod, admin } from "better-auth/plugins";
import { Pool } from "pg";
import { Resend } from "resend";

import { renderAuthEmailTemplate } from "./email-templates";
import { ac, roles } from "./lib/auth/permissions";
import { isDisposableEmail, normalizeEmail } from "./lib/email-validation";

export interface AuthEnv {
  DATABASE_URL: string;
  BETTER_AUTH_SECRET: string;
  BETTER_AUTH_URL: string;
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

function getSocialProviders(env: AuthEnv) {
  if (!env.GOOGLE_CLIENT_ID || !env.GOOGLE_CLIENT_SECRET) return {};
  return {
    google: {
      clientId: env.GOOGLE_CLIENT_ID,
      clientSecret: env.GOOGLE_CLIENT_SECRET,
      prompt: "select_account" as const,
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

export function createAuth(env: AuthEnv, pool: Pool) {
  return betterAuth({
    appName: "Claustrum",
    baseURL: env.BETTER_AUTH_URL,
    secret: env.BETTER_AUTH_SECRET,
    database: pool,
    trustedOrigins: getTrustedOrigins(env),
    hooks: {
      before: createAuthMiddleware(async (ctx) => {
        if (ctx.body && typeof ctx.body === "object" && "email" in ctx.body) {
          if (typeof ctx.body.email === "string") {
            ctx.body.email = normalizeEmail(ctx.body.email);
          }
        }

        if (ctx.path === "/sign-up/email") {
          const email = typeof ctx.body?.email === "string" ? ctx.body.email : "";
          if (isDisposableEmail(email)) {
            throw new APIError("BAD_REQUEST", {
              message: "No se permiten correos electrónicos temporales o desechables.",
            });
          }

          const name = typeof ctx.body?.name === "string" ? ctx.body.name.trim() : "";
          if (!name || name.length < 2) {
            throw new APIError("BAD_REQUEST", {
              message: "Debes ingresar tu nombre completo (mínimo 2 caracteres).",
            });
          }
        }
      }),
    },
    emailAndPassword: {
      enabled: true,
      requireEmailVerification: true,
      customSyntheticUser: ({ coreFields, additionalFields, id }) => ({
        ...coreFields,
        role: "user",
        banned: false,
        banReason: null,
        banExpires: null,
        ...additionalFields,
        id,
      }),
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
    session: {
      cookieCache: {
        enabled: true,
        maxAge: 5 * 60,
      },
    },
    advanced: {
      useSecureCookies: env.BETTER_AUTH_URL.startsWith("https://"),
      ipAddress: {
        ipAddressHeaders: ["cf-connecting-ip", "x-real-ip", "x-forwarded-for"],
      },
      database: {
        generateId: "uuid",
        joins: true,
      },
    },
    plugins: [
      openAPI(),
      lastLoginMethod({
        storeInDatabase: true,
        customResolveMethod: (ctx) => {
          if (ctx.path === "/magic-link/verify") {
            return "magic-link";
          }
          return null;
        },
      }),
      magicLink({
        disableSignUp: true,
        expiresIn: 600,
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
      admin({
        ac,
        roles,
        defaultRole: "user",
      }),
    ],
  });
}
