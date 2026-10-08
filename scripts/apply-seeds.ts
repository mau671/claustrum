import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import pg from "pg";

const { Pool } = pg;

interface SeedMeta {
  scope: string;
  years: number[];
  termExternalKeys: string[];
}

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

function parseSeedMetadata(content: string, defaultScope: string): SeedMeta {
  let scope = defaultScope;
  let years: number[] = [];
  let termExternalKeys: string[] = [];

  for (const line of content.split("\n")) {
    if (!line.startsWith("-- TEC-DATA-META ")) {
      if (line.trim().length > 0 && !line.startsWith("--")) {
        // Stop scanning after header comments
        break;
      }
      continue;
    }
    const meta = line.slice("-- TEC-DATA-META ".length).trim();
    const [key, ...rest] = meta.split("=");
    const val = rest.join("=").trim();

    if (key === "scope" && val) {
      scope = val;
    } else if (key === "years" && val) {
      years = val
        .split(",")
        .map((s) => parseInt(s.trim(), 10))
        .filter((n) => !Number.isNaN(n));
    } else if (key === "term_external_keys" && val) {
      termExternalKeys = val
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
    }
  }

  return { scope, years, termExternalKeys };
}

async function main() {
  const args = process.argv.slice(2);
  const isProd = args.includes("--prod");
  const isReviews = args.includes("--reviews");
  const isDryRun = args.includes("--dry-run");

  const dirArgIndex = args.indexOf("--dir");
  let targetDir =
    dirArgIndex !== -1 && args[dirArgIndex + 1]
      ? args[dirArgIndex + 1]
      : isReviews
        ? "data/reviews/data/processed/sql"
        : "supabase/seeds/tec-data";

  let connectionString = process.env.DATABASE_URL;

  if (isProd) {
    const prodEnvPath = path.resolve(process.cwd(), ".env.production.local");
    const prodEnv = parseEnvFile(prodEnvPath);
    connectionString = connectionString || prodEnv.DATABASE_URL;
    if (!connectionString) {
      console.error("❌ Error: No DATABASE_URL found for production. Check .env.production.local");
      process.exit(1);
    }
    console.log("🚀 Targeting PRODUCTION database (Supabase Pooler)");
  } else {
    connectionString =
      connectionString || "postgresql://postgres:postgres@127.0.0.1:54322/postgres";
    console.log("💻 Targeting LOCAL database (127.0.0.1:54322)");
  }

  const resolvedDir = path.resolve(process.cwd(), targetDir);
  if (!fs.existsSync(resolvedDir)) {
    console.error(`❌ Error: Seed directory not found: ${resolvedDir}`);
    process.exit(1);
  }

  const files = fs
    .readdirSync(resolvedDir)
    .filter((f) => f.endsWith(".sql"))
    .sort();

  if (files.length === 0) {
    console.log(`ℹ️ No .sql seed files found in ${targetDir}`);
    return;
  }

  console.log(`📁 Scanning ${files.length} seed files in ${targetDir}...`);

  const pool = new Pool({
    connectionString,
    connectionTimeoutMillis: 10000,
  });

  const client = await pool.connect();

  try {
    // 1. Fetch already applied seed SHAs
    const { rows: appliedRows } = await client.query<{ seed_sha256: string }>(
      "SELECT seed_sha256 FROM public.sync_seed_run WHERE status = 'applied';",
    );
    const appliedShas = new Set(appliedRows.map((r) => r.seed_sha256));
    console.log(`🔍 Found ${appliedShas.size} already applied seed SHAs in database.`);

    let appliedCount = 0;
    let skippedCount = 0;

    for (const file of files) {
      const fullPath = path.join(resolvedDir, file);
      const content = fs.readFileSync(fullPath, "utf-8");
      const sha = crypto.createHash("sha256").update(content).digest("hex");

      if (appliedShas.has(sha)) {
        console.log(`  [skip] ${file}`);
        skippedCount++;
        continue;
      }

      if (isDryRun) {
        console.log(`  [dry-run] Would apply ${file} (sha: ${sha.slice(0, 10)}...)`);
        appliedCount++;
        continue;
      }

      const defaultScope = isReviews ? "reviews" : "all";
      const { scope, years, termExternalKeys } = parseSeedMetadata(content, defaultScope);

      console.log(`  [apply] ${file} (scope: ${scope})...`);
      const startTime = Date.now();

      try {
        await client.query("BEGIN;");
        await client.query(content);
        await client.query(
          `INSERT INTO public.sync_seed_run (
            seed_file_name,
            seed_sha256,
            scope,
            years,
            term_external_keys,
            generated_at_utc,
            applied_at_utc,
            status,
            metadata
          ) VALUES ($1, $2, $3, $4, $5, NOW(), NOW(), 'applied', '{}'::jsonb)
          ON CONFLICT (seed_sha256) DO UPDATE SET
            seed_file_name = EXCLUDED.seed_file_name,
            scope = EXCLUDED.scope,
            years = EXCLUDED.years,
            term_external_keys = EXCLUDED.term_external_keys,
            applied_at_utc = NOW(),
            status = 'applied',
            error_message = NULL,
            updated_at = NOW();`,
          [file, sha, scope, years, termExternalKeys],
        );
        await client.query("COMMIT;");
        const elapsed = ((Date.now() - startTime) / 1000).toFixed(2);
        console.log(`  [ok]    ${file} in ${elapsed}s`);
        appliedCount++;
        appliedShas.add(sha);
      } catch (err: unknown) {
        await client.query("ROLLBACK;");
        const message = err instanceof Error ? err.message : String(err);
        console.error(`\n❌ Error applying seed ${file}:`, message);

        // Record failure in sync_seed_run
        try {
          await client.query(
            `INSERT INTO public.sync_seed_run (
              seed_file_name,
              seed_sha256,
              scope,
              years,
              term_external_keys,
              generated_at_utc,
              status,
              error_message,
              metadata
            ) VALUES ($1, $2, $3, $4, $5, NOW(), 'failed', $6, '{}'::jsonb)
            ON CONFLICT (seed_sha256) DO UPDATE SET
              status = 'failed',
              error_message = EXCLUDED.error_message,
              updated_at = NOW();`,
            [file, sha, scope, years, termExternalKeys, message],
          );
        } catch {
          // ignore tracking error on failure
        }
        process.exit(1);
      }
    }

    console.log(
      `\n✨ Finished! Applied: ${appliedCount}, Skipped: ${skippedCount}, Total: ${files.length}`,
    );
  } finally {
    client.release();
    await pool.end();
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
