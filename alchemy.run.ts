import * as Alchemy from "alchemy";
import * as Cloudflare from "alchemy/Cloudflare";
import * as Config from "effect/Config";
import * as Effect from "effect/Effect";
import * as Redacted from "effect/Redacted";

export default Alchemy.Stack(
  "Claustrum",
  {
    providers: Cloudflare.providers(),
    state: Cloudflare.state(),
  },
  Effect.gen(function* () {
    const { stage } = yield* Alchemy.Stack;
    const isProd = stage === "prod";

    const appDomain = process.env.APP_DOMAIN;
    const zoneName = process.env.ZONE_NAME;

    const evaluationsBucket = yield* Cloudflare.R2.Bucket("claustrum-evaluations");

    const dbPassword = yield* Config.Redacted("DB_PASSWORD").pipe(
      Config.withDefault(Redacted.make("development-dummy-password")),
    );

    const hyperdrive = yield* Cloudflare.Hyperdrive.Connection("claustrum-db", {
      origin: {
        scheme: "postgresql",
        host: process.env.DB_HOST ?? "db.jxzkhfclcdpcgtkpyxyk.supabase.co",
        port: Number(process.env.DB_PORT ?? "5432"),
        database: process.env.DB_NAME ?? "postgres",
        user: process.env.DB_USER ?? "hyperdrive_user",
        password: dbPassword,
      },
      dev: {
        origin:
          process.env.LOCAL_DB_URL ?? "postgresql://postgres:postgres@127.0.0.1:54322/postgres",
      },
      caching: {
        disabled: true,
      },
    });

    const betterAuthSecret = yield* Config.Redacted("BETTER_AUTH_SECRET").pipe(
      Config.withDefault(Redacted.make("development-better-auth-secret")),
    );
    const turnstileSecret = yield* Config.Redacted("TURNSTILE_SECRET_KEY").pipe(
      Config.withDefault(Redacted.make("development-turnstile-secret")),
    );
    const resendApiKey = yield* Config.Redacted("RESEND_API_KEY").pipe(
      Config.withDefault(Redacted.make("development-resend-api-key")),
    );

    const apiWorker = yield* Cloudflare.Worker("claustrum-api", {
      main: "./apps/api/src/index.ts",
      compatibilityFlags: ["nodejs_compat"],
      observability: {
        logs: { enabled: true },
      },
      routes:
        isProd && appDomain && zoneName
          ? [
              {
                pattern: `${appDomain}/api/*`,
                zoneName,
              },
            ]
          : undefined,
      env: {
        HYPERDRIVE: hyperdrive,
        EVALUATIONS_BUCKET: evaluationsBucket,
        BETTER_AUTH_SECRET: betterAuthSecret,
        BETTER_AUTH_URL: process.env.BETTER_AUTH_URL ?? "https://claustrum.maugp.com",
        TURNSTILE_SECRET_KEY: turnstileSecret,
        RESEND_API_KEY: resendApiKey,
        CORS_ORIGINS: process.env.CORS_ORIGINS ?? "",
        GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID ?? "",
        GOOGLE_CLIENT_SECRET: process.env.GOOGLE_CLIENT_SECRET
          ? Redacted.make(process.env.GOOGLE_CLIENT_SECRET)
          : undefined,
      },
    });

    const webSite = yield* Cloudflare.Website.Vite("claustrum-web", {
      rootDir: "./apps/web",
      routes:
        isProd && appDomain && zoneName
          ? [
              {
                pattern: `${appDomain}/*`,
                zoneName,
              },
            ]
          : undefined,
      bindings: {
        API: apiWorker,
      },
      env: {
        VITE_TURNSTILE_SITE_KEY: process.env.VITE_TURNSTILE_SITE_KEY ?? "",
        VITE_API_BASE_URL: process.env.VITE_API_BASE_URL ?? "",
      },
    });

    return {
      apiUrl: apiWorker.url,
      webUrl: webSite.url,
    };
  }),
);
