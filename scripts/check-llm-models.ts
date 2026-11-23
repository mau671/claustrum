/* eslint-disable no-console */
import { execFileSync } from "node:child_process";

import { loadDatabaseEnv } from "./env.ts";
import {
  DEFAULT_SUMMARY_AGENT,
  DEFAULT_SUMMARY_MODEL,
  courseMatchModels,
  summaryModel,
} from "./llm-config.ts";

const OPENROUTER_MODELS_URL = "https://openrouter.ai/api/v1/models";
const OPENROUTER_CHAT_URL =
  process.env.OPENROUTER_API_URL ?? "https://openrouter.ai/api/v1/chat/completions";
const isProd = process.argv.includes("--prod");
const skipRun = process.argv.includes("--no-run");

interface ModelCatalogEntry {
  id: string;
}

async function checkOpenRouter(): Promise<boolean> {
  const models = courseMatchModels();
  console.log(`\nOpenRouter course-matching models (${models.length}):`);

  let catalog: Set<string>;
  try {
    const response = await fetch(OPENROUTER_MODELS_URL);
    const payload = (await response.json()) as { data: ModelCatalogEntry[] };
    catalog = new Set(payload.data.map((entry) => entry.id));
  } catch (error) {
    console.error("  Could not read the OpenRouter catalog:", error);
    return false;
  }

  const apiKey = process.env.OPENROUTER_API_KEY;
  if (!apiKey) {
    console.warn("  OPENROUTER_API_KEY is not set; only catalog presence was checked.");
  }

  let allPresent = true;
  for (const model of models) {
    if (!catalog.has(model)) {
      allPresent = false;
      console.log(`  MISS ${model} (not in the OpenRouter catalog)`);
      continue;
    }

    if (!apiKey || skipRun) {
      console.log(`  OK   ${model} (present in the catalog)`);
      continue;
    }

    const started = Date.now();
    try {
      const response = await fetch(OPENROUTER_CHAT_URL, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${apiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model,
          temperature: 0,
          max_tokens: 80,
          messages: [
            {
              role: "user",
              content: 'Devuelve solo este JSON sin markdown: {"ok":true,"curso":"FISICA I"}',
            },
          ],
        }),
        signal: AbortSignal.timeout(30000),
      });
      const elapsed = Date.now() - started;
      if (!response.ok) {
        const body = await response.text();
        console.log(
          `  WARN ${model} (HTTP ${response.status} after ${elapsed}ms: ${body.slice(0, 120)})`,
        );
        continue;
      }
      const payload = (await response.json()) as {
        choices?: Array<{ message?: { content?: string } }>;
      };
      const content = payload.choices?.[0]?.message?.content?.trim() ?? "";
      const objectMatch = content.match(/\{[\s\S]*\}/);
      let jsonOk = false;
      if (objectMatch) {
        try {
          JSON.parse(objectMatch[0]);
          jsonOk = true;
        } catch {
          jsonOk = false;
        }
      }
      console.log(
        `  ${jsonOk ? "OK  " : "WARN"} ${model} (${elapsed}ms, JSON ${jsonOk ? "valid" : "invalid"}${content ? "" : ", empty content"})`,
      );
    } catch (error) {
      const elapsed = Date.now() - started;
      console.log(
        `  WARN ${model} (request failed after ${elapsed}ms: ${String(error).slice(0, 120)})`,
      );
    }
  }

  return allPresent;
}

function checkOpenCode(): boolean {
  const model = summaryModel();
  const bin = process.env.OPENCODE_BIN ?? "opencode";
  console.log(`\nOpenCode summary model: ${model}`);

  let listing: string;
  try {
    listing = execFileSync(bin, ["models"], { encoding: "utf-8", timeout: 30000 });
  } catch (error) {
    console.error(`  Could not run '${bin} models':`, error);
    return false;
  }

  const available = new Set(listing.split(/\s+/).filter(Boolean));
  if (!available.has(model)) {
    console.log(`  MISS ${model} (not in the opencode catalog)`);
    console.log(
      "       Connect the opencode provider (opencode auth login) or set REVIEW_SUMMARY_MODEL.",
    );
    return false;
  }

  if (skipRun) {
    console.log(`  OK   ${model} (present in the catalog)`);
    return true;
  }

  try {
    const started = Date.now();
    const output = execFileSync(
      bin,
      [
        "run",
        "--agent",
        DEFAULT_SUMMARY_AGENT,
        "--model",
        model,
        "--format",
        "json",
        "Responde solo: ok",
      ],
      { encoding: "utf-8", timeout: 90000 },
    );
    const elapsed = Date.now() - started;
    console.log(`  OK   ${model} (responded in ${elapsed}ms, ${output.trim().length} bytes)`);
    return true;
  } catch (error) {
    console.log(
      `  WARN ${model} (listed, but the test run failed: ${String(error).slice(0, 160)})`,
    );
    return true;
  }
}

async function main(): Promise<void> {
  loadDatabaseEnv(isProd);
  console.log(
    `Checking LLM configuration against ${isProd ? ".env.prod" : ".env.dev"}${skipRun ? " (catalog only)" : ""}`,
  );

  const openRouterOk = await checkOpenRouter();
  const openCodeOk = checkOpenCode();

  console.log(`\nSummary default: ${DEFAULT_SUMMARY_MODEL}`);

  if (!openRouterOk || !openCodeOk) {
    process.exit(1);
  }
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
