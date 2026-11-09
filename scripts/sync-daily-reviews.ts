/* eslint-disable no-console */
import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

interface DailySyncOutput {
  status: string;
  new_reviews_count: number;
  affected_professors_count: number;
  affected_professors: Array<{
    professor_id: number;
    name: string;
    source_id: string;
    delta: number;
  }>;
  auto_matched_professors: Array<{
    professor_id: number;
    source_id: string;
    site_name: string;
    db_full_name: string;
    reason: string;
    delta: number;
  }>;
  seed_files: string[];
  new_profiles: Array<{
    source_professor_id: string;
    display_name: string;
    review_count: number;
    department: string;
  }>;
  unmatched_deltas: Array<{
    source_professor_id: string;
    display_name: string;
    prev_count: number;
    current_count: number;
    delta: number;
  }>;
  message?: string;
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

function runProcess(
  command: string,
  args: string[],
  cwd = process.cwd(),
  stdio: "inherit" | "pipe" = "pipe",
): Promise<{ stdout: string; stderr: string; code: number }> {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd,
      stdio: stdio === "inherit" ? "inherit" : ["ignore", "pipe", "pipe"],
      env: { ...process.env },
    });

    let stdout = "";
    let stderr = "";

    if (child.stdout) {
      child.stdout.on("data", (chunk: Buffer) => {
        stdout += chunk.toString("utf-8");
      });
    }

    if (child.stderr) {
      child.stderr.on("data", (chunk: Buffer) => {
        stderr += chunk.toString("utf-8");
      });
    }

    child.on("error", (err) => {
      reject(err);
    });

    child.on("close", (code) => {
      resolve({ stdout, stderr, code: code ?? 0 });
    });
  });
}

async function main(): Promise<void> {
  const rawArgs = process.argv.slice(2).filter((arg) => arg !== "--");
  const isProd = rawArgs.includes("--prod");
  const isDryRun = rawArgs.includes("--dry-run");
  const isNoOpenRouter = rawArgs.includes("--no-openrouter");
  const isSkipSummaries = rawArgs.includes("--skip-summaries");
  const isGitPush = rawArgs.includes("--git-push");

  console.log("================================================================================");
  console.log("🚀 MisProfesores Unified Daily Sync, Seeding & Summaries");
  console.log("================================================================================");
  console.log(
    `Target: ${isProd ? "PRODUCTION database (.env.prod)" : "LOCAL database (.env.dev)"}`,
  );
  if (isDryRun) {
    console.log("Mode:   DRY-RUN (preview only, no files downloaded or written to DB)");
  }
  console.log();

  if (isProd) {
    const prodEnvPath = path.resolve(process.cwd(), ".env.prod");
    const prodEnv = parseEnvFile(prodEnvPath);
    if (!prodEnv.DATABASE_URL && !process.env.DATABASE_URL) {
      console.error("❌ Error: No DATABASE_URL found in .env.prod");
      process.exit(1);
    }
    if (prodEnv.DATABASE_URL) {
      process.env.DATABASE_URL = prodEnv.DATABASE_URL;
    }
  } else {
    const devEnvPath = path.resolve(process.cwd(), ".env.dev");
    const devEnv = parseEnvFile(devEnvPath);
    if (devEnv.DATABASE_URL && !process.env.DATABASE_URL) {
      process.env.DATABASE_URL = devEnv.DATABASE_URL;
    }
  }

  const pythonArgs = ["run", "--directory", "data/reviews", "reviews-sync-daily", "--json"];

  if (isDryRun) {
    pythonArgs.push("--dry-run");
  }
  if (isNoOpenRouter) {
    pythonArgs.push("--no-openrouter");
  }

  console.log("🔍 Checking MisProfesores school directory and local snapshot...");
  const pythonRes = await runProcess("uv", pythonArgs);

  if (pythonRes.code !== 0) {
    console.error("❌ Python daily sync process failed:");
    console.error(pythonRes.stderr || pythonRes.stdout);
    process.exit(pythonRes.code || 1);
  }

  let syncResult: DailySyncOutput;
  try {
    syncResult = JSON.parse(pythonRes.stdout.trim()) as DailySyncOutput;
  } catch {
    console.error("❌ Failed to parse JSON response from daily sync:");
    console.error(pythonRes.stdout);
    process.exit(1);
  }

  if (syncResult.status === "error") {
    console.error(`❌ Error during sync: ${syncResult.message}`);
    process.exit(1);
  }

  // Report new profiles if any were discovered on MisProfesores
  if (syncResult.new_profiles && syncResult.new_profiles.length > 0) {
    console.log(
      `\n✨ Discovered ${syncResult.new_profiles.length} brand-new professor profiles on MisProfesores:`,
    );
    for (const np of syncResult.new_profiles) {
      console.log(
        `   • ${np.display_name} (ID: ${np.source_professor_id}, Dept: ${np.department}, Reviews: ${np.review_count})`,
      );
    }
  }

  // Report automatically matched professors
  if (syncResult.auto_matched_professors && syncResult.auto_matched_professors.length > 0) {
    console.log(
      `\n🎉 Successfully auto-matched ${syncResult.auto_matched_professors.length} previously unmatched professor(s):`,
    );
    for (const m of syncResult.auto_matched_professors) {
      console.log(
        `   • ${m.site_name} -> ${m.db_full_name} (ID: ${m.professor_id}, Reason: ${m.reason})`,
      );
    }
  }

  // Report remaining unmatched profiles with new activity
  if (syncResult.unmatched_deltas && syncResult.unmatched_deltas.length > 0) {
    console.log(
      `\n⚠️  Found ${syncResult.unmatched_deltas.length} unmatched profiles with new reviews (still ambiguous):`,
    );
    for (const ud of syncResult.unmatched_deltas) {
      console.log(
        `   • ${ud.display_name} (Source: ${ud.source_professor_id}, +${ud.delta} review(s), total: ${ud.current_count})`,
      );
    }
  }

  // Report affected professors
  if (syncResult.affected_professors && syncResult.affected_professors.length > 0) {
    console.log(
      `\n📋 Found ${syncResult.affected_professors_count} professor(s) with new reviews:`,
    );
    for (const prof of syncResult.affected_professors) {
      console.log(`   • Prof ${prof.professor_id} (${prof.name}): +${prof.delta} new review(s)`);
    }
  } else {
    console.log("\n✅ All reviews are up-to-date! No new reviews found on MisProfesores for ITCR.");
  }

  // Apply review seed files if generated
  if (!isDryRun && syncResult.seed_files && syncResult.seed_files.length > 0) {
    console.log(
      `\n🌱 Applying ${syncResult.seed_files.length} newly generated SQL review seed(s) to database...`,
    );
    const seedArgs = ["scripts/seed.ts", "--reviews"];
    if (isProd) {
      seedArgs.push("--prod");
    }

    const seedRes = await runProcess(
      "pnpm",
      ["exec", "tsx", ...seedArgs],
      process.cwd(),
      "inherit",
    );
    if (seedRes.code !== 0) {
      console.error("\n❌ Error applying review seeds to database.");
      process.exit(seedRes.code);
    }
    console.log("✅ Review seeds applied successfully.");
  }

  // Phase: AI Review Summaries check & generation
  if (!isSkipSummaries) {
    console.log("\n🤖 Evaluating if any professors qualify for AI review summaries...");
    const summaryDir = path.resolve(process.cwd(), "data/seeds/review_summaries");
    const beforeFiles = fs.existsSync(summaryDir)
      ? new Set(fs.readdirSync(summaryDir))
      : new Set<string>();

    const summaryArgs = ["scripts/generate-review-summaries.ts"];
    if (isProd) summaryArgs.push("--prod");
    if (isDryRun) summaryArgs.push("--dry-run");

    const summaryRes = await runProcess(
      "pnpm",
      ["exec", "tsx", ...summaryArgs],
      process.cwd(),
      "inherit",
    );

    if (summaryRes.code !== 0) {
      console.error("⚠️ Summaries generation encountered an error (continuing).");
    } else if (!isDryRun && fs.existsSync(summaryDir)) {
      const afterFiles = new Set(fs.readdirSync(summaryDir));
      const newSummaryFiles = [...afterFiles].filter(
        (f) => !beforeFiles.has(f) && f.endsWith(".sql"),
      );

      if (newSummaryFiles.length > 0) {
        console.log(
          `\n🌱 Applying ${newSummaryFiles.length} newly generated summary seed(s) to database...`,
        );
        const seedSummaryArgs = ["scripts/seed.ts", "--summaries"];
        if (isProd) seedSummaryArgs.push("--prod");

        const seedSummaryRes = await runProcess(
          "pnpm",
          ["exec", "tsx", ...seedSummaryArgs],
          process.cwd(),
          "inherit",
        );
        if (seedSummaryRes.code === 0) {
          console.log("✅ AI Summary seeds applied successfully to database.");
        }
      }
    }
  }

  // Phase: Git Commit & Push (if requested)
  if (!isDryRun && isGitPush) {
    const statusRes = await runProcess("git", [
      "status",
      "--porcelain",
      "data/seeds/reviews",
      "data/seeds/review_summaries",
      "data/state/downloads/school_snapshot.json",
      "data/state/matching",
    ]);

    if (statusRes.stdout.trim().length > 0) {
      console.log("\n📦 Staging and committing newly generated seeds and snapshot...");
      await runProcess("git", [
        "add",
        "data/seeds/reviews",
        "data/seeds/review_summaries",
        "data/state/downloads/school_snapshot.json",
        "data/state/matching",
      ]);
      const commitRes = await runProcess("git", [
        "commit",
        "-m",
        "chore(reviews): sync daily reviews and summaries [skip ci]",
      ]);
      if (commitRes.code === 0) {
        console.log("🚀 Pushing changes to origin development...");
        const pushRes = await runProcess("git", ["push", "origin", "development"]);
        if (pushRes.code === 0) {
          console.log("✅ Changes successfully pushed to origin development.");
        } else {
          console.error("⚠️ Failed to push changes to remote repository:", pushRes.stderr);
        }
      }
    } else {
      console.log("\nℹ️  No new seed files or state changes to commit to git.");
    }
  }

  if (isDryRun) {
    console.log("\n✨ Dry run complete. No database changes or downloads performed.\n");
  } else {
    console.log("\n🎉 Unified daily synchronization cycle finished successfully!\n");
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
