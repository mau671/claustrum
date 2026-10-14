/* eslint-disable no-console */
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import pg from "pg";

const { Pool } = pg;

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

async function main(): Promise<void> {
  const args = process.argv.slice(2).filter((arg) => arg !== "--");
  const isProd = args.includes("--prod");
  const isDryRun = args.includes("--dry-run");

  let connectionString = process.env.DATABASE_URL;

  if (isProd) {
    const prodEnvPath = path.resolve(process.cwd(), ".env.production.local");
    const prodEnv = parseEnvFile(prodEnvPath);
    connectionString = connectionString || prodEnv.DATABASE_URL;
    if (!connectionString) {
      console.error("❌ Error: No DATABASE_URL found for production. Check .env.production.local");
      process.exit(1);
    }
    console.log("🚀 Targeting PRODUCTION database");
  } else {
    connectionString =
      connectionString || "postgresql://postgres:postgres@127.0.0.1:54322/postgres";
    console.log("💻 Targeting LOCAL database (127.0.0.1:54322)");
  }

  const drizzleDir = path.resolve(process.cwd(), "drizzle");
  if (!fs.existsSync(drizzleDir)) {
    console.error(`❌ Error: Migration directory not found: ${drizzleDir}`);
    process.exit(1);
  }

  const files = fs
    .readdirSync(drizzleDir)
    .filter((f) => f.endsWith(".sql"))
    .sort();

  if (files.length === 0) {
    console.log("ℹ️ No .sql migration files found in drizzle directory.");
    return;
  }

  console.log(`📁 Scanning ${files.length} migration files in ${drizzleDir}...`);

  const pool = new Pool({
    connectionString,
    max: 1,
    connectionTimeoutMillis: 10000,
  });

  let client: pg.PoolClient;
  try {
    client = await pool.connect();
  } catch (error) {
    if (!isProd && (error as { code?: string })?.code === "ECONNREFUSED") {
      console.error(
        "❌ Error: Cannot connect to local database at 127.0.0.1:54322.\n   Please start the database with: pnpm run db:start\n",
      );
      process.exit(1);
    }
    throw error;
  }

  try {
    // 1. Ensure public.__drizzle_migrations table exists
    await client.query(`
      CREATE TABLE IF NOT EXISTS public.__drizzle_migrations (
        id SERIAL PRIMARY KEY,
        hash text NOT NULL,
        created_at bigint
      );
    `);

    // 2. Query already applied migrations
    const { rows: appliedRows } = await client.query<{ hash: string }>(
      "SELECT hash FROM public.__drizzle_migrations;",
    );
    const appliedHashes = new Set(appliedRows.map((r) => r.hash));

    // 3. Sync legacy Supabase migration history if present
    const { rows: legacyTableCheck } = await client.query<{ exists: boolean }>(`
      SELECT EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'supabase_migrations' AND table_name = 'schema_migrations'
      );
    `);

    if (legacyTableCheck[0]?.exists) {
      const { rows: legacyRows } = await client.query<{ version: string }>(
        "SELECT version FROM supabase_migrations.schema_migrations;",
      );
      const legacyVersions = new Set(legacyRows.map((r) => r.version));
      for (const file of files) {
        const versionPrefix = file.split("_")[0];
        if (versionPrefix && legacyVersions.has(versionPrefix)) {
          const fullPath = path.join(drizzleDir, file);
          const content = fs.readFileSync(fullPath, "utf-8");
          const hash = crypto.createHash("sha256").update(content).digest("hex");
          if (!appliedHashes.has(hash)) {
            appliedHashes.add(hash);
            appliedHashes.add(file);
            if (!isDryRun) {
              await client.query(
                "INSERT INTO public.__drizzle_migrations (hash, created_at) VALUES ($1, $2);",
                [hash, Date.now()],
              );
            }
          }
        }
      }
    }

    console.log(`🔍 Found ${appliedHashes.size} already applied migration entries in database.`);

    let appliedCount = 0;
    let skippedCount = 0;

    for (const file of files) {
      const fullPath = path.join(drizzleDir, file);
      const content = fs.readFileSync(fullPath, "utf-8");
      const hash = crypto.createHash("sha256").update(content).digest("hex");

      // Skip if either sha256 hash or filename is recorded
      if (appliedHashes.has(hash) || appliedHashes.has(file)) {
        skippedCount++;
        continue;
      }

      if (isDryRun) {
        console.log(`  [dry-run] Would apply ${file} (hash: ${hash.slice(0, 10)}...)`);
        appliedCount++;
        continue;
      }

      console.log(`  [apply] ${file}...`);
      const startTime = Date.now();

      try {
        await client.query("BEGIN;");
        await client.query(content);
        await client.query(
          "INSERT INTO public.__drizzle_migrations (hash, created_at) VALUES ($1, $2);",
          [hash, Date.now()],
        );
        await client.query("COMMIT;");
        const elapsed = ((Date.now() - startTime) / 1000).toFixed(2);
        console.log(`  [ok]    ${file} in ${elapsed}s`);
        appliedCount++;
        appliedHashes.add(hash);
      } catch (err: unknown) {
        try {
          await client.query("ROLLBACK;");
        } catch {
          // Ignore rollback error if transaction already aborted
        }
        const message = err instanceof Error ? err.message : String(err);
        console.error(`\n❌ Error applying migration ${file}:`, message);
        process.exit(1);
      }
    }

    if (isDryRun) {
      console.log(
        `\n✨ Dry run complete! Pending: ${appliedCount}, Skipped: ${skippedCount}, Total: ${files.length}`,
      );
    } else {
      console.log(
        `\n✨ Finished! Applied: ${appliedCount}, Skipped: ${skippedCount}, Total: ${files.length}`,
      );
    }
  } finally {
    client.release();
    await pool.end();
  }
}

main().catch((err: unknown) => {
  const message = err instanceof Error ? err.message : String(err);
  console.error("Fatal error:", message);
  process.exit(1);
});
