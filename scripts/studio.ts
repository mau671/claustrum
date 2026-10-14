/* eslint-disable no-console */
import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

function parseEnvFile(filePath: string): Record<string, string> {
  if (!fs.existsSync(filePath)) {
    return {};
  }
  const content = fs.readFileSync(filePath, "utf-8");
  const env: Record<string, string> = {};
  for (const rawLine of content.split("\n")) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const eqIdx = line.indexOf("=");
    if (eqIdx !== -1) {
      const key = line.slice(0, eqIdx).trim();
      let val = line.slice(eqIdx + 1).trim();
      if (
        (val.startsWith('"') && val.endsWith('"')) ||
        (val.startsWith("'") && val.endsWith("'"))
      ) {
        val = val.slice(1, -1);
      }
      env[key] = val;
    }
  }
  return env;
}

function main(): void {
  const args = process.argv.slice(2);
  const isProd = args.includes("--prod");

  let databaseUrl = process.env.DATABASE_URL;

  if (isProd) {
    const prodEnvPath = fs.existsSync(path.resolve(process.cwd(), ".env.prod"))
      ? path.resolve(process.cwd(), ".env.prod")
      : path.resolve(process.cwd(), ".env.production.local");
    const prodEnv = parseEnvFile(prodEnvPath);
    databaseUrl = databaseUrl || prodEnv.DATABASE_URL;
    if (!databaseUrl) {
      console.error("❌ Error: No DATABASE_URL found for production. Check .env.prod");
      process.exit(1);
    }
    console.log("🚀 Launching Drizzle Studio for PRODUCTION database...");
  } else {
    const devEnvPath = fs.existsSync(path.resolve(process.cwd(), ".env.dev"))
      ? path.resolve(process.cwd(), ".env.dev")
      : path.resolve(process.cwd(), ".env.local");
    const devEnv = parseEnvFile(devEnvPath);
    databaseUrl =
      databaseUrl ||
      devEnv.DATABASE_URL ||
      "postgresql://postgres:postgres@127.0.0.1:54322/postgres";
    console.log("💻 Launching Drizzle Studio for LOCAL database (127.0.0.1:54322)...");
  }

  const forwardedArgs = args.filter((arg) => arg !== "--prod" && arg !== "--");

  const child = spawn("pnpm", ["exec", "drizzle-kit", "studio", ...forwardedArgs], {
    env: {
      ...process.env,
      DATABASE_URL: databaseUrl,
    },
    stdio: "inherit",
  });

  child.on("exit", (code) => {
    process.exit(code ?? 0);
  });

  child.on("error", (err: unknown) => {
    const message = err instanceof Error ? err.message : String(err);
    console.error("❌ Failed to start Drizzle Studio:", message);
    process.exit(1);
  });
}

main();
