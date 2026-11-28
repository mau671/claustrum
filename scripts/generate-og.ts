/* eslint-disable no-console */
import { spawn } from "node:child_process";
import fs from "node:fs/promises";
import { createRequire } from "node:module";
import path from "node:path";
import { pathToFileURL } from "node:url";

const require = createRequire(import.meta.url);
const webRoot = path.resolve(import.meta.dirname, "..", "apps", "web");
const playwrightEntry = require.resolve("playwright", { paths: [webRoot] });
const playwright = await import(pathToFileURL(playwrightEntry).href);
const { chromium } = playwright.default ?? playwright;

const PORT = 5173;
const URL = `http://127.0.0.1:${PORT}`;

async function waitForServer() {
  const deadline = Date.now() + 60_000;
  while (Date.now() < deadline) {
    try {
      const response = await fetch(URL);
      if (response.ok) {
        console.log("Dev server is ready.");
        return;
      }
    } catch {
      // Server is not accepting connections yet.
    }
    await new Promise((resolve) => setTimeout(resolve, 500));
  }
  throw new Error("Timed out waiting for the Vite dev server");
}

async function main() {
  const ogDir = path.join(webRoot, "public/og");
  await fs.mkdir(ogDir, { recursive: true });

  console.log("Starting Vite dev server...");
  const server = spawn(
    "pnpm",
    ["exec", "vite", "dev", "--port", PORT.toString(), "--host", "127.0.0.1", "--strictPort"],
    {
      cwd: webRoot,
      stdio: "inherit",
      detached: true,
    },
  );

  try {
    await waitForServer();

    console.log("Launching Chromium...");
    const browser = await chromium.launch({ headless: true });

    // Create a context with dark color scheme and standard OG size
    const context = await browser.newContext({
      viewport: { width: 1200, height: 630 },
      colorScheme: "dark",
      deviceScaleFactor: 1, // Standard OG size (1200x630)
    });

    const page = await context.newPage();

    const routes = [
      { path: "/og/schedule", output: "og-schedule.png" },
      { path: "/og/professors", output: "og-professors.png" },
      { path: "/og/curriculum", output: "og-curriculum.png" },
      { path: "/og/evaluations", output: "og-evaluations.png" },
    ];

    for (const route of routes) {
      console.log(`Navigating to ${route.path}...`);
      await page.goto(`${URL}${route.path}`, { waitUntil: "networkidle" });

      // Wait a bit extra for fonts and animations to settle
      await page.waitForTimeout(2000);

      const outputPath = path.join(ogDir, route.output);
      console.log(`Taking screenshot for ${route.output}...`);
      await page.screenshot({ path: outputPath });
      console.log(`Saved ${route.output}`);
    }

    await browser.close();
  } catch (err) {
    console.error("Error generating OG images:", err);
  } finally {
    console.log("Cleaning up server...");
    process.kill(-server.pid!);
  }
}

main().catch(console.error);
