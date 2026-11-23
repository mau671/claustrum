import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

function mainRepositoryRoot(): string | null {
  try {
    const commonDir = execFileSync(
      "git",
      ["rev-parse", "--path-format=absolute", "--git-common-dir"],
      {
        cwd: path.resolve(import.meta.dirname, ".."),
        encoding: "utf-8",
        stdio: ["ignore", "pipe", "ignore"],
      },
    ).trim();

    return commonDir ? path.dirname(commonDir) : null;
  } catch {
    return null;
  }
}

export function resolveEnvFilePath(filename: string): string | null {
  const repoRoot = path.resolve(import.meta.dirname, "..");
  const candidates: string[] = [];

  if (process.env.ENV_FILE) {
    candidates.push(path.resolve(process.env.ENV_FILE));
  }

  candidates.push(path.resolve(process.cwd(), filename), path.resolve(repoRoot, filename));

  // T3 task worktrees do not contain gitignored .env files; read the main
  // checkout's file instead of copying or linking secrets between trees.
  const mainRoot = mainRepositoryRoot();
  if (mainRoot) {
    candidates.push(path.resolve(mainRoot, filename));
  }

  for (const candidate of candidates) {
    if (fs.existsSync(candidate)) {
      return candidate;
    }
  }

  return null;
}

export function parseEnvFile(filePath: string): Record<string, string> {
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

export function loadDatabaseEnv(isProd: boolean): {
  connectionString: string | undefined;
  envFilePath: string | null;
  env: Record<string, string>;
} {
  const targetFile = isProd ? ".env.prod" : ".env.dev";
  const resolvedPath = resolveEnvFilePath(targetFile) || resolveEnvFilePath(".env");
  const env = resolvedPath ? parseEnvFile(resolvedPath) : {};

  // Export the file values to child processes without overriding the real environment.
  for (const [key, value] of Object.entries(env)) {
    if (process.env[key] === undefined) {
      process.env[key] = value;
    }
  }

  let connectionString = process.env.DATABASE_URL;
  if (!connectionString && env.DATABASE_URL) {
    connectionString = env.DATABASE_URL;
    process.env.DATABASE_URL = env.DATABASE_URL;
  }

  return {
    connectionString,
    envFilePath: resolvedPath,
    env,
  };
}
