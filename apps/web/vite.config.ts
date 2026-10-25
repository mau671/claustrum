import { cloudflare } from "@cloudflare/vite-plugin";
import tailwindcss from "@tailwindcss/vite";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import viteReact from "@vitejs/plugin-react";
import mdx from "fumadocs-mdx/vite";
import { copyFileSync, existsSync } from "node:fs";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig, type Plugin } from "vite";

/**
 * Copies the PDFium WebAssembly binary shipped by `@embedpdf/pdfium` into the
 * public directory so the PDF viewer loads it from our own origin instead of a
 * third-party CDN. Keeps the 4.6 MB binary out of version control.
 */
function copyPdfiumWasm(): Plugin {
  const publicDir = resolve(import.meta.dirname, "public");
  const target = resolve(publicDir, "pdfium.wasm");

  return {
    name: "copy-pdfium-wasm",
    buildStart() {
      if (existsSync(target)) return;
      const source = fileURLToPath(import.meta.resolve("@embedpdf/pdfium/pdfium.wasm"));
      copyFileSync(source, target);
    },
  };
}

export default defineConfig({
  envDir: "../../",
  define: {
    "import.meta.url": JSON.stringify("file:///worker.js"),
  },
  plugins: [
    copyPdfiumWasm(),
    {
      name: "fix-cloudflare-create-require",
      renderChunk(code) {
        if (code.includes("createRequire(import.meta.url)")) {
          return code.replaceAll(
            "createRequire(import.meta.url)",
            'createRequire("file:///worker.js")',
          );
        }
        return null;
      },
    },
    cloudflare({ viteEnvironment: { name: "ssr" } }),
    tanstackStart(),
    viteReact(),
    tailwindcss(),
    mdx(),
  ],
  build: {
    rolldownOptions: {
      external: ["cloudflare:workers"],
    },
  },
  ssr: {
    noExternal: true,
    external: ["cloudflare:workers"],
  },
  server: {
    proxy: {
      "/api": {
        target: "http://127.0.0.1:8787",
        changeOrigin: true,
      },
    },
  },
  resolve: {
    dedupe: ["react", "react-dom"],
    alias: {
      "@": "/src",
    },
    tsconfigPaths: true,
  },
});
