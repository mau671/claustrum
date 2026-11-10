import { execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

export function resolveEnvFilePath(filename: string): string | null {
  const directPath = path.resolve(process.cwd(), filename);
  if (fs.existsSync(directPath)) {
    return directPath;
  }

  // If in a git worktree, resolve the main repository root
  try {
    const gitCommonDir = execSync("git rev-parse --git-common-dir", {
      encoding: "utf-8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();

    if (gitCommonDir) {
      const mainRepoRoot = path.isAbsolute(gitCommonDir)
        ? path.dirname(gitCommonDir)
        : path.resolve(process.cwd(), path.dirname(gitCommonDir));
      const candidatePath = path.join(mainRepoRoot, filename);

      if (fs.existsSync(candidatePath)) {
        // Create symlink in the current worktree for seamless access by child processes
        try {
          fs.symlinkSync(candidatePath, directPath);
        } catch {
          // Ignore error if symlink already exists or filesystem is read-only
        }
        return candidatePath;
      }
    }
  } catch {
    // Git command failed or not inside a git repository
  }

  // Check parent directories as fallback
  let current = path.dirname(process.cwd());
  while (current !== path.dirname(current)) {
    const candidate = path.join(current, filename);
    if (fs.existsSync(candidate)) {
      try {
        fs.symlinkSync(candidate, directPath);
      } catch {
        // Ignore symlink failure
      }
      return candidate;
    }
    if (fs.existsSync(path.join(current, ".git"))) {
      break;
    }
    current = path.dirname(current);
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
